{
           Fluent4D - Fluent Data Processing Library for Delphi

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
  @created(03 Abr 2025)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @Discord(https://discord.gg/T2zJC8zX)
}

unit Fluent.Core;

interface

uses
  Classes,
  SysUtils,
  Generics.Collections,
  Generics.Defaults;

type
  TFluentType = (ftNone, ftList, ftDictionary);

  TAction<T> = reference to procedure(const AArg: T);

  IGroupedEnumerator<TKey, T> = interface;
  IFluentWrapper<TResult> = interface;

  IFluentEnumerator<T> = interface(IInterface)
    ['{E2DEBD49-1094-41A5-A817-48FB81A6F6F2}']
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  IFluentEnumerableBase<T> = interface(IInterface)
    ['{B68572C5-32C6-436A-B39B-D8DA06E33C14}']
    function GetEnumerator: IFluentEnumerator<T>;
  end;

  IFluentQueryableBase<T> = interface(IInterface)
    ['{5E8E37CE-6372-4FBB-872B-9687A24F63DD}']
    function GetEnumerator: IFluentEnumerator<T>;
    function BuildQuery: string;
  end;

  TFluentEnumerableBase<T> = class abstract(TInterfacedObject, IFluentEnumerableBase<T>)
  protected
    function GetEnumerator: IFluentEnumerator<T>; virtual; abstract;
  end;

  TFluentQueryableBase<T> = class abstract(TInterfacedObject, IFluentQueryableBase<T>)
  protected
    function GetEnumerator: IFluentEnumerator<T>; virtual; abstract;
    function BuildQuery: string;
  end;

  IFluentEnumerable<T> = record
  private
    FEnumerator: IFluentEnumerableBase<T>;
    FFluentType: TFluentType;
    FComparer: IEqualityComparer<T>;
    type
      TFluentCompare = class
      public
        class function Compare(const AEnumerator: IFluentEnumerableBase<T>;
          const AValue: T; const AComparer: IEqualityComparer<T>): Boolean; static;
      end;
  public
    constructor Create(const AEnumerator: IFluentEnumerableBase<T>;
      const AFluentType: TFluentType = ftNone; const AComparer: IEqualityComparer<T> = nil);
    procedure ForEach(const AAction: TAction<T>);
    function GetEnumerator: IFluentEnumerator<T>;
    function Filter(const APredicate: TFunc<T, Boolean>): IFluentEnumerable<T>;
    function Take(const ACount: Integer): IFluentEnumerable<T>;
    function Skip(const ACount: Integer): IFluentEnumerable<T>;
    function OrderBy(const AComparer: TFunc<T, T, Integer>): IFluentEnumerable<T>;
    function OrderByDesc(const AComparer: TFunc<T, T, Integer>): IFluentEnumerable<T>;
    function Distinct: IFluentEnumerable<T>;
    function DistinctBy<TKey>(const AKeySelector: TFunc<T, TKey>): IFluentEnumerable<T>;
    function Map<TResult>(const ASelector: TFunc<T, TResult>): IFluentEnumerable<TResult>;
    function FlatMap<TResult>(const ASelector: TFunc<T, TArray<TResult>>): IFluentEnumerable<TResult>;
    function Reduce(const AReducer: TFunc<T, T, T>; const AInitialValue: T): T; overload;
    function Reduce(const AReducer: TFunc<T, T, T>): T; overload;
    function Reduce<TAcc>(const AInitialValue: TAcc; const AAccumulator: TFunc<TAcc, T, TAcc>): TAcc; overload;
    function ReduceRight(const AReducer: TFunc<T, T, T>; const AInitialValue: T): T; overload;
    function ReduceRight(const AReducer: TFunc<T, T, T>): T; overload;
    function Cycle(const ACount: Integer = -1): IFluentEnumerable<T>;
    function Sum(const ASelector: TFunc<T, Double>): Double; overload;
    function Sum(const ASelector: TFunc<T, Integer>): Integer; overload;
    function Average(const ASelector: TFunc<T, Double>): Double;
    function Min(const AComparer: TFunc<T, T, Integer>): T; overload;
    function Min: T; overload;
    function Max(const AComparer: TFunc<T, T, Integer>): T; overload;
    function Max: T; overload;
    function Any(const APredicate: TFunc<T, Boolean>): Boolean;
    function All(const APredicate: TFunc<T, Boolean>): Boolean;
    function Contains(const AValue: T): Boolean;
    function FirstOrDefault(const APredicate: TFunc<T, Boolean>): T;
    function First(const APredicate: TFunc<T, Boolean> = nil): T;
    function Last(const APredicate: TFunc<T, Boolean>): T;
    function LastOrDefault(const APredicate: TFunc<T, Boolean>): T;
    function Count(const APredicate: TFunc<T, Boolean>): Integer;
    function LongCount(const APredicate: TFunc<T, Boolean>): Int64;
    function TakeWhile(const APredicate: TFunc<T, Boolean>): IFluentEnumerable<T>;
    function SkipWhile(const APredicate: TFunc<T, Boolean>): IFluentEnumerable<T>;
    function ToArray: TArray<T>;
    function ToList: TList<T>;
    function ToDictionary<TKey, TValue>(const AKeySelector: TFunc<T, TKey>;
      const AValueSelector: TFunc<T, TValue>): TDictionary<TKey, TValue>;
    function GroupBy<TKey>(const AKeySelector: TFunc<T, TKey>): IGroupedEnumerator<TKey, T>;
    function Zip<TSecond, TResult>(const ASecond: IFluentEnumerable<TSecond>;
      const AResultSelector: TFunc<T, TSecond, TResult>): IFluentEnumerable<TResult>;
    function Join<TInner, TKey, TResult>(const AInner: IFluentEnumerable<TInner>;
      const AOuterKeySelector: TFunc<T, TKey>; const AInnerKeySelector: TFunc<TInner, TKey>;
      const AResultSelector: TFunc<T, TInner, TResult>): IFluentEnumerable<TResult>;
    function OfType<TResult>(const AIsType: TFunc<T, Boolean>; const AConverter: TFunc<T, TResult>): IFluentEnumerable<TResult>;
    function MinBy<TKey>(const AKeySelector: TFunc<T, TKey>;
      const AComparer: TFunc<TKey, TKey, Integer>): T;
    function MaxBy<TKey>(const AKeySelector: TFunc<T, TKey>;
      const AComparer: TFunc<TKey, TKey, Integer>): T;
    function Tee(const ACount: Integer): IFluentEnumerable<T>;
    function SelectMany<TResult>(const ASelector: TFunc<T, IFluentWrapper<TResult>>): IFluentEnumerable<TResult>;
    function GroupJoin<TInner, TKey, TResult>(const AInner: IFluentEnumerable<TInner>;
      const AOuterKeySelector: TFunc<T, TKey>; const AInnerKeySelector: TFunc<TInner, TKey>;
      const AResultSelector: TFunc<T, IFluentWrapper<TInner>, TResult>): IFluentEnumerable<TResult>;
    function Exclude(const ASecond: IFluentEnumerable<T>): IFluentEnumerable<T>;
    function Intersect(const ASecond: IFluentEnumerable<T>): IFluentEnumerable<T>;
    function Union(const ASecond: IFluentEnumerable<T>): IFluentEnumerable<T>;
    function Concat(const ASecond: IFluentEnumerable<T>): IFluentEnumerable<T>;
    function SequenceEqual(const ASecond: IFluentEnumerable<T>): Boolean;
    function Single(const APredicate: TFunc<T, Boolean>): T;
    function SingleOrDefault(const APredicate: TFunc<T, Boolean>): T;
    function ElementAt(const AIndex: Integer): T;
    function ElementAtOrDefault(const AIndex: Integer): T;
  end;

  IFluentQueryable<T> = record
  private
    FQueryable: IFluentQueryableBase<T>;
  public
    constructor Create(AQueryable: IFluentQueryableBase<T>);
    function GetEnumerator: IFluentEnumerator<T>;
  end;

  IFluentWrapper<TResult> = interface(IInterface)
    ['{DDB79C8C-52AC-4542-877F-EFE1874882E9}']
    function Value: IFluentEnumerable<TResult>;
  end;

  TFluentWrapper<TResult> = class(TInterfacedObject, IFluentWrapper<TResult>)
  private
    FValue: IFluentEnumerable<TResult>;
    FList: TObject;
  public
    constructor Create(const AValue: IFluentEnumerable<TResult>; const AList: TObject);
    destructor Destroy; override;
    function Value: IFluentEnumerable<TResult>;
  end;

  IGrouping<TKey, T> = interface(IInterface)
    ['{87B4E3F7-C092-44D1-B682-0B03C0202BF0}']
    function GetKey: TKey;
    function GetItems: IFluentEnumerable<T>;
    property Key: TKey read GetKey;
    property Items: IFluentEnumerable<T> read GetItems;
  end;

  IGroupedEnumerator<TKey, T> = interface(IInterface)
    ['{A85DB3F6-E808-4E81-B386-75190087507B}']
    function GetEnumerator: IFluentEnumerator<IGrouping<TKey, T>>;
    function AsEnumerable: IFluentEnumerable<IGrouping<TKey, T>>;
  end;

implementation

uses
  Fluent.Lazy,
  Fluent.Adapters;

{ IFluentEnumerable<T> }

constructor IFluentEnumerable<T>.Create(const AEnumerator: IFluentEnumerableBase<T>;
      const AFluentType: TFluentType; const AComparer: IEqualityComparer<T>);
begin
  FEnumerator := AEnumerator;
  FFluentType := AFluentType;
  FComparer := AComparer;
  if FComparer = nil then
    FComparer := TEqualityComparer<T>.Default;
end;

procedure IFluentEnumerable<T>.ForEach(const AAction: TAction<T>);
var
  LEnum: IFluentEnumerator<T>;
begin
  LEnum := GetEnumerator;
  while LEnum.MoveNext do
    AAction(LEnum.Current);
end;

function IFluentEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := FEnumerator.GetEnumerator;
end;

function IFluentEnumerable<T>.Filter(const APredicate: TFunc<T, Boolean>): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentFilterEnumerable<T>.Create(FEnumerator, APredicate),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.Take(const ACount: Integer): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentTakeEnumerable<T>.Create(FEnumerator, ACount),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.Skip(const ACount: Integer): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentSkipEnumerable<T>.Create(FEnumerator, ACount),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.OrderBy(const AComparer: TFunc<T, T, Integer>): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentOrderByEnumerable<T>.Create(FEnumerator, AComparer),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.OrderByDesc(const AComparer: TFunc<T, T, Integer>): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentOrderByEnumerable<T>.Create(FEnumerator,
      function(A, B: T): Integer begin Result := -AComparer(A, B); end),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.Distinct: IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentDistinctEnumerable<T>.Create(FEnumerator),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.DistinctBy<TKey>(const AKeySelector: TFunc<T, TKey>): IFluentEnumerable<T>;
var
  LSeenKeys: TDictionary<TKey, T>;
  LEnum: IFluentEnumerator<T>;
  LItems: TArray<T>;
  LItem: T;
  LIndex: Integer;
begin
  LSeenKeys := TDictionary<TKey, T>.Create;
  try
    LEnum := GetEnumerator;
    SetLength(LItems, 0);
    LIndex := 0;
    while LEnum.MoveNext do
    begin
      LItem := LEnum.Current;
      if not LSeenKeys.ContainsKey(AKeySelector(LItem)) then
      begin
        LSeenKeys.Add(AKeySelector(LItem), LItem);
        SetLength(LItems, LIndex + 1);
        LItems[LIndex] := LItem;
        Inc(LIndex);
      end;
    end;
    Result := IFluentEnumerable<T>.Create(
      TArrayAdapter<T>.Create(LItems),
      FFluentType,
      FComparer
    );
  finally
    LSeenKeys.Free;
  end;
end;

function IFluentEnumerable<T>.Map<TResult>(const ASelector: TFunc<T, TResult>): IFluentEnumerable<TResult>;
begin
  Result := IFluentEnumerable<TResult>.Create(
    TFluentMapEnumerable<T, TResult>.Create(FEnumerator, ASelector),
    FFluentType
    // FComparer não é propagado porque o tipo muda pra TResult
  );
end;

function IFluentEnumerable<T>.FlatMap<TResult>(const ASelector: TFunc<T, TArray<TResult>>): IFluentEnumerable<TResult>;
begin
  Result := IFluentEnumerable<TResult>.Create(
    TFluentFlatMapEnumerable<T, TResult>.Create(FEnumerator, ASelector),
    FFluentType
    // FComparer não é propagado porque o tipo muda pra TResult
  );
end;

function IFluentEnumerable<T>.Reduce(const AReducer: TFunc<T, T, T>;
  const AInitialValue: T): T;
var
  LEnum: IFluentEnumerator<T>;
begin
  Result := AInitialValue;
  LEnum := GetEnumerator;
  while LEnum.MoveNext do
    Result := AReducer(Result, LEnum.Current);
end;

function IFluentEnumerable<T>.Reduce(const AReducer: TFunc<T, T, T>): T;
var
  LEnum: IFluentEnumerator<T>;
  LResult: T;
  LHasValue: Boolean;
begin
  LResult := Default(T);
  LEnum := GetEnumerator;
  LHasValue := False;
  while LEnum.MoveNext do
  begin
    if not LHasValue then
    begin
      LResult := LEnum.Current;
      LHasValue := True;
    end
    else
      LResult := AReducer(LResult, LEnum.Current);
  end;
  if not LHasValue then
    raise EInvalidOperation.Create('Sequence contains no elements');
  Result := LResult;
end;

function IFluentEnumerable<T>.Reduce<TAcc>(const AInitialValue: TAcc;
  const AAccumulator: TFunc<TAcc, T, TAcc>): TAcc;
var
  LEnum: IFluentEnumerator<T>;
  LResult: TAcc;
begin
  LEnum := GetEnumerator;
  LResult := AInitialValue;
  while LEnum.MoveNext do
    LResult := AAccumulator(LResult, LEnum.Current);
  Result := LResult;
end;

function IFluentEnumerable<T>.ReduceRight(const AReducer: TFunc<T, T, T>; const AInitialValue: T): T;
var
  LList: TList<T>;
  LFor: Integer;
  LResult: T;
begin
  LList := ToList;
  try
    LResult := AInitialValue;
    for LFor := LList.Count - 1 downto 0 do
      LResult := AReducer(LList[LFor], LResult);
    Result := LResult;
  finally
    LList.Free;
  end;
end;

function IFluentEnumerable<T>.ReduceRight(const AReducer: TFunc<T, T, T>): T;
var
  LList: TList<T>;
  LFor: Integer;
  LResult: T;
begin
  LList := ToList;
  try
    if LList.Count = 0 then
      raise EInvalidOperation.Create('Sequence contains no elements');
    LResult := LList[LList.Count - 1];
    for LFor := LList.Count - 2 downto 0 do
      LResult := AReducer(LList[LFor], LResult);
    Result := LResult;
  finally
    LList.Free;
  end;
end;

function IFluentEnumerable<T>.Cycle(const ACount: Integer): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentCycleEnumerable<T>.Create(FEnumerator, ACount),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.Sum(const ASelector: TFunc<T, Double>): Double;
var
  LEnum: IFluentEnumerator<T>;
  LSum: Double;
begin
  LEnum := GetEnumerator;
  LSum := 0;
  while LEnum.MoveNext do
    LSum := LSum + ASelector(LEnum.Current);
  Result := LSum;
end;

function IFluentEnumerable<T>.Sum(const ASelector: TFunc<T, Integer>): Integer;
var
  LEnum: IFluentEnumerator<T>;
  LSum: Integer;
begin
  LEnum := GetEnumerator;
  LSum := 0;
  while LEnum.MoveNext do
    LSum := LSum + ASelector(LEnum.Current);
  Result := LSum;
end;

function IFluentEnumerable<T>.Average(const ASelector: TFunc<T, Double>): Double;
var
  LEnum: IFluentEnumerator<T>;
  LSum: Double;
  LCount: Integer;
begin
  LEnum := GetEnumerator;
  LSum := 0;
  LCount := 0;
  while LEnum.MoveNext do
  begin
    LSum := LSum + ASelector(LEnum.Current);
    Inc(LCount);
  end;
  if LCount = 0 then
    raise EInvalidOperation.Create('Sequence contains no elements');
  Result := LSum / LCount;
end;

function IFluentEnumerable<T>.Min(const AComparer: TFunc<T, T, Integer>): T;
var
  LEnum: IFluentEnumerator<T>;
  LResult: T;
  LHasValue: Boolean;
begin
  LResult := Default(T);
  LEnum := GetEnumerator;
  LHasValue := False;
  while LEnum.MoveNext do
  begin
    if not LHasValue then
    begin
      LResult := LEnum.Current;
      LHasValue := True;
    end
    else if AComparer(LEnum.Current, LResult) < 0 then
      LResult := LEnum.Current;
  end;
  if not LHasValue then
    raise EInvalidOperation.Create('Sequence contains no elements');
  Result := LResult;
end;

function IFluentEnumerable<T>.Min: T;
var
  LComparer: TFunc<T, T, Integer>;
begin
  LComparer := function(A, B: T): Integer begin Result := TComparer<T>.Default.Compare(A, B); end;
  Result := Min(LComparer);
end;

function IFluentEnumerable<T>.Max(const AComparer: TFunc<T, T, Integer>): T;
var
  LEnum: IFluentEnumerator<T>;
  LResult: T;
  LHasValue: Boolean;
begin
  LResult := Default(T);
  LEnum := GetEnumerator;
  LHasValue := False;
  while LEnum.MoveNext do
  begin
    if not LHasValue then
    begin
      LResult := LEnum.Current;
      LHasValue := True;
    end
    else if AComparer(LEnum.Current, LResult) > 0 then
      LResult := LEnum.Current;
  end;
  if not LHasValue then
    raise EInvalidOperation.Create('Sequence contains no elements');
  Result := LResult;
end;

function IFluentEnumerable<T>.Max: T;
var
  LComparer: TFunc<T, T, Integer>;
begin
  LComparer := function(A, B: T): Integer begin Result := TComparer<T>.Default.Compare(A, B); end;
  Result := Max(LComparer);
end;

function IFluentEnumerable<T>.Any(const APredicate: TFunc<T, Boolean>): Boolean;
var
  LEnum: IFluentEnumerator<T>;
begin
  LEnum := GetEnumerator;
  while LEnum.MoveNext do
    if APredicate(LEnum.Current) then
      Exit(True);
  Result := False;
end;

function IFluentEnumerable<T>.All(const APredicate: TFunc<T, Boolean>): Boolean;
var
  LEnum: IFluentEnumerator<T>;
begin
  LEnum := GetEnumerator;
  while LEnum.MoveNext do
    if not APredicate(LEnum.Current) then
      Exit(False);
  Result := True;
end;

function IFluentEnumerable<T>.Contains(const AValue: T): Boolean;
begin
  Result := TFluentCompare.Compare(FEnumerator, AValue, FComparer);
end;

function IFluentEnumerable<T>.First(const APredicate: TFunc<T, Boolean> = nil): T;
var
  LEnum: IFluentEnumerator<T>;
  LItem: T;
  LFound: Boolean;
begin
  LItem := Default(T);
  LEnum := GetEnumerator;
  LFound := False;
  while LEnum.MoveNext do
  begin
    LItem := LEnum.Current;
    if not Assigned(APredicate) or APredicate(LItem) then
    begin
      LFound := True;
      Break;
    end;
  end;
  if LFound then
    Result := LItem
  else
    raise Exception.Create('Nenhum elemento encontrado');
end;

function IFluentEnumerable<T>.FirstOrDefault(const APredicate: TFunc<T, Boolean>): T;
var
  LEnum: IFluentEnumerator<T>;
begin
  LEnum := GetEnumerator;
  while LEnum.MoveNext do
    if APredicate(LEnum.Current) then
      Exit(LEnum.Current);
  Result := Default(T);
end;

function IFluentEnumerable<T>.Last(const APredicate: TFunc<T, Boolean>): T;
var
  LEnum: IFluentEnumerator<T>;
  LResult: T;
  LHasValue: Boolean;
begin
  LResult := Default(T);
  LEnum := GetEnumerator;
  LHasValue := False;
  while LEnum.MoveNext do
    if APredicate(LEnum.Current) then
    begin
      LResult := LEnum.Current;
      LHasValue := True;
    end;
  if not LHasValue then
    raise EInvalidOperation.Create('Sequence contains no matching element');
  Result := LResult;
end;

function IFluentEnumerable<T>.LastOrDefault(const APredicate: TFunc<T, Boolean>): T;
var
  LEnum: IFluentEnumerator<T>;
  LResult: T;
  LHasValue: Boolean;
begin
  LResult := Default(T);
  LEnum := GetEnumerator;
  LHasValue := False;
  while LEnum.MoveNext do
    if APredicate(LEnum.Current) then
    begin
      LResult := LEnum.Current;
      LHasValue := True;
    end;
  if not LHasValue then
    Result := Default(T)
  else
    Result := LResult;
end;

function IFluentEnumerable<T>.Count(const APredicate: TFunc<T, Boolean>): Integer;
var
  LEnum: IFluentEnumerator<T>;
  LCount: Integer;
begin
  LEnum := GetEnumerator;
  LCount := 0;
  while LEnum.MoveNext do
    if APredicate(LEnum.Current) then
      Inc(LCount);
  Result := LCount;
end;

function IFluentEnumerable<T>.LongCount(const APredicate: TFunc<T, Boolean>): Int64;
var
  LEnum: IFluentEnumerator<T>;
  LCount: Int64;
begin
  LEnum := GetEnumerator;
  LCount := 0;
  while LEnum.MoveNext do
    if APredicate(LEnum.Current) then
      Inc(LCount);
  Result := LCount;
end;

function IFluentEnumerable<T>.TakeWhile(const APredicate: TFunc<T, Boolean>): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentTakeWhileEnumerable<T>.Create(FEnumerator, APredicate),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.Tee(const ACount: Integer): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentTeeEnumerable<T>.Create(FEnumerator, ACount),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.SkipWhile(const APredicate: TFunc<T, Boolean>): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentSkipWhileEnumerable<T>.Create(FEnumerator, APredicate),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.ToArray: TArray<T>;
var
  LEnum: IFluentEnumerator<T>;
  LList: TList<T>;
begin
  LList := TList<T>.Create;
  try
    LEnum := GetEnumerator;
    while LEnum.MoveNext do
      LList.Add(LEnum.Current);
    Result := LList.ToArray;
  finally
    LList.Free;
  end;
end;

function IFluentEnumerable<T>.ToList: TList<T>;
var
  LList: TList<T>;
  LEnum: IFluentEnumerator<T>;
begin
  LList := TList<T>.Create;
  LEnum := GetEnumerator;
  while LEnum.MoveNext do
    LList.Add(LEnum.Current);
  Result := LList;
end;

function IFluentEnumerable<T>.ToDictionary<TKey, TValue>(const AKeySelector: TFunc<T, TKey>;
  const AValueSelector: TFunc<T, TValue>): TDictionary<TKey, TValue>;
var
  LEnum: IFluentEnumerator<T>;
  LDict: TDictionary<TKey, TValue>;
begin
  LDict := TDictionary<TKey, TValue>.Create;
  try
    LEnum := GetEnumerator;
    while LEnum.MoveNext do
      LDict.Add(AKeySelector(LEnum.Current), AValueSelector(LEnum.Current));
    Result := LDict;
  except
    LDict.Free;
    raise;
  end;
end;

function IFluentEnumerable<T>.GroupBy<TKey>(const AKeySelector: TFunc<T, TKey>): IGroupedEnumerator<TKey, T>;
begin
  Result := TFluentGroupByEnumerable<TKey, T>.Create(FEnumerator, AKeySelector);
end;

function IFluentEnumerable<T>.GroupJoin<TInner, TKey, TResult>(const AInner: IFluentEnumerable<TInner>;
  const AOuterKeySelector: TFunc<T, TKey>; const AInnerKeySelector: TFunc<TInner, TKey>;
  const AResultSelector: TFunc<T, IFluentWrapper<TInner>, TResult>): IFluentEnumerable<TResult>;
begin
  Result := IFluentEnumerable<TResult>.Create(
    TFluentGroupJoinEnumerable<T, TInner, TKey, TResult>.Create(
      FEnumerator, AInner.FEnumerator, AOuterKeySelector, AInnerKeySelector, AResultSelector),
    FFluentType
    // FComparer não é propagado porque o tipo muda pra TResult
  );
end;

function IFluentEnumerable<T>.Zip<TSecond, TResult>(const ASecond: IFluentEnumerable<TSecond>;
  const AResultSelector: TFunc<T, TSecond, TResult>): IFluentEnumerable<TResult>;
begin
  Result := IFluentEnumerable<TResult>.Create(
    TFluentZipEnumerable<T, TSecond, TResult>.Create(FEnumerator, ASecond.FEnumerator, AResultSelector),
    FFluentType
    // FComparer não é propagado porque o tipo muda pra TResult
  );
end;

function IFluentEnumerable<T>.Join<TInner, TKey, TResult>(const AInner: IFluentEnumerable<TInner>;
  const AOuterKeySelector: TFunc<T, TKey>; const AInnerKeySelector: TFunc<TInner, TKey>;
  const AResultSelector: TFunc<T, TInner, TResult>): IFluentEnumerable<TResult>;
begin
  Result := IFluentEnumerable<TResult>.Create(
    TFluentJoinEnumerable<T, TInner, TKey, TResult>.Create(FEnumerator, AInner.FEnumerator, AOuterKeySelector, AInnerKeySelector, AResultSelector),
    FFluentType
    // FComparer não é propagado porque o tipo muda pra TResult
  );
end;

function IFluentEnumerable<T>.OfType<TResult>(const AIsType: TFunc<T, Boolean>;
  const AConverter: TFunc<T, TResult>): IFluentEnumerable<TResult>;
begin
  Result := IFluentEnumerable<TResult>.Create(
    TFluentOfTypeEnumerable<T, TResult>.Create(FEnumerator, AIsType, AConverter),
    FFluentType
    // FComparer não é propagado porque o tipo muda pra TResult
  );
end;

function IFluentEnumerable<T>.MinBy<TKey>(const AKeySelector: TFunc<T, TKey>;
  const AComparer: TFunc<TKey, TKey, Integer>): T;
var
  LEnum: IFluentEnumerator<T>;
  LResult: T;
  LMinKey: TKey;
  LKey: TKey;
  LHasValue: Boolean;
begin
  LResult := Default(T);
  LMinKey := Default(TKey);
  LEnum := GetEnumerator;
  LHasValue := False;
  while LEnum.MoveNext do
  begin
    if not LHasValue then
    begin
      LResult := LEnum.Current;
      LMinKey := AKeySelector(LResult);
      LHasValue := True;
    end
    else
    begin
      LKey := AKeySelector(LEnum.Current);
      if AComparer(LKey, LMinKey) < 0 then
      begin
        LMinKey := LKey;
        LResult := LEnum.Current;
      end;
    end;
  end;
  if not LHasValue then
    raise EInvalidOperation.Create('Sequence contains no elements');
  Result := LResult;
end;

function IFluentEnumerable<T>.MaxBy<TKey>(const AKeySelector: TFunc<T, TKey>;
  const AComparer: TFunc<TKey, TKey, Integer>): T;
var
  LEnum: IFluentEnumerator<T>;
  LResult: T;
  LMaxKey: TKey;
  LKey: TKey;
  LHasValue: Boolean;
begin
  LResult := Default(T);
  LMaxKey := Default(TKey);
  LEnum := GetEnumerator;
  LHasValue := False;
  while LEnum.MoveNext do
  begin
    if not LHasValue then
    begin
      LResult := LEnum.Current;
      LMaxKey := AKeySelector(LResult);
      LHasValue := True;
    end
    else
    begin
      LKey := AKeySelector(LEnum.Current);
      if AComparer(LKey, LMaxKey) > 0 then
      begin
        LMaxKey := LKey;
        LResult := LEnum.Current;
      end;
    end;
  end;
  if not LHasValue then
    raise EInvalidOperation.Create('Sequence contains no elements');
  Result := LResult;
end;

function IFluentEnumerable<T>.Exclude(const ASecond: IFluentEnumerable<T>): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentExcludeEnumerable<T>.Create(FEnumerator, ASecond.FEnumerator, FComparer),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.Intersect(const ASecond: IFluentEnumerable<T>): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentIntersectEnumerable<T>.Create(FEnumerator, ASecond.FEnumerator, FComparer),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.Union(const ASecond: IFluentEnumerable<T>): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentUnionEnumerable<T>.Create(FEnumerator, ASecond.FEnumerator, FComparer),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.Concat(const ASecond: IFluentEnumerable<T>): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TFluentConcatEnumerable<T>.Create(FEnumerator, ASecond.FEnumerator),
    FFluentType,
    FComparer
  );
