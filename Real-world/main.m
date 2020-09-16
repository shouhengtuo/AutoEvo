function main()
% Experiments on real-world portfolio optimization problems

% Copyright (c) 2020 Ye Tian

clc; format compact; format shorte;

    Alg    = {@GA,@PSO,@DE,@CMAES,@AutoEvo};
    Algstr = {'GA','PSO','DE','CMA-ES','AutoEvo'};
    Data = zeros(length(Alg),500);
    for i = 1 : size(Data,2)
        P = rand(randi([10 30]),randi([10 100]))*20-10;
        PO(P);
        for a = 1 : length(Alg)
            clc; fprintf('%d-%d\n',i,a);
            Data(a,i) = min(Alg{a}(@PO,1,size(P,2),100,200));
        end
    end
    save RealWorld Data;

    load RealWorld Data;
    R = zeros(1,size(Data,1));
    for i = 1 : size(Data,1)
        R(i) = sum(Data(i,:)==min(Data,[],1));
    end
    bar(R,'FaceColor',[.7 .7 .7]);
    set(gca,'xlim',[0.2 5.8],'NextPlot','add','Box','on','Fontname','Times New Roman','FontSize',13);
    set(gcf,'Position',[100 100 530 200]); 
    set(gca,'xticklabel',Algstr);
    ylabel('# Best Results');
    for i = 1 : length(R)
        text(i-0.05,R(i)+5,num2str(R(i)));
    end
end

function F = PO(X)
% The portfolio optimization problem
persistent P C;

    if nargout == 0
        P = X;
        C = cov(P);
    else
        X = X./repmat(sum(abs(X),2),1,size(X,2));
        f1 = X*sum(P,1)';
        f2 = zeros(size(X,1),1);
        for i = 1 : size(X,1)
            f2(i) = X(i,:)*C*X(i,:)';
        end
        F = f2 - f1;
    end
end
