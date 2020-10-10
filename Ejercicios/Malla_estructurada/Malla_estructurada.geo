// código para generar la geometría y malla estructurada

// ===========================================================================
// se definen algunas variables
r_interno  = 1;
r_externo  = 3;

// ===========================================================================
// se definen etiquetas y entidades

// definen las etiquetas de los puntos y puntos
p_1  = 1;     Point(p_1)  = { -r_externo,     0, 0, 1};
p_2  = newp;  Point(p_2)  = { -r_interno,     0, 0, 1};
p_3  = newp;  Point(p_3)  = {  r_interno,     0, 0, 1};
p_4  = newp;  Point(p_4)  = {  r_externo,     0, 0, 1};
centro = newp; Point(centro) = {0, 0, 0, 1};


// curvas
arco_interior = 1;
Circle(arco_interior) = {p_3, centro, p_2};

arco_exterior = 2;
Circle(arco_exterior) = {p_4, centro, p_1};


// líneas
L1_2 = newl;
Line(L1_2) = {p_1, p_2};

L3_4 = newl;
Line(L3_4) = {p_3, p_4};

// ===========================================================================
// se definen lazos de curva

// se crea el contorno izquierdo
contorno = 1;
Curve Loop(contorno) = {L1_2, -arco_interior, L3_4, arco_exterior};

// ===========================================================================
// se define la superficie

// se crea la superficie plana
superficie = 1;
Plane Surface(superficie) = {contorno};


// ===========================================================================
// se define grupos físicos

// superficie
eti_gf_superficie = 1;
Physical Surface("superficie", eti_gf_superficie) = {superficie};


// ===========================================================================
// generar la malla


Mesh.ElementOrder = 2;
Mesh.Points = 1;
Mesh.SurfaceFaces = 1;
Mesh.Color.Points = {255, 0, 0};
Mesh.Color.PointsSup = {0, 0, 0};

Color {60,230,20} {Surface{superficie};}


Transfinite Curve{L1_2, -L3_4} = 10;
Transfinite Curve{arco_interior, arco_exterior} = 15;

Transfinite Surface{superficie};


Mesh 2;
