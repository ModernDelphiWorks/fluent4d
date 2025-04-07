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

unit Fluent.Lazy;

interface

uses
  Classes,
  SysUtils,
  Generics.Collections,
  Generics.Defaults,
  Fluent.Core,
  Fluent.Adapters;

type
  TFluentFilterEnumerable<T> = class(TFluentEnumerableBase<T>)
  private
    FSource: IFluentEnumerableBase<T>;
    FPredicate: TFunc<T, Boolean>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const APredicate: TFunc<T, Boolean>);
    function GetEnumerator: IFluentEnumerator<T>; override;
  end;

  TFluentFilterEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FSource: IFluentEnumerator<T>;
    FPredicate: TFunc<T, Boolean>;
    FCurrent: T;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const APredicate: TFunc<T, Boolean>);
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  TFluentMapEnumerable<T, TResult> = class(TFluentEnumerableBase<TResult>)
  private
    FSource: IFluentEnumerableBase<T>;
    FSelector: TFunc<T, TResult>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const ASelector: TFunc<T, TResult>);
    function GetEnumerator: IFluentEnumerator<TResult>; override;
  end;

  TFluentMapEnumerator<T, TResult> = class(TInterfacedObject, IFluentEnumerator<TResult>)
  private
    FSource: IFluentEnumerator<T>;
    FSelector: TFunc<T, TResult>;
    FCurrent: TResult;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const ASelector: TFunc<T, TResult>);
    function GetCurrent: TResult;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: TResult read GetCurrent;
  end;

  TFluentCycleEnumerable<T> = class(TFluentEnumerableBase<T>)
  private
    FSource: IFluentEnumerableBase<T>;
    FCount: Integer;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const ACount: Integer);
    function GetEnumerator: IFluentEnumerator<T>; override;
  end;

  TFluentCycleEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FSource: IFluentEnumerator<T>;
    FCount: Integer;
    FItems: TArray<T>;
    FCurrentIndex: Integer;
    FCurrentCycle: Integer;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const ACount: Integer);
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  TFluentTakeEnumerable<T> = class(TFluentEnumerableBase<T>)
  private
    FSource: IFluentEnumerableBase<T>;
    FCount: Integer;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const ACount: Integer);
    function GetEnumerator: IFluentEnumerator<T>; override;
  end;

  TFluentTakeEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FSource: IFluentEnumerator<T>;
    FCount: Integer;
    FCurrentIndex: Integer;
    FCurrent: T;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const ACount: Integer);
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  TFluentSkipEnumerable<T> = class(TFluentEnumerableBase<T>)
  private
    FSource: IFluentEnumerableBase<T>;
    FCount: Integer;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; ACount: Integer);
    function GetEnumerator: IFluentEnumerator<T>; override;
  end;

  TFluentSkipEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FSource: IFluentEnumerator<T>;
    FCount: Integer;
    FSkipped: Integer;
    FCurrent: T;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; ACount: Integer);
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  TFluentOrderByEnumerable<T> = class(TFluentEnumerableBase<T>)
  private
    FSource: IFluentEnumerableBase<T>;
    FComparer: TFunc<T, T, Integer>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const AComparer: TFunc<T, T, Integer>);
    function GetEnumerator: IFluentEnumerator<T>; override;
  end;

  TFluentOrderByEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FItems: TArray<T>;
    FIndex: Integer;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const AComparer: TFunc<T, T, Integer>);
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  TFluentDistinctEnumerable<T> = class(TFluentEnumerableBase<T>)
  private
    FSource: IFluentEnumerableBase<T>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>);
    function GetEnumerator: IFluentEnumerator<T>; override;
  end;

  TFluentDistinctEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FSource: IFluentEnumerator<T>;
    FSet: TList<T>;
    FCurrent: T;
  public
    constructor Create(const ASource: IFluentEnumerator<T>);
    destructor Destroy; override;
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  TFluentGroupByEnumerable<TKey, T> = class(TFluentEnumerableBase<IGrouping<TKey, T>>, IGroupedEnumerator<TKey, T>)
  private
    FSource: IFluentEnumerableBase<T>;
    FKeySelector: TFunc<T, TKey>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const AKeySelector: TFunc<T, TKey>);
    function GetEnumerator: IFluentEnumerator<IGrouping<TKey, T>>; override;
    function AsEnumerable: IFluentEnumerable<IGrouping<TKey, T>>;
  end;

  TFluentGroupByEnumerator<TKey, T> = class(TInterfacedObject, IFluentEnumerator<IGrouping<TKey, T>>)
  private
    FSourceEnum: IFluentEnumerator<T>;
    FKeySelector: TFunc<T, TKey>;
    FGroups: TDictionary<TKey, TList<T>>;
    FEnumerator: TEnumerator<TPair<TKey, TList<T>>>;
    FCurrent: IGrouping<TKey, T>;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const AKeySelector: TFunc<T, TKey>);
    destructor Destroy; override;
    function GetCurrent: IGrouping<TKey, T>;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: IGrouping<TKey, T> read GetCurrent;
  end;

  TFluentFlatMapEnumerable<T, TResult> = class(TFluentEnumerableBase<TResult>)
  private
    FSource: IFluentEnumerableBase<T>;
    FSelector: TFunc<T, TArray<TResult>>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const ASelector: TFunc<T, TArray<TResult>>);
    function GetEnumerator: IFluentEnumerator<TResult>; override;
  end;

  TFluentFlatMapEnumerator<T, TResult> = class(TInterfacedObject, IFluentEnumerator<TResult>)
  private
    FSource: IFluentEnumerator<T>;
    FSelector: TFunc<T, TArray<TResult>>;
    FCurrentArray: TArray<TResult>;
    FIndex: Integer;
    FCurrent: TResult;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const ASelector: TFunc<T, TArray<TResult>>);
    function GetCurrent: TResult;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: TResult read GetCurrent;
  end;

  TFluentTakeWhileEnumerable<T> = class(TFluentEnumerableBase<T>)
  private
    FSource: IFluentEnumerableBase<T>;
    FPredicate: TFunc<T, Boolean>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const APredicate: TFunc<T, Boolean>);
    function GetEnumerator: IFluentEnumerator<T>; override;
  end;

  TFluentTakeWhileEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FSource: IFluentEnumerator<T>;
    FPredicate: TFunc<T, Boolean>;
    FCurrent: T;
    FDone: Boolean;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const APredicate: TFunc<T, Boolean>);
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  TFluentSkipWhileEnumerable<T> = class(TFluentEnumerableBase<T>)
  private
    FSource: IFluentEnumerableBase<T>;
    FPredicate: TFunc<T, Boolean>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const APredicate: TFunc<T, Boolean>);
    function GetEnumerator: IFluentEnumerator<T>; override;
  end;

  TFluentSkipWhileEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FSource: IFluentEnumerator<T>;
    FPredicate: TFunc<T, Boolean>;
    FSkipped: Boolean;
    FCurrent: T;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const APredicate: TFunc<T, Boolean>);
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  TFluentZipEnumerable<T, TSecond, TResult> = class(TFluentEnumerableBase<TResult>)
  private
    FSource1: IFluentEnumerableBase<T>;
    FSource2: IFluentEnumerableBase<TSecond>;
    FSelector: TFunc<T, TSecond, TResult>;
  public
    constructor Create(const ASource1: IFluentEnumerableBase<T>; const ASource2: IFluentEnumerableBase<TSecond>;
      const ASelector: TFunc<T, TSecond, TResult>);
    function GetEnumerator: IFluentEnumerator<TResult>; override;
  end;

  TFluentZipEnumerator<T, TSecond, TResult> = class(TInterfacedObject, IFluentEnumerator<TResult>)
  private
    FSource1: IFluentEnumerator<T>;
    FSource2: IFluentEnumerator<TSecond>;
    FSelector: TFunc<T, TSecond, TResult>;
    FCurrent: TResult;
  public
    constructor Create(const ASource1: IFluentEnumerator<T>; const ASource2: IFluentEnumerator<TSecond>;
      const ASelector: TFunc<T, TSecond, TResult>);
    function GetCurrent: TResult;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: TResult read GetCurrent;
  end;

  TFluentJoinEnumerable<T, TInner, TKey, TResult> = class(TFluentEnumerableBase<TResult>)
  private
    FSource: IFluentEnumerableBase<T>;
    FInner: IFluentEnumerableBase<TInner>;
    FOuterKeySelector: TFunc<T, TKey>;
    FInnerKeySelector: TFunc<TInner, TKey>;
    FResultSelector: TFunc<T, TInner, TResult>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const AInner: IFluentEnumerableBase<TInner>;
      const AOuterKeySelector: TFunc<T, TKey>; const AInnerKeySelector: TFunc<TInner, TKey>;
      const AResultSelector: TFunc<T, TInner, TResult>);
    function GetEnumerator: IFluentEnumerator<TResult>; override;
  end;

  TFluentJoinEnumerator<T, TInner, TKey, TResult> = class(TInterfacedObject, IFluentEnumerator<TResult>)
  private
    FSource: IFluentEnumerator<T>;
    FInner: TList<TInner>;
    FOuterKeySelector: TFunc<T, TKey>;
    FInnerKeySelector: TFunc<TInner, TKey>;
    FResultSelector: TFunc<T, TInner, TResult>;
    FCurrent: TResult;
    FInnerEnum: IFluentEnumerator<TInner>;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const AInner: IFluentEnumerator<TInner>;
      const AOuterKeySelector: TFunc<T, TKey>; const AInnerKeySelector: TFunc<TInner, TKey>;
      const AResultSelector: TFunc<T, TInner, TResult>);
    destructor Destroy; override;
    function GetCurrent: TResult;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: TResult read GetCurrent;
  end;

  TFluentOfTypeEnumerable<T, TResult> = class(TFluentEnumerableBase<TResult>)
  private
    FSource: IFluentEnumerableBase<T>;
    FIsType: TFunc<T, Boolean>;
    FConverter: TFunc<T, TResult>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const AIsType: TFunc<T, Boolean>;
      const AConverter: TFunc<T, TResult>);
    function GetEnumerator: IFluentEnumerator<TResult>; override;
  end;

  TFluentOfTypeEnumerator<T, TResult> = class(TInterfacedObject, IFluentEnumerator<TResult>)
  private
    FSource: IFluentEnumerator<T>;
    FIsType: TFunc<T, Boolean>;
    FConverter: TFunc<T, TResult>;
    FCurrent: TResult;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const AIsType: TFunc<T, Boolean>;
      const AConverter: TFunc<T, TResult>);
    function GetCurrent: TResult;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: TResult read GetCurrent;
  end;

  TFluentSelectManyEnumerable<T, TResult> = class(TFluentEnumerableBase<TResult>)
  private
    FSource: IFluentEnumerableBase<T>;
    FSelector: TFunc<T, IFluentWrapper<TResult>>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const ASelector: TFunc<T, IFluentWrapper<TResult>>);
    function GetEnumerator: IFluentEnumerator<TResult>; override;
  end;

  TFluentSelectManyEnumerator<T, TResult> = class(TInterfacedObject, IFluentEnumerator<TResult>)
  private
    FSource: IFluentEnumerator<T>;
    FSelector: TFunc<T, IFluentWrapper<TResult>>;
    FCurrentWrapper: IFluentWrapper<TResult>;
    FCurrentEnum: IFluentEnumerator<TResult>;
    FCurrent: TResult;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const ASelector: TFunc<T, IFluentWrapper<TResult>>);
    function GetCurrent: TResult;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: TResult read GetCurrent;
  end;

  TFluentGroupJoinEnumerable<T, TInner, TKey, TResult> = class(TFluentEnumerableBase<TResult>)
  private
    FSource: IFluentEnumerableBase<T>;
    FInner: IFluentEnumerableBase<TInner>;
    FOuterKeySelector: TFunc<T, TKey>;
    FInnerKeySelector: TFunc<TInner, TKey>;
    FResultSelector: TFunc<T, IFluentWrapper<TInner>, TResult>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const AInner: IFluentEnumerableBase<TInner>;
      const AOuterKeySelector: TFunc<T, TKey>; const AInnerKeySelector: TFunc<TInner, TKey>;
      const AResultSelector: TFunc<T, IFluentWrapper<TInner>, TResult>);
    function GetEnumerator: IFluentEnumerator<TResult>; override;
  end;

  TFluentGroupJoinEnumerator<T, TInner, TKey, TResult> = class(TInterfacedObject, IFluentEnumerator<TResult>)
  private
    FSource: IFluentEnumerator<T>;
    FInner: TList<TInner>;
    FOuterKeySelector: TFunc<T, TKey>;
    FInnerKeySelector: TFunc<TInner, TKey>;
    FResultSelector: TFunc<T, IFluentWrapper<TInner>, TResult>;
    FCurrent: TResult;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const AInner: IFluentEnumerator<TInner>;
      const AOuterKeySelector: TFunc<T, TKey>; const AInnerKeySelector: TFunc<TInner, TKey>;
      const AResultSelector: TFunc<T, IFluentWrapper<TInner>, TResult>);
    destructor Destroy; override;
    function GetCurrent: TResult;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: TResult read GetCurrent;
  end;

  TFluentExcludeEnumerable<T> = class(TFluentEnumerableBase<T>)
  private
    FSource: IFluentEnumerableBase<T>;
    FSecond: IFluentEnumerableBase<T>;
    FComparer: IEqualityComparer<T>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>;
      const ASecond: IFluentEnumerableBase<T>;
      const AComparer: IEqualityComparer<T>);
    function GetEnumerator: IFluentEnumerator<T>; override;
  end;

  TFluentExcludeEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FSource: IFluentEnumerator<T>;
    FSecond: TDictionary<T, Boolean>;
    FCurrent: T;
    FComparer: IEqualityComparer<T>;
    function ContainsValue(const AValue: T): Boolean;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const ASecond: IFluentEnumerator<T>;
      const AComparer: IEqualityComparer<T>);
    destructor Destroy; override;
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  TFluentIntersectEnumerable<T> = class(TFluentEnumerableBase<T>)
  private
    FSource: IFluentEnumerableBase<T>;
    FSecond: IFluentEnumerableBase<T>;
    FComparer: IEqualityComparer<T>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>;
      const ASecond: IFluentEnumerableBase<T>;
      const AComparer: IEqualityComparer<T>);
    function GetEnumerator: IFluentEnumerator<T>; override;
  end;

  TFluentIntersectEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FSource: IFluentEnumerator<T>;
    FSecond: TDictionary<T, Boolean>;
    FCurrent: T;
    FComparer: IEqualityComparer<T>;
    function ContainsValue(const AValue: T): Boolean;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const ASecond: IFluentEnumerator<T>;
      const AComparer: IEqualityComparer<T>);
    destructor Destroy; override;
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  TFluentUnionEnumerable<T> = class(TFluentEnumerableBase<T>)
  private
    FSource: IFluentEnumerableBase<T>;
    FSecond: IFluentEnumerableBase<T>;
    FComparer: IEqualityComparer<T>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>;
      const ASecond: IFluentEnumerableBase<T>;
      const AComparer: IEqualityComparer<T>);
    function GetEnumerator: IFluentEnumerator<T>; override;
  end;

  TFluentUnionEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FSource: IFluentEnumerator<T>;
    FSecond: IFluentEnumerator<T>;
    FSet: TDictionary<T, Boolean>;
    FCurrent: T;
    FOnSecond: Boolean;
    FComparer: IEqualityComparer<T>;
    function ContainsValue(const AValue: T): Boolean;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const ASecond: IFluentEnumerator<T>;
      const AComparer: IEqualityComparer<T>);
    destructor Destroy; override;
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  TFluentConcatEnumerable<T> = class(TFluentEnumerableBase<T>)
  private
    FSource: IFluentEnumerableBase<T>;
    FSecond: IFluentEnumerableBase<T>;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; const ASecond: IFluentEnumerableBase<T>);
    function GetEnumerator: IFluentEnumerator<T>; override;
  end;

  TFluentConcatEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FSource: IFluentEnumerator<T>;
    FSecond: IFluentEnumerator<T>;
    FCurrent: T;
    FOnSecond: Boolean;
  public
    constructor Create(const ASource: IFluentEnumerator<T>; const ASecond: IFluentEnumerator<T>);
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  TFluentGrouping<TKey, T> = class(TInterfacedObject, IGrouping<TKey, T>)
  private
    FKey: TKey;
    FItems: IFluentEnumerable<T>;
  public
    constructor Create(const AKey: TKey; const AItems: IFluentEnumerable<T>);
    function GetKey: TKey;
    function GetItems: IFluentEnumerable<T>;
    property Key: TKey read GetKey;
    property Items: IFluentEnumerable<T> read GetItems;
  end;

  TFluentTeeEnumerable<T> = class(TInterfacedObject, IFluentEnumerableBase<T>)
  private
    FSource: IFluentEnumerableBase<T>;
    FItems: TArray<T>;
    FPopulated: Boolean;
    FCount: Integer;
  public
    constructor Create(const ASource: IFluentEnumerableBase<T>; ACount: Integer);
    function GetEnumerator: IFluentEnumerator<T>;
  end;

  TFluentTeeEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FItems: TArray<T>;
    FIndex: Integer;
    FCurrent: T;
  public
    constructor Create(const AItems: TArray<T>);
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

