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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComboEx, mvMapViewer,
  mvTypes, BCButton, mvGPSObj, mvEngine, mvDE_RGBGraphics;

type

  { TForm2 }

  TForm2 = class(TForm)                                                       // Ventana de selección de tests de velocidad
    BCButton1: TBCButton;                                                     // Botón de selección de test de velocidad
    BCButton2: TBCButton;                                                     // Botón de anulación de test de velocidad
    ComboBoxEx1: TComboBoxEx;
    ImageList1: TImageList;
    MapView1: TMapView;                                                       // Mapa de selección de tests
    MvRGBGraphicsDrawingEngine1: TMvRGBGraphicsDrawingEngine;
    procedure BCButton1Click(Sender: TObject);                                // Rutina que ocurre al pulsar el botón de selección de test de velocidad
    procedure BCButton2Click(Sender: TObject);                                // Rutina que ocurre al pulsar el botón de anulación de test de velocidad
    procedure ComboBoxEx1Change(Sender: TObject);
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
     MapView1.Zoom:=6;              // Pone el zoom del mapa a 5
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
     T:=TGpsPoint.Create(-3.6940925,40.4478561);    // 6o punto GPS -> test de RedIris.es (Madrid, España)
     T.Name:='Test de RedIris.es'+#13+'(Madrid, España)'; // Título del test de velocidad
     MapView1.GPSItems.Add(T,6); // Añade test de velocidad al mapa
     T:=TGpsPoint.Create(11.0140584,49.4494552);    // 7o punto GPS -> test de RedIris.es (Madrid, España)
     T.Name:='Test de Hetzner.de'+#13+'(Núremberg, Alemania)'; // Título del test de velocidad
     MapView1.GPSItems.Add(T,7); // Añade test de velocidad al mapa
     T:=TGpsPoint.Create(-4.7245,41.6523);    // 8o punto GPS -> test de Orange (Valladolid, España)
     T.Name:='Test de Orange'+#13+'(Valladolid, España)'; // Título del test de velocidad
     MapView1.GPSItems.Add(T,8); // Añade test de velocidad al mapa.
     T:=TGpsPoint.Create(-0.0889078,51.5164717);    // 9o punto GPS -> test de TurnKeyInternet (Amsterdam, Holanda)
     T.Name:='Test de ClouVider'+#13+'(Londres, Reino Unido)'; // Título del test de velocidad
     MapView1.GPSItems.Add(T,9); // Añade test de velocidad al mapa.
     T:=TGpsPoint.Create(-2.2339847,53.4526741);    // 9o punto GPS -> test de TurnKeyInternet (Amsterdam, Holanda)
     T.Name:='Test de ClouVider'+#13+'(Manchester, Reino Unido)'; // Título del test de velocidad
     MapView1.GPSItems.Add(T,10); // Añade test de velocidad al mapa.
     T:=TGpsPoint.Create(6.7702486,50.6810975);    // 9o punto GPS -> test de TurnKeyInternet (Amsterdam, Holanda)
     T.Name:='Test de ClouVider'+#13+'(Frankfurt, Alemania)'; // Título del test de velocidad
     MapView1.GPSItems.Add(T,11); // Añade test de velocidad al mapa.
     T:=TGpsPoint.Create(9.0996351,45.4780144);    // 9o punto GPS -> test de TurnKeyInternet (Amsterdam, Holanda)
     T.Name:='Test de FiberTelecom'+#13+'(Milán, Italia)'; // Título del test de velocidad
     MapView1.GPSItems.Add(T,12); // Añade test de velocidad al mapa.
     T:=TGpsPoint.Create(-74.0069365,40.7200627);    // 9o punto GPS -> test de TurnKeyInternet (Amsterdam, Holanda)
     T.Name:='Test de ClouVider'+#13+'Nueva York, Estados Unidos)'; // Título del test de velocidad
     MapView1.GPSItems.Add(T,13); // Añade test de velocidad al mapa.
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
                  2 : begin // Si se ha pulsado el test de ThinkBroadband - Londres
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
                           numero_test:=5; // Cambia el número de test activo
                           cadena_test:='Test desde LINODE (Londres, Inglaterra)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
                  6 : begin // Si se ha pulsado el test de RedIris - España
                           BCButton1.Caption:='Seleccionar test desde RedIris.es (Madrid, España)'; // Cambia el texto del botón de selección de test
                           numero_test:=6; // Cambia el número de test activo
                           cadena_test:='Test desde RedIris.es (Madrid, España)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
                  7 : begin // Si se ha pulsado el test de Hertzner.de - Alemania
                           BCButton1.Caption:='Seleccionar test desde Hetzner.de (Núremberg, Alemania)'; // Cambia el texto del botón de selección de test
                           numero_test:=7; // Cambia el número de test activo
                           cadena_test:='Test desde Hetzner.de (Núremberg, Alemania)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
                   8 : begin // Si se ha pulsado el test de Orange - España
                           BCButton1.Caption:='Seleccionar test desde Orange (Valladolid, España)'; // Cambia el texto del botón de selección de test
                           numero_test:=8; // Cambia el número de test activo
                           cadena_test:='Test desde Orange (Valladolid, España)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
                   9 : begin // Si se ha pulsado el test de ClouVider - Londres
                           BCButton1.Caption:='Seleccionar test desde ClouVider (Londres, Reino Unido)'; // Cambia el texto del botón de selección de test
                           numero_test:=9; // Cambia el número de test activo
                           cadena_test:='Test desde ClouVider (Londres, Reino Unido)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
                   10 : begin // Si se ha pulsado el test de ClouVider - Manchester
                           BCButton1.Caption:='Seleccionar test desde ClouVider (Manchester, Reino Unido)'; // Cambia el texto del botón de selección de test
                           numero_test:=10; // Cambia el número de test activo
                           cadena_test:='Test desde ClouVider (Manchester, Reino Unido)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
                   11 : begin // Si se ha pulsado el test de ClouVider - FrankFurt
                           BCButton1.Caption:='Seleccionar test desde ClouVider (Frankfurt, Alemania)'; // Cambia el texto del botón de selección de test
                           numero_test:=11; // Cambia el número de test activo
                           cadena_test:='Test desde ClouVider (Frankfurt, Alemania)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
                   12 : begin // Si se ha pulsado el test de FiberTelecom - Milán
                           BCButton1.Caption:='Seleccionar test desde FiberTelecom (Milán, Italia)'; // Cambia el texto del botón de selección de test
                           numero_test:=12; // Cambia el número de test activo
                           cadena_test:='Test desde FiberTelecom (Milán, Italia)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
                   13 : begin // Si se ha pulsado el test de ClouVider - Manchester
                           BCButton1.Caption:='Seleccionar test desde ClouVider (Nueva York, Estados Unidos)'; // Cambia el texto del botón de selección de test
                           numero_test:=13; // Cambia el número de test activo
                           cadena_test:='Test desde ClouVider (Nueva York, Estados Unidos)'; // Cambia la cadena de texto a mostrar en la ventana principal
                      end;
             end;
             BCButton1.Enabled:=True; // Se activa el botón de selección de test de velocidad
        end;
