function [ mv ] = measurement_model(sv,G_w,G_alpha, GRI)
%measurement_model Summary of this function goes here
%   input -- state vector
%   output -- measurement vector

ss = vector2state(sv);
ms = new_meas();
g_quat = [0;0;0;1];%gravity vector, units of g

%aim
tempg = quatproduct(g_quat,GRI);
W_g_quat_I = quatproduct([GRI(1);-GRI(2:4)],tempg);
ms.AIm = W_g_quat_I(2:4);
    
        % %GAI = (ss.GVI_0-ss.GVI_1)./dt;
        % %ms.AIm
        % %    IAI = unquat(quatproduct(quatproduct(quatinv(ss.GRI), [0; GAI]), ss.GRI))   ...
        % %        + cross(ss.GW, unquat(quatproduct(quatproduct(quatinv(ss.GRI), [0; ss.GVI_0]), ss.GRI)));
        %     IAI = cross(ss.GW, unquat(quatproduct(quatproduct(quatinv(ss.GRI), [0; ss.GVI_0]), ss.GRI)));   %version without accel
        % ms.AIm = IAI + unquat(quatproduct(quatproduct(quatinv(ss.GRI), [0; 0; 0; -g]), ss.GRI));

%ajm
%rotates g result further
tempg = quatproduct(W_g_quat_I,ss.IRJ);
W_g_quat_J = quatproduct([ss.IRJ(1);-ss.IRJ(2:4)],tempg);
ajm_G = W_g_quat_J(2:4);

%computes terms, then rotates twice
rot_terms =  cross(G_w,cross(G_w,ss.IPJ))+cross(G_alpha,ss.IPJ);

temp = quatproduct([0;rot_terms],GRI);
IAJ_quat = quatproduct([GRI(1);-GRI(2:4)],temp);

temp = quatproduct(IAJ_quat,ss.IRJ);
JAJ_quat = quatproduct([ss.IRJ(1);-ss.IRJ(2:4)],temp);
ms.AJm = ajm_G + JAJ_quat(2:4);

        % %ms.AJm
        % COMP_ROT = quatproduct(quatinv(ss.IRJ),quatinv(GRI));    %composite rotation
        % %    JAJ = unquat(quatproduct(quatproduct(COMP_ROT, [0;GAI + cross(ss.GW, cross(ss.GW, ss.IPJ))] ), quatinv(COMP_ROT)));
        % 
        %     JAJ = unquat(quatproduct(quatproduct(COMP_ROT, [0; cross(G_w, cross(G_w, ss.IPJ))] ), quatinv(COMP_ROT)));  %version without accel 
        % ms.AJm = JAJ + unquat(quatproduct(quatproduct(COMP_ROT, g_quat), quatinv(COMP_ROT)));

%ms.IWI
ms.IWI = unquat(quatproduct(quatinv(GRI), quatproduct([0; G_w], GRI)));

%ms.JWJ
ms.JWJ = unquat(quatproduct(quatinv(ss.IRJ), quatproduct([0; ms.IWI], ss.IRJ)));

% %
% qGRI = ss.GRI;
% qGRJ = quatproduct(ss.GRI, ss.IRJ);
% 
% ms.GRI = quat2aa(qGRI);
% ms.GRJ = quat2aa(qGRJ);

mv = meas2vector(ms);
end

