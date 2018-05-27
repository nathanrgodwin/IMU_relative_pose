# -*- coding: utf-8 -*-
"""
Created on Fri Nov 10 14:54:58 2017

@author: Nicholas
"""

import numpy as np
import my_conversions as rbm_conv
import cv2
import euler_short as euler
import matplotlib as plt

#camd['cam'][:,:,:,i] is the 240x320x3 image at timestep i

my_ans = camd['cam'][:,:,0,0]
v_size = camd['cam'][:,:,0,0].shape[1] # 320
u_size = camd['cam'][:,:,0,0].shape[0] # 240

orig_v, orig_u = np.meshgrid(range(v_size), range(u_size))
orig_uv = np.vstack((orig_u.reshape((u_size*v_size)),orig_v.reshape((u_size*v_size)))).T

fov_w = 60.0*np.pi/180
fov_h = 45.0*np.pi/180

v = np.hstack((range(-v_size/2,0), range(1,v_size/2+1)))
u = np.hstack((range(-u_size/2,0), range(1,u_size/2+1)))

longit = v*fov_w/v_size
latit = -u*fov_h/u_size

longit_g, latit_g = np.meshgrid(longit, latit)
longit_latit = np.vstack((longit_g.reshape(u_size*v_size),latit_g.reshape(u_size*v_size))).T

cam_xyz = np.zeros((u_size*v_size,4)) # last column is used for later
r = 1
cam_xyz[:,0] = r*np.cos(longit_latit[:,0])*np.cos(longit_latit[:,1])
cam_xyz[:,1] = -r*np.sin(longit_latit[:,0])*np.cos(longit_latit[:,1])
cam_xyz[:,2] = r*np.sin(longit_latit[:,1])
cam_xyz = cam_xyz.T

#p_cam = np.matrix([0,0,.1]).T
p_cam = np.matrix([0,0,0]).T

world_xyz = np.zeros((u_size*v_size,3))
world_longit_latit = np.zeros((u_size*v_size,2))
uv_p = np.zeros((u_size*v_size,2))

u_size_p = u_size*4
v_size_p = v_size*6

final_pano = np.zeros((u_size_p,v_size_p,3))
occurences = np.zeros((u_size_p,v_size_p))
#%%
for t_cam in range(0,camd['ts'].shape[1],1):
    #find correct timestamp in x_hat
    i_ukf = abs((t_imu[0,:]-camd['ts'][0,t_cam])).argmin()
    
    #convert to w
    w = rbm_conv.q2w_log(x_hat[:,i_ukf])
    
    #normalize
    w = (-np.pi + np.mod(np.linalg.norm(w) + np.pi,2*np.pi))*w/np.linalg.norm(w)
    
    #convert to R
    R = np.matrix(rbm_conv.w2R_exp(w))
    #R = data_vic[:,:,i_ukf].T
    
    #transformation matrix at the correct time
    R_SE3 = np.vstack((np.hstack((R,p_cam)), np.matrix([0,0,0,1]))) 
    
    #transform cam_xyz to world_xyz, then world spherical, then world flat    

    world_xyz = R_SE3.dot(cam_xyz)[0:3,:].T
    
    world_longit_latit[:,0] = np.array(np.arctan2(-world_xyz[:,1],world_xyz[:,0]).T)
    world_longit_latit[:,1] = np.array(np.arctan2(world_xyz[:,2],np.sqrt(np.square(world_xyz[:,0]) + np.square(world_xyz[:,1]))).T)

    uv_p[:,0] = -u_size_p/(np.pi)*world_longit_latit[:,1] + u_size_p/2
    uv_p[:,1] = v_size_p/(2*np.pi)*world_longit_latit[:,0] + v_size_p/2
    
    current_pano = np.zeros((u_size_p,v_size_p,3))
    for i_pixel in range(u_size*v_size):
        i_pano = uv_p[i_pixel,0].astype(int)
        j_pano = uv_p[i_pixel,1].astype(int)            
        if i_pano < u_size_p and i_pano >= 0 and j_pano < v_size_p and j_pano >= 0:
            if occurences[i_pano,j_pano] < 1:
                current_pano[i_pano,j_pano,:] = camd['cam'][orig_uv[i_pixel,0],orig_uv[i_pixel,1],:,t_cam]
                final_pano[i_pano,j_pano,:] = camd['cam'][orig_uv[i_pixel,0],orig_uv[i_pixel,1],:,t_cam]
                occurences[i_pano,j_pano] += 1
            
    print('timestamp # '+str(t_cam) + '/' + str(camd['ts'].shape[1]))
    print('euler angles xyz [deg] '+str(180/np.pi*euler.quat2euler(x_hat[:,i_ukf])[0]) + ' ' + str(180/np.pi*euler.quat2euler(x_hat[:,i_ukf])[1]) + ' ' + str(180/np.pi*euler.quat2euler(x_hat[:,i_ukf])[2]))

    final_pano = np.uint8(final_pano)
    
    #plt.imshow(camd['cam'][:,:,:,t_cam])
    #plt.imshow(np.uint8(current_pano))
    
    #cv2.imshow(str(t_cam)+': '+str(180/np.pi*euler.quat2euler(x_hat[:,i_ukf])[0]) + ' ' + str(180/np.pi*euler.quat2euler(x_hat[:,i_ukf])[1]) + ' ' + str(180/np.pi*euler.quat2euler(x_hat[:,i_ukf])[2]), np.uint8(current_pano))
    #cv2.waitKey(0)
    #cv2.destroyAllWindows()

plt.pyplot.imshow(final_pano)






    