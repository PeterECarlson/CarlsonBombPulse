function [modelStal] = calcbox(fluxsol)

% calcbox models stalagmite 14C using a box model that uses correct fluxes 
% The intial value of the pools is set to the average of the atmospheric 14C
% over the current time minus one turnover time.
% calcbox.m is called by errors.m and by Bomber.m
%
% Adapted from Noronha et al., 2015 QSR by Peter Carlson 5/12/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



global atmo startModel modelYears memoMeans lambda boxes turnovers

sum(fluxsol);

poolRec = zeros(length(modelYears),boxes);
modelStal = zeros(length(modelYears),1);

pool(1:boxes) = memoMeans(turnovers)';
poolRec(1,1:boxes) = pool(1:boxes).*(1-(1./turnovers))+1./turnovers*atmo(startModel,2);

modelStal(1) = poolRec(1,:)*fluxsol(1:boxes)'/100;

for j = 2:1:(length(modelYears))
    poolRec(j,1:boxes) = poolRec(j-1,1:boxes).*(1-(1./turnovers))*exp(-lambda)+(1./turnovers*atmo(startModel-j+1,2));
    modelStal(j) = poolRec(j,:)*fluxsol(1:boxes)'/100;
end
