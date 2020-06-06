unit api.plataforma.contador;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes;

type
  EPlataformaContadorAPI = class(Exception);

  TTipoDocumento = (tpcEntrada, tpcSaida);

  IPlataformaContador = interface(IInterface)
  ['{C87AFB5C-B3B0-44C8-8E1A-3112C71DC42E}']
    function GetContabilistaId: Integer;
    function GetContabilistaNome: string;
    function GetEmail: string;
    function GetNome: string;
    function GetSenha: string;
    function GetTipo: Integer;
    function GetToken: string;
    function GetUsuario: string;
    function GetCnpjCliente: string;
    function GetUrlHost: string;
    procedure SetSenha(const Value: string);
    procedure SetUsuario(const Value: string);
    procedure SetCnpjCliente(const Value: string);
    procedure SetToken(const Value: string);
    procedure SetUrlHost(const Value: string);

    function Login: Boolean;
    function EnviarXMLString(const ATipo: TTipoDocumento; const AXML: string): Boolean;
    function EnviarXMLArquivo(const ATipo: TTipoDocumento; const APathXML: string): Boolean;

    property UrlHost: string read GetUrlHost write SetUrlHost;
    property Usuario: string read GetUsuario write SetUsuario;
    property Senha: string read GetSenha write SetSenha;
    property Email: string read GetEmail;
    property Nome: string read GetNome;
    property Tipo: Integer read GetTipo;
    property Token: string read GetToken write SetToken;
    property CnpjCliente: string read GetCnpjCliente write SetCnpjCliente;
    property ContabilistaId: Integer read GetContabilistaId;
    property ContabilistaNome: string read GetContabilistaNome;
  end;

function CreateApiPlataformaContador: IPlataformaContador;

implementation

uses
  REST.Client,
  REST.Types,
  REST.Utils,
  System.JSON;

type
  TTipoEnvio = (tpeString, tpeXML);

  TPlataformaContadorAPI = class(TInterfacedObject, IPlataformaContador)
  private
    FRestClient: TRestClient;
    FRestRequest: TRESTRequest;
    FRestResponse: TRESTResponse;

    FUrlHost: string;
    FUsuario: string;
    FSenha: string;
    FToken: string;
    FEmail: string;
    FNome: string;
    FCNPJEmitente: string;
    FTipo: Integer;
    FContabilistaId: Integer;
    FContabilistaNome: string;
    function GetContabilistaId: Integer;
    function GetContabilistaNome: string;
    function GetEmail: string;
    function GetNome: string;
    function GetSenha: string;
    function GetTipo: Integer;
    function GetToken: string;
    function GetUsuario: string;
    function GetCnpjCliente: string;
    function GetUrlHost: string;
    procedure SetSenha(const Value: string);
    procedure SetUsuario(const Value: string);
    procedure SetCnpjCliente(const Value: string);
    procedure SetToken(const Value: string);
    procedure SetUrlHost(const Value: string);

    procedure CreateComponentes;
    procedure FreeComponentes;
    procedure ConfigurarRESTClient;
    procedure ConfigurarRESTRequest;
    procedure ConfigurarToken;
    function GetURLEnvio(const ATipoEnvio: TTipoEnvio; const ATipoDocumento: TTipoDocumento): String;
    function GetJSONLogin: string;
    function GetMensagemErro(const AJsonValue: TJSONValue): string;
    function TratarRetornoEnvio(const AResposta: TRESTResponse): Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function Login: Boolean;
    function EnviarXMLString(const ATipo: TTipoDocumento; const AXML: string): Boolean;
    function EnviarXMLArquivo(const ATipo: TTipoDocumento; const APathXML: string): Boolean;
  end;

function CreateApiPlataformaContador: IPlataformaContador;
begin
  Result := TPlataformaContadorAPI.Create;
end;

{ TPlataformaContadorAPI }

constructor TPlataformaContadorAPI.Create;
begin
  inherited;

end;

destructor TPlataformaContadorAPI.Destroy;
begin

end;

function TPlataformaContadorAPI.GetCnpjCliente: string;
begin
  Result := FCNPJEmitente;
end;

function TPlataformaContadorAPI.GetContabilistaId: Integer;
begin
  Result := FContabilistaId;
end;

