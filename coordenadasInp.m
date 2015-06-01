function coordenadasInp(archivoLectura, archivoEscritura,dim,nodos)

% Extraer coordenadas de un archivo inp de Abaqus y guardarlo en otro
% archivo
% dim = dimension del problema
% nodos = numero de nodos

% Leer inp

texto = fileread(archivoLectura);

% Expresion regular

if dim==2

    exp = '\d+,[\s-]+[0-9]\.[0-9]+,\s+[0-9.-]+';
    match = regexp(texto,exp,'match');

else
    
    exp = '\d+,[\s-]+[0-9]\.[0-9e,-]+\s+[0-9]\.[0-9e,-]+\s+[0-9e.-]+';
    match = regexp(texto,exp,'match');
    
end

match = match(1:nodos); % Para que no coja nada de mas abajo


% Escribir archivo de nodos-coordenadas 

f = fopen(archivoEscritura,'w');

for i=1:length(match)

    fprintf(f,'%s\n', match{i});
end

fclose(f);
