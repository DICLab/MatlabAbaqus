function C = leerCPRESS(archivo)

% Lee CPRESS de una superficie y devuelve un cell cuyos elementos son los 
% nodos en contacto para la pieza y la presion de contacto para cada pieza
% C{k} es una matriz de dos columnas: la primera son los nodos en contacto
% y la segunda la presion de contacto

texto = fileread(archivo); % leer el archivo report de Abaqus
C = strsplit(texto,'-----------------------------------------------------------------');
C = C(2:end); % Quitar el heading

C = cellfun(@(x) strsplit(x,'Minimum'), C, 'UniformOutput', 0); 
C = cellfun(@(x) x{1}, C, 'UniformOutput', 0); % Hay que quedarse con el primer trozo de cada celda excepto de la primera

C = cellfun(@str2num, C, 'UniformOutput', 0); % Convertir el string a numero

C = cellfun(@(x) x(:,[3,4]), C, 'UniformOutput', 0); % Quedarse con la tercera y cuarta columna que son los nodos en contacto y la presion de contacto
C = cellfun(@(x) x(x(:,2)~=0,:),C, 'UniformOutput', 0); % Quitar los ceros
C = cellfun(@(x) unique(x,'rows'),C, 'UniformOutput', 0); % Quitar los nodos repetidos
