function test()
% Experiments on multi-objective benchmark problems

% Copyright (c) 2020 Ye Tian

clc; format compact; format short

    Algorithm = {@SPEA2,@SMPSO,@MOEADDE,@MOEADCMA,@MOEADFRRMAB,@AutoEvo};
    Problem   = {@ZDT1,@ZDT2,@ZDT3,@ZDT4,@ZDT6,@WFG1,@WFG2,@WFG3,@WFG4,@WFG5,@WFG6,@WFG7,@WFG8,@WFG9};

    for a = 1 : length(Algorithm)
        for p = 1 : length(Problem)
            for r = 1 : 30
                main('-algorithm',Algorithm{a},'-problem',Problem{p},'-N',100,'-M',2,'-run',r,'-save',1,'-evaluation',10000);
            end
        end
    end
end