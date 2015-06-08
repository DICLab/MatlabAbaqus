% Nodos en contacto

clear
clc

% 1) Leer CPRESS O CSHEAR para ver cuales son los nodos en contacto en cada
% pieza


C = leerCPRESS('presion.txt');

nodosContacto1 = C{1};
nodosContacto2 = C{2};

nodosContacto1 = nodosContacto1(:,1);
nodosContacto2 = nodosContacto2(:,1);


% 2) Para esos nodos, importar sus coordenadas

C = coordenadasInp('beamSinAssembly.inp');

coord1 = C{1};
coord2 = C{2};

% Quedarse solo con los nodos con contacto

coord1 = coord1(sort(nodosContacto1),:);
coord2 = coord2(sort(nodosContacto2),:);


% 3) Para cada nodo de una de las superficies iterar en los nodos de la otra 
% y encontrar el nodo mas cercano, ese sera el nodo con el que estara en
% contacto

numeroNodo = zeros(length(coord1),1);

for k = 1:length(coord1)

    numeroNodo(k) = nodoMasCercano(coord1(k,:), coord2);
    
end

