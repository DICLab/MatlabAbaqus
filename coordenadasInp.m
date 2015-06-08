function C = coordenadasInp(archivoLectura)

% Extraer coordenadas de un archivo inp de Abaqus (sin part y assembly). 
% Devuelve un cell cuyos elementos son las coordenadas de cada pieza en el 
% sistema global

texto = fileread(archivoLectura); % Leer inp

C = strsplit(texto,'*Node'); % Parte el texto en numero de piezas + 1 trozos. El primer trozo es el heading
C = C(2:end); % Quitar el heading

C = cellfun(@(x) strsplit(x,'*Element'), C, 'UniformOutput', 0); % Coger el trozo entre *Node y *Element  

C = cellfun(@(x) x{1}, C, 'UniformOutput', 0); % Hay que quedarse con el primer trozo de cada celda excepto de la primera

C = cellfun(@str2num, C, 'UniformOutput', 0); % Convertir el string a numero
