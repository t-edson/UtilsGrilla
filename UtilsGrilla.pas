{
DESCRIPCIÓN
Incluye la definición del objeto TUtilGrilla, con rutinas comunes para el manejo de
grillas. Se incluye TUtilGrilla en esta unidad separada de BasicGrilla, porque incluye a
FrameUtilsGrilla, que depende también de BasicGrilla.

CAMBIOS EN LA VERSIÓN 0.5
Se pasa a usar el campo Object[] de la columna cero, para TUtilGrillaFil. Ya no se usa la
columna 3.
Se crea la opción "OpSelMultiFila", para permitir seleccionar múltiples filas en
TUtilGrillaFil.
Se incluye el método EsFilaSeleccionada() en TUtilGrillaFil, para determinar si una fila
está seleccionada o no.
Se agrega el método TUtilGrillaFil.AgrEncabIco(), para agregar columnas con íconos.
Se agrega el campo TUtilGrillaFil.ImageList, para poder asignar una lista de imágenes
a mostrar en las columnas de tipo ICO.

CAMBIOS EN LA VERSIÓN 0.4
Se crea el campo TugGrillaCol.idx
Se crean los métodos AgrEncabTxt() y AgrEncabNum()
Se cambia el tipo que devuelve AgrEncab(). Ahora devuelve TugGrillaCol.
}
unit UtilsGrilla;
{$mode objfpc}{$H+}
interface
uses
  Classes, windows, SysUtils, fgl, Grids, Clipbrd, Menus, Controls, ComCtrls,
  Graphics, LCLProc, BasicGrilla;
const
  ALT_FILA_DEF = 22;          //Altura por defecto para las grillas de datos
type
  TugTipoCol = (
    tugTipText,  //columna de tipo texto
    tugTipNum,   //columna de tipo numérico
    tugTipIco    //columna de tipo ícono
  );

  {Representa a una columna de la grilla}
  TugGrillaCol = class
    nomCampo: string;     //Nombre del campo de la grilla
    ancho   : integer;    //Ancho físico de la columna de la grilla
    visible : boolean;    //Permite coultar la columna
    alineam : TAlignment; //Alineamiento del campo
    iEncab  : integer;    //índice a columna de la base de datos o texto
    tipo    : TugTipoCol; //Tipo de columna
    idx     : integer;    //Índice dentro de su contenedor
  end;
  TGrillaDBCol_list =   specialize TFPGObjectList<TugGrillaCol>;

  TEvMouseGrillaDB = procedure(Button: TMouseButton; row, col: integer) of object;

  { TUtilGrilla }
{Este es el objeto principal de la unidad. TUtilGrilla, permite administrar una grilla
 de tipo TStringGrid, agregándole funcionalidades comunes, como el desplazamiento de
 teclado o la creación sencilla de encabezados. Para trabajar con una grilla se tiene
 dos formas:

1. Asociándola a una grilla desde el inicio:

   UtilGrilla.IniEncab;
   UtilGrilla.AgrEncab('CAMPO1' , 40);  //Con 40 pixeles de ancho
   UtilGrilla.AgrEncab('CAMPO2' , 60);  //Con 60 pixeles de ancho
   UtilGrilla.AgrEncab('CAMPO3' , 35, -1, taRightJustify); //Justificado a la derecha
   UtilGrilla.FinEncab;

2. Sin asociarla a una UtilGrilla:

   UtilGrilla.IniEncab;
   UtilGrilla.AgrEncab('CAMPO1' , 40);  //Con 40 pixeles de ancho
   UtilGrilla.AgrEncab('CAMPO2' , 60);  //Con 60 pixeles de ancho
   UtilGrilla.AgrEncab('CAMPO3' , 35, -1, taRightJustify); //Justificado a la derecha
   UtilGrilla.FinEncab;

En esta segunda forma, se debe asociar posteriormente a la UtilGrilla, usando el método:
   UtilGrilla.AsignarGrilla(MiGrilla);

, haciendo que la grilla tome los encabezados que se definieron en "UtilGrilla". De esta
forma se pueden tener diversos objetos TUtilGrilla, para usarse en un solo objeto
TStringGrid.
}
  TUtilGrillaBase = class
  protected  //campos privados
    FMenuCampos   : boolean;
    PopupCampos   : TPopupMenu;  //Menú contextual para mostrar/ocultar campos
    popX, popY    : integer;     //posición donde se abre el menú contextual
    procedure DimensColumnas;
    procedure SetMenuCampos(AValue: boolean);
    procedure grillaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grillaKeyPress(Sender: TObject; var Key: char);
    procedure grillaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grillaPrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
    procedure itClick(Sender: TObject);
  private  //Getters and Setters
    FOpOrdenarConClick: boolean;
    FOpAutoNumeracion: boolean;
    FOpDimensColumnas: boolean;
    FOpEncabezPulsable: boolean;
    FOpResaltarEncabez: boolean;
    FOpResaltFilaSelec: boolean;
    procedure SetOpDimensColumnas(AValue: boolean);
    procedure SetOpAutoNumeracion(AValue: boolean);
    procedure SetOpEncabezPulsable(AValue: boolean);
    procedure SetOpOrdenarConClick(AValue: boolean);
    procedure SetOpResaltarEncabez(AValue: boolean);
    procedure SetOpResaltFilaSelec(AValue: boolean);
  public
    grilla: TStringGrid;  //referencia a la grila de trabajo
    cols          : TGrillaDBCol_list;  //Información sobre las columnas
    PopUpCells: TPopupMenu;  //Menú para las celdad
    OnKeyDown: TKeyEvent; {Se debe usar este evento en lugar de usar directamente
                           el evento de la grilla, ya que TGrillaDB, usa ese evento.}
    OnKeyPress: TKeyPressEvent; {Se debe usar este evento en lugar de usar directamente
                           el evento de la grilla, ya que TGrillaDB, usa ese evento.}
