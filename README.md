UtilsGrilla 0.6
===============

Librería con utilidades para el manejo y configuración de grillas de tipo TStringGrid 

Descripción
===========

La librería consiste en dos unidades y un Frame:

* BasicGrilla.pas -> Rutinas básicas de manejo de la grilla.
* UtilsGrilla.pas -> Definición del objeto TUtilGrilla.
* FrameFiltCampo.pas -> Frame para filtrado de filas.

No todas las unidades tienen que incluirse, Por lo general solo será necesario usar "UtilsGrilla".

## TUtilGrilla ##

La clase principal de la librería es TUtilGrilla. Este objeto es un envoltorio que permite administrar fácilmente una grilla de tipo TStringGrid.

Las facilidades que ofrece TUtilGrilla son:

- Mejora el desplazamiento de teclado, permitiendo usar <Ctrl>+teclas direccionales, para desplazarse hasta los extremos de la grilla.
- Permite la creación sencilla de encabezados. Usando los métodos AgrEncab(), AgrEncabTxt() y AgrEncabNum().
- Permite opciones de alineamiento, del texto dentro de la celda.
- Permite ocultar fácilmente ciertas columnas.
- Permite activar opciones comunes (como el dimensionado del ancho de las columnas), de forma sencilla, sin necesidad de usar conjuntos.
- Permite crear estructuras de encabezados diversas para una misma grilla.
- Permite asociar una columna de uan grilla a un índice, para facilitar la carga de 
campos de tipo texto o de base de datos.
- Brinda un soporte para posteriormente incluir, filtros por filas, en la grilla.

Para trabajar con una grilla se tiene dos formas:

1. Asociándola a una grilla desde el inicio:

```
  UtilGrilla := TUtilGrilla.Create(StringGrid1);
  UtilGrilla.IniEncab;
  UtilGrilla.AgrEncab('CAMPO1' , 40);  //Con 40 pixeles de ancho
  UtilGrilla.AgrEncab('CAMPO2' , 60);  //Con 60 pixeles de ancho
  UtilGrilla.AgrEncab('CAMPO3' , 35, -1, taRightJustify); //Justificado a la derecha
  UtilGrilla.FinEncab;
  ...
```

2. Sin asociarla a una UtilGrilla:

```
  UtilGrilla := TUtilGrilla.Create;
  UtilGrilla.IniEncab;
  UtilGrilla.AgrEncab('CAMPO1' , 40);  //Con 40 pixeles de ancho
  UtilGrilla.AgrEncab('CAMPO2' , 60);  //Con 60 pixeles de ancho
  UtilGrilla.AgrEncab('CAMPO3' , 35, -1, taRightJustify); //Justificado a la derecha
  UtilGrilla.FinEncab;
  ...
```

En esta segunda forma, se debe asociar posteriormente a la UtilGrilla, usando el método:
   UtilGrilla.AsignarGrilla(MiGrilla);

, haciendo que la grilla tome los encabezados que se definieron en "UtilGrilla". De esta forma se pueden tener diversos objetos TUtilGrilla, para usarse en un solo objeto
TStringGrid.

Existen diversas opciones que se pueden cambiar directamente en TUtilGrilla, sin necesidad de configurar al TStringGrid, directamente. 

Algunas de estas opciones son:

  MenuCampos: boolean        //Activa o desactiva el menú contextual
  OpDimensColumnas: boolean  //activa el dimensionamiento de columnas
  OpAutoNumeracion: boolean  //activa el autodimensionado en la columna 0
  OpResaltarEncabez: boolean //Resalta el encabezado, cuando se pasa el mouse
  OpEncabezPulsable: boolean //Permite pulsar sobre los encabezados como botones
  OpOrdenarConClick: boolean //Ordenación de filas pulsando en los encabezados
  OpResaltFilaSelec: boolean //Resaltar fila seleccionada

La propiedad MenuCampos, permite mostrar un menú PopUp, cuando se pulsa el botón derecho sobre la fila de los encabezados de la grilla. Dicho menú permite mostrar u ocultar las columnas de la grilla.

Para el manejo de filtros, TUtilGrilla, incluye los siguientes métodos:

  LimpiarFiltros;  //Elimina todos los filtros internos
  AgregarFiltro(); //Agrega un filtro a TUtilGrilla
  Filtrar;	       //Filtra las filas, usando los filtros ingresados.

