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

unit Fluent.Collections;

interface

uses
  Types,
  TypInfo,
  SysUtils,
  Generics.Collections,
  Generics.Defaults,
  Fluent.Core,
  Fluent.Adapters;

type
  IFluentArray<T> = interface(IInterface)
    ['{E3DF6D61-1A52-466E-8B16-CF7AAC574A02}']
    function AsEnumerable: IFluentEnumerable<T>;
  end;

  TFluentArray<T> = class(TInterfacedObject, IFluentArray<T>)
  private
    FArray: TArray<T>;
    FOwnsArray: Boolean;
    function GetEnumerable: IFluentEnumerable<T>;
  public
    constructor Create(const AArray: TArray<T>; AOwnsArray: Boolean = False);
    destructor Destroy; override;
    class function From(const AArray: TArray<T>): IFluentEnumerable<T>; overload; static;
    class function From(const AList: TList<T>): IFluentEnumerable<T>; overload; static;
    procedure SetItems(const AItems: TArray<T>);
    function AsEnumerable: IFluentEnumerable<T>;
    property ArrayData: TArray<T> read FArray;
  end;

  TFluentArray = record
  public
    class procedure FreeValues<T>(const Values: array of T); overload; static;
    class procedure FreeValues<T>(var Values: TArray<T>); overload; static;
    class procedure Sort<T>(var Values: array of T); overload; static;
    class procedure Sort<T>(var Values: array of T; const Comparer: IComparer<T>); overload; static;
    class procedure Sort<T>(var Values: array of T; const Comparer: IComparer<T>; Index, Count: NativeInt); overload; static;
    class function From<T>(const AArray: array of T): IFluentEnumerable<T>; static;
    class function BinarySearch<T>(const Values: array of T; const Item: T; out FoundIndex: NativeInt; const Comparer: IComparer<T>; Index, Count: NativeInt): Boolean; overload; static;
    class function BinarySearch<T>(const Values: array of T; const Item: T; out FoundIndex: NativeInt; const Comparer: IComparer<T>): Boolean; overload; static;
    class function BinarySearch<T>(const Values: array of T; const Item: T; out FoundIndex: NativeInt): Boolean; overload; static;
{$IF Defined(CPU64BITS)}
    class function BinarySearch<T>(const Values: array of T; const Item: T; out FoundIndex: Integer; const Comparer: IComparer<T>; Index, Count: Integer): Boolean; overload; static;
    class function BinarySearch<T>(const Values: array of T; const Item: T; out FoundIndex: Integer; const Comparer: IComparer<T>): Boolean; overload; static;
    class function BinarySearch<T>(const Values: array of T; const Item: T; out FoundIndex: Integer): Boolean; overload; static;
{$ENDIF CPU64BITS}
    class procedure Copy<T>(const Source: array of T; var Destination: array of T; SourceIndex, DestIndex, Count: NativeInt); overload; static;
    class procedure Copy<T>(const Source: array of T; var Destination: array of T; Count: NativeInt); overload; static;
    class function Concat<T>(const Args: array of TArray<T>): TArray<T>; static;
    class function IndexOf<T>(const Values: array of T; const Item: T): NativeInt; overload; static;
    class function IndexOf<T>(const Values: array of T; const Item: T; Index: NativeInt): NativeInt; overload; static;
    class function IndexOf<T>(const Values: array of T; const Item: T; const Comparer: IComparer<T>; Index, Count: NativeInt): NativeInt; overload; static;
    class function LastIndexOf<T>(const Values: array of T; const Item: T): NativeInt; overload; static;
    class function LastIndexOf<T>(const Values: array of T; const Item: T; Index: NativeInt): NativeInt; overload; static;
    class function LastIndexOf<T>(const Values: array of T; const Item: T; const Comparer: IComparer<T>; Index, Count: NativeInt): NativeInt; overload; static;
    class function Contains<T>(const Values: array of T; const Item: T): Boolean; overload; static;
    class function Contains<T>(const Values: array of T; const Item: T; const Comparer: IComparer<T>): Boolean; overload; static;
    class function ToString<T>(const Values: array of T; const AFormatSettings: TFormatSettings; const ASeparator: string = ','; const ADelim1: string = ''; const ADelim2: string = ''): string; reintroduce; overload; static;
    class function ToString<T>(const Values: array of T; const ASeparator: string = ','; const ADelim1: string = ''; const ADelim2: string = ''): string; reintroduce; overload; static;
  end;

  IFluentList<T> = interface(IInterface)
    ['{2749C02A-9973-4747-A4D3-29376DFD6242}']
    function GetCapacity: NativeInt;
    procedure SetCapacity(Value: NativeInt);
    function GetCount: NativeInt;
    procedure SetCount(Value: NativeInt);
    function GetIsEmpty: Boolean;
    function GetItem(Index: NativeInt): T;
    procedure SetItem(Index: NativeInt; const Value: T);
    function GetList: TArray<T>;
    function GetComparer: IComparer<T>;
    procedure SetOnNotify(const Value: TCollectionNotifyEvent<T>);
    function GetOnNotify: TCollectionNotifyEvent<T>;
    //
    procedure AddRange(const Values: array of T); overload;
    procedure AddRange(const Collection: IEnumerable<T>); overload;
    procedure AddRange(const Collection: TEnumerable<T>); overload;
    procedure Insert(Index: NativeInt; const Value: T);
    procedure InsertRange(Index: NativeInt; const Values: array of T; Count: NativeInt); overload;
    procedure InsertRange(Index: NativeInt; const Values: array of T); overload;
    procedure InsertRange(Index: NativeInt; const Collection: IEnumerable<T>); overload;
    procedure InsertRange(Index: NativeInt; const Collection: TEnumerable<T>); overload;
    procedure Pack;
    procedure Delete(Index: NativeInt);
    procedure DeleteRange(AIndex, ACount: NativeInt);
    procedure Exchange(Index1, Index2: NativeInt);
    procedure Move(CurIndex, NewIndex: NativeInt);
    procedure Clear;
    procedure Reverse;
    procedure Sort; overload;
    procedure Sort(const AComparer: IComparer<T>); overload;
    procedure Sort(const AComparer: IComparer<T>; Index, Count: NativeInt); overload;
    procedure TrimExcess;
    function Add(const Value: T): NativeInt;
    function Remove(const Value: T): NativeInt;
    function RemoveItem(const Value: T; Direction: TDirection): NativeInt;
    function ExtractItem(const Value: T; Direction: TDirection): T;
    function Extract(const Value: T): T;
    function ExtractAt(Index: NativeInt): T;
    function First: T;
    function Last: T;
    function Expand: IFluentList<T>;
    function Contains(const Value: T): Boolean;
    function IndexOf(const Value: T): NativeInt;
    function IndexOfItem(const Value: T; Direction: TDirection): NativeInt;
    function LastIndexOf(const Value: T): NativeInt;
    function BinarySearch(const Item: T; out FoundIndex: NativeInt): Boolean; overload;
    function BinarySearch(const Item: T; out FoundIndex: NativeInt; const AComparer: IComparer<T>): Boolean; overload;
    function BinarySearch(const Item: T; out FoundIndex: NativeInt; const AComparer: IComparer<T>; Index, Count: NativeInt): Boolean; overload;
{$IF Defined(CPU64BITS)}
    function BinarySearch(const Item: T; out FoundIndex: Integer): Boolean; overload;
    function BinarySearch(const Item: T; out FoundIndex: Integer; const AComparer: IComparer<T>): Boolean; overload;
    function BinarySearch(const Item: T; out FoundIndex: Integer; const AComparer: IComparer<T>; Index, Count: Integer): Boolean; overload;
{$ENDIF}
    function ToArray: TArray<T>;
    function AsEnumerable: IFluentEnumerable<T>;
    property Capacity: NativeInt read GetCapacity write SetCapacity;
    property Count: NativeInt read GetCount write SetCount;
    property IsEmpty: Boolean read GetIsEmpty;
    property Items[Index: NativeInt]: T read GetItem write SetItem; default;
    property List: TArray<T> read GetList;
    property Comparer: IComparer<T> read GetComparer;
    property OnNotify: TCollectionNotifyEvent<T> read GetOnNotify write SetOnNotify;
  end;

  TFluentList<T> = class(TInterfacedObject, IFluentList<T>)
  private
    FList: TList<T>;
    FOwnsList: Boolean;
    FOnNotify: TCollectionNotifyEvent<T>;
    function GetEnumerable: IFluentEnumerable<T>;
    function GetCapacity: NativeInt;
    procedure SetCapacity(Value: NativeInt);
    function GetCount: NativeInt;
    procedure SetCount(Value: NativeInt);
    function GetIsEmpty: Boolean;
    function GetItem(Index: NativeInt): T;
    procedure SetItem(Index: NativeInt; const Value: T);
    function GetList: TArray<T>;
    function GetComparer: IComparer<T>;
    procedure SetOnNotify(const Value: TCollectionNotifyEvent<T>);
    function GetOnNotify: TCollectionNotifyEvent<T>;
  public type
    TEmptyFunc = reference to function (const L, R: T): Boolean;
  public
    class function From(const AList: TList<T>): IFluentEnumerable<T>; overload; static;
    class function From(const AArray: TArray<T>): IFluentEnumerable<T>; overload; static;
    class procedure Error(const Msg: string; Data: NativeInt); overload; virtual;
{$IFNDEF NEXTGEN}
    class procedure Error(Msg: PResStringRec; Data: NativeInt); overload;
{$ENDIF}
    constructor Create; overload;
    constructor Create(const AComparer: IComparer<T>); overload;
    constructor Create(const Collection: TEnumerable<T>); overload;
    constructor Create(const Collection: IEnumerable<T>); overload;
    constructor Create(const Values: array of T); overload;
    constructor Create(const AList: TList<T>; AOwnsList: Boolean = False); overload;
    destructor Destroy; override;
    procedure AddRange(const Values: array of T); overload;
    procedure AddRange(const Collection: IEnumerable<T>); overload;
    procedure AddRange(const Collection: TEnumerable<T>); overload;
    procedure Insert(Index: NativeInt; const Value: T);
    procedure InsertRange(Index: NativeInt; const Values: array of T; Count: NativeInt); overload;
    procedure InsertRange(Index: NativeInt; const Values: array of T); overload;
    procedure InsertRange(Index: NativeInt; const Collection: IEnumerable<T>); overload;
    procedure InsertRange(Index: NativeInt; const Collection: TEnumerable<T>); overload;
    procedure Pack;
    procedure Delete(Index: NativeInt);
    procedure DeleteRange(AIndex, ACount: NativeInt);
    procedure Exchange(Index1, Index2: NativeInt);
    procedure Move(CurIndex, NewIndex: NativeInt);
    procedure Clear;
    procedure Reverse;
    procedure Sort; overload;
    procedure Sort(const AComparer: IComparer<T>); overload;
    procedure Sort(const AComparer: IComparer<T>; Index, Count: NativeInt); overload;
    procedure TrimExcess;
    function Add(const Value: T): NativeInt;
    function Remove(const Value: T): NativeInt;
    function RemoveItem(const Value: T; Direction: TDirection): NativeInt;
    function ExtractItem(const Value: T; Direction: TDirection): T;
    function Extract(const Value: T): T;
    function ExtractAt(Index: NativeInt): T;
    function First: T;
    function Last: T;
    function Expand: IFluentList<T>;
    function Contains(const Value: T): Boolean;
    function IndexOf(const Value: T): NativeInt;
    function IndexOfItem(const Value: T; Direction: TDirection): NativeInt;
    function LastIndexOf(const Value: T): NativeInt;
    function BinarySearch(const Item: T; out FoundIndex: NativeInt): Boolean; overload;
    function BinarySearch(const Item: T; out FoundIndex: NativeInt; const AComparer: IComparer<T>): Boolean; overload;
    function BinarySearch(const Item: T; out FoundIndex: NativeInt; const AComparer: IComparer<T>; Index, Count: NativeInt): Boolean; overload;
{$IF Defined(CPU64BITS)}
    function BinarySearch(const Item: T; out FoundIndex: Integer): Boolean; overload;
    function BinarySearch(const Item: T; out FoundIndex: Integer; const AComparer: IComparer<T>): Boolean; overload;
    function BinarySearch(const Item: T; out FoundIndex: Integer; const AComparer: IComparer<T>; Index, Count: Integer): Boolean; overload;
{$ENDIF}
    function ToArray: TArray<T>;
    function AsEnumerable: IFluentEnumerable<T>;
    property Capacity: NativeInt read GetCapacity write SetCapacity;
    property Count: NativeInt read GetCount write SetCount;
    property IsEmpty: Boolean read GetIsEmpty;
    property Items[Index: NativeInt]: T read GetItem write SetItem; default;
    property List: TArray<T> read GetList;
    property Comparer: IComparer<T> read GetComparer;
    property OnNotify: TCollectionNotifyEvent<T> read GetOnNotify write SetOnNotify;
  end;

  IFluentDictionary<K, V> = interface(IInterface)
    ['{CF242859-D62D-4277-91B3-D4E389793E7C}']
    procedure SetCapacity(Value: NativeInt);
    procedure SetItem(const Key: K; const Value: V);
    procedure SetOnKeyNotify(const Value: TCollectionNotifyEvent<K>);
    procedure SetOnValueNotify(const Value: TCollectionNotifyEvent<V>);
    function GetCapacity: NativeInt;
    function GetItem(const Key: K): V;
    function GetCount: NativeInt;
    function GetIsEmpty: Boolean;
    function GetGrowThreshold: NativeInt;
    function GetCollisions: NativeInt;
    function GetKeys: TDictionary<K, V>.TKeyCollection;
    function GetValues: TDictionary<K, V>.TValueCollection;
    function GetComparer: IEqualityComparer<K>;
    function GetOnKeyNotify: TCollectionNotifyEvent<K>;
    function GetOnValueNotify: TCollectionNotifyEvent<V>;
    //
    procedure Add(const Key: K; const Value: V);
    procedure AddRange(const ADictionary: TDictionary<K, V>); overload;
    procedure AddRange(const AItems: TEnumerable<TPair<K, V>>); overload;
    procedure Remove(const Key: K);
    procedure Clear;
    procedure TrimExcess;
    procedure AddOrSetValue(const Key: K; const Value: V);
    function ExtractPair(const Key: K): TPair<K, V>;
    function TryGetValue(const Key: K; var Value: V): Boolean;
    function TryAdd(const Key: K; const Value: V): Boolean;
    function ContainsKey(const Key: K): Boolean;
    function ContainsValue(const Value: V): Boolean;
    function ToArray: TArray<TPair<K, V>>;
    function AsEnumerable: IFluentEnumerable<TPair<K, V>>;
    property Count: NativeInt read GetCount;
    property IsEmpty: Boolean read GetIsEmpty;
    property GrowThreshold: NativeInt read GetGrowThreshold;
    property Collisions: NativeInt read GetCollisions;
    property Keys: TDictionary<K, V>.TKeyCollection read GetKeys;
    property Values: TDictionary<K, V>.TValueCollection read GetValues;
    property Comparer: IEqualityComparer<K> read GetComparer;
    property Items[const Key: K]: V read GetItem write SetItem; default;
    property OnKeyNotify: TCollectionNotifyEvent<K> read GetOnKeyNotify write SetOnKeyNotify;
    property OnValueNotify: TCollectionNotifyEvent<V> read GetOnValueNotify write SetOnValueNotify;
  end;

  TFluentDictionary<K, V> = class(TInterfacedObject, IFluentDictionary<K, V>)
  private
    FDict: TDictionary<K, V>;
    FOwnsDict: Boolean;
    FOnKeyNotify: TCollectionNotifyEvent<K>;
    FOnValueNotify: TCollectionNotifyEvent<V>;
    function GetEnumerable: IFluentEnumerable<TPair<K, V>>;
    function GetCapacity: NativeInt;
    function GetItem(const Key: K): V;
    function GetCount: NativeInt;
    function GetIsEmpty: Boolean;
    function GetGrowThreshold: NativeInt;
    function GetCollisions: NativeInt;
    function GetKeys: TDictionary<K, V>.TKeyCollection;
    function GetValues: TDictionary<K, V>.TValueCollection;
    function GetComparer: IEqualityComparer<K>;
    function GetOnKeyNotify: TCollectionNotifyEvent<K>;
    function GetOnValueNotify: TCollectionNotifyEvent<V>;
    procedure SetCapacity(Value: NativeInt);
    procedure SetItem(const Key: K; const Value: V);
    procedure SetOnKeyNotify(const Value: TCollectionNotifyEvent<K>);
    procedure SetOnValueNotify(const Value: TCollectionNotifyEvent<V>);
  public
    class function From(const ADict: TDictionary<K, V>): IFluentEnumerable<TPair<K, V>>; overload; static;
    class function From(const AArray: TArray<TPair<K, V>>): IFluentEnumerable<TPair<K, V>>; overload; static;
    constructor Create; overload;
    constructor Create(ACapacity: NativeInt); overload;
    constructor Create(const AComparer: IEqualityComparer<K>); overload;
    constructor Create(ACapacity: NativeInt; const AComparer: IEqualityComparer<K>); overload;
    constructor Create(const Collection: TEnumerable<TPair<K, V>>); overload;
    constructor Create(const Collection: TEnumerable<TPair<K, V>>; const AComparer: IEqualityComparer<K>); overload;
    constructor Create(const AItems: array of TPair<K, V>); overload;
    constructor Create(const AItems: array of TPair<K, V>; const AComparer: IEqualityComparer<K>); overload;
    constructor Create(const ADict: TDictionary<K, V>; AOwnsDict: Boolean = False); overload;
    destructor Destroy; override;
    procedure Add(const Key: K; const Value: V);
    procedure AddRange(const ADictionary: TDictionary<K, V>); overload;
    procedure AddRange(const AItems: TEnumerable<TPair<K, V>>); overload;
    procedure Remove(const Key: K);
    procedure Clear;
    procedure TrimExcess;
    procedure AddOrSetValue(const Key: K; const Value: V);
    function ExtractPair(const Key: K): TPair<K, V>;
    function TryGetValue(const Key: K; var Value: V): Boolean;
    function TryAdd(const Key: K; const Value: V): Boolean;
    function ContainsKey(const Key: K): Boolean;
    function ContainsValue(const Value: V): Boolean;
    function ToArray: TArray<TPair<K, V>>;
    function AsEnumerable: IFluentEnumerable<TPair<K, V>>;
    property Capacity: NativeInt read GetCapacity write SetCapacity;
    property Items[const Key: K]: V read GetItem write SetItem; default;
    property Count: NativeInt read GetCount;
    property IsEmpty: Boolean read GetIsEmpty;
    property GrowThreshold: NativeInt read GetGrowThreshold;
    property Collisions: NativeInt read GetCollisions;
    property Keys: TDictionary<K, V>.TKeyCollection read GetKeys;
    property Values: TDictionary<K, V>.TValueCollection read GetValues;
    property Comparer: IEqualityComparer<K> read GetComparer;
    property Items[const Key: K]: V read GetItem write SetItem; default;
    property OnKeyNotify: TCollectionNotifyEvent<K> read GetOnKeyNotify write SetOnKeyNotify;
    property OnValueNotify: TCollectionNotifyEvent<V> read GetOnValueNotify write SetOnValueNotify;
  end;