end;

function IFluentEnumerable<T>.SelectMany<TResult>(const ASelector: TFunc<T, IFluentWrapper<TResult>>): IFluentEnumerable<TResult>;
begin
  Result := IFluentEnumerable<TResult>.Create(
    TFluentSelectManyEnumerable<T, TResult>.Create(FEnumerator, ASelector),
    FFluentType
    // FComparer não é propagado porque o tipo muda pra TResult
  );
end;

function IFluentEnumerable<T>.SequenceEqual(const ASecond: IFluentEnumerable<T>): Boolean;
var
  LEnum1, LEnum2: IFluentEnumerator<T>;
begin
  LEnum1 := GetEnumerator;
  LEnum2 := ASecond.GetEnumerator;
  while LEnum1.MoveNext and LEnum2.MoveNext do
    if not FComparer.Equals(LEnum1.Current, LEnum2.Current) then
      Exit(False);
  Result := not (LEnum1.MoveNext or LEnum2.MoveNext);
end;

function IFluentEnumerable<T>.Single(const APredicate: TFunc<T, Boolean>): T;
var
  LEnum: IFluentEnumerator<T>;
  LFound: Boolean;
begin
  Result := Default(T);
  LEnum := GetEnumerator;
  LFound := False;
  while LEnum.MoveNext do
  begin
    if APredicate(LEnum.Current) then
    begin
      if LFound then
        raise EInvalidOperation.Create('Sequence contains more than one matching element');
      Result := LEnum.Current;
      LFound := True;
    end;
  end;
  if not LFound then
    raise EInvalidOperation.Create('Sequence contains no matching element');
