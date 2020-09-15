function BEST = CSO(func,k,D,N,G)
% Competitive swarm optimizer

% Copyright (c) 2020 Ye Tian

    Lower = zeros(N/2,D) - k;
    Upper = zeros(N/2,D) + k;
    Pdec  = unifrnd(repmat(Lower,2,1),repmat(Upper,2,1));
    Pvel  = zeros(size(Pdec));
    Pobj  = func(Pdec);
    for gen = 1 : 2*G
%         clc; fprintf('CSO %d\n',gen);
        % Divide winners and losers
        rank    = randperm(N);
        loser   = rank(1:end/2);
        winner  = rank(end/2+1:end);
        replace = Pobj(loser) < Pobj(winner);
        temp            = loser(replace);
        loser(replace)  = winner(replace);
        winner(replace) = temp;
        % Update the losers
        R1 = repmat(rand(N/2,1),1,D);
        R2 = repmat(rand(N/2,1),1,D);
        Pvel(loser,:) = R1.*Pvel(loser,:) + R2.*(Pdec(winner,:)-Pdec(loser,:));
        Pdec(loser,:) = Pdec(loser,:) + Pvel(loser,:);
        Pdec(loser,:) = min(max(Pdec(loser,:),Lower),Upper);
        Pobj(loser)   = func(Pdec(loser,:));
        BEST(ceil(gen/2)) = min(Pobj);
    end
end