function numeroNodo = nodoMasCercano(nodo,superf)

% Busca entre los nodos de una superficie el mas cercano a otro nodo

dist = (superf(:,2)-nodo(2)).^2 + (superf(:,3)-nodo(3)).^2 + (superf(:,4)-nodo(4)).^2;

[valor, indice] = min(dist);

numeroNodo = superf(indice);