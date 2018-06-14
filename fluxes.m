function fluxCalcSol = fluxes(sol)
% fluxes.m converts carbon pool fluxes to carbon pool size. In the original
% code by Noronha et al., 2015, this function ran the opposite conversion.
% fluxes.m is called by Bomber.m
%
% Adapted from Noronha et al., 2015 QSR by Peter Carlson 4/12/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global boxes turnovers
y = round(sol(1:boxes)'.*turnovers');

fluxCalcSol = y/nansum(y)*100; 