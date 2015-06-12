function numeroNodo = nodoMasCercano(nodo,superf)

% Busca entre los nodos de una superficie el mas cercano a otro nodo

if size(superf,2) == 4

    dist = (superf(:,2)-nodo(2)).^2 + (superf(:,3)-nodo(3)).^2 + (superf(:,4)-nodo(4)).^2;

else
    
    dist = (superf(:,2)-nodo(2)).^2 + (superf(:,3)-nodo(3)).^2;
    
end

[~, indice] = min(dist); % no es necesario el valor, solo el indice

numeroNodo = superf(indice);