implementation

{ TFluentFilterEnumerable<T> }

constructor TFluentFilterEnumerable<T>.Create(const ASource: IFluentEnumerableBase<T>; const APredicate: TFunc<T, Boolean>);
begin
  FSource := ASource;
  FPredicate := APredicate;
end;

function TFluentFilterEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TFluentFilterEnumerator<T>.Create(FSource.GetEnumerator, FPredicate);
end;

{ TFluentFilterEnumerator<T> }

constructor TFluentFilterEnumerator<T>.Create(const ASource: IFluentEnumerator<T>; const APredicate: TFunc<T, Boolean>);
begin
  FSource := ASource;
  FPredicate := APredicate;
end;

function TFluentFilterEnumerator<T>.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TFluentFilterEnumerator<T>.MoveNext: Boolean;
begin
  while FSource.MoveNext do
  begin
    FCurrent := FSource.Current;
    if FPredicate(FCurrent) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure TFluentFilterEnumerator<T>.Reset;
begin
  FSource.Reset;
end;

{ TFluentMapEnumerable<T, TResult> }

constructor TFluentMapEnumerable<T, TResult>.Create(const ASource: IFluentEnumerableBase<T>; const ASelector: TFunc<T, TResult>);
begin
  FSource := ASource;
  FSelector := ASelector;
