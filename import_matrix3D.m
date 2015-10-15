function matlab_matrix = import_matrix3D(mtx_file)

% Importa matrices 3D de archivo .mtx de Abaqus
% Usa 3*(nodo1-1)+gdl para pasar a gdlGlobal1 gdlGlobal2 valor
% Extendido de código en http://www.eng.ox.ac.uk/stress/

% Archivo mtx. Columnas:
% 1) Número de nodo fila 
% 2) Gdl nodo fila (1,2 o 3)
% 3) Número de nodo columna
% 4) Gdl nodo columna (1,2 o 3)
% 5) Valor 

abaqus_matrix = dlmread(mtx_file);

% Utilizar info de número de nodo y gdl para pasar a gdl global
matlab_nodes(:,1) = 3*(abaqus_matrix(:,1)-1)+ abaqus_matrix(:,2);
matlab_nodes(:,2) = 3*(abaqus_matrix(:,3)-1)+ abaqus_matrix(:,4);

% Extraer valores de la matrix. Duplicar para triángulo superior e inferior
values = [abaqus_matrix(:,5); abaqus_matrix(:,5)];

% Crear una matriz de los nuevos números de nodoy su posición en la matriz 
% de Abaqus.  
% [matlab_nodes; matlab_nodes(:,2) matlab_nodes(:,1)] --> la segunda parte
% representa los valores del triángulo inferior, los simétricos. Unique es
% necesario para no repetir los valores de la diagonal. 

[matlab_matrix_indices, abaqus_value_index] = unique( ...
[matlab_nodes; matlab_nodes(:,2) matlab_nodes(:,1)], 'rows');

% Crear la nueva matriz. Busca el valor de la matriz entre el nodo i y el j
% y llena la matriz. Como ese valor estará tanto en i j como en j i solo 
% hay que coger 1, de ahí que use @max porque por defecto suma
matlab_matrix = accumarray(matlab_matrix_indices, values(abaqus_value_index), [], @max, [], true);