function TPlataformaContadorAPI.GetContabilistaNome: string;
begin
  Result := FContabilistaNome;
end;

function TPlataformaContadorAPI.GetEmail: string;
begin
  Result := FEmail;
end;

function TPlataformaContadorAPI.GetNome: string;
begin
  Result := FNome;
end;

function TPlataformaContadorAPI.GetSenha: string;
begin
  Result := FSenha;
end;

function TPlataformaContadorAPI.GetTipo: Integer;
begin
  Result := FTipo;
end;

function TPlataformaContadorAPI.GetToken: string;
begin
  Result := FToken;
end;

function TPlataformaContadorAPI.GetUrlHost: string;
begin
  Result := FUrlHost;
end;

function TPlataformaContadorAPI.GetUsuario: string;
begin
  Result := FUsuario;
end;

procedure TPlataformaContadorAPI.SetCnpjCliente(const Value: string);
begin
  if FCNPJEmitente <> Value then
    FCNPJEmitente := Value;
end;

procedure TPlataformaContadorAPI.SetSenha(const Value: string);
begin
  if FSenha <> Value then
    FSenha := Value;
end;

procedure TPlataformaContadorAPI.SetToken(const Value: string);
begin
  if FToken <> Value then
    FToken := Value;
end;

procedure TPlataformaContadorAPI.SetUrlHost(const Value: string);
begin
  if FUrlHost <> Value then
    FUrlHost := Value;
end;

procedure TPlataformaContadorAPI.SetUsuario(const Value: string);
begin
  if FUsuario <> Value then
    FUsuario := Value;
end;

procedure TPlataformaContadorAPI.ConfigurarRESTClient;
begin
  FRestClient.BaseURL             := FUrlHost;
  FRestClient.Accept              := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  FRestClient.AcceptCharset       := 'utf-8, *;q=0.8';
  FRestClient.ContentType         := 'text/html';
  FRestClient.HandleRedirects     := True;
  FRestClient.RaiseExceptionOn500 := False;
  FRestClient.Params.Clear;
end;

procedure TPlataformaContadorAPI.ConfigurarRESTRequest;
begin
  FRestRequest.Client             := FRestClient;
  FRestRequest.Response           := FRestResponse;
  FRestRequest.SynchronizedEvents := False;
  FRestRequest.Params.Clear;
  FRestRequest.ClearBody;
end;

procedure TPlataformaContadorAPI.ConfigurarToken;
begin
  if not FToken.Trim.IsEmpty then
  begin
    FRestRequest.AddAuthParameter(
      'Authorization',
      'bearer ' + FToken,
      pkHTTPHEADER,
      [poDoNotEncode]
    );
  end;
end;

procedure TPlataformaContadorAPI.CreateComponentes;
begin
  FRestClient   := TRESTClient.Create(nil);
  FRestResponse := TRESTResponse.Create(nil);
  FRestRequest  := TRESTRequest.Create(nil);

  ConfigurarRESTClient;
  ConfigurarRESTRequest;
  ConfigurarToken;
end;

procedure TPlataformaContadorAPI.FreeComponentes;
begin
  if Assigned(FRestResponse) then
    FRestResponse.DisposeOf;

  if Assigned(FRestRequest) then
    FRestRequest.DisposeOf;

  if Assigned(FRestClient) then
    FRestClient.DisposeOf;
end;

function TPlataformaContadorAPI.GetURLEnvio(const ATipoEnvio: TTipoEnvio; const ATipoDocumento: TTipoDocumento): String;
begin
  Result := FCNPJEmitente + '/' + IntToStr(Integer(ATipoDocumento));
  case ATipoEnvio of
    tpeString: Result := '/api/v1/NFeString/'  + Result;
    tpeXML   : Result := '/api/v1/NFeArquivo/' + Result;
  else
    raise EPlataformaContadorAPI.Create('Tipo desconhecido em GetURLEnvio');
  end;
end;

function TPlataformaContadorAPI.GetJSONLogin: string;
var
  ObJSON: TJSONObject;
