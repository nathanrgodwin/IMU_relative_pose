function [ mv ] = measurement_model( sv )
%measurement_model Summary of this function goes here
%   input -- state vector
%   output -- measurement vector
ss = vector2state(sv);
ms = new_meas();

dt = 1;
g = 9.8;

%ms.AIm
    IAI = unquat(quatproduct(quatproduct(quatinv(ss.GRI), [0; (ss.GVI_0-ss.GVI_1)./dt]), ss.GRI))   ...
        + cross(ss.GW, (quatproduct(quatproduct(quatinv(ss.GRI), ss.GVI_0), ss.GRI)));
ms.AIm = IAI + unquat(quatproduct(quatproduct(quatinv(ss.GRI), [0; 0; 0; -g]), ss.GRI));

%ms.AJm
    COMP_ROT = quatproduct(quatinv(ss.IRJ),quatinv(ss.GRI));    %composite rotation
    JAJ = quatproduct(quatproduct(COMP_ROT, ss.GAI + cross(ss.GW, cross(ss.GW, ss.IPJ)) ), quatinv(COMP_ROT));
ms.AJm = unquat(    ...
        JAJ ...
        + quatproduct(quatproduct(COMP_ROT, [0; 0; 0; -g]), quatinv(COMP_ROT))  ...
            );
%ms.IWI
ms.IWI = unquat(    ...
        [0; ss.GW]
        
        );




end

