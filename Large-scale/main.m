function main()
% Experiments on large-scale benchmark problems

% Copyright (c) 2020 Ye Tian

clc; format compact; format shorte;
global initial_flag;

    % Results of SHADE-ILS are referred to:
    % D. Molina, A. LaTorre, and F. Herrera. SHADE with iterative local
    % search for large-scale global optimization. Proceedings of the 2018
    % IEEE Congress on Evolutionary Computation, 2018.
    Alg  = {@CMAES,@DE,@GA,@PSO,@AutoEvo};
    Data = cell(1,length(Alg));
    for a = 1 : length(Alg)
        Data{a} = zeros(15,30);
        for r = 1 : size(Data{a},2)
            for i = 1 : size(Data{a},1)
                clc; fprintf('%d-%d-%d\n',a,r,i);
                initial_flag = 0;
                [K,D] = getKD(i);
                Data{a}(i,r) = min(Alg{a}(@(x)benchmark_func(x',i)',K,D,100,1200));
            end
        end
    end
    save LargeScale Data;

    load LargeScale Data;
    a = 1;  % Index of algorithm
    data = [mean(Data{a},2),std(Data{a},0,2),zeros(size(Data{a},1),1)];
    for i = 1 : size(data,1)
        [~,data(i,end)] = ranksum(Data{end}(i,:),Data{a}(i,:));
    end
    data
end

function [K,D] = getKD(i)
    switch i
        case {1 4 7 8 11 12 13 14 15}
            K = 100;
        case {2 5 9}
            K = 5;
        case {3 6 10}
            K = 32;
    end
    if i > 12 && i < 15
        D = 905;
    else
        D = 1000;
    end
end