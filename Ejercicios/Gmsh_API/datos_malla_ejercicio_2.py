 # -*- coding: utf-8 -*-

'''
código para obtener los datos de malla del Ejercicio_2_malla.msh
'''

# %% =================== importar las librerías ===============================

import gmsh_api.gmsh as gmsh    # librería de Gmsh-API
import numpy as np              # librería para el manejo de arrays
import matplotlib.pyplot as plt # librería de graficación


# %% =================== código principal =====================================

# nombre del archivo
nombre_archivo = 'Ejercicio_2_malla.msh'


# se inicializa el módulo de gmsh-api
gmsh.initialize()

# se abre el archivo .msh
gmsh.open(nombre_archivo)

# se obtiene las etiquetas y las coordenadas de los nodos de la malla
eti_nodos, coor_nodos, _ = gmsh.model.mesh.getNodes()

# se redimensiona las coordenadas de los nodos
# cada fila representa un nodo, las 3 columnas representan las
# coordenadas x, y, z
coor_nodos = np.reshape(coor_nodos, (-1, 3))


tipo_elemento = 21 # EF triangular

# se obtiene las etiquetas de los elementos y nodos
eti_EFs, eti_nodos_EFs = gmsh.model.mesh.getElementsByType(21)

# etiqueta mínima del tipo de elemento
eti_EFs_min = np.min(eti_EFs)

# se organiza la numeración de los EFs
eti_EFs = eti_EFs - eti_EFs_min + 1

# se redimensiona el array de nodos
eti_nodos_EFs = np.reshape(eti_nodos_EFs, (-1, 10))


# se finaliza el módulo de gmsh-api
gmsh.finalize()


# %% =========== se dibuja la malla de elementos finitos ======================


# solo se toman las componentes en x y y
xnod = coor_nodos[:, [0, 1]]
LaG = eti_nodos_EFs

X, Y = 0, 1
nef = np.size(LaG, 0) # número de EFs
nno = len(eti_nodos) # número de nodos
NL1, NL2, NL3, NL4, NL5, NL6, NL7, NL8, NL9, NL10 = np.arange(10)

cg = np.zeros((nef,2))  # almacena el centro de gravedad de los EF
#                         (se separa la memoria)
plt.figure() # crea un lienzo
for e in range(nef):

#   se dibujan las aristas
    nod_ef = LaG[e, [NL1, NL4, NL5, NL2, NL6, NL7, NL3, NL8, NL9, NL1]] - 1
    # se gráfica el contorno
    plt.plot(xnod[nod_ef, X], xnod[nod_ef, Y], 'b')
#   se calcula la posición del centro de gravedad
    cg[e] = np.mean(xnod[LaG[e] - 1], axis = 0)
#   y se reporta el número del elemento actual
    plt.text(cg[e,X], cg[e,Y], f'{eti_EFs[e]}', horizontalalignment='center',
                                         verticalalignment='center',  color='b',
                                         fontsize=15)



# en todos los nodos se dibuja un marcador y se reporta su numeración
plt.plot(xnod[:, X], xnod[:, Y], 'r*')
for i in range(nno):
#   se pone el número del EF
    plt.text(xnod[i, X], xnod[i, Y], f'{i+1}', color = 'r', fontsize=13)



# se ajusta los ejes
plt.gca().set_aspect('equal', adjustable = 'box')
plt.tight_layout()
plt.title('Malla de elementos finitos', fontsize=15) # título
plt.xlabel('$x$ [m]', fontsize=15) # etiqueta del eje x
plt.ylabel('$y$ [m]', fontsize=15) # etiqueta del eje y
plt.grid('on')                     # crea retícula

plt.show()
