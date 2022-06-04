unit BuscaCEP;

interface
  uses
    System.Classes,
    System.SysUtils,
    System.NetConsts,
    System.Net.URLClient,
    System.Net.HttpClient,
    System.Net.HttpClientComponent;

const
  URL_VIA_CEP   = 'https://viacep.com.br/ws/%s/json/';
  URL_WEB_MANIA = 'https://webmaniabr.com/api/1/cep/%s/?app_key=%s&app_secret=%s';
  URL_WSCEP     = 'http://127.0.0.1/cep/index.php?secret_key=%s&CEP=%s';

type
  TServidor = (ViaCEP, WebMania {, WSCEP});

  TViaCEPResult = class
  private
    FLogradouro : string;
    FIBGE       : string;
    FBairro     : string;
    FUF         : string;
    FCEP        : string;
    FLocalidade : string;
    FUnidade    : string;
    FComplemento: string;
    FGIA        : string;
  public
    property CEP        : string read FCEP         write FCEP;
    property Logradouro : string read FLogradouro  write FLogradouro;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro     : string read FBairro      write FBairro;
    property Localidade : string read FLocalidade  write FLocalidade;
    property UF         : string read FUF          write FUF;
    property Unidade    : string read FUnidade     write FUnidade;
    property IBGE       : string read FIBGE        write FIBGE;
    property GIA        : string read FGIA         write FGIA;
  end;

  TWebManiaCEPResult = class
  private
    FEndereco : string;
    FBairro   : string;
    FCidade   : string;
    FUF       : string;
    FCEP      : string;
    FIBGE     : string;
  public
    property Endereco : string read FEndereco write FEndereco;
    property Bairro   : string read FBairro   write FBairro;
    property Cidade   : string read FCidade   write FCidade;
    property UF       : string read FUF       write FUF;
    property CEP      : string read FCEP      write FCEP;
    property IBGE     : string read FIBGE     write FIBGE;
  end;

  TWSCEPResult = class
  private
    FLogradouro : string;
    FIBGE       : string;
    FBairro     : string;
    FUF         : string;
    FCidade     : string;
    FComplemento: string;
    FCEP        : string;
  public
    property Logradouro : string read FLogradouro  write FLogradouro;
    property IBGE       : string read FIBGE        write FIBGE;
    property Bairro     : string read FBairro      write FBairro;
    property UF         : string read FUF          write FUF;
    property Cidade     : string read FCidade      write FCidade;
    property Complemento: string read FComplemento write FComplemento;
    property CEP        : string read FCEP         write FCEP;
  end;

  TBuscaCEP = class(TComponent)
  private
    FLogradouro       : string;
    FIBGE             : string;
    FBairro           : string;
    FUF               : string;
    FCEP              : string;
    FLocalidade       : string;
    FUnidade          : string;
    FComplemento      : string;
    FGIA              : string;

    FServidor         : TServidor;

    FWebManiaAppkey   : string;
    FWebManiaAppSecret: string;
    FWSCEPSecretKey   : string;

    FURLWebMania: string;
    FURLViaCEP  : string;
    {FURLWSCEP   : string;}

    FViaCEP   : TViaCEPResult;
    FWebMania : TWebManiaCEPResult;
    FVersao   : string;
    FSobre    : string;
    {FWSCEP    : TWSCEPResult;}

    procedure LimparDadosCEP;
    procedure LiberarObjetosPesquisa;
    function CEPLocalizado(const AResultado: string): Boolean;
  public
    constructor Create(AOwner: TComponent); override;

    property CEP        : string read FCEP         write FCEP;
    property Logradouro : string read FLogradouro  write FLogradouro;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro     : string read FBairro      write FBairro;
    property Localidade : string read FLocalidade  write FLocalidade;
    property UF         : string read FUF          write FUF;
    property Unidade    : string read FUnidade     write FUnidade;
    property IBGE       : string read FIBGE        write FIBGE;
    property GIA        : string read FGIA         write FGIA;

    function Buscar(const ACEP: string): boolean;
  published
    property Servidor         : TServidor read FServidor          write FServidor;
    property WebManiaAppkey   : string    read FWebManiaAppkey    write FWebManiaAppkey;
    property WebManiaAppSecret: string    read FWebManiaAppSecret write FWebManiaAppSecret;
    property WSCEPSecretKey   : string    read FWSCEPSecretKey    write FWSCEPSecretKey;

    property URLViaCEP   : string read FURLViaCEP   write FURLViaCEP;
    property URLWebMania : string read FURLWebMania write FURLWebMania;
    property Versao      : string read FVersao;
    property Sobre       : string read FSobre;
    {property URLWSCEP    : string read FURLWSCEP    write FURLWSCEP;}
  end;