implementation

{ TFluentArray<T> }

function TFluentArray<T>.AsEnumerable: IFluentEnumerable<T>;
begin
  Result := GetEnumerable;
end;

constructor TFluentArray<T>.Create(const AArray: TArray<T>; AOwnsArray: Boolean);
begin
  FArray := AArray;
  FOwnsArray := AOwnsArray;
end;

destructor TFluentArray<T>.Destroy;
begin
  if FOwnsArray then
    SetLength(FArray, 0);
  inherited;
end;

function TFluentArray<T>.GetEnumerable: IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(TArrayAdapter<T>.Create(FArray));
end;

procedure TFluentArray<T>.SetItems(const AItems: TArray<T>);
begin
  FArray := Copy(AItems, 0, Length(AItems));
end;

class function TFluentArray<T>.From(const AArray: TArray<T>): IFluentEnumerable<T>;
begin
  Result := TFluentArray<T>.Create(AArray).GetEnumerable;
end;

class function TFluentArray<T>.From(const AList: TList<T>): IFluentEnumerable<T>;
var
  LArray: TArray<T>;
begin
  if AList = nil then
    raise EArgumentNilException.Create('AList cannot be nil');
  LArray := AList.ToArray;
  Result := TFluentArray<T>.Create(LArray, True).GetEnumerable;