end;

function IFluentEnumerable<T>.SingleOrDefault(const APredicate: TFunc<T, Boolean>): T;
var
  LEnum: IFluentEnumerator<T>;
  LFound: Boolean;
begin
  Result := Default(T);
  LEnum := GetEnumerator;
  LFound := False;
  while LEnum.MoveNext do
  begin
    if APredicate(LEnum.Current) then
    begin
      if LFound then
        raise EInvalidOperation.Create('Sequence contains more than one matching element');
      Result := LEnum.Current;
      LFound := True;
    end;
  end;
end;

function IFluentEnumerable<T>.ElementAt(const AIndex: Integer): T;
var
  LEnum: IFluentEnumerator<T>;
  LCount: Integer;
begin
  if AIndex < 0 then
    raise EArgumentOutOfRangeException.Create('Index must be non-negative');
  LEnum := GetEnumerator;
  LCount := 0;
  while LEnum.MoveNext do
  begin
    if LCount = AIndex then
      Exit(LEnum.Current);
    Inc(LCount);
  end;
  raise EArgumentOutOfRangeException.Create('Index out of range');
end;

function IFluentEnumerable<T>.ElementAtOrDefault(const AIndex: Integer): T;
var
  LEnum: IFluentEnumerator<T>;
  LCount: Integer;
