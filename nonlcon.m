function [c, ceq] = nonlcon(x)
% nonlcon.m 
% nonlcon defines the nonlinear constraints for the inversion.
% A and b are inequality constraints s.t. A*boxes <= b
% This sets 50% <= sum of pool fluxes <= 100%
% Aeq and beq are equality constraints s.t. Aeq*boxes = beq
% This sets the sum of pool fluxes to 100%. This has been disabled by
% defining ceq = [];
%
% Adapted from Noronha et al., 2015 QSR by Peter Carlson 4/12/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global A b %Aeq Beq

ceq =[]; % (Aeq*x')-beq; %equality
c = (A*x')-b; %inequality