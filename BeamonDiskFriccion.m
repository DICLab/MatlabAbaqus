% IMPORTAR MATRICES K Y M, APLICAR CONDICIONES DE CONTORNO Y CALCULAR
% FRECUENCIAS NATURALES Y MODOS

% Importa nodo1 gdl nodo2 gdl valor. 
% Usa 3*(nodo1-1)+gdl para pasar a gdlGlobal1 gdlGlobal2 valor

clear
clc

% Beam on disk. Importar matrices del sistema libre

K = import_matrix3D('libreMatrices_STIF1.mtx');
M = import_matrix3D('libreMatrices_MASS1.mtx');


%%%%%%%%%%%%%%%%%%%%%%%%%%% CONDICIONES DE CONTORNO %%%%%%%%%%%%%%%%%%%%%%%

% Para aplicar bien las condiciones de contorno exportar en Abaqus con "Do 
% not use parts and assembly in input"

% Nodos de las condiciones de contorno. Aparecen en el inp. 
% Set-1 quitarle x e y, mantener z
% Set-4 empotramiento
 

viga =  [181, 182, 183, 184, 185, 186, 187, 188, 189, 601, 602, 603, 604, 609, 610, 611 ...
 614, 615, 616, 619, 620];

empotramiento =    [622,  623,  624,  625,  626,  627,  628,  629,  630,  631,  632,  633,  930,  931, 2287, 2288 ...
 2289, 2290, 2291, 2292, 2293, 2294, 2295, 2296, 2297, 2298, 2595, 2596, 3954, 3957, 3960, 3962 ...
 3976, 3977, 3979, 3982, 3985, 3989, 4151, 4152, 4155, 4360, 4365, 4367, 4369, 4372, 4375, 4479 ...
 4482, 4486, 4689, 4694, 4695, 5008, 5009, 5012, 5102, 5103, 5105, 5108, 5111, 5115, 5126, 5127 ...
 5130, 5133, 5136, 5138, 8876, 8877];

% Pasar las BCs a modo Matlab

empotramiento = [3*(empotramiento-1)+1, 3*(empotramiento-1)+2, 3*(empotramiento-1)+3];
viga = [3*(viga-1)+1, 3*(viga-1)+2];

BC = [empotramiento, viga];

BC = sort(BC,'descend');

K(BC,:)=[];
K(:,BC)=[];

M(BC,:)=[];
M(:,BC)=[];


%%%%%%%%%% Frecuencias naturales y modos del sistema original %%%%%%%%%%%%

[phi, lambda]=eigs(K,M,20,'sm'); 
omega = lambda.^0.5/(2*pi);
omega = real(omega(:));
omega = omega(omega > 1);

omega = sort(omega);

X = sprintf('%0.3f\n',omega);
disp(X)

[nodosContacto, numeroNodo, alfa] = nodesContact('presionBeam.txt', 'beamSinAssembly.inp');


% Hacer una matriz sparse de la misma dimension que K con 1 en 
% (gdl_1,gdl_1) y (gdl_2,gdl_2) y -1 en (gdl_1,gdl_2) y (gdl_2,gdl_1)

% TRANSFORMAR PRIMERO A MODO MATLAB COMO LAS CONDICIONES DE CONTORNO Y
% COGER LA VERTICAL (en este caso es el 3) 

nodosContacto1_matlab = 3*(nodosContacto-1) + 3;
numeroNodo_matlab = 3*(numeroNodo-1) + 3;

i = [nodosContacto1_matlab; numeroNodo_matlab; nodosContacto1_matlab; numeroNodo_matlab];
j = [nodosContacto1_matlab; numeroNodo_matlab; numeroNodo_matlab; nodosContacto1_matlab];
v = [ones(2*length(nodosContacto1_matlab),1); -1*ones(2*length(nodosContacto1_matlab),1)];

Kc = sparse(i,j,v, size(K,1),size(K,2));

k_contacto = 1e10;

K = K + k_contacto*Kc;

[~, lambda]=eigs(K,M,20,'sm'); 

omega = lambda.^0.5; % Me dan cambiados el real y el imaginario por el tema de la raiz
omega = real(omega(:))/(2*pi);
omega = omega(omega > 1);
omega = sort(omega);

fprintf('Frecuencias naturales con contacto \n')
X = sprintf('%0.3f\n',omega);
disp(X)

%%%%%%%%%%%%%%%%%%%  TODO: DIRECCIONES DE DESLIZAMIENTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% La friccion se incluye como acoplamiento entre gdl vertical y gdl
% horizontal, tendra un termino (gdl_H1, gdl_V1) en una pieza y
% (gdl_H2,gdl_V2)en la otra (gdl_H1, gdl_V1) = - (gdl_H2,gdl_V2)
% (numero de fila = gdl horizontal, numero de columna gdl vertical)

nodosContacto1_matlab_Hor = [3*(nodosContacto-1) + 1; 3*(nodosContacto-1) + 2]; 
numeroNodo_matlab_Hor = [3*(numeroNodo-1) + 1; 3*(numeroNodo-1) + 2];

i = [nodosContacto1_matlab_Hor; numeroNodo_matlab_Hor]; % numero de fila = gdl horizontal
j = [nodosContacto1_matlab; nodosContacto1_matlab; numeroNodo_matlab; numeroNodo_matlab]; % numero de columna = gdl vertical
v = [ones(length(nodosContacto1_matlab_Hor),1); -1*ones(length(nodosContacto1_matlab_Hor),1)]; % la primera pieza positiva y la segunda negativa

% primera aproximacion para introducir el contacto! 

K_mu = sparse(i,j,v, size(K,1),size(K,2));

mu = 0.3;

K = K + mu*k_contacto*K_mu; % porque K ya incluye el contacto

[~, lambda]=eigs(K,M,20,'sm'); 

omega = lambda.^0.5; % Me dan cambiados el real y el imaginario por el tema de la raiz
omega = real(omega(:))/(2*pi);
omega = omega(omega > 1);
omega = sort(omega);

fprintf('Frecuencias naturales con friccion \n')
X = sprintf('%0.3f\n',omega);
disp(X)

% Falta tener en cuenta las direcciones de deslizamiento. De momento se 
% supone que afecta por igual la friccion a los dos gdl horizontales y que 
% en un pieza todos los terminos son negativos y en la otra todos
% positivos. Esto dependera de las direcciones de deslizamiento



