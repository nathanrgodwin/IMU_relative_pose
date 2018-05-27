# -*- coding: utf-8 -*-
"""
Created on Tue Oct 31 21:55:36 2017

@author: Nicholas
"""
import numpy as np
import my_quat_ops as quat
import my_conversions as rbm_conv
import my_sigma_points as spoints
import euler_short as euler
import matplotlib.pyplot as plt

data_A = data_imu[0:3,:]
data_omega = data_imu[3:6,:]

#saving data elsewhere
#np.savetxt("data_imu.csv", data_imu, delimiter=",")
#np.savetxt("t_imu.csv", t_imu, delimiter=",")

#attempting to use other data
#data_imu = np.genfromtxt('my_file.csv', delimiter=',')
#t_imu = 
#%% UKF

Q = .001*np.eye(3)  #.002 .05 . even better: .001 and .01
R = .01*np.eye(3) 

g_quat = np.array([0, 0, 0, 1])

#old weights
#alpha_mu = 1/2.0 #1/2.0 #weighting for mean
#alpha_cov = 1/2.0

alpha_mu = 0 #1/2.0 #weighting for mean
alpha_cov = 2.0

n_steps = t_imu.shape[1]

x_hat = np.zeros((4,n_steps))
x_hat[:,0] = np.array([1,0,0,0]) 
P_hat = np.zeros((3,3,n_steps))
P_hat[:,:,0] = .0001*np.eye(3)

x_ap = np.zeros((4,n_steps))
P_ap = np.zeros((3,3,n_steps))
z_ap = np.zeros((3,n_steps))
P_zz = np.zeros((3,3,n_steps))

nu = np.zeros((3,n_steps))
P_nu = np.zeros((3,3,n_steps))

P_xz = np.zeros((3,3,n_steps))

K = np.zeros((3,3,n_steps)) 

X = np.zeros((4,7)) # ~ sigma points for x_hat[i]
Y = np.zeros((4,7)) # ~ sigma points for x_ap[i+1]
Z = np.zeros((3,7)) # ~ sigma points for z_ap[i+1]

update = True

for i_ukf in range(data_imu.shape[1]-1): #for every sample in data_imu 
    
    dt = t_imu[0,i_ukf+1] - t_imu[0,i_ukf]
    
    #prediction step
    
    #describe x_hat in sigma points    
    X = spoints.gen_sigma_points(x_hat[:,i_ukf],P_hat[:,:,i_ukf],Q)
    
    #propogate sigma points through process model A
    for i_spoints in range(X.shape[1]):
        Y[:,i_spoints] = quat.multiply(X[:,i_spoints], rbm_conv.w2q_exp(data_omega[:,i_ukf]*dt))
    
    #determine a priori estimates by analyzing sigma points
    #breaks when guess is 0
    #w_prime is 3x7 matrix containing deviations of each sigma point from mean in vector space
    x_ap[:,i_ukf+1],P_ap[:,:,i_ukf+1],W_prime = spoints.mean_covar_quat(Y,alpha_mu, alpha_cov,x_hat[:,i_ukf])
    
    x_hat[:,i_ukf+1] = x_ap[:,i_ukf+1]#remove this after update step works 
    P_hat[:,:,i_ukf+1] = P_ap[:,:,i_ukf+1]
    if update:
        #update step
        
        #propogate sigma points of x_ap through measurement model H
        for i_spoints in range(X.shape[1]):
            Z[:,i_spoints] = quat.multiply( np.hstack((Y[0,i_spoints],-Y[1:4,i_spoints])), quat.multiply(g_quat,Y[:,i_spoints]))[1:4]
        
        #find z_ap and P_zz from Z.
        z_ap[:,i_ukf+1], P_zz[:,:,i_ukf+1] = spoints.mean_covar_vect(Z,alpha_mu, alpha_cov)    
        nu[:,i_ukf+1] = data_A[:,i_ukf+1] - z_ap[:,i_ukf+1]
        P_nu[:,:,i_ukf+1] = P_zz[:,:,i_ukf+1] + R   
        P_xz[:,:,i_ukf+1] = spoints.P_XZ(W_prime, Z, alpha_mu, alpha_cov) 
        K[:,:,i_ukf+1] = P_xz[:,:,i_ukf+1].dot(np.linalg.inv(P_nu[:,:,i_ukf+1]))
        
        x_hat[:,i_ukf+1] = quat.multiply(x_ap[:,i_ukf+1],rbm_conv.w2q_exp(K[:,:,i_ukf+1].dot(nu[:,i_ukf+1])))
        P_hat[:,:,i_ukf+1] = P_ap[:,:,i_ukf+1] - K[:,:,i_ukf+1].dot(P_nu[:,:,i_ukf+1].dot(K[:,:,i_ukf+1].T))
        
    print('timestep = ' + str(i_ukf+1) + '/' +str(data_imu.shape[1]-1))