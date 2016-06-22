{Frame que contienen utilidades a realizar sobre grillas TSTringGrid. Actualmente solo se
ha implementado la opción de búsqueda.
Para realizar su trabajo, se debe asociar a un TStringGrid.
Para facilitar el uso de este frame, se ha definido que no tenga más dependencias
especiales que UtilsGrilla.
Además no se debe interceptar eventos de la grilla, a menos que sea estrcitamente necesario.
Estos e hace previeniendo el caso de que la grilla necesite usar sus eventos o estos estén
siendo usados por alguna otra utilidad.

La forma de utilizar el frame, es insertándolo en el formulario o panel, a modo de
ToolBar. Luego configurarlo:

fraUtilsGrilla1.Inic(grilla, ALT_FILA, StatusBar1.Panels[0]);
fraUtilsGrilla1.AgregarColumnaFiltro('Por Código', 1);
fraUtilsGrilla1.AgregarColumnaFiltro('Por Nombre', 2);

También se debe llamar a fraUtilsGrilla1.GridKeyPress(Key), en el evento KeyPress() de la
grilla, si se desea que la búsqueda se haga con solo pulsar una tecla en la grilla.
                                                   Por Tito Hinostroza 28/04/016.
}
unit FrameUtilsGrilla;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, ExtCtrls, LCLProc,
  Graphics, Buttons, LCLType, Grids, fgl, ComCtrls, BasicGrilla;
