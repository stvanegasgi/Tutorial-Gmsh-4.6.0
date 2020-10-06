// código para generar la geometría del ejercicio 1

// ===========================================================================
// se definen algunas variables
radio_interno    =   2;
radio_externo    =   4;
radio_circulo    = 0.3;
radio_medio      = (radio_externo - radio_interno)/2;
eje_mayor_elipse = 0.7;
eje_menor_elipse = 0.4;
radio_cicloide   = 0.5;

a = (radio_externo - radio_interno - 2*radio_circulo)/2;
b = 1.5;   
c = b + eje_mayor_elipse;
d = (radio_externo + radio_interno)/2 - Pi*radio_cicloide;

perimetro_cicloide = 2*Pi*radio_cicloide;

// se define el ángulo donde está el círculo (hueco)
ang = 30*(Pi/180);


// ===========================================================================
// generar etiquetas y entidades

// generar las etiquetas de los puntos exteriores
For i In {1:14}

    p~{i} = i;
    
EndFor

// creación de puntos
//  etiqueta                                                     x                                      y           z  lc 
Point(p_1)  = {                                                      0,                          c + radio_externo, 0, 1};
Point(p_2)  = {                                          radio_externo,                                          c, 0, 1};
Point(p_3)  = {                       radio_externo + eje_menor_elipse,                                          b, 0, 1};
Point(p_4)  = { radio_interno + radio_medio + perimetro_cicloide/2 + d,                                          b, 0, 1};
Point(p_5)  = { radio_interno + radio_medio + perimetro_cicloide/2 + d,                                          0, 0, 1};
Point(p_6)  = { radio_interno + radio_medio + perimetro_cicloide/2    ,                                          0, 0, 1};
Point(p_7)  = { radio_interno + radio_medio - perimetro_cicloide/2    ,                                          0, 0, 1};
Point(p_8)  = { radio_interno + radio_medio - perimetro_cicloide/2 - d,                                          0, 0, 1};
Point(p_9)  = { radio_interno + radio_medio - perimetro_cicloide/2 - d,                                          b, 0, 1};
Point(p_10) = {                       radio_interno - eje_menor_elipse,                                          b, 0, 1};
Point(p_11) = {                                          radio_interno,                                          c, 0, 1};
Point(p_12) = {                                                      0,                          c + radio_interno, 0, 1};
Point(p_13) = {                                                      0,                      c + radio_interno + a, 0, 1};
Point(p_14) = {                                                      0,    c + radio_interno + a + 2*radio_circulo, 0, 1};
 

// creación de etiquetas y puntos de centros
c_arc_1_2 = newp; Point(c_arc_1_2) = { 0,                               c, 0, 1};
c_arc_3   = newp; Point(c_arc_3)   = { 0, c + radio_interno + radio_medio, 0, 1};

// generan puntos de centro de elipses
c_elip_1  = newp; Point(c_elip_1)  = {radio_interno, b, 0, 1};
c_elip_2  = newp; Point(c_elip_2)  = {radio_externo, b, 0, 1};

// creación del hueco
// centro del círculo
c_cir = newp; Point(c_cir)   = {(radio_interno + radio_medio)*Cos(ang), c + (radio_interno + radio_medio)*Sin(ang), 0, 1};
// puntos iniciales y finales
pi_cir = newp; Point(pi_cir) = {(radio_interno + radio_medio)*Cos(ang) + radio_circulo, c + (radio_interno + radio_medio)*Sin(ang), 0, 1};
pf_cir = newp; Point(pf_cir) = {(radio_interno + radio_medio)*Cos(ang) - radio_circulo, c + (radio_interno + radio_medio)*Sin(ang), 0, 1};



// se genera etiquetas para las líneas y las líneas
L1 = newl; Line(L1) = {p_12,  p_13};
L2 = newl; Line(L2) = {p_14,  p_1};
L3 = newl; Line(L3) = {p_3 ,  p_4};
L4 = newl; Line(L4) = {p_4 ,  p_5};
L5 = newl; Line(L5) = {p_5 ,  p_6};
L6 = newl; Line(L6) = {p_7 ,  p_8};
L7 = newl; Line(L7) = {p_8 ,  p_9};
L8 = newl; Line(L8) = {p_9 ,  p_10};


// se genera etiquetas para los arcos de círculo y los arcos
arc_1 = newl; Circle(arc_1) = {p_11, c_arc_1_2,  p_12};
arc_2 = newl; Circle(arc_2) = {p_1,  c_arc_1_2,  p_2};
arc_3 = newl; Circle(arc_3) = {p_13, c_arc_3  ,  p_14};

// se crean los arcos
arc_4 = newl; Circle(arc_4) = {pi_cir, c_cir, pf_cir};
arc_5 = newl; Circle(arc_5) = {pf_cir, c_cir, pi_cir};



// se genera etiquetas para los arcos de elipse y las elipses
elip_1 = newl; Ellipse(elip_1) = {p_10, c_elip_1, p_11, p_11};
elip_2 = newl; Ellipse(elip_2) = {p_2 , c_elip_2,  p_2,  p_3};



// creación del cicloide
np = 25;
For t In {0 :2*Pi :2*Pi/(np - 1)}

    etiqueta = newp;
    Point(etiqueta) = {radio_cicloide*(t - Sin(t)) + d, radio_cicloide*(1 - Cos(t)), 0, 1};
    
    
EndFor

// creación del cicloide como spline
ciclo = newl;
Spline(ciclo) = {p_7, pf_cir+1:pf_cir + np, p_6};




// ===========================================================================
// se crea el ciclo cerrado externo (contorno)
contor = 1;
Curve Loop(contor) = {arc_2, elip_2, L3, L4, L5, -ciclo, L6, L7, L8, elip_1, arc_1, L1, arc_3, L2};

// se crea la curva cerrada del círculo (hueco)
curva_cir = newll;
Curve Loop(curva_cir) = {arc_4, arc_5};



// ===============================================================================
// creación de la superficie
super = 1;
Plane Surface(super) = {contor, curva_cir};


// ===============================================================================
// se crean grupos físicos

// puntos
eti_gf_cargas_puntuales = 1;
Physical Point("carga_puntual", eti_gf_cargas_puntuales) = {p_4};

// curvas (apoyos)
eti_gf_apoyos = 2;
Physical Curve("apoyos", eti_gf_apoyos) = {L1, L2};

// curvas (cargas superficiales)
eti_gf_cargas = 3;
Physical Curve("cargas_superficiales", eti_gf_cargas) = {L5, L6};

// superficie
eti_gf_superficie = 4;
Physical Surface("superficie", eti_gf_superficie) = {super};



// ===============================================================================
// se agregan ejes
General.Axes = 3;



// ===============================================================================
// agregar colores y tamaños

Geometry.PointSize = 4;

Geometry.LineWidth = 5;

Geometry.Color.Points = {255, 0, 0};

Geometry.Color.Lines = {0, 255, 0};


