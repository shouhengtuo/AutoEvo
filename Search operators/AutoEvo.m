function [bestObj,bestDec] = AutoEvo(func,N,G,Weight,Lower,Upper)
% Automated evolving system

% Copyright (c) 2020 Ye Tian

    mode = nargin < 4;  % 0.Solving problems 1.Evolving operators
    k    = 10;          % Number of parameter sets
    if mode
        Lower = repmat([0 -1 0 -1 0 -1 1e-6],N,k);
        Upper = repmat([1  1 1  1 1  1    1],N,k);
    else
        if nargin < 5
            Lower  = zeros(N,10) - 10;
            Upper  = zeros(N,10) + 10;
        end
        Weight = reshape(Weight,[],k)'; % Parameter matrix
        Fit    = cumsum(Weight(:,end));
        Fit    = Fit./max(Fit);         % Probability of each parameter set
    end
    Pdec = unifrnd(Lower,Upper);
    if mode
        Pobj = FitnessEvaluation(Pdec,func);
    else
        Pobj = func(Pdec);
    end
    for gen = 1 : G
        if mode
            clc; fprintf('AutoEvo %d/%d\n',gen,G);
            [~,best] = min(Pobj);
            Weight   = reshape(Pdec(best,:),[],k)'; % Parameter matrix
            Fit      = cumsum(Weight(:,end));
            Fit      = Fit./max(Fit);   % Probability of each parameter set
        end
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
        if mode
            Qobj = FitnessEvaluation(Qdec,func);
        else
            Qobj = func(Qdec);
        end
        % Environmental selection
        Pdec     = [Pdec;Qdec];
        Pobj     = [Pobj;Qobj];
        [~,rank] = sort(Pobj);
        Pdec     = Pdec(rank(1:N),:);
        Pobj     = Pobj(rank(1:N),:);
    end
    [bestObj,best] = min(Pobj);
    bestDec = Pdec(best,:);
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