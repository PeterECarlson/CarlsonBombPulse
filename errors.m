function RMSE = errors(testParams)

% errors.m calculates the Root Mean Square Error between modeled and measured 
% stalagmite 14C measurements.
% errors.m is called by Bomber.m
% errors.m calls the function calcbox.m
%
% Adapted from Noronha et al., 2015 QSR by Peter Carlson 4/12/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global stal modelYears


modelStal = calcbox(testParams(:)');    
  
modelStal = horzcat(modelYears, modelStal);

testStal = stal;
y = zeros(length(testStal), 1);

for i = 1:1:length(y)
    y(i) = find(modelStal(:,1)==round(testStal(i,1)));
end

errs = zeros(length(y),1);

for i = 1:1:length(y)
    errs(i) = testStal(i,2) - modelStal(y(i),2);
end

RMSE = sqrt(sum((errs).^2)/(length(y)+1));
