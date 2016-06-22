UtilsGrilla
==============

Librería con utilidades para el manejo y configuración de grillas de tipo TStringGrid 

== Cambios en la versión 0.4 ==

Se cambia el nombre de la unidad UtilGrilla a UtilsGrilla.
Se crean dos proyectos de ejemplo.
Se cambia de nombre a la clase TGrillaDBCol.
Se agrega el campo "tipo" a la clase TugGrillaCol
Sed crean los métodos AgrEncabTxt() y AgrEncabNum()

== Cambios en la versión 0.3 ==

La unidad UtilsGrilla, se renombra a BasicGrilla.
Se incluyen una nueva unidad UtilGrilla con la definición del objeto TUtilGrilla.

Descripción
===========

La librería consiste en dos unidades y un Frame:

* BasicGrilla.pas -> Rutinas básicas de manejo de la grilla.
* UtilsGrilla.pas -> Definición del objeto TUtilGrilla.
* FrameUtilsGrilla.pas -> Frame para filtrado de filas.

No todas las unidades tienen que incluirse, Por lo general solo será necesario usar "UtilsGrilla".

El frame FrameUtilsGrilla, contiene controles para realizar búsquedas filtrando las filas que no 
coincidan con el criterio de búsqueda. El algortimo de búsqueda está optimizado para manejar 
varios miles de filas sin retraso notorio.

El objeto principal de la unidad es TUtilGrilla. Este objeto permite administrar una grilla
de tipo TStringGrid, agregándole funcionalidades comunes, como el desplazamiento de teclado 
o la creación sencilla de encabezados. Para trabajar con una grilla se tiene dos formas:

1. Asociándola a una grilla desde el inicio:

```
   UtilGrilla.IniEncab;
   UtilGrilla.AgrEncab('CAMPO1' , 40);  //Con 40 pixeles de ancho
   UtilGrilla.AgrEncab('CAMPO2' , 60);  //Con 60 pixeles de ancho
   UtilGrilla.AgrEncab('CAMPO3' , 35, -1, taRightJustify); //Justificado a la derecha
   UtilGrilla.FinEncab;
```

2. Sin asociarla a una UtilGrilla:

```
   UtilGrilla.IniEncab;
   UtilGrilla.AgrEncab('CAMPO1' , 40);  //Con 40 pixeles de ancho
   UtilGrilla.AgrEncab('CAMPO2' , 60);  //Con 60 pixeles de ancho
   UtilGrilla.AgrEncab('CAMPO3' , 35, -1, taRightJustify); //Justificado a la derecha
   UtilGrilla.FinEncab;
```

En esta segunda forma, se debe asociar posteriormente a la UtilGrilla, usando el método:
   UtilGrilla.AsignarGrilla(MiGrilla);

, haciendo que la grilla tome los encabezados que se definieron en "UtilGrilla". De esta
forma se pueden tener diversos objetos TUtilGrilla, para usarse en un solo objeto
TStringGrid.
