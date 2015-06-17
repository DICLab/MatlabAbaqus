# MatlabAbaqus
In this repository you can find some Matlab code that I've been using to process Abaqus output, specially any system's K, M and C matrices and output related to contact. This code was written to apply contact and boundary conditions to matrices extracted from Abaqus in order to compute the receptance matrix in Matlab. Using the receptance matrix some structural modifications could be proposed to shift the natural frequencies of the system [1]. This part is a WIP at the moment, but expect to see it in here in the (near) future!

## Content

The content can be divided into two groups:

- The file `Datos`: here you can find Abaqus data from a *beam-on-disk* case -- the system's matrices in free conditions, contact pressure and inp file. This folder is intended as sample data for the Matlab scripts outside.

- Some Matlab files for reading and treating data. The mayority of them are documented, I hope. `BeamonDiskFriccion.m` is a case example that uses the archives in `Datos` 

[1] http://www.sciencedirect.com/science/article/pii/S0888327008002045
