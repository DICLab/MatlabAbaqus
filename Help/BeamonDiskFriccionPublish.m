%% _Beam-on-disk_ example
% Example of computation of natural frequencies using K and M matrices from
% Abaqus and applying BCs and friction in Matlab

%%% Import K and M matrices
% To export matrices in |.mtx| format from Abaqus the following lines are 
% added to the input file:
%
%%
%  *STEP, name=exportmatrix
%  *MATRIX GENERATE, STIFFNESS, MASS, STRUCTURAL DAMPING
%  *MATRIX OUTPUT, STIFFNESS,MASS, STRUCTURAL DAMPING, FORMAT=MATRIX INPUT
%  *END STEP
%% 
% Then, the matrices are imported using |import_matrix3D| :
%%
%   K = import_matrix3D('libreMatrices_STIF1.mtx');
%   M = import_matrix3D('libreMatrices_MASS1.mtx');
%%
% The DOFs are expressed as |3*(Node-1)+direction|, where |direction={1,2,3}|
%
%%% Boundary conditions
% To avoid problems applying boundary conditions. Check the "Do not use 
% parts and assembly in input" box in Model Attributes. Nodes with BC
% appear in the inp file, find them and paste them making a vector, for
% example: 
%%
% 
%   beam =  [181, 182, 183, 184, 185, 186, 187, 188, 189, 601, 602, 603, 604, 609, 610, 611, 614, 615, 616, 619, 620];
% 
% This BCs have to converted to "Matlab way" with the formula presented
% before. For example, the BCs in the beam restrict movement in the first
% and the second degrees of freedom, so:
%%
%   beam = [3*(beam-1)+1, 3*(beam-1)+2];
%%
% Form a vector with every boundary condition, sort them and erase the
% corresponding rows and columns in |M| and |K| matrices:
%%
% 
%   BC = [disk, beam];
%   BC = sort(BC,'descend');
%
%   K(BC,:)=[];
%   K(:,BC)=[];
%
%   M(BC,:)=[];
%   M(:,BC)=[];
%%
%%% Natural frequencies of the system without contact
% Computation of eigenvalues and natural frequencies from them:
%%
%   [~, lambda] = eigs(K,M,20,'sm'); 
%   omega = lambda.^0.5/(2*pi);
%   omega = real(omega(:));
%   omega = omega(omega > 1);
%   omega = sort(omega);
%%
%%% Contact
% Closest nodes to a surface from the other one are found using
% |nodesContact| function:
%%
%   [nodosContacto, numeroNodo] = nodesContact('presionBeam.txt', 'beamSinAssembly.inp');
%%
% |[nodosContacto, numeroNodo]| are the pair of nodes closest to each
% other.
% 
% Contact stiffness matrix is a sparse matrix the same size as |K| that has
% a |1| un every (dof_1,dof_1) and (dof_2,dof_2) position and a |-1| in the
% (dof_1,dof_2) and (dof_2,dof_1) positions in the vertical direction. It 
% has to be converted to Matlab. In this case the vertical direction is |3|, so : 
%%
% 
%   nodosContacto1_matlab = 3*(nodosContacto-1) + 3;
%   numeroNodo_matlab = 3*(numeroNodo-1) + 3;
%   
%   i = [nodosContacto1_matlab; numeroNodo_matlab; nodosContacto1_matlab; numeroNodo_matlab];
%   j = [nodosContacto1_matlab; numeroNodo_matlab; numeroNodo_matlab; nodosContacto1_matlab];
%   v = [ones(2*length(nodosContacto1_matlab),1); -1*ones(2*length(nodosContacto1_matlab),1)];
%
%   Kc = sparse(i,j,v, size(K,1),size(K,2));
%   k_contacto = 1e10;
%   K = K + k_contacto*Kc;
%% 
% The value |k_contacto| should be tuned using data from FE simulation or experiment.
%%
%%% Natural frequencies of the system with contact
% Natural frequencies are computed the same way as before, using the new
% matrices
%%
%   [~, lambda] = eigs(K,M,20,'sm'); 
%   omega = lambda.^0.5/(2*pi);
%   omega = real(omega(:));
%   omega = omega(omega > 1);
%   omega = sort(omega);
%
%%% Friction
% The contribution of friction to stiffness matrix is a sparse matrix the same size as |K| that 
% couples vertical and horizontal degrees of freedom. It has a |1| in the (dof_H1, dof_V1)
% position in one component and a (dof_H2, dof_V2) = - (dof_H1,dof_V1) term
% in the other component (TODO: sliding directions must be taken into account, for now
% it is supposed that friction affects equally in both directions in the plane). 
% Doing the same as before: 
%%
%   nodosContacto1_matlab_Hor = [3*(nodosContacto-1) + 1; 3*(nodosContacto-1) + 2]; 
%   numeroNodo_matlab_Hor = [3*(numeroNodo-1) + 1; 3*(numeroNodo-1) + 2];
%   
%   i = [nodosContacto1_matlab_Hor; numeroNodo_matlab_Hor]; % row number = horizontal dof
%   j = [nodosContacto1_matlab; nodosContacto1_matlab; numeroNodo_matlab; numeroNodo_matlab]; % column number = vertical dof
%   v = [ones(length(nodosContacto1_matlab_Hor),1); -1*ones(length(nodosContacto1_matlab_Hor),1)]; % first component positive and second negative
%
%   K_mu = sparse(i,j,v, size(K,1),size(K,2));
%   mu = 0.3;
%   K = K + mu*k_contacto*K_mu;
%%
% Now the eigenvalues with friction applied can be computed as explained
% before