end;

{ TFluentArray }

class function TFluentArray.From<T>(const AArray: array of T): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(TNonGenericArrayAdapter<T>.Create(AArray));
end;

class procedure TFluentArray.Sort<T>(var Values: array of T);
begin
  TArray.Sort<T>(Values);
end;

class procedure TFluentArray.Sort<T>(var Values: array of T; const Comparer: IComparer<T>);
begin
  TArray.Sort<T>(Values, Comparer);
end;

class procedure TFluentArray.Sort<T>(var Values: array of T; const Comparer: IComparer<T>; Index, Count: NativeInt);
begin
  TArray.Sort<T>(Values, Comparer, Index, Count);
end;

class function TFluentArray.BinarySearch<T>(const Values: array of T; const Item: T; out FoundIndex: NativeInt; const Comparer: IComparer<T>; Index, Count: NativeInt): Boolean;
begin
  Result := TArray.BinarySearch<T>(Values, Item, FoundIndex, Comparer, Index, Count);
end;

class function TFluentArray.BinarySearch<T>(const Values: array of T; const Item: T; out FoundIndex: NativeInt; const Comparer: IComparer<T>): Boolean;
begin
  Result := TArray.BinarySearch<T>(Values, Item, FoundIndex, Comparer);
end;

class function TFluentArray.BinarySearch<T>(const Values: array of T; const Item: T; out FoundIndex: NativeInt): Boolean;
begin
  Result := TArray.BinarySearch<T>(Values, Item, FoundIndex);
