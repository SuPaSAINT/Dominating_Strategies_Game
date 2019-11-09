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
%% CLEAR THE WORKSPACE AND COMMAND WINDOW
clear all;
clc;


%% SET UP THE GAME CONFIGURABLES
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


%% CREATE THE COST MATRIX [CA] BASED ON ALL COMBINATIONS THAT COULD BE PLAYED BETWEEN BOTH ATTACKERS VERSUS DEFENDER
[CA] = resourcecombos(num_cyber_nodes,resources);

CA1 = {CA{attacker1(1)} CA{attacker2(1)} CA{defender(1)}};
CA2 = {CA{attacker1(2)} CA{attacker2(2)} CA{defender(2)}};
CA3 = {CA{attacker1(3)} CA{attacker2(3)} CA{defender(3)}};

matrix1 = Gamebuild(num_cyber_nodes,CA1,connections,cost,threshold);
matrix2 = Gamebuild(num_cyber_nodes,CA2,connections,cost,threshold);
matrix3 = Gamebuild(num_cyber_nodes,CA3,connections,cost,threshold);


%% Evaluating Game #1 %%

dom_strat_1_defender = dominatingstrategies(matrix1, 'defender');
dom_strat_1_attacker1 = dominatingstrategies(matrix1, 'attacker1');
dom_strat_1_attacker2 = dominatingstrategies(matrix1, 'attacker2');

new_strat_1_defender = reduced_matrix(dom_strat_1_defender, CA1, 'defender');
new_strat_1_attacker1 = reduced_matrix(dom_strat_1_attacker1, CA1, 'attacker1');
new_strat_1_attacker2 = reduced_matrix(dom_strat_1_attacker2, CA1, 'attacker2');

CA1_new = {new_strat_1_attacker1 new_strat_1_attacker2 new_strat_1_defender};
matrix1_new = Gamebuild2(num_cyber_nodes,CA1_new,connections,cost,threshold);

len_new_strat_defender_1 = size(new_strat_1_defender);
len_new_strat_attacker1_1 = size(new_strat_1_attacker1);
len_new_strat_attacker2_1 = size(new_strat_1_attacker2);

num_of_strat1 = [len_new_strat_attacker1_1(1) len_new_strat_attacker2_1(1) len_new_strat_defender_1(1)];

[Aa1,payoff1,iterations1,err1] = npg2(num_of_strat1,matrix1_new);

%% Evaluating Game #2 %%

dom_strat_2_defender = dominatingstrategies(matrix2, 'defender');
dom_strat_2_attacker1 = dominatingstrategies(matrix2, 'attacker1');
dom_strat_2_attacker2 = dominatingstrategies(matrix2, 'attacker2');

new_strat_2_defender = reduced_matrix(dom_strat_2_defender, CA2, 'defender');
new_strat_2_attacker1 = reduced_matrix(dom_strat_2_attacker1, CA2, 'attacker1');
new_strat_2_attacker2 = reduced_matrix(dom_strat_2_attacker2, CA2, 'attacker2');

CA2_new = {new_strat_2_attacker1 new_strat_2_attacker2 new_strat_2_defender};
matrix2_new = Gamebuild2(num_cyber_nodes,CA2_new,connections,cost,threshold);

len_new_strat_defender_2 = size(new_strat_2_defender);
len_new_strat_attacker1_2 = size(new_strat_2_attacker1);
len_new_strat_attacker2_2 = size(new_strat_2_attacker2);

num_of_strat2 = [len_new_strat_attacker1_2(1) len_new_strat_attacker2_2(1) len_new_strat_defender_2(1)];


[Aa2,payoff2,iterations2,err2] = npg2(num_of_strat2,matrix2_new);

%% Evaluating Game #3 %%

dom_strat_3_defender = dominatingstrategies(matrix3, 'defender');
dom_strat_3_attacker1 = dominatingstrategies(matrix3, 'attacker1');
dom_strat_3_attacker2 = dominatingstrategies(matrix3, 'attacker2');

new_strat_3_defender = reduced_matrix(dom_strat_3_defender, CA3, 'defender');
new_strat_3_attacker1 = reduced_matrix(dom_strat_3_attacker1, CA3, 'attacker1');
new_strat_3_attacker2 = reduced_matrix(dom_strat_3_attacker2, CA3, 'attacker2');

CA3_new = {new_strat_3_attacker1 new_strat_3_attacker2 new_strat_3_defender};
matrix3_new = Gamebuild2(num_cyber_nodes,CA3_new,connections,cost,threshold);

len_new_strat_defender_3 = size(new_strat_3_defender);
len_new_strat_attacker1_3 = size(new_strat_3_attacker1);
len_new_strat_attacker2_3 = size(new_strat_3_attacker2);

num_of_strat3 = [len_new_strat_attacker1_3(1) len_new_strat_attacker2_3(1) len_new_strat_defender_3(1)];

[Aa3,payoff3,iterations3,err3] = npg2(num_of_strat3,matrix3_new);

% Plot %%
figure;
plot(defender,payoff1,'-+r');
hold on
plot(defender,payoff2,':*g')
plot(defender,payoff3,'-.xk')
% legend('Payoff Player 1','Payoff Player 2','Payoff Defender')
title('Defender resources vs value of game')
xlabel('Defender resources')
ylabel('Value of n-person game')
hold off 