//    OnDblClick: TKeyPressEvent; {Se debe usar este evento en lugar de usar directamente
//                         el evento de la grilla, ya que TGrillaDB, usa ese evento.}
    OnMouseUp: TMouseEvent;
    OnMouseUpHeader: TEvMouseGrillaDB;
    OnMouseUpCell: TEvMouseGrillaDB;
    //Definición de encabezados
    procedure IniEncab;
    function AgrEncab(titulo: string; ancho: integer; indColDat: int16=-1;
      alineam: TAlignment=taLeftJustify): TugGrillaCol;
    function AgrEncabTxt(titulo: string; ancho: integer; indColDat: int16=-1
      ): TugGrillaCol;
    function AgrEncabNum(titulo: string; ancho: integer; indColDat: int16=-1
      ): TugGrillaCol;
    procedure FinEncab(actualizarGrilla: boolean=true);
    procedure AsignarGrilla(grilla0: TStringGrid); virtual;  //Configura grilla de trabajo
  public //Opciones de la grilla
    property MenuCampos: boolean     //Activa el menú contextual
             read FMenuCampos write SetMenuCampos;
    property OpDimensColumnas: boolean  //activa el dimensionamiento de columnas
             read FOpDimensColumnas write SetOpDimensColumnas;
    property OpAutoNumeracion: boolean  //activa el autodimensionado en la columna 0
             read FOpAutoNumeracion write SetOpAutoNumeracion;
    property OpResaltarEncabez: boolean  //Resalta el encabezado, cuando se pasa el mouse
             read FOpResaltarEncabez write SetOpResaltarEncabez;
    property OpEncabezPulsable: boolean  //Permite pulsar sobre los encabezados como botones
             read FOpEncabezPulsable write SetOpEncabezPulsable;
    property OpOrdenarConClick: boolean  //Ordenación de filas pulsando en los encabezados
             read FOpOrdenarConClick write SetOpOrdenarConClick;
    property OpResaltFilaSelec: boolean  //Resaltar fila seleccionada
             read FOpResaltFilaSelec write SetOpResaltFilaSelec;
  public //funciones auxiliares
    procedure CopiarCampo;  //copia valor de la celda al portapapeles
    procedure CopiarFila;   //copia valor de la fila al portapapeles
  public //Constructor y destructor
    constructor Create(grilla0: TStringGrid); virtual;
    destructor Destroy; override;
  end;

const
  MAX_UTIL_FILTROS = 10;

