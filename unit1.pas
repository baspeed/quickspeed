//
// Test de velocidad de internet QuickSpeed (antiguo BASpeed)
// Creado por José Ignacio Legido (djnacho de bandaancha.eu), 2022
// Licencia GPL v3
// Versión 0.1.0 prebeta
//


unit Unit1;

{$mode objfpc}{$H+}

interface

// Librerías usadas por la ventana principal del programa

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  dtthemedgauge, BCButton, BGRALabelFX, BGRACustomDrawn,
  JvSimScope, RxVersInfo, HtmlView, LCLType, LCLIntF, ComCtrls, HtmlGlobals,
  Unit2, cySimpleGauge, IdHTTP, IdIOHandler, IdIOHandlerStack,
  IdSSLOpenSSL, IdComponent;

type

  { TForm1 }
// Ventana principal del programa

  TForm1 = class(TForm)
    BCButton1: TBCButton;                              // Botón de seleccionar test en el mapa
    BCButton2: TBCButton;                              // Botón de iniciar el test de velocidad
    Bevel1: TBevel;                                    // Linea divisoria entre pantalla de test y panel informativo
    BGRALabelFX1: TBGRALabelFX;                        // Velocidad en Mbps en efecto especial de texto
    cySimpleGauge1: TcySimpleGauge;
    DTThemedGauge1: TDTThemedGauge;                    // Velocímetro
    GroupBox1: TGroupBox;                              // Datos generales de velocidad del test de velocidad
    GroupBox2: TGroupBox;                              // Gráfica de velocidad instantánea
    GroupBox3: TGroupBox;                              // Datos de cada hilo de descarga
    HtmlViewer1: THtmlViewer;                          // Caja de texto HTML
    Image1: TImage;                                    // Imagen / icono de la información del hilo 1 de descarga
    Image2: TImage;                                    // Imagen / icono de la información del hilo 2 de descarga
    Image3: TImage;                                    // Imagen / icono de la información del hilo 3 de descarga
    Image4: TImage;                                    // Imagen / icono de la información del hilo 4 de descarga
    Image5: TImage;                                    // Imagen / icono de la información del hilo 5 de descarga
    Image6: TImage;                                    // Imagen / icono de la información del hilo 6 de descarga
    JvSimScope1: TJvSimScope;                          // Componente que muestra la gráfica de velocidad instantánea
    Label1: TLabel;                                    // Test de velocidad seleccionado en la ventana de selección de test
    Label10: TLabel;                                   // Datos hilo 4 de descarga
    Label11: TLabel;                                   // Datos hilo 5 de descarga
    Label12: TLabel;                                   // Datos hilo 6 de descarga
    Label13: TLabel;                                   // Texto que indica que hay que pulsar CTRL+I para ver el panel informativo de la aplicación
    Label2: TLabel;                                    // Etiqueta de la gráfica de velocidad 1000 Mbps
    Label3: TLabel;                                    // Etiqueta de la gráfica de velocidad 750 Mbps
    Label4: TLabel;                                    // Etiqueta de la gráfica de velocidad 500 Mbps
    Label5: TLabel;                                    // Etiqueta de la gráfica de velocidad 250 Mbps
    Label6: TLabel;                                    // Etiqueta de la gráfica de velocidad 0 Mbps
    Label7: TLabel;                                    // Datos hilo 1 de descarga
    Label8: TLabel;                                    // Datos hilo 2 de descarga
    Label9: TLabel;                                    // Datos hilo 3 de descarga
    RxVersionInfo1: TRxVersionInfo;                    // Obtiene la versión del archivo ejecutable QuickSpeed.exe
    Timer1: TTimer;
    procedure BCButton1Click(Sender: TObject);         // Llama a rutina que permite seleccionar un test de velocidad de un mapa
    procedure BCButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);             // Rutina que se ejecuta al crear la ventana (antes de visualizarla)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);  // Rutina que permite examinar las pulsaciones del teclado dentro de la aplicación
    procedure G32_ProgressBar1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure HtmlViewer1HotSpotClick(Sender: TObject; const SRC: ThtString;    // Rutina que abre un enlace dentro del texto HTML de descripción de la aplicación
      var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);

    private
    public
    end;

  TDescarga = class(TThread)                           // Objeto que define un hilo de descarga simultaneo paralelo al hilo de ejecución de la aplicación
              enlace: string;                             // Cadena de caracteres que define la URL del archivo en un servidor de internet que se usa para el test de descarga
              ioh: TIdIOHandlerStack;                  // Manejador de I/O para el objeto web que se encarga de la descarga (Sin SSL)
              sslioh: TIdSSLIOHandlerSocketOpenSSL;    // Manejador de I/O para el objeto web que se encarga de la descarga (con SSL)
              web: TIdHTTP;                            // Objeto web que permite la descarga de archivos desde internet (con y sin SSL dependiendo del servidor)
              buffermemoria: TMemoryStream;            // Objeto que guarda en memoria todo el buffer de recepción
              ti, tf, tt: int64;                       // Tiempo inicial, final y total del test de velocidad
              velocidad: UInt64;                       // velocidad de la conexión (en KBit/s)
              tpc: UInt64;                             // Tanto por ciento del test de velocidad completado
              tam: Uint64;                             // Tamaño del archivo en el servidor
              terminado: Boolean;                      // Indica si el test ha terminado (con error o sin el)
              private
                     procedure CalculaDatos(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64); // Rutina que calcula la velocidad y el tanto por ciento completado en cada descarga
              protected
                       procedure Execute; override;    // Rutina de arranque del test de velocidad
  end;

  const
       TAMBUFFER:integer=512*1024;                 // Tamaño del buffer de recepción de datos = 512 KBytes
       NUMHILOS:integer=6;                         // Número de hilos de descarga simultaneos para test de velocidad;


