% +HDR-------------------------------------------------------------------------
% FILE NAME      : Main.m
% TYPE           : MATLAB File
% COURSE         : Binghamton University
%                  EECE580A - Cyber Physical Systems Security
% -----------------------------------------------------------------------------
% PURPOSE : Colonel Blotto Game With Dominating Strategies
%           Solve a non co-op game between 3 players (2 attackers 1 defender)
%
% -HDR-------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLEAR THE WORKSPACE AND COMMAND WINDOW %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
clc;



%%%%%%%%%%%%%%%%%%%%%%%%
%% START ELAPSED TIME %%
%%%%%%%%%%%%%%%%%%%%%%%%
start_time = clock;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET UP THE GAME CONFIGURABLES %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HOW MANY CYBER NODES ARE THERE?
num_cyber_nodes = 4;

% HOW ARE THE PHYSICAL NODES CONNECTED TO THE CYBER NODES?
%   [PHYSICAL_NODE_1; PHYSICAL_NODE_2]
%   [CYBER_NODE_1 CYBER_NODE_2 ... CYBER_NODE_N; CYBER_NODE_1 CYBER_NODE_2 ... CYBER_NODE_N]
connections = [1 1 1 0 ; 0 1 1 1];

% WHAT ARE THE AVAILABLE PLAYER RESOURCES FOR EACH GAME?
%   [GAME_1; GAME_2; GAME_3]
attacker1 = [3;3;3];
attacker2 = [3;3;3];
defender  = [6;7;8];
resources = [attacker1 attacker2 defender];

% WHAT IS THE COST OF EACH PHYSICAL NODE TO EACH PLAYER WHEN DOWN?
%   [PHYSICAL_NODE_1; PHYSICAL_NODE_2]
%   A POSITIVE SIGN DENOTES AN ATTACKER (MAXIMIZER)
%   A NEGATIVE SIGN DENOTES A DEFENDER (MINIMIZER)
attacker1_cost = [1;.25];
attacker2_cost = [.25;1];
defender_cost  = [-.75;-.75];
cost = [attacker1_cost attacker2_cost defender_cost];

% HOW MANY CYBER NODES MUST BE DOWN FOR EACH PHYSICAL NODE TO BE DOWN?
%   [PHYSICAL_NODE_1; PHYSICAL_NODE_2]
threshold = [1;1];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CREATE THE RESOURCE MATRIX [RESOURCE_MATRIX] BASED ON ALL COMBINATIONS %%
%% THAT COULD BE PLAYED BETWEEN BOTH ATTACKERS VERSUS DEFENDER            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CREATE AN ARRAY OF 2-D MATRICES CONTAINING ALL NECESSARY COMBINATIONS OF RESOURCE ALLOCATIONS
[RESOURCE_COMBOS_ARRAY] = ResourceCombos(num_cyber_nodes,resources);

% CREATE AN ARRAY OF 2-D RESOURCE MATRICES FOR EACH GAME BY SELECTING THE APPROPRIATE
%   RESOURCE ALLOCATIONS MATRIX BASED ON THE PLAYER'S AVAILABLE RESOURCES
RESOURCE_MATRIX_ARRAY_1 = {RESOURCE_COMBOS_ARRAY{attacker1(1)} RESOURCE_COMBOS_ARRAY{attacker2(1)} RESOURCE_COMBOS_ARRAY{defender(1)}};
RESOURCE_MATRIX_ARRAY_2 = {RESOURCE_COMBOS_ARRAY{attacker1(2)} RESOURCE_COMBOS_ARRAY{attacker2(2)} RESOURCE_COMBOS_ARRAY{defender(2)}};
RESOURCE_MATRIX_ARRAY_3 = {RESOURCE_COMBOS_ARRAY{attacker1(3)} RESOURCE_COMBOS_ARRAY{attacker2(3)} RESOURCE_COMBOS_ARRAY{defender(3)}};

% BUILD THE THREE 3-D GAME MATRICES USING THE SETTINGS AND RESPECTIVE GAME RESOURCE MATRIX ARRAY
GAME_MATRIX_1 = GameBuild(num_cyber_nodes,RESOURCE_MATRIX_ARRAY_1,connections,cost,threshold);
GAME_MATRIX_2 = GameBuild(num_cyber_nodes,RESOURCE_MATRIX_ARRAY_2,connections,cost,threshold);
GAME_MATRIX_3 = GameBuild(num_cyber_nodes,RESOURCE_MATRIX_ARRAY_3,connections,cost,threshold);



%%%%%%%%%%%%%%%%%%%%%%
%% EVALUATE GAME #1 %%
%%%%%%%%%%%%%%%%%%%%%%
% CREATE THE DOMINATING STRATEGIES MATRICES FOR EACH PLAYER
DOM_STRAT_1_DEFENDER  = DominatingStrategies(GAME_MATRIX_1, 'defender');
DOM_STRAT_1_ATTACKER1 = DominatingStrategies(GAME_MATRIX_1, 'attacker1');
DOM_STRAT_1_ATTACKER2 = DominatingStrategies(GAME_MATRIX_1, 'attacker2');

% REDUCE THE RESOURCE ALLOCATIONS MATRICES FOR EACH PLAYER (THROW AWAY DOMINATED STRATEGIES)
NEW_STRAT_1_DEFENDER  = ReducedMatrix(DOM_STRAT_1_DEFENDER, RESOURCE_MATRIX_ARRAY_1, 'defender');
NEW_STRAT_1_ATTACKER1 = ReducedMatrix(DOM_STRAT_1_ATTACKER1, RESOURCE_MATRIX_ARRAY_1, 'attacker1');
NEW_STRAT_1_ATTACKER2 = ReducedMatrix(DOM_STRAT_1_ATTACKER2, RESOURCE_MATRIX_ARRAY_1, 'attacker2');

