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

unit Fluent.Adapters;

interface

uses
  SysUtils,
  Generics.Collections,
  Fluent.Core;

type
  TListAdapter<T> = class(TInterfacedObject, IFluentEnumerableBase<T>)
  private
    FList: TList<T>;
    FOwnsList: Boolean;
  public
    constructor Create(const AList: TList<T>; AOwnsList: Boolean = False);
    destructor Destroy; override;
    function GetEnumerator: IFluentEnumerator<T>;
  end;

  TListEnumerator<T> = class(TInterfacedObject, IFluentEnumerator<T>)
  private
    FEnumerator: TList<T>.TEnumerator;
  public
    constructor Create(const AEnumerator: TList<T>.TEnumerator);
    destructor Destroy; override;
    function GetCurrent: T;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: T read GetCurrent;
  end;

  TDictionaryAdapter<K, V> = class(TInterfacedObject, IFluentEnumerableBase<TPair<K, V>>)
  private
    FDict: TDictionary<K, V>;
    FOwnsDict: Boolean;
  public
    constructor Create(const ADict: TDictionary<K, V>; AOwnsDict: Boolean = False);
    destructor Destroy; override;
    function GetEnumerator: IFluentEnumerator<TPair<K, V>>;
  end;

  TDictionaryEnumerator<K, V> = class(TInterfacedObject, IFluentEnumerator<TPair<K, V>>)
  private
    FEnumerator: TDictionary<K, V>.TPairEnumerator;
  public
    constructor Create(const AEnumerator: TDictionary<K, V>.TPairEnumerator);
    destructor Destroy; override;
    function GetCurrent: TPair<K, V>;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: TPair<K, V> read GetCurrent;
  end;

  TArrayAdapter<T> = class(TInterfacedObject, IFluentEnumerableBase<T>)
  private
    FArray: TArray<T>;
    FList: TList<T>;
  public
    constructor Create(const AArray: TArray<T>);
    destructor Destroy; override;
    function GetEnumerator: IFluentEnumerator<T>;
  end;

  TStringAdapter = class(TInterfacedObject, IFluentEnumerableBase<char>)
  private
    FString: string;
  public
    constructor Create(const AString: string);
    function GetEnumerator: IFluentEnumerator<char>;
  end;

  TStringEnumerator = class(TInterfacedObject, IFluentEnumerator<char>)
  private
    FString: string;
    FIndex: Integer;
  public
    constructor Create(const AString: string);
    function GetCurrent: char;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: char read GetCurrent;
  end;

  TNonGenericArrayAdapter<T> = class(TInterfacedObject, IFluentEnumerableBase<T>)
  private
    FArray: TArray<T>;
    FList: TList<T>;
  public
    constructor Create(const AArray: array of T);
    destructor Destroy; override;
    function GetEnumerator: IFluentEnumerator<T>;
  end;

implementation

{ TListAdapter<T> }

constructor TListAdapter<T>.Create(const AList: TList<T>; AOwnsList: Boolean);
begin
  FList := AList;
  FOwnsList := AOwnsList;
end;

destructor TListAdapter<T>.Destroy;
begin
  if FOwnsList then
    FList.Free;
  inherited;
end;

function TListAdapter<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TListEnumerator<T>.Create(FList.GetEnumerator);
end;

{ TListEnumerator<T> }

constructor TListEnumerator<T>.Create(const AEnumerator: TList<T>.TEnumerator);
begin
  FEnumerator := AEnumerator;
end;

destructor TListEnumerator<T>.Destroy;
begin
  FEnumerator.Free;
  inherited;
end;

function TListEnumerator<T>.GetCurrent: T;
begin
  Result := FEnumerator.Current;
end;

function TListEnumerator<T>.MoveNext: Boolean;
begin
  Result := FEnumerator.MoveNext;
end;

procedure TListEnumerator<T>.Reset;
begin
  raise ENotSupportedException.Create('Reset is not supported for list enumerators');
end;

{ TDictionaryAdapter<K, V> }

constructor TDictionaryAdapter<K, V>.Create(const ADict: TDictionary<K, V>; AOwnsDict: Boolean);
begin
  FDict := ADict;
  FOwnsDict := AOwnsDict;
end;

destructor TDictionaryAdapter<K, V>.Destroy;
begin
  if FOwnsDict then
    FDict.Free;
  inherited;
end;

function TDictionaryAdapter<K, V>.GetEnumerator: IFluentEnumerator<TPair<K, V>>;
begin
  Result := TDictionaryEnumerator<K, V>.Create(FDict.GetEnumerator);
end;

{ TDictionaryEnumerator<K, V> }

constructor TDictionaryEnumerator<K, V>.Create(const AEnumerator: TDictionary<K, V>.TPairEnumerator);
begin
  FEnumerator := AEnumerator;
end;

destructor TDictionaryEnumerator<K, V>.Destroy;
begin
  FEnumerator.Free;
  inherited;
end;

function TDictionaryEnumerator<K, V>.GetCurrent: TPair<K, V>;
begin
  Result := FEnumerator.Current;
end;

function TDictionaryEnumerator<K, V>.MoveNext: Boolean;
begin
  Result := FEnumerator.MoveNext;
end;

procedure TDictionaryEnumerator<K, V>.Reset;
begin
  raise ENotSupportedException.Create('Reset is not supported for dictionary enumerators');
end;

{ TArrayAdapter<T> }

constructor TArrayAdapter<T>.Create(const AArray: TArray<T>);
begin
  FArray := AArray;
  FList := TList<T>.Create(AArray);
end;

destructor TArrayAdapter<T>.Destroy;
begin
  FList.Free;
  inherited;
end;

function TArrayAdapter<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TListEnumerator<T>.Create(FList.GetEnumerator);
end;

{ TStringAdapter }

constructor TStringAdapter.Create(const AString: string);
begin
  FString := AString;
end;

function TStringAdapter.GetEnumerator: IFluentEnumerator<char>;
begin
  Result := TStringEnumerator.Create(FString);
end;

{ TStringEnumerator }

constructor TStringEnumerator.Create(const AString: string);
begin
  FString := AString;
  FIndex := 0;
end;

function TStringEnumerator.GetCurrent: Char;
begin
  if (FIndex < 1) or (FIndex > Length(FString)) then
    raise ERangeError.Create('Index out of bounds');
  Result := FString[FIndex];
end;

function TStringEnumerator.MoveNext: Boolean;
begin
  Inc(FIndex);
  Result := FIndex <= Length(FString);
end;

procedure TStringEnumerator.Reset;
begin
  FIndex := 0;
end;

{ TNonGenericArrayAdapter<T> }

constructor TNonGenericArrayAdapter<T>.Create(const AArray: array of T);
var
  LFor: Integer;
begin
  SetLength(FArray, Length(AArray));
  for LFor := 0 to High(AArray) do
    FArray[LFor] := AArray[LFor];
  FList := TList<T>.Create(AArray);
end;

destructor TNonGenericArrayAdapter<T>.Destroy;
begin
  FList.Free;
  inherited;
end;

function TNonGenericArrayAdapter<T>.GetEnumerator: IFluentEnumerator<T>;
begin
  Result := TListEnumerator<T>.Create(FList.GetEnumerator);
end;

end.