type
  TFiltroGrilla = class
    etiq: string;   //etiqueta  a mostrar
    campo: integer; //campo a usar como filtro
  end;
  TFiltroGrilla_list = specialize TFPGObjectList<TFiltroGrilla>;

  { TfraUtilsGrilla }
  TfraUtilsGrilla = class(TFrame)
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Panel1: TPanel;
    btnFind: TSpeedButton;
    btnClose: TSpeedButton;

    procedure btnCloseClick(Sender: TObject);

    procedure ComboBox2Change(Sender: TObject);
    procedure AplicarFiltro;
    procedure Edit1Change(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FrameResize(Sender: TObject);
  private
    grilla :TStringGrid;  //grilla asociada
    panel  :TStatusPanel; //panel para mostrar mensajes realtivos al filtrado
    alt_fila: integer;    //alto de las filas
    txt    : string;  //para guardar el contenido del texto
    proteger: boolean;
    filtros : TFiltroGrilla_list;
    procedure ActualizarVisibilidadBotones;
    procedure ModoConTexto(txt0: string);
    procedure ModoSinTexto;
  public
    msjeBuscar: string;   //mensajae inicial que aparecerá en el cuadro de texto
    incluirCateg: boolean;
    filVisibles: Integer;
    OnFiltrado: procedure of object;  //cuando se ha realizado el filtrado de la grilla
    procedure AgregarColumnaFiltro(NomCampo: string; ColCampo: integer);
    procedure Inic(grilla0: TStringGrid; alt_fila0: integer=22; panel0: TStatusPanel
      =nil);
    procedure GridKeyPress(var Key: char);  //Para dejar al frame procesar el evento KeyPress de la grilla
  public  //Constructor y destructor
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation
{$R *.lfm}
{ TfraUtilsGrilla }
procedure TfraUtilsGrilla.ActualizarVisibilidadBotones;
begin
  if txt = '' then begin
    //No tiene contenido
    btnFind.Visible:=true;
    btnClose.Visible:=false;
  end else begin
    //Tiene contendio
    btnFind.Visible:=false;
    btnClose.Visible:=true;
  end;
  //ComboBox2.Enabled := filtros.Count>0;
end;
procedure TfraUtilsGrilla.ModoSinTexto;
//Pone al control de edición en modo "Esperando a que se escriba."
begin
  proteger := true;
  Edit1.Font.Italic := true;
  Edit1.Font.Color := clGray;
  Edit1.Text := msjeBuscar;
  proteger := false;
end;
procedure TfraUtilsGrilla.ModoConTexto(txt0: string);
begin
  proteger := true;
  Edit1.Font.Italic := false;
  Edit1.Font.Color := clBlack;
  Edit1.Text:=txt0;
  proteger := false;
end;
procedure TfraUtilsGrilla.AgregarColumnaFiltro(NomCampo: string;
  ColCampo: integer);
//Agrega un campo para usar como filtro a la lista
var
  fil: TFiltroGrilla;
begin
  fil := TFiltroGrilla.Create;
  fil.etiq  := NomCampo;
  fil.campo := ColCampo;
  filtros.Add(fil);
  ComboBox2.AddItem(NomCampo, nil);
  ComboBox2.ItemIndex:=0;  //selecciona el primero
end;
procedure TfraUtilsGrilla.btnCloseClick(Sender: TObject);  //Limpia texto
begin
  Edit1.Text:= '';
end;
procedure TfraUtilsGrilla.ComboBox2Change(Sender: TObject);
begin
  AplicarFiltro;  //para actualizar la búsqueda
end;
procedure TfraUtilsGrilla.AplicarFiltro;
{Filtra la grilla de acuerdo al contenido de "txt"}
var
  campoAfiltrar: integer;
begin
  ActualizarVisibilidadBotones;
  //Realiza el filtrado de la grilla asociada
  if (grilla <> nil) and (ComboBox2.ItemIndex<>-1) then begin
    campoAfiltrar := filtros[ComboBox2.ItemIndex].campo;
    filVisibles := FiltrarGrilla(grilla, txt, campoAfiltrar, alt_fila);
    //actualiza panel
    if panel <> nil then begin
      if txt = '' then begin
        panel.Text := IntToStr(grilla.RowCount-1) + ' registros.';
      end else begin
        panel.Text := 'Encontrados: ' + IntToStr(filVisibles) + ' de ' + IntToStr(grilla.RowCount-1);
      end;
    end;
    if OnFiltrado<>nil then OnFiltrado;
  end;
end;
procedure TfraUtilsGrilla.Inic(grilla0: TStringGrid; alt_fila0: integer = 22;
                                        panel0: TStatusPanel = nil);
{Prepara al frame para iniciar su trabajo. Notar que para evitar conflictos, se ha
definido que no se intercepten los eventos de la grilla, en este Frame.}
begin
  grilla := grilla0;
  panel := panel0;
  alt_fila := alt_fila0;
  ComboBox2.Clear;
  filtros.Clear;
end;
procedure TfraUtilsGrilla.GridKeyPress(var Key: char);
{Debe ser llamado en el evento OnKeyPress, de la grilla, si se desee que el Frame tome el
 control de este evento, iniciando el filtrado con la tecla pulsada.}
begin
  if Key = #13 then exit;   //este código, no debe ser considerado como tecla de edición
  Edit1.SetFocus;
  Edit1.Text := Key;  //sobreescribe lo que hubiera
  Edit1.SelStart:=length(Edit1.Text);
end;
procedure TfraUtilsGrilla.Edit1Change(Sender: TObject);
begin
  if proteger then exit;   //para no actualizar
  txt := Edit1.Text;
  AplicarFiltro;
end;
procedure TfraUtilsGrilla.Edit1Enter(Sender: TObject);
begin
  //if (txt='') and (Edit1.Text=msjeBuscar) then begin
    ModoConTexto(txt);
  //end;
end;
procedure TfraUtilsGrilla.Edit1Exit(Sender: TObject);
begin
  if txt = '' then begin    //No tiene contenido
    ModoSinTexto;
  end;
  ActualizarVisibilidadBotones;
end;
procedure TfraUtilsGrilla.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN then begin
    if grilla<>nil then grilla.SetFocus;
    //grilla.row := PrimeraFilaVis;
  end;
  if (Key = VK_RETURN) then begin
    //<Enter> pulsado
    if (Shift = []) then begin
      //acHerInsNElemExecute(self);
    end;
    Key := 0;  //para que no llegue a la grilla
  end;
end;
procedure TfraUtilsGrilla.FrameResize(Sender: TObject);
begin
    Panel1.Height:=Edit1.Height;
    Panel1.Left:=0;
    Panel1.Top :=0;
    Panel1.Width:=self.Width - ComboBox2.Width;
    ComboBox2.Top:=0;
    ComboBox2.Left := self.Width - ComboBox2.Width;
    //Edit1.Align:=alClient;
    Edit1.Left := 0;  //a la izquierda, dentro del panel
    Edit1.Width := Panel1.Width - btnClose.Width;  {Se supone que solo habrá un botón
                                                    visible, así que esto debe funcionar}
    Edit1.Top:=2;
end;
constructor TfraUtilsGrilla.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  OnResize:=@FrameResize;
  filtros := TFiltroGrilla_list.Create(true);
  msjeBuscar := 'Texto a buscar';  //Inicia mensaje
  ActualizarVisibilidadBotones;
  ModoSinTexto;
end;
destructor TfraUtilsGrilla.Destroy;
begin
  filtros.Destroy;
  inherited Destroy;
end;

end.

