function [nodosContacto, numeroNodo, alfa] = nodesContact(cpress, inp)

% Takes CPRESS and inp from Abaqus simulation and computes which are the
% closest nodes between two surfaces

% 1) Read CPRESS

% C = leerCPRESS(cpress);

[C, alfa]= leerContacto(cpress);

nodosContacto1 = C{1};
nodosContacto2 = C{2};

nodosContacto1 = nodosContacto1(:,1);
nodosContacto2 = nodosContacto2(:,1);

% 2) Import coordinates

C = coordenadasInp(inp);

coord1 = C{1};
coord2 = C{2};

% Take out contact nodes only

coord1 = coord1(sort(nodosContacto1)-coord1(1,1) + 1,:); % just in case it doesn't start in one
coord2 = coord2(sort(nodosContacto2)-coord2(1,1) + 1,:); % index of nodosContacto in coord2 = value - value_first_node +1 because coord2 correlative

% 3) Find closest node in surface B to node in surface A. 
% Use shortest vector. Avoid redundance and ensure spring is perpendicular
% to surface

if length(coord1) <= length(coord2)

    nodosContacto = nodosContacto1;
    numeroNodo = zeros(length(coord1),1); % vector that contains closest nodes to coord1

    for k = 1:length(coord1)

        numeroNodo(k) = nodoMasCercano(coord1(k,:), coord2);

    end

else
    
    nodosContacto = nodosContacto2;
    numeroNodo = zeros(length(coord2),1); % vector that contains closest nodes to coord2
    
    for k = 1:length(coord2)

        numeroNodo(k) = nodoMasCercano(coord2(k,:), coord1);

    end
    
end