end;

{$IF Defined(CPU64BITS)}
class function TFluentArray.BinarySearch<T>(const Values: array of T; const Item: T; out FoundIndex: Integer; const Comparer: IComparer<T>; Index, Count: Integer): Boolean;
begin
  Result := TArray.BinarySearch<T>(Values, Item, FoundIndex, Comparer, Index, Count);
end;

class function TFluentArray.BinarySearch<T>(const Values: array of T; const Item: T; out FoundIndex: Integer; const Comparer: IComparer<T>): Boolean;
begin
  Result := TArray.BinarySearch<T>(Values, Item, FoundIndex, Comparer);
end;

class function TFluentArray.BinarySearch<T>(const Values: array of T; const Item: T; out FoundIndex: Integer): Boolean;
begin
  Result := TArray.BinarySearch<T>(Values, Item, FoundIndex);
end;
{$ENDIF CPU64BITS}

class procedure TFluentArray.Copy<T>(const Source: array of T; var Destination: array of T; SourceIndex, DestIndex, Count: NativeInt);
begin
  TArray.Copy<T>(Source, Destination, SourceIndex, DestIndex, Count);
end;

class procedure TFluentArray.Copy<T>(const Source: array of T; var Destination: array of T; Count: NativeInt);
begin
  TArray.Copy<T>(Source, Destination, Count);