end;

function TFluentMapEnumerable<T, TResult>.GetEnumerator: IFluentEnumerator<TResult>;
begin
  Result := TFluentMapEnumerator<T, TResult>.Create(FSource.GetEnumerator, FSelector);
end;

{ TFluentMapEnumerator<T, TResult> }

constructor TFluentMapEnumerator<T, TResult>.Create(const ASource: IFluentEnumerator<T>; const ASelector: TFunc<T, TResult>);
begin
  FSource := ASource;
  FSelector := ASelector;
end;

function TFluentMapEnumerator<T, TResult>.GetCurrent: TResult;
begin
  Result := FCurrent;
end;

function TFluentMapEnumerator<T, TResult>.MoveNext: Boolean;
begin
  if FSource.MoveNext then
  begin
    FCurrent := FSelector(FSource.Current);
    Result := True;
  end
  else
    Result := False;
end;

procedure TFluentMapEnumerator<T, TResult>.Reset;
begin
  FSource.Reset;
end;

{ TFluentCycleEnumerable<T> }

constructor TFluentCycleEnumerable<T>.Create(const ASource: IFluentEnumerableBase<T>; const ACount: Integer);
begin
  FSource := ASource;
  FCount := ACount;
end;

function TFluentCycleEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TFluentCycleEnumerator<T>.Create(FSource.GetEnumerator, FCount);
end;

{ TFluentCycleEnumerator<T> }