begin
  if FUsuario.Trim.IsEmpty then
    raise EPlataformaContadorAPI.Create('Usuário não foi informado.');

  if FSenha.Trim.IsEmpty then
    raise EPlataformaContadorAPI.Create('Senha não foi informada.');

  ObJSON := TJSONObject.Create;
  try
    obJSON.AddPair('email', FUsuario);
    obJSON.AddPair('senha', FSenha);

    Result := ObJSON.ToJSON;
  finally
    ObJSON.DisposeOf;
  end;
end;

function TPlataformaContadorAPI.GetMensagemErro(const AJsonValue: TJSONValue): string;
var
  Msg, XML, Mensagem: string;
begin
  AJsonValue.TryGetValue('msg', Msg);
  AJsonValue.TryGetValue('arquivosRuins[0].xml', XML);
  AJsonValue.TryGetValue('arquivosRuins[0].mensagem', Mensagem);

  Result := '';
  if not Msg.Trim.IsEmpty then
    Result := Result + sLineBreak + Msg;
  if not XML.Trim.IsEmpty then
    Result := Result + sLineBreak + XML;
  if not Mensagem.Trim.IsEmpty then
    Result := Result + sLineBreak + Mensagem;

  Result := Result.Trim;
end;

function TPlataformaContadorAPI.TratarRetornoEnvio(const AResposta: TRESTResponse): Boolean;
begin
  Result := AResposta.StatusCode = 200;
  if not Result then
  begin
    if AResposta.StatusCode = 400 then
      raise EPlataformaContadorAPI.Create(GetMensagemErro(AResposta.JSONValue))
    else
      raise EPlataformaContadorAPI.CreateFmt('%d - %s', [AResposta.StatusCode, AResposta.StatusText]);
  end;
end;

function TPlataformaContadorAPI.Login: Boolean;
begin
  CreateComponentes;
  try
    FRestRequest.Resource := '/api/v1/login';
    FRestRequest.Method   := TRESTRequestMethod.rmPOST;
    FRestRequest.Body.Add(GetJSONLogin, TRESTContentType.ctAPPLICATION_JSON);
    FRestRequest.Execute;

    Result := FRestResponse.StatusCode = 200;
    if Result then
    begin
      FToken            := FRestResponse.JSONValue.GetValue<string>('token');
      FEmail            := FRestResponse.JSONValue.GetValue<string>('email');
      FNome             := FRestResponse.JSONValue.GetValue<string>('nome');
      FTipo             := FRestResponse.JSONValue.GetValue<Integer>('tipo');
      FContabilistaId   := FRestResponse.JSONValue.GetValue<Integer>('contabilistaId');
      FContabilistaNome := FRestResponse.JSONValue.GetValue<string>('contabilistaNome');
    end
    else
    begin
      if FRestResponse.StatusCode = 401 then
        raise EPlataformaContadorAPI.Create('Nome de Usuário ou Senha incorretos.')
      else
      if FRestResponse.StatusCode <> 200 then
        raise EPlataformaContadorAPI.CreateFmt('%d - %s', [FRestResponse.StatusCode, FRestResponse.StatusText]);
    end;
  finally
    FreeComponentes;
  end;
end;

function TPlataformaContadorAPI.EnviarXMLString(const ATipo: TTipoDocumento; const AXML: string): Boolean;
begin
  if FToken.Trim.IsEmpty then
    Login;

  CreateComponentes;
  try
    FRestRequest.Method   := TRESTRequestMethod.rmPOST;
    FRestRequest.Resource := GetURLEnvio(tpeString, ATipo);
    FRestRequest.AddBody(AXML, TRESTContentType.ctTEXT_PLAIN);
    FRestRequest.Execute;

    Result := TratarRetornoEnvio(FRestResponse)
  finally
    FreeComponentes;
  end;
end;

function TPlataformaContadorAPI.EnviarXMLArquivo(const ATipo: TTipoDocumento; const APathXML: string): Boolean;
begin
  if FToken.Trim.IsEmpty then
    Login;

  CreateComponentes;
  try
    FRestRequest.Method   := TRESTRequestMethod.rmPOST;
    FRestRequest.Resource := GetURLEnvio(tpeXML, ATipo);
    FRestRequest.AddFile('arquivosXml', APathXML, ctAPPLICATION_XML);
    FRestRequest.Execute;

    Result := TratarRetornoEnvio(FRestResponse)
  finally
    FreeComponentes;
  end;
end;


end.

