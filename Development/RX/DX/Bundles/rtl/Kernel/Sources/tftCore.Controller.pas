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
  System.Classes, System.Generics.Collections;

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
    FEntity: TtftEntity;
    FEntityClass: TClass;
    FEntityState: TtftEntityState;
    FPrimaryKeys: TList<string>;
  protected
    constructor Create(const AEntityClass: TClass);
    function DoFirstOrDefault(const AKeyValues: array of Variant): TtftEntity; virtual; abstract;
    function DoToList: TList<TtftEntity>; virtual; abstract;
    function Entry(const AEntity: TtftEntity): TtftEntityState;
    function First(const AKeyValues: array of Variant): TtftEntity;
    function FirstOrDefault(const AKeyValues: array of Variant): TtftEntity;
    function ToList: TList<TtftEntity>;
    procedure BeforeDelete; dynamic;
    procedure BeforeInsert; dynamic;
    procedure BeforeInsertOrUpdate; dynamic;
    procedure BeforeSave;
    procedure BeforeUpdate; dynamic;
    procedure DoSaveChanges; virtual; abstract;
    procedure SaveChanges(const AEntity: TtftEntity);
    procedure SetPrimaryKeys; virtual; abstract;
    property Entity: TtftEntity read FEntity;
    property EntityClass: TClass read FEntityClass;
    property PrimaryKeys: TList<string> read FPrimaryKeys;
  public
    destructor Destroy; override;
  end;

implementation

uses
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

constructor TtftController.Create(const AEntityClass: TClass);
begin
  inherited Create;
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
      BeforeInsertOrUpdate;
    end;
  end;
end;

procedure TtftController.BeforeUpdate;
begin
end;

procedure TtftController.SaveChanges(const AEntity: TtftEntity);
begin
  FEntity := AEntity;
  BeforeSave;
  DoSaveChanges;
end;

function TtftController.Entry(const AEntity: TtftEntity): TtftEntityState;
begin
  FEntity := AEntity;
  Result := FEntityState;
end;

end.