% CREATE AN ARRAY OF 2-D RESOURCE MATRICES (REDUCED)
REDUCED_RESOURCE_MATRIX_ARRAY_1 = {NEW_STRAT_1_ATTACKER1 NEW_STRAT_1_ATTACKER2 NEW_STRAT_1_DEFENDER};

% BUILD THE 3-D GAME MATRICES USING THE SETTINGS AND RESPECTIVE GAME REDUCED RESOURCE MATRIX ARRAY
REDUCED_GAME_MATRIX_1 = GameBuild2(num_cyber_nodes,REDUCED_RESOURCE_MATRIX_ARRAY_1,connections,cost,threshold);

% FIND THE SIZE OF EACH REDUCED RESOURCE ALLOCATIONS MATRIX FOR EACH PLAYER
len_new_strat_1_defender  = size(NEW_STRAT_1_DEFENDER);
len_new_strat_1_attacker1 = size(NEW_STRAT_1_ATTACKER1);
len_new_strat_1_attacker2 = size(NEW_STRAT_1_ATTACKER2);

% CREATE AN ARRAY OF REDUCED RESOURCE ALLOCATIONS MATRIX SIZES
num_of_strat_1 = [len_new_strat_1_attacker1(1) len_new_strat_1_attacker2(1) len_new_strat_1_defender(1)];

% EXECUTE THE GAME CALCULATION
[Aa1,payoff1,iterations1,err1] = NPG2(num_of_strat_1,REDUCED_GAME_MATRIX_1);



% %%%%%%%%%%%%%%%%%%%%%%
% %% EVALUATE GAME #2 %%
% %%%%%%%%%%%%%%%%%%%%%%
% dom_strat_2_defender = DominatingStrategies(GAME_MATRIX_2, 'defender');
% dom_strat_2_attacker1 = DominatingStrategies(GAME_MATRIX_2, 'attacker1');
% dom_strat_2_attacker2 = DominatingStrategies(GAME_MATRIX_2, 'attacker2');
% 
% new_strat_2_defender = ReducedMatrix(dom_strat_2_defender, RESOURCE_MATRIX_ARRAY_2, 'defender');
% new_strat_2_attacker1 = ReducedMatrix(dom_strat_2_attacker1, RESOURCE_MATRIX_ARRAY_2, 'attacker1');
% new_strat_2_attacker2 = ReducedMatrix(dom_strat_2_attacker2, RESOURCE_MATRIX_ARRAY_2, 'attacker2');
% 
% RESOURCE_MATRIX_ARRAY_2_new = {new_strat_2_attacker1 new_strat_2_attacker2 new_strat_2_defender};
% REDUCED_GAME_MATRIX_2 = GameBuild2(num_cyber_nodes,RESOURCE_MATRIX_ARRAY_2_new,connections,cost,threshold);
% 
% len_new_strat_defender_2 = size(new_strat_2_defender);
% len_new_strat_attacker1_2 = size(new_strat_2_attacker1);
% len_new_strat_attacker2_2 = size(new_strat_2_attacker2);
% 
% num_of_strat2 = [len_new_strat_attacker1_2(1) len_new_strat_attacker2_2(1) len_new_strat_defender_2(1)];
% 
% [Aa2,payoff2,iterations2,err2] = NPG2(num_of_strat2,REDUCED_GAME_MATRIX_2);
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%
% %% EVALUATE GAME #3 %%
% %%%%%%%%%%%%%%%%%%%%%%
% dom_strat_3_defender = DominatingStrategies(GAME_MATRIX_3, 'defender');
% dom_strat_3_attacker1 = DominatingStrategies(GAME_MATRIX_3, 'attacker1');
% dom_strat_3_attacker2 = DominatingStrategies(GAME_MATRIX_3, 'attacker2');
% 
% new_strat_3_defender = ReducedMatrix(dom_strat_3_defender, RESOURCE_MATRIX_ARRAY_3, 'defender');
% new_strat_3_attacker1 = ReducedMatrix(dom_strat_3_attacker1, RESOURCE_MATRIX_ARRAY_3, 'attacker1');
% new_strat_3_attacker2 = ReducedMatrix(dom_strat_3_attacker2, RESOURCE_MATRIX_ARRAY_3, 'attacker2');
% 
% RESOURCE_MATRIX_ARRAY_3_new = {new_strat_3_attacker1 new_strat_3_attacker2 new_strat_3_defender};
% REDUCED_GAME_MATRIX_3 = GameBuild2(num_cyber_nodes,RESOURCE_MATRIX_ARRAY_3_new,connections,cost,threshold);
% 
% len_new_strat_defender_3 = size(new_strat_3_defender);
% len_new_strat_attacker1_3 = size(new_strat_3_attacker1);
% len_new_strat_attacker2_3 = size(new_strat_3_attacker2);
% 
% num_of_strat3 = [len_new_strat_attacker1_3(1) len_new_strat_attacker2_3(1) len_new_strat_defender_3(1)];
% 
% [Aa3,payoff3,iterations3,err3] = NPG2(num_of_strat3,REDUCED_GAME_MATRIX_3);



%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERATE RESULTS PLOT %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot(defender,payoff1,'-+r');
hold on
% plot(defender,payoff2,':*g')
% plot(defender,payoff3,'-.xk')
% legend('Payoff Player 1','Payoff Player 2','Payoff Defender')
title('Defender resources vs value of game')
xlabel('Defender resources')
ylabel('Value of n-person game')
hold off 



%%%%%%%%%%%%%%%%%%%%%%%
%% STOP ELAPSED TIME %%
%%%%%%%%%%%%%%%%%%%%%%%
stop_time = clock;
elapsed_seconds = etime(stop_time,start_time)