constructor TFluentCycleEnumerator<T>.Create(const ASource: IFluentEnumerator<T>; const ACount: Integer);
var
  LList: TList<T>;
begin
  FSource := ASource;
  FCount := ACount;
  LList := TList<T>.Create;
  try
    while FSource.MoveNext do
      LList.Add(FSource.Current);
    FItems := LList.ToArray;
  finally
    LList.Free;
  end;
  FCurrentIndex := -1;
  FCurrentCycle := 0;
end;

function TFluentCycleEnumerator<T>.GetCurrent: T;
begin
  Result := FItems[FCurrentIndex];
end;

function TFluentCycleEnumerator<T>.MoveNext: Boolean;
begin
  if Length(FItems) = 0 then
    Exit(False);
  Inc(FCurrentIndex);
  if FCurrentIndex >= Length(FItems) then
  begin
    FCurrentIndex := 0;
    Inc(FCurrentCycle);
  end;
  Result := (FCount = -1) or (FCurrentCycle < FCount);
end;

procedure TFluentCycleEnumerator<T>.Reset;
begin
  FCurrentIndex := -1;
  FCurrentCycle := 0;
end;

{ TFluentTakeEnumerable<T> }

constructor TFluentTakeEnumerable<T>.Create(const ASource: IFluentEnumerableBase<T>; const ACount: Integer);
begin
  FSource := ASource;
  FCount := ACount;
end;

function TFluentTakeEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TFluentTakeEnumerator<T>.Create(FSource.GetEnumerator, FCount);
end;

{ TFluentTakeEnumerator<T> }

constructor TFluentTakeEnumerator<T>.Create(const ASource: IFluentEnumerator<T>; const ACount: Integer);
begin
  FSource := ASource;
  FCount := ACount;
  FCurrentIndex := 0;
end;

function TFluentTakeEnumerator<T>.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TFluentTakeEnumerator<T>.MoveNext: Boolean;
begin
  if FCurrentIndex < FCount then
  begin
    if FSource.MoveNext then
    begin
      FCurrent := FSource.Current;
      Inc(FCurrentIndex);
      Result := True;
    end
    else
      Result := False;
  end
  else
    Result := False;
end;

procedure TFluentTakeEnumerator<T>.Reset;
begin
  FSource.Reset;
  FCurrentIndex := 0;
end;

{ TFluentSkipEnumerable<T> }

constructor TFluentSkipEnumerable<T>.Create(const ASource: IFluentEnumerableBase<T>; ACount: Integer);
begin
  FSource := ASource;
  FCount := ACount;
end;

function TFluentSkipEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TFluentSkipEnumerator<T>.Create(FSource.GetEnumerator, FCount);
end;

{ TFluentSkipEnumerator<T> }

constructor TFluentSkipEnumerator<T>.Create(const ASource: IFluentEnumerator<T>; ACount: Integer);
begin
  FSource := ASource;
  FCount := ACount;
  FSkipped := 0;
end;

function TFluentSkipEnumerator<T>.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TFluentSkipEnumerator<T>.MoveNext: Boolean;
begin
  while FSkipped < FCount do
  begin
    if FSource.MoveNext then
      Inc(FSkipped)
    else
      Exit(False);
  end;
  Result := FSource.MoveNext;
  if Result then
    FCurrent := FSource.Current;
end;

procedure TFluentSkipEnumerator<T>.Reset;
begin
  FSource.Reset;
  FSkipped := 0;
end;

{ TFluentOrderByEnumerable<T> }

constructor TFluentOrderByEnumerable<T>.Create(const ASource: IFluentEnumerableBase<T>; const AComparer: TFunc<T, T, Integer>);
begin
  FSource := ASource;
  FComparer := AComparer;
end;

function TFluentOrderByEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TFluentOrderByEnumerator<T>.Create(FSource.GetEnumerator, FComparer);
end;

{ TFluentOrderByEnumerator<T> }

constructor TFluentOrderByEnumerator<T>.Create(const ASource: IFluentEnumerator<T>; const AComparer: TFunc<T, T, Integer>);
var
  LList: TList<T>;
begin
  LList := TList<T>.Create;
  try
    while ASource.MoveNext do
      LList.Add(ASource.Current);
    FItems := LList.ToArray;
    TArray.Sort<T>(FItems, TComparer<T>.Construct(
      function(const Left, Right: T): Integer
      begin
        Result := AComparer(Left, Right);
      end));
  finally
    LList.Free;
  end;
  FIndex := -1;
end;

function TFluentOrderByEnumerator<T>.GetCurrent: T;
begin
  Result := FItems[FIndex];
end;

function TFluentOrderByEnumerator<T>.MoveNext: Boolean;
begin
  Inc(FIndex);
  Result := FIndex < Length(FItems);
end;

procedure TFluentOrderByEnumerator<T>.Reset;
begin
  FIndex := -1;
end;

{ TFluentDistinctEnumerable<T> }

constructor TFluentDistinctEnumerable<T>.Create(const ASource: IFluentEnumerableBase<T>);
begin
  FSource := ASource;
end;

function TFluentDistinctEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TFluentDistinctEnumerator<T>.Create(FSource.GetEnumerator);
end;

{ TFluentDistinctEnumerator<T> }

constructor TFluentDistinctEnumerator<T>.Create(const ASource: IFluentEnumerator<T>);
begin
  FSource := ASource;
  FSet := TList<T>.Create;
end;

destructor TFluentDistinctEnumerator<T>.Destroy;
begin
  FSet.Free;
  inherited;
end;

function TFluentDistinctEnumerator<T>.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TFluentDistinctEnumerator<T>.MoveNext: Boolean;
begin
  while FSource.MoveNext do
  begin
    FCurrent := FSource.Current;
    if not FSet.Contains(FCurrent) then
    begin
      FSet.Add(FCurrent);
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure TFluentDistinctEnumerator<T>.Reset;
begin
  FSource.Reset;
  FSet.Clear;
end;

{ TFluentGrouping<TKey, T> }

constructor TFluentGrouping<TKey, T>.Create(const AKey: TKey; const AItems: IFluentEnumerable<T>);
begin
  FKey := AKey;
  FItems := AItems;
end;

function TFluentGrouping<TKey, T>.GetKey: TKey;
begin
  Result := FKey;
end;

function TFluentGrouping<TKey, T>.GetItems: IFluentEnumerable<T>;
begin
  Result := FItems;
end;

{ TFluentGroupByEnumerable<TKey, T> }

constructor TFluentGroupByEnumerable<TKey, T>.Create(const ASource: IFluentEnumerableBase<T>; const AKeySelector: TFunc<T, TKey>);
begin
  FSource := ASource;
  FKeySelector := AKeySelector;
end;

