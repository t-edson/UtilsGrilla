unit Unit1;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, StdCtrls, UtilsGrilla;
type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
  public
    UtilGrilla: TUtilGrilla;
    UtilGrilla1: TUtilGrilla;
    UtilGrilla2: TUtilGrilla;
  end;

var
  Form1: TForm1;

implementation
{$R *.lfm}
{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
begin
  ////////// Configura grilla en modo simple ///////////
  UtilGrilla:= TUtilGrilla.Create(StringGrid1);
  UtilGrilla.IniEncab;
  UtilGrilla.AgrEncabTxt('CAMPO0' , 40);  //Con 40 pixeles de ancho
  UtilGrilla.AgrEncabTxt('CAMPO1' , 60);  //Con 60 pixeles de ancho
  UtilGrilla.AgrEncabNum('CAMPO2' , 60); //Campo numérico, justificado a la derecha
  UtilGrilla.AgrEncabNum('CAMPO3' , 60); //Campo numérico, justificado a la derecha
  UtilGrilla.FinEncab;
  UtilGrilla.MenuCampos:=true;
  UtilGrilla.OpResaltFilaSelec:=true;
  //Llena datos, normalmente
  StringGrid1.RowCount:=4;
  StringGrid1.Cells[0,1] := '1';
  StringGrid1.Cells[1,1] := 'EN';
  StringGrid1.Cells[2,1] := 'LA';
  StringGrid1.Cells[0,2] := '2';
  StringGrid1.Cells[1,2] := 'CASA';
  StringGrid1.Cells[2,2] := 'DE';
  StringGrid1.Cells[0,3] := '3';
  StringGrid1.Cells[1,3] := 'PINOCHO';
  StringGrid1.Cells[2,3] := 'TODOS';

  ////////// Crea dos juegos de encabezados ///////////
  UtilGrilla1:= TUtilGrilla.Create(nil);
  UtilGrilla1.IniEncab;
  UtilGrilla1.AgrEncabTxt('NUM' , 40);
  UtilGrilla1.AgrEncabTxt('NOMBRE' , 60);
  UtilGrilla1.AgrEncabTxt('APELLIDO', 80);
  UtilGrilla1.FinEncab;
  UtilGrilla1.MenuCampos:=true;

  UtilGrilla2:= TUtilGrilla.Create(nil);
  UtilGrilla2.IniEncab;
  UtilGrilla2.AgrEncabTxt('NUM' , 40);
  UtilGrilla2.AgrEncabTxt('TÍTULO', 80);
  UtilGrilla2.AgrEncabNum('AUTOR' , 130);
  UtilGrilla2.FinEncab;
  UtilGrilla2.MenuCampos:=true;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  UtilGrilla1.AsignarGrilla(StringGrid2);
  //Llena datos
  StringGrid2.RowCount:=2;
  StringGrid2.Cells[0,1] := '1';
  StringGrid2.Cells[1,1] := 'JUAN';
  StringGrid2.Cells[2,1] := 'PEREZ';
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  UtilGrilla2.AsignarGrilla(StringGrid2);
  //Llena datos
  StringGrid2.RowCount:=2;
  StringGrid2.Cells[0,1] := '1';
  StringGrid2.Cells[1,1] := 'BLASÓN';
  StringGrid2.Cells[2,1] := 'JOSÉ SANTOS CHOCANO';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UtilGrilla.Destroy;
  UtilGrilla1.Destroy;
  UtilGrilla2.Destroy;
end;

end.

