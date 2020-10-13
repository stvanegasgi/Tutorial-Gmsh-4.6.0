// código para generar la geometría del ejercicio 2

// ===========================================================================
// se definen algunas variables
radio = 0.6;
a     = 0.7;
b     = 0.4;
c     = 0.2;
e     = Sqrt(radio^2 - a^2/4);
f     = 0.5;
g     = 0.1;
d     = 2*(e + g);

// y de los puntos 5 y 12
y_1   = -Sqrt(radio^2 - b^2/4);

// ===========================================================================
// se definen etiquetas y entidades

// definen las etiquetas de los puntos y puntos
p_1  = 1;     Point(p_1)  = {   0,       0, 0, 1};
p_2  = newp;  Point(p_2)  = {  -e,     a/2, 0, 1};
p_3  = newp;  Point(p_3)  = {   e,     a/2, 0, 1};
p_4  = newp;  Point(p_4)  = {   e,    -a/2, 0, 1};
p_5  = newp;  Point(p_5)  = { b/2,     y_1, 0, 1};
p_6  = newp;  Point(p_6)  = { b/2,   y_1-f, 0, 1};
p_7  = newp;  Point(p_7)  = {   e,   y_1-f, 0, 1};
p_8  = newp;  Point(p_8)  = { d/2, y_1-f-c, 0, 1};
p_9  = newp;  Point(p_9)  = {-d/2, y_1-f-c, 0, 1};
p_10 = newp;  Point(p_10) = {  -e,   y_1-f, 0, 1};
p_11 = newp;  Point(p_11) = {-b/2,   y_1-f, 0, 1};
p_12 = newp;  Point(p_12) = {-b/2,     y_1, 0, 1};
p_13 = newp;  Point(p_13) = {  -e,    -a/2, 0, 1};


// se define las líneas rectas
L13_2 = 1;    Line(L13_2) = { p_13, p_2};
L3_4  = newl; Line(L3_4)  = {  p_3, p_4};
L5_6  = newl; Line(L5_6)  = {  p_5, p_6};
L6_7  = newl; Line(L6_7)  = {  p_6, p_7};
L7_8  = newl; Line(L7_8)  = {  p_7, p_8};
L8_9  = newl; Line(L8_9)  = {  p_8, p_9};
L9_10 = newl; Line(L9_10) = {  p_9, p_10};
L10_11= newl; Line(L10_11)= { p_10, p_11};
L11_12= newl; Line(L11_12)= { p_11, p_12};
L11_6 = newl; Line(L11_6) = { p_11, p_6};


// se define los arcos
arc_1 = newl; Circle(arc_1) = {p_2, p_1, p_3};
arc_2 = newl; Circle(arc_2) = {p_4, p_1, p_5};
arc_3 = newl; Circle(arc_3) = {p_12, p_1, p_13};


// factor de la curva interior
alpha = 0.3;

// se crea la curva con interpolación Splines
np_1 = 10; // número de puntos curva 1

For t In {0:2*Pi/4:(2*Pi/4)/(np_1-1)}

    etiqueta = newp; // siguiente etiqueta de puntos
    x = alpha*(Cos(t))^3;
    y = alpha*(Sin(t))^3;
    Point(etiqueta) = {x, y, 0, 1};

EndFor

u_punto_1 = etiqueta;

np_2 = 10; // número de puntos curva 2

For t In {2*Pi/4:2*2*Pi/4:(2*2*Pi/4-2*Pi/4)/(np_2-1)}

    etiqueta = newp; // siguiente etiqueta de puntos
    x = alpha*(Cos(t))^3;
    y = alpha*(Sin(t))^3;
    Point(etiqueta) = {x, y, 0, 1};

EndFor

u_punto_2 = etiqueta;

np_3 = 10; // número de puntos curva 3

For t In {2*2*Pi/4:3*2*Pi/4:(3*2*Pi/4-2*2*Pi/4)/(np_3-1)}

    etiqueta = newp; // siguiente etiqueta de puntos
    x = alpha*(Cos(t))^3;
    y = alpha*(Sin(t))^3;
    Point(etiqueta) = {x, y, 0, 1};

EndFor

u_punto_3 = etiqueta;

np_4 = 10; // número de puntos curva 4

For t In {3*2*Pi/4:2*Pi:(2*Pi-3*2*Pi/4)/(np_4-1)}

    etiqueta = newp; // siguiente etiqueta de puntos
    x = alpha*(Cos(t))^3;
    y = alpha*(Sin(t))^3;
    Point(etiqueta) = {x, y, 0, 1};

EndFor

u_punto_4 = etiqueta;

// se crea el Spline
spline_1 = newl;
Spline(spline_1) = {p_13+1:u_punto_1};


spline_2 = newl;
Spline(spline_2) = {u_punto_1:u_punto_2};

spline_3 = newl;
Spline(spline_3) = {u_punto_2:u_punto_3};

spline_4 = newl;
Spline(spline_4) = {u_punto_3:u_punto_4, p_13+1};

// ===========================================================================
// se definen lazos de curva

// se crea el contorno exterior
exte = 1;
Curve Loop(exte) = {L13_2, arc_1, L3_4, arc_2, L5_6, -L11_6, L11_12, arc_3};


// se crea el contorno interior
inte = 2;
Curve Loop(inte) = {spline_1, spline_2, spline_3, spline_4};


// se crea el contorno abajo
abajo = newll;
Curve Loop(abajo) = {L6_7, L7_8, L8_9, L9_10, L10_11, L11_6};

// ===========================================================================
// se define la superficie

// se crea la superficie plana material 1
mate1 = 1;
Plane Surface(mate1) = {exte, inte};


// se crea la superficie plana material 2
mate2 = 2;
Plane Surface(mate2) = {abajo};

// ===========================================================================
// se define grupos físicos

// cargas puntuales
eti_gf_cargas_puntuales = 1;
Physical Point("cargas_puntuales", eti_gf_cargas_puntuales) = {p_3, p_4};

// apoyos
eti_gf_apoyos = 2;
Physical Curve("apoyos", eti_gf_apoyos) = {L8_9};

// carga distribuida
eti_gf_carga_dsitribuida = 3;
Physical Curve("carga_distribuida", eti_gf_carga_dsitribuida) = {arc_1};

// superficie
eti_gf_material_1 = 4;
Physical Surface("material_1", eti_gf_material_1) = {mate1};

// superficie
eti_gf_material_2 = 5;
Physical Surface("material_2", eti_gf_material_2) = {mate2};