end;

class function TFluentArray.Concat<T>(const Args: array of TArray<T>): TArray<T>;
begin
  Result := TArray.Concat<T>(Args);
end;

class function TFluentArray.IndexOf<T>(const Values: array of T; const Item: T): NativeInt;
begin
  Result := TArray.IndexOf<T>(Values, Item);
end;

class function TFluentArray.IndexOf<T>(const Values: array of T; const Item: T; Index: NativeInt): NativeInt;
begin
  Result := TArray.IndexOf<T>(Values, Item, Index);
end;

class function TFluentArray.IndexOf<T>(const Values: array of T; const Item: T; const Comparer: IComparer<T>; Index, Count: NativeInt): NativeInt;
begin
  Result := TArray.IndexOf<T>(Values, Item, Comparer, Index, Count);
end;

class function TFluentArray.LastIndexOf<T>(const Values: array of T; const Item: T): NativeInt;
begin
  Result := TArray.LastIndexOf<T>(Values, Item);
end;

class function TFluentArray.LastIndexOf<T>(const Values: array of T; const Item: T; Index: NativeInt): NativeInt;
begin
  Result := TArray.LastIndexOf<T>(Values, Item, Index);
end;

class function TFluentArray.LastIndexOf<T>(const Values: array of T; const Item: T; const Comparer: IComparer<T>; Index, Count: NativeInt): NativeInt;
begin
  Result := TArray.LastIndexOf<T>(Values, Item, Comparer, Index, Count);
end;

class function TFluentArray.Contains<T>(const Values: array of T; const Item: T): Boolean;
begin
  Result := TArray.Contains<T>(Values, Item);
end;

class function TFluentArray.Contains<T>(const Values: array of T; const Item: T; const Comparer: IComparer<T>): Boolean;
begin
  Result := TArray.Contains<T>(Values, Item, Comparer);
end;

class procedure TFluentArray.FreeValues<T>(const Values: array of T);
begin
  TArray.FreeValues<T>(Values);
end;

class procedure TFluentArray.FreeValues<T>(var Values: TArray<T>);
begin
  TArray.FreeValues<T>(Values);
end;

class function TFluentArray.ToString<T>(const Values: array of T; const AFormatSettings: TFormatSettings; const ASeparator: string = ','; const ADelim1: string = ''; const ADelim2: string = ''): string;
begin
  Result := TArray.ToString<T>(Values, AFormatSettings, ASeparator, ADelim1, ADelim2);
end;

class function TFluentArray.ToString<T>(const Values: array of T; const ASeparator: string = ','; const ADelim1: string = ''; const ADelim2: string = ''): string;
begin
  Result := TArray.ToString<T>(Values, ASeparator, ADelim1, ADelim2);
end;

{ TFluentList<T> }

constructor TFluentList<T>.Create;
begin
  FList := TList<T>.Create;
  FOwnsList := True;
end;

constructor TFluentList<T>.Create(const AComparer: IComparer<T>);
begin
  FList := TList<T>.Create(AComparer);
  FOwnsList := True;
end;

constructor TFluentList<T>.Create(const Collection: TEnumerable<T>);
begin
  FList := TList<T>.Create(Collection);
  FOwnsList := True;
end;

constructor TFluentList<T>.Create(const Collection: IEnumerable<T>);
begin
  FList := TList<T>.Create(Collection);
  FOwnsList := True;
end;

constructor TFluentList<T>.Create(const Values: array of T);
begin
  FList := TList<T>.Create;
  FOwnsList := True;
  AddRange(Values);
end;

constructor TFluentList<T>.Create(const AList: TList<T>; AOwnsList: Boolean);
begin
  if AList = nil then
    raise EArgumentNilException.Create('AList cannot be nil');
  FList := AList;
  FOwnsList := AOwnsList;
