{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftData.FDController;

interface

uses
{PROJETO}
  tftCore.Controller,
{IDE}
  Data.DB, FireDAC.Comp.Client, System.Generics.Collections;

type
  TtftFDController<TEntity: TtftEntity> = class(TtftController<TEntity>)
  protected
    function CreateCommand(const ACommandSQL: string): TDataSet; override;
    procedure SetParamCommand(const ACommand: TDataSet; const AIndex: Integer; const AValue: Variant); override;
  public
    constructor Create(const AConnection: TFDConnection);
    function ToList: TList<TEntity>;
    function Entry(const AEntity: TEntity): TtftEntityState;
    function First(const AKeyValues: array of Variant): TEntity;
    function FirstOrDefault(const AKeyValues: array of Variant): TEntity;
    procedure Save(const AEntity: TEntity);
  end;

implementation

uses
{IDE}
  FireDAC.DApt;

{ TtftFDController<TEntity> }

constructor TtftFDController<TEntity>.Create(const AConnection: TFDConnection);
begin
  inherited Create(AConnection);
end;

function TtftFDController<TEntity>.ToList: TList<TEntity>;
begin
  Result := inherited ToList;
end;

function TtftFDController<TEntity>.CreateCommand(const ACommandSQL: string): TDataSet;
begin
  Result := TFDQuery.Create(nil);
  TFDQuery(Result).Connection := TFDConnection(Connection);
  TFDQuery(Result).SQL.Text := ACommandSQL;
end;

function TtftFDController<TEntity>.Entry(const AEntity: TEntity): TtftEntityState;
begin
  Result := inherited Entry(AEntity);
end;

function TtftFDController<TEntity>.First(const AKeyValues: array of Variant): TEntity;
begin
  Result := inherited First(AKeyValues);
end;

function TtftFDController<TEntity>.FirstOrDefault(const AKeyValues: array of Variant): TEntity;
begin
  Result := inherited FirstOrDefault(AKeyValues);
end;

procedure TtftFDController<TEntity>.Save(const AEntity: TEntity);
begin
  DoSave(AEntity);
end;

procedure TtftFDController<TEntity>.SetParamCommand(const ACommand: TDataSet; const AIndex: Integer;
  const AValue: Variant);
begin
  TFDQuery(ACommand).Params[AIndex].Value := AValue;
end;

end.
