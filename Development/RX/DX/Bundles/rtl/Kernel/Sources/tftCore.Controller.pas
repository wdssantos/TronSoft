{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftCore.Controller;

interface

uses
{IDE}
  Data.DB, System.Classes, System.Generics.Collections;

type
{$SCOPEDENUMS ON}
  TEntityState = (Added, Deleted, Modified);
{$SCOPEDENUMS OFF}

  TtftEntity = class
  private
    FState: TEntityState;
  protected
    property State: TEntityState read FState write FState;
  public
    constructor Create;
  end;

  TtftController = class;

  TtftEntityState = class
  private
    FOwner: TtftController;
    function GetState: TEntityState;
    procedure SetState(const Value: TEntityState);
  protected
    constructor Create(const AOwner: TtftController);
  public
    property State: TEntityState read GetState write SetState;
  end;

  TtftController = class
  private
    FConnection: TCustomConnection;
    FEntity: TtftEntity;
    FEntityClass: TClass;
    FEntityState: TtftEntityState;
    FPrimaryKeys: TList<string>;
  protected
    constructor Create(const AConnection: TCustomConnection; const AEntityClass: TClass);
    function CreateCommand(const ACommandSQL: string): TDataSet; virtual; abstract;
    function Entry(const AEntity: TtftEntity): TtftEntityState;
    function First(const AKeyValues: array of Variant): TtftEntity;
    function FirstOrDefault(const AKeyValues: array of Variant): TtftEntity;
    function ToList: TList<TtftEntity>;
    procedure BeforeDelete; dynamic;
    procedure BeforeInsert; dynamic;
    procedure BeforeInsertOrUpdate; dynamic;
    procedure BeforeSave;
    procedure BeforeUpdate; dynamic;
    procedure DoSave(const AEntity: TtftEntity);
    procedure SetParamCommand(const ACommand: TDataSet; const AIndex: Integer; const AValue: Variant); virtual; abstract;
    procedure SetPrimaryKeys; virtual; abstract;
    property Connection: TCustomConnection read FConnection;
    property Entity: TtftEntity read FEntity;
    property EntityClass: TClass read FEntityClass;
    property PrimaryKeys: TList<string> read FPrimaryKeys;
  public
    destructor Destroy; override;
  end;

  TtftController<TEntity: TtftEntity> = class(TtftController)
  private
    function getEntity: TEntity;
  protected
    function ToList: TList<TEntity>;
    function Entry(const AEntity: TEntity): TtftEntityState;
    function First(const AKeyValues: array of Variant): TEntity;
    function FirstOrDefault(const AKeyValues: array of Variant): TEntity;
    procedure DoSave(const AEntity: TEntity);
    property Entity: TEntity read getEntity;
  public
    constructor Create(const AConnection: TCustomConnection);
  end;

implementation

uses
{PROJETO}
  tftCore.Controller.Extensions,
{IDE}
  System.SysUtils;

{ TtftEntity }

constructor TtftEntity.Create;
begin
  inherited Create;
  FState := TEntityState.Added;
end;

{ TtftEntityState }

constructor TtftEntityState.Create(const AOwner: TtftController);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TtftEntityState.GetState: TEntityState;
begin
  Result := FOwner.Entity.State;
end;

procedure TtftEntityState.SetState(const Value: TEntityState);
begin
  FOwner.Entity.State := Value;
end;

{ TtftController }

constructor TtftController.Create(const AConnection: TCustomConnection; const AEntityClass: TClass);
begin
  inherited Create;
  FConnection := AConnection;
  FEntityClass := AEntityClass;
  FEntityState := TtftEntityState.Create(Self);
  FPrimaryKeys := TList<string>.Create;
  SetPrimaryKeys;
end;

destructor TtftController.Destroy;
begin
  FreeAndNil(FPrimaryKeys);
  FreeAndNil(FEntityState);
  inherited;
end;

function TtftController.First(const AKeyValues: array of Variant): TtftEntity;
begin
  Result := FirstOrDefault(AKeyValues);
  if not Assigned(Result) then
  begin
    raise Exception.Create('Não foi possível obter resultado.');
  end;
end;

function TtftController.FirstOrDefault(const AKeyValues: array of Variant): TtftEntity;
begin
  Result := DoFirstOrDefault(AKeyValues);
end;

function TtftController.ToList: TList<TtftEntity>;
begin
  Result := DoToList;
end;

procedure TtftController.BeforeDelete;
begin
end;

procedure TtftController.BeforeInsert;
begin
end;

procedure TtftController.BeforeInsertOrUpdate;
begin
end;

procedure TtftController.BeforeSave;
begin
  case Entry(Entity).State of
    TEntityState.Added:
      BeforeInsert;
    TEntityState.Deleted:
      BeforeDelete;
    TEntityState.Modified:
      BeforeUpdate;
  end;

  case Entry(Entity).State of
    TEntityState.Added,
    TEntityState.Modified:
    begin
      BeforeInsert;
      BeforeUpdate;
    end;
  end;
end;

procedure TtftController.BeforeUpdate;
begin
end;

procedure TtftController.DoSave(const AEntity: TtftEntity);
begin
  FEntity := AEntity;
  BeforeSave;
  DoInternalSave;
end;

function TtftController.Entry(const AEntity: TtftEntity): TtftEntityState;
begin
  FEntity := AEntity;
  Result := FEntityState;
end;

{ TtftController<TEntity> }

constructor TtftController<TEntity>.Create(const AConnection: TCustomConnection);
begin
  inherited Create(AConnection, TEntity);
end;

function TtftController<TEntity>.First(const AKeyValues: array of Variant): TEntity;
begin
  Result := TEntity(inherited First(AKeyValues));
end;

function TtftController<TEntity>.FirstOrDefault(const AKeyValues: array of Variant): TEntity;
begin
  Result := TEntity(inherited FirstOrDefault(AKeyValues));
end;

function TtftController<TEntity>.getEntity: TEntity;
begin
  Result := TEntity(inherited Entity);
end;

function TtftController<TEntity>.ToList: TList<TEntity>;
begin
  Result := TList<TEntity>(inherited ToList);
end;

procedure TtftController<TEntity>.DoSave(const AEntity: TEntity);
begin
  inherited DoSave(AEntity);
end;

function TtftController<TEntity>.Entry(const AEntity: TEntity): TtftEntityState;
begin
  Result := inherited Entry(AEntity);
end;

end.
