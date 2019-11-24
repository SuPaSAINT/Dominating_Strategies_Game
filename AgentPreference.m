function [ newvalue ] = AgentPreference( agent, value )
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
%agentpreference coverts payoff values to newvalues based on player
%   This is done to allow interger comparisions to identy dominant
%   strategies for each player
    
    if strcmp(agent, 'defender')
        if value == -1
            newvalue = 0;
        elseif value == 0
            newvalue = 1;
        else 
            newvalue = 2;
        end
    elseif strcmp(agent, 'attacker2')
        if value == 0
            newvalue = 1;
        elseif value == 1
            newvalue = 0;
        else
            newvalue = value;
        end
    elseif strcmp(agent, 'attacker1') 
        newvalue = value; %xa1's perfered strategies are already in decending order
    else
        error('AgentPreference: Invalid agent')
    end
        
        


end

