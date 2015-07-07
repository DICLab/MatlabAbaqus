% Leer subestructura

% 1) Importar archivo

texto = fileread('substructure.mtx'); % % leer el archivo report de Abaqus

% 2) Partir en trozo de elementos, K y M

% Delimitadores

stiff = '*MATRIX,TYPE=STIFFNESS';
mass = '*MATRIX,TYPE=MASS';

C = strsplit(texto,{stiff, mass});

% Descartar el heading

C = C(2:end);

% 3) Interpretar K y M segun elementos

% Contador que inicie en uno y represente la fila en la que estoy en la
% matriz (i)

% Ir avanzando columnas (j) hasta que j = i.

% Cuando j = i saltar linea, i = i+1
% Cuando j sea multiplo de 4 saltar de linea, i se mantiene 

% Repetir hasta tener nodos * gdl filas

% OTRA OPCION

% Sacar todos los numeros. Crear un vector con las posiciones. Crear la
% sparse

C = cellfun(@(x) strrep(x, ',', ' '), C, 'UniformOutput', 0); 
C = cellfun(@(x) strsplit(x,' '), C, 'UniformOutput', 0); 

C{1} = cellfun(@str2num, C{1}, 'UniformOutput',0);
C{2} = cellfun(@str2num, C{2}, 'UniformOutput',0);

C{1} = [C{1}{:}];
C{2} = [C{2}{:}];