function TFluentGroupByEnumerable<TKey, T>.GetEnumerator: IFluentEnumerator<IGrouping<TKey, T>>;
begin
  Result := TFluentGroupByEnumerator<TKey, T>.Create(FSource.GetEnumerator, FKeySelector);
end;

function TFluentGroupByEnumerable<TKey, T>.AsEnumerable: IFluentEnumerable<IGrouping<TKey, T>>;
begin
  Result := IFluentEnumerable<IGrouping<TKey, T>>.Create(Self);
end;

{ TFluentGroupByEnumerator<TKey, T> }

constructor TFluentGroupByEnumerator<TKey, T>.Create(const ASource: IFluentEnumerator<T>; const AKeySelector: TFunc<T, TKey>);
var
  LItem: T;
begin
  FSourceEnum := ASource;
  FKeySelector := AKeySelector;
  FGroups := TDictionary<TKey, TList<T>>.Create;
  while FSourceEnum.MoveNext do
  begin
    LItem := FSourceEnum.Current;
    if not FGroups.ContainsKey(FKeySelector(LItem)) then
      FGroups.Add(FKeySelector(LItem), TList<T>.Create);
    FGroups[FKeySelector(LItem)].Add(LItem);
  end;
  FEnumerator := FGroups.GetEnumerator;
end;

destructor TFluentGroupByEnumerator<TKey, T>.Destroy;
var
  LPair: TPair<TKey, TList<T>>;
begin
  for LPair in FGroups do
    LPair.Value.Free;
  FGroups.Free;
  FEnumerator.Free;
  inherited;
end;

function TFluentGroupByEnumerator<TKey, T>.GetCurrent: IGrouping<TKey, T>;
begin
  Result := FCurrent;
end;

function TFluentGroupByEnumerator<TKey, T>.MoveNext: Boolean;
var
  LPair: TPair<TKey, TList<T>>;
begin
  if FEnumerator.MoveNext then
  begin
    LPair := FEnumerator.Current;
    FCurrent := TFluentGrouping<TKey, T>.Create(LPair.Key,
      IFluentEnumerable<T>.Create(TListAdapter<T>.Create(LPair.Value, False)));
    Result := True;
  end
  else
    Result := False;
end;

procedure TFluentGroupByEnumerator<TKey, T>.Reset;
begin
  FEnumerator.Free;
  FEnumerator := FGroups.GetEnumerator;
end;

{ TFluentFlatMapEnumerable<T, TResult> }

constructor TFluentFlatMapEnumerable<T, TResult>.Create(const ASource: IFluentEnumerableBase<T>; const ASelector: TFunc<T, TArray<TResult>>);
begin
  FSource := ASource;
  FSelector := ASelector;
end;

function TFluentFlatMapEnumerable<T, TResult>.GetEnumerator: IFluentEnumerator<TResult>;
begin
  Result := TFluentFlatMapEnumerator<T, TResult>.Create(FSource.GetEnumerator, FSelector);
end;

{ TFluentFlatMapEnumerator<T, TResult> }

constructor TFluentFlatMapEnumerator<T, TResult>.Create(const ASource: IFluentEnumerator<T>;
  const ASelector: TFunc<T, TArray<TResult>>);
begin
  FSource := ASource;
  FSelector := ASelector;
  FIndex := -1;
end;

function TFluentFlatMapEnumerator<T, TResult>.GetCurrent: TResult;
begin
  Result := FCurrent;
end;

function TFluentFlatMapEnumerator<T, TResult>.MoveNext: Boolean;
begin
  while True do
  begin
    if (FIndex >= 0) and (FIndex < Length(FCurrentArray) - 1) then
    begin
      Inc(FIndex);
      FCurrent := FCurrentArray[FIndex];
      Result := True;
      Exit;
    end;
    if not FSource.MoveNext then
    begin
      Result := False;
      Exit;
    end;
    FCurrentArray := FSelector(FSource.Current);
    FIndex := 0;
    if Length(FCurrentArray) > 0 then
    begin
      FCurrent := FCurrentArray[FIndex];
      Result := True;
      Exit;
    end;
  end;
end;

procedure TFluentFlatMapEnumerator<T, TResult>.Reset;
begin
  FSource.Reset;
  FIndex := -1;
  FCurrentArray := nil;
end;

{ TFluentTakeWhileEnumerable<T> }

constructor TFluentTakeWhileEnumerable<T>.Create(const ASource: IFluentEnumerableBase<T>; const APredicate: TFunc<T, Boolean>);
begin
  FSource := ASource;
  FPredicate := APredicate;
end;

function TFluentTakeWhileEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TFluentTakeWhileEnumerator<T>.Create(FSource.GetEnumerator, FPredicate);
end;

{ TFluentTakeWhileEnumerator<T> }

constructor TFluentTakeWhileEnumerator<T>.Create(const ASource: IFluentEnumerator<T>; const APredicate: TFunc<T, Boolean>);
begin
  FSource := ASource;
  FPredicate := APredicate;
  FDone := False;
end;

function TFluentTakeWhileEnumerator<T>.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TFluentTakeWhileEnumerator<T>.MoveNext: Boolean;
begin
  if FDone or not FSource.MoveNext then
    Exit(False);
  FCurrent := FSource.Current;
  if not FPredicate(FCurrent) then
  begin
    FDone := True;
    Exit(False);
  end;
  Result := True;
end;

procedure TFluentTakeWhileEnumerator<T>.Reset;
begin
  FSource.Reset;
  FDone := False;
end;

{ TFluentSkipWhileEnumerable<T> }

constructor TFluentSkipWhileEnumerable<T>.Create(const ASource: IFluentEnumerableBase<T>;
  const APredicate: TFunc<T, Boolean>);
begin
  FSource := ASource;
  FPredicate := APredicate;
end;

function TFluentSkipWhileEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TFluentSkipWhileEnumerator<T>.Create(FSource.GetEnumerator, FPredicate);
end;

{ TFluentSkipWhileEnumerator<T> }

constructor TFluentSkipWhileEnumerator<T>.Create(const ASource: IFluentEnumerator<T>;
  const APredicate: TFunc<T, Boolean>);
begin
  FSource := ASource;
  FPredicate := APredicate;
  FSkipped := False;
end;

function TFluentSkipWhileEnumerator<T>.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TFluentSkipWhileEnumerator<T>.MoveNext: Boolean;
begin
  if not FSkipped then
  begin
    while FSource.MoveNext do
    begin
      if not FPredicate(FSource.Current) then
      begin
        FCurrent := FSource.Current;
        FSkipped := True;
        Result := True;
        Exit;
      end;
    end;
    FSkipped := True;
  end;
  Result := FSource.MoveNext;
  if Result then
    FCurrent := FSource.Current;
end;

procedure TFluentSkipWhileEnumerator<T>.Reset;
begin
  FSource.Reset;
  FSkipped := False;
