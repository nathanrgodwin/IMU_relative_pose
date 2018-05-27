# -*- coding: utf-8 -*-
"""
Created on Sat Nov 04 17:14:38 2017

@author: Nicholas
"""

#finding mean and covariance of sigma points 

import numpy as np
import my_quat_ops as quat
import my_conversions as rbm_conv

def gen_sigma_points(mu, P, Q):
    #given 3x3 covariance matrix P for w and process noise Q, generates 2n 3x1 sigma points in Wi. 
    #then converts to quats. then applies the mean mu which is a quat, to end 
    #with 2n+1 quaternions in Xi. the first one is the mean 
    n = P.shape[0]
    
    P_total = P + Q
    
    S = np.array(np.linalg.cholesky(P_total).T)
    
    W_plus = np.zeros((n,n)) 
    W_minus = np.zeros((n,n))  
    
    for i in range(n):
        W_plus[:,i] = np.sqrt(n)*S[:,i]
        W_minus[:,i] = -np.sqrt(n)*S[:,i]
    W = np.hstack((W_plus,W_minus))    
    
    X = np.zeros((n+1,2*n+1))
    X[:,0] = mu
    
    for i in range(W.shape[1]):
        X[:,i+1] = rbm_conv.w2q_exp(W[:,i])
        X[:,i+1] = quat.multiply(mu,X[:,i+1])
    
    return X

def mean_covar_quat(quats, alpha_mu, alpha_cov, mu_quats):
    #finds the mean and cov of quaternion sigma points
    
    #quats has n columns of quat sigma points. the first element is the mean after transformation
    #alpha is the weight on the mean (for now, .5)
    #mu_quats contains the first guess
    
    n_quats = quats.shape[1]
    n = 3
    quat_err = np.ones((4,n_quats))
    w_err = np.ones((3,n_quats))
    w_err_mean = np.ones((3,1))
    err_norm_min = .0001
    maxT = 1000

    for t in range(maxT):
        #mu_quats_conj = np.hstack((mu_quats[0],-mu_quats[1:4]))
        for i in range(n_quats):
            #find the error quaternion
            quat_err[:,i] = quat.multiply(quat.inverse(mu_quats),quats[:,i]) 
            #convert it to angle 
            w_err[:,i] = rbm_conv.q2w_log(quat_err[:,i])
            #restrict the angle -pi to pi
            if np.isnan(np.linalg.norm(w_err[:,i])):
                print('is nan')
                w_err[:,i] = np.zeros(3)
                #input('press enter to continue')
            elif np.linalg.norm(w_err[:,i]) == 0:
                print('is zero')
                w_err[:,i] = np.zeros(3)
                #input('press enter to continue')
            else:
                w_err[:,i] = (-np.pi + np.mod(np.linalg.norm(w_err[:,i]) + np.pi,2*np.pi))*w_err[:,i]/np.linalg.norm(w_err[:,i])
        #compute weighted mean
        w_err_mean = np.sum(w_err[:,1:],axis = 1)/(2.0*n) + alpha_mu*w_err[:,0]
        #go back to quaternion
        mu_quats = quat.multiply(mu_quats,rbm_conv.w2q_exp(w_err_mean))
        
        if np.linalg.norm(w_err_mean) < err_norm_min:
            #compute covariance
            covar = np.zeros((3,3)) 
            for i in range(1,n_quats):
                A = np.asmatrix(w_err[:,i]).T
                covar += A*A.T             
            covar = covar/(2.0*n)
            A = np.asmatrix(w_err[:,0]).T
            covar = covar + alpha_cov*A*A.T
                      
            return mu_quats,covar,w_err

def mean_covar_vect(Z,alpha_mu, alpha_cov):
    
    n_vects = Z.shape[1]
    n = Z.shape[0]
    z_mean = alpha_mu*Z[:,0] + np.sum(Z[:,1:-1],axis = 1)/(2.0*n)
    
    covar = np.zeros((n,n)) 
    for i in range(1,n_vects):
        A = np.asmatrix(Z[:,i]-z_mean).T
        covar = covar + A*A.T             
    covar = covar/(2.0*n)
    
    A = np.asmatrix(Z[:,0]-z_mean).T
    covar = covar + alpha_cov*A*A.T
              
    return z_mean, covar
        
def P_XZ(W,Z,alpha_mu, alpha_cov ): # in vector space 
    #W and Z are matrices with 2n+1 columns of points in vector space, 1st point is the mean
    n_vects = Z.shape[1]
    n = Z.shape[0]
    z_mean = alpha_mu*Z[:,0] + np.sum(Z[:,1:-1],axis = 1)/(2.0*n)
    
    Pxz = np.zeros((n,n)) 
    for i in range(1,n_vects):
        A = np.asmatrix(W[:,i]).T
        B = np.asmatrix(Z[:,i]-z_mean).T
        Pxz = Pxz + A*B.T             
    Pxz = Pxz/(2.0*n)
    
    A = np.asmatrix(W[:,0]).T
    B = np.asmatrix(Z[:,0]-z_mean).T
    Pxz = Pxz + alpha_cov*A*B.T
              
    return Pxz

#%%examples
thetas = np.array([170,270,101,120, 250,100, 100])
rads = thetas*np.pi/180
xi = np.array([[1,0,0],
               [1,0,0],
               [1,0,0],
               [1,0,0],
               [1,0,0],
               [1,0,0],
               [1,0,0]])
xi = xi.T    
w = rads*xi
quats = np.zeros((4,7))
for i in range(7):
    quats[:,i] = rbm_conv.w2q_exp(w[:,i])
alpha_mu = 0.0
alpha_cov = 2.0
mu_guess_w = 200*np.pi/180*np.array([1,0,0])    
mu_guess_quats = rbm_conv.w2q_exp(mu_guess_w)
mu_try, cov_try, _ = mean_covar_quat(quats,alpha_mu, alpha_cov, mu_guess_quats)

mu_try_w = rbm_conv.q2w_log(mu_try)

#print(mu_try_w)
#print(cov_try)

Q = .001*np.eye(3)
X_try = gen_sigma_points(mu_try,cov_try,Q)

#W = 
#Z = 
#my_P_xz = P_XZ(W,Z,1.0/7)
