# -*- coding: utf-8 -*-
"""
Spyder Editor

loads in raw imu data
orders and corrects it, finds and removes both biases
plots final results 

use my_load_data to adjust which dataset

results are in data_imu
"""
import copy
import numpy as np
import matplotlib.pyplot as plt
import my_rotplot as my_rots
import euler_short as euler
#%% Get data in order 
my_imud = copy.deepcopy(imud)
t_imu = np.array(my_imud["ts"])
data_imu = np.array(my_imud["vals"].astype(int) )
data_imu[0:2] *= -1 #fix Ax and Ay
data_imu = np.vstack((data_imu, data_imu[3,:]))
data_imu = data_imu[[0,1,2,4,5,6],:].astype(float) #data_imu is 6xN, contains A and R in rows in order

#%% conversions to normal units

# formulas to convert bits to real units
# omega [rad/s] = (raw - b_omega)*3300/1023   /m_omega/m_fudge_omega   *pi/180
# A [g] = (raw - b_A)*3300/1023    /m_A/m_fudge_A 

m_A = 300.0 #mV/g from datasheet
m_omega = 3.33 #mV/(degree/sec) from datasheet

m_fudge_A = np.ones((3,1))
m_fudge_omega = np.ones((3,1))

m_total_A = 3300.0/1023.0/m_A/m_fudge_A
m_total_omega = 3300.0/1023.0/m_omega/m_fudge_omega*np.pi/180 

b_A = np.zeros((3,1))
b_omega = np.zeros((3,1))


#%% final data with bias accounted for 

#determined from find_bias
b_A = np.array([[ -511.72518163,  -500.48490781, 512.16888223]])
b_omega = np.array([[ 373.58,  375.52,  369.72]])

print('b_A: ' + str(b_A))
print('b_omega: ' + str(b_omega))

data_imu[0:3] = (data_imu[0:3] - b_A.T)*m_total_A
data_imu[3:6] = (data_imu[3:6] - b_omega.T)*m_total_omega

plt.figure(1)
lA = [[0],[0],[0]]
for i in range(3):
    lA[i], = plt.plot(range(data_imu.shape[1]), data_imu[i,:])
    
plt.grid(True)
plt.legend((lA[0], lA[1],lA[2]), ('Ax','Ay','Az'))
plt.xlabel('sample number')
plt.ylabel('g')
plt.title('processed accel data, dataset #' + str(dataset))
plt.show()

plt.show()

plt.figure(2)
lW = [[0],[0],[0]]
for i in range(3,6):
    lW[i-3], = plt.plot(range(data_imu.shape[1]), data_imu[i,:])
    
plt.grid(True)
plt.legend((lW[0], lW[1],lW[2]), ('wx','wy','wz'))
plt.xlabel('sample number')
plt.ylabel('rad/sec')
plt.title('processed gyro data, dataset #' + str(dataset))
plt.show()
plt.show()

