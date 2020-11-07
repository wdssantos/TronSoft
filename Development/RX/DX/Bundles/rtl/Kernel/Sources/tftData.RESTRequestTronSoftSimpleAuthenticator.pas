{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftData.RESTRequestTronSoftSimpleAuthenticator;

interface

uses
{PROJETO}
  tftData.RESTRequestAuthenticator,
{IDE}
  IdHeaderList,
  System.Classes;

type
  TtftRESTRequestTronSoftSimpleAuthenticator = class(TtftRESTRequestAuthenticator)
  strict protected
    function GetAuthenticated: Boolean; override;
    function GetAuthorizeURL: string; override;
  public
    function Authenticate: Boolean; override;
    function GetURL: string; override;
    function HTTPHeaders: TIdHeaderList; override;
    procedure LoadSettings; override;
    procedure SaveSettings; override;
  end;

implementation

uses
{PROJETO}
  tftData.RESTRequestParams,
{IDE}
  IdGlobalProtocols,
  System.IniFiles,
  System.TypInfo;

{ TtftRESTRequestTronSoftSimpleAuthenticator }

function TtftRESTRequestTronSoftSimpleAuthenticator.Authenticate: Boolean;
begin
  Result := GetAuthenticated;
end;

function TtftRESTRequestTronSoftSimpleAuthenticator.GetAuthenticated: Boolean;
begin
  Result := True;
end;

function TtftRESTRequestTronSoftSimpleAuthenticator.GetAuthorizeURL: string;
begin
  Result := '';
end;

function TtftRESTRequestTronSoftSimpleAuthenticator.GetURL: string;
begin
  Result := Concat(BaseURL, '/', Resource);
end;

function TtftRESTRequestTronSoftSimpleAuthenticator.HTTPHeaders: TIdHeaderList;
begin
  Result := TIdHeaderList.Create(QuoteHTTP);
  Result.AddValue('Accept', ContentType);
  Result.AddValue('Content-type', ContentType);
end;

procedure TtftRESTRequestTronSoftSimpleAuthenticator.LoadSettings;
var
  LAuthType: string;
  LIni: TIniFile;
  LSection: string;
begin
  LAuthType := GetEnumName(System.TypeInfo(TtftRESTAuthMethod), Ord(TtftRESTAuthMethod.TronSoftSimple));
  LSection := Concat(SettingName, '.', LAuthType);
  LIni := TIniFile.Create(SettingFileName);
  try
    Active      := LIni.ReadBool  (LSection, 'Active'      , False);
    BaseURL     := LIni.ReadString(LSection, 'BaseURL'     , '');
    ContentType := LIni.ReadString(LSection, 'ContentType' , 'application/json');
  finally
    LIni.Free;
  end;
end;

procedure TtftRESTRequestTronSoftSimpleAuthenticator.SaveSettings;
var
  LAuthType: string;
  LIni: TIniFile;
  LSection: string;
begin
  LAuthType := GetEnumName(System.TypeInfo(TtftRESTAuthMethod), Ord(TtftRESTAuthMethod.TronSoftSimple));
  LSection := Concat(SettingName, '.', LAuthType);
  LIni := TIniFile.Create(SettingFileName);
  try
    LIni.WriteString(SettingName, 'AuthenticatorType'       , LAuthType);

    LIni.WriteBool  (LSection   , 'Active'                  , Active);
    LIni.WriteString(LSection   , 'BaseURL'                 , BaseURL);
    LIni.WriteString(LSection   , 'ContentType'             , ContentType);
  finally
    LIni.Free;
  end;
end;

end.

