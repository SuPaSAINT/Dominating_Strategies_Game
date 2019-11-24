function [ output ] = DominatingStrategies( matrix, player )
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
%DOMINATINGSTRATIGIES Summary of this function goes here
%   Detailed explanation goes here

% Defender minimizes, attackers maximize

    [sz_d,sz_a1,sz_a2] = size(matrix);
    
    matrix = ConvertPreference(matrix,player);
        
    if strcmp(player, 'defender')
        output = zeros(1,sz_d);
        for x = 1:sz_d
            for y = x+1:sz_d
                if all( all( matrix(x,:,:) >= matrix(y,:,:) ))
                    output(1,x) = 1;
                elseif all( all( matrix(x,:,:) <= matrix(y,:,:) ))
                    output(1,y) = 1;
                end
            end
        end
    elseif strcmp(player, 'attacker2')
        output = zeros(1,sz_a2);
         for x = 1:sz_a2
            for y = x+1:sz_a2
                if all( all( matrix(:,:,x) >= matrix(:,:,y) ))
                    output(1,y) = 1;
                elseif all( all( matrix(:,:,x) <= matrix(:,:,y) ))
                     output(1,x) = 1; 
                end
            end
        end      
    elseif strcmp(player, 'attacker1') 
        output = zeros(1,sz_a1);
        for x = 1:sz_a1
            for y = x+1:sz_a1
                if all( all( matrix(:,x,:) >= matrix(:,y,:) ))
                    output(1,y) = 1;
                elseif all( all( matrix(:,x,:) <= matrix(:,y,:) ))
                    output(1,x) = 1;   
                end
            end
        end
    else
        error('DominatingStratigies: Invalid agent')
    end
       
    

    


end

