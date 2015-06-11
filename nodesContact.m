function [nodosContacto1, numeroNodo] = nodesContact(cpress, inp)

% Takes CPRESS and inp from Abaqus simulation and computes which are the
% closest nodes between two surfaces

% 1) Read CPRESS

C = leerCPRESS(cpress);

nodosContacto1 = C{1};
nodosContacto2 = C{2};

nodosContacto1 = nodosContacto1(:,1);
nodosContacto2 = nodosContacto2(:,1);

% 2) Import coordinates

C = coordenadasInp(inp);

coord1 = C{1};
coord2 = C{2};

% Take out contact nodes only

coord1 = coord1(sort(nodosContacto1),:);
coord2 = coord2(sort(nodosContacto2),:);

% 3) Find closest node in surface B to node in surface A

numeroNodo = zeros(length(coord1),1); % vector that contains closest nodes to coord1

for k = 1:length(coord1)

    numeroNodo(k) = nodoMasCercano(coord1(k,:), coord2);
    
end