end;

destructor TFluentList<T>.Destroy;
begin
  if FOwnsList then
    FList.Free;
  inherited;
end;

class procedure TFluentList<T>.Error(const Msg: string; Data: NativeInt);
begin
  TList<T>.Error(Msg, Data);
end;

{$IFNDEF NEXTGEN}
class procedure TFluentList<T>.Error(Msg: PResStringRec; Data: NativeInt);
begin
  TList<T>.Error(Msg, Data);
end;
{$ENDIF}

function TFluentList<T>.Add(const Value: T): NativeInt;
begin
  Result := FList.Add(Value);
end;

procedure TFluentList<T>.AddRange(const Values: array of T);
begin
  FList.AddRange(Values);
end;

procedure TFluentList<T>.AddRange(const Collection: IEnumerable<T>);
begin
  FList.AddRange(Collection);
end;

procedure TFluentList<T>.AddRange(const Collection: TEnumerable<T>);
begin
  FList.AddRange(Collection);
end;

procedure TFluentList<T>.Insert(Index: NativeInt; const Value: T);
begin
  FList.Insert(Index, Value);
end;

procedure TFluentList<T>.InsertRange(Index: NativeInt; const Values: array of T; Count: NativeInt);
begin
  FList.InsertRange(Index, Values, Count);
end;

procedure TFluentList<T>.InsertRange(Index: NativeInt; const Values: array of T);
begin
  FList.InsertRange(Index, Values);
end;

procedure TFluentList<T>.InsertRange(Index: NativeInt; const Collection: IEnumerable<T>);
begin
  FList.InsertRange(Index, Collection);
end;

procedure TFluentList<T>.InsertRange(Index: NativeInt; const Collection: TEnumerable<T>);
begin
  FList.InsertRange(Index, Collection);
end;

procedure TFluentList<T>.Pack;
begin
  FList.Pack;
end;

function TFluentList<T>.Remove(const Value: T): NativeInt;
begin
  Result := FList.Remove(Value);
end;

function TFluentList<T>.RemoveItem(const Value: T; Direction: TDirection): NativeInt;
begin
  Result := FList.RemoveItem(Value, Direction);
end;

procedure TFluentList<T>.Delete(Index: NativeInt);
begin
  FList.Delete(Index);
end;

procedure TFluentList<T>.DeleteRange(AIndex, ACount: NativeInt);
begin
  FList.DeleteRange(AIndex, ACount);
end;

function TFluentList<T>.ExtractItem(const Value: T; Direction: TDirection): T;
begin
  Result := FList.ExtractItem(Value, Direction);
end;

function TFluentList<T>.Extract(const Value: T): T;
begin
  Result := FList.Extract(Value);
end;

function TFluentList<T>.ExtractAt(Index: NativeInt): T;
begin
  Result := FList.ExtractAt(Index);
end;

procedure TFluentList<T>.Exchange(Index1, Index2: NativeInt);
begin
  FList.Exchange(Index1, Index2);
end;

procedure TFluentList<T>.Move(CurIndex, NewIndex: NativeInt);
begin
  FList.Move(CurIndex, NewIndex);
end;

function TFluentList<T>.First: T;
begin
  Result := FList.First;
end;

function TFluentList<T>.Last: T;
begin
  Result := FList.Last;
end;

procedure TFluentList<T>.Clear;
begin
  FList.Clear;
end;

function TFluentList<T>.Expand: IFluentList<T>;
begin
  FList.Expand;
  Result := Self;
end;

function TFluentList<T>.Contains(const Value: T): Boolean;
begin
  Result := FList.Contains(Value);
end;

function TFluentList<T>.IndexOf(const Value: T): NativeInt;
begin
  Result := FList.IndexOf(Value);
end;

function TFluentList<T>.IndexOfItem(const Value: T; Direction: TDirection): NativeInt;
begin
  Result := FList.IndexOfItem(Value, Direction);
end;

function TFluentList<T>.LastIndexOf(const Value: T): NativeInt;
begin
  Result := FList.LastIndexOf(Value);
end;

procedure TFluentList<T>.Reverse;
begin
  FList.Reverse;
end;

procedure TFluentList<T>.Sort;
begin
  FList.Sort;
end;

procedure TFluentList<T>.Sort(const AComparer: IComparer<T>);
begin
  FList.Sort(AComparer);
end;

procedure TFluentList<T>.Sort(const AComparer: IComparer<T>; Index, Count: NativeInt);
begin
  FList.Sort(AComparer, Index, Count);
end;

function TFluentList<T>.BinarySearch(const Item: T; out FoundIndex: NativeInt): Boolean;
begin
  Result := FList.BinarySearch(Item, FoundIndex);
end;

function TFluentList<T>.BinarySearch(const Item: T; out FoundIndex: NativeInt; const AComparer: IComparer<T>): Boolean;
begin
  Result := FList.BinarySearch(Item, FoundIndex, AComparer);
end;

function TFluentList<T>.BinarySearch(const Item: T; out FoundIndex: NativeInt; const AComparer: IComparer<T>; Index, Count: NativeInt): Boolean;
begin
  Result := FList.BinarySearch(Item, FoundIndex, AComparer, Index, Count);
end;

{$IF Defined(CPU64BITS)}
function TFluentList<T>.BinarySearch(const Item: T; out FoundIndex: Integer): Boolean;
begin
  Result := FList.BinarySearch(Item, FoundIndex);
end;

