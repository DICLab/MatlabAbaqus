function [K, M] = leerSubs(archivo)

% Lee archivo mtx de subestructura exportado de Abaqus mediante
% *SUBSTRUCTURE MATRIX OUTPUT, OUTPUT FILE=USER DEFINED, 
% FILE NAME=substructure, STIFFNESS=YES, MASS=YES

% 1) Importar archivo

texto = fileread(archivo); % % leer el archivo report de Abaqus

% 2) Partir en trozo de nodos, K y M. La parte de nodos puede usarse para
% saber automaticamente cuantos gdl se retienen, pero probablemente sea
% mas facil preguntar.

% Delimitadores

stiff = '*MATRIX,TYPE=STIFFNESS';
mass = '*MATRIX,TYPE=MASS';

C = strsplit(texto,{stiff, mass});

% Descartar el heading

C = C(2:end);

% 3) Interpretar K y M 

% Extraer todos los numeros del archivo en un unico vector

C = cellfun(@(x) strrep(x, ',', ' '), C, 'UniformOutput', 0); % sustituir la coma por espacio
C = cellfun(@(x) strsplit(x,' '), C, 'UniformOutput', 0); % partir por el espacio

% Convertir a numero

C{1} = cellfun(@str2num, C{1}, 'UniformOutput',0);
C{2} = cellfun(@str2num, C{2}, 'UniformOutput',0);

% Coger solo las celdas con contenido

C{1} = [C{1}{:}];
C{2} = [C{2}{:}];

% Generar el triangulo de posiciones

% Total de filas que tendra la matriz:

total = (sqrt(1+8*length(C{1}))-1)/2; % el numero de elementos de una matriz triangular es (n^2 + n)/2. 
% Da este numero resolviendo para (n^2 + n)/2 = longitud_vector y cogiendo
% el positivo

pos1=[]; 
pos2=[];

for i =1:total
    
    pos1 = [pos1, ones(1,i)*i]; % [ 1 2 2 3 3 3 4 4 4 4 ...]
    pos2 = [pos2, 1:i]; % [ 1 1 2 1 2 3 1 2 3 4 ...]
    
end


K = sparse(pos1,pos2,C{1}); % triangulo inferior
M = sparse(pos1,pos2,C{2}); % triangulo inferior

spy(K), title('Stiffness matrix')
figure
spy(M), title('Mass matrix')

% Crear vectores de posicion de triangulo superior, usar K y M anteriores para crear nueva matriz completa

pos3=[]; 
pos4=[];

for i = (total-1):-1:1
    
    pos3 = [pos3, ones(1,i)*(total-i)]; % [ 1 1 1 1 ... 1 2 2 ...2 ] fila
    pos4 = [pos4, (total-i+1):total]; % [2...n 3...n 4...n ] columna
    
end

% Elegir terminos de M y de K que esten en las posiciones [pos4 pos3] y meterlos en superiorK y superiorM

superiorK = K(sub2ind(size(K),pos4,pos3)); % convertir posiciones a indice sencillo, con indice doble coge filas y columnas
superiorM = M(sub2ind(size(M),pos4,pos3));

K = sparse([pos1 pos3],[pos2 pos4],[C{1} superiorK]); 
M = sparse([pos1 pos3],[pos2 pos4],[C{2} superiorM]); 

figure
spy(K)
figure
spy(M)


% Comprobar simetria: issymmetric