type
  TUtilProcFiltro = function(const f: integer):boolean of object;
  {Se crea una clase derivada, para agregar funcionalidades de filtro}
  TUtilGrilla = class(TUtilGrillaBase)
  private
    procedure FiltrarFila(f: integer);
  public
    {Se usa una matriz estática para almacenar a los filtros, para hacer el proceso,
    de filtrado más rápido, ya que se iterará por cada fila de la grilla .}
    filtros: array[0..MAX_UTIL_FILTROS-1] of TUtilProcFiltro;
    numFiltros: integer;
    filVisibles: integer;
    procedure LimpiarFiltros;
    function AgregarFiltro(proc: TUtilProcFiltro): integer;
    procedure Filtrar;
  public
    constructor Create(grilla0: TStringGrid); override;
  end;

  { TUtilGrillaFil }
  {Similar a "TUtilGrilla", pero está orientada a trabajar con datos como filas, más que
  como celdas.
  Además permite cambiar atributos de las filas, como color de fondo, color de texto, etc.
  Para almacenar los atributos de las filas, no crea nuevas variables, sino que usa la
  propiedad "Object", de las celdas, usando las columnas como campos de propiedades para
  la fila. El uso de las columnas es como se indica:
    * Colunna 0-> Almacena el color de fondo de la fila.
    * Colunna 1-> Almacena el color del texto de la fila.
    * Colunna 2-> Almacena los atributos del texto de la fila.
  Por lo tanto se deduce que para manejar estas propiedades, la grilla debe tener las
  columnas necesarias.
  }
  TUtilGrillaFil = class(TUtilGrilla)
  private
    FOpSelMultiFila: boolean;
    procedure DibCeldaTexto(aCol, aRow: Integer; const aRect: TRect);
    procedure DibCeldaIcono(aCol, aRow: Integer; const aRect: TRect);
    procedure grillaDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState); virtual;
    procedure SetOpSelMultiFila(AValue: boolean);
  public //Opciones de la grilla
    property OpSelMultiFila: boolean  //activa el dimensionamiento de columnas
             read FOpSelMultiFila write SetOpSelMultiFila;
  public
    ImageList: TImageList;   //referecnia a un TInageList, para los íconos
    function AgrEncabIco(titulo: string; ancho: integer; indColDat: int16=-1
      ): TugGrillaCol;
    procedure AsignarGrilla(grilla0: TStringGrid); override;  //Configura grilla de trabajo
    procedure FijColorFondo(fil: integer; color: TColor);  //Color de fondo de la fila
    procedure FijColorFondoGrilla(color: TColor);
    procedure FijColorTexto(fil: integer; color: TColor);  //Color del texto de la fila
    procedure FijColorTextoGrilla(color: TColor);
    procedure FijAtribTexto(fil: integer; negrita, cursiva, subrayadao: boolean);  //Atributos del texto de la fila
    procedure FijAtribTextoGrilla(negrita, cursiva, subrayadao: boolean);  //Atributos del texto de la fila
    function EsFilaSeleccionada(const f: integer): boolean;
  public //Constructor y destructor
    constructor Create(grilla0: TStringGrid); override;
  end;

implementation
procedure TUtilGrillaBase.grillaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT] then begin
    //Corrige un comportamiento anómalo de la selección: Cuando se tienen seleccionados
    //varios rangos y se mueve la selecció, los otros rangos no desaparecen.
    if grilla.SelectedRangeCount>1 then begin
      grilla.ClearSelections;
    end;
  end;
  ProcTeclasDireccion(grilla, Key, SHift, ALT_FILA_DEF);
  //Dispara evento
  if OnKeyDown<>nil then OnKeyDown(Sender, Key, Shift);
end;
procedure TUtilGrillaBase.grillaKeyPress(Sender: TObject; var Key: char);
begin
  //Dispara evento
  if OnKeyPress<>nil then OnKeyPress(Sender, Key);
end;
procedure TUtilGrillaBase.grillaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  coordMouse: TPoint;
  it: TMenuItem;
  i: Integer;
  col, row: integer;
  gz: TGridZone;
