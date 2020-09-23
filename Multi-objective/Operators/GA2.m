function Offspring = GA2(Parent1,Parent2)
% GA2

    %% Parameter setting
    Parent1 = Parent1.decs;
    Parent2 = Parent2.decs;
    [N,D]   = size(Parent1);
    Global  = GLOBAL.GetObj();

    %% Genetic operators for real encoding
    Weight = [	0.0000	0	0.0000	0   0.0072    0.9999    0.7323
                     0	0        0	0   0.0056   -0.0070    0.5537
                0.0011	0   0.0011	0   0.4978   -0.9998    0.0079
                0.2127	0   0.2127	0   0.3427   -0.8547    0.0003
                0.0181	0   0.0181	0   0.3254   -0.5621    0.0002
                0.0379	0   0.0379	0   0.8975    0.7293    0.1128
                     0	0   	 0	0   0.1014    0.4753    0.7694
                0.0002	0   0.0002	0   0.0167    0.9988    0.5579
                0.0000	0   0.0000	0   0.0006    0.0034    0.7646
                0.1874	0   0.1874	0   0.5644    0.0392    0.0204];
                 
    Fit  = cumsum(Weight(:,end));
    Fit  = Fit./max(Fit);
    type = arrayfun(@(S)find(rand<=Fit,1),1:numel(Parent1));
    type = reshape(type,size(Parent1));
    r1   = randn(size(Parent1));
    r2   = randn(size(Parent1));
    r3   = randn(size(Parent1));
    Lower     = repmat(Global.lower,N,1);
    Upper     = repmat(Global.upper,N,1);
    Offspring = Parent1;
    for i = 1 : length(Fit)
        index = type == i;
        Offspring(index) = Upper(index).*(r1(index)*Weight(i,1)+Weight(i,2)) + ...
                           Lower(index).*(r2(index)*Weight(i,3)+Weight(i,4)) + ...
                           Parent2(index).*(r3(index)*Weight(i,5)+Weight(i,6)) + ...
                           Parent1(index).*(1-r1(index)*Weight(i,1)-Weight(i,2)-r2(index)*Weight(i,3)-Weight(i,4)-r3(index)*Weight(i,5)-Weight(i,6));
    end
	Offspring = INDIVIDUAL(Offspring);
end