procedure Register;

implementation
  uses
    REST.Json;

procedure Register;
begin
  RegisterComponents('iNoveFast', [TBuscaCEP]);
end;

function TBuscaCEP.Buscar(const ACEP: string): boolean;
var
  HttpClient: THttpClient;
  Response  : IHttpResponse;
begin
  try
    LimparDadosCEP;
    LiberarObjetosPesquisa;
    Self.CEP := ACEP;
    try
      HttpClient := THttpClient.Create;

      HttpClient.ContentType := 'application/json';
      HttpClient.Accept      := 'text/javascript';

      case Servidor of
        ViaCEP  : Response := HttpClient.Get(Format(URL_VIA_CEP,   [ACEP]), nil, nil);
        WebMania: Response := HttpClient.Get(Format(URL_WEB_MANIA, [ACEP, Self.WebManiaAppkey, Self.WebManiaAppSecret]), nil, nil);
        {WSCEP   : Response := HttpClient.Get(Format(URL_WSCEP,     [Self.FWSCEPSecretKey, ACEP]), nil, nil);}
      end;

      Result := CEPLocalizado(Response.ContentAsString);
    except
      on E:Exception do
        raise Exception.Create(E.Message);
      end;
  finally
    if Assigned(HttpClient) then
      FreeAndNil(HttpClient);
  end;
end;

procedure TBuscaCEP.LiberarObjetosPesquisa;
begin
  if Assigned(FViaCEP) then
    FreeAndNil(FViaCEP);

  if Assigned(FWebMania) then
    FreeAndNil(FWebMania);

  {if Assigned(FWSCEP) then
    FreeAndNil(FWSCEP);}
end;

procedure TBuscaCEP.LimparDadosCEP;
begin
  Self.CEP        := '';
  Self.Logradouro := '';
  Self.IBGE       := '';
  Self.Bairro     := '';
  Self.Localidade := '';
  Self.UF         := '';
  Self.Unidade    := '';
  Self.Complemento:= '';
  Self.GIA        := '';
end;

function TBuscaCEP.CEPLocalizado(const AResultado: string): Boolean;
begin
  if AResultado.Contains('"erro"') then
  begin
    Self.Logradouro := 'NÃO LOCALIZADO';
    Exit(False);
  end;

  try
    try
      case Servidor of
        ViaCEP:
        begin
          FViaCEP         := TJson.JsonToObject<TViaCEPResult>(AResultado);
          Self.CEP        := FViaCEP.CEP;
          Self.Logradouro := FViaCEP.Logradouro;
          Self.IBGE       := FViaCEP.IBGE;
          Self.Bairro     := FViaCEP.Bairro;
          Self.Localidade := FViaCEP.Localidade;
          Self.UF         := FViaCEP.UF;
          Self.Unidade    := FViaCEP.Unidade;
          Self.Complemento:= FViaCEP.Complemento;
          Self.GIA        := FViaCEP.GIA;
        end;
        WebMania:
        begin
          FWebMania       := TJson.JsonToObject<TWebManiaCEPResult>(AResultado);
          Self.CEP        := FWebMania.CEP;
          Self.Logradouro := FWebMania.Endereco;
          Self.IBGE       := FWebMania.IBGE;
          Self.Bairro     := FWebMania.Bairro;
          Self.Localidade := FWebMania.Cidade;
          Self.UF         := FWebMania.UF;
        end;
        {WSCEP:
        begin
          FWSCEP          := TJson.JsonToObject<TWSCEPResult>(Copy(AResultado, 2, Length(AResultado)-2));
          Self.CEP        := FWSCEP.CEP;
          Self.Logradouro := FWSCEP.Logradouro;
          Self.IBGE       := FWSCEP.IBGE;
          Self.Bairro     := FWSCEP.Bairro;
          Self.Localidade := FWSCEP.Cidade;
          Self.UF         := FWSCEP.UF;
        end;}
      end;
      Result := True;
    except
      Result := False;
    end;
  finally
    LiberarObjetosPesquisa;
  end;
end;

constructor TBuscaCEP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Self.URLViaCEP   := URL_VIA_CEP;
  Self.URLWebMania := URL_WEB_MANIA;
  {Self.URLWSCEP    := URL_WSCEP;}

  Self.FVersao := '1.5.1';
  Self.FSobre  := 'www.inovefast.com.br';
end;

end.
