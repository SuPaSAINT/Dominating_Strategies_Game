% GameBuild - Generate the game cost matrix based on blotto resource combinations
% 
% Syntax:  [GAME_COST_MATRIX] = GameBuild(mode,num_cyber_nodes,RESOURCE_MATRIX_ARRAY,CONNECTIONS,COST,threshold)
% 
% Inputs:
%    mode                  - 0      = Build 3 player game matrix (3-D)
%                            1      = Build 3 player game cost matrix (2-D)
%                            others = Invalid
%    num_cyber_nodes       - The number of cyber nodes in the system
%    RESOURCE_MATRIX_ARRAY - An array of 2-D resource matrices for each player
%    CONNECTIONS           - Interconnectivity of cyber and physical nodes
%    COST                  - The cost of each physical node to each player when down
%    threshold             - How many cyber nodes must be down for each physical node to be down
% 
% Outputs:
%    GAME_COST_MATRIX - Game cost matrix (mode 0 = 3-D matrix, mode 1 = 2-D matrix)
% 
% -----------------------------------------------------------------------------
function [GAME_COST_MATRIX] = GameBuild(mode,num_cyber_nodes,RESOURCE_MATRIX_ARRAY,CONNECTIONS,COST,threshold)
  % Three player game matrix based on blotto resource combinations
  if mode == 0
      player = 0;
  elseif mode == 1
      player = 1;
  else
      error('GameBuild: Invalid mode')
  end % if
   
  z = 0;

  RESOURCE_MATRIX_ATTACKER1 = RESOURCE_MATRIX_ARRAY{1};
  RESOURCE_MATRIX_ATTACKER2 = RESOURCE_MATRIX_ARRAY{2};
  RESOURCE_MATRIX_DEFENDER  = RESOURCE_MATRIX_ARRAY{3};

  resource_matrix_attacker1_dimentions = size(RESOURCE_MATRIX_ATTACKER1);
  resource_matrix_attacker2_dimentions = size(RESOURCE_MATRIX_ATTACKER2);
  resource_matrix_defender_dimentions  = size(RESOURCE_MATRIX_DEFENDER);

  resource_matrix_attacker1_rows = resource_matrix_attacker1_dimentions(1);
  resource_matrix_attacker2_rows = resource_matrix_attacker2_dimentions(1);
  resource_matrix_defender_rows  = resource_matrix_defender_dimentions(1);

  if mode == 0
      GAME_COST_MATRIX = zeros(resource_matrix_defender_rows,resource_matrix_attacker1_rows,resource_matrix_attacker2_rows);
      i = 1; j = 1; k = 1;
  end % if

  % For each strategy set in attacker 2 combinations
  for kk = 1:resource_matrix_attacker2_rows

      % For each strategy set in attacker 1 combinations 
      for jj = 1:resource_matrix_attacker1_rows

          % For each strategy set in defender combinations
          for ii = 1:resource_matrix_defender_rows

              % Check if combined strategies takes over a node
              for ll = 1:num_cyber_nodes
                  if RESOURCE_MATRIX_ATTACKER1(jj,ll)+RESOURCE_MATRIX_ATTACKER2(kk,ll) <= RESOURCE_MATRIX_DEFENDER(ii,ll)
                      H = 0; % Not taken over
                  elseif RESOURCE_MATRIX_ATTACKER1(jj,ll)+RESOURCE_MATRIX_ATTACKER2(kk,ll) > RESOURCE_MATRIX_DEFENDER(ii,ll)
                      H = 1; % Taken over
                  end % if
                  % z contains success or failure of each cyber nodes attacks from combined efforts
                  z(ll) = H;
              end % for

              % CONNECTIONS helps relate interconnectivity of physical nodes.
              % If y(1) = 2; ==> physical node 1 suffered 2 cyber node losses this combo
              y = CONNECTIONS*z';

              for b = 1:length(y) % Compare nodes with threshold values
                  if y(b) >= threshold(b)
                      Y(b) = 1; % Physical node taken down
                  else
                      Y(b) = 0; % Physical node remains up
                  end % if
                  % Y now contains 1 if physical node is taken down and 0 if not
              end % for

              % Each player values physical nodes differently
              % If player mm is an attacker, reward nodes being down.(Y(ii) = 1)
              for mm = 1:size(COST,2)
                  if sum(COST(:,mm)) > 0
                    C(mm) = Y*COST(:,mm); 
                  else
                      % Otherwise a defender gets rewarded when cyber nodes are not
                      % successfully taken down.
                      for b = 1:length(Y)
                          if Y(b) == 0
                              C10(b) = abs(COST(b,mm));
                          elseif Y(b) == 1
                              C10(b) = 0;
                          end % if
                      end % for
                      C(mm) = sum(C10);
                  end % if
              end % for

              if mode == 0
                  % if C == [0,0,1.5]
                  if C == [0,0,abs(COST(1,3)+COST(2,3))]
                      n = -1;
                  end % if

                  % if C == [.25,1,.75]
                  if C == [COST(1,2),COST(1,1),abs(COST(1,3))]
                      n = 0;
                  end % if

                  % if C == [1,.25,.75]
                  if C == [COST(2,2),COST(2,1),abs(COST(2,3))]
                      n = 1;
                  end % if

                  % if C == [1.25,1.25,0]
                  if C == [COST(1,2)+COST(2,2),COST(1,1)+COST(2,1),0]
                      n = 2;
                  end % if

                  GAME_COST_MATRIX(i,j,k) = n;
                  i = i + 1;

                  if i == resource_matrix_defender_rows + 1
                      i = 1;
                      j = j + 1;
                  end % if

                  if j == resource_matrix_attacker1_rows + 1
                      j = 1;
                      k = k +1;
                  end % if
              elseif mode == 1
                  % Build cost matrix.
                  GAME_COST_MATRIX(player,:) = C;
                  player = player+1;
              end % if

          end % for

      end % for

  end % for

end % function