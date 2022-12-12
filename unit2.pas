//
// Ventana de selección de tests de velocidad a través de mapas de Google Maps
// Por José Ignacio Legido (usuario djnacho de bandaancha.eu), 2022
// Licencia del archivo GPL v3
//

unit Unit2;

{$mode ObjFPC}{$H+}

interface

// Librerías que usa la ventana

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, mvMapViewer, mvTypes,
  BCButton, mvGPSObj, mvEngine;

type

  { TForm2 }

  TForm2 = class(TForm)                                                       // Ventana de selección de tests de velocidad
    BCButton1: TBCButton;                                                     // Botón de selección de test de velocidad
    BCButton2: TBCButton;                                                     // Botón de anulación de test de velocidad
    MapView1: TMapView;                                                       // Mapa de selección de tests
    procedure BCButton1Click(Sender: TObject);                                // Rutina que ocurre al pulsar el botón de selección de test de velocidad
    procedure BCButton2Click(Sender: TObject);                                // Rutina que ocurre al pulsar el botón de anulación de test de velocidad
    procedure FormActivate(Sender: TObject);                                  // Rutina que ocurre cuando se visualiza la ventana de selección de tests
    procedure FormCreate(Sender: TObject);                                    // Rutina que ocurre cuando se carga la ventana de selección de tests (al inicio del programa)
    procedure MapView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);                                     // Rutina que ocurre cuando se pulsa algún botón del ratón dentro del mapa de selección de test

  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.frm}

{ TForm2 }

uses
    Unit1;    // Se pone aquí la unidad que controla la ventana principal para poder acceder a las variables globales de la unidad 1

// Rutina que ocurre al cargar la ventana de selección de tests de velocidad (al inicio del programa)

procedure TForm2.FormCreate(Sender: TObject);

var
   P: TRealPoint;                   // Punto que indica una coordenada dentro del mapa (coordenada del centro inicial del mapa - Valladolid)
   T: TGpsPoint;                    // Punto que indica otras coordenadas dentro del mapa (coordenadas de los tests de velocidad)

begin
     P.Lat:=41.65518;               // Latitud de Valladolid
     P.Lon:=-4.72372;               // Longitud de Valladolid
     MapView1.Center:=P;            // Centra el mapa sobre esas coordenadas
     MapView1.Zoom:=5;              // Pone el zoom del mapa a 5
     MapView1.Font.Style:=[fsBold]; // Fuente del mapa en negrita
     MapView1.POITextBgColor:=clWhite; // Fondo de cada punto GPS del mapa = blanco
     T:=TGpsPoint.Create(1.86026,41.7515);      // 1er punto GPS -> test de bandaancha.eu (en Barcelona, España)
     T.Name:='Test de bandaancha.eu'+#13+'(Barcelona - España)';    // Título del test de velocidad 1
     MapView1.GPSItems.Add(T,1); // Añade test de velocidad al mapa
     T:=TGpsPoint.Create(-2.244644,53.483959);      // 2do punto GPS -> test de ThinkBroadBand (en Londres, Inglaterra)
     T.Name:='Test de ThinkBroadBand'+#13+'(Londres - Inglaterra)'; // Título del test de velocidad 2
     MapView1.GPSItems.Add(T,2); // Añade test de velocidad al mapa
     T:=TGpsPoint.Create(3.17456,50.69421);    // 3er punto GPS -> test de OVH (Roubaix, Francia)
     T.Name:='Test de OVH'+#13+'(Roubaix - Francia)'; // Título del test de velocidad
     MapView1.GPSItems.Add(T,3); // Añade test de velocidad al mapa
     T:=TGpsPoint.Create( -121.96736110185623,37.37102186757838);    // 4o punto GPS -> test de NVIDIA (California, EEUU)
     T.Name:='Test de NVIDIA'+#13+'(Santa Clara, California - EEUU)'; // Título del test de velocidad
     MapView1.GPSItems.Add(T,4); // Añade test de velocidad al mapa
     T:=TGpsPoint.Create(-0.12800499999998327,51.50812900000004);    // 5o punto GPS -> test de LINODE (Londres, Inglaterra)
     T.Name:='Test de LINODE'+#13+'(Londres, Inglaterra)'; // Título del test de velocidad
     MapView1.GPSItems.Add(T,5); // Añade test de velocidad al mapa
