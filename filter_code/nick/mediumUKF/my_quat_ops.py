# -*- coding: utf-8 -*-
"""
Created on Tue Oct 31 22:39:07 2017

@author: Nicholas
"""
import numpy as np
#inputs must be arrays
def multiply(q,p):
    #inputs and outputs can be either cols or rows
    qs,qv,ps,pv = q[0],q[1:4],p[0],p[1:4]
    rs = qs*ps - qv.T.dot(pv)
    rv = qs*pv + ps*qv + np.cross(qv, pv)
    return np.hstack((rs,rv))

def norm(q):
    qs, qv = q[0], q[1:4]
    return np.sqrt(qs**2 + qv.T.dot(qv))
    
def inverse(q):
    return np.hstack((q[0], -q[1:4]))/norm(q)**2

def log(q):
    qs, qv = q[0], q[1:4]
    rs = np.log(norm(q))
    qv_norm = np.linalg.norm(qv)
    rv = qv/qv_norm*np.arccos(qs/norm(q))
    return np.hstack((rs,rv)) 

def exp(q):
    qs, qv = q[0], q[1:4]
    qv_norm = np.sqrt(np.sum(np.square(qv)))
    rs = np.exp(qs) *np.cos(qv_norm)
    rv = np.exp(qs) *qv/qv_norm *np.sin(qv_norm)
    return np.hstack((rs,rv))

def rotate(x,q):
    r =  multiply( q, multiply( np.hstack((0,x)), inverse(q) ) )
    return r[1:4]

my_ans = log(np.array((1,2,3,4)))

