function BEST = PSO(func,k,D,N,G)
% Particle swarm optimization

% Copyright (c) 2020 Ye Tian

    Lower = zeros(N,D) - k;
    Upper = zeros(N,D) + k;
    Pdec  = unifrnd(Lower,Upper);
    Pvel  = zeros(size(Pdec));
    Pobj  = func(Pdec);
    PBdec = Pdec;
    PBobj = Pobj;
    [~,index] = min(PBobj);
    GBdec = PBdec(index,:);
    for gen = 1 : G
%         clc; fprintf('PSO %d\n',gen);
        % Update particles
        r1   = repmat(rand(N,1),1,D);
        r2   = repmat(rand(N,1),1,D);
        Pvel = 0.4.*Pvel + r1.*(PBdec-Pdec) + r2.*(repmat(GBdec,N,1)-Pdec);
        Pdec = Pdec + Pvel;
        Pdec = min(max(Pdec,Lower),Upper);
        Pobj = func(Pdec);
        % Update global best and personal best
        replace = Pobj < PBobj;
        PBdec(replace,:)  = Pdec(replace,:);
        PBobj(replace,:)  = Pobj(replace,:);
        [BEST(gen),index] = min(PBobj);
        GBdec = PBdec(index,:);
    end
end