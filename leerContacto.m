function [C, alfa]= leerContacto(archivo)

% Lee un archivo que contenta CPRESS, CSHEAR1 y CSHEAR2 (es igual que leer CPRESS)

texto = fileread(archivo); % % leer el archivo report de Abaqus
C = strsplit(texto,'-------------------------------------------------------------------------------------------------');
C = C(2:end); % Quitar el heading

C = cellfun(@(x) strsplit(x,'Minimum'), C, 'UniformOutput', 0); %
C = cellfun(@(x) x{1}, C, 'UniformOutput', 0); % Hay que quedarse con el primer trozo de cada celda excepto de la primera

C = cellfun(@str2num, C, 'UniformOutput', 0); % Convertir el string a numero

C = cellfun(@(x) x(:,3:6), C, 'UniformOutput', 0); % Quedarse con las columnas de la 3 a la 6; son el nodo, presion de contacto, cortante1 y cortante2
C = cellfun(@(x) x(x(:,2)~=0,:),C, 'UniformOutput', 0); % Quitar los ceros
C = cellfun(@(x) unique(x,'rows'),C, 'UniformOutput', 0); % Quitar los nodos repetidos

alfa = cellfun(@(x) [x(:,1) atan(x(:,end)./x(:,(end-1)))], C,'UniformOutput', 0); % [nodo; coseno director de las direcciones de deslizamiento]