begin
  //Pasa el evento
  if OnMouseUp<>nil then OnMouseUp(Sender, Button, Shift, X, Y);
  //Verifica posición en donde se soltó el mouse
  coordMouse := grilla.ScreenToClient(Mouse.CursorPos);
  col := grilla.MouseToCell(coordMouse).x;
  row := grilla.MouseToCell(coordMouse).y;
  gz := grilla.MouseToGridZone(coordMouse.x, coordMouse.y);
  if gz = gzFixedCols then begin
    //Es el encabezado
    if OnMouseUpHeader<>nil then OnMouseUpHeader(Button, row, col);
    if FMenuCampos and (Button = mbRight) then begin
      {Se ha configurado un menú contextual para los campos.}
      //Configura el menú
      PopupCampos.Items.Clear;
      for i:=0 to cols.Count-1 do begin
        it := TMenuItem.Create(PopupCampos.Owner);
        it.Caption:=cols[i].nomCampo;
        it.Checked := cols[i].visible;
        it.OnClick:=@itClick;
        PopupCampos.Items.Add(it);
      end;
      //Muestra
      popX := Mouse.CursorPos.x;
      popY := Mouse.CursorPos.y;
      PopupCampos.PopUp(popX, popY);
    end;
  end else if gz = gzFixedRows then begin
    //En columnas fijas
  end else begin
    //Es una celda común o enposición inválida
    if Button = mbRight then begin
      //Implementa la selección con botón derecho
      grilla.Row:=row;
      grilla.Col:=col;
      if PopUpCells<>nil then PopUpCells.PopUp;
    end;
    if OnMouseUpCell<>nil then OnMouseUpCell(Button, row, col);
  end;