function TFluentList<T>.BinarySearch(const Item: T; out FoundIndex: Integer; const AComparer: IComparer<T>): Boolean;
begin
  Result := FList.BinarySearch(Item, FoundIndex, AComparer);
end;

function TFluentList<T>.BinarySearch(const Item: T; out FoundIndex: Integer; const AComparer: IComparer<T>; Index, Count: Integer): Boolean;
begin
  Result := FList.BinarySearch(Item, FoundIndex, AComparer, Index, Count);
end;
{$ENDIF}

procedure TFluentList<T>.TrimExcess;
begin
  FList.TrimExcess;
end;

function TFluentList<T>.ToArray: TArray<T>;
begin
  Result := FList.ToArray;
end;

function TFluentList<T>.AsEnumerable: IFluentEnumerable<T>;
begin
  Result := GetEnumerable;
end;

function TFluentList<T>.GetEnumerable: IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(
    TListAdapter<T>.Create(FList, False),
    ftList,
    TEqualityComparer<T>.Default
  );
end;

//function TFluentList<T>.GetEnumerable: IFluentEnumerable<T>;
//begin
//  Result := IFluentEnumerable<T>.Create(TListAdapter<T>.Create(FList));
//end;

class function TFluentList<T>.From(const AList: TList<T>): IFluentEnumerable<T>;
begin
  Result := TFluentList<T>.Create(AList).GetEnumerable;
end;

class function TFluentList<T>.From(const AArray: TArray<T>): IFluentEnumerable<T>;
begin
  Result := IFluentEnumerable<T>.Create(TArrayAdapter<T>.Create(AArray));
end;

function TFluentList<T>.GetCapacity: NativeInt;
begin
  Result := FList.Capacity;
end;

procedure TFluentList<T>.SetCapacity(Value: NativeInt);
begin
  FList.Capacity := Value;
end;

function TFluentList<T>.GetCount: NativeInt;
begin
  Result := FList.Count;
end;

procedure TFluentList<T>.SetCount(Value: NativeInt);
begin
  FList.Count := Value;
end;

function TFluentList<T>.GetIsEmpty: Boolean;
begin
  Result := FList.IsEmpty;
end;

function TFluentList<T>.GetItem(Index: NativeInt): T;
begin
  Result := FList.Items[Index];
end;

procedure TFluentList<T>.SetItem(Index: NativeInt; const Value: T);
begin
  FList.Items[Index] := Value;
end;

function TFluentList<T>.GetList: TArray<T>;
begin
  Result := FList.List;
end;

function TFluentList<T>.GetOnNotify: TCollectionNotifyEvent<T>;
begin
  Result := FOnNotify;
end;

function TFluentList<T>.GetComparer: IComparer<T>;
begin
  Result := FList.Comparer;
end;

procedure TFluentList<T>.SetOnNotify(const Value: TCollectionNotifyEvent<T>);
begin
  FList.OnNotify := Value;
end;

{ TFluentDictionary<K, V> }

constructor TFluentDictionary<K, V>.Create;
begin
  FDict := TDictionary<K, V>.Create;
  FOwnsDict := True;
end;

constructor TFluentDictionary<K, V>.Create(ACapacity: NativeInt);
begin
  FDict := TDictionary<K, V>.Create(ACapacity);
  FOwnsDict := True;
end;

constructor TFluentDictionary<K, V>.Create(const AComparer: IEqualityComparer<K>);
begin
  FDict := TDictionary<K, V>.Create(AComparer);
  FOwnsDict := True;
end;

constructor TFluentDictionary<K, V>.Create(ACapacity: NativeInt; const AComparer: IEqualityComparer<K>);
begin
  FDict := TDictionary<K, V>.Create(ACapacity, AComparer);
  FOwnsDict := True;
end;

constructor TFluentDictionary<K, V>.Create(const Collection: TEnumerable<TPair<K, V>>);
begin
  FDict := TDictionary<K, V>.Create(Collection);
  FOwnsDict := True;
end;

constructor TFluentDictionary<K, V>.Create(const Collection: TEnumerable<TPair<K, V>>; const AComparer: IEqualityComparer<K>);
begin
  FDict := TDictionary<K, V>.Create(Collection, AComparer);
  FOwnsDict := True;
end;

constructor TFluentDictionary<K, V>.Create(const AItems: array of TPair<K, V>);
begin
  FDict := TDictionary<K, V>.Create(AItems);
  FOwnsDict := True;
end;

constructor TFluentDictionary<K, V>.Create(const AItems: array of TPair<K, V>; const AComparer: IEqualityComparer<K>);
begin
  FDict := TDictionary<K, V>.Create(AItems, AComparer);
  FOwnsDict := True;
end;

constructor TFluentDictionary<K, V>.Create(const ADict: TDictionary<K, V>; AOwnsDict: Boolean);
begin
  if ADict = nil then
    raise EArgumentNilException.Create('ADict cannot be nil');
  FDict := ADict;
  FOwnsDict := AOwnsDict;
end;

destructor TFluentDictionary<K, V>.Destroy;
begin
  if FOwnsDict then
    FDict.Free;
  inherited;
end;

procedure TFluentDictionary<K, V>.Add(const Key: K; const Value: V);
begin
  FDict.Add(Key, Value);
end;

procedure TFluentDictionary<K, V>.Remove(const Key: K);
begin
  FDict.Remove(Key);
end;

function TFluentDictionary<K, V>.ExtractPair(const Key: K): TPair<K, V>;
begin
  Result := FDict.ExtractPair(Key);
end;

