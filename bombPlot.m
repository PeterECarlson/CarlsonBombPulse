function bombPlot(params, modelSolutions, RMSE, stalFile, varargin)
global atmo stal boxes turnovers

%bombPlot.m
%bombPlot is a function that can be used to plot the results of a single
%model run (when called by Bomber.m or the combined results of several
%runs, as when called by BombHandler.m.
%bombPlot(params, modelSolutions, RMSE, stalFile)
%   --When bombPlot is called by Bomber.m, it uses this format
%   params is a matrix of [[Pool sizes]; [Pool Fluxes (including DCP)]; [Pool Turnover times]]
%   modelSolutions is the model output speleothem [[year];[FMC]]
%   RMSE is the Root Mean Square error of the modelSolutions versus
%      measured stalagmite.
%   stalFile is the .txt file of stalagmite measurements
%bombPlot(params, modelSolutions, RMSE, stalFile, offset, errorbars, allSolutions, MRCARange)
%   --When bombPlot is called by BombHandler.m, it uses this format
%   offset is an optional argument that offsets the chronology of the
%      measured stalagmite
%   errorbars are added to the bar charts when bombPlot plots the results
%      of multiple model runs. errorbars is a 3D matrix of 
%         [[[+SizeErr];[+FluxErr]][[-SizeErr];[-FluxErr]]]
%   allSolutions are all of the model output speleothem results
%   MRCARange is a vector all of lowest and highest calculated MRCA values.
%
% Peter Carlson 5/12/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if length(varargin) > 4
    error('bombPlot:TooManyInputs', ...
        'requires at most 4 optional input');
end

optargs = {0, zeros(boxes+1,2,2), nan(length(modelSolutions),2,2), zeros(2,1)};
optargs(1:length(varargin)) = varargin;
offset = optargs{1}; %This would have the effect of moving a record by an entire year. Defunct, but easy to fix.
[errorBars] = optargs{2};
errorPos = errorBars(:,:,2);
errorNeg = errorBars(:,:,1);
[allSolutions] = optargs{3};
MRCARange = optargs{4};


allSolutionsBreak = cat(1,allSolutions,nan(1,size(allSolutions,2),size(allSolutions,3)));
allSolutionsBreakOrdered = [reshape(allSolutionsBreak(:,1,:),[],1,1),reshape(allSolutionsBreak(:,2,:),[],1,1)];


figure('Color',[1 1 1])

set(gcf,'Position', [100, 100, 1249, 895]);

%Outer Plot:
axes('Position',[0.15 0.15 0.5 0.75])
set(gca,'FontSize', 24,'Units','Normalized','Linewidth',3)
axis([1940 2015 50 200])
xlabel('Calendar Age (Years AD)');
ylabel('^{14}C (pMC)');
hold on

plot((1950-(atmo(1:100,1))), atmo(1:100,2)*100, 'k-', 'LineWidth', 3);
plot(allSolutionsBreakOrdered(:,1),allSolutionsBreakOrdered(:,2)*100,'r-');
if isnan(optargs{3})
    plot(modelSolutions(:,1),modelSolutions(:,2)*100, 'r-','LineWidth',3);
end
errorbar(1950-stal(:,1), stal(:,2)*100, stal(:,3)*100, '.k', 'MarkerSize', 20);

MRCA = sum(params(1:boxes,2).*params(1:boxes,3))/sum(params(1:boxes,2)); %Mean Respired Carbon Age.

text(1985,156,sprintf('RMSE = %.2g',RMSE),'FontSize', 18);
text(1985,148,sprintf('MRCA = %d',round(MRCA)),'FontSize', 18);
if ~isnan(optargs{3})
    text(1985,140,sprintf('MRCA Range = %d-%d',round(MRCARange(1)),round(MRCARange(2))),'FontSize', 18);
    text(1985,132,sprintf('n_{tests} = %d',size(allSolutions,3)),'FontSize', 18);
end

titleTextLarge = sprintf('%s',strtok(stalFile,'.'));
title(titleTextLarge);

%Inner Plot 1: Relative Pool Sizes Bar Chart
for i = 1:boxes
    boxlabel{i} = sprintf('%.0f',turnovers(i));
end
ax1 = axes('Position',[.7 .6 .25 .3]);
hold on
bar(ax1,log10(params(1:boxes,3)),params(1:boxes,1),'stacked');
eb1 = errorbar(ax1,log10(params(1:boxes,3)),params(1:boxes,1),errorNeg(1:boxes,1), errorPos(1:boxes,1), '.k', 'MarkerSize',0.5);
set(ax1,'FontSize', 16,'Linewidth',3)
xticks([log10(turnovers), log10(turnovers(end))+1])
xlim([-0.25 log10(params(boxes,3))+1.75])
ylim([0 ceil(max(params(:,1)+errorPos(:,1))/10)*10]);
xticklabels(boxlabel);
xlabel('\tau (years)')
ylabel('% Abundance')
title('Epikarst Carbon Pools')
hold off

%Inner Plot 2: Relative Fluxes Bar Chart
ax2 = axes('Position',[.7 .15 .25 .3]);
hold on
b2 = bar(ax2,[log10(params(1:boxes,3)); log10(params(boxes,3))+1],[[params(1:boxes,2); nan], [nan(boxes,1); params(boxes+1,2)]],'stacked');
eb2 = errorbar(ax2,[log10(params(1:boxes,3)); log10(params(boxes,3))+1],params(1:boxes+1,2),errorNeg(:,2),  errorPos(:,2), 'k.', 'MarkerSize',0.5);
set(ax2,'FontSize', 16,'Linewidth',3)
xticks([log10(turnovers), log10(turnovers(end))+1])
xticklabels([boxlabel,{'DCP'}]);
xlim([-0.25 log10(params(boxes,3))+1.75])
ylim([0 ceil(max(params(:,2)+errorPos(:,2))/10)*10]);
xlabel('\tau (years)')
ylabel('% Contribution')
title('Contribution to Stalagmite')
text(log10(params(boxes,3))+1, params(boxes+1,2)+max(params(:,2)+errorPos(:,2))/15+errorPos(boxes+1,2), sprintf('%.0f', params(boxes+1,2)),'FontSize', 16,'HorizontalAlignment','center')


 shg
