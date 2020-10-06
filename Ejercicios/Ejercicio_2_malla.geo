// código para generar la malla del ejercicio 2



// ===========================================================================
// cargar la geometría del ejericicio 2

Include "Ejercicio_2.geo";

// ===========================================================================
// generar la malla


// tamaños y vistas
Mesh.Points       = 1;
Mesh.SurfaceFaces = 1;
Mesh.PointSize    = 5;
Mesh.LineWidth    = 2;

// colores
Mesh.Color.Points = {0, 0, 0};
Mesh.Color.PointsSup = {0, 0, 0};
Color {195,195,195} {Surface{mate1};}
Color {253,188,180} {Surface{mate2};}


// orden del elemento finito
Mesh.ElementOrder = 3;

// longitud característica global
Mesh.CharacteristicLengthFactor = 0.35;


// se refina alrededor de los puntos donde estan las cargas puntuales
Transfinite Curve {L3_4} = 11 Using Bump 0.15;

// cerca a los puntos p_3 y p_4
Transfinite Curve {arc_2} = 6 Using Progression 1.5;
Transfinite Curve {-arc_1} = 12 Using Progression 1.2;



// se refina el límite de cambio de material
Transfinite Curve {-L5_6, L11_12} = 6 Using Progression 1.4;
Transfinite Curve {L11_6} = 8;
// cerca a los puntos 6 y 11
Transfinite Curve {L6_7,-L10_11} = 5 Using Progression 1.3;


// se refina las curvas Splines
Transfinite Curve {spline_1, spline_4} = 7 Using Bump 0.08;
Transfinite Curve {spline_2, spline_3} = 8 Using Bump 0.07;



// se determina el número de vértices
Transfinite Curve {L8_9}  = 9;
Transfinite Curve {L13_2} = 5;



// se crea la malla
Mesh 2;


// se guarda la malla
Save "Ejercicio_2_malla.msh";




