{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftCore.RESTRequestParams;

interface

uses
{PROJETO}
  tftCore.RESTRequestAuthenticator,
{IDE}
  REST.Types, System.Generics.Collections;

type
{$SCOPEDENUMS ON}
  TtftRESTAuthMethod = (None, TronSoftSimple);
{$SCOPEDENUMS OFF}

  TtftRESTRequestParams = class
  strict private
    FAuthenticator: TtftRESTRequestAuthenticator;
    FAuthMethod: TtftRESTAuthMethod;
    FAuthMethods: TObjectDictionary<TtftRESTRequestAuthenticatorClass, TtftRESTRequestAuthenticator>;
    FAuthMethodAssociation: TDictionary<TtftRESTAuthMethod, TtftRESTRequestAuthenticatorClass>;
    FMethod: TRESTRequestMethod;
    procedure SetAuthMethod(const Value: TtftRESTAuthMethod);
  public
    constructor Create;
    destructor Destroy; override;
    property AuthMethod: TtftRESTAuthMethod read FAuthMethod write SetAuthMethod default TtftRESTAuthMethod.None;
    property Authenticator: TtftRESTRequestAuthenticator read FAuthenticator;
    property Method: TRESTRequestMethod read FMethod write FMethod default TRESTRequestMethod.rmGET;
  end;

implementation

uses
{PROJETO}
  tftCore.RESTRequestTronSoftSimpleAuthenticator,
{IDE}
  System.SysUtils;

{ TtftRESTRequestParams }

constructor TtftRESTRequestParams.Create;
begin
  inherited Create;
  //--------------------------------------------------------------------------------------
  FAuthenticator := nil;
  FAuthMethod := TtftRESTAuthMethod.None;
  FMethod := TRESTRequestMethod.rmGET;
  //--------------------------------------------------------------------------------------
  FAuthMethods := TObjectDictionary<TtftRESTRequestAuthenticatorClass, TtftRESTRequestAuthenticator>.Create([doOwnsValues]);
  FAuthMethodAssociation := TDictionary<TtftRESTAuthMethod, TtftRESTRequestAuthenticatorClass>.Create;
  //--------------------------------------------------------------------------------------
  FAuthMethodAssociation.Add(TtftRESTAuthMethod.TronSoftSimple, TtftRESTRequestTronSoftSimpleAuthenticator);
  //--------------------------------------------------------------------------------------
end;

destructor TtftRESTRequestParams.Destroy;
begin
  FreeAndNil(FAuthMethods);
  FreeAndNil(FAuthMethodAssociation);
  inherited;
end;

procedure TtftRESTRequestParams.SetAuthMethod(const Value: TtftRESTAuthMethod);
var
  TAuthenticator: TtftRESTRequestAuthenticatorClass;
begin
  if FAuthMethod <> Value then
  begin
    TAuthenticator := nil;
    if FAuthMethodAssociation.ContainsKey(Value) then
    begin
      TAuthenticator := FAuthMethodAssociation[Value];
    end;
    if Assigned(TAuthenticator) and
      (Value <> TtftRESTAuthMethod.None) then
    begin
      if FAuthMethods.ContainsKey(TAuthenticator) then
      begin
        FAuthenticator := FAuthMethods[TAuthenticator];
      end
      else
      begin
        FAuthenticator := TAuthenticator.Create;
        FAuthMethods.Add(TAuthenticator, FAuthenticator);
      end;
    end
    else
    begin
      FAuthenticator := nil;
    end;
    FAuthMethod := Value;
  end;
end;

end.


