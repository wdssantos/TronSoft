{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftCore.RESTRequestAuthenticator;

interface

uses
{IDE}
  IdHeaderList,
  REST.Types,
  System.Classes,
  System.SysUtils;

type
  TtftRESTRequestAuthenticator = class
  strict private
    FActive: Boolean;
    FAuthCode: string;
    FBaseURL: string;
    FCharSet: string;
    FContentType: string;
    FResource: string;
    FSettingFileName: TFileName;
    FSettingName: string;
  strict protected
    function GetAuthenticated: Boolean; virtual; abstract;
    function GetAuthorizeURL: string; virtual; abstract;
    procedure ExecuteRequest(const AMethod: TRESTRequestMethod; const AUrl: string; const AParams: TStringList;
      var AResponse: TStringStream; out AResponseCode: Integer; const AErrorException: Boolean = True);
  public
    constructor Create; dynamic;
    function Authenticate: Boolean; virtual; abstract;
    function HTTPHeaders: TIdHeaderList; virtual; abstract;
    function GetURL: string; virtual; abstract;
    procedure LoadSettings; virtual; abstract;
    procedure SaveSettings; virtual; abstract;
    property Active: Boolean read FActive write FActive;
    property AuthCode: string read FAuthCode write FAuthCode;
    property Authenticated: Boolean read GetAuthenticated;
    property BaseURL: string read FBaseURL write FBaseURL;
    property CharSet: string read FCharSet write FCharSet;
    property ContentType: string read FContentType write FContentType;
    property AuthorizeURL: string read GetAuthorizeURL;
    property Resource: string read FResource write FResource;
    property SettingFileName: TFileName read FSettingFileName write FSettingFileName;
    property SettingName: string read FSettingName write FSettingName;
  end;

  TtftRESTRequestAuthenticatorClass = class of TtftRESTRequestAuthenticator;

  function GetSimpleValue(const AContent: string; const AContentType: string; const AName: string;
    var AValue: string): boolean;

implementation

uses
{IDE}
  Data.DBXJSON,
  IdHTTP,
  IdSSLOpenSSL,
  System.JSON,
  System.StrUtils;

function GetSimpleValue(const AContent: string; const AContentType: string;
  const AName: string; var AValue: string): boolean;
var
  LJSONObj: TJSONObject;
  LJSONPair: TJSONPair;
begin
  AValue := '';
  Result := False;
  if SameText(AContentType, CONTENTTYPE_TEXT_HTML) then
  begin
    if ContainsText(AContent, AName + '=') then
    begin
      AValue := Copy(AContent, Pos(AName + '=', AContent) + Length(AName) + 1, Length(AContent));
      Result := Pos('&', AValue) > 0;
      if Result then
      begin
        AValue := Copy(AValue, 1, Pos('&', AValue) - 1);
      end;
    end;
  end
  else if SameText(AContentType, CONTENTTYPE_APPLICATION_JSON) then
  begin
    LJSONObj := TJSONObject.ParseJSONValue(AContent) as TJSONObject;
    if Assigned(LJSONObj) then
    begin
      LJSONPair := LJSONObj.Get(AName);
      Result := Assigned(LJSONPair);
      if Result then
      begin
        AValue := LJSONPair.JSONValue.Value;
      end;
      FreeAndNIL(LJSONObj);
    end;
  end;
end;

{ TtftRESTRequestAuthenticator }

constructor TtftRESTRequestAuthenticator.Create;
begin
  inherited Create;
  FCharSet := 'UTF-8';
end;

procedure TtftRESTRequestAuthenticator.ExecuteRequest(const AMethod: TRESTRequestMethod; const AUrl: string;
  const AParams: TStringList; var AResponse: TStringStream; out AResponseCode: Integer; const AErrorException: Boolean);
var
  LIdHTTP: TIdHTTP;
  LIOHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  LIdHTTP := TIdHTTP.Create(nil);
  LIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
  try
    LIdHTTP.IOHandler := LIOHandler;
    LIdHTTP.Request.CharSet := CharSet;
    LIdHTTP.Request.CustomHeaders.AddStrings(HTTPHeaders);
    if not AErrorException then
    begin
      LIdHTTP.HTTPOptions := LIdHTTP.HTTPOptions + [hoNoProtocolErrorException];
    end;
    case AMethod of
       rmGET: LIdHTTP.Get(AUrl, AResponse);
      rmPOST: LIdHTTP.Post(AUrl, AParams, AResponse);
    end;
  finally
    AResponseCode := LIdHTTP.ResponseCode;
    LIdHTTP.Free;
    LIOHandler.Free;
  end;
end;

end.