var
  Form1: TForm1;                              // Ventana principal
  Ventana_Expandida: Boolean;                 // Indica cuando el panel informativo está abierto / cerrado
  numero_test: Word;                          // Número asignado al test seleccionado
  cadena_test: String;                        // Cadena de texto para mostrar el test de velocidad seleccionado
  cancelartestvelocidad: Boolean;             // Variable que indica cuando el usuario cancela el test de velocidad activo
  hilosactivos: Word;                         // Número de hilos con el test de velocidad activo
  hilosdescarga: array[1..6] of TDescarga;    // Array de hilos de descarga
  velocidadtotal: UInt64;                     // Velocidad total (suma de la velocidad de los hilos de descarga)
  testactivo: Boolean;
  VMax: UInt64;

implementation

{$R *.frm}

// Rutina de ejecución de cada hilo simultaneo de descarga

procedure TDescarga.Execute;

begin
     tpc:=0;                                                           // Inicializa el tanto por ciento descargadp a 0
     web:=TidHTTP.Create;                                              // Crea el objeto HTTP que permite descargar archivos de servidores
     buffermemoria:=TMemoryStream.Create;                              // Crea el buffer en memoria con el tamaño indicado en TAMBUFER
     buffermemoria.SetSize(TAMBUFFER);
     case numero_test of                                               // En caso del valor de numero_test
          1,3,6,7: begin                                                   // 1 o 3 son tests SSL
                  sslioh:=TIdSSLIOHandlerSocketOpenSSL.Create;         // Crea el manejador de datos SSL para el objeto HTTP
                  sslioh.ConnectTimeout:=5000;                         // 5 segundos de tiempo de espera de conexión antes de error
                  sslioh.ReadTimeout:=5000;                            // 5 segundos de tiempo de espera para lectura de datos antes de eror
                  sslioh.RecvBufferSize:=TAMBUFFER;                    // Tamaño del buffer de recepción
                  web.IOHandler:=sslioh;                               // Asigna el manejador de datos SSL al manejador por defecto del objeto HTTP
             end;
          2,4,5 : begin                                                  // 1 y 4 son tests normales (HHTP sin SSL)
                      ioh:=TIdIOHandlerStack.Create;                   // Crea el manejador de datos
                      ioh.ConnectTimeout:=5000;                        // 5 segundos de tiempo de espera de conexión antes de error
                      ioh.ReadTimeout:=5000;                           // 5 segundos de tiempo de espera para lectura de datos antes de error
                      ioh.RecvBufferSize:=TAMBUFFER;                   // Tamaño del buffer de recepción
                      web.IOHandler:=ioh;                              // Asigna el manejador de datos al manejador por defecto del objeto HTTP
                 end;
     end;
     if (numero_test<>7) then                                          // El test de hetzner.de no admite la lectura de cabecera de datos con lo que no podemos obtener el valor del tamaño del archivo de descarga
        begin
             web.Head(enlace);                                                 // Lee la cabecera de datos del archivo
             tam:=web.Response.ContentLength;                                  // Asigna a tam el tamaño del archivo en el servidor
        end
     else
         tam:=104857600;                                               // Se asignan 100 MB al test de hetzner.de que es el tamaño del archivo (se comprueba desde speed.hetzner.de)
     web.OnWork:=@CalculaDatos;                                        // Asigna la rutina que se ejecutará cada vez que se llene el buffer de datos
     ti:=GetTickCount64;                                               // Asigna a ti el tiempo inicial de ejecución del hilo
     try                                                               // Intenta
        web.Get(enlace,buffermemoria);                                 // Descargar el archivo en el buffer de memoria
     except                                                            // Si hay cualquier fallo
           begin
                 terminado:=true;                                      // Variable terminado a True para indicar que el test
                 velocidad:=0;                                         // Se pone la velocidad de descarga del hilo a 0
                 dec(hilosactivos);                                    // Resta una unidad al número de hilos activos
           end;
     end;
     buffermemoria.Free;                                               // Libera el buffer de datos
     if (numero_test=1) or (numero_test=3) then
        sslioh.Free                                                    // Libera los manejadores de datos SSL
     else
         ioh.Free;                                                     // Libera los manejadores de datos normales
     web.Free;                                                         // Libera el objeto HTTP
     terminado:=True;                                                  // Pone la variable terminado a true para indicar que el test ha terminado
     velocidad:=0;                                                     // Pone la velocidad a 0 para el cálculo posterior de la velocidad
