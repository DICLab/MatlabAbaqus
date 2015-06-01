function [nodosContacto, presion] = leerCPRESS(archivo)

% Lee CPRESS de una superficie y devuelve los nodos en 
% contacto para la pieza

% NOTA: de momento el archivo que se lee esta hecho a mano. Hacer un script

archivo = load(archivo);
archivo = archivo(:,[3,4]);

archivo = archivo(archivo(:,2)~=0,:);

archivo= unique(archivo,'rows');

nodosContacto = archivo(:,1);
presion = archivo(:,2);