begin
  if AIndex < 0 then
    Exit(Default(T));
  LEnum := GetEnumerator;
  LCount := 0;
  while LEnum.MoveNext do
  begin
    if LCount = AIndex then
      Exit(LEnum.Current);
    Inc(LCount);
  end;
  Result := Default(T);
end;

{ IFluentQueryable<T> }

constructor IFluentQueryable<T>.Create(AQueryable: IFluentQueryableBase<T>);
begin
  FQueryable := AQueryable;
end;

function IFluentQueryable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := FQueryable.GetEnumerator;
end;

{ TFluentWrapper<TResult> }

constructor TFluentWrapper<TResult>.Create(const AValue: IFluentEnumerable<TResult>;
  const AList: TObject);
begin
  FValue := AValue;
  FList := AList;
end;

destructor TFluentWrapper<TResult>.Destroy;
begin
  FList.Free;
  inherited;
end;

function TFluentWrapper<TResult>.Value: IFluentEnumerable<TResult>;
begin
  Result := FValue;
end;


{ IFluentEnumerable<T>.TFluentCompare }

class function IFluentEnumerable<T>.TFluentCompare.Compare(
  const AEnumerator: IFluentEnumerableBase<T>; const AValue: T;
  const AComparer: IEqualityComparer<T>): Boolean;
var
  LEnum: IFluentEnumerator<T>;
begin
  LEnum := AEnumerator.GetEnumerator;
  while LEnum.MoveNext do
    if AComparer.Equals(LEnum.Current, AValue) then
      Exit(True);
  Result := False;
end;

{ TFluentQueryableBase<T> }

function TFluentQueryableBase<T>.BuildQuery: string;
begin

end;

end.
