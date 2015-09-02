# MatlabAbaqus
In this repository you can find some Matlab code that I've been using
to process Abaqus output, specially any system's K, M and C matrices
and output related to contact. This code was written to apply contact
and boundary conditions to matrices extracted from Abaqus in order to
compute the receptance matrix in Matlab. Using the receptance matrix
some structural modifications could be proposed to shift the natural
frequencies of the system [1]. This part is a WIP at the moment, but
expect to see it in here in the (near) future!


## Content

The content can be divided into two groups:

- The file `Datos`: here you can find Abaqus data from a
  *beam-on-disk* case -- the system's matrices in free conditions,
  contact pressure and inp file. This folder is intended as sample
  data for the Matlab scripts outside.
  

- Some Matlab files for reading and treating data. The mayority of
  them are documented, I hope. Can be divided into the following:

  - `BeamonDiskFriccion.m` is a case example that uses the archives in
    `Datos`
  - Functions for reading matrix output from Abaqus: `import_matrix.m`
    and `import_matrix3D.m`, for 2 and 3D data respectively.
  - Functions for reading contact data: `leerCPRESS.m`,
    `leerContacto.m`
  - Functions for reading substructure data:
    `leerSubs.m`. (`subestructura.m` is a simple script for reading
    substructure matrices and compiting its natural frequencies)
  - Auxiliary functions:
    - `ScriptProfiler.m`: wrapping function for profiling code
	- `nodesContact.m`: gives back closest nodes between two surfaces
    - `nodoMasCercano.m`: computes closest node in a surface from some
      other node
	- `coordenadasInp.m`: reads node coordinates in Abaqus inp file

[1] http://www.sciencedirect.com/science/article/pii/S0888327008002045
