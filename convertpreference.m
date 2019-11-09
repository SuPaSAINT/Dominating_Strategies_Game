function [ newmatrix ] = convertpreference( matrix, player )
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
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

 [sz_1,sz_2,sz_3] = size(matrix);
    
 
 newmatrix = zeros(sz_1,sz_2,sz_3);

    for x = 1:sz_1
        for y = 1:sz_2
            for z = 1:sz_3
                newmatrix(x,y,z) = agentpreference(player, matrix(x,y,z));
            end
        end
    end

end

