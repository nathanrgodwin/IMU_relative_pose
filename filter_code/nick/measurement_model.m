function [ mv ] = measurement_model( sv )
%measurement_model Summary of this function goes here
%   input -- state vector
%   output -- measurement vector
ss = vector2state(sv);
ms = new_meas();

dt = 1;
g = 9.8;


GAI = (ss.GVI_0-ss.GVI_1)./dt;
%ms.AIm
    IAI = unquat(quatproduct(quatproduct(quatinv(ss.GRI), [0; GAI]), ss.GRI))   ...
        + cross(ss.GW, unquat(quatproduct(quatproduct(quatinv(ss.GRI), [0; ss.GVI_0]), ss.GRI)));
ms.AIm = IAI + unquat(quatproduct(quatproduct(quatinv(ss.GRI), [0; 0; 0; -g]), ss.GRI));

%ms.AJm
    COMP_ROT = quatproduct(quatinv(ss.IRJ),quatinv(ss.GRI));    %composite rotation
    JAJ = unquat(quatproduct(quatproduct(COMP_ROT, [0;GAI + cross(ss.GW, cross(ss.GW, ss.IPJ))] ), quatinv(COMP_ROT)));
ms.AJm = JAJ + unquat(quatproduct(quatproduct(COMP_ROT, [0; 0; 0; -g]), quatinv(COMP_ROT)));

%ms.IWI
ms.IWI = unquat(quatproduct(quatproduct(quatinv(ss.GRI), [0; ss.GW]), ss.GRI));

%ms.JWJ
ms.JWJ = unquat(quatproduct(quatproduct(COMP_ROT, [0; ss.GW]), quatinv(COMP_ROT)));

%
qGRI = ss.GRI;
qGRJ = quatproduct(ss.GRI, ss.IRJ);

ms.GRI = quat2aa(qGRI);
ms.GRJ = quat2aa(qGRJ);

mv = meas2vector(ms);
end

