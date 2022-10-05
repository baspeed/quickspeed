unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, mvMapViewer, mvTypes,
  BCButton, mvGPSObj, mvEngine;

type

  { TForm2 }

  TForm2 = class(TForm)
    BCButton1: TBCButton;
    BCButton2: TBCButton;
    MapView1: TMapView;
    procedure BCButton1Click(Sender: TObject);
    procedure BCButton2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MapView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.frm}

{ TForm2 }

uses
    Unit1;

procedure TForm2.FormCreate(Sender: TObject);

var
   P: TRealPoint;
   T: TGpsPoint;

begin
     P.Lat:=41.65518;
     P.Lon:=-4.72372;
     MapView1.Center:=P;
     MapView1.Zoom:=5;
     MapView1.Font.Style:=[fsBold];
     MapView1.POITextBgColor:=clWhite;
     T:=TGpsPoint.Create(1.86026,41.7515);
     T.Name:='Test de bandaancha.eu'+#13+'(Barcelona - España)';
     MapView1.GPSItems.Add(T,1);
     T:=TGpsPoint.Create(-4.7245,41.6523);
     T.Name:='Test de Orange'+#13+'(Valladolid - España)';
     MapView1.GPSItems.Add(T,2);
     T:=TGpsPoint.Create(3.17456,50.69421);
     T.Name:='Test de OVH'+#13+'(Roubaix - Francia)';
     MapView1.GPSItems.Add(T,3);
end;

procedure TForm2.MapView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

var
   POI: TGPSObjArray;

begin
     POI:=MapView1.ObjsAtScreenPt(X,Y,48);
     if (POI<>nil) then
        begin
             case POI[0].IdOwner of
                  1 : begin
                           BCButton1.Caption:='Seleccionar test desde bandaancha.eu (Barcelona - España)';
                           numero_test:=1;
                           cadena_test:='Test desde bandaancha.eu (Barcelona - España)';
                      end;
                  2 : begin
                           BCButton1.Caption:='Seleccionar test desde Orange (Valladolid - España)';
                           numero_test:=2;
                           cadena_test:='Test desde Orange (Valladolid - España)';
                      end;
                  3 : begin
                           BCButton1.Caption:='Seleccionar test desde OVH (Roubaix - Francia)';
                           numero_test:=3;
                           cadena_test:='Test desde OVH (Roubaix - Francia)';
                      end;
             end;
             BCButton1.Enabled:=True;
        end;
end;

procedure TForm2.FormActivate(Sender: TObject);
begin
     MapView1.Active:=True;
end;

procedure TForm2.BCButton2Click(Sender: TObject);
begin
     BCButton1.Caption:='Activar test de velocidad seleccionado';
     BCButton1.Enabled:=False;
     Form1.Label1.Caption:='Ninguno seleccionado actualmente';
     Form1.BCButton2.Enabled:=False;
     Form2.Visible:=False;
end;

procedure TForm2.BCButton1Click(Sender: TObject);
begin
     Form1.Label1.Caption:=cadena_test;
     Form1.BCButton2.Enabled:=True;
     Form2.Visible:=False;
end;

end.