end;

// Rutina que se ejecuta cuando se va a visualizar la ventana por primera vez

procedure TForm2.FormActivate(Sender: TObject);
begin
     MapView1.Active:=True; // Activa el mapa de selección de tests de velocidad
     ComboBoxEx1Change(self);   // Activa el cambio de localizacion del mapa en función del test seleccionado de la lista
     MapView1.Update;          // Actualiza el mapa de tests para visualizar correctamente la localización de los tests
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

procedure TForm2.ComboBoxEx1Change(Sender: TObject);
begin
      case ComboBoxEx1.ItemIndex+1 of // Comprueba el número de ID del punto GPS
                  1 : begin // Si se ha pulsado del test de bandaancha.eu
                           BCButton1.Caption:='Seleccionar test desde bandaancha.eu (Barcelona - España)'; // Cambia texto del botón de selección de test
                           numero_test:=1; // Cambia el número de test activo
                           cadena_test:='Test desde bandaancha.eu (Barcelona - España)'; // Cambia la cadena de texto a mostrar en la ventana principal
                           MapView1.CenterOnObj(MapView1.GPSItems[0]);                   // Centra el mapa en el test seleccionado en la lista
                      end;
                  2 : begin // Si se ha pulsado el test de ThinkBroadband - Londres
                           BCButton1.Caption:='Seleccionar test desde ThinkBroadBand (Londres - Inglaterra)'; // Cambia texto del botón de selección de test
                           numero_test:=2; // Cambia el número de test activo
                           cadena_test:='Test desde ThinkBroadBand (Londres - Inglaterra)'; // Cambia la cadena de texto a mostrar en la ventana principal
                           MapView1.CenterOnObj(MapView1.GPSItems[1]);                      // Centra el mapa en el test seleccionado en la lista
                      end;
                  3 : begin // Si se ha pulsado el test de OVH - Roubaix
                           BCButton1.Caption:='Seleccionar test desde OVH (Roubaix - Francia)'; // Cambia el texto del botón de selección de test
                           numero_test:=3; // Cambia el número de test activo
                           cadena_test:='Test desde OVH (Roubaix - Francia)'; // Cambia la cadena de texto a mostrar en la ventana principal
                           MapView1.CenterOnObj(MapView1.GPSItems[2]);                      // Centra el mapa en el test seleccionado en la lista
                      end;
                  4 : begin // Si se ha pulsado el test de NVIDIA - California
                           BCButton1.Caption:='Seleccionar test desde NVIDIA (Santa Clara, California - EEUU)'; // Cambia el texto del botón de selección de test
                           numero_test:=4; // Cambia el número de test activo
                           cadena_test:='Test desde NVIDIA (Santa Clara, California - EEUU)'; // Cambia la cadena de texto a mostrar en la ventana principal
                           MapView1.CenterOnObj(MapView1.GPSItems[3]);                        // Centra el mapa en el test seleccionado en la lista
                      end;
                  5 : begin // Si se ha pulsado el test de LINODE - Londres
                           BCButton1.Caption:='Seleccionar test desde LINODE (Londres, Inglaterra)'; // Cambia el texto del botón de selección de test
                           numero_test:=5; // Cambia el número de test activo
                           cadena_test:='Test desde LINODE (Londres, Inglaterra)'; // Cambia la cadena de texto a mostrar en la ventana principal
                           MapView1.CenterOnObj(MapView1.GPSItems[4]);             // Centra el mapa en el test seleccionado en la lista
                      end;
                  6 : begin // Si se ha pulsado el test de RedIris - España
                           BCButton1.Caption:='Seleccionar test desde RedIris.es (Madrid, España)'; // Cambia el texto del botón de selección de test
                           numero_test:=6; // Cambia el número de test activo
                           cadena_test:='Test desde RedIris.es (Madrid, España)'; // Cambia la cadena de texto a mostrar en la ventana principal
                           MapView1.CenterOnObj(MapView1.GPSItems[5]);            // Centra el mapa en el test seleccionado en la lista
                      end;
                  7 : begin // Si se ha pulsado el test de Hertzner.de - Alemania
                           BCButton1.Caption:='Seleccionar test desde Hetzner.de (Núremberg, Alemania)'; // Cambia el texto del botón de selección de test
                           numero_test:=7; // Cambia el número de test activo
                           cadena_test:='Test desde Hetzner.de (Núremberg, Alemania)'; // Cambia la cadena de texto a mostrar en la ventana principal
                           MapView1.CenterOnObj(MapView1.GPSItems[6]);                 // Centra el mapa en el test seleccionado en la lista
                      end;
                   8 : begin // Si se ha pulsado el test de Orange - España
                           BCButton1.Caption:='Seleccionar test desde Orange (Valladolid, España)'; // Cambia el texto del botón de selección de test
                           numero_test:=8; // Cambia el número de test activo
                           cadena_test:='Test desde Orange (Valladolid, España)'; // Cambia la cadena de texto a mostrar en la ventana principal
                           MapView1.CenterOnObj(MapView1.GPSItems[7]);            // Centra el mapa en el test seleccionado en la lista
                      end;
                   9 : begin // Si se ha pulsado el test de ClouVider - Londres
                           BCButton1.Caption:='Seleccionar test desde ClouVider (Londres, Reino Unido)'; // Cambia el texto del botón de selección de test
                           numero_test:=9; // Cambia el número de test activo
                           cadena_test:='Test desde ClouVider (Londres, Reino Unido)'; // Cambia la cadena de texto a mostrar en la ventana principal
                           MapView1.CenterOnObj(MapView1.GPSItems[8]);                 // Centra el mapa en el test seleccionado en la lista
                      end;
                   10 : begin // Si se ha pulsado el test de ClouVider - Manchester
                           BCButton1.Caption:='Seleccionar test desde ClouVider (Manchester, Reino Unido)'; // Cambia el texto del botón de selección de test
                           numero_test:=10; // Cambia el número de test activo
                           cadena_test:='Test desde ClouVider (Manchester, Reino Unido)'; // Cambia la cadena de texto a mostrar en la ventana principal
                           MapView1.CenterOnObj(MapView1.GPSItems[9]);                    // Centra el mapa en el test seleccionado en la lista
                      end;
                   11 : begin // Si se ha pulsado el test de ClouVider - FrankFurt
                           BCButton1.Caption:='Seleccionar test desde ClouVider (Frankfurt, Alemania)'; // Cambia el texto del botón de selección de test
                           numero_test:=11; // Cambia el número de test activo
                           cadena_test:='Test desde ClouVider (Frankfurt, Alemania)'; // Cambia la cadena de texto a mostrar en la ventana principal
                           MapView1.CenterOnObj(MapView1.GPSItems[10]);               // Centra el mapa en el test seleccionado en la lista
                      end;
                   12 : begin // Si se ha pulsado el test de FiberTelecom - Milán
                           BCButton1.Caption:='Seleccionar test desde FiberTelecom (Milán, Italia)'; // Cambia el texto del botón de selección de test
                           numero_test:=12; // Cambia el número de test activo
                           cadena_test:='Test desde FiberTelecom (Milán, Italia)'; // Cambia la cadena de texto a mostrar en la ventana principal
                           MapView1.CenterOnObj(MapView1.GPSItems[11]);            // Centra el mapa en el test seleccionado en la lista
                      end;
                   13 : begin // Si se ha pulsado el test de ClouVider - Manchester
                           BCButton1.Caption:='Seleccionar test desde ClouVider (Nueva York, Estados Unidos)'; // Cambia el texto del botón de selección de test
                           numero_test:=13; // Cambia el número de test activo
                           cadena_test:='Test desde ClouVider (Nueva York, Estados Unidos)'; // Cambia la cadena de texto a mostrar en la ventana principal
                           MapView1.CenterOnObj(MapView1.GPSItems[12]);                      // Centra el mapa en el test seleccionado en la lista
                      end;
             end;

end;

// Rutina que se ejecuta cuando se pulsa el botón de selección de test

procedure TForm2.BCButton1Click(Sender: TObject);
begin
     Form1.Label1.Caption:=cadena_test; // En la ventana principal cambia el texto del test activo
     Form1.BCButton2.Enabled:=True; // En la ventana principal activa el botón de iniciar el test de velocidad
     Form2.Visible:=False; // Oculta la ventana de selección de velocidad
end;

end.

