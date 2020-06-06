unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    BtnEnviarString: TButton;
    Panel2: TPanel;
    BtnEnviarArquivo: TButton;
    GroupBox1: TGroupBox;
    BtnLogin: TButton;
    Label1: TLabel;
    EdtUsuario: TEdit;
    Label2: TLabel;
    EdtSenha: TEdit;
    Label3: TLabel;
    EdtCNPJEmitente: TEdit;
    MemStringXML: TMemo;
    OpenDialog1: TOpenDialog;
    BtnCarregarArquivoXML: TButton;
    Label4: TLabel;
    EdtUrlHost: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnLoginClick(Sender: TObject);
    procedure BtnEnviarStringClick(Sender: TObject);
    procedure BtnEnviarArquivoClick(Sender: TObject);
    procedure BtnCarregarArquivoXMLClick(Sender: TObject);
  private

  public
    FToken: string;
  end;

var
  Form1: TForm1;

implementation

uses
  api.plataforma.contador;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  PageControl1.ActivePageIndex := 0;
end;

procedure TForm1.BtnCarregarArquivoXMLClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    MemStringXML.Clear;
    MemStringXML.Lines.LoadFromFile(OpenDialog1.FileName);
  end;
end;

procedure TForm1.BtnLoginClick(Sender: TObject);
var
  ApiContador: IPlataformaContador;
begin
  ApiContador := CreateApiPlataformaContador;
  ApiContador.UrlHost := EdtUrlHost.Text;
  ApiContador.Usuario := EdtUsuario.Text;
  ApiContador.Senha   := EdtSenha.Text;

  ApiContador.Login;
  Ftoken := ApiContador.Token;

  ShowMessage(
    'e-mail: '        + ApiContador.Email                   + sLineBreak +
    'nome: '          + ApiContador.Nome                    + sLineBreak +
    'id contador: '   + ApiContador.ContabilistaId.ToString + sLineBreak +
    'nome contador: ' + ApiContador.ContabilistaNome
  );
end;

procedure TForm1.BtnEnviarStringClick(Sender: TObject);
var
  ApiContador: IPlataformaContador;
begin
  if MemStringXML.Text = '' then
    raise Exception.Create('Informe o conteúdo do documento XML que deseja enviar!');

  ApiContador := CreateApiPlataformaContador;
  ApiContador.UrlHost     := EdtUrlHost.Text;
  ApiContador.Usuario     := EdtUsuario.Text;
  ApiContador.Senha       := EdtSenha.Text;
  ApiContador.CnpjCliente := EdtCNPJEmitente.Text;

  if ApiContador.EnviarXMLString(TTipoDocumento.tpcSaida, MemStringXML.Text) then
    ShowMessage('Arquivo enviado');
end;

procedure TForm1.BtnEnviarArquivoClick(Sender: TObject);
var
  ApiContador: IPlataformaContador;
begin
  if OpenDialog1.Execute then
  begin
    ApiContador := CreateApiPlataformaContador;
    ApiContador.UrlHost     := EdtUrlHost.Text;
    ApiContador.Usuario     := EdtUsuario.Text;
    ApiContador.Senha       := EdtSenha.Text;
    ApiContador.CnpjCliente := EdtCNPJEmitente.Text;

    if ApiContador.EnviarXMLArquivo(TTipoDocumento.tpcSaida, OpenDialog1.FileName) then
      ShowMessage('Arquivo enviado');
  end;
end;

end.

