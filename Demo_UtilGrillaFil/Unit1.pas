unit Unit1;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, StdCtrls, UtilsGrilla;
type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    StringGrid1: TStringGrid;
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
  private
    { private declarations }
  public
    UtilGrilla: TUtilGrillaFil;
  end;

var
  Form1: TForm1;

implementation
{$R *.lfm}
{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
begin
  ////////// Configura grilla en modo simple ///////////
  UtilGrilla:= TUtilGrillaFil.Create(StringGrid1);
  UtilGrilla.IniEncab;
  UtilGrilla.AgrEncabTxt('CAMPO0' , 40);  //Con 40 pixeles de ancho
  UtilGrilla.AgrEncabTxt('CAMPO1' , 60);  //Con 60 pixeles de ancho
  UtilGrilla.AgrEncabNum('CAMPO2' , 60); //Campo numérico, justificado a la derecha
  UtilGrilla.AgrEncabIco('ÍCONO' , 60).alineam:=taCenter; //Imagen
  UtilGrilla.FinEncab;
  UtilGrilla.MenuCampos:=true;
  UtilGrilla.OpResaltFilaSelec:=true;
  UtilGrilla.OpSelMultiFila:=true;
  UtilGrilla.ImageList := ImageList1;
  //Llena datos, normalmente
  StringGrid1.RowCount:=6;
  StringGrid1.Cells[0,1] := '1';
  StringGrid1.Cells[1,1] := 'EN';
  StringGrid1.Cells[2,1] := 'LA';
  StringGrid1.Cells[3,1] := '0';

  StringGrid1.Cells[0,2] := '2';
  StringGrid1.Cells[1,2] := 'CASA';
  StringGrid1.Cells[2,2] := 'DE';
  StringGrid1.Cells[3,2] := '1';

  StringGrid1.Cells[0,3] := '3';
  StringGrid1.Cells[1,3] := 'PINOCHO';
  StringGrid1.Cells[2,3] := 'TODOS';

  UtilGrilla.FijColorFondoGrilla(clWhite);
  UtilGrilla.FijColorTexto(2, clRed);
  UtilGrilla.FijColorFondo(3, clYellow);
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  UtilGrilla.OpResaltFilaSelec := CheckBox1.Checked;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  UtilGrilla.OpSelMultiFila := CheckBox2.Checked;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UtilGrilla.Destroy;
end;

procedure TForm1.StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
var
  NumSelec, f: Integer;
begin
  if UtilGrilla.OpSelMultiFila then begin
    //En este caso de selección múltiple, se recomienda hacer toda la exploración
    NumSelec := 0;
    for f := 1 to StringGrid1.RowCount-1 do begin
      if UtilGrilla.EsFilaSeleccionada(f) then inc(NumSelec);
    end;
    Label2.Caption:='Seleccionadas ' + IntToStr(NumSelec) + ' filas';
  end else begin
    Label2.Caption:='Seleccionada la fila: ' + IntToStr(StringGrid1.Row);
  end;
end;

end.

