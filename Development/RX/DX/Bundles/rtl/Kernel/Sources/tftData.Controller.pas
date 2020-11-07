{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftData.Controller;

interface

uses
{PROJETO}
  tftCore.Controller,
{IDE}
  Data.DB, System.Generics.Collections;

type
  TtftDataController = class(TtftController)
  private
    FConnection: TCustomConnection;
  protected
    constructor Create(const AConnection: TCustomConnection; const AEntityClass: TClass);
    function DoFirstOrDefault(const AKeyValues: array of Variant): TtftEntity; override;
    function DoToList: TList<TtftEntity>; override;
    function CreateCommand(const ACommandSQL: string): TDataSet; virtual; abstract;
    procedure DoSaveChanges; override;
    procedure SaveChanges(const AEntity: TtftEntity);
    procedure SetParamCommand(const ACommand: TDataSet; const AIndex: Integer; const AValue: Variant); virtual; abstract;
    property Connection: TCustomConnection read FConnection;
  end;

  TtftDataController<TEntity: TtftEntity> = class(TtftDataController)
  private
    function getEntity: TEntity;
  protected
    function ToList: TList<TEntity>;
    function Entry(const AEntity: TEntity): TtftEntityState;
    function First(const AKeyValues: array of Variant): TEntity;
    function FirstOrDefault(const AKeyValues: array of Variant): TEntity;
    procedure SaveChanges(const AEntity: TEntity);
    property Entity: TEntity read getEntity;
  public
    constructor Create(const AConnection: TCustomConnection);
  end;

implementation

uses
{PROJETO}
  tftData.Controller.Extensions;

{ TtftDataController }

constructor TtftDataController.Create(const AConnection: TCustomConnection; const AEntityClass: TClass);
begin
  inherited Create(AEntityClass);
  FConnection := AConnection;
end;

function TtftDataController.DoFirstOrDefault(const AKeyValues: array of Variant): TtftEntity;
begin
  Result := DoInternalFirstOrDefault(AKeyValues);
end;

function TtftDataController.DoToList: TList<TtftEntity>;
begin
  Result := DoInternalToList;
end;

procedure TtftDataController.DoSaveChanges;
begin
  DoInternalSaveChanges
end;

procedure TtftDataController.SaveChanges(const AEntity: TtftEntity);
begin
  inherited SaveChanges(AEntity);
end;

{ TtftDataController<TEntity> }

constructor TtftDataController<TEntity>.Create(const AConnection: TCustomConnection);
begin
  inherited Create(AConnection, TEntity);
end;

function TtftDataController<TEntity>.First(const AKeyValues: array of Variant): TEntity;
begin
  Result := TEntity(inherited First(AKeyValues));
end;

function TtftDataController<TEntity>.FirstOrDefault(const AKeyValues: array of Variant): TEntity;
begin
  Result := TEntity(inherited FirstOrDefault(AKeyValues));
end;

function TtftDataController<TEntity>.getEntity: TEntity;
begin
  Result := TEntity(inherited Entity);
end;

function TtftDataController<TEntity>.ToList: TList<TEntity>;
begin
  Result := TList<TEntity>(inherited ToList);
end;

procedure TtftDataController<TEntity>.SaveChanges(const AEntity: TEntity);
begin
  inherited SaveChanges(AEntity);
end;

function TtftDataController<TEntity>.Entry(const AEntity: TEntity): TtftEntityState;
begin
  Result := inherited Entry(AEntity);
end;

end.
