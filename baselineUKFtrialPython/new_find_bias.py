# -*- coding: utf-8 -*-
"""
Spyder Editor

loads in raw imu and vic data.
orders and corrects it, finds and removes both biases
plots final results 

use my_load_data to adjust which dataset
uses my_rotplot to show the 3d orientations

results are in data_imu
"""
import copy
import numpy as np
import matplotlib.pyplot as plt
#import mpl_toolkits.mplot3d as a3
import my_rotplot as my_rots
import euler_short as euler
#%% Get data in order 
my_imud = copy.deepcopy(imud)
my_vicd = copy.deepcopy(vicd)

t_vic = np.array(my_vicd["ts"])
data_vic = np.array(my_vicd["rots"].astype(float)) #data_vic[:,:,i] is the ith rotation matrix

t_imu = np.array(my_imud["ts"])

data_imu = np.array(my_imud["vals"].astype(int) )
data_imu[0:2] *= -1 #fix Ax and Ay
data_imu = np.vstack((data_imu, data_imu[3,:]))
data_imu = data_imu[[0,1,2,4,5,6],:].astype(float) #data_imu is 6xN, contains A and R in rows in order

#%% convert to normal units

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

#%% plotting raw 
data_imu[0:3] = (data_imu[0:3] - b_A)*m_total_A
data_imu[3:6] = (data_imu[3:6] - b_omega)*m_total_omega

baseline = my_rots.rotplot(np.eye(3))
baseline.set_title('baseline')

#%% finding  b_A 
#adjust stationary_end appropriately from looking at graphs

stationary_end = 50
#checking accel readings
A_true = np.zeros((data_vic.shape[0],data_vic.shape[2]))
A_err = np.zeros((data_vic.shape[0],data_vic.shape[2]))
g = np.array([0,0,1])

for i_vic in range(0,data_vic.shape[2],1):    
    
    #find corresponding data sample in imu data
    i_imu = abs((t_imu[0,:]-t_vic[0,i_vic])).argmin()    
    
    A_true[:,i_vic] = g.dot(data_vic[:,:,i_vic])
    A_imu = data_imu[0:3,i_imu]
    A_err[:,i_vic] = A_true[:,i_vic] - A_imu
"""    
    if np.mod(i_vic,20) == 0:
        my_plot = rotplot(data_vic[:,:,i_vic])
        my_plot.set_title('i_vic = '+ str(i_vic) + '/' + str(data_vic.shape[2]))
        plt.show()
        print('A_true: '  + str(A_true[:,i_vic]))
        print('A_imu: '  + str(A_imu))
        print('A_err: ' + str(A_err[:,i_vic]))
        raw_input("Press Enter to continue...")    
    
"""
labels = ['x','y','z']   
plt.figure(1) 
for i in range(3):
    plt.subplot(3,1,i+1)
    plt.plot(t_vic.T, A_true[i,:], t_vic.T, A_err[i,:])
    plt.ylabel(labels[i])
plt.title('with b_A = 0')
plt.show()

b_A = -A_err[:,0:stationary_end].mean(axis = 1)/m_total_A.T #result: array([[ -511.12518163,  -500.38490781, 509.86888223]])

#%% plotting A with no error 

#reinitializing raw data
data_imu = np.array(my_imud["vals"].astype(int) )
data_imu[0:2] *= -1
data_imu = np.vstack((data_imu, data_imu[3,:]))
data_imu = data_imu[[0,1,2,4,5,6],:].astype(float) #data_imu is 6xN, contains A and R in rows in order

#now with b_A set
data_imu[0:3] = (data_imu[0:3] - b_A.T)*m_total_A
data_imu[3:6] = (data_imu[3:6] - b_omega)*m_total_omega

#error is centered at 0
A_true = np.zeros((data_vic.shape[0],data_vic.shape[2]))
A_err = np.zeros((data_vic.shape[0],data_vic.shape[2]))
g = np.array([0,0,1])

for i_vic in range(0,data_vic.shape[2],1):    
    
    #find corresponding data sample in imu data
    i_imu = abs((t_imu[0,:]-t_vic[0,i_vic])).argmin()    
    
    A_true[:,i_vic] = g.dot(data_vic[:,:,i_vic])
    A_imu = data_imu[0:3,i_imu]
    A_err[:,i_vic] = A_true[:,i_vic] - A_imu
    """
    my_plot = rotplot(data_vic[:,:,i_vic])
    my_plot.set_title('i_vic = '+ str(i_vic) + '/' + str(data_vic.shape[2]))
    plt.show()
    print('A_true: '  + str(A_true[:,i_vic]))
    print('A_imu: '  + str(A_imu))
    print('A_err: ' + str(A_err[:,i_vic]))
    raw_input("Press Enter to continue...")    
    """

plt.figure(2)
for i in range(3):
    plt.subplot(3,1,i+1)
    plt.plot(t_vic.T, A_true[i,:], t_vic.T, A_err[i,:])
    plt.ylabel(labels[i])
print('b_A = ' + str(b_A))
plt.show()


#%% looking for b_omega
plt.figure(3)
for i in range(3):
    plt.plot(range(A_true.shape[1]), A_true[i,:])
    
plt.grid(True)
plt.show()

b_omega = data_imu[3:6,0:stationary_end].mean(axis = 1)/m_total_omega.T # result: array([[ 373.63428571,  375.37571429,  369.65428571]])


#%% final data with bias accounted for 

b_A = np.array([[ -511.72518163,  -500.48490781, 512.16888223]])
b_omega = np.array([[ 373.58,  375.52,  369.72]])

print('b_A: ' + str(b_A))
print('b_omega: ' + str(b_omega))

#reinitializing raw data
data_imu = np.array(my_imud["vals"].astype(int) )
data_imu[0:2] *= -1
data_imu = np.vstack((data_imu, data_imu[3,:]))
data_imu = data_imu[[0,1,2,4,5,6],:].astype(float) #data_imu is 6xN, contains A and R in rows in order

#now with b_A set
data_imu[0:3] = (data_imu[0:3] - b_A.T)*m_total_A
data_imu[3:6] = (data_imu[3:6] - b_omega.T)*m_total_omega

plt.figure(4)
lA = [[0],[0],[0]]
for i in range(3):
    lA[i], = plt.plot(range(data_imu.shape[1]), data_imu[i,:])
    
plt.grid(True)
plt.legend((lA[0], lA[1],lA[2]), ('Ax','Ay','Az'))
plt.xlabel('sample number')
plt.ylabel('g')
plt.title('processed accel data, dataset #' + str(dataset))
plt.show()

plt.figure(5)
lW = [[0],[0],[0]]
for i in range(3,6):
    lW[i-3], = plt.plot(range(data_imu.shape[1]), data_imu[i,:])
    
plt.grid(True)
plt.legend((lW[0], lW[1],lW[2]), ('wx','wy','wz'))
plt.xlabel('sample number')
plt.ylabel('rad/sec')
plt.title('processed gyro data, dataset #' + str(dataset))
plt.show()

