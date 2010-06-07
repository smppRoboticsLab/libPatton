% ************** MATLAB "M" functionn (jim Patton) *************
% JACOBIAN.M  [jac] = jacobian(phi,L)
%             where phi is a [2x1] instance of the joint angles.
%  SYNTAX:     
%  REVISIONS:  INITATED 4/26/99 by patton from conditt's jacobian.m
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [jac] = jacobian(phi,L)

jac = [-L(1) * sin(phi(1)) - L(2) * sin(phi(1) + phi(2))   -L(2) * sin(phi(1) + phi(2));
        L(1) * cos(phi(1)) + L(2) * cos(phi(1) + phi(2))    L(2) * cos(phi(1) + phi(2))];
      