end;

{ TFluentZipEnumerable<T, TSecond, TResult> }

constructor TFluentZipEnumerable<T, TSecond, TResult>.Create(const ASource1: IFluentEnumerableBase<T>;
  const ASource2: IFluentEnumerableBase<TSecond>; const ASelector: TFunc<T, TSecond, TResult>);
begin
  FSource1 := ASource1;
  FSource2 := ASource2;
  FSelector := ASelector;
end;

function TFluentZipEnumerable<T, TSecond, TResult>.GetEnumerator: IFluentEnumerator<TResult>;
begin
  Result := TFluentZipEnumerator<T, TSecond, TResult>.Create(FSource1.GetEnumerator, FSource2.GetEnumerator, FSelector);
end;

{ TFluentZipEnumerator<T, TSecond, TResult> }

constructor TFluentZipEnumerator<T, TSecond, TResult>.Create(const ASource1: IFluentEnumerator<T>;
  const ASource2: IFluentEnumerator<TSecond>; const ASelector: TFunc<T, TSecond, TResult>);
begin
  FSource1 := ASource1;
  FSource2 := ASource2;
  FSelector := ASelector;
end;

function TFluentZipEnumerator<T, TSecond, TResult>.GetCurrent: TResult;
begin
  Result := FCurrent;
end;

function TFluentZipEnumerator<T, TSecond, TResult>.MoveNext: Boolean;
begin
  if FSource1.MoveNext and FSource2.MoveNext then
  begin
    FCurrent := FSelector(FSource1.Current, FSource2.Current);
    Result := True;
  end
  else
    Result := False;
end;

procedure TFluentZipEnumerator<T, TSecond, TResult>.Reset;
begin
  FSource1.Reset;
  FSource2.Reset;
end;

{ TFluentJoinEnumerable<T, TInner, TKey, TResult> }

constructor TFluentJoinEnumerable<T, TInner, TKey, TResult>.Create(const ASource: IFluentEnumerableBase<T>;
  const AInner: IFluentEnumerableBase<TInner>; const AOuterKeySelector: TFunc<T, TKey>;
  const AInnerKeySelector: TFunc<TInner, TKey>; const AResultSelector: TFunc<T, TInner, TResult>);
begin
  FSource := ASource;
  FInner := AInner;
  FOuterKeySelector := AOuterKeySelector;
  FInnerKeySelector := AInnerKeySelector;
  FResultSelector := AResultSelector;
end;

function TFluentJoinEnumerable<T, TInner, TKey, TResult>.GetEnumerator: IFluentEnumerator<TResult>;
begin
  Result := TFluentJoinEnumerator<T, TInner, TKey, TResult>.Create(FSource.GetEnumerator, FInner.GetEnumerator,
    FOuterKeySelector, FInnerKeySelector, FResultSelector);
end;

{ TFluentJoinEnumerator<T, TInner, TKey, TResult> }

constructor TFluentJoinEnumerator<T, TInner, TKey, TResult>.Create(const ASource: IFluentEnumerator<T>;
  const AInner: IFluentEnumerator<TInner>; const AOuterKeySelector: TFunc<T, TKey>;
  const AInnerKeySelector: TFunc<TInner, TKey>; const AResultSelector: TFunc<T, TInner, TResult>);
begin
  FSource := ASource;
  FInner := TList<TInner>.Create;
  FOuterKeySelector := AOuterKeySelector;
  FInnerKeySelector := AInnerKeySelector;
  FResultSelector := AResultSelector;
  while AInner.MoveNext do
    FInner.Add(AInner.Current);
  FInnerEnum := nil;
end;

destructor TFluentJoinEnumerator<T, TInner, TKey, TResult>.Destroy;
begin
  FInner.Free;
  inherited;
end;

function TFluentJoinEnumerator<T, TInner, TKey, TResult>.GetCurrent: TResult;
begin
  Result := FCurrent;
end;

function TFluentJoinEnumerator<T, TInner, TKey, TResult>.MoveNext: Boolean;
var
  LOuterKey: TKey;
  LInnerItem: TInner;
begin
  while True do
  begin
    if not Assigned(FInnerEnum) or not FInnerEnum.MoveNext then
    begin
      if not FSource.MoveNext then
      begin
        FInnerEnum := nil;
        Result := False;
        Exit;
      end;
      FInnerEnum := TListEnumerator<TInner>.Create(FInner.GetEnumerator);
      if not FInnerEnum.MoveNext then
        Continue;
    end;
    LOuterKey := FOuterKeySelector(FSource.Current);
    LInnerItem := FInnerEnum.Current;
    if TComparer<TKey>.Default.Compare(LOuterKey, FInnerKeySelector(LInnerItem)) = 0 then
    begin
      FCurrent := FResultSelector(FSource.Current, LInnerItem);
      Result := True;
      Exit;
    end;
  end;
end;

procedure TFluentJoinEnumerator<T, TInner, TKey, TResult>.Reset;
begin
  FSource.Reset;
  FInnerEnum := nil;
end;

{ TFluentOfTypeEnumerable<T, TResult> }

constructor TFluentOfTypeEnumerable<T, TResult>.Create(const ASource: IFluentEnumerableBase<T>;
  const AIsType: TFunc<T, Boolean>; const AConverter: TFunc<T, TResult>);
begin
  FSource := ASource;
  FIsType := AIsType;
  FConverter := AConverter;
end;

function TFluentOfTypeEnumerable<T, TResult>.GetEnumerator: IFluentEnumerator<TResult>;
begin
  Result := TFluentOfTypeEnumerator<T, TResult>.Create(FSource.GetEnumerator, FIsType, FConverter);
end;

{ TFluentOfTypeEnumerator<T, TResult> }

constructor TFluentOfTypeEnumerator<T, TResult>.Create(const ASource: IFluentEnumerator<T>;
  const AIsType: TFunc<T, Boolean>; const AConverter: TFunc<T, TResult>);
begin
  FSource := ASource;
  FIsType := AIsType;
  FConverter := AConverter;
end;

function TFluentOfTypeEnumerator<T, TResult>.GetCurrent: TResult;
begin
  Result := FCurrent;
end;

function TFluentOfTypeEnumerator<T, TResult>.MoveNext: Boolean;
begin
  while FSource.MoveNext do
  begin
    if FIsType(FSource.Current) then
    begin
      FCurrent := FConverter(FSource.Current);
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure TFluentOfTypeEnumerator<T, TResult>.Reset;
begin
  FSource.Reset;
end;

{ TFluentSelectManyEnumerable<T, TResult> }

constructor TFluentSelectManyEnumerable<T, TResult>.Create(const ASource: IFluentEnumerableBase<T>;
  const ASelector: TFunc<T, IFluentWrapper<TResult>>);
