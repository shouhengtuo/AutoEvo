function main()
% Experiments on single-objective benchmark problems

% Copyright (c) 2020 Ye Tian

clc; format compact; format shorte;

    f{1} = @(x)sum(abs(x),2)+prod(abs(x),2);
    f{2} = @(x)max(abs(x),[],2);
    f{3} = @(x)sum(repmat(1:size(x,2),size(x,1),1).*x.^4,2)+rand(size(x,1),1);
    f{4} = @(x)1/4000*sum(x.^2,2)-prod(cos(x./sqrt(repmat(1:size(x,2),size(x,1),1))),2)+1;
    f{5} = @(x)-sum(x.*sin(sqrt(abs(x))),2);
    f{6} = @(x)-20*exp(-0.2*sqrt(mean(x.^2,2)))-exp(mean(cos(2*pi*x),2))+20+exp(1);
    f{7} = @(x)sum(100*(x(:,1:end-1)-x(:,2:end)).^2+(x(:,1:end-1)-1).^2,2);
    f{8} = @(x)sum(x.^2-10*cos(2*pi*x)+10,2);
    K    = [10,100,1.25,600,500,32,100,5];

    % Results of BSPGA, C-DEEPSO, and OSNPS are referred to:
    % Y. Su, N. Guo, Y. Tian, and X. Zhang. A non-revisiting genetic
    % algorithm based on a novel binary space partition tree. Information
    % Sciences, 2020, 512: 661-674.
    Alg  = {@ABC,@CMAES,@CSO,@DE,@FEP,@GA,@PSO,@AutoEvo};
    Data = cell(1,length(Alg));
    for a = 1 : length(Alg)
        Data{a} = zeros(length(f),30);
        for r = 1 : size(Data{a},2)
            for i = 1 : length(f)
                clc; fprintf('%d-%d-%d\n',a,r,i);
                Data{a}(i,r) = min(Alg{a}(f{i},K(i),30,100,200));
            end
        end
    end
    save SingleObjective Data;

    load SingleObjective Data;
    a = 1;  % Index of algorithm
    data = [mean(Data{a},2),std(Data{a},0,2),zeros(size(Data{a},1),1)];
    for i = 1 : size(data,1)
        [~,data(i,end)] = ranksum(Data{end}(i,:),Data{a}(i,:));
    end
    data
end