end;

// Rutina que se ejecuta cada vez que se llena el buffer de datos

procedure TDescarga.CalculaDatos(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);

begin
     if (AWorkMode=TworkMode.wmRead) and (cancelartestvelocidad=False) then
        begin
             buffermemoria.Seek(0,0); // Mover el puntero de memoria al inicio del buffer
             tf:=gettickcount64; // obtiene el tiempo transcurrido actual
             tt:=tf-ti; // calcula la diferencia de tiempos entre el inicio del test y ahora mismo
             velocidad:=(AWorkCount div tt) * 8; // Calcula la velocidad en Kbits/s
             tpc:=(AworkCount*100) div tam; // Calcula el tanto por ciento completado
        end
     else
         if (AWorkMode=TWorkMode.wmRead) and (cancelartestvelocidad=True) then
            begin
                 web.Disconnect; // Si se cancela el test de velocidad, desconecta del servidor para terminar el test de velocidad
            end;
end;

{ TForm1 }

// Rutina que se ejcuta antes de visualizar la ventana principal del programa (inicia toda la aplicación antes de visualizarla en pantalla)

procedure TForm1.FormCreate(Sender: TObject);

var
   Age: Int64;                      // Variable que guarda la fecha de modificación del archivo QuickSpeed.exe

begin
     testactivo:=False;                                    // No hay ningún test de velocidad activo
     cancelartestvelocidad:=False;
     Form1.Width:=368;                                     // Ancho de la ventana 368 pixels
     JvSimScope1.VerticalGridSize:=LongInt.MaxValue;       // Alto de la cuadrícula de la gráfica = Valor más alto de LongInt (para que no se vea)
     Ventana_Expandida:=False;                             // Se indica a la aplicación que el panel informativo está oculto
     Age:=FileAge('QuickSpeed.exe');                       // Se toma el valor de la fecha de modificación de QuickSpeed.exe en la variable Age
     HTMLViewer1.Text:=UnicodeString('<b>Test de velocidad <a href="http://baspeed.bandaancha.eu">QuickSpeed</a> v'+RXVersionInfo1.FileVersion+' ('+DateToStr(FileDateToDateTime(Age))+')</b>.<br>'+
                       'Creado por José Ignacio Legido (usuario <b><a href="https://bandaancha.eu/usuarios/djnacho-60320">djnacho</a></b> de <b><a href="https://bandaancha.eu">bandaancha.eu</a></b>).<br><br>'+
                       'Este test de velocidad ha sido creado usando <b><a href="https://www.pilotlogic.com">CodeTyphon</a></b>, un IDE de código abierto para <b><a href="https://www.freepascal.org">freepascal</a></b>.<br>'+
                       'Este programa tiene licencia <b><a href="https://www.gnu.org/licenses/gpl-3.0-standalone">GPL v3</a></b>.<br>'+
                       'Dedicado a todos los usuarios de bandaancha.eu y a toda la comunidad internauta en general. Este software no sería posible sin su apoyo y ayuda.'); // Presenta texto HTML de descripción de la aplicación en pantalla
end;


// Rutina que permite seleccionar un test de velocidad de un mapa

procedure TForm1.BCButton1Click(Sender: TObject);
begin
     Form2.Visible:=True;               // Hace visible la ventana que contiene el mapa
end;

// Rutina que se ejecuta cuando se pulsa el botón de iniciar/ cancelar test de velocidad

