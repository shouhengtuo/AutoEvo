function Obj = FitnessEvaluation(Dec,func)
% Fitness evaluation of a candidate operator

% Copyright (c) 2020 Ye Tian

    CallStack = dbstack();
    caller    = CallStack(2).file;
    optimizer = str2func(caller(1:end-2));
    Obj = zeros(size(Dec,1),1);
    for i = 1 : size(Dec,1)
        Data = zeros(1,9);
        for r = 1 : length(Data)
            Data(r) = optimizer(func,100,100,Dec(i,:));
        end
        Obj(i) = median(Data);
    end
end