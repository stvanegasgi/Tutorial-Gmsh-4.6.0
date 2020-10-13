#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Extracción de datos de la malla del ejercicio 2
"""


#%% ===================== importar módulos ====================================

import numpy as np               # módulo para el manejo de arrays
import matplotlib.pyplot as plt  # módulo de graficación

import gmsh_api.gmsh as gmsh     # librería de Gmsh-API


#%% ================ uso del módulo de gmsh ===================================

# se inicializa el módulo de gmsh-api
gmsh.initialize()

# nombre del archivo de la malla
nombre_archivo = 'Ejercicio_2_malla.msh'

# se abre el archivo de malla
gmsh.open(nombre_archivo)

# obtener etiquetas y coordenadas de los nodos
eti_nodos, coor_nodos, _ = gmsh.model.mesh.getNodes()

coor_nodos = np.reshape(coor_nodos, (-1, 3))

# obtener etiquetas y coordenadas de los nodos
eti_EF, nodos_locales_EF = gmsh.model.mesh.getElementsByType(21)

# mínima etiqueta de los elementos finitos
eti_min_EF = np.min(eti_EF)

# se organiza la numeración para que empiece desde 1
eti_EF = eti_EF - eti_min_EF + 1

# matriz de los nodos locales
nodos_locales_EF = np.reshape(nodos_locales_EF, (-1, 10))

# etiquetas numéricas de los elementos finitos del material 2
tipo, eti_material_2, _ = gmsh.model.mesh.getElements(2, 2)

# grupo físico de la carga distribuida
eti_carga_distrbuida,  _ = gmsh.model.mesh.getNodesForPhysicalGroup(1, 3)

# se organiza para que las etiquetas empiecen en 1
eti_material_2 = eti_material_2 - eti_min_EF + 1

# se finaliza el módulo de gmsh-api
gmsh.finalize()



# %% =========== se dibuja la malla de elementos finitos ======================


# %% se gráfican los nodos de la malla y su numeración

X = 0; Y = 1
nno = len(eti_nodos)
# en todos los nodos se dibuja un marcador y se reporta su numeración
plt.plot(coor_nodos[:, X], coor_nodos[:, Y], 'r*')

for i in range(nno):
#   se pone el número del EF
    plt.text(coor_nodos[i, X], coor_nodos[i, Y], f'{i+1}', color = 'r', fontsize=11)


# %% se gráfican los elementos finitos y su numeración
coor_nodos = coor_nodos[:, [0, 1]]

nef = np.size(nodos_locales_EF, 0) # número de EFs
NL1, NL2, NL3, NL4, NL5, NL6, NL7, NL8, NL9, NL10 = np.arange(10)

cg = np.zeros((nef,2))  # almacena el centro de gravedad de los EF
#                         (se separa la memoria)
for e in range(nef):

#   se dibujan las aristas
    nod_ef = nodos_locales_EF[e, [NL1, NL4, NL5, NL2, NL6, NL7, NL3, NL8, NL9, NL1]] - 1
    # se gráfica el contorno
    plt.plot(coor_nodos[nod_ef, X], coor_nodos[nod_ef, Y], 'b')
#   se calcula la posición del centro de gravedad
    cg[e] = np.mean(coor_nodos[nodos_locales_EF[e] - 1], axis = 0)
#   y se reporta el número del elemento actual
    plt.text(cg[e,X], cg[e,Y], f'{eti_EF[e]}', horizontalalignment='center',
                                         verticalalignment='center',  color='b',
                                         fontsize=15)

# %% se ajustan características del lienzo

# se ajusta los ejes
plt.gca().set_aspect('equal', adjustable = 'box')
plt.tight_layout()
plt.title('Malla de elementos finitos', fontsize=15) # título
plt.xlabel('$x$ [m]', fontsize=15) # etiqueta del eje x
plt.ylabel('$y$ [m]', fontsize=15) # etiqueta del eje y
plt.grid('on')                     # crea retícula



# %% se gráfican los elementos finitos del material 2 y los nodos de la carga
#    distribuida

coor_nodos = coor_nodos[:, [0, 1]]

nef = np.size(nodos_locales_EF, 0) # número de EFs
NL1, NL2, NL3, NL4, NL5, NL6, NL7, NL8, NL9, NL10 = np.arange(10)

plt.figure()
for e in range(nef):

#   se dibujan las aristas
    nod_ef = nodos_locales_EF[e, [NL1, NL4, NL5, NL2, NL6, NL7, NL3, NL8, NL9, NL1]] - 1
    # se gráfica el contorno
    plt.plot(coor_nodos[nod_ef, X], coor_nodos[nod_ef, Y], 'g:')
    
eti_material_2 = np.ndarray.flatten(eti_material_2)
cg = np.zeros((nef,2))  # almacena el centro de gravedad de los EF
#                         (se separa la memoria)
for e in eti_material_2-1:

#   se dibujan las aristas
    nod_ef = nodos_locales_EF[e, [NL1, NL4, NL5, NL2, NL6, NL7, NL3, NL8, NL9, NL1]] - 1
    # se gráfica el contorno
    plt.plot(coor_nodos[nod_ef, X], coor_nodos[nod_ef, Y], 'r')
    #   se calcula la posición del centro de gravedad
    cg[e] = np.mean(coor_nodos[nodos_locales_EF[e] - 1], axis = 0)
#   y se reporta el número del elemento actual
    plt.text(cg[e,X], cg[e,Y], f'{e}', horizontalalignment='center',
                                         verticalalignment='center',  color='b',
                                         fontsize=15)

# nodos del grupo físico de la carga distribuida
plt.plot(coor_nodos[eti_carga_distrbuida-1, X], coor_nodos[eti_carga_distrbuida-1, Y], 'r*')

# %% se ajustan características del lienzo

# se ajusta los ejes
plt.gca().set_aspect('equal', adjustable = 'box')
plt.tight_layout()
plt.title('Malla de elementos finitos', fontsize=15) # título
plt.xlabel('$x$ [m]', fontsize=15) # etiqueta del eje x
plt.ylabel('$y$ [m]', fontsize=15) # etiqueta del eje y
plt.grid('on')                     # crea retícula

plt.show()
