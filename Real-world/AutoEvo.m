function BEST = AutoEvo(func,k,D,N,G)
% Automated evolving system

% Copyright (c) 2020 Ye Tian

    Weight = [	0.0000	0	0.0000	0   0.0072    0.9999    0.7323
                     0	0        0	0   0.0056   -0.0070    0.5537
                0.0011	0   0.0011	0   0.4978   -0.9998    0.0079
                0.2127	0   0.2127	0   0.3427   -0.8547    0.0003
                0.0181	0   0.0181	0   0.3254   -0.5621    0.0002
                0.0379	0   0.0379	0   0.8975    0.7293    0.1128
                     0	0   	 0	0   0.1014    0.4753    0.7694
                0.0002	0   0.0002	0   0.0167    0.9988    0.5579
                0.0000	0   0.0000	0   0.0006    0.0034    0.7646
                0.1874	0   0.1874	0   0.5644    0.0392    0.0204];  % Parameter matrix 
    Fit = cumsum(Weight(:,end));
    Fit = Fit./max(Fit);	% Probability of each parameter set
    
    Lower = zeros(N,D) - k;
    Upper = zeros(N,D) + k;
    Pdec  = unifrnd(Lower,Upper);
    Pobj  = func(Pdec);
    for gen = 1 : G
%         clc; fprintf('AutoEvo %d\n',gen);
        % Mating selection
        Parent1 = Pdec(Tournament(2,N,Pobj),:);
        Parent2 = Pdec(Tournament(2,N,Pobj),:);
        % Generating offspring
        type = arrayfun(@(S)find(rand<=Fit,1),1:numel(Parent1));
        type = reshape(type,size(Parent1));
        r1   = randn(size(Parent1));
        r2   = randn(size(Parent1));
        r3   = randn(size(Parent1));
        Qdec = Parent1;
        for i = 1 : length(Fit)
            index = type == i;
            Qdec(index) = Upper(index).*(r1(index)*Weight(i,1)+Weight(i,2)) + ...
                          Lower(index).*(r2(index)*Weight(i,3)+Weight(i,4)) + ...
                          Parent2(index).*(r3(index)*Weight(i,5)+Weight(i,6)) + ...
                          Parent1(index).*(1-r1(index)*Weight(i,1)-Weight(i,2)-r2(index)*Weight(i,3)-Weight(i,4)-r3(index)*Weight(i,5)-Weight(i,6));
        end
        Qdec = min(max(Qdec,Lower),Upper);
        Qobj = func(Qdec);
        % Environmental selection
        Pdec      = [Pdec;Qdec];
        Pobj      = [Pobj;Qobj];
        [~,rank]  = sort(Pobj);
        Pdec      = Pdec(rank(1:N),:);
        Pobj      = Pobj(rank(1:N),:);
        BEST(gen) = min(Pobj);
    end
end

function index = Tournament(K,N,varargin)
% Tournament selection

    varargin = cellfun(@(S)reshape(S,[],1),varargin,'UniformOutput',false);
    [~,rank] = sortrows([varargin{:}]);
    [~,rank] = sort(rank);
    Parents  = randi(length(varargin{1}),K,N);
    [~,best] = min(rank(Parents),[],1);
    index    = Parents(best+(0:N-1)*K);
end