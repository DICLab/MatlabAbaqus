function matlab_matrix = import_matrix3D(mtx_file)

% Importa matrices 3D de archivo .mtx de Abaqus
% Usa 3*(nodo1-1)+gdl para pasar a gdlGlobal1 gdlGlobal2 valor
% Extendido de c�digo en http://www.eng.ox.ac.uk/stress/

% Archivo mtx. Columnas:
% 1) N�mero de nodo fila 
% 2) Gdl nodo fila (1,2 o 3)
% 3) N�mero de nodo columna
% 4) Gdl nodo columna (1,2 o 3)
% 5) Valor 

abaqus_matrix = dlmread(mtx_file);

% Utilizar info de n�mero de nodo y gdl para pasar a gdl global
matlab_nodes(:,1) = 3*(abaqus_matrix(:,1)-1)+ abaqus_matrix(:,2);
matlab_nodes(:,2) = 3*(abaqus_matrix(:,3)-1)+ abaqus_matrix(:,4);

% Extraer valores de la matrix. Duplicar para tri�ngulo superior e inferior
values = [abaqus_matrix(:,5); abaqus_matrix(:,5)];

% Crear una matriz de los nuevos n�meros de nodoy su posici�n en la matriz 
% de Abaqus.  
% [matlab_nodes; matlab_nodes(:,2) matlab_nodes(:,1)] --> la segunda parte
% representa los valores del tri�ngulo inferior, los sim�tricos. Unique es
% necesario para no repetir los valores de la diagonal. 

[matlab_matrix_indices, abaqus_value_index] = unique( ...
[matlab_nodes; matlab_nodes(:,2) matlab_nodes(:,1)], 'rows');

% Crear la nueva matriz. Busca el valor de la matriz entre el nodo i y el j
% y llena la matriz. Como ese valor estar� tanto en i j como en j i solo 
% hay que coger 1, de ah� que use @max porque por defecto suma
matlab_matrix = accumarray(matlab_matrix_indices, values(abaqus_value_index), [], @max, [], true);