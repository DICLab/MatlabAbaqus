% Nodos en contacto

% 1) Leer CPRESS O CSHEAR para ver cuales son los nodos en contacto en cada
% pieza

% Vectores columna

nodosContacto1 =
nodosContacto2 =

% 2) Para esos nodos, importar sus coordenadas

% 2.1) Llamar a coordenadasInp para generar un archivo con las coordenadas

dim = 3;
nodos = 621; 
archivoLectura = 'beamOnDisk.inp';
archivoEscritura = 'coordBeamOnDisk.txt';

coordenadasInp(archivoLectura,archivoEscritura,dim,nodos)

% 2.2) Importar el archivo de solo las coordenadas

coordenadas = load(archivoEscritura);

% 2.3) Quedarse solo con los nodos con contacto

coordenadas = coordenadas(sort([nodosContacto1; nodosContacto2]),:);


% 3) Para cada nodo de una de las superficies iterar en los nodos de la otra 
% y encontrar el nodo mas cercano, ese sera el nodo con el que estara en
% contacto