procedure TForm1.BCButton2Click(Sender: TObject);

var
   contadorhilo: integer;

begin
     if (testactivo=False) then                                              // Si no hay test de velocidad activo
        begin
             VMax:=0;
             testactivo:=True;                                               // Variable que indica que hay un test activo a True
             BCButton2.Caption:='Cancelar test de velocidad';                // Cambia texto del botón 2
             BCButton1.Enabled:=False;                                       // Inhabilita el botón 1 para no poder elegir otro test en caso de iniciar el test
             for contadorhilo:=1 to NUMHILOS do                              // Desde 1 hasta el número de hilos predeterminado en el código fuente
                 hilosdescarga[contadorhilo]:=TDescarga.Create(True);        // Crea todos los hilos de descarga (6 simultaneos)
             Timer1.Enabled:=True;                                           // Inicia el Timer
             JVSimScope1.Active:=True;                                       // Inicia la gráfica de velocidad
             for contadorhilo:=1 to NUMHILOS do                              // Desde el hilo 1 hasta el hilo NUMMAX (6 por defecto en el código fuente original)
                 begin
                      case numero_test of                                    // Dependiendo del número de test, indica al hilo de ejecución un enlace o otro
                           1 : hilosdescarga[contadorhilo].enlace:='https://testvelocidad.eu/speed-test/download.bin';
                           2 : hilosdescarga[contadorhilo].enlace:='http://ipv4.download.thinkbroadband.com/100MB.zip';
                           3 : hilosdescarga[contadorhilo].enlace:='https://rbx.proof.ovh.net/files/100Mb.dat';
                           4 : hilosdescarga[contadorhilo].enlace:='http://es.download.nvidia.com/Windows/452.06/452.06-desktop-win10-64bit-international-dch-whql.exe';
                           5 : hilosdescarga[contadorhilo].enlace:='http://speedtest.london.linode.com/100MB-london.bin';
                           6 : hilosdescarga[contadorhilo].enlace:='https://ftp.rediris.es/mirror/OpenSuSE/distribution/openSUSE-stable/live/openSUSE-Leap-15.4-Rescue-CD-x86_64-Build31.38-Media.iso';
                           7 : hilosdescarga[contadorhilo].enlace:='https://speed.hetzner.de/100MB.bin';

                      end;
                      hilosdescarga[contadorhilo].Start;                    // Inicia el hilo de ejecución
                 end
        end
     else
         cancelartestvelocidad:=True;                                       // Si se pulsa el botón con el test iniciado se activa esta variable para detener el test
end;

// Rutina que permite conocer todas las pulsaciones de teclas dentro de la aplicación

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
     if (Key=VK_I) and (Shift=[ssCtrl]) then  // Si la pulsación es CTRL+I
        case Ventana_Expandida of             // Se verifica la variable Ventana_Expandida
             False             : begin        // Si está oculta
                                      Ventana_Expandida:=True; // Se pone la variable a True
                                      Form1.Width:=801;        // Expande la ventana para que aparezca el panel informativo
                                      Form1.Left:=(Screen.DesktopWidth-Form1.Width) div 2;    // Centra la ventana en el escritorio
                                 end;
             True              : begin        // Si está visible
                                      Ventana_Expandida:=False; // Se pone la variable a False
                                      Form1.Width:=368;         // Vuelve a poner el ancho de ventana a 368 pixels para ocultar el panel informativo
                                      Form1.Left:=(Screen.DesktopWidth-Form1.Width) div 2; // Centra la ventana en el escritorio
                                 end;
        end;
end;

procedure TForm1.G32_ProgressBar1DragDrop(Sender, Source: TObject; X, Y: Integer
  );
begin

end;

// Rutina que permite abrir un enlace que está dentro del texto HTML de la descripción de la aplicación

procedure TForm1.HtmlViewer1HotSpotClick(Sender: TObject; const SRC: ThtString;
  var Handled: Boolean);
begin
     OpenURl(AnsiString(SRC));                   // Transforma la variable SRC en AnsiString y abre el enlace en el navegador
end;

// Rutina que se ejecuta cada vez que el timer llega al tiempo preestablecido (actualiza los datos de la ventana)

procedure TForm1.Timer1Timer(Sender: TObject);

var
   contadorhilos: integer;                    // Variable que contiene el numero de hilo actual
   tpctotal: integer;                         // Tanto por ciento total descargado del servidor

