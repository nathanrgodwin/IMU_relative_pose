# -*- coding: utf-8 -*-
"""
Created on Tue Nov 14 23:03:28 2017


Plot comparisons of euler angles

@author: Nicholas
"""

import numpy as np
import my_quat_ops as quat
import my_conversions as rbm_conv
import euler_short as euler
import matplotlib.pyplot as plt



#vicon
data_vic_euler = np.ones((3,data_vic.shape[2]))
for i in range(data_vic.shape[2]):
    data_vic_euler[:,i] = euler.mat2euler(data_vic[:,:,i])

#integrate omega measurements
data_imu_euler = np.ones((3,data_imu.shape[1]))
data_imu_quat = np.ones((4,data_imu.shape[1]))
data_imu_quat[:,0] = np.array([1,0,0,0])
data_imu_euler[:,0] = euler.quat2euler(data_imu_quat[:,0])
for i in range(data_imu.shape[1]-1):
    dt = t_imu[0,i+1] - t_imu[0,i]
    data_imu_quat[:,i+1] = quat.multiply(data_imu_quat[:,i],rbm_conv.w2q_exp(data_omega[:,i]*dt))
    data_imu_euler[:,i+1] = euler.quat2euler(data_imu_quat[:,i+1])
    
#using UKF (with or without update step)
data_imu_UKF_euler =  np.ones((3,data_imu.shape[1]))
for i in range(data_imu.shape[1]):
    data_imu_UKF_euler[:,i] = euler.quat2euler(x_hat[:,i])    
    
labels1 = ['roll(x)','pitch(y)','yaw(z)']

plt.figure(1)

lA = [[0],[0],[0]]
for i in range(3):
    plt.subplot(3,1,i+1)
    lA[0], lA[1], lA[2] = plt.plot(t_vic.T, data_vic_euler[i,:], t_imu.T, data_imu_euler[i,:],t_imu.T, data_imu_UKF_euler[i,:],'r')
    plt.ylabel(labels1[i])
plt.legend((lA[0], lA[1], lA[2]), ('vicon','imu integrate', 'UKF'))

plt.subplot(3,1,1)
if update:
    plt.title('UKF with update, dataset # ' +str(dataset)) 
else:
    plt.title('UKF predict only, dataset # ' +str(dataset))  

plt.show()