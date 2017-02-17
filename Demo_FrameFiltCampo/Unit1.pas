unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, FrameFiltCampo, UtilsGrilla;

type

  { TForm1 }

  TForm1 = class(TForm)
    fraFiltCampo1: TfraFiltCampo;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    UtilGrilla: TUtilGrilla;
    procedure fraFiltCampo1CambiaFiltro;
  public
    { public declarations }
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
  UtilGrilla.FinEncab;
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
  fraFiltCampo1.Inic(UtilGrilla, 0);
  fraFiltCampo1.OnCambiaFiltro:=@fraFiltCampo1CambiaFiltro;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UtilGrilla.Destroy;
end;

procedure TForm1.fraFiltCampo1CambiaFiltro;
begin
  UtilGrilla.Filtrar;
end;

end.