procedure TFluentDictionary<K, V>.Clear;
begin
  FDict.Clear;
end;

procedure TFluentDictionary<K, V>.TrimExcess;
begin
  FDict.TrimExcess;
end;

function TFluentDictionary<K, V>.TryGetValue(const Key: K; var Value: V): Boolean;
begin
  Result := FDict.TryGetValue(Key, Value);
end;

procedure TFluentDictionary<K, V>.AddOrSetValue(const Key: K; const Value: V);
begin
  FDict.AddOrSetValue(Key, Value);
end;

procedure TFluentDictionary<K, V>.AddRange(const ADictionary: TDictionary<K, V>);
var
  Pair: TPair<K, V>;
begin
  for Pair in ADictionary do
    Add(Pair.Key, Pair.Value);
end;

procedure TFluentDictionary<K, V>.AddRange(const AItems: TEnumerable<TPair<K, V>>);
var
  Pair: TPair<K, V>;
begin
  for Pair in AItems do
    Add(Pair.Key, Pair.Value);
end;

function TFluentDictionary<K, V>.TryAdd(const Key: K; const Value: V): Boolean;
begin
  Result := FDict.TryAdd(Key, Value);
end;

function TFluentDictionary<K, V>.ContainsKey(const Key: K): Boolean;
begin
  Result := FDict.ContainsKey(Key);
end;

function TFluentDictionary<K, V>.ContainsValue(const Value: V): Boolean;
begin
  Result := FDict.ContainsValue(Value);
end;

function TFluentDictionary<K, V>.ToArray: TArray<TPair<K, V>>;
begin
  Result := FDict.ToArray;
end;

function TFluentDictionary<K, V>.AsEnumerable: IFluentEnumerable<TPair<K, V>>;
begin
  Result := GetEnumerable;
end;

function TFluentDictionary<K, V>.GetEnumerable: IFluentEnumerable<TPair<K, V>>;
begin
  Result := IFluentEnumerable<TPair<K, V>>.Create(
    TDictionaryAdapter<K, V>.Create(FDict),
    ftDictionary,
    TEqualityComparer<TPair<K, V>>.Construct(
      function(const Left, Right: TPair<K, V>): Boolean
      begin
        Result := (TComparer<K>.Default.Compare(Left.Key, Right.Key) = 0) and
                  (TComparer<V>.Default.Compare(Left.Value, Right.Value) = 0);
      end,
      function(const Value: TPair<K, V>): Integer
      begin
        Result := TEqualityComparer<K>.Default.GetHashCode(Value.Key) xor
                  TEqualityComparer<V>.Default.GetHashCode(Value.Value);
      end)
  );
end;

//function TFluentDictionary<K, V>.GetEnumerable: IFluentEnumerable<TPair<K, V>>;
//begin
//  Result := IFluentEnumerable<TPair<K, V>>.Create(TDictionaryAdapter<K, V>.Create(FDict));
//end;

class function TFluentDictionary<K, V>.From(const ADict: TDictionary<K, V>): IFluentEnumerable<TPair<K, V>>;
begin
  Result := TFluentDictionary<K, V>.Create(ADict).GetEnumerable;
end;

class function TFluentDictionary<K, V>.From(const AArray: TArray<TPair<K, V>>): IFluentEnumerable<TPair<K, V>>;
begin
  Result := TFluentDictionary<K, V>.Create(AArray).GetEnumerable;
end;

function TFluentDictionary<K, V>.GetCapacity: NativeInt;
begin
  Result := FDict.Capacity;
end;

procedure TFluentDictionary<K, V>.SetCapacity(Value: NativeInt);
begin
  FDict.Capacity := Value;
end;

function TFluentDictionary<K, V>.GetItem(const Key: K): V;
begin
  Result := FDict.Items[Key];
end;

procedure TFluentDictionary<K, V>.SetItem(const Key: K; const Value: V);
begin
  FDict.Items[Key] := Value;
end;

function TFluentDictionary<K, V>.GetCount: NativeInt;
begin
  Result := FDict.Count;
end;

function TFluentDictionary<K, V>.GetIsEmpty: Boolean;
begin
  Result := FDict.IsEmpty;
end;

function TFluentDictionary<K, V>.GetGrowThreshold: NativeInt;
begin
  Result := FDict.GrowThreshold;
end;

function TFluentDictionary<K, V>.GetCollisions: NativeInt;
begin
  Result := FDict.Collisions;
end;

function TFluentDictionary<K, V>.GetKeys: TDictionary<K, V>.TKeyCollection;
begin
  Result := FDict.Keys;
end;

function TFluentDictionary<K, V>.GetOnKeyNotify: TCollectionNotifyEvent<K>;
begin
  Result := FOnKeyNotify;
end;

function TFluentDictionary<K, V>.GetOnValueNotify: TCollectionNotifyEvent<V>;
begin
  Result := FOnValueNotify;
end;

function TFluentDictionary<K, V>.GetValues: TDictionary<K, V>.TValueCollection;
begin
  Result := FDict.Values;
end;

function TFluentDictionary<K, V>.GetComparer: IEqualityComparer<K>;
begin
  Result := FDict.Comparer;
end;

procedure TFluentDictionary<K, V>.SetOnKeyNotify(const Value: TCollectionNotifyEvent<K>);
begin
  FDict.OnKeyNotify := Value;
end;

procedure TFluentDictionary<K, V>.SetOnValueNotify(const Value: TCollectionNotifyEvent<V>);
begin
  FDict.OnValueNotify := Value;
end;

end.
