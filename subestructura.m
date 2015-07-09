%[K, M] = leerSubs('substructure.mtx');
[K, M] = leerSubs('substructureDisco.mtx');
close all

%numeroNodos = 4;
numeroNodos = 499;
gdlNodo = 3;

gdlTotal = numeroNodos * gdlNodo;

% Coger la matriz de la subestructura solo

Ksub = K(1:gdlTotal, 1:gdlTotal);
Msub = M(1:gdlTotal, 1:gdlTotal);

[~, lambda]=eigs(K,M,20,'sm'); 

omega = lambda.^0.5/(2*pi);
omega = real(omega(:));
omega = sort(omega(omega > 1));

fprintf('\nFrecuencias:\n')
X = sprintf('%0.3f\n',omega);
disp(X)