begin
  FSource := ASource;
  FSelector := ASelector;
end;

function TFluentSelectManyEnumerable<T, TResult>.GetEnumerator: IFluentEnumerator<TResult>;
begin
  Result := TFluentSelectManyEnumerator<T, TResult>.Create(FSource.GetEnumerator, FSelector);
end;

{ TFluentSelectManyEnumerator<T, TResult> }

constructor TFluentSelectManyEnumerator<T, TResult>.Create(const ASource: IFluentEnumerator<T>;
  const ASelector: TFunc<T, IFluentWrapper<TResult>>);
begin
  FSource := ASource;
  FSelector := ASelector;
  FCurrentWrapper := nil;
  FCurrentEnum := nil;
end;

function TFluentSelectManyEnumerator<T, TResult>.GetCurrent: TResult;
begin
  Result := FCurrent;
end;

function TFluentSelectManyEnumerator<T, TResult>.MoveNext: Boolean;
begin
  while (not Assigned(FCurrentEnum) or not FCurrentEnum.MoveNext) do
  begin
    if not FSource.MoveNext then
      Exit(False);
    FCurrentWrapper := FSelector(FSource.Current);
    FCurrentEnum := FCurrentWrapper.Value.GetEnumerator;
  end;
  FCurrent := FCurrentEnum.Current;
  Result := True;
end;

procedure TFluentSelectManyEnumerator<T, TResult>.Reset;
begin
  FSource.Reset;
  FCurrentWrapper := nil;
  FCurrentEnum := nil;
end;

{ TFluentGroupJoinEnumerable<T, TInner, TKey, TResult> }

constructor TFluentGroupJoinEnumerable<T, TInner, TKey, TResult>.Create(const ASource: IFluentEnumerableBase<T>;
  const AInner: IFluentEnumerableBase<TInner>; const AOuterKeySelector: TFunc<T, TKey>;
  const AInnerKeySelector: TFunc<TInner, TKey>; const AResultSelector: TFunc<T, IFluentWrapper<TInner>, TResult>);
begin
  FSource := ASource;
  FInner := AInner;
  FOuterKeySelector := AOuterKeySelector;
  FInnerKeySelector := AInnerKeySelector;
  FResultSelector := AResultSelector;
end;

function TFluentGroupJoinEnumerable<T, TInner, TKey, TResult>.GetEnumerator: IFluentEnumerator<TResult>;
begin
  Result := TFluentGroupJoinEnumerator<T, TInner, TKey, TResult>.Create(FSource.GetEnumerator, FInner.GetEnumerator,
    FOuterKeySelector, FInnerKeySelector, FResultSelector);
end;

{ TFluentGroupJoinEnumerator<T, TInner, TKey, TResult> }

constructor TFluentGroupJoinEnumerator<T, TInner, TKey, TResult>.Create(const ASource: IFluentEnumerator<T>;
  const AInner: IFluentEnumerator<TInner>; const AOuterKeySelector: TFunc<T, TKey>;
  const AInnerKeySelector: TFunc<TInner, TKey>; const AResultSelector: TFunc<T, IFluentWrapper<TInner>, TResult>);
begin
  FSource := ASource;
  FInner := TList<TInner>.Create;
  FOuterKeySelector := AOuterKeySelector;
  FInnerKeySelector := AInnerKeySelector;
  FResultSelector := AResultSelector;
  while AInner.MoveNext do
    FInner.Add(AInner.Current);
end;

destructor TFluentGroupJoinEnumerator<T, TInner, TKey, TResult>.Destroy;
begin
  FInner.Free;
  inherited;
end;

function TFluentGroupJoinEnumerator<T, TInner, TKey, TResult>.GetCurrent: TResult;
begin
  Result := FCurrent;
end;

function TFluentGroupJoinEnumerator<T, TInner, TKey, TResult>.MoveNext: Boolean;
var
  LOuterKey: TKey;
  LMatches: IFluentEnumerable<TInner>;
  LWrapper: IFluentWrapper<TInner>;
begin
  if FSource.MoveNext then
  begin
    LOuterKey := FOuterKeySelector(FSource.Current);
    LMatches := IFluentEnumerable<TInner>.Create(TListAdapter<TInner>.Create(FInner)).Filter(
      function(Item: TInner): Boolean
      begin
        Result := TComparer<TKey>.Default.Compare(LOuterKey, FInnerKeySelector(Item)) = 0;
      end);
    LWrapper := TFluentWrapper<TInner>.Create(LMatches, nil);
    FCurrent := FResultSelector(FSource.Current, LWrapper);
    Result := True;
  end
  else
    Result := False;
end;

procedure TFluentGroupJoinEnumerator<T, TInner, TKey, TResult>.Reset;
begin
  FSource.Reset;
end;

{ TFluentExcludeEnumerable<T> }

constructor TFluentExcludeEnumerable<T>.Create(const ASource: IFluentEnumerableBase<T>;
  const ASecond: IFluentEnumerableBase<T>; const AComparer: IEqualityComparer<T>);
begin
  FSource := ASource;
  FSecond := ASecond;
  FComparer := AComparer;
end;

function TFluentExcludeEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TFluentExcludeEnumerator<T>.Create(FSource.GetEnumerator, FSecond.GetEnumerator, FComparer);
end;

{ TFluentExcludeEnumerator<T> }

constructor TFluentExcludeEnumerator<T>.Create(const ASource: IFluentEnumerator<T>;
  const ASecond: IFluentEnumerator<T>; const AComparer: IEqualityComparer<T>);
begin
  FSource := ASource;
  FComparer := AComparer;
  FSecond := TDictionary<T, Boolean>.Create(FComparer);
  while ASecond.MoveNext do
    FSecond.Add(ASecond.Current, True);
end;

destructor TFluentExcludeEnumerator<T>.Destroy;
begin
  FSecond.Free;
  inherited;
end;

function TFluentExcludeEnumerator<T>.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TFluentExcludeEnumerator<T>.ContainsValue(const AValue: T): Boolean;
var
  LKey: T;
begin
  for LKey in FSecond.Keys do
    if FComparer.Equals(LKey, AValue) then
      Exit(True);
  Result := False;
end;

function TFluentExcludeEnumerator<T>.MoveNext: Boolean;
begin
  while FSource.MoveNext do
  begin
    FCurrent := FSource.Current;
    if not ContainsValue(FCurrent) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure TFluentExcludeEnumerator<T>.Reset;
begin
  FSource.Reset;
end;

{ TFluentIntersectEnumerable<T> }

constructor TFluentIntersectEnumerable<T>.Create(const ASource: IFluentEnumerableBase<T>;
  const ASecond: IFluentEnumerableBase<T>; const AComparer: IEqualityComparer<T>);
