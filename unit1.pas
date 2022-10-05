unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  dtthemedgauge, BCButton, BGRALabelFX, JvSimScope,
  RxVersInfo, HtmlView, LCLType, LCLIntF, HtmlGlobals, Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    BCButton1: TBCButton;
    BCButton2: TBCButton;
    Bevel1: TBevel;
    BGRALabelFX1: TBGRALabelFX;
    DTThemedGauge1: TDTThemedGauge;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    HtmlViewer1: THtmlViewer;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    JvSimScope1: TJvSimScope;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RxVersionInfo1: TRxVersionInfo;
    procedure BCButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HtmlViewer1HotSpotClick(Sender: TObject; const SRC: ThtString;
      var Handled: Boolean);
  private

  public

  end;

var
  Form1: TForm1;
  Ventana_Expandida: Boolean;
  numero_test: Word;
  cadena_test: String;

implementation

{$R *.frm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);

var
   Age: Int64;

begin
     Form1.Width:=368;
     JvSimScope1.VerticalGridSize:=LongInt.MaxValue;
     Ventana_Expandida:=False;
     Age:=FileAge('QuickSpeed.exe');
     HTMLViewer1.Text:=UnicodeString('<b>Test de velocidad <a href="http://baspeed.bandaancha.eu">QuickSpeed</a> v'+RXVersionInfo1.FileVersion+' ('+DateToStr(FileDateToDateTime(Age))+')</b>.<br>'+
                       'Creado por José Ignacio Legido (usuario <b><a href="https://bandaancha.eu/usuarios/djnacho-60320">djnacho</a></b> de <b><a href="https://bandaancha.eu">bandaancha.eu</a></b>).<br><br>'+
                       'Este test de velocidad ha sido creado usando <b><a href="https://www.pilotlogic.com">CodeTyphon</a></b>, un IDE de código abierto para <b><a href="https://www.freepascal.org">freepascal</a></b>.<br>'+
                       'Este programa tiene licencia <b><a href="https://creativecommons.org/licenses/by/4.0/deed.es">Creative Commons 4.0</a></b>.<br>'+
                       'Dedicado a todos los usuarios de bandaancha.eu y a toda la comunidad internauta en general. Este software no sería posible sin su apoyo y ayuda.');
end;

procedure TForm1.BCButton1Click(Sender: TObject);
begin
     Form2.Visible:=True;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
     if (Key=VK_I) and (Shift=[ssCtrl]) then
        case Ventana_Expandida of
             False             : begin
                                      Ventana_Expandida:=True;
                                      Form1.Width:=801;
                                      Form1.Left:=(Screen.DesktopWidth-Form1.Width) div 2;
                                 end;
             True              : begin
                                      Ventana_Expandida:=False;
                                      Form1.Width:=368;
                                      Form1.Left:=(Screen.DesktopWidth-Form1.Width) div 2;
                                 end;
        end;
end;

procedure TForm1.HtmlViewer1HotSpotClick(Sender: TObject; const SRC: ThtString;
  var Handled: Boolean);
begin
     OpenURl(AnsiString(SRC));
end;

end.

