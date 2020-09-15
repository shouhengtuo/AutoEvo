function BEST = FEP(func,k,D,N,G)
% Fast evolutionary programming

% Copyright (c) 2020 Ye Tian

    Lower = zeros(N,D) - k;
    Upper = zeros(N,D) + k;
    Pdec  = unifrnd(Lower,Upper);
    Pvel  = rand(size(Pdec))/30.*(Upper-Lower);
    Pobj  = func(Pdec);
    for gen = 1 : G
%         clc; fprintf('FEP %d\n',gen);
        tau  = 1/sqrt(2*sqrt(D));
        tau1 = 1/sqrt(2*D);
        GaussianRand  = repmat(randn(N,1),1,D);
        GaussianRandj = randn(N,D);
        CauchyRandj   = trnd(1,N,D);
        Odec = Pdec + Pvel.*CauchyRandj;
        Ovel = Pvel.*exp(tau1*GaussianRand+tau*GaussianRandj);
        Odec = min(max(Odec,Lower),Upper);
        Pdec = [Pdec;Odec];
        Pvel = [Pvel;Ovel];
        Pobj = [Pobj;func(Odec)];
        Win  = zeros(1,size(Pdec,1));
        for i = 1 : size(Pdec,1)
            Win(i) = sum(Pobj(i)<=Pobj(randperm(size(Pdec,1),10)));
        end
        [~,rank] = sort(Win,'descend');
        Pdec = Pdec(rank(1:N),:);
        Pvel = Pvel(rank(1:N),:);
        Pobj = Pobj(rank(1:N));
        BEST(gen) = min(Pobj);
    end
end