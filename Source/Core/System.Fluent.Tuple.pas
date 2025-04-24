{
                          Apache License
                      Version 2.0, January 2004
                   http://www.apache.org/licenses/

       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at

             http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.
}

{
  @abstract(Fluent4D Library - Fluent Data Processing for Delphi)
  @description(A powerful and intuitive library for fluent-style data manipulation in Delphi)
  @created(03 Abr 2025)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @Discord(https://discord.gg/T2zJC8zX)
}

{$include ./../fluent4d.inc}

unit System.Fluent.Tuple;

interface

uses
  Rtti,
  TypInfo,
  SysUtils,
  Generics.Collections,
  Generics.Defaults;

type
  IFluentTupleDict<K> = interface
    ['{73CD7882-7D2C-4842-A828-96CD6ECF417C}']
    function GetDict: TDictionary<K, TValue>;
    function Count: Integer;
    function GetItem(const AKey: K): TValue;
    function TryGetValue(const AKey: K; out AValue: TValue): Boolean;
  end;

  TFluentTupleDict<K> = class(TInterfacedObject, IFluentTupleDict<K>)
  private
    FTupleDict: TDictionary<K, TValue>;
  public
    constructor Create(const ATuples: TArray<TPair<K, TValue>>);
    destructor Destroy; override;
    function GetDict: TDictionary<K, TValue>;
    function Count: Integer;
    function GetItem(const AKey: K): TValue;
    function TryGetValue(const AKey: K; out AValue: TValue): Boolean;
  end;

  TFluentTuple<K> = record
  strict private
    FTupleDict: IFluentTupleDict<K>;
    constructor Create(const ATuples: TArray<TPair<K, TValue>>);
    function GetItem(const AKey: K): TValue;
  public
    class operator Implicit(const P: TFluentTuple<K>): TArray<TPair<K, TValue>>; inline;
    class operator Implicit(const P: TArray<TPair<K, TValue>>): TFluentTuple<K>; inline;
    class operator Equal(const Left, Right: TFluentTuple<K>): Boolean; inline;
    class operator NotEqual(const Left, Right: TFluentTuple<K>): Boolean; inline;
    class function New(const AKeys: TArray<K>;
      const AValues: TArray<TValue>): TFluentTuple<K>; static; inline;
    function Get<T>(const AKey: K): T; inline;
    function TryGet<T>(const AKey: K; out AValue: T): Boolean; inline;
    function Count: Integer; inline;
    function SetTuple(const AKeys: TArray<K>; const AValues: TArray<TValue>): TFluentTuple<K>; inline;
    property Items[const Key: K]: TValue read GetItem; default;
  end;

  TValueArray = array of TValue;

  PFluentTuple = ^TFluentTuple;
  TFluentTuple = record
  strict private
    FTuples: TValueArray;
    constructor Create(const Args: TValueArray);
    function GetItem(const AIndex: Integer): TValue;
  public
    class operator Implicit(const Args: TFluentTuple): TValueArray;
    class operator Implicit(const Args: array of Variant): TFluentTuple;
    class operator Implicit(const Args: TValueArray): TFluentTuple;
    class operator Equal(const Left, Right: TFluentTuple): Boolean; inline;
    class operator NotEqual(const Left, Right: TFluentTuple): Boolean; inline;
    class function New(const AValues: TValueArray): TFluentTuple; static; inline;
    function Get<T>(const AIndex: Integer): T; inline;
    function Count: Integer; inline;
    procedure Dest(const AVarRefs: TArray<Pointer>);
    property Items[const Key: Integer]: TValue read GetItem; default;
  end;

  TTupluString = TFluentTuple<string>;
  TTupluInteger = TFluentTuple<Integer>;
  TTupluInt16 = TFluentTuple<Int16>;
  TTupluInt32 = TFluentTuple<Int32>;
  TTupluInt64 = TFluentTuple<Int64>;
  TTupluDouble = TFluentTuple<Double>;
  TTupluCurrency = TFluentTuple<Currency>;
  TTupluSingle = TFluentTuple<Single>;
  TTupluDate = TFluentTuple<TDate>;
  TTupluTime = TFluentTuple<TTime>;
  TTupluDateTime = TFluentTuple<TDateTime>;
  TTupluChar = TFluentTuple<Char>;
  TTupluVariant = TFluentTuple<Variant>;

implementation

{ TFluentTupleDict<K> }

constructor TFluentTupleDict<K>.Create(const ATuples: TArray<TPair<K, TValue>>);
var
  LFor: Integer;
begin
  FTupleDict := TDictionary<K, TValue>.Create;
  for LFor := 0 to High(ATuples) do
    FTupleDict.Add(ATuples[LFor].Key, ATuples[LFor].Value);
end;

destructor TFluentTupleDict<K>.Destroy;
begin
  FTupleDict.Free;
  inherited;
end;

function TFluentTupleDict<K>.GetDict: TDictionary<K, TValue>;
begin
  Result := FTupleDict;
end;

function TFluentTupleDict<K>.Count: Integer;
begin
  Result := FTupleDict.Count;
end;

function TFluentTupleDict<K>.GetItem(const AKey: K): TValue;
begin
  Result := FTupleDict[AKey];
end;

function TFluentTupleDict<K>.TryGetValue(const AKey: K; out AValue: TValue): Boolean;
begin
  Result := FTupleDict.TryGetValue(AKey, AValue);
end;

{ TFluentTuple<K> }

function TFluentTuple<K>.Count: Integer;
begin
  Result := FTupleDict.Count;
end;

constructor TFluentTuple<K>.Create(const ATuples: TArray<TPair<K, TValue>>);
begin
  FTupleDict := TFluentTupleDict<K>.Create(ATuples);
end;

class operator TFluentTuple<K>.Equal(const Left, Right: TFluentTuple<K>): Boolean;
var
  LComp1: IEqualityComparer<K>;
  LComp2: IEqualityComparer<TValue>;
  LPair: TPair<K, TValue>;
begin
  Result := False;
  if Left.FTupleDict.Count <> Right.FTupleDict.Count then
    Exit;
  LComp1 := TEqualityComparer<K>.Default;
  LComp2 := TEqualityComparer<TValue>.Default;
  for LPair in Left.FTupleDict.GetDict do
  begin
    if not Right.FTupleDict.GetDict.ContainsKey(LPair.Key) then
      Exit;
    if not LComp2.Equals(LPair.Value, Right.FTupleDict.GetDict[LPair.Key]) then
      Exit;
  end;
  Result := True;
end;

function TFluentTuple<K>.SetTuple(const AKeys: TArray<K>;
  const AValues: TArray<TValue>): TFluentTuple<K>;
begin
  Result := TFluentTuple<K>.New(AKeys, AValues);
end;

function TFluentTuple<K>.Get<T>(const AKey: K): T;
begin
  Result := FTupleDict.GetItem(AKey).AsType<T>;
end;

function TFluentTuple<K>.TryGet<T>(const AKey: K; out AValue: T): Boolean;
var
  LValue: TValue;
begin
  Result := FTupleDict.TryGetValue(AKey, LValue);
  if Result then
    AValue := LValue.AsType<T>
  else
    AValue := Default(T);
end;

function TFluentTuple<K>.GetItem(const AKey: K): TValue;
begin
  Result := FTupleDict.GetItem(AKey);
end;

class operator TFluentTuple<K>.Implicit(const P: TArray<TPair<K, TValue>>): TFluentTuple<K>;
begin
  Result := TFluentTuple<K>.Create(P);
end;

class operator TFluentTuple<K>.Implicit(const P: TFluentTuple<K>): TArray<TPair<K, TValue>>;
var
  LPair: TPair<K, TValue>;
  LFor: Integer;
begin
  SetLength(Result, P.FTupleDict.Count);
  LFor := 0;
  for LPair in P.FTupleDict.GetDict do
  begin
    Result[LFor] := LPair;
    Inc(LFor);
  end;
end;

class function TFluentTuple<K>.New(const AKeys: TArray<K>;
  const AValues: TArray<TValue>): TFluentTuple<K>;
var
  LPairs: TArray<TPair<K, TValue>>;
  LFor: Integer;
begin
  if Length(AKeys) <> Length(AValues) then
    raise Exception.Create('Number of keys and values must match');

  SetLength(LPairs, Length(AKeys));
  for LFor := 0 to High(AKeys) do
    LPairs[LFor] := TPair<K, TValue>.Create(AKeys[LFor], AValues[LFor]);
  Result := TFluentTuple<K>.Create(LPairs);
end;

class operator TFluentTuple<K>.NotEqual(const Left, Right: TFluentTuple<K>): Boolean;
begin
  Result := not (Left = Right);
end;

{ TFluentTuple }

function TFluentTuple.Count: Integer;
begin
  Result := Length(FTuples);
end;

constructor TFluentTuple.Create(const Args: TValueArray);
var
  LFor: Integer;
begin
  SetLength(FTuples, Length(Args));
  for LFor := Low(Args) to High(Args) do
    FTuples[LFor] := Args[LFor];
end;

class operator TFluentTuple.Equal(const Left, Right: TFluentTuple): Boolean;
var
  LFor: Integer;
begin
  Result := False;
  if Length(Left.FTuples) <> Length(Right.FTuples) then
    Exit;
  for LFor := 0 to High(Left.FTuples) do
  begin
    if Left.FTuples[LFor].Kind <> Right.FTuples[LFor].Kind then
      Exit;
    if Left.FTuples[LFor].ToString <> Right.FTuples[LFor].ToString then
      Exit;
  end;
  Result := True;
end;

function TFluentTuple.Get<T>(const AIndex: Integer): T;
begin
  Result := FTuples[AIndex].AsType<T>;
end;

function TFluentTuple.GetItem(const AIndex: Integer): TValue;
begin
  Result := FTuples[AIndex];
end;

procedure TFluentTuple.Dest(const AVarRefs: TArray<Pointer>);
var
  LFor: Integer;
  LTypeInfo: PTypeInfo;
begin
  if Length(AVarRefs) <> Length(FTuples) then
    raise Exception.Create('Number of pointers (' + IntToStr(Length(AVarRefs)) +
      ') must match tuple length (' + IntToStr(Length(FTuples)) + ')');

  for LFor := Low(AVarRefs) to High(AVarRefs) do
  begin
    case FTuples[LFor].Kind of
      tkInt64:
        PInt64(AVarRefs[LFor])^ := FTuples[LFor].AsInt64;
      tkInteger, tkSet:
        PInteger(AVarRefs[LFor])^ := FTuples[LFor].AsInteger;
      tkFloat:
        PDouble(AVarRefs[LFor])^ := FTuples[LFor].AsExtended;
      tkUString, tkLString, tkWString, tkString, tkChar, tkWChar:
        PUnicodeString(AVarRefs[LFor])^ := FTuples[LFor].AsString;
      tkClass:
        PObject(AVarRefs[LFor])^ := FTuples[LFor].AsObject;
      tkEnumeration:
        PBoolean(AVarRefs[LFor])^ := FTuples[LFor].AsBoolean;
      tkRecord, tkVariant:
        PVariant(AVarRefs[LFor])^ := FTuples[LFor].AsVariant;
      tkArray, tkDynArray:
      begin
        LTypeInfo := FTuples[LFor].TypeInfo;
        case GetTypeData(LTypeInfo).elType2^.Kind of
          tkInt64:
            TArray<Int64>(AVarRefs[LFor]) := FTuples[LFor].AsType<TArray<Int64>>;
          tkInteger, tkSet:
            TArray<Integer>(AVarRefs[LFor]) := FTuples[LFor].AsType<TArray<Integer>>;
          tkFloat:
            TArray<Extended>(AVarRefs[LFor]) := FTuples[LFor].AsType<TArray<Extended>>;
          tkUString, tkLString, tkWString, tkString, tkChar, tkWChar:
            TArray<String>(AVarRefs[LFor]) := FTuples[LFor].AsType<TArray<String>>;
          tkClass:
            TArray<TObject>(AVarRefs[LFor]) := FTuples[LFor].AsType<TArray<TObject>>;
          tkEnumeration:
            TArray<Boolean>(AVarRefs[LFor]) := FTuples[LFor].AsType<TArray<Boolean>>;
          tkRecord, tkVariant:
            TArray<Variant>(AVarRefs[LFor]) := FTuples[LFor].AsType<TArray<Variant>>;
          else
            raise Exception.Create('Unsupported array element type at index ' + IntToStr(LFor));
        end;
      end;
      else
        raise Exception.Create('Unsupported type at index ' + IntToStr(LFor));
    end;
  end;
end;

class operator TFluentTuple.Implicit(const Args: TFluentTuple): TValueArray;
begin
  Result := Args.FTuples;
end;

class operator TFluentTuple.Implicit(const Args: array of Variant): TFluentTuple;
var
  LFor: Integer;
begin
  SetLength(Result.FTuples, Length(Args));
  for LFor := Low(Args) to High(Args) do
    Result.FTuples[LFor] := TValue.FromVariant(Args[LFor]);
end;

class operator TFluentTuple.Implicit(const Args: TValueArray): TFluentTuple;
begin
  Result := TFluentTuple.Create(Args);
end;

class function TFluentTuple.New(const AValues: TValueArray): TFluentTuple;
begin
  Result := TFluentTuple.Create(AValues);
end;

class operator TFluentTuple.NotEqual(const Left, Right: TFluentTuple): Boolean;
begin
  Result := not (Left = Right);
end;

end.

