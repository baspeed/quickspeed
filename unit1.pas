//
// Test de velocidad de internet QuickSpeed (antiguo BASpeed)
// Creado por José Ignacio Legido (djnacho de bandaancha.eu), 2022
// Licencia GPL v3
// Versión 0.4.5.282 prebeta
//


unit Unit1;

{$mode objfpc}{$H+}

interface

// Librerías usadas por la ventana principal del programa

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  dtthemedgauge, BCButton, BGRACustomDrawn, RxVersInfo, LCLType,
  LCLIntF, ComCtrls, Grids, Spin, Unit2, HtmlView, HtmlGlobals,
  JvPageList, JvTabBar, TplLogGraphUnit, TplComboBoxUnit, indLCDDisplay,
  cySimpleGauge, IdHTTP, IdIOHandler, IdIOHandlerStack, IdSSLOpenSSL,
  IdComponent, IdSSLOpenSSLHeaders, PingSend;

type

  { TForm1 }
// Ventana principal del programa

  TForm1 = class(TForm)
    BCButton1: TBCButton;                              // Botón de seleccionar test en el mapa
    BCButton2: TBCButton;                              // Botón de iniciar el test de velocidad
    BCButton3: TBCButton;
    BCButton4: TBCButton;
    Bevel1: TBevel;                                    // Linea divisoria entre pantalla de test y panel informativo
    Bevel2: TBevel;
    Bevel3: TBevel;
    cySimpleGauge1: TcySimpleGauge;                    // Barra de progreso del test de velocidad
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
    ImageList1: TImageList;                            // Lista de imágenes para usar con la aplicación
    JvPageList1: TJvPageList;                          // Lista de páginas para mostrar al usuario
    JvStandardPage1: TJvStandardPage;                  // Página del test de velocidad
    JvStandardPage2: TJvStandardPage;                  // Página del test de ping
    JvStandardPage3: TJvStandardPage;                  // Página del test de tracert
    JvTabBar1: TJvTabBar;                              // Control tab para seleccionar el tipo de test
    Label1: TLabel;                                    // Test de velocidad seleccionado en la ventana de selección de test
    Label13: TLabel;                                   // Texto que indica que hay que pulsar CTRL+I para ver el panel informativo de la aplicación
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;                                    // Etiqueta de la gráfica de velocidad 1000 Mbps
    Label3: TLabel;                                    // Etiqueta de la gráfica de velocidad 750 Mbps
    Label4: TLabel;                                    // Etiqueta de la gráfica de velocidad 500 Mbps
    Label5: TLabel;                                    // Etiqueta de la gráfica de velocidad 250 Mbps
    Label6: TLabel;                                    // Etiqueta de la gráfica de velocidad 0 Mbps
    LCDDisplay1: TLCDDisplay;                          // Display digital de velocidad
    LCDDisplay2: TLCDDisplay;
    LCDDisplay3: TLCDDisplay;
    LCDDisplay4: TLCDDisplay;
    LCDDisplay5: TLCDDisplay;
    LCDDisplay6: TLCDDisplay;
    LCDDisplay7: TLCDDisplay;
    plComboBox1: TplComboBox;
    plComboBox2: TplComboBox;
    plLogGraph1: TplLogGraph;                          // Gráfica de velocidad
    RxVersionInfo1: TRxVersionInfo;                    // Obtiene la versión del archivo ejecutable QuickSpeed.exe
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    Timer1: TTimer;                                    // Temporizador para mostrar los datos del test de velocidad en un intervalo determinado
    procedure BCButton1Click(Sender: TObject);         // Llama a rutina que permite seleccionar un test de velocidad de un mapa
    procedure BCButton2Click(Sender: TObject);         // Llama a la rutina que inicia el test de velocidad
    procedure FormActivate(Sender: TObject);           // Se llama a esta rutina cuando se activa la ventana en la primera ejecución del programa
    procedure FormCreate(Sender: TObject);             // Rutina que se ejecuta al crear la ventana (antes de visualizarla)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);  // Rutina que permite examinar las pulsaciones del teclado dentro de la aplicación
    procedure HtmlViewer1HotSpotClick(Sender: TObject; const SRC: ThtString;    // Rutina que abre un enlace dentro del texto HTML de descripción de la aplicación
      var Handled: Boolean);
    procedure IniciaPing(Sender: TObject);
    procedure IniciaTracert(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);            // Rutina que muestra los datos del test de velocidad cuando ha pasado el intervalo especificado

    procedure MuestraDatosPing;
    procedure MuestraErrorPing;
    procedure MuestraDatosTracert1;
    procedure MuestraDatosTracert2;
    procedure MuestradatosTracert3;
    procedure ErrorTracert1;
    procedure ErrorTracert2;
    procedure ErrorTracert3;
    procedure ErrorWebPais;

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

  TECo = class(TThread)                                // Objeto que permite realizar un ping a un servidor mediante un hilo de ejecución simultanea con el programa pincipal
         servidor: string;                             // nombre del servidor
         infoip: string;                               // información de la ip (mediante ip-api.com)
         latitud, longitud: single;                    // latitud y longitud de la IP (no se usa en esta versión, para futuras versiones)
         respuestainfoip: string;                      // respuesta de la web ip-api.com
         web: TIdHTTP;                                 // objeto web que accede a la web ip-api.com
         io: TIdIOHandlerStack;                        // Manejador de conexiones para el objeto web
         protected
                  procedure Execute; override;         // Rutina que permite realizar los pings a un servidor
  end;

  TTracert = class (TThread)                           // Objeto de permite realizar un tracert a un servidor (seguimiento de paquetes en la red) con un hilo de ejecución simultanea con el programa principal
             servidor: String;                         // Nombre del servidor
             infoip: string;                           // Información de la ip (mediante ip-api.com)
             latitud, longitud: single;                // Latitud y longitud de la IP (no se usa en esta versión, para futuras versiones)
             respuestainfoip: string;                  // Respuesta de la web ip-api.com
             web: TIdHTTP;                             // Objeto web que accede a ip-api.com
             io: TIdIOHandlerStack;                    // Manejador de conexiones del objeto web
             errorpais: Boolean;                       // Variable que indica que ha habido un error durante el test de tracert
             protected
                      procedure Execute; override;     // Rutina que permite realizar los tracerts a un servidor
  end;

  const
       TAMBUFFER:integer=256*1024;                 // Tamaño del buffer de recepción de datos = 512 KBytes
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
  testactivo: Boolean;                        // Determina si hay algún test de velocidad ejecutándose o no
  VMax: UInt64;                               // Velocidad máxima marcada por el test de velocidad en un momento determinado
  contadorping: Integer;                      // Contador de pings para el test de ping y el test de tracert
  Ping: TPingSend;                            // Objeto que puede realizar pings a servidores (protocolo ICMP)
  tiempoping: Integer;
  servidorping: String;
  paisipshort, paisiplong: String;
  cadenainfo: TStringList;