begin
  FSource := ASource;
  FSecond := ASecond;
  FComparer := AComparer;
end;

function TFluentIntersectEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TFluentIntersectEnumerator<T>.Create(FSource.GetEnumerator, FSecond.GetEnumerator, FComparer);
end;

{ TFluentIntersectEnumerator<T> }

constructor TFluentIntersectEnumerator<T>.Create(const ASource: IFluentEnumerator<T>;
  const ASecond: IFluentEnumerator<T>; const AComparer: IEqualityComparer<T>);
begin
  FSource := ASource;
  FComparer := AComparer;
  FSecond := TDictionary<T, Boolean>.Create(FComparer);
  while ASecond.MoveNext do
    FSecond.Add(ASecond.Current, True);
end;

destructor TFluentIntersectEnumerator<T>.Destroy;
begin
  FSecond.Free;
  inherited;
end;

function TFluentIntersectEnumerator<T>.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TFluentIntersectEnumerator<T>.ContainsValue(const AValue: T): Boolean;
var
  LKey: T;
begin
  for LKey in FSecond.Keys do
    if FComparer.Equals(LKey, AValue) then
      Exit(True);
  Result := False;
end;

function TFluentIntersectEnumerator<T>.MoveNext: Boolean;
begin
  while FSource.MoveNext do
  begin
    FCurrent := FSource.Current;
    if ContainsValue(FCurrent) then
    begin
      FSecond.Remove(FCurrent);
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure TFluentIntersectEnumerator<T>.Reset;
begin
  FSource.Reset;
end;

{ TFluentUnionEnumerable<T> }

constructor TFluentUnionEnumerable<T>.Create(const ASource: IFluentEnumerableBase<T>;
  const ASecond: IFluentEnumerableBase<T>; const AComparer: IEqualityComparer<T>);
begin
  FSource := ASource;
  FSecond := ASecond;
  FComparer := AComparer;
end;

function TFluentUnionEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TFluentUnionEnumerator<T>.Create(FSource.GetEnumerator, FSecond.GetEnumerator, FComparer);
end;

{ TFluentUnionEnumerator<T> }

constructor TFluentUnionEnumerator<T>.Create(const ASource: IFluentEnumerator<T>;
  const ASecond: IFluentEnumerator<T>; const AComparer: IEqualityComparer<T>);
begin
  FSource := ASource;
  FSecond := ASecond;
  FComparer := AComparer;
  FSet := TDictionary<T, Boolean>.Create(FComparer);
  FOnSecond := False;
end;

destructor TFluentUnionEnumerator<T>.Destroy;
begin
  FSet.Free;
  inherited;
end;

function TFluentUnionEnumerator<T>.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TFluentUnionEnumerator<T>.ContainsValue(const AValue: T): Boolean;
var
  LKey: T;
begin
  for LKey in FSet.Keys do
    if FComparer.Equals(LKey, AValue) then
      Exit(True);
  Result := False;
end;

function TFluentUnionEnumerator<T>.MoveNext: Boolean;
begin
  while True do
  begin
    if not FOnSecond then
    begin
      if FSource.MoveNext then
      begin
        FCurrent := FSource.Current;
        if not ContainsValue(FCurrent) then
        begin
          FSet.Add(FCurrent, True);
          Result := True;
          Exit;
        end;
      end
      else
        FOnSecond := True;
    end
    else if FSecond.MoveNext then
    begin
      FCurrent := FSecond.Current;
      if not ContainsValue(FCurrent) then
      begin
        FSet.Add(FCurrent, True);
        Result := True;
        Exit;
      end;
    end
    else
      Exit(False);
  end;
end;

procedure TFluentUnionEnumerator<T>.Reset;
begin
  FSource.Reset;
  FSecond.Reset;
  FSet.Clear;
  FOnSecond := False;
end;

// TFluentConcatEnumerable<T>
constructor TFluentConcatEnumerable<T>.Create(const ASource: IFluentEnumerableBase<T>;
  const ASecond: IFluentEnumerableBase<T>);
begin
  FSource := ASource;
  FSecond := ASecond;
end;

function TFluentConcatEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TFluentConcatEnumerator<T>.Create(FSource.GetEnumerator, FSecond.GetEnumerator);
end;

// TFluentConcatEnumerator<T>
constructor TFluentConcatEnumerator<T>.Create(const ASource: IFluentEnumerator<T>; const ASecond: IFluentEnumerator<T>);
begin
  FSource := ASource;
  FSecond := ASecond;
  FOnSecond := False;
end;

function TFluentConcatEnumerator<T>.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TFluentConcatEnumerator<T>.MoveNext: Boolean;
begin
  if not FOnSecond then
  begin
    if FSource.MoveNext then
    begin
      FCurrent := FSource.Current;
      Result := True;
      Exit;
    end
    else
      FOnSecond := True;
  end;
  if FSecond.MoveNext then
  begin
    FCurrent := FSecond.Current;
    Result := True;
    Exit;
  end;
  Result := False;
end;

procedure TFluentConcatEnumerator<T>.Reset;
begin
  FSource.Reset;
  FSecond.Reset;
  FOnSecond := False;
end;

{ TFluentTeeEnumerable<T> }

constructor TFluentTeeEnumerable<T>.Create(const ASource: IFluentEnumerableBase<T>; ACount: Integer);
var
  LEnum: IFluentEnumerator<T>;
  LList: TList<T>;
  I: Integer;
  J: Integer;
begin
  FSource := ASource;
  FCount := ACount;
  FPopulated := False;
  LList := TList<T>.Create;
  try
    LEnum := FSource.GetEnumerator;
    while LEnum.MoveNext do
      LList.Add(LEnum.Current);
    if FCount > 1 then
    begin
      for I := 1 to FCount - 1 do
        for J := 0 to LList.Count - 1 do
          LList.Add(LList[J]);
    end;
    FItems := LList.ToArray;
    FPopulated := True;
  finally
    LList.Free;
  end;
end;

function TFluentTeeEnumerable<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  if not FPopulated then
    raise EInvalidOperation.Create('Tee items should already be populated in constructor');
  Result := TFluentTeeEnumerator<T>.Create(FItems);
end;

{ TFluentTeeEnumerator<T> }

constructor TFluentTeeEnumerator<T>.Create(const AItems: TArray<T>);
begin
  FItems := AItems;
  FIndex := -1;
end;

function TFluentTeeEnumerator<T>.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TFluentTeeEnumerator<T>.MoveNext: Boolean;
begin
  Inc(FIndex);
  if FIndex < Length(FItems) then
  begin
    FCurrent := FItems[FIndex];
    Result := True;
  end
  else
    Result := False;
end;

procedure TFluentTeeEnumerator<T>.Reset;
begin
  FIndex := -1;
end;

end.
