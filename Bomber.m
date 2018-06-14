function [params, modelSolutions, RMSE] =  Bomber(varargin)
    % Bomber() 
    %   models stalagmite WC-3 from Westcave Preserve
    % Bomber(stal) 
    %   models stal in NH Zone 2. Stal is a text file.
    %   See README for file format.
    % Bomber(stal, PostBombZone) 
    %   Where PostBombZone is 'NHZ1',
    %   'NHZ2', 'NHZ3', 'SHZ1', or 'SHZ3'.
    % Bomber(stal, PostBombZone, offset)
    %   models stal with a chronological offset.
    % Bomber(stal, PostBombZone, offset, plot on) 
    %   plot on is a boolean that
    %   can suppress outputing a figure. Use this when calling Bomber.m from
    %   BombHandler.m
    % Bomber(stal, PostBombZone, offset, plot on, Boxes) Boxes is a list of 
    %   Modeled pool turnover times. Default is [1 2 3 6 10 22 100 1000]
    % Bomber.m can be called by BombHandler.m or run independently
    % Bomber.m calls Errors.m, calcbox.m, nonlcon.m and bombPlot.m
    %
    % Adapted from Noronha et al., 2015 QSR by Peter Carlson 5/12/2018 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    clear atmo stal lambda startRecord stalYears intPool memoMeans startModel modelYears boxes turnovers
   
    global atmo stal lambda startRecord stalYears intPool memoMeans startModel modelYears boxes turnovers Aeq beq A b
    
    if nargin > 5
        error('simple_bombC_Peter:TooManyInputs', ...
            'requires at most 5 optional inputs in the following order:', ...
            'stalagmite file .txt--tab delimited, young to old', ...
            '14CO2 Zone',...
            'chronology offset years',...
            'plot on (true/false)',...
            'Boxes');
    end

    optargs = {'WC3.txt' 'NHZ2' 1 true round(10.^([0 1/4 1/2 3/4 1 4/3 2 3]))};
    optargs(1:nargin) = varargin;

    [stalFile, zone, offset, plotOn, turnovers] = optargs{:};

    format shortG

    %'running model'

    warning('off', 'MATLAB:nearlySingularMatrix')


    %post-bomb atmosphere record to use, from Hua et al., 2013:
    if zone == 'SHZ1'
        postbomb = load('SHZ1.txt');
        prebomb = load('shprebomb.txt');    
    elseif zone == 'SHZ3'
         postbomb = load('SHZ3.txt');
        prebomb = load('shprebomb.txt');   
    elseif zone == 'NHZ1'
        postbomb = load('NHZ1.txt');
        prebomb = load('nhprebomb.txt');    
    elseif zone == 'NHZ2'
        postbomb = load('NHZ2.txt');
        prebomb = load('nhprebomb.txt');    
    elseif zone == 'NHZ3'
        postbomb = load('NHZ3.txt');
        prebomb = load('nhprebomb.txt');    
    else
        error('simple_bombC_Peter:Unknown14CZone ', ...
            '14C Zone not found. See README.txt for info.');    
    end
        
    in_stal = load(stalFile);
    atmo = vertcat(postbomb, prebomb);

    stal = sortrows(in_stal,-1);
    stal(:,1) = stal(:,1) + offset;
    
    lambda = log(2)/5730;

    boxes = length(turnovers);

    windup = 100;

    for j = 1:1:length(stal)
        stal(j,2) = stal(j,2)*exp(-stal(j,1)*lambda);
    end

    stalYears = (round(stal(1,1)):-1:-60)';
    modelYears = (windup+round(stal(1,1)):-1:-60)';
    
    r = rand(1, boxes);
    x0 = r/sum(r)*90;
    startRecord = find(atmo(:,1)==round(stal(1,1)));

    startModel = startRecord+windup;

    intPool = zeros(length(atmo),1);

    for j = 1:1:length(atmo)-startModel
        intPool(j) = atmo(startModel+j,2)*exp(-(lambda*atmo(startModel+j,1)));
    end

    memoMeans = zeros(10000,1);
    for j = 1:1:length(memoMeans)
        memoMeans(j) = mean(intPool(1:j));
    end

    %These nonlinear constraints are redefined in nonlcon.m
    Aeq = []; 
    beq = [];
    A = [ones(1,boxes);-ones(1,boxes)];
    b = [100;-50];
    lb = zeros(1,boxes); %Indivual lower bounds for fluxes
    ub = 100*ones(1,boxes); %Indivual upper bounds for fluxes



    options = optimoptions('fmincon','Display','none');%,'FiniteDifferenceStepSize',);

    solution = fmincon(@errors, x0, A, b, Aeq, beq, lb, ub, @nonlcon, options);

    
    RMSE = errors(solution);

    modelSolutions = 1950-modelYears;
    modelSolutions = horzcat(modelSolutions, calcbox(solution));

    bestFitFluxes = round(solution(1:boxes)');
    bestFitSOM = fluxes(round(solution));
    DCP = 100 - sum(bestFitFluxes);
    params  = [[bestFitSOM(1:boxes);nan], [bestFitFluxes(1:boxes);DCP],[turnovers(:);nan]];

    vheader = horzcat(sprintf('Pool%d ',1:boxes), sprintf('DCP')); %Called by evalc, line 130. Ignore the pretty print, and do not delete.

    if plotOn == true
        strtok(stalFile,'.')
        evalc('printmat(params, '''' ,vheader,''P F tau'')')
       bombPlot(params, modelSolutions, RMSE, stalFile, offset) 
    end    

   