Los filtros se ingresan como referencias a funciones que deben devolver TRUE, si la fila pasa el filtro y FALSE, en caso contrario. 

Todos los filtros agregados, se evalúan en cortocicuito, usando el operador AND.


## TUtilGrillaFil ##

![SynFacilCompletion](http://blog.pucp.edu.pe/blog/tito/wp-content/uploads/sites/610/2017/02/Sin-título-1.png "Título de la imagen")

Esta clase es similar a TUtilGrilla, pero se maneja a la grilla, por filas, permitiendo cambiar el color de fondo, del texto o los atributos de las filas, de forma independiente.

Incluye las mismas facilidades de TUtilGrilla, pero adicionalmente:
- Configura la selección por filas, aunque mantiene identificada a la celda seleccionada.
- Permite cambiara atributos de las filas (color de fondo, color de texto y atributos de texto)
- Permite activar y desactivar  la selección múltiple de filas.
- Permite crear columnas que muestren íconos en lugar de texto.

Su uso es similar al de TUtilGrilla:

```
  UtilGrilla:= TUtilGrillaFil.Create(StringGrid1);
  UtilGrilla.IniEncab;
  UtilGrilla.AgrEncabTxt('CAMPO0', 40);  //Con 40 pixeles de ancho
  UtilGrilla.AgrEncabTxt('CAMPO1', 60);  //Con 60 pixeles de ancho
  UtilGrilla.AgrEncabNum('CAMPO2', 60); //Campo numérico, justificado a la derecha
  UtilGrilla.AgrEncabIco('ÍCONO' , 60).alineam:=taCenter; //Ícono centrado
  UtilGrilla.FinEncab;
  UtilGrilla.ImageList := ImageList1;  //Íconos a usar
```

 Para mayor información, se recomienda ver el proyecto ejemplo.


## FrameFiltCampo ##

![SynFacilCompletion](http://blog.pucp.edu.pe/blog/tito/wp-content/uploads/sites/610/2017/02/Sin-título.png "Título de la imagen")

Como un complemento para el manejo de grillas, se incluye el frame FrameFiltCampo.pas, que se comporta como un componente para realizar búsquedas filtrando las filas que no coincidan con el criterio de búsqueda. El algortimo de búsqueda está optimizado para manejar varios miles de filas sin retraso notorio.

Para que un FrameFiltCampo, trabaje como filtro, se puede configurar de dos formas. La forma simple consiste en asociarla directamente a un objeto TUtilGrillaFil:

```
  fraFiltCampo.Inic(UtilGrilla, 4);  
```
  
Esta definición asocia el frame a la grilla, configura todos los campos de la grilla, como parte del filtro, y elige el campo 4 (segundo parámetro), como campo por defecto para el filtro.  

La forma detallada, la que permite más libertad, sería:

```
  fraFiltCampo.Inic(StringGrid1);   //asocia a grilla
  fraFiltCampo.LeerCamposDeGrilla(UtilGrilla.cols, 1);  //configura menú de campos
  UtilGrilla.AgregarFiltro(@fraFiltCampo.Filtro);  //agrega el filtro
```

Adicionalmente, para determinar cuando cambia el filtro (sea porque se ha modificado el texto de búsqueda o se cambia el campo de trabajo), se debe interceptar el método "OnCambiaFiltro". 

```
  fraFiltCampo.OnCambiaFiltro:=@fraFiltCampo_CambiaFiltro;
```

Luego, lo más común sería que este método, llame al método Filtrar() de UtilGrilla.
 
Hay que notar que es posible agregar varios FrameFiltCampo, a un TUtilGrilla, y que funcionen a modo de filtro en cascada.

Si bien fraFiltCampo, se ha creado para trabajar con un objeto TUtilGrilla, también es posible usarlo, con un TStringGrid común:

```
  fraFiltCampo1.Inic(StringGrid1);
  fraFiltCampo1.AgregarColumnaFiltro('Por columna A', 1);
  fraFiltCampo1.AgregarColumnaFiltro('Por columna B', 2);
  fraFiltCampo1.OnCambiaFiltro:=@fraFiltCampo1CambiaFiltro;
```

En este caso habría que implementar en fraFiltCampo1CambiaFiltro(), el código que realice el filtrado sobre la grilla.


