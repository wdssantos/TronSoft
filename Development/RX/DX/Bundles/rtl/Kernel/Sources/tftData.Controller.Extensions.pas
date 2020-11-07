{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftData.Controller.Extensions;

interface

uses
{PROJETO}
  tftCore.Controller,
  tftData.Controller,
{IDE}
  Data.DB, System.SysUtils, System.Generics.Collections;

type
  TtftEntityExtensions = class helper for TtftEntity
  private
    function GetState: TEntityState;
    procedure SetState(const Value: TEntityState);
  public
    property State: TEntityState read GetState write SetState;
  end;

  TtftDataControllerExtensions = class helper for TtftDataController
  private
    function GetLKeyValues: TArray<Variant>;
    procedure CreateSelectCommandSQL(const AEntityClass: TClass; out ACommandSQL: TStringBuilder);
    procedure CreateSelectCommand(const AKeyValues: array of Variant; out ASelectCommand: TDataSet);
    procedure DeleteRecord;
    procedure InsertRecord;
    procedure UpdateRecord;
    procedure SetEntityPropertyValues(const ACommand: TDataSet; const AEntity: TtftEntity);
  public
    function DoInternalFirstOrDefault(const AKeyValues: array of Variant): TtftEntity;
    function DoInternalToList: TList<TtftEntity>;
    procedure DoInternalSaveChanges;
  end;

implementation

uses
{PROJETO}
  tftCore.Reflection,
{IDE}
  System.Rtti;

{ TtftEntityExtensions }

function TtftEntityExtensions.GetState: TEntityState;
begin
  Result := inherited State;
end;

procedure TtftEntityExtensions.SetState(const Value: TEntityState);
begin
  inherited State := Value;
end;

{ TtftDataControllerExtensions }

function TtftDataControllerExtensions.DoInternalFirstOrDefault(const AKeyValues: array of Variant): TtftEntity;
var
  LCommand: TDataSet;
  LEntity: TtftEntity;
begin
  CreateSelectCommand(AKeyValues, LCommand);
  try
    LCommand.Open;
    LCommand.First;
    if not LCommand.IsEmpty then
    begin
      LEntity := Self.CreateObject<TtftEntity>(EntityClass);
      LEntity.State := TEntityState.Modified;
      SetEntityPropertyValues(LCommand, LEntity);
      Exit(LEntity);
    end;
    LCommand.Close;
  finally
    FreeAndNil(LCommand);
  end;
  Result := nil;
end;

function TtftDataControllerExtensions.GetLKeyValues: TArray<Variant>;
var
  I: Integer;
  LPrimaryKey: TArray<string>;
  LProp: TRttiProperty;
  LType: TRttiType;
begin
  TryGetType(Entity.ClassType, LType);
  LPrimaryKey := PrimaryKeys.ToArray;
  for I := Low(LPrimaryKey) to High(LPrimaryKey) do
  begin
    if LType.TryGetProperty(LPrimaryKey[I], LProp) then
    begin
      Result := Result + [LProp.GetValue(Entity).AsVariant];
    end;
  end;
end;

procedure TtftDataControllerExtensions.CreateSelectCommand(const AKeyValues: array of Variant;
  out ASelectCommand: TDataSet);
var
  I: Integer;
  LCommandSQL: TStringBuilder;
  LPrimaryKey: TArray<string>;
begin
  if PrimaryKeys.Count = 0 then
  begin
    Exit;
  end;
  LCommandSQL := TStringBuilder.Create;
  try
    CreateSelectCommandSQL(EntityClass, LCommandSQL);
    LCommandSQL.Append('WHERE ');
    LPrimaryKey := PrimaryKeys.ToArray;
    for I := Low(LPrimaryKey) to High(LPrimaryKey) do
    begin
      if I = 0 then
      begin
        LCommandSQL.AppendFormat('%s = :%s ', [PrimaryKeys[I].ToUpper, PrimaryKeys[I].ToUpper]);
      end
      else
      begin
        LCommandSQL.AppendFormat('AND %s = :%s ', [PrimaryKeys[I].ToUpper, PrimaryKeys[I].ToUpper]);
      end;
    end;
    ASelectCommand := CreateCommand(LCommandSQL.ToString);
    for I := Low(AKeyValues) to High(AKeyValues) do
    begin
      SetParamCommand(ASelectCommand, I, AKeyValues[I]);
    end;
  finally
    FreeAndNil(LCommandSQL);
  end;
end;

procedure TtftDataControllerExtensions.CreateSelectCommandSQL(const AEntityClass: TClass; out ACommandSQL: TStringBuilder);
begin
  ACommandSQL.Append('SELECT * ');
  ACommandSQL.AppendFormat('FROM %s ', [AEntityClass.ClassName.Substring(1).ToUpper]);
end;

procedure TtftDataControllerExtensions.DeleteRecord;
var
  LCommand: TDataSet;
begin
  CreateSelectCommand(GetLKeyValues, LCommand);
  try
    LCommand.Open;
    if not LCommand.IsEmpty then
    begin
      LCommand.Delete;
    end;
    LCommand.Close;
  finally
    FreeAndNil(LCommand);
  end;
end;

procedure TtftDataControllerExtensions.DoInternalSaveChanges;
begin
  case Entity.State of
    TEntityState.Added:
      InsertRecord;
    TEntityState.Deleted:
      DeleteRecord;
    TEntityState.Modified:
      UpdateRecord;
  end;
end;

function TtftDataControllerExtensions.DoInternalToList: TList<TtftEntity>;
var
  LCommand: TDataSet;
  LCommandSQL: TStringBuilder;
begin
  Result := TList<TtftEntity>.Create;
  LCommandSQL := TStringBuilder.Create;
  try
    CreateSelectCommandSQL(EntityClass, LCommandSQL);
    LCommand := CreateCommand(LCommandSQL.ToString);
    try
      LCommand.Open;
      if not LCommand.IsEmpty then
      begin
        LCommand.First;
        while not LCommand.Eof do
        begin
          Result.Add(Self.CreateObject<TtftEntity>(EntityClass));
          Result.Last.State := TEntityState.Modified;
          SetEntityPropertyValues(LCommand, Result.Last);
          LCommand.Next;
        end;
      end;
      LCommand.Close;
    finally
      FreeAndNil(LCommand);
    end;
  finally
    FreeAndNil(LCommandSQL);
  end;
end;

procedure TtftDataControllerExtensions.InsertRecord;
var
  LAssignedValue: Boolean;
  LCommand: TDataSet;
  LCommandSQL: TStringBuilder;
  LField: TField;
  LProp: TRttiProperty;
  LType: TRttiType;
begin
  LAssignedValue := False;
  LCommandSQL := TStringBuilder.Create;
  try
    CreateSelectCommandSQL(EntityClass, LCommandSQL);
    LCommandSQL.Append('WHERE 1 = 0 ');
    LCommand := CreateCommand(LCommandSQL.ToString);
    try
      LCommand.Open;
      LCommand.Append;
      TryGetType(Entity.ClassType, LType);
      for LProp in LType.GetProperties do
      begin
        LField := LCommand.FindField(LProp.Name);
        if Assigned(LField) then
        begin
          if (LProp.PropertyType.Name = 'string') and
            (LProp.GetValue(Entity).AsVariant = '') then
          begin
            LField.Clear;
          end
          else
          begin
            LField.Value := LProp.GetValue(Entity).AsVariant;
          end;
          LAssignedValue := True;
        end;
      end;
      if LAssignedValue then
      begin
        LCommand.Post;
        Entity.State := TEntityState.Modified;
      end
      else
      begin
        LCommand.Cancel;
      end;
      LCommand.Close;
    finally
      FreeAndNil(LCommand);
    end;
  finally
    FreeAndNil(LCommandSQL);
  end;
end;

procedure TtftDataControllerExtensions.SetEntityPropertyValues(const ACommand: TDataSet; const AEntity: TtftEntity);
var
  LField: TField;
  LProp: TRttiProperty;
  LType: TRttiType;
begin
  TryGetType(AEntity.ClassType, LType);
  for LField in ACommand.Fields do
  begin
    if LType.TryGetProperty(LField.FieldName, LProp) then
    begin
      case LField.DataType of
        ftGuid:
          LProp.SetValue(AEntity, TValue.From<TGuid>(TGuidField(LField).AsGuid));
        ftInteger:
          LProp.SetValue(AEntity, TValue.From<Integer>(LField.AsInteger));
        ftDate:
          LProp.SetValue(AEntity, TValue.From<TDate>(LField.AsDateTime));
        ftTimeStamp:
          LProp.SetValue(AEntity, TValue.From<TDateTime>(LField.AsDateTime));
        ftString:
          LProp.SetValue(AEntity, TValue.From<string>(LField.AsString));
        else
          LProp.SetValue(AEntity, TValue.FromVariant(LField.Value));
      end;
    end;
  end;
end;

procedure TtftDataControllerExtensions.UpdateRecord;
var
  LAssignedValue: Boolean;
  LCommand: TDataSet;
  LField: TField;
  LProp: TRttiProperty;
  LType: TRttiType;
begin
  CreateSelectCommand(GetLKeyValues, LCommand);
  try
    LCommand.Open;
    if not LCommand.IsEmpty then
    begin
      LCommand.Edit;
      LAssignedValue := False;
      TryGetType(Entity.ClassType, LType);
      for LProp in LType.GetProperties do
      begin
        LField := LCommand.FindField(LProp.Name);
        if Assigned(LField) then
        begin
          if (LProp.PropertyType.Name = 'string') and
            (LProp.GetValue(Entity).AsVariant = '') then
          begin
            LField.Clear;
          end
          else
          begin
            LField.Value := LProp.GetValue(Entity).AsVariant;
          end;
          LAssignedValue := True;
        end;
      end;
      if LAssignedValue then
      begin
        LCommand.Post;
      end
      else
      begin
        LCommand.Cancel;
      end;
    end;
    LCommand.Close;
  finally
    FreeAndNil(LCommand);
  end;
end;

end.
