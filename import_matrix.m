function matlab_matrix = import_matrix(mtx_file)

% Importa matrices de Abaqus 2D
% Usa 2*(nodo1-1)+gdl para pasar a gdlGlobal1 gdlGlobal2 valor

%============== Import Stiffness Matrix ==============%
abaqus_stiffness_matrix = dlmread(mtx_file);

nodosPos1 = abaqus_stiffness_matrix(:,1)>0; % Nodos positivos en posicion 1 
nodosPos2 = abaqus_stiffness_matrix(:,3)>0; % Nodos positivos en posicion 2
nodosPos = nodosPos1&nodosPos2; % Nodos positivos en posicion 1 y 2
abaqus_stiffness_matrix = abaqus_stiffness_matrix(nodosPos,:);

% merge node number info from column 1 and DOF info from column 2 and
% store in the 1st column of a new matrix
matlab_nodes(:,1) = 2*(abaqus_stiffness_matrix(:,1)-1)+ ...
abaqus_stiffness_matrix(:,2);
% merge node number info from column 3 and DOF info from column 4 and
% store in the 2nd column of a new matrix
matlab_nodes(:,2) = 2*(abaqus_stiffness_matrix(:,3)-1)+ ...
abaqus_stiffness_matrix(:,4);
% extract the stiffness values from the .mtx file, and store in a double
% length vector
stiffness_values = [abaqus_stiffness_matrix(:,5); ...
abaqus_stiffness_matrix(:,5)];
% create a matrix of the new matlab node numbers, and a vector of indices
% of their position in the abaqus stiffness matrix
[matlab_matrix_indices, abaqus_stiffness_value_index] = unique( ...
[matlab_nodes; matlab_nodes(:,2) matlab_nodes(:,1)], 'rows');
% compile the stiffness matrix using the new node numbering convention
matlab_matrix = accumarray( matlab_matrix_indices, ...
stiffness_values(abaqus_stiffness_value_index), [], @max, [], true);