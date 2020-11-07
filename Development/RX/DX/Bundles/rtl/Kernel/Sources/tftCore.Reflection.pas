{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

{ *********************************************************** }
{ *              Biblioteca de utilidades RTTI              * }
{ *********************************************************** }

unit tftCore.Reflection;

interface

uses
{IDE}
  System.Classes,
  System.Rtti,
  System.TypInfo,
  System.SysUtils;

type
    TObjectExtensions = class helper for TObject
  strict private
    class function InternalNewObject(const ATypeInfo: Pointer; const Args: array of TValue): TObject; static;
    procedure InternalAssignOf(const Source: TObject);
  public
    class function CreateObject(const ClassType: TClass; const Args: array of TValue): TObject; overload; static;
    class function CreateObject(const ClassType: TClass): TObject; overload; static;
    class function CreateObject<T: class>: T; overload; static;
    class function CreateObject<T: class>(const Args: array of TValue): T; overload; static;
    class function CreateObject<T: class>(const ClassType: TClass): T; overload; static;
    class function CreateObject<T: class>(const ClassType: TClass; const Args: array of TValue): T; overload; static;
    class function IIF<T>(AValue: Boolean; const ATrue: T; AFalse: T): T; inline; static;
    class function NewObject<T: class, constructor>(const Args: array of TValue): T; overload; static;
    class function NewObject(const ATypeInfo: Pointer; const Args: array of TValue): TObject; overload; static;
    class function TryGetType(const AClassType: TClass; out AType: TRttiType): Boolean; overload;
    class function TryGetType(const ATypeInfo: Pointer; out AType: TRttiType): Boolean; overload;
    function GetDeclaredProperties: TArray<TRttiProperty>;
    function GetField(const AName: string): TRttiField;
    function GetFields: TArray<TRttiField>;
    function GetGenericArguments: TArray<TRttiType>;
    function GetMember(const AName: string): TRttiMember;
    function GetMethod(ACodeAddress: Pointer): TRttiMethod; overload;
    function GetMethod(const AName: string): TRttiMethod; overload;
    function GetMethods: TArray<TRttiMethod>;
    function GetProperties: TArray<TRttiProperty>;
    function GetProperty(const AName: string): TRttiProperty;
    function GetType: TRttiType; overload;
    function GetType(AClass: TClass): TRttiType; overload;
    function HasField(const AName: string): Boolean;
    function HasMethod(const AName: string): Boolean;
    function HasProperty(const AName: string): Boolean;
    function IsGenericTypeDefinition: Boolean;
    function IsMatchRegEx(const SearchText, Pattern: string): Boolean;
    function TryGetField(const AName: string; out AField: TRttiField): Boolean;
    function TryGetMember(const AName: string; out AMember: TRttiMember): Boolean;
    function TryGetMethod(ACodeAddress: Pointer; out AMethod: TRttiMethod): Boolean; overload;
    function TryGetMethod(const AName: string; out AMethod: TRttiMethod): Boolean; overload;
    function TryGetProperty(const AName: string; out AProperty: TRttiProperty): Boolean;
    function TryGetType(out AType: TRttiType): Boolean; overload;
    procedure AssignOf<T: class>(const Source: T);
    procedure DSFreeAndNil(var AObj);
    procedure ReleaseInstanceDependencies;
  end;

  TRttiFieldExtensions = class helper for TRttiField
  strict private
    function GetMetaclassType: TClass;
  public
    function AsInstance: TRttiInstanceType;
    function IsInstance: Boolean;
    function TryGetValue(Instance: Pointer; out Value: TValue): Boolean;
    property MetaclassType: TClass read GetMetaclassType;
  end;

  TRttiMethodExtensions = class helper for TRttiMethod
  strict private
    function GetParameterCount: Integer;
  public
    function Format(const Args: array of TValue; SkipSelf: Boolean = True): string;
    property ParameterCount: Integer read GetParameterCount;
  end;

  TRttiPropertyExtensions = class helper for TRttiProperty
  strict private
    function GetMetaclassType: TClass;
  public
    function AsInstance: TRttiInstanceType;
    function IsCollection: Boolean;
    function IsInstance: Boolean;
    function TryGetValue(Instance: Pointer; out Value: TValue): Boolean;
    function TrySetValue(Instance: Pointer; Value: TValue): Boolean;
    property MetaclassType: TClass read GetMetaclassType;
  end;

  TRttiTypeExtensions = class helper for TRttiType
  private
    function InheritsFrom(OtherType: PTypeInfo): Boolean;
  strict private
    function GetIsInterface: Boolean;
    function GetMetaclassType: TClass;
  public
    function GetDeclaredProperty(const AName: string): TRttiProperty;
    function GetFullName: string;
    function GetGenericArguments(const ConsiderInheritance: Boolean = False): TArray<TRttiType>;
    function GetGenericTypeDefinition(const AIncludeUnitName: Boolean = True): string;
    function GetMethod(ACodeAddress: Pointer): TRttiMethod; overload;
    function IsCovariantTo(OtherClass: TClass): Boolean; overload;
    function IsCovariantTo(OtherType: PTypeInfo): Boolean; overload;
    function IsGenericTypeDefinition(const ConsiderInheritance: Boolean = False): Boolean;
    function IsGenericTypeOf(const BaseTypeName: string): Boolean;
    function IsInheritedFrom(OtherType: TRttiType): Boolean; overload;
    function IsInheritedFrom(const OtherTypeName: string): Boolean; overload;
    function IsInheritedFrom(const AClass: TClass): Boolean; overload;
    function MakeGenericType(TypeArguments: array of PTypeInfo): TRttiType;
    function TryGetField(const AName: string; out AField: TRttiField): Boolean;
    function TryGetMethod(ACodeAddress: Pointer; out AMethod: TRttiMethod): Boolean; overload;
    function TryGetMethod(const AName: string; out AMethod: TRttiMethod): Boolean; overload;
    function TryGetProperty(const AName: string; out AProperty: TRttiProperty): Boolean;
    property IsInterface: Boolean read GetIsInterface;
    property MetaclassType: TClass read GetMetaclassType;
  end;

  TValueExtensions = record helper for TValue
  private
    class function FromFloat(ATypeInfo: PTypeInfo; AValue: Extended): TValue; static;
  strict private
    function GetRttiType: TRttiType;
  public
    class function Equals(const Left, Right: TArray<TValue>): Boolean; overload; static;
    class function Equals<T>(const Left, Right: T): Boolean; overload; static;
    class function From(const ABuffer: Pointer; const ATypeInfo: PTypeInfo): TValue; overload; static;
    class function From(const AValue: NativeInt; const ATypeInfo: PTypeInfo): TValue; overload; static;
    class function From(const AObject: TObject; const AClass: TClass): TValue; overload; static;
    class function FromBoolean(const Value: Boolean): TValue; static;
    class function FromString(const Value: string): TValue; static;
    class function FromVarRec(const Value: TVarRec): TValue; static;
    class function ToString(const Value: TValue): string; overload; static;
    class function ToString(const Values: array of TValue; Index: Integer = 0): string; overload; static;
    function AsByte: Byte;
    function AsCardinal: Cardinal;
    function AsCurrency: Currency;
    function AsDate: TDate;
    function AsDateTime: TDateTime;
    function AsDouble: Double;
    function AsFloat: Extended;
    function AsPointer: Pointer;
    function AsShortInt: ShortInt;
    function AsSingle: Single;
    function AsSmallInt: SmallInt;
    function AsTime: TTime;
    function AsUInt64: UInt64;
    function AsWord: Word;
    function IsBoolean: Boolean;
    function IsByte: Boolean;
    function IsCardinal: Boolean;
    function IsCurrency: Boolean;
    function IsDate: Boolean;
    function IsDateTime: Boolean;
    function IsDouble: Boolean;
    function IsFloat: Boolean;
    function IsInstance: Boolean;
    function IsInteger: Boolean;
    function IsInterface: Boolean;
    function IsInt64: Boolean;
    function IsNumeric: Boolean;
    function IsPointer: Boolean;
    function IsShortInt: Boolean;
    function IsSingle: Boolean;
    function IsSmallInt: Boolean;
    function IsString: Boolean;
    function IsTime: Boolean;
    function IsUInt64: Boolean;
    function IsVariant: Boolean;
    function IsWord: Boolean;
    function ToObject: TObject;
    function TryConvert(ATypeInfo: PTypeInfo; out AResult: TValue): Boolean; overload;
    function TryConvert<T>(out AResult: TValue): Boolean; overload;
    property RttiType: TRttiType read GetRttiType;
  end;

  TCollectionExtensions = class helper for TCollection
  public
    function FindItemByID(ID: Integer): TCollectionItem;
  end;



  function VarToDateDef(const AVariant: Variant; ADefault: Integer): TDate;
  function VarToDateTimeDef(const AVariant: Variant; ADefault: Integer): TDateTime;
  function VarToFloatDef(const AVariant: Variant; ADefault: Integer): Double;
  function VarToInt(const AVariant: Variant): Integer;
  function VarToIntDef(const AVariant: Variant; ADefault: Integer): Integer;

var
  Context: TRttiContext;

implementation

uses
{IDE}
  System.Generics.Collections,
  System.Generics.Defaults,
  System.Math,
  System.RegularExpressions,
  System.StrUtils,
  System.Types,
  System.Variants;

var
  Covariances: TDictionary<TPair<PTypeInfo, PTypeInfo>, Boolean>;
  Enumerations: TObjectDictionary<PTypeInfo, TStrings>;

resourcestring
  SComma = ',';
  SDot = '.';
  SGreaterThan = '>';
  SLessThan = '<';
  SBParentheses = '(';
  SEParentheses = ')';
  SSpace = ' ';
  SUL = '_';

  VK_ENTER = #13#10;
  VK_TAB = #9;

  SArgumentIsNullOrWhitespace = 'O argumento ''%s'' é nulo ou contém espaços em branco.';
  SArgumentNullException = 'O valor não pode ser nulo. Parâmetro: ''%s''.';
  SConstructorMethodNotFound = 'O método construtor de %d argumento(s), do objeto ''%s'', não pôde ser encontrado.';
  SIndexError = 'Índice fora do intervalo.';
  SInvalidClassType = 'Tipo inválido de classe. Classe: %s.';
  SItemNotFound = 'Item não encontrado.';
  SItemReinserted = 'Item inserido duas vezes.';

function VarToDateDef(const AVariant: Variant; ADefault: Integer): TDate;
begin
  Result := StrToDateDef(Trim(VarToStr(AVariant)), ADefault);
end;

function VarToDateTimeDef(const AVariant: Variant; ADefault: Integer): TDateTime;
begin
  Result := StrToDateTimeDef(Trim(VarToStr(AVariant)), ADefault);
end;

function VarToFloatDef(const AVariant: Variant; ADefault: Integer): Double;
begin
  Result := StrToFloatDef(Trim(VarToStr(AVariant)), ADefault);
end;

function VarToInt(const AVariant: Variant): Integer;
begin
  Result := StrToIntDef(Trim(VarToStr(AVariant)), 0);
end;

function VarToIntDef(const AVariant: Variant; ADefault: Integer): Integer;
begin
  Result := StrToIntDef(Trim(VarToStr(AVariant)), ADefault);
end;

function ExtractGenericArguments(ATypeInfo: PTypeInfo): string;
var
  Index: Integer;
  LName: string;
begin
  LName := UTF8ToString(ATypeInfo.Name);
  Index := Pos(SLessThan, LName);
  if Index > 0 then
    Exit(Copy(LName, Succ(Index), Length(LName) - Succ(Index)));
  Result := string.Empty;
end;

function FindType(const AName: string; out AType: TRttiType): Boolean;
var
  LType: TRttiType;
begin
  AType := Context.FindType(AName);
  Result := Assigned(AType);
  if not Result then
    for LType in Context.GetTypes do
      if SameText(LType.Name, AName) then
      begin
        AType := LType;
        Exit(True);
      end;
end;

function IsTypeCovariantTo(ThisType, OtherType: PTypeInfo): Boolean;
var
  LType: TRttiType;
begin
  LType := Context.GetType(ThisType);
  Result := Assigned(LType) and LType.IsCovariantTo(OtherType);
end;

function MergeStrings(Values: TStringDynArray; const Delimiter: string): string;
var
  Index: Integer;
begin
  for Index := Low(Values) to High(Values) do
    if Index = 0 then
      Result := Values[Index]
    else
      Result := Concat(Result, Delimiter, Values[Index]);
end;

function SameValue(const Left, Right: TValue): Boolean;
begin
  if Left.IsNumeric and Right.IsNumeric then
  begin
    if Left.IsOrdinal then
    begin
      if Right.IsOrdinal then
        Result := Left.AsOrdinal = Right.AsOrdinal
      else if Right.IsSingle then
        Result := System.Math.SameValue(Left.AsOrdinal, Right.AsSingle)
      else if Right.IsDouble then
        Result := System.Math.SameValue(Left.AsOrdinal, Right.AsDouble)
      else
        Result := System.Math.SameValue(Left.AsOrdinal, Right.AsExtended);
    end
    else if Left.IsSingle then
    begin
      if Right.IsOrdinal then
        Result := System.Math.SameValue(Left.AsSingle, Right.AsOrdinal)
      else if Right.IsSingle then
        Result := System.Math.SameValue(Left.AsSingle, Right.AsSingle)
      else if Right.IsDouble then
        Result := System.Math.SameValue(Left.AsSingle, Right.AsDouble)
      else
        Result := System.Math.SameValue(Left.AsSingle, Right.AsExtended);
    end
    else if Left.IsDouble then
    begin
      if Right.IsOrdinal then
        Result := System.Math.SameValue(Left.AsDouble, Right.AsOrdinal)
      else if Right.IsSingle then
        Result := System.Math.SameValue(Left.AsDouble, Right.AsSingle)
      else if Right.IsDouble then
        Result := System.Math.SameValue(Left.AsDouble, Right.AsDouble)
      else
        Result := System.Math.SameValue(Left.AsDouble, Right.AsExtended);
    end
    else
    begin
      if Right.IsOrdinal then
        Result := System.Math.SameValue(Left.AsExtended, Right.AsOrdinal)
      else if Right.IsSingle then
        Result := System.Math.SameValue(Left.AsExtended, Right.AsSingle)
      else if Right.IsDouble then
        Result := System.Math.SameValue(Left.AsExtended, Right.AsDouble)
      else
        Result := System.Math.SameValue(Left.AsExtended, Right.AsExtended)
    end;
  end
  else if Left.IsString and Right.IsString then
    Result := Left.AsString = Right.AsString
  else if Left.IsClass and Right.IsClass then
    Result := Left.AsClass = Right.AsClass
  else if Left.IsObject and Right.IsObject then
    Result := Left.AsObject = Right.AsObject
  else if Left.IsPointer and Right.IsPointer then
    Result := Left.AsPointer = Right.AsPointer
  else if Left.IsVariant and Right.IsVariant then
    Result := Left.AsVariant = Right.AsVariant
  else if Left.TypeInfo = Right.TypeInfo then
    Result := Left.AsPointer = Right.AsPointer
  else
    Result := False;
end;

function StripUnitName(const s: string): string;
begin
  Result := ReplaceText(s, 'System.', string.Empty);
end;

function TryGetRttiType(AClass: TClass; out AType: TRttiType): Boolean; overload;
begin
  AType := Context.GetType(AClass);
  Result := Assigned(AType);
end;

function TryGetRttiType(ATypeInfo: PTypeInfo; out AType: TRttiType): Boolean; overload;
begin
  AType := Context.GetType(ATypeInfo);
  Result := Assigned(AType);
end;

type
  TConvertFunc = function(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;

function ConvAny2Nullable(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
var
  LType: TRttiType;
  LValue: TValue;
  LBuffer: array of Byte;
begin
  Result := TryGetRttiType(ATarget, LType) and LType.IsGenericTypeOf('Nullable') and
    ASource.TryConvert(LType.GetGenericArguments[0].Handle, LValue);
  if Result then
  begin
    SetLength(LBuffer, LType.TypeSize);
    Move(LValue.GetReferenceToRawData^, LBuffer[0], LType.TypeSize - SizeOf(string));
    PString(@LBuffer[LType.TypeSize - SizeOf(string)])^ := DefaultTrueBoolStr;
    TValue.Make(LBuffer, LType.Handle, AResult);
    PString(@LBuffer[LType.TypeSize - SizeOf(string)])^ := '';
  end
end;

function ConvClass2Class(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
begin
  Result := ASource.TryCast(ATarget, AResult);
  if not Result and IsTypeCovariantTo(ASource.TypeInfo, ATarget) then
  begin
    AResult := TValue.From(ASource.AsObject, GetTypeData(ATarget).ClassType);
    Result := True;
  end;
end;

function ConvClass2Enum(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
begin
  Result := ATarget = TypeInfo(Boolean);
  if Result then
    AResult := not(ASource.AsObject = nil);
end;

function ConvEnum2Class(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
var
  I: Integer;
  LType: TRttiType;
  LStrings: TStrings;
begin
  Result := TryGetRttiType(ATarget, LType) and LType.MetaclassType.InheritsFrom(TStrings);
  if not Result then
    Exit;
  if not Enumerations.TryGetValue(ASource.TypeInfo, LStrings) then
  begin
    LStrings := TStringList.Create;
    with TRttiEnumerationType(ASource.RttiType) do
      for I := MinValue to MaxValue do
        LStrings.Add(GetEnumName(Handle, I));
    Enumerations.Add(ASource.TypeInfo, LStrings);
  end;
  AResult := TValue.From(LStrings, TStrings);
  Result := True;
end;

function ConvFail(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
begin
  Result := False;
end;

function ConvFloat2Ord(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
begin
  Result := Frac(ASource.AsExtended) = 0;
  if Result then
    AResult := TValue.FromOrdinal(ATarget, Trunc(ASource.AsExtended));
end;

function ConvFloat2Str(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
var
  LValue: TValue;
begin
  if ASource.TypeInfo = TypeInfo(TDate) then
    LValue := DateToStr(ASource.AsExtended)
  else if ASource.TypeInfo = TypeInfo(TDateTime) then
    LValue := DateTimeToStr(ASource.AsExtended)
  else if ASource.TypeInfo = TypeInfo(TTime) then
    LValue := TimeToStr(ASource.AsExtended)
  else
    LValue := FloatToStr(ASource.AsExtended);
  Result := LValue.TryCast(ATarget, AResult);
end;

function ConvIntf2Class(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
begin
  Result := ConvClass2Class(ASource.AsInterface as TObject, ATarget, AResult);
end;

function ConvIntf2Intf(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
var
  LSourceType, LTargetType: TRttiType;
  LMethod: TRttiMethod;
  LInterface: IInterface;
begin
  Result := ASource.TryCast(ATarget, AResult);
  if not Result then
    if IsTypeCovariantTo(ASource.TypeInfo, ATarget) then
    begin
      AResult := TValue.From(ASource.GetReferenceToRawData, ATarget);
      Result := True;
    end
    else if TryGetRttiType(ASource.TypeInfo, LSourceType) and LSourceType.IsGenericTypeOf('IList') then
      if (ATarget.Name = 'IList') and LSourceType.TryGetMethod('AsList', LMethod) then
      begin
        LInterface := LMethod.Invoke(ASource, []).AsInterface;
        AResult := TValue.From(@LInterface, ATarget);
        Result := True;
      end
      else if TryGetRttiType(ATarget, LTargetType) and LTargetType.IsGenericTypeOf('IList') then
      begin
        LInterface := ASource.AsInterface;
        AResult := TValue.From(@LInterface, ATarget);
        Result := True;
      end;
end;

function ConvOrd2Ord(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
begin
  AResult := TValue.FromOrdinal(ATarget, ASource.AsOrdinal);
  Result := True;
end;

function ConvOrd2Float(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
begin
  AResult := TValue.FromFloat(ATarget, ASource.AsOrdinal);
  Result := True;
end;

function ConvOrd2Str(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
var
  LValue: TValue;
begin
  LValue := ASource.ToString;
  Result := LValue.TryCast(ATarget, AResult);
end;

function ConvNullable2Any(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
var
  LType: TRttiType;
  LValue: TValue;
begin
  Result := TryGetRttiType(ASource.TypeInfo, LType) and LType.IsGenericTypeOf('Nullable');
  if Result then
  begin
    LValue := TValue.From(ASource.GetReferenceToRawData, LType.GetGenericArguments[0].Handle);
    Result := LValue.TryConvert(ATarget, AResult);
  end
end;

function ConvRec2Meth(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
begin
  if ASource.TypeInfo = TypeInfo(TMethod) then
  begin
    AResult := TValue.From(ASource.GetReferenceToRawData, ATarget);
    Exit(True);
  end;
  Result := ConvNullable2Any(ASource, ATarget, AResult);
end;

function ConvSet2Class(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
var
  LType: TRttiType;
  LTypeData: PTypeData;
  LStrings: TStrings;
  I: Integer;
begin
  Result := TryGetRttiType(ATarget, LType) and LType.AsInstance.MetaclassType.InheritsFrom(TStrings);
  if not Result then
    Exit;
  LTypeData := GetTypeData(ASource.TypeInfo);
  if not Enumerations.TryGetValue(LTypeData.CompType^, LStrings) then
  begin
    LStrings := TStringList.Create;
    with TRttiEnumerationType(TRttiSetType(ASource.RttiType).ElementType) do
      for I := MinValue to MaxValue do
        LStrings.Add(GetEnumName(Handle, I));
    Enumerations.Add(LTypeData.CompType^, LStrings);
  end;
  AResult := TValue.From(LStrings, TStrings);
end;

function ConvStr2Enum(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
begin
  AResult := TValue.FromOrdinal(ATarget, GetEnumValue(ATarget, ASource.AsString));
  Result := True;
end;

function ConvStr2Float(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
begin
  if ATarget = TypeInfo(TDate) then
    AResult := TValue.From<TDate>(StrToDateDef(ASource.AsString, 0))
  else if ATarget = TypeInfo(TDateTime) then
    AResult := TValue.From<TDateTime>(StrToDateTimeDef(ASource.AsString, 0))
  else if ATarget = TypeInfo(TTime) then
    AResult := TValue.From<TTime>(StrToTimeDef(ASource.AsString, 0))
  else
    AResult := TValue.FromFloat(ATarget, StrToFloatDef(ASource.AsString, 0));
  Result := True;
end;

function ConvStr2Ord(const ASource: TValue; ATarget: PTypeInfo; out AResult: TValue): Boolean;
begin
  AResult := TValue.FromOrdinal(ATarget, StrToInt64Def(ASource.AsString, 0));
  Result := True;
end;

const
  Conversions: array [TTypeKind, TTypeKind] of TConvertFunc = (
    // tkUnknown
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkInteger
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvOrd2Ord, ConvOrd2Ord, ConvOrd2Ord, ConvOrd2Float, ConvOrd2Str,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvOrd2Ord, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkChar
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvOrd2Ord, ConvOrd2Ord, ConvOrd2Ord, ConvOrd2Float, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvOrd2Ord, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkEnumeration
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvOrd2Ord, ConvOrd2Ord, ConvOrd2Ord, ConvOrd2Float, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvEnum2Class, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvOrd2Ord, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkFloat
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFloat2Ord, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFloat2Ord, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkString
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure  , tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkSet
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvSet2Class, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkClass
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvClass2Enum, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvClass2Class, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkMethod
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkWChar
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvOrd2Ord, ConvOrd2Ord, ConvOrd2Ord, ConvOrd2Float, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvOrd2Ord, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkLString
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkWString
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkVariant
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkArray
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkRecord
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvRec2Meth, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkInterface
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvIntf2Class, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvIntf2Intf, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkInt64
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvOrd2Ord, ConvOrd2Ord, ConvOrd2Ord, ConvOrd2Float, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvOrd2Ord, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkDynArray
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkUString
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvStr2Ord, ConvFail, ConvStr2Enum, ConvStr2Float, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvStr2Ord, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkClassRef
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkPointer
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkProcedure
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail),
//    ConvFail, ConvFail, ConvFail, ConvFail),
    // tkMRecord
    (
    // tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail, ConvFail,
    // tkUString, tkClassRef, tkPointer, tkProcedure, tkMRecord
    ConvFail, ConvFail, ConvFail, ConvFail, ConvFail)
    {ConvFail, ConvFail, ConvFail, ConvFail)});

{ TObjectExtensions }

class function TObjectExtensions.CreateObject(const ClassType: TClass; const Args: array of TValue): TObject;
var
  LType: TRttiType;
begin
  Result := NewObject(ClassType.ClassInfo, Args);
  if Assigned(Result) then
    Exit;
  TryGetType(ClassType, LType);
  raise Exception.CreateFmt(SConstructorMethodNotFound, [Length(Args), LType.MetaclassType.QualifiedClassName]);
end;

procedure TObjectExtensions.AssignOf<T>(const Source: T);
begin
  InternalAssignOf(TObject(Source));
end;

class function TObjectExtensions.IIF<T>(AValue: Boolean; const ATrue: T; AFalse: T): T;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

procedure TObjectExtensions.InternalAssignOf(const Source: TObject);
var
  LDestinyEnum, LSourceEnum: TEnumerable<TObject>;
  LDestinyObj, LSourceObj: TObject;
  LDestinyType, LSourceType, LType: TRttiType;
  LDestinyField, LSourceField: TRttiField;
  LMethod: TRttiMethod;
  LValue: TValue;
  LOwnsObjects: Boolean;
begin
  TryGetType(Source.ClassInfo, LSourceType);
  for LSourceField in LSourceType.GetFields do
  begin
    if LSourceField.FieldType.IsInstance and
      (LSourceField.FieldType.AsInstance.MetaclassType.InheritsFrom(TRttiObject)) then
      Continue;
    if LSourceField.FieldType.IsInstance and
      TryGetType(LSourceField.AsInstance.MetaclassType, LType) and
      Assigned(LType.GetMethod('GetEnumerator')) and
      LType.IsGenericTypeDefinition(True) and
      LType.TryGetMethod('Add', LMethod) then
    begin
      LSourceEnum := TEnumerable<TObject>(LSourceField.GetValue(Source).AsObject);
      if LType.IsGenericTypeOf('TObjectList') then
      begin
        LOwnsObjects := LType.GetField('FOwnsObjects').GetValue(Source).AsBoolean;
        LDestinyEnum := TEnumerable<TObject>(CreateObject(LSourceField.FieldType.AsInstance.MetaclassType, [LOwnsObjects]));
      end
      else
        LDestinyEnum := TEnumerable<TObject>(CreateObject(LSourceField.FieldType.AsInstance.MetaclassType));
      if Length(LSourceEnum.ToArray) > Low(LSourceEnum.ToArray) then
      begin
        for LSourceObj in LSourceEnum do
        begin
          LDestinyObj := CreateObject(LSourceObj.ClassType);
          LDestinyObj.AssignOf(LSourceObj);
          TryGetType(LDestinyEnum.ClassType, LType);
          LType.TryGetMethod('Add', LMethod);
          LMethod.Invoke(LDestinyEnum, [LDestinyObj]);
        end;
      end;
      LValue := TValue.From(LDestinyEnum);
    end
    else if LSourceField.FieldType.IsInstance and
      TryGetType(LSourceField.FieldType.AsInstance.MetaclassType, LType) and
      not Assigned(LType.GetMethod('GetEnumerator')) then
    begin
      LDestinyObj := nil;
      LSourceObj := LSourceField.GetValue(Source).AsObject;
      if Assigned(LSourceObj) then
      begin
        LDestinyObj := CreateObject(LType.AsInstance.MetaclassType);
        LDestinyObj.AssignOf(LSourceObj);
      end;
      LValue := TValue.From(LDestinyObj);
    end
    else
      LValue := LSourceField.GetValue(Source);
    TryGetType(Self.ClassInfo, LDestinyType);
    LDestinyField := LDestinyType.GetField(LSourceField.Name);
    if Assigned(LDestinyField) then
      LDestinyField.SetValue(Self, LValue);
  end;
end;

class function TObjectExtensions.CreateObject(const ClassType: TClass): TObject;
begin
  Result := CreateObject(ClassType, []);
end;

class function TObjectExtensions.CreateObject<T>: T;
begin
  Result := CreateObject(T, []) as T;
end;

class function TObjectExtensions.CreateObject<T>(const Args: array of TValue): T;
begin
  Result := CreateObject(T, Args) as T;
end;

class function TObjectExtensions.CreateObject<T>(const ClassType: TClass): T;
begin
  Result := CreateObject(ClassType, []) as T;
end;

class function TObjectExtensions.CreateObject<T>(const ClassType: TClass; const Args: array of TValue): T;
begin
  Result := CreateObject(ClassType, Args) as T;
end;

procedure TObjectExtensions.DSFreeAndNil(var AObj);
begin
  FreeAndNil(AObj);
end;

procedure TObjectExtensions.ReleaseInstanceDependencies;
var
  LField: TRttiField;
  LInstance: TObject;
  LType: TRttiType;
begin
  TryGetType(Self.ClassType, LType);
  if LType.IsGenericTypeDefinition and Assigned(LType.GetMethod('GetEnumerator')) then
    Exit;
  for LField in GetFields do
  begin
    if not LField.IsInstance then
      Continue;
    LInstance := LField.GetValue(Self).AsObject;
    if not Assigned(LInstance) then
      Continue;
    LInstance.DisposeOf;
  end;
end;

class function TObjectExtensions.InternalNewObject(const ATypeInfo: Pointer; const Args: array of TValue): TObject;
var
  LMethod: TRttiMethod;
  LType: TRttiType;
begin
  TryGetType(ATypeInfo, LType);
  for LMethod in LType.GetMethods do
    if LMethod.IsConstructor and (LMethod.ParameterCount = Length(Args)) then
      Exit(LMethod.Invoke(LType.MetaclassType, Args).AsObject);
  Result := nil;
end;

function TObjectExtensions.IsGenericTypeDefinition: Boolean;
var
  LType: TRttiType;
begin
  if TryGetType(LType) then
    Exit(LType.IsGenericTypeDefinition);
  Result := False;
end;

function TObjectExtensions.IsMatchRegEx(const SearchText, Pattern: string): Boolean;
begin
  Result := TRegEx.Create(Pattern).Match(SearchText).Success;
end;

class function TObjectExtensions.NewObject(const ATypeInfo: Pointer; const Args: array of TValue): TObject;
begin
  Result := InternalNewObject(ATypeInfo, Args);
end;

class function TObjectExtensions.NewObject<T>(const Args: array of TValue): T;
begin
  Result := InternalNewObject(TypeInfo(T), Args) as T;
end;

class function TObjectExtensions.TryGetType(const AClassType: TClass; out AType: TRttiType): Boolean;
begin
  AType := Context.GetType(AClassType);
  Result := Assigned(AType);
end;

class function TObjectExtensions.TryGetType(const ATypeInfo: Pointer; out AType: TRttiType): Boolean;
begin
  AType := Context.GetType(ATypeInfo);
  Result := Assigned(AType);
end;

function TObjectExtensions.GetDeclaredProperties: TArray<TRttiProperty>;
var
  LType: TRttiType;
begin
  if TryGetType(LType) then
    Exit(LType.GetDeclaredProperties);
  Result := nil;
end;

function TObjectExtensions.GetField(const AName: string): TRttiField;
var
  LType: TRttiType;
begin
  if TryGetType(LType) then
    Exit(LType.GetField(AName));
  Result := nil;
end;

function TObjectExtensions.GetFields: TArray<TRttiField>;
var
  LType: TRttiType;
begin
  if TryGetType(LType) then
    Exit(LType.GetFields);
  Result := nil;
end;

function TObjectExtensions.GetGenericArguments: TArray<TRttiType>;
var
  LType: TRttiType;
begin
  if TryGetType(LType) then
    Exit(LType.GetGenericArguments);
  Result := nil;
end;

function TObjectExtensions.GetMember(const AName: string): TRttiMember;
var
  LType: TRttiType;
begin
  if TryGetType(LType) then
    Exit(LType.GetMember(AName));
  Result := nil;
end;

function TObjectExtensions.GetMethod(ACodeAddress: Pointer): TRttiMethod;
var
  LType: TRttiType;
begin
  if TryGetType(LType) then
    Exit(LType.GetMethod(ACodeAddress));
  Result := nil;
end;

function TObjectExtensions.GetMethod(const AName: string): TRttiMethod;
var
  LType: TRttiType;
begin
  Result := nil;
  if TryGetType(LType) then
    try
      Result := LType.GetMethod(AName);
    except
      Result := nil;
    end;
end;

function TObjectExtensions.GetMethods: TArray<TRttiMethod>;
var
  LType: TRttiType;
begin
  if TryGetType(LType) then
    Exit(LType.GetMethods);
  Result := nil;
end;

function TObjectExtensions.GetProperties: TArray<TRttiProperty>;
var
  LType: TRttiType;
begin
  if TryGetType(LType) then
    Exit(LType.GetProperties);
  Result := nil;
end;

function TObjectExtensions.GetProperty(const AName: string): TRttiProperty;
var
  LType: TRttiType;
begin
  if TryGetType(LType) then
    Exit(LType.GetProperty(AName));
  Result := nil;
end;

function TObjectExtensions.GetType(AClass: TClass): TRttiType;
begin
  Result := Context.GetType(AClass);
end;

function TObjectExtensions.GetType: TRttiType;
begin
  TryGetType(Result);
end;

function TObjectExtensions.HasField(const AName: string): Boolean;
begin
  Result := not(GetField(AName) = nil);
end;

function TObjectExtensions.HasMethod(const AName: string): Boolean;
begin
  Result := not(GetMethod(AName) = nil);
end;

function TObjectExtensions.HasProperty(const AName: string): Boolean;
begin
  Result := not(GetProperty(AName) = nil);
end;

function TObjectExtensions.TryGetField(const AName: string; out AField: TRttiField): Boolean;
begin
  AField := GetField(AName);
  Result := Assigned(AField);
end;

function TObjectExtensions.TryGetMember(const AName: string; out AMember: TRttiMember): Boolean;
begin
  AMember := GetMember(AName);
  Result := Assigned(AMember);
end;

function TObjectExtensions.TryGetMethod(ACodeAddress: Pointer; out AMethod: TRttiMethod): Boolean;
begin
  AMethod := GetMethod(ACodeAddress);
  Result := Assigned(AMethod);
end;

function TObjectExtensions.TryGetMethod(const AName: string; out AMethod: TRttiMethod): Boolean;
begin
  AMethod := GetMethod(AName);
  Result := Assigned(AMethod);
end;

function TObjectExtensions.TryGetProperty(const AName: string; out AProperty: TRttiProperty): Boolean;
begin
  AProperty := GetProperty(AName);
  Result := Assigned(AProperty);
end;

function TObjectExtensions.TryGetType(out AType: TRttiType): Boolean;
begin
  if not Assigned(Self) then
    Exit(False);
  AType := Context.GetType(ClassInfo);
  Result := Assigned(AType);
end;

{ TRttiFieldExtensions }

function TRttiFieldExtensions.AsInstance: TRttiInstanceType;
begin
  Result := FieldType.AsInstance;
end;

function TRttiFieldExtensions.GetMetaclassType: TClass;
begin
  Result := FieldType.MetaclassType;
end;

function TRttiFieldExtensions.IsInstance: Boolean;
begin
  Result := FieldType.IsInstance;
end;

function TRttiFieldExtensions.TryGetValue(Instance: Pointer; out Value: TValue): Boolean;
begin
  try
    Value := GetValue(Instance);
    Result := True;
  except
    Value := TValue.Empty;
    Result := False;
  end;
end;

{ TRttiMethodExtensions }

function TRttiMethodExtensions.Format(const Args: array of TValue; SkipSelf: Boolean): string;
begin
  Result := Concat(StripUnitName(Parent.Name), SDot, Name, SBParentheses);
  if SkipSelf then
  begin
    if Length(Args) > 1 then
      Result := Concat(Result, TValue.ToString(Args, 1));
  end
  else
    Result := Concat(Result, TValue.ToString(Args));
  Result := Concat(Result, SEParentheses);
end;

function TRttiMethodExtensions.GetParameterCount: Integer;
begin
  Result := Length(GetParameters);
end;

{ TRttiPropertyExtensions }

function TRttiPropertyExtensions.AsInstance: TRttiInstanceType;
begin
  Result := PropertyType.AsInstance;
end;

function TRttiPropertyExtensions.GetMetaclassType: TClass;
begin
  Result := PropertyType.AsInstance.MetaclassType;
end;

function TRttiPropertyExtensions.IsCollection: Boolean;
var
  LType: TRttiType;
begin
  Result := Self.IsInstance and TryGetType(Self.MetaclassType, LType) and
    LType.IsGenericTypeDefinition and Assigned(LType.GetMethod('GetEnumerator'));
end;

function TRttiPropertyExtensions.IsInstance: Boolean;
begin
  Result := PropertyType.IsInstance;
end;

function TRttiPropertyExtensions.TryGetValue(Instance: Pointer; out Value: TValue): Boolean;
begin
  try
    if IsReadable then
    begin
      Value := GetValue(Instance);
      Result := True;
    end
    else
      Result := False;
  except
    Value := TValue.Empty;
    Result := False;
  end;
end;

function TRttiPropertyExtensions.TrySetValue(Instance: Pointer; Value: TValue): Boolean;
var
  LValue: TValue;
begin
  Result := Value.TryConvert(PropertyType.Handle, LValue);
  if Result then
    SetValue(Instance, LValue);
end;

{ TRttiTypeExtensions }

function TRttiTypeExtensions.GetDeclaredProperty(const AName: string): TRttiProperty;
var
  LProperty: TRttiProperty;
begin
  for LProperty in Self.GetDeclaredProperties do
    if SameText(LProperty.Name, AName) then
      Exit(LProperty);
  Result := nil;
end;

function TRttiTypeExtensions.GetFullName: string;
var
  LType: TRttiType;
begin
  LType := Self;
  while Assigned(LType) do
  begin
    Result := Concat(LType.Name, IfThen(not Result.IsEmpty, '->'), Result);
    LType := LType.BaseType;
  end;
end;

function TRttiTypeExtensions.GetGenericArguments(const ConsiderInheritance: Boolean = False): TArray<TRttiType>;
var
  Args: TStringDynArray;
  Index: Integer;
begin
  Args := SplitString(ExtractGenericArguments(Handle), SComma);
  if Length(Args) > 0 then
  begin
    SetLength(Result, Length(Args));
    for Index := 0 to Pred(Length(Args)) do
      FindType(Args[Index], Result[Index]);
  end
  else if ConsiderInheritance and Assigned(BaseType) then
    Result := BaseType.GetGenericArguments;
end;

function TRttiTypeExtensions.GetGenericTypeDefinition(const AIncludeUnitName: Boolean): string;
var
  I: Integer;
  Args: TStringDynArray;
  LValue: string;
begin
  Args := SplitString(ExtractGenericArguments(Handle), ',');
  for I := Low(Args) to High(Args) do
    if (I = 0) and (Length(Args) = 1) then
      Args[I] := 'T'
    else
      Args[I] := 'T' + IntToStr(Succ(I));
  if IsPublicType and AIncludeUnitName then
    LValue := QualifiedName
  else
    LValue := Name;
  Result := Concat(Copy(LValue, 1, Pos(SLessThan, LValue)) + MergeStrings(Args, SComma),
    SGreaterThan);
end;

function TRttiTypeExtensions.GetIsInterface: Boolean;
begin
  Result := Self is TRttiInterfaceType;
end;

function TRttiTypeExtensions.GetMetaclassType: TClass;
begin
  Result := AsInstance.MetaclassType;
end;

function TRttiTypeExtensions.GetMethod(ACodeAddress: Pointer): TRttiMethod;
var
  LMethod: TRttiMethod;
begin
  for LMethod in GetMethods do
    if LMethod.CodeAddress = ACodeAddress then
      Exit(LMethod);
  Result := nil;
end;

function TRttiTypeExtensions.IsCovariantTo(OtherClass: TClass): Boolean;
begin
  Result := Assigned(OtherClass) and IsCovariantTo(OtherClass.ClassInfo);
end;

function TRttiTypeExtensions.InheritsFrom(OtherType: PTypeInfo): Boolean;
var
  LType: TRttiType;
begin
  Result := Handle = OtherType;
  if not Result then
  begin
    LType := BaseType;
    while Assigned(LType) and not Result do
    begin
      Result := LType.Handle = OtherType;
      LType := LType.BaseType;
    end;
  end;
end;

function TRttiTypeExtensions.IsCovariantTo(OtherType: PTypeInfo): Boolean;
var
  Args, OtherArgs: TArray<TRttiType>;
  I: Integer;
  Key: TPair<PTypeInfo, PTypeInfo>;
  T: TRttiType;
begin
  Key := TPair<PTypeInfo, PTypeInfo>.Create(Handle, OtherType);
  if Covariances.TryGetValue(Key, Result) then
    Exit;
  Result := False;
  T := Context.GetType(OtherType);
  if Assigned(T) and IsGenericTypeDefinition then
  begin
    if SameText(GetGenericTypeDefinition, T.GetGenericTypeDefinition) or
      SameText(GetGenericTypeDefinition(False), T.GetGenericTypeDefinition(False)) then
    begin
      Result := True;
      Args := GetGenericArguments;
      OtherArgs := T.GetGenericArguments;
      for I := Low(Args) to High(Args) do
      begin
        if Args[I].IsInterface and Args[I].IsInterface and Args[I].InheritsFrom(OtherArgs[I].Handle) then
          Continue;
        if Args[I].IsInstance and OtherArgs[I].IsInstance and Args[I].InheritsFrom(OtherArgs[I].Handle) then
          Continue;
        Result := False;
        Break;
      end;
    end
    else if Assigned(BaseType) then
      Result := BaseType.IsCovariantTo(OtherType);
  end
  else
    Result := InheritsFrom(OtherType);
  Covariances.Add(Key, Result);
end;

function TRttiTypeExtensions.IsGenericTypeDefinition(const ConsiderInheritance: Boolean = False): Boolean;
begin
  Result := Length(GetGenericArguments(ConsiderInheritance)) > 0;
  if not Result and ConsiderInheritance and Assigned(BaseType) then
    Result := BaseType.IsGenericTypeDefinition;
end;

function TRttiTypeExtensions.IsGenericTypeOf(const BaseTypeName: string): Boolean;
var
  S: string;
begin
  S := Name;
  Result := (Copy(S, 1, Succ(Length(BaseTypeName))) = (BaseTypeName + SLessThan)) and
    (Copy(S, Length(S), 1) = SGreaterThan);
end;

function TRttiTypeExtensions.IsInheritedFrom(const AClass: TClass): Boolean;
var
  LType: TRttiType;
begin
  TryGetType(AClass, LType);
  Result := IsInheritedFrom(LType);
end;

function TRttiTypeExtensions.IsInheritedFrom(OtherType: TRttiType): Boolean;
var
  LType: TRttiType;
begin
  Result := Self.Handle = OtherType.Handle;
  if Result then
    Exit(False);
  LType := BaseType;
  while Assigned(LType) and not Result do
  begin
    Result := LType.Handle = OtherType.Handle;
    LType := LType.BaseType;
  end;
end;

function TRttiTypeExtensions.IsInheritedFrom(const OtherTypeName: string): Boolean;
var
  LType: TRttiType;
begin
  Result := SameText(Name, OtherTypeName) or (IsPublicType and SameText(QualifiedName, OtherTypeName));
  if not Result then
  begin
    LType := BaseType;
    while Assigned(LType) and not Result do
    begin
      Result := SameText(LType.Name, OtherTypeName) or
        (LType.IsPublicType and SameText(LType.QualifiedName, OtherTypeName));
      LType := LType.BaseType;
    end;
  end;
end;

function TRttiTypeExtensions.MakeGenericType(TypeArguments: array of PTypeInfo): TRttiType;
var
  Args: TStringDynArray;
  Index: Integer;
begin
  if IsPublicType then
  begin
    Args := SplitString(ExtractGenericArguments(Handle), SComma);
    for Index := Low(Args) to High(Args) do
      Args[Index] := Context.GetType(TypeArguments[Index]).QualifiedName;
    Exit(Context.FindType(Concat(Copy(QualifiedName, 1, Pos(SLessThan, QualifiedName)),
      MergeStrings(Args, SComma) + SGreaterThan)));
  end;
  Result := nil;
end;

function TRttiTypeExtensions.TryGetField(const AName: string; out AField: TRttiField): Boolean;
begin
  AField := GetField(AName);
  Result := Assigned(AField);
end;

function TRttiTypeExtensions.TryGetMethod(ACodeAddress: Pointer; out AMethod: TRttiMethod): Boolean;
begin
  AMethod := GetMethod(ACodeAddress);
  Result := Assigned(AMethod);
end;

function TRttiTypeExtensions.TryGetMethod(const AName: string; out AMethod: TRttiMethod): Boolean;
begin
  AMethod := GetMethod(AName);
  Result := Assigned(AMethod);
end;

function TRttiTypeExtensions.TryGetProperty(const AName: string; out AProperty: TRttiProperty): Boolean;
begin
  AProperty := GetProperty(AName);
  Result := Assigned(AProperty);
end;

{ TValueExtensions }

function TValueExtensions.AsByte: Byte;
begin
  Result := AsType<Byte>;
end;

function TValueExtensions.AsCardinal: Cardinal;
begin
  Result := AsType<Cardinal>;
end;

function TValueExtensions.AsCurrency: Currency;
begin
  Result := AsType<Currency>;
end;

function TValueExtensions.AsDate: TDate;
begin
  Result := AsType<TDate>;
end;

function TValueExtensions.AsDateTime: TDateTime;
begin
  Result := AsType<TDateTime>;
end;

function TValueExtensions.AsDouble: Double;
begin
  Result := AsType<Double>;
end;

function TValueExtensions.AsFloat: Extended;
begin
  Result := AsType<Extended>;
end;

function TValueExtensions.AsPointer: Pointer;
begin
  if Kind in [tkClass, tkInterface] then
    Result := ToObject
  else
    Result := GetReferenceToRawData;
end;

function TValueExtensions.AsShortInt: ShortInt;
begin
  Result := AsType<ShortInt>;
end;

function TValueExtensions.AsSingle: Single;
begin
  Result := AsType<Single>;
end;

function TValueExtensions.AsSmallInt: SmallInt;
begin
  Result := AsType<SmallInt>;
end;

function TValueExtensions.AsTime: TTime;
begin
  Result := AsType<TTime>;
end;

function TValueExtensions.AsUInt64: UInt64;
begin
  Result := AsType<UInt64>;
end;

function TValueExtensions.AsWord: Word;
begin
  Result := AsType<Word>;
end;

function TValueExtensions.GetRttiType: TRttiType;
begin
  Result := Context.GetType(TypeInfo);
end;

function TValueExtensions.IsBoolean: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Boolean);
end;

function TValueExtensions.IsByte: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Byte);
end;

function TValueExtensions.IsCardinal: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Cardinal);
{$IFNDEF CPUX64}
  Result := Result or (TypeInfo = System.TypeInfo(NativeUInt));
{$ENDIF}
end;

function TValueExtensions.IsCurrency: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Currency);
end;

function TValueExtensions.IsDate: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(TDate);
end;

function TValueExtensions.IsDateTime: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(TDateTime);
end;

function TValueExtensions.IsDouble: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Double);
end;

function TValueExtensions.IsFloat: Boolean;
begin
  Result := Kind = tkFloat;
end;

function TValueExtensions.IsInstance: Boolean;
begin
  Result := Kind in [tkClass, tkInterface];
end;

function TValueExtensions.IsInt64: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Int64);
{$IFDEF CPUX64}
  Result := Result or (TypeInfo = System.TypeInfo(NativeInt));
{$ENDIF}
end;

function TValueExtensions.IsInteger: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Integer);
{$IFNDEF CPUX64}
  Result := Result or (TypeInfo = System.TypeInfo(NativeInt));
{$ENDIF}
end;

function TValueExtensions.IsInterface: Boolean;
begin
  Result := Assigned(TypeInfo) and (TypeInfo.Kind = tkInterface);
end;

function TValueExtensions.IsNumeric: Boolean;
begin
  Result := Kind in [tkInteger, tkChar, tkEnumeration, tkFloat, tkWChar, tkInt64];
end;

function TValueExtensions.IsPointer: Boolean;
begin
  Result := Kind = tkPointer;
end;

function TValueExtensions.IsShortInt: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(ShortInt);
end;

function TValueExtensions.IsSingle: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Single);
end;

function TValueExtensions.IsSmallInt: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(SmallInt);
end;

function TValueExtensions.IsString: Boolean;
begin
  Result := Kind in [tkChar, tkString, tkWChar, tkLString, tkWString, tkUString];
end;

function TValueExtensions.IsTime: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(TTime);
end;

function TValueExtensions.IsUInt64: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(UInt64);
{$IFDEF CPUX64}
  Result := Result or (TypeInfo = System.TypeInfo(NativeInt));
{$ENDIF}
end;

function TValueExtensions.IsVariant: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Variant);
end;

function TValueExtensions.IsWord: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Word);
end;

function TValueExtensions.ToObject: TObject;
begin
  if IsInterface then
    Result := AsInterface as TObject
  else
    Result := AsObject;
end;

class function TValueExtensions.ToString(const Value: TValue): string;
var
  LInterface: IInterface;
  LObject: TObject;
begin
  case Value.Kind of
    tkFloat:
      begin
        if Value.IsDate then
          Result := DateToStr(Value.AsDate)
        else if Value.IsDateTime then
          Result := DateTimeToStr(Value.AsDateTime)
        else if Value.IsTime then
          Result := TimeToStr(Value.AsTime)
        else
          Result := Value.ToString;
      end;
    tkClass:
      begin
        LObject := Value.AsObject;
        Result := Format('%s($%x)', [StripUnitName(LObject.ClassName), NativeInt(LObject)]);
      end;
    tkInterface:
      begin
        LInterface := Value.AsInterface;
        LObject := LInterface as TObject;
        Result := Format('%s($%x) como %s', [StripUnitName(LObject.ClassName), NativeInt(LInterface),
          StripUnitName(string(Value.TypeInfo.Name))]);
      end
  else
    Result := Value.ToString;
  end;
end;

class function TValueExtensions.Equals(const Left, Right: TArray<TValue>): Boolean;
var
  I: Integer;
begin
  Result := Length(Left) = Length(Left);
  if Result then
    for I := Low(Left) to High(Left) do
      if not SameValue(Left[I], Right[I]) then
        Exit(False);
end;

class function TValueExtensions.Equals<T>(const Left, Right: T): Boolean;
begin
  Result := TEqualityComparer<T>.Default.Equals(Left, Right);
end;

class function TValueExtensions.From(const ABuffer: Pointer; const ATypeInfo: PTypeInfo): TValue;
begin
  TValue.Make(ABuffer, ATypeInfo, Result);
end;

class function TValueExtensions.From(const AValue: NativeInt; const ATypeInfo: PTypeInfo): TValue;
begin
  TValue.Make(AValue, ATypeInfo, Result);
end;

class function TValueExtensions.From(const AObject: TObject; const AClass: TClass): TValue;
begin
  TValue.Make(NativeInt(AObject), AClass.ClassInfo, Result);
end;

class function TValueExtensions.FromBoolean(const Value: Boolean): TValue;
begin
  Result := TValue.From<Boolean>(Value);
end;

class function TValueExtensions.FromFloat(ATypeInfo: PTypeInfo; AValue: Extended): TValue;
begin
  case GetTypeData(ATypeInfo).FloatType of
    ftSingle:
      Result := TValue.From<Single>(AValue);
    ftDouble:
      Result := TValue.From<Double>(AValue);
    ftExtended:
      Result := TValue.From<Extended>(AValue);
    ftComp:
      Result := TValue.From<Comp>(AValue);
    ftCurr:
      Result := TValue.From<Currency>(AValue);
  end;
end;

class function TValueExtensions.FromString(const Value: string): TValue;
begin
  Result := TValue.From<string>(Value);
end;

class function TValueExtensions.FromVarRec(const Value: TVarRec): TValue;
begin
  case Value.VType of
    vtInteger:
      Result := Value.VInteger;
    vtBoolean:
      Result := Value.VBoolean;
    vtChar:
      Result := string(Value.VChar);
    vtExtended:
      Result := Value.VExtended^;
    vtString:
      Result := string(Value.VString^);
    vtPointer:
      Result := TValue.From<Pointer>(Value.VPointer);
    vtPChar:
      Result := string(Value.VPChar);
    vtObject:
      Result := Value.VObject;
    vtClass:
      Result := Value.VClass;
    vtWideChar:
      Result := string(Value.VWideChar);
    vtPWideChar:
      Result := string(Value.VPWideChar);
    vtAnsiString:
      Result := string(AnsiString(Value.VAnsiString));
    vtCurrency:
      Result := Value.VCurrency^;
    vtVariant:
      Result := TValue.FromVariant(Value.VVariant^);
    vtInterface:
      Result := TValue.From<IInterface>(IInterface(Value.VInterface));
    vtWideString:
      Result := WideString(Value.VWideString);
    vtInt64:
      Result := Value.VInt64^;
    vtUnicodeString:
      Result := string(Value.VUnicodeString);
  end;
end;

class function TValueExtensions.ToString(const Values: array of TValue; Index: Integer): string;
var
  I: Integer;
begin
  Result := string.Empty;
  for I := Index to High(Values) do
  begin
    if I > Index then
      Result := Concat(Result, SComma, SSpace);
    if Values[I].IsString then
      Result := Concat(Result, QuotedStr(TValue.ToString(Values[I])))
    else
      Result := Concat(Result, TValue.ToString(Values[I]));
  end;
end;

function TValueExtensions.TryConvert(ATypeInfo: PTypeInfo; out AResult: TValue): Boolean;
begin
  Result := False;
  if ATypeInfo = System.TypeInfo(TValue) then
  begin
    AResult := Self;
    Exit(True);
  end;
  if Assigned(ATypeInfo) then
  begin
    Result := Conversions[Kind, ATypeInfo.Kind](Self, ATypeInfo, AResult);
    if not Result then
    begin
      case Kind of
        tkRecord:
          Result := ConvNullable2Any(Self, ATypeInfo, AResult);
      end;
      case ATypeInfo.Kind of
        tkRecord:
          Result := ConvAny2Nullable(Self, ATypeInfo, AResult);
      end
    end;
    if not Result then
      Result := TryCast(ATypeInfo, AResult);
  end;
end;

function TValueExtensions.TryConvert<T>(out AResult: TValue): Boolean;
begin
  Result := TryConvert(System.TypeInfo(T), AResult);
end;

{ TCollectionExtensions }

function TCollectionExtensions.FindItemByID(ID: Integer): TCollectionItem;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    Result := Items[I];
    if Result.ID = ID then
      Exit;
  end;
  Result := nil;
end;

initialization

Context := TRttiContext.Create;
Covariances := TDictionary<TPair<PTypeInfo, PTypeInfo>, Boolean>.Create;
Enumerations := TObjectDictionary<PTypeInfo, TStrings>.Create([doOwnsValues]);

finalization

Covariances.DisposeOf;
Enumerations.DisposeOf;
Context.Free;

end.
