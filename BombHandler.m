%BombHandler
% 
% This program allows you to model multiple speleothems, synthetic
% speleothems, or alternative chronological interpretations in series.
% It will also allow for the user to model each multiple times, to generate
% a range of possible solutions. 
% BombHandler.m calls Bomber.m
%
% Peter Carlson 5/12/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%box = round(10.^((0:12)/3));
box = [1 2 5 10 22 100 1000]; %Carbon pool turnover times
iter = 30; %Number of times to model each stal.

timeStart = cputime;
timeEnd = timeStart;

stals = {...
    %This is a list of inputs to the function Bomber. Each line should be
    %in the following format:
    %Format: 'SpeleothemFileName.txt', '14C Zone', Offset (0), plot each
    %iteration (false), carbon pool turnover times (box)
  
% Sensitivity and Precision tests

  %'ninety1pre.txt', 'NHZ2', 0, false, box
  %'ninety2pre.txt', 'NHZ2', 0, false, box
  %'ninety5pre.txt', 'NHZ2', 0, false, box
  %'ninety10pre.txt', 'NHZ2', 0, false, box
  %'ninety22pre.txt', 'NHZ2', 0, false, box
  %'ninety50pre.txt', 'NHZ2', 0, false, box
  %'ninety100.txt', 'NHZ2', 0, false, box
  %'ninety220pre.txt', 'NHZ2', 0, false, box
  %'ninety500pre.txt', 'NHZ2', 0, false, box
  %'ninety1000pre.txt', 'NHZ2', 0, false, box
  %'ninety2200pre.txt', 'NHZ2', 0, false, box
  %'ninety5000pre.txt', 'NHZ2', 0, false, box
  %'ninety10000pre.txt', 'NHZ2', 0, false, box
    
    %Speleothem Records
    
    'WC3.txt','NHZ2', 0, false, box %post bomb
    %'WC3plus.txt','NHZ2', 0, false, box %post bomb
    %'WC3minus.txt','NHZ2', 0, false, box  %post bomb
    %'WC3plusminus.txt','NHZ2', 0, false, box  %post bomb
    'CCBIL.txt','NHZ1', 0, false, box 
    %'GAR02.txt','NHZ1', 0, false, box  
    %'ER77.txt','NHZ1', 4, false, box 
    %'YOKI.txt', 'NHZ2', -3, false, box 
    %'YOKG.txt', 'NHZ2', -3, false, box 
    %'GIB04ACycleAge.txt','NHZ2', 0, false, box 
    %'GIB04A14CAge.txt','NHZ2', 0, false, box 
    %'HANSTM5.txt','NHZ1', 5, false,box 
    %'POSSTM4.txt','NHZ1', 0, false, box 
    %'LR06B1.txt','SHZ1', -4, false, box 
    %'OBI84.txt','NHZ1', -2, false, box 
    %'SO11.txt','NHZ2', -1, false, box
    %'T7.txt','SHZ3', 0, false, box 
    %'VK1.txt','NHZ1', 2, false, box 
    %'VK2.txt','NHZ1', -4, false, box 
    %'NU1.txt','NHZ1', -3, false, box %post bomb
    %'NU2.txt','NHZ1',  -8, false, box 
    %'ASFA3.txt','NHZ3', 19, false, box
    %'CCBIL.txt','NHZ1', -1, false, box 
    %'FAUSTM14.txt','NHZ1', -1, false, box 
    %'GAR02.txt','NHZ1', 0, false, box 
    %'HS4.txt','NHZ3', 3, false, box 
    %'MERC1.txt','NHZ3', 15, false, box 
    %'MOD27.txt','NHZ1', 4, false, box 
    };

for i = 1:size(stals,1)
    clear modelSolutionsAll  paramsAll RMSEAll
    try
        for j = 1:iter
            [paramsAll(:,:,j), modelSolutionsAll(:,:,j), RMSEAll(j)] = Bomber(stals{i,1},stals{i,2},stals{i,3},stals{i,4},stals{i,5});
        end
        [RMSE, best] = min(RMSEAll);
        idx = find(RMSEAll<1.05*RMSE);
        params = paramsAll(:,:,best);
        MRCARange = [min(sum(paramsAll(1:end-1,2,:).*params(1:end-1,3))./sum(paramsAll(1:end-1,2,:)));...
            max(sum(paramsAll(1:end-1,2,:).*params(1:end-1,3))./sum(paramsAll(1:end-1,2,:)))];
        errorBars = cat(3,params(:,1:2) - min(paramsAll(:,1:2,idx),[],3),max(paramsAll(:,1:2,idx)-params(:,1:2),[],3));
        modelSolutions = modelSolutionsAll(:,:,best);
        bombPlot(params, modelSolutions, RMSE, stals{i,1},stals{i,3}, errorBars,modelSolutionsAll(:,:,idx),MRCARange)
        stals{i,1}
        params
        timeEnd = cputime;
        timeElapsed = timeEnd - timeStart
    catch me
        warning('An error occured modeling %s.',stals{i,1});
        warning(getReport(me, 'extended', 'hyperlinks', 'on'));
    end
end