begin
     velocidadtotal:=0;                       // Velocidad total del test a 0
     for contadorhilos:=1 to NUMHILOS do      // Desde 1 hasta NUMHILOS de ejecución simultanea
         begin
              velocidadtotal:=velocidadtotal+hilosdescarga[contadorhilos].velocidad; // Realiza la suma de velocidades de todos los hilos de ejecución
         end;
     Label7.Caption:='Hilo 1'+#13+FormatFloat('0000.00',hilosdescarga[1].velocidad/1000)+' Mbps';         // Escribe las velocidades de cada hilo en su lugar correspondiente
     Label8.Caption:='Hilo 2'+#13+FormatFloat('0000.00',hilosdescarga[2].velocidad/1000)+' Mbps';
     Label9.Caption:='Hilo 3'+#13+FormatFloat('0000.00',hilosdescarga[3].velocidad/1000)+' Mbps';
     Label10.Caption:='Hilo 4'+#13+FormatFloat('0000.00',hilosdescarga[1].velocidad/1000)+' Mbps';
     Label11.Caption:='Hilo 5'+#13+FormatFloat('0000.00',hilosdescarga[1].velocidad/1000)+' Mbps';
     Label12.Caption:='Hilo 6'+#13+FormatFloat('0000.00',hilosdescarga[1].velocidad/1000)+' Mbps';
     DTThemedGauge1.Position:=velocidadtotal div 1000;
     BGRALabelFX1.Caption:=FormatFloat('0000.00',velocidadtotal/1000)+' Mbps';                 // Imprime la velocidad actual del test
     if (velocidadtotal>VMax) then                                                             // Si la velocidad del test > velocidad máxima registrada hasta ese momento entonces
        begin
             VMax:=velocidadtotal;
             JVSimScope1.BaseLine:=VMax div 1000;                                              // Pone la barra que indica la máxima velocidad en la nueva velocidad máxima
             JVSimScope1.UpdateScope;                                                          // Se actualiza la gráfica
             GroupBox2.Caption:='Gráfica de velocidad (Mbps) - VMax: '+FormatFloat('0000.00',velocidadtotal/1000)+' Mbps';    // Se actualiza la velocidad máxima en el título del grupo de la gráfica de velocidad
        end;
     JVSimScope1.Lines[0].Position:=velocidadtotal div 1000;                                   // Imprime la velocidad actual del test en la gráfica de velocidad
     JVSimScope1.UpdateScope;                                                                  // Actualiza la gráfica de velocidad (la repinta) para que el gráfico salga correctamente
     tpctotal:=0;                                                                              // Tanto por ciento total a 0
     for contadorhilos:=1 to NUMHILOS do                                                       // Desde 1 hasta NUMHILOS (6 por defecto en el código fuente original)
         tpctotal:=tpctotal+hilosdescarga[contadorhilos].tpc;                                  // Actualiza el tanto por ciento total, realizando la suma de todos los tantos por ciento y diviendo el valor entre el número de hilos (6)
     cySimpleGauge1.Position:=tpctotal div 6;                                                  // Actualiza la barra de progreso con el valor del tanto poor ciento total
     // Cuando se ha terminado el test de velocidad
     if (hilosdescarga[1].terminado=True) and (hilosdescarga[2].terminado=True) and (hilosdescarga[3].terminado=True) and (hilosdescarga[4].terminado=True) and (hilosdescarga[5].terminado=True) and (hilosdescarga[6].terminado=True) then
        begin
             BCButton1.Enabled:=True;                                                          // Botón 1 habilitado
             BCButton2.Caption:='Iniciar test de velocidad';                                   // Cambia texto del botón 2
             for contadorhilos:=1 to NUMHILOS do                                               // Desde el hilo 1 hasta el numero máximo de hilos (6)
                 hilosdescarga[contadorhilos].Free;                                            // Libera la memoria de los hilos de ejecución simultanea
             timer1.Enabled:=False;                                                            // Para el timer para no seguir actualizando datos en la ventana principal
             JvSimScope1.Active:=False;                                                        // Desactiva la gráfica de velocidad
             cancelartestvelocidad:=False;                                                     // Pone el valor de Cancelar el test de velocidad a False
             testactivo:=False;                                                                // Ya no está activo el test de velocidad así que el test activo a False
             // Se muestra un cuadro de diálogo mostrando la velocidad máxima alcanzada en el test si este ha acabado con éxito o se ha cancelado por el usuario
             MessageDlg('Test de velocidad terminado','Test de velocidad terminado.'+#13+'La velocidad máxima alcanzada ha sido de '+FormatFloat('0000.00',VMax/1000)+' Mbps.',MtInformation,[MbOK],0,MbOK);
        end;
end;

end.

