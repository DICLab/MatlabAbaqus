% Nodos en contacto

clear
clc

% 1) Leer CPRESS O CSHEAR para ver cuales son los nodos en contacto en cada
% pieza

% Vectores columna

[nodosContacto1, presion1] = leerCPRESS('beam.txt');
[nodosContacto2, presion2] = leerCPRESS('disk.txt');


% 2) Para esos nodos, importar sus coordenadas

% 2.1) Llamar a coordenadasInp para generar un archivo con las coordenadas

%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dim = 3; % Dimension del problema
% nodos = 12136; % Numero de nodos del sistema
% archivoLectura = 'beamOnDisk.inp';
% coordenadas = 'coordBeamOnDisk.txt';

% coordenadasInp(archivoLectura,coordenadas,dim,nodos)

% 2.2) Importar el archivo de solo las coordenadas

% coordenadas = load(archivoEscritura);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Por el momento usar los archivos coordBeam y coordDisk

coord1 = load('coordBeam.txt');
coord2 = load('coordDisk.txt');

% 2.3) Quedarse solo con los nodos con contacto

coord1 = coord1(sort(nodosContacto1),:);
coord2 = coord2(sort(nodosContacto2),:);


% 3) Para cada nodo de una de las superficies iterar en los nodos de la otra 
% y encontrar el nodo mas cercano, ese sera el nodo con el que estara en
% contacto

numeroNodo = nodoMasCercano(coord1(1,:), coord2);

