{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftCore.RESTRequest;

interface

uses
{PROJETO}
  tftCore.RESTRequestParams,
{IDE}
  System.Classes, System.SysUtils;

type
  TtftRESTRequest = class
  private
    FErrorException: Boolean;
    FParams: TtftRESTRequestParams;
    FRequestBody: TStream;
    FResponseCode: Integer;
    function IsPossibleExecute: Boolean;
    procedure BeforeExecute;
    procedure OnExecute(const AResponse: TProc<string>);
  public
    constructor Create;
    destructor Destroy; override;
    function Execute(const AResponse: TProc<string> = nil): Boolean;
    procedure AddBody(const AContent: string);
    property ErrorException: Boolean read FErrorException write FErrorException;
    property Params: TtftRESTRequestParams read FParams;
    property ResponseCode: Integer read FResponseCode;
  end;

implementation

uses
{PROJETO}
  tftCore.RESTRequestAuthenticator,
{IDE}
  IdHTTP,
  IdSSLOpenSSL,
  REST.Types;

{ TtftRESTRequest }

procedure TtftRESTRequest.AddBody(const AContent: string);
begin
  if Assigned(FRequestBody) then
  begin
    FRequestBody.Free;
  end;
  FRequestBody := TStringStream.Create(AContent, TEncoding.UTF8);
end;

procedure TtftRESTRequest.BeforeExecute;
begin
  FParams.Authenticator.LoadSettings;
end;

constructor TtftRESTRequest.Create;
begin
  inherited Create;
  FErrorException := True;
  FParams := TtftRESTRequestParams.Create;
  FRequestBody := TStringStream.Create;
end;

destructor TtftRESTRequest.Destroy;
begin
  FParams.Free;
  FRequestBody.Free;
  inherited;
end;

function TtftRESTRequest.IsPossibleExecute: Boolean;
begin
  Result := FParams.Authenticator.Active and FParams.Authenticator.Authenticated;
end;

function TtftRESTRequest.Execute(const AResponse: TProc<string>): Boolean;
begin
  Result := IsPossibleExecute;
  if Result then
  begin
    BeforeExecute;
    OnExecute(AResponse);
  end;
end;

procedure TtftRESTRequest.OnExecute(const AResponse: TProc<string>);
var
  LHeaders: TStrings;
  LIdHTTP: TIdHTTP;
  LIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  LResponse: TStringStream;
begin
  LResponse := TStringStream.Create;
  LHeaders := FParams.Authenticator.HTTPHeaders;

  LIdHTTP := TIdHTTP.Create(nil);
  LIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
  try
    LIdHTTP.IOHandler := LIOHandler;
    LIdHTTP.Request.CharSet := FParams.Authenticator.CharSet;
    if LHeaders.Count > 0 then
    begin
      LIdHTTP.Request.CustomHeaders.AddStrings(LHeaders);
    end;
    if not FErrorException then
    begin
      LIdHTTP.HTTPOptions := LIdHTTP.HTTPOptions + [hoNoProtocolErrorException];
    end;
    case FParams.Method of
       rmGET: LIdHTTP.Get (FParams.Authenticator.GetURL, LResponse);
      rmPOST: LIdHTTP.Post(FParams.Authenticator.GetURL, FRequestBody, LResponse);
       rmPUT: LIdHTTP.Put (FParams.Authenticator.GetURL, FRequestBody, LResponse);
    end;
  finally
    FResponseCode := LIdHTTP.ResponseCode;
    if Assigned(AResponse) then
    begin
      AResponse(LResponse.DataString);
    end;
    LIdHTTP.Free;
    LIOHandler.Free;
    LHeaders.Free;
    LResponse.Free;
  end;
end;

end.