end;


// Rutina que se llama cada vez que se pulsa cualquier botón del ratón dentro del mapa

procedure TForm2.MapView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

var
   POI: TGPSObjArray; // Variable que guarda los puntos GPS dentro del area del ratón (un círculo desde punto de pulsación con un radio de 48 pixels)

begin
     POI:=MapView1.ObjsAtScreenPt(X,Y,48); // Guarda todos los puntos GPS en el area del ratón
     if (POI<>nil) then // Si hay algún punto GPS dentro de ese area
        begin
             case POI[0].IdOwner of // Comprueba el número de ID del punto GPS
                  1 : begin // Si se ha pulsado del test de bandaancha.eu
                           BCButton1.Caption:='Seleccionar test desde bandaancha.eu (Barcelona - España)'; // Cambia texto del botón de selección de test
                           numero_test:=1; // Cambia el número de test activo
                           cadena_test:='Test desde bandaancha.eu (Barcelona - España)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
                  2 : begin // Si se ha pulsado el test de Orange - Valladolid
                           BCButton1.Caption:='Seleccionar test desde ThinkBroadBand (Londres - Inglaterra)'; // Cambia texto del botón de selección de test
                           numero_test:=2; // Cambia el número de test activo
                           cadena_test:='Test desde ThinkBroadBand (Londres - Inglaterra)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
                  3 : begin // Si se ha pulsado el test de OVH - Roubaix
                           BCButton1.Caption:='Seleccionar test desde OVH (Roubaix - Francia)'; // Cambia el texto del botón de selección de test
                           numero_test:=3; // Cambia el número de test activo
                           cadena_test:='Test desde OVH (Roubaix - Francia)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
                  4 : begin // Si se ha pulsado el test de NVIDIA - California
                           BCButton1.Caption:='Seleccionar test desde NVIDIA (Santa Clara, California - EEUU)'; // Cambia el texto del botón de selección de test
                           numero_test:=4; // Cambia el número de test activo
                           cadena_test:='Test desde NVIDIA (Santa Clara, California - EEUU)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
                  5 : begin // Si se ha pulsado el test de LINODE - Londres
                           BCButton1.Caption:='Seleccionar test desde LINODE (Londres, Inglaterra)'; // Cambia el texto del botón de selección de test
                           numero_test:=4; // Cambia el número de test activo
                           cadena_test:='Test desde LINODE (Londres, Inglaterra)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
             end;
             BCButton1.Enabled:=True; // Se activa el botón de selección de test de velocidad
        end;
end;

// Rutina que se ejecuta cuando se va a visualizar la ventana por primera vez

procedure TForm2.FormActivate(Sender: TObject);
begin
     MapView1.Active:=True; // Activa el mapa de selección de tests de velocidad
end;

// Rutina que se ejecuta cuando se pulsa el botón de anulación de selección del test de velocidad

procedure TForm2.BCButton2Click(Sender: TObject);
begin
     BCButton1.Caption:='Activar test de velocidad seleccionado'; // Cambia el texto del botón de selección de test
     BCButton1.Enabled:=False; // Desactiva el botón de selección de test
     Form1.Label1.Caption:='Ninguno seleccionado actualmente'; // En la ventana principal cambia el texto del test activo
     Form1.BCButton2.Enabled:=False; // En la ventana principal desactiva el botón de iniciar el test de velocidad
     Form2.Visible:=False; // Oculta la ventana de selección de tests de velocidad
end;

// Rutina que se ejecuta cuando se pulsa el botón de selección de test

procedure TForm2.BCButton1Click(Sender: TObject);
begin
     Form1.Label1.Caption:=cadena_test; // En la ventana principal cambia el texto del test activo
     Form1.BCButton2.Enabled:=True; // En la ventana principal activa el botón de iniciar el test de velocidad
     Form2.Visible:=False; // Oculta la ventana de selección de velocidad
end;

end.

