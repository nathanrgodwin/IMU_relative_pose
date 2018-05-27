# -*- coding: utf-8 -*-
"""
Created on Sat Nov 04 15:38:39 2017

@author: Nicholas
"""
import numpy as np
import my_quat_ops as my_quat

#tested to work forwards and backwards to a scaling factor 

def w2q_exp(w): 
    w = w.astype(float)
    # slide 11
    #theta = np.linalg.norm(w)
    #xi = w/np.linalg.norm(w)
    #return np.hstack((np.cos(theta/2), np.sin(theta/2)*xi))
    
    #slide #13 exp
    return my_quat.exp(np.hstack((0,w/2)))

def q2w_log(q):
    q = q.astype(float)
    #slide 13 log 
    w = (2*my_quat.log(q))[1:4]
    return w
    #return (-np.pi + np.mod(np.linalg.norm(w) + np.pi,2*np.pi))*w/np.linalg.norm(w)
    
def w2R_exp(w): # rodrigues (exp map) slide 20
    w = w.astype(float)
    theta = np.linalg.norm(w)
    w_hat = np.array([[ 0,   -w[2], w[1]],
                      [ w[2], 0,  -w[0]],
                      [-w[1], w[0],   0]])
    return np.eye(3) + np.sin(theta)/theta *w_hat + (1 - np.cos(theta))/theta**2 * w_hat.dot(w_hat) 

def R2w_log(R): # log map slide 21
    R = R.astype(float)
    theta = np.arccos((np.matrix.trace(R)-1)/2)
    w_hat = theta/(2*np.sin(theta)) * (R - R.T)
    return np.hstack((w_hat[2,1], w_hat[0,2], w_hat[1,0]))

w = np.array((-1,2,30))

q = w2q_exp(w)
w_new = q2w_log(q)
w_rat = w/w_new
#print(w_rat)

q = np.array((-1,2,-10,-5))

w = q2w_log(q)
q_new = w2q_exp(w)
q_rat = q/q_new
#print(q_rat)

"""
R = w2R_exp(w)
w_new = R2w_log(R)
w_rat = w/w_new
"""