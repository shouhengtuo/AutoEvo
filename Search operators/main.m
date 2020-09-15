function main()
% Search robust operators by AutoEvo

% Copyright (c) 2020 Ye Tian

clc; format compact;

    [~,Operator] = AutoEvo(@(x)sum(x.^2-10*cos(2*pi*x)+10,2),100,1000);
    save Operator Operator;
end