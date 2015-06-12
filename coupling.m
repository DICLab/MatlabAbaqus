% Script que acople las matrices de rigidez de dos piezas segun rigidez de
% contacto. Para ello direccion de contacto perpendicular a superficie.
% Probar en el beam on disk primero y extrapolar a champi

% Poner un muelle entre dos gdls implica:
% 1) + Kc en las posiciones (gdl_1,gdl_1) y (gdl_2,gdl_2), la diagonal
% 2) - Kc en las posiciones (gdl_1,gdl_2) y (gdl_2,gdl_1)

clear
clc
close all

% Contacto entre cubos 2D

% Importa nodo1 gdl nodo2 gdl valor. 
% Usa 2*(nodo1-1)+gdl para pasar a gdlGlobal1 gdlGlobal2 valor

K = import_matrix('contactMatrix_STIF1.mtx');
M = import_matrix('contactMatrix_MASS1.mtx');

%%%%%%%%%%%%%%%%%%%%%%%%%%% CONDICIONES DE CONTORNO %%%%%%%%%%%%%%%%%%%%%%%

% Para aplicar bien las condiciones de contorno exportar en Abaqus con "Do 
% not use parts and assembly in input"

% Nodos de las condiciones de contorno. Aparecen en el inp. Pone 1,11,1
% que significa del 1 al 11 todos

BC = [1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 45, 49, 52, 55, 58, 61, 64, 67, 70, 73] ; 

% Pasar las BCs a modo Matlab

BC = [2*(BC-1)+1, 2*(BC-1)+2];

BC = sort(BC,'descend');

K(BC,:)=[];
K(:,BC)=[];

M(BC,:)=[];
M(:,BC)=[];

[~, lambda]=eigs(K,M,10,'sm'); 
omega = lambda.^0.5/(2*pi);
omega = real(omega(:));
omega = omega(omega > 1);

omega = sort(omega);

fprintf('Frecuencias naturales sin contacto \n')
X = sprintf('%0.3f\n',omega);
disp(X)

% Visualizacion

C = coordenadasInp('contacto.inp');

plot(C{1}(:,2),C{1}(:,3),'.')
hold on
plot(C{2}(:,2),C{2}(:,3),'r.')

for i=1:length(C{1}(:,2))
   
    text(C{1}(i,2),C{1}(i,3),num2str(C{1}(i,1)))
    
end

% for i=1:length(C{2}(:,2))
%    
%     text(C{2}(i,2),C{2}(i,3),num2str(C{2}(i,1)))
%     
% end

[nodosContacto1, numeroNodo] = nodesContact('presion2D.txt', 'contacto.inp');

% Hacer una matriz sparse de la misma dimension que K con 1 en 
% (gdl_1,gdl_1) y (gdl_2,gdl_2) y -1 en (gdl_1,gdl_2) y (gdl_2,gdl_1)

% TRANSFORMAR PRIMERO A MODO MATLAB COMO LAS CONDICIONES DE CONTORNO Y
% COGER LA VERTICAL (en este caso es el 2) 

nodosContacto1_matlab = 2*(nodosContacto1-1) + 2;
numeroNodo_matlab = 2*(numeroNodo-1) + 2;

i = [nodosContacto1_matlab; numeroNodo_matlab; nodosContacto1_matlab; numeroNodo_matlab];
j = [nodosContacto1_matlab; numeroNodo_matlab; numeroNodo_matlab; nodosContacto1_matlab];
v = [ones(2*length(nodosContacto1_matlab),1); -1*ones(2*length(nodosContacto1_matlab),1)];

Kc = sparse(i,j,v, size(K,1),size(K,2));

k_contacto = 1e11;

% La friccion se incluye igual pero solo en los horizontales (en 2D) para
% 3D habria que saber la direccion de deslizamiento 

nodosContacto1_matlab = 2*(nodosContacto1-1) + 1; % los horizontales
numeroNodo_matlab = 2*(numeroNodo-1) + 1;

K_mu = sparse(nodosContacto1_matlab,numeroNodo_matlab,ones(length(nodosContacto1_matlab),1), size(K,1),size(K,2));

mu = 0.3;

K = K + k_contacto*Kc + mu*k_contacto*K_mu;

[~, lambda]=eigs(K,M,10,'sm'); 
omega = lambda.^0.5/(2*pi);
omega = real(omega(:));
omega = omega(omega > 1);

omega = sort(omega);

fprintf('Frecuencias naturales con contacto \n')
X = sprintf('%0.3f\n',omega);
disp(X)

