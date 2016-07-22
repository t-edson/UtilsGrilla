unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, FrameUtilsGrilla;

type

  { TForm1 }

  TForm1 = class(TForm)
    fraUtilsGrilla1: TfraUtilsGrilla;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
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
  fraUtilsGrilla1.Inic(StringGrid1, 22, nil);
  fraUtilsGrilla1.AgregarColumnaFiltro('Por columna A', 1);
  fraUtilsGrilla1.AgregarColumnaFiltro('Por columna B', 2);
end;

end.

