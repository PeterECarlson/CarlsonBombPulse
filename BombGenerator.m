function BombGenerator(varargin)

%bombGenerator() produces a synthetic stalagmite for validation
%of the inverse modeling program Bomber.m. Stalagmite chronology is based on WC-3.
%With no inputs, BombGenerator produces a speleothem-based record with a
%log-normal distribution of carbon input in 17 pools with DCP = 1%, with a mean input of 56-100 years.
%optional arguments include:
%   1) The distribution of relative pool sizes, as a vector
%   2) The output file name
%   3) The turnover time (in year) of each pool, as a vector.
%Peter Carlson 5/12/2018 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear atmo startModel modelYears memoMeans lambda boxes turnovers
global atmo startModel modelYears memoMeans lambda boxes turnovers

if length(varargin) > 3
    error('bombGenerator:TooManyInputs', ...
        'requires at most 2 optional input');
end

optargs = {[0 25 0 25 0 25 0], '12check2.txt', [1 2 5 10 22 100 1000]};
optargs(1:length(varargin)) = varargin;

sizes = optargs{1};
file = optargs{2};
turnovers = optargs{3};

if length(sizes) ~= length(turnovers)
    error('BombGenerator:UnequalPoolNumber', ...
        'The length of the "sizes" vector must equal the length of the "turnovers" vector');
end
if sum(sizes) > 100
    error('BombGenerator:SumPools', ...
        'The sum of the "sizes" vector must less than 100');
end

postbomb = load('NHZ2.txt');
prebomb = load('nhprebomb.txt');
stalFake = (-59:1:-4)';
stalFake = [stalFake, zeros(length(stalFake),2)];

lambda = log(2)/5730;
boxes = length(turnovers);
atmo = vertcat(postbomb, prebomb);

stalFake = sortrows(stalFake,-1);    

windup = 100;
modelYears = (windup+round(stalFake(1,1)):-1:-60)';
startRecord = find(atmo(:,1)==round(stalFake(1,1)));

startModel = startRecord+windup;
intPool = zeros(length(atmo),1);

for j = 1:1:length(atmo)-startModel
   intPool(j) = atmo(startModel+j,2)*exp(-(lambda*atmo(startModel+j,1)));
end

memoMeans = zeros(10000,1);
for j = 1:1:length(memoMeans)
    memoMeans(j) = mean(intPool(1:j));
end

modelStal = calcbox(sizes);
modelStal = horzcat(modelYears, modelStal);

y = zeros(length(stalFake), 1);

for i = 1:1:length(y)
    y(i) = find(modelStal(:,1)==round(stalFake(i,1)));
end

for i = 1:1:length(y)
   stalFake(i,2) = modelStal(y(i),2);
end
stalFake(:,3) = zeros(length(stalFake), 1);
stalFake =flipud(stalFake);

figure
plot(stalFake(:,1), stalFake(:,2),'.')
dlmwrite(file, stalFake, 'delimiter', ' ', 'newline','pc');