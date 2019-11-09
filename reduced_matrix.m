function [new_strat] = reduced_matrix(dom_strat, CA, player)
%FUNCTION_NAME - One line description of what the function or script performs (H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%
% Inputs:
%    input1 - Description
%    input2 - Description
%    input3 - Description
%
% Outputs:
%    output1 - Description
%
% -----------------------------------------------------------------------------
len = length(dom_strat);

if strcmp(player, 'attacker1')
    strat = CA{1};
end

if strcmp(player, 'attacker2')
    strat = CA{2};
end

if strcmp(player, 'defender')
    strat = CA{3};
end

x = 1;
y = 1;

for x=1:len
    if dom_strat(1,x) == 0
        new_strat(y,:) = strat(x,:);
        y = y + 1;
    end
end
