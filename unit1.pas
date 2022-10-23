//
// Test de velocidad de internet QuickSpeed (antiguo BASpeed)
// Creado por José Ignacio Legido (djnacho de bandaancha.eu), 2022
// Licencia GPL v3
// Versión 0.1 alfa (en desarrollo temprano)
//


unit Unit1;

{$mode objfpc}{$H+}

interface

// Librerías usadas por la ventana principal del programa

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  dtthemedgauge, BCButton, BGRALabelFX, JvSimScope,
  RxVersInfo, HtmlView, LCLType, LCLIntF, HtmlGlobals, Unit2;

type

  { TForm1 }
// Ventana principal del programa

  TForm1 = class(TForm)
    BCButton1: TBCButton;                              // Botón de seleccionar test en el mapa
    BCButton2: TBCButton;                              // Botón de iniciar el test de velocidad
    Bevel1: TBevel;                                    // Linea divisoria entre pantalla de test y panel informativo
    BGRALabelFX1: TBGRALabelFX;                        // Velocidad en Mbps en efecto especial de texto
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
    procedure BCButton1Click(Sender: TObject);         // Llama a rutina que permite seleccionar un test de velocidad de un mapa
    procedure FormCreate(Sender: TObject);             // Rutina que se ejecuta al crear la ventana (antes de visualizarla)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);  // Rutina que permite examinar las pulsaciones del teclado dentro de la aplicación
    procedure HtmlViewer1HotSpotClick(Sender: TObject; const SRC: ThtString;    // Rutina que abre un enlace dentro del texto HTML de descripción de la aplicación
      var Handled: Boolean);
  private

  public

  end;

var
  Form1: TForm1;                              // Ventana principal
  Ventana_Expandida: Boolean;                 // Indica cuando el panel informativo está abierto / cerrado
  numero_test: Word;                          // Número asignado al test seleccionado
  cadena_test: String;                        // Cadena de texto para mostrar el test de velocidad seleccionado

implementation

{$R *.frm}

{ TForm1 }

// Rutina que se ejcuta antes de visualizar la ventana principal del programa (inicia toda la aplicación antes de visualizarla en pantalla)

procedure TForm1.FormCreate(Sender: TObject);

var
   Age: Int64;                      // Variable que guarda la fecha de modificación del archivo QuickSpeed.exe

begin
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

// Rutina que permite abrir un enlace que está dentro del texto HTML de la descripción de la aplicación

procedure TForm1.HtmlViewer1HotSpotClick(Sender: TObject; const SRC: ThtString;
  var Handled: Boolean);
begin
     OpenURl(AnsiString(SRC));                   // Transforma la variable SRC en AnsiString y abre el enlace en el navegador
end;

end.