end;
procedure TUtilGrillaBase.grillaPrepareCanvas(sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
var
  MyTextStyle: TTextStyle;
begin
  //Activa el alineamiento
  if aRow = 0 then exit;  //no cambia el encabezado
  if cols[aCol].alineam <> taLeftJustify then begin
    MyTextStyle := grilla.Canvas.TextStyle;
    MyTextStyle.Alignment := cols[aCol].alineam;
    grilla.Canvas.TextStyle := MyTextStyle;
  end;
end;
procedure TUtilGrillaBase.itClick(Sender: TObject);
{Se hizo click en un ítem del menú de campos}
var
  it: TMenuItem;
  i: Integer;
begin
  it := TMenuItem(Sender);   //debe ser siempre de este tipo
  it.Checked := not it.Checked;
  //Actualiza visibilidad, de acuerdo al menú contextual
  for i:=0 to PopupCampos.Items.Count-1 do begin
    cols[i].visible := PopupCampos.Items[i].Checked;
  end;
  DimensColumnas;  //dimesiona grillas
  PopupCampos.PopUp(popX, popY);  //abre nuevamente, para que no se oculte
end;
procedure TUtilGrillaBase.DimensColumnas;
var
  c: Integer;
begin
  if grilla=nil then exit;
  for c:=0 to cols.Count-1 do begin
    grilla.Cells[c,0] := cols[c].nomCampo;
    if cols[c].visible then  //es visible. Se le asigna ancho
      grilla.ColWidths[c] := cols[c].ancho
    else                //se oculat poniéndole ancho cero.
      grilla.ColWidths[c] := 0;
  end;
end;
procedure TUtilGrillaBase.SetMenuCampos(AValue: boolean);
begin
  //if FMenuCampos=AValue then Exit;
  FMenuCampos:=AValue;
  if grilla<>nil then begin
    //Ya tiene grilla asignada
    if AValue=true then begin
      //Se pide activar el menú contextual
      if PopupCampos<>nil then PopupCampos.Destroy;  //ya estaba creado
      PopupCampos := TPopupMenu.Create(grilla);
    end else begin
      //Se pide desactivar el menú contextual
      if PopupCampos<>nil then PopupCampos.Destroy;
      PopupCampos := nil;
    end;
  end;
end;
procedure TUtilGrillaBase.SetOpDimensColumnas(AValue: boolean);
begin
  FOpDimensColumnas:=AValue;
  if grilla<>nil then begin
    //Ya tiene asignada una grilla
    if AValue then grilla.Options:=grilla.Options + [goColSizing]
    else grilla.Options:=grilla.Options - [goColSizing];
  end;
end;
procedure TUtilGrillaBase.SetOpAutoNumeracion(AValue: boolean);
begin
  FOpAutoNumeracion:=AValue;
  if grilla<>nil then begin
    //Ya tiene asignada una grilla
    if AValue then grilla.Options:=grilla.Options+[goFixedRowNumbering]
    else grilla.Options:=grilla.Options - [goFixedRowNumbering];
  end;
end;
procedure TUtilGrillaBase.SetOpResaltarEncabez(AValue: boolean);
begin
  FOpResaltarEncabez:=AValue;
  if grilla<>nil then begin
    //Ya tiene asignada una grilla
    if AValue then grilla.Options:=grilla.Options+[goHeaderHotTracking]
    else grilla.Options:=grilla.Options - [goHeaderHotTracking];
  end;
end;
procedure TUtilGrillaBase.SetOpEncabezPulsable(AValue: boolean);
begin
  FOpEncabezPulsable:=AValue;
  if grilla<>nil then begin
    //Ya tiene asignada una grilla
    if AValue then grilla.Options:=grilla.Options+[goHeaderPushedLook]
    else grilla.Options:=grilla.Options - [goHeaderPushedLook];
  end;
end;
procedure TUtilGrillaBase.SetOpOrdenarConClick(AValue: boolean);
begin
  FOpOrdenarConClick:=AValue;
  if grilla<>nil then begin
    //Ya tiene asignada una grilla
    grilla.ColumnClickSorts:=AValue;
  end;
end;
procedure TUtilGrillaBase.SetOpResaltFilaSelec(AValue: boolean);
begin
  FOpResaltFilaSelec:=AValue;
  if grilla<>nil then begin
    //Ya tiene asignada una grilla
    if AValue then grilla.Options:=grilla.Options+[goRowHighlight]
    else grilla.Options:=grilla.Options - [goRowHighlight];
  end;
end;
procedure TUtilGrillaBase.IniEncab;
{Inicia el proceso de agregar encabezados a la grilla.}
begin
  cols.Clear;   //Limpia información de columnas
end;
function TUtilGrillaBase.AgrEncab(titulo: string; ancho: integer; indColDat: int16 =-1;
    alineam: TAlignment = taLeftJustify): TugGrillaCol;
{Agrega una celda de encabezado a la grilla y devuelve el campo creado. Esta
función debe ser llamada después de inicializar los enbezados con IniEncab.
Sus parámetros son:
* titulo -> Es el título que aparecerá en la fila de encabezados.
* ancho -> Ancho en pixeles de la columna a definir.
* indColDat -> Número de columna, de una fuente de datos, de donde se leerá este campo}
var
  col: TugGrillaCol;
begin
  //Agrega información de campo
  col := TugGrillaCol.Create;
  col.nomCampo:= titulo;
  col.ancho   := ancho;
  col.visible := true;  //visible por defecto
  col.alineam := alineam;
  col.iEncab  := indColDat;
  col.tipo    := tugTipText;  //texto por defecto
  col.idx     := cols.Count;
  cols.Add(col);
  Result := col;  //columna usada
end;
function TUtilGrillaBase.AgrEncabTxt(titulo: string; ancho: integer;
  indColDat: int16=-1): TugGrillaCol;
{Crea encabezado de tipo texto. Devuelve el número de columna usada. }
begin
  Result := AgrEncab(titulo, ancho, indColDat);
end;
function TUtilGrillaBase.AgrEncabNum(titulo: string; ancho: integer;
  indColDat: int16=-1): TugGrillaCol;
{Crea encabezado de tipo numérico. Devuelve el número de columna usada. }
begin
  Result := AgrEncab(titulo, ancho, indColDat, taRightJustify);
  Result.tipo := tugTipNum;
end;
procedure TUtilGrillaBase.FinEncab(actualizarGrilla: boolean = true);
begin
  if actualizarGrilla and (grilla<>nil) then begin
      //Configura las columnas
      grilla.FixedCols:= 1;  //columna de cuenta de filas
      grilla.RowCount := 1;
      grilla.ColCount:=cols.Count;   //Hace espacio
      DimensColumnas;
  end;
end;
procedure TUtilGrillaBase.AsignarGrilla(grilla0: TStringGrid);
{Asigna una grilla al objeto GrillaDB. Al asignarle una nueva grilla, la configura
de acuerdo a los encabezados definidos para este objeto. Se define esta rutina de forma
separada al constructor para poder ejecutarla posteroiormente y tener la posibilidad de
poder cambiar de grilla. Poder cambiar de grilla, nos permite reutilizar una misma grilla
para mostrar información diversa.
Si solo se va a trabajar con una grilla. No es necesario usar este método. Bastará con la
definición de ña grilla en el constructor.}
begin
  grilla := grilla0;
  if cols.Count>0 then  //se han definido columnas
    FinEncab(true);  //configura columnas de la grilla
  //Actualiza menú contextual
  SetMenuCampos(FMenuCampos);
  //Actualiza opciones
  SetOpDimensColumnas(FOpDimensColumnas);
  SetOpAutoNumeracion(FOpAutoNumeracion);
  SetOpResaltarEncabez(FOpResaltarEncabez);
  SetOpEncabezPulsable(FOpEncabezPulsable);
  SetOpOrdenarConClick(FOpOrdenarConClick);
  SetOpResaltFilaSelec(FOpResaltFilaSelec);
  //Configura eventos
  grilla.OnPrepareCanvas:=@grillaPrepareCanvas;
  grilla.OnKeyDown:=@grillaKeyDown;
  grilla.OnKeyPress:=@grillaKeyPress;
  grilla.OnMouseUp:=@grillaMouseUp;
end;
procedure TUtilGrillaBase.CopiarCampo;
begin
  if grilla.Row = -1 then exit;
  if grilla.Col = -1 then exit;
  Clipboard.AsText:=grilla.Cells[grilla.Col, grilla.Row];
end;
procedure TUtilGrillaBase.CopiarFila;
var
  tmp: String;
  c: Integer;
begin
  if grilla.Row = -1 then exit;
  if grilla.Col = -1 then exit;
  tmp := grilla.Cells[1, grilla.Row];
  for c:=2 to grilla.ColCount-1 do tmp := tmp + #9 + grilla.Cells[c, grilla.Row];
  Clipboard.AsText:=tmp;
end;
//Constructor y destructor
constructor TUtilGrillaBase.Create(grilla0: TStringGrid);
begin
  cols:= TGrillaDBCol_list.Create(true);
  //Configura grilla
  if grilla0<>nil then AsignarGrilla(grilla0);
end;
destructor TUtilGrillaBase.Destroy;
begin
  cols.Destroy;
  //Elimina menú. Si se ha creado
  if PopupCampos<>nil then PopupCampos.Destroy;
  inherited Destroy;
end;
{ TUtilGrilla }
procedure TUtilGrilla.LimpiarFiltros;
{Elimina todos los filtros}
begin
   numFiltros := 0;
end;
function TUtilGrilla.AgregarFiltro(proc: TUtilProcFiltro): integer;
{Agrega un filtro al arreglo. Devuelve el índice.}
begin
  if numFiltros+1>MAX_UTIL_FILTROS then exit;
  filtros[numFiltros] := proc;
  Result := numFiltros;
  inc(numFiltros);
end;
procedure TUtilGrilla.FiltrarFila(f: integer);
var
  n: Integer;
begin
  //Los filtros se aplican en modo AND, es decir si alguno falla, se oculta
  for n:=0 to numFiltros-1 do begin
    if not Filtros[n](f) then begin
      grilla.RowHeights[f] := 0;
      exit;
    end;
  end;
  //Paso por todos los filtros
  inc(filVisibles);
  grilla.RowHeights[f] := ALT_FILA_DEF;
end;
procedure TUtilGrilla.Filtrar;
{Ejecuta un filtrado, de las filsa de la grilla, uaando los filtros, previamente
agregados a TUtilGrilla}
var
  fil: Integer;
begin
  if grilla=nil then exit;  //protección
  if numFiltros = 0 then begin  //sin filtros
    grilla.BeginUpdate;
    for fil:=1 to grilla.RowCount-1 do begin
      grilla.RowHeights[fil] := ALT_FILA_DEF;
    end;
    grilla.EndUpdate();
    exit;
  end;
  grilla.BeginUpdate;
  filVisibles := 0;
  for fil:=1 to grilla.RowCount-1 do begin
    FiltrarFila(fil);
  end;
  grilla.EndUpdate();
  grilla.row := PrimeraFilaVis(grilla);   //selecciona el primero
end;
constructor TUtilGrilla.Create(grilla0: TStringGrid);
begin
  inherited Create(grilla0);
  LimpiarFiltros;
end;

{ TUtilGrillaFil }
procedure TUtilGrillaFil.DibCeldaIcono(aCol, aRow: Integer; const aRect: TRect);
{Dibuja un ícono alineado en la celda "aRect" de la grilla "Self.grilla", usando el
alineamiento de Self.cols[].}
var
  cv: TCanvas;
  txt: String;
  ancTxt: Integer;
  icoIdx: Integer;
begin
  cv := grilla.Canvas;  //referencia al Lienzo
  if ImageList = nil then exit;
  //Es una celda de tipo ícono
  txt := grilla.Cells[ACol,ARow];
  if not TryStrToInt(txt, icoIdx) then begin //obtiene índice
    icoIdx := -1
  end;
  case cols[aCol].alineam of
    taLeftJustify: begin
      ImageList.Draw(cv, aRect.Left+2, aRect.Top+2, icoIdx);
    end;
    taCenter: begin
      ancTxt := ImageList.Width;
      ImageList.Draw(cv, aRect.Left + ((aRect.Right - aRect.Left) - ancTxt) div 2,
                   aRect.Top + 2, icoIdx);
    end;
    taRightJustify: begin
      ancTxt := ImageList.Width;
      ImageList.Draw(cv, aRect.Right - ancTxt - 2, aRect.Top+2, icoIdx);
    end;
  end;
end;
procedure TUtilGrillaFil.DibCeldaTexto(aCol, aRow: Integer; const aRect: TRect);
{Dibuja un texto alineado en la celda "aRect" de la grilla "Self.grilla", usando el
alineamiento de Self.cols[].}
var
  cv: TCanvas;
  txt: String;
  ancTxt: Integer;
  icoIdx: Integer;
begin
  cv := grilla.Canvas;  //referencia al Lienzo
  txt := grilla.Cells[ACol,ARow];
  //escribe texto con alineación
  case cols[aCol].alineam of
    taLeftJustify: begin
      cv.TextOut(aRect.Left + 2, aRect.Top + 2, txt);
    end;
    taCenter: begin
      ancTxt := cv.TextWidth(txt);
      cv.TextOut(aRect.Left + ((aRect.Right - aRect.Left) - ancTxt) div 2,
                 aRect.Top + 2, txt );
    end;
    taRightJustify: begin
      ancTxt := cv.TextWidth(txt);
      cv.TextOut(aRect.Right - ancTxt - 2, aRect.Top + 2, txt);
    end;
  end;
end;
function TUtilGrillaFil.EsFilaSeleccionada(const f: integer): boolean;
{Indica si la fila "f", está seleccionada.
Se puede usar esta función para determinar las filas seleccionadas de la grilla (en el
caso de que la selección múltiple esté activada), porque hasta la versión actual,
SelectedRange[], puede contener rangos duplicados, si se hace click dos veces en la misma
fila, así que podría dar problemas si se usa SelectedRange[], para hallar las filas
seleccionadas.}
var
  i: Integer;
  sel: TGridRect;
begin
  if not FOpSelMultiFila then begin
    //Caso de selección simple
    exit(f = grilla.Row);
  end;
  //Selección múltiple
  for i:=0 to grilla.SelectedRangeCount-1 do begin
    sel := grilla.SelectedRange[i];
    if (f >= sel.Top) and (f <= sel.Bottom) then exit(true);
  end;
  //No está en ningún rango de selección
  exit(false);
end;
procedure TUtilGrillaFil.grillaDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  cv: TCanvas;           //referencia al lienzo
  atrib: integer;
begin
  cv := grilla.Canvas;  //referencia al Lienzo
  //txt := grilla.Cells[ACol,ARow];
  if gdFixed in aState then begin
    //Es una celda fija
    cv.Font.Color := clBlack;
    cv.Font.Style := [];
    cv.Brush.Color := clBtnFace;
    cv.FillRect(aRect);   //fondo
    DibCeldaTexto(aCol, aRow, aRect);
  end else begin
    //Es una celda común
    cv.Font.Color := TColor(PtrUInt(grilla.Objects[1, aRow]));
    if grilla.Objects[2, aRow]=nil then begin
      //Sin atributos
      cv.Font.Style := [];
    end  else begin
      //Hay atributos de texto
      atrib := PtrUInt(grilla.Objects[2, aRow]);
      if (atrib and 1) = 1 then cv.Font.Style := cv.Font.Style + [fsUnderline];
      if (atrib and 2) = 2 then cv.Font.Style := cv.Font.Style + [fsItalic];
      if (atrib and 4) = 4 then cv.Font.Style := cv.Font.Style + [fsBold];
    end;
    if OpResaltFilaSelec and EsFilaSeleccionada(aRow) then begin
      //Fila seleccionada. (Debe estar activada la opción "goRowHighligh", para que esto funcione bien.)
      cv.Brush.Color := clBtnFace;
    end else begin
      cv.Brush.Color := TColor(PtrUInt(grilla.Objects[0, aRow]));
    end;
    cv.FillRect(aRect);   //fondo
    if cols[aCol].tipo = tugTipIco then
      DibCeldaIcono(aCol, aRow, aRect)
    else
      DibCeldaTexto(aCol, aRow, aRect);
    // Dibuja ícono
{    if (aCol=0) and (aRow>0) then
      ImageList16.Draw(grilla.Canvas, aRect.Left, aRect.Top, 19);}
    //Dibuja borde en celda seleccionada
    if gdFocused in aState then begin
      cv.Pen.Color := clRed;
      cv.Pen.Style := psDot;
      cv.Frame(aRect.Left, aRect.Top, aRect.Right-1, aRect.Bottom-1);  //dibuja borde
    end;
  end;
end;
procedure TUtilGrillaFil.SetOpSelMultiFila(AValue: boolean);
begin
  FOpSelMultiFila:=AValue;
  if grilla<>nil then begin
    //Ya tiene asignada una grilla
    if AValue then grilla.RangeSelectMode := rsmMulti
    else grilla.RangeSelectMode := rsmSingle;
  end;
end;
function TUtilGrillaFil.AgrEncabIco(titulo: string; ancho: integer;
  indColDat: int16): TugGrillaCol;
{Agrega una columna de tipo ícono.}
begin
  Result := AgrEncab(titulo, ancho, indColDat);
  Result.tipo := tugTipIco;
end;
procedure TUtilGrillaFil.AsignarGrilla(grilla0: TStringGrid);
begin
  inherited;
  SetOpSelMultiFila(FOpSelMultiFila);
  //Trabaja con su propia rutina de dibujo
  grilla.DefaultDrawing:=false;
  grilla.OnDrawCell:=@grillaDrawCell;
end;
procedure TUtilGrillaFil.FijColorFondo(fil: integer; color: TColor);
{Fija el color de fondo de la fila indicada. Por defecto es negro.}
begin
  //El color de fondo se almacena en la colunma 1
  if grilla.ColCount<2 then exit;  //protección
  grilla.Objects[0, fil] := TObject(PtrUInt(color));
end;
procedure TUtilGrillaFil.FijColorFondoGrilla(color: TColor);
{Fija el color de fondo de toda la grilla.}
var
  f: Integer;
begin
  if grilla.ColCount<2 then exit;  //protección
  for f:=grilla.FixedRows to grilla.RowCount-1 do begin
    grilla.Objects[0, f] := TObject(PtrUInt(color));
  end;
end;
procedure TUtilGrillaFil.FijColorTexto(fil: integer; color: TColor);
{Fija el color del texto de la fila indicada. Por defecto es negro.}
begin
  //El color de fondo se almacena en la colunma 2
  if grilla.ColCount<3 then exit;  //protección
  grilla.Objects[1, fil] := TObject(PtrUInt(color));
end;
procedure TUtilGrillaFil.FijColorTextoGrilla(color: TColor);
{Fija el color del texto de toda la grilla.}
var
  f: Integer;
begin
  if grilla.ColCount<3 then exit;  //protección
  for f:=grilla.FixedRows to grilla.RowCount-1 do begin
    grilla.Objects[1, f] := TObject(PtrUInt(color));
  end;
end;
procedure TUtilGrillaFil.FijAtribTexto(fil: integer; negrita, cursiva,
  subrayadao: boolean);
{Fija lo satributos del texto de la fila indicada. Por defecto no tiene atributos.}
begin
  //Los atributos se almacenan en la colunma 3
  if grilla.ColCount<4 then exit;  //protección
  grilla.Objects[2, fil] := TObject(ord(negrita)*4+ord(cursiva)*2+ord(subrayadao));
end;
procedure TUtilGrillaFil.FijAtribTextoGrilla(negrita, cursiva,
  subrayadao: boolean);
var
  f: Integer;
begin
  if grilla.ColCount<4 then exit;  //protección
  for f:=grilla.FixedRows to grilla.RowCount-1 do begin
    grilla.Objects[2, f] := TObject(ord(negrita)*4+ord(cursiva)*2+ord(subrayadao));
  end;
end;
constructor TUtilGrillaFil.Create(grilla0: TStringGrid);
begin
  inherited Create(grilla0);
  OpResaltFilaSelec:=true;  //Por defecto trabaja en modo fila
end;

end.