implementation

{$R *.frm}

procedure TForm1.ErrorWebPais;

begin
     // Sólo se pueden coger datos de 45 IP's por minuto. Si se supera ese límite (versiòn gratuita de la API) se debe esperar un minuto para realizar un ping o tracert
     MessageDlg('Error al recoger información de IP','No se puede acceder a más registros de información de IPs hasta que haya pasado un minuto debido a la limitación impuesta desde ip-api.com de 45 IPs por minuto.'+#10+'Espere un minuto para volver a realizar peticiones de información de IPs',mtInformation,[MbOK],0,MbOK);
end;

procedure TForm1.ErrorTracert1;

begin
     StringGrid2.Cells[2,contadorping]:='NR'; // Muestra NR en la zona del ping1 si no ha respondido al ping al primer intento
end;

procedure TForm1.ErrorTracert2;

begin
     StringGrid2.Cells[3,contadorping]:='NR'; // Muestra NR en la zona del ping2 si no ha respondido al ping al segundo intento
end;

procedure TForm1.ErrorTracert3;

begin
     StringGrid2.Cells[4,contadorping]:='NR'; // Muestra NR en la zona del ping3 si no ha respondido al ping al tercer intento
end;

procedure TForm1.MuestraDatosTracert1;

begin
     StringGrid2.Cells[1,contadorping]:=servidorping;        // Escribe la IP del servidor
     StringGrid2.Cells[2,contadorping]:=IntToStr(tiempoping);          // Escribe el tiempo del ping en milisegundos
     if (StringGrid2.Cells[6,contadorping]='') then                    // Si los datos del pais aún no se habían mostrado mostrarlos
        begin
             StringGrid2.Cells[5,contadorping]:=paisipshort;           // Escribe el nombre corto del pais
             StringGrid2.Cells[6,contadorping]:=paisiplong;            // Escribe el nombre largo del pais
        end;
end;

procedure TForm1.MuestraDatosTracert2;

begin
     StringGrid2.Cells[1,contadorping]:=servidorping;        // Escribe la IP del servidor
     StringGrid2.Cells[3,contadorping]:=IntToStr(tiempoping);          // Escribe el tiempo del ping en milisegundos
     if (StringGrid2.Cells[6,contadorping]='') then                    // Si los datos del pais aún no se habían mostrado mostrarlos
        begin
             StringGrid2.Cells[5,contadorping]:=paisipshort;           // Escribe el nombre corto del pais
             StringGrid2.Cells[6,contadorping]:=paisiplong;            // Escribe el nombre largo del pais
        end;
end;

procedure TForm1.MuestraDatosTracert3;

begin
     StringGrid2.Cells[1,contadorping]:=servidorping;        // Escribe la IP del servidor
     StringGrid2.Cells[4,contadorping]:=IntToStr(tiempoping);          // Escribe el tiempo del ping en milisegundos
     if (StringGrid2.Cells[6,contadorping]='') then                    // Si los datos del pais aun no se habían mostrado mostrarlos
        begin
             StringGrid2.Cells[5,contadorping]:=paisipshort;           // Escribe el nombre corto del pais
             StringGrid2.Cells[6,contadorping]:=paisiplong;            // Escribe el nombre largo del pais
        end;
end;

procedure TForm1.MuestraDatosPing;

begin
     StringGrid1.Cells[1,contadorping]:=servidorping;        // Escribe la IP del servidor
     StringGrid1.Cells[2,contadorping]:=IntToStr(tiempoping);          // Escribe el tiempo del ping en milisegundos
     StringGrid1.Cells[3,contadorping]:=paisipshort;                   // Muestra nombre corto del pais
     StringGrid1.Cells[4,contadorping]:=paisiplong;                    // Muestra nombra largo del pais
end;

procedure TForm1.MuestraErrorPing;

begin
     StringGrid1.Cells[1,contadorping]:='Servidor no responde';        // Mensaje de error en columna de servidor
     StringGrid1.Cells[2,contadorping]:='No Responde';          // Mensaje de error en columna de tiempo de ping
     StringGrid1.Cells[3,contadorping]:='--';                   // Nombre corto del pais --
     StringGrid1.Cells[4,contadorping]:='--';                   // Nombre largo del pais --
end;

procedure TTracert.Execute;

var
   final: string;

begin
     web:=TIdHTTP.Create;                                       // Crea el objeto web para acceder a ip-api.com
     io:=TIdIOHandlerStack.Create;                              // Crea manejador de conexiones para el objeto web
     web.IOHandler:=io;                                         // Asigna manejador de conexiones a objeto web
     io.ReadTimeout:=2000;                                      // Tiempo error lectura 2000 ms (2seg)
     io.ConnectTimeout:=2000;                                   // Tiempo error conexión 2000 ms (2 seg)
     cadenainfo:=TSTringList.Create;                            // Lista de cadena de caracteres para información de IP
     errorpais:=False;                                          // No hay errores en la IP detectados por ip-api.com
     if Ping.Ping(Form1.plComboBox2.Text) then                  // Si la IP responde a ping
        begin
             final:=Ping.ReplyFrom;                             // IP final del tracert
             Ping.TTL:=1;                                       // Pone el TTL del ping a 1 para el primer salto
             contadorping:=1;                                   // Contadorping a mismo valor que TTL
             repeat
                   if Ping.Ping(Form1.plComboBox2.Text) and (errorpais=False) then      // Si hay ping y la info de ip-api.com es correcta
                      begin
                           cadenainfo.Clear;                                  // Limpia la lista de cadena de caracteres
                           tiempoping:=Ping.PingTime;                         // Asigna tiempo de ping
                           servidorping:=Ping.ReplyFrom;                      // Asigna servidor que ha respondido al salto
                           try
                              respuestainfoip:=web.Get('http://ip-api.com/line/'+Ping.ReplyFrom+'?lang=en');       // Accede a ip-info.com
                              cadenainfo.AddText(respuestainfoip);                                                 // Rellena lista de cadenas de caracteres
                              if (cadenainfo[0]='success') then                                                    // Si todo es correcto
                                 begin
                                      paisipshort:=cadenainfo[2];                                                  // Rellena nombre de pais corto
                                      paisiplong:=cadenainfo[1];                                                   // Rellena nombre de pais largo
                                 end
                              else
                                  begin
                                       paisipshort:='--';                                                          // Rellena -- en nombre de pais corto
                                       paisiplong:=cadenainfo[1];                                                  // Rellena mensaje de error en nombre de pais largo
                                  end;
                              if (errorpais=False) then                                                            // Si no hay error a la hora de devolver la info de ip-api.com
                                 Synchronize(@Form1.MuestraDatosTracert1);                                         // Muestra los datos por pantalla
                           except
                                 begin                                                                             // Muestra el mensaje de error de esperar 1 minuto antes de hacer otro tracert
                                      Synchronize(@Form1.ErrorWebPais);
                                      errorpais:=True;                                                             // Variable error pais a True
                                 end;
                           end;
                      end
                   else
                       if (errorpais=False) then
                          Synchronize(@Form1.ErrorTracert1);
                   if Ping.Ping(Form1.plComboBox2.Text) and (errorpais=False) then                                 // Corta - Pega del primer IF
                      begin
                           cadenainfo.Clear;
                           tiempoping:=Ping.PingTime;
                           servidorping:=Ping.ReplyFrom;
                           if (Form1.StringGrid2.Cells[6,contadorping]='') then
                           begin
                                try
                                   respuestainfoip:=web.Get('http://ip-api.com/line/'+Ping.ReplyFrom+'?lang=en');
                                   cadenainfo.AddText(respuestainfoip);
                                   if (cadenainfo[0]='success') then
                                      begin
                                           paisipshort:=cadenainfo[2];
                                           paisiplong:=cadenainfo[1];
                                      end
                                   else
                                       begin
                                            paisipshort:='--';
                                            paisiplong:=cadenainfo[1];
                                       end;
                                except
                                      begin
                                            Synchronize(@Form1.ErrorWebPais);
                                            errorpais:=True;
                                      end;
                                end;
                           end;
                           if (errorpais=False) then
                              Synchronize(@Form1.MuestraDatosTracert2);
                      end
                   else
                       if (errorpais=False) then
                          Synchronize(@Form1.ErrorTracert2);
                   if Ping.Ping(Form1.plComboBox2.Text) and (errorpais=False) then                               // Corta-pega del primer IF
                      begin
                           cadenainfo.Clear;
                           tiempoping:=Ping.PingTime;
                           servidorping:=Ping.ReplyFrom;
                           if (Form1.StringGrid2.Cells[6,contadorping]='') then
                              begin
                                   try
                                      respuestainfoip:=web.Get('http://ip-api.com/line/'+Ping.ReplyFrom+'?lang=en');
                                      cadenainfo.AddText(respuestainfoip);
                                      if (cadenainfo[0]='success') then
                                         begin
                                              paisipshort:=cadenainfo[2];
                                              paisiplong:=cadenainfo[1];
                                         end
                                      else
                                          begin
                                               paisipshort:='--';
                                               paisiplong:=cadenainfo[1];
                                          end;
                                   except
                                         begin
                                              Synchronize(@Form1.ErrorWebPais);
                                              errorpais:=True;
                                         end;
                                   end;
                              end;
                           if (errorpais=False) then
                              Synchronize(@Form1.MuestradatosTracert3);
                      end
                   else
                       if (errorpais=False) then
                       Synchronize(@Form1.ErrorTracert3);
                   inc(contadorping,1);
                   Ping.TTL:=contadorping;
             until (Ping.ReplyFrom=final) or (contadorping>=Form1.SpinEdit2.Value) or (errorpais);  //Realiza el test hasta que se llegue a la IP destino o se supere el límite de saltos puesto por el usuario o se produzca un error en los datos de ip-api.com
             Ping.Free;                   // Libera el objeto para hacer los pings
             web.Free;                    // Libera el objeto para acceder a ip-api.com
             io.Free;                     // Libera el manejador de conexiones del objeto web
             cadenainfo.Free;             // Libera la cadena de caracteres
        end;
end;

procedure TEco.Execute;

begin
     web:=TIdHTTP.Create;                                    // Crea objeto HTTP para poder acceder a ip-api.com (la web que nos informa de la geolocalización de IP's)
     io:=TIdIOHandlerStack.Create;                           // Crea el objeto io que va a manejar las conexiones del objeto web
     web.IOHandler:=io;                                      // Asigna el manejador de conexiones al objeto web
     io.ReadTimeout:=2000;                                   // Tiempo de espera antes de error del manejador de conexiones (lectura)
     io.ConnectTimeout:=2000;                                // Tiempo de espera antes de error del manejador de conexiones (conexión)
     cadenainfo:=TStringList.Create;                         // Crea la lista de cadenas de caracteres que va a contener toda la info proporcionada por ip-pi.com
     for contadorping:=1 to Form1.SpinEdit1.Value do       // Lanza tantos pings como indique el valor del contador de pings
         begin
              if Ping.Ping(Form1.plComboBox1.Text) then    // Si el ping es correcto
                 begin
                      tiempoping:=Ping.PingTime;           // Recoge el tiempo del ping
                      servidorping:=Ping.ReplyFrom;        // IP del servidor destino
                      try
                         respuestainfoip:=web.Get('http://ip-api.com/line/'+Ping.ReplyFrom+'?lang=en');    // Recoge la info de la IP (en inglés)
                         cadenainfo.AddText(respuestainfoip);                                              // Saca todas las cadenas de texto de la info
                         if (cadenainfo[0]='success') then                                                 // Si la IP es correcta
                            begin
                                 paisipshort:=cadenainfo[2];                                               // Rellena el valor de nombre de pais corto
                                 paisiplong:=cadenainfo[1];                                                // Rellena el valor de nombre de pais largo
                            end
                         else
                             begin
                                  paisipshort:='--';                                                       // Rellena el valor de nombre de pais corto con --
                                  paisiplong:=cadenainfo[1];                                               // Rellena el valor de nombre de pais largo con el mensaje de error
                             end;
                         Synchronize(@Form1.MuestraDatosPing);                                             // Muestra los datos por pantalla
                      except
                            begin
                                 Synchronize(@Form1.ErrorWebPais);                                         // Muestra datos de error de IP
                                 break;
                            end;
                      end;
                 end
              else                                                                         // Si hay algún fallo al realizar el ping
                  Synchronize(@Form1.MuestraErrorPing);
         end;
     Ping.Free;                                                                            // Libera el objeto para hacer pings
     web.Free;                                                                             // Librera el objeto para acceder a la web
     io.Free;                                                                              // Libera el manejador de conexiones del objeto web
     cadenainfo.Free;                                                                      // Libera la lista de cadenas de caracteres
end;

// Rutina de ejecución de cada hilo simultaneo de descarga

procedure TDescarga.Execute;

begin
     tpc:=0;                                                           // Inicializa el tanto por ciento descargadp a 0
     web:=TidHTTP.Create;                                              // Crea el objeto HTTP que permite descargar archivos de servidores
     buffermemoria:=TMemoryStream.Create;                              // Crea el buffer en memoria con el tamaño indicado en TAMBUFER
     buffermemoria.SetSize(TAMBUFFER);
     case numero_test of                                               // En caso del valor de numero_test
          1,3,6,7,8,9,10,11,12,13: begin                               // Números de tests que utilizan protocolo SSL
                  sslioh:=TIdSSLIOHandlerSocketOpenSSL.Create;         // Crea el manejador de datos SSL para el objeto HTTP
                  sslioh.ConnectTimeout:=5000;                         // 5 segundos de tiempo de espera de conexión antes de error
                  sslioh.ReadTimeout:=5000;                            // 5 segundos de tiempo de espera para lectura de datos antes de eror
                  sslioh.RecvBufferSize:=TAMBUFFER;                    // Tamaño del buffer de recepción
                  web.IOHandler:=sslioh;                               // Asigna el manejador de datos SSL al manejador por defecto del objeto HTTP
                  sslioh.SSLOptions.Method:=sslvSSLv23;                // Asigna todos los métodos SSL posibles para realizar la comunicación SSL con cualquier servidor SSL
             end;
          2,4,5 : begin                                                // Números de tests que utilizan HTTP normal (sin SSL)
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
         if (numero_test=7) then
            tam:=104857600; // Se asignan 100 MB al test de hetzner.de que es el tamaño del archivo (se comprueba desde speed.hetzner.de)
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
   contador: Integer;               // Variable para inicializar las tablas de ping y tracert

begin
     testactivo:=False;                                    // No hay ningún test de velocidad activo
     cancelartestvelocidad:=False;                         // Pone la variable que indica que se ha cancelado el test al valor por defecto de inicio (False)
     Form1.Width:=Bevel1.Left;                       // Ancho de la ventana = Posición X de la linea vertical que separa el panel principal del expandido en la ventana principal
     Ventana_Expandida:=False;                             // La ventana se inicializa con el valor de ventana compacta (sin expandir)
     {$IFDEF UNIX}                                         // Si se compila el programa para Linux
     Age:=FileAge('./QuickSpeed');                         // Fecha de modificación del ejecutable en formato de 4 bytes
     IdOpenSSLSetLibPath('./');                            // Donde tiene que encontrar el ejecutable las librerías para acceder al protocolo HTTPS
     Form1.Caption:='QuickSpeed Linux Edition';            // Cambia el título de la ventana para que vea que la edición es la de Linux
     {$ENDIF}
     {$IFDEF WINDOWS}                                        // Si se compila el programa para Windows
     Age:=FileAge('.\QuickSpeed.exe');                       // Fecha de modificación del ejecutable en formato de 4 bytes
     IdOpenSSLSetLibPath('.\');                              // Donde tiene que encontrar el ejecutable las librerías para acceder al protocolo HTTPS
     Form1.Caption:='QuickSpeed Windows Edition';            // Cambia el título de la ventana para que vea que la edición es la de Windows
     {$ENDIF}
     HTMLViewer1.Text:=UnicodeString('<b>Test de velocidad <a href="http://baspeed.bandaancha.eu">QuickSpeed</a> v'+RXVersionInfo1.FileVersion+' ('+FormatDateTime('DD-MM-YYYY',FileDatetoDateTime(Age))+')</b><br>'+
                       'Creado por José Ignacio Legido (usuario <b><a href="https://bandaancha.eu/usuarios/djnacho-60320">djnacho</a></b> de <b><a href="https://bandaancha.eu">bandaancha.eu</a></b>).<br><br>'+
                       'Este test de velocidad ha sido creado usando <b><a href="https://www.pilotlogic.com">CodeTyphon</a></b>, un IDE de código abierto para <b><a href="https://www.freepascal.org">freepascal</a></b>.<br>'+
                       'Este programa tiene licencia <b><a href="https://www.gnu.org/licenses/gpl-3.0-standalone">GPL v3</a></b>.<br>'+
                       'Dedicado a todos los usuarios de bandaancha.eu y a toda la comunidad internauta en general. Este software no sería posible sin su apoyo y ayuda.<br><br>'+
                       'Código fuente de este software disponible en <b><a href="https://github.com/baspeed/quickspeed">GitHub.com</a></b>'); // Presenta texto HTML de descripción de la aplicación en pantalla
     for contador:=1 to 32 do
         begin
              StringGrid1.Cells[0,contador]:=inttostr(contador);   // Inicializa la columna del número de ping (test de ping)
         end;
     for contador:=1 to 64 do
         begin
              StringGrid2.Cells[0,contador]:=inttostr(contador);   // Inicializa  la columna del número de salto (test de tracert)
         end;
end;

// Rutina que permite seleccionar un test de velocidad de un mapa

procedure TForm1.BCButton1Click(Sender: TObject);
begin
     Form2.Visible:=True;               // Hace visible la ventana que contiene el mapa
end;

// Rutina que se ejecuta cuando se pulsa el botón de iniciar/ cancelar test de velocidad

procedure TForm1.BCButton2Click(Sender: TObject);

var
   contadorhilo: integer;                                                    // Variable que contiene el número de hilo de descarga actual

begin
     if (testactivo=False) then                                              // Si no hay test de velocidad activo
        begin                                                                // Velocidad máxima = 0
             VMax:=0;                                                        // Test de velocidad activo
             testactivo:=True;                                               // Variable que indica que hay un test activo a True
             BCButton2.Caption:='Cancelar test de velocidad';                // Cambia texto del botón 2
             BCButton2.ImageIndex:=1;                                        // Cambia la imagen del botón para mostrar la imagen de cancelar
             BCButton1.Enabled:=False;                                       // Inhabilita el botón 1 para no poder elegir otro test en caso de iniciar el test
             for contadorhilo:=1 to NUMHILOS do                              // Desde 1 hasta el número de hilos predeterminado en el código fuente
                 hilosdescarga[contadorhilo]:=TDescarga.Create(True);        // Crea todos los hilos de descarga (6 simultaneos)
             Timer1.Enabled:=True;                                           // Inicia el Timer
             for contadorhilo:=1 to NUMHILOS do                              // Desde el hilo 1 hasta el hilo NUMMAX (6 por defecto en el código fuente original)
                 begin
                      case numero_test of                                    // Dependiendo del número de test, indica al hilo de ejecución un enlace o otro
                           1 : hilosdescarga[contadorhilo].enlace:='https://testvelocidad.eu/speed-test/download.bin';
                           2 : hilosdescarga[contadorhilo].enlace:='http://ipv4.download.thinkbroadband.com/100MB.zip';
                           3 : hilosdescarga[contadorhilo].enlace:='https://rbx.proof.ovh.net/files/100Mb.dat';
                           4 : hilosdescarga[contadorhilo].enlace:='http://es.download.nvidia.com/Windows/452.06/452.06-desktop-win10-64bit-international-dch-whql.exe';
                           5 : hilosdescarga[contadorhilo].enlace:='http://speedtest.london.linode.com/100MB-london.bin';
                           6 : hilosdescarga[contadorhilo].enlace:='https://ftp.rediris.es/debian-cd/11.7.0-live/amd64/iso-hybrid/debian-live-11.7.0-amd64-standard.iso';
                           7 : hilosdescarga[contadorhilo].enlace:='https://speed.hetzner.de/100MB.bin';
                           8 : hilosdescarga[contadorhilo].enlace:='https://testvelocidadvld.orange.es:8080/speedtest/random4000x4000.jpg';
                           9 : hilosdescarga[contadorhilo].enlace:='https://lon.speedtest.clouvider.net/1g.bin';
                           10 : hilosdescarga[contadorhilo].enlace:='https://man.speedtest.clouvider.net/1g.bin';
                           11 : hilosdescarga[contadorhilo].enlace:='https://fra.speedtest.clouvider.net/1g.bin';
                           12 : hilosdescarga[contadorhilo].enlace:='https://test2.fibertelecom.it/512MB.zip';
                           13 : hilosdescarga[contadorhilo].enlace:='https://nyc.speedtest.clouvider.net/1g.bin';
                      end;
                      hilosdescarga[contadorhilo].Start;                    // Inicia el hilo de ejecución
                 end
        end
     else
         cancelartestvelocidad:=True;                                       // Si se pulsa el botón con el test iniciado se activa esta variable para detener el test
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
     DTThemedGauge1.Update;                    // Actualiza el gráfico del velocímetro analógico para eliminar el fallo del pintado de control al activar la ventana
end;

// Rutina que permite conocer todas las pulsaciones de teclas dentro de la aplicación

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
     if (Key=VK_I) and (Shift=[ssCtrl]) then  // Si la pulsación es CTRL+I
        case Ventana_Expandida of             // Se verifica la variable Ventana_Expandida
             False             : begin        // Si está oculta
                                      Ventana_Expandida:=True; // Se pone la variable a True
                                      Form1.Width:=DTThemedGauge1.Width+GroupBox3.Width+25;        // Expande la ventana para que aparezca el panel informativo
                                      Form1.Left:=(Screen.DesktopWidth-Form1.Width) div 2;         // Centra la ventana en el escritorio
                                 end;
             True              : begin        // Si está visible
                                      Ventana_Expandida:=False; // Se pone la variable a False
                                      Form1.Width:=Bevel1.Left;                           // Vuelve a poner el ancho de ventana a la anchura original para ocultar el panel informativo
                                      Form1.Left:=(Screen.DesktopWidth-Form1.Width) div 2;         // Centra la ventana en el escritorio
                                 end;
        end;
end;

// Rutina que permite abrir un enlace que está dentro del texto HTML de la descripción de la aplicación

procedure TForm1.HtmlViewer1HotSpotClick(Sender: TObject; const SRC: ThtString;
  var Handled: Boolean);
begin
     OpenURl(AnsiString(SRC));                   // Transforma la variable SRC en AnsiString y abre el enlace en el navegador
end;

// Rutina que realiza el test de ping

procedure TForm1.IniciaPing(Sender: TObject);

var
   eco: TEco;
   contador: integer;

begin
     StringGrid1.Clean;                      // Limpia completamente ta tabla de texto del test de ping
     for contador:=1 to 32 do
         begin
              StringGrid1.Cells[0,contador]:=inttostr(contador);   // Inicializa la columna del número de ping (test de ping)
         end;
     Ping:=TPingSend.Create;                 // Crea el objeto que realiza los pings
     Ping.Timeout:=1000;                     // Pone un tiempo de espera de 1000 ms (1 segundo) por ping antes de error
     eco:=TEco.Create(True);                 // Crea el objeto que va a realizar los pings al servidor y pone el hilo de ejecución en espera
     eco.FreeOnTerminate:=True;              // Cuando el hilo de ejecución termine su ejecución librera todos sus recursos
     eco.Start;                              // Inicia el hilo de ejecución del ping a un servidor
end;

procedure TForm1.IniciaTracert(Sender: TObject);

var
   camino: TTracert;                            // Variable de tipo TTracert que permite realizar un tracert o seguimiento de paquetes en la red
   contador: integer;                           // Contador que permite saber si se ha llegado al tope de saltos indicado por el usuario

begin                                           // Borra la lista de resultados del tracert
     StringGrid2.Clean;
     for contador:=1 to 64 do                   // Imprime todos los números de salto (los 64)
         begin
              StringGrid2.Cells[0,contador]:=inttostr(contador);
         end;
     Ping:=TPingSend.Create;                                    // Crea el objeto que permite realizar pings
     Ping.Timeout:=1000;                                        // El tiempo de espera hasta fallo se establece en 1 segundo
     camino:=TTracert.Create(True);                             // Crea el hilo de ejecución simultánea
     camino.FreeOnTerminate:=True;                              // El hilo debe liberar toda su memoria y recursos cuando termine
     camino.Start;                                              // Comienza el hilo del tracert
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
     LCDDisplay2.Lines[0]:='Hilo 1';
     LCDDisplay2.Lines[1]:=FormatFloat('0000.00',hilosdescarga[1].velocidad/1000)+' Mbps';         // Escribe las velocidades de cada hilo en su lugar correspondiente
     LCDDisplay3.Lines[0]:='Hilo 2';
     LCDDisplay3.Lines[1]:=FormatFloat('0000.00',hilosdescarga[2].velocidad/1000)+' Mbps';
     LCDDisplay4.Lines[0]:='Hilo 3';
     LCDDisplay4.Lines[1]:=FormatFloat('0000.00',hilosdescarga[3].velocidad/1000)+' Mbps';
     LCDDisplay5.Lines[0]:='Hilo 4';
     LCDDisplay5.Lines[1]:=FormatFloat('0000.00',hilosdescarga[4].velocidad/1000)+' Mbps';
     LCDDisplay6.Lines[0]:='Hilo 5';
     LCDDisplay6.Lines[1]:=FormatFloat('0000.00',hilosdescarga[5].velocidad/1000)+' Mbps';
     LCDDisplay7.Lines[0]:='Hilo 6';
     LCDDisplay7.Lines[1]:=FormatFloat('0000.00',hilosdescarga[6].velocidad/1000)+' Mbps';
     DTThemedGauge1.Position:=velocidadtotal div 1000;
     if (velocidadtotal>VMax) then                                                             // Si la velocidad del test > velocidad máxima registrada hasta ese momento entonces
        VMax:=velocidadtotal;                                                                  // la velocidad máxima se corresponde con la velocidad del test
     LCDDisplay1.Lines[0]:='Vmedia: '+FormatFloat('0000.00',velocidadtotal/1000)+' Mbps';                 // Imprime la velocidad actual del test
     LCDDisplay1.Lines[1]:='Vmax  : '+FormatFloat('0000.00',VMax/1000)+' Mbps';                           // Imprime la velocidad máxima del test
     plLogGraph1.Add(velocidadtotal div 1000);                                                 // Añade valor a la gráfica de velocidad (traza linea de valor de velocidad y mueve datos hacia la izquierda)
     tpctotal:=0;                                                                              // Tanto por ciento total a 0
     for contadorhilos:=1 to NUMHILOS do                                                       // Desde 1 hasta NUMHILOS (6 por defecto en el código fuente original)
         tpctotal:=tpctotal+hilosdescarga[contadorhilos].tpc;                                  // Actualiza el tanto por ciento total, realizando la suma de todos los tantos por ciento y diviendo el valor entre el número de hilos (6)
     cySimpleGauge1.Position:=tpctotal div 6;                                                  // Actualiza la barra de progreso con el valor del tanto poor ciento total
     // Cuando se ha terminado el test de velocidad
     if (hilosdescarga[1].terminado=True) and (hilosdescarga[2].terminado=True) and (hilosdescarga[3].terminado=True) and (hilosdescarga[4].terminado=True) and (hilosdescarga[5].terminado=True) and (hilosdescarga[6].terminado=True) then
        begin
             BCButton1.Enabled:=True;                                                          // Botón 1 habilitado
             BCButton2.Caption:='Iniciar test de velocidad';                                   // Cambia texto del botón 2
             BCButton2.ImageIndex:=0;                                                          // Cambia la imagen del botón para mostrar la imagen de iniciar el test de velocidad
             for contadorhilos:=1 to NUMHILOS do                                               // Desde el hilo 1 hasta el numero máximo de hilos (6)
                 hilosdescarga[contadorhilos].Free;                                            // Libera la memoria de los hilos de ejecución simultanea
             timer1.Enabled:=False;                                                            // Para el timer para no seguir actualizando datos en la ventana principal
             cancelartestvelocidad:=False;                                                     // Pone el valor de Cancelar el test de velocidad a False
             testactivo:=False;                                                                // Ya no está activo el test de velocidad así que el test activo a False
             // Se muestra un cuadro de diálogo mostrando la velocidad máxima alcanzada en el test si este ha acabado con éxito o se ha cancelado por el usuario
             MessageDlg('Test de velocidad terminado','Test de velocidad terminado.'+#13+'La velocidad máxima alcanzada ha sido de '+FormatFloat('0000.00',VMax/1000)+' Mbps.',MtInformation,[MbOK],0,MbOK);
        end;
end;

end.

