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

unit Fluent.Helpers;

interface

uses
  Classes,
  StrUtils,
  SysUtils,
  Generics.Collections,
  Fluent.Core,
  Fluent.Adapters;

type
  TFluentChar = record helper for Char
  public
    function ToUpper: Char;
    function ToLower: Char;
    function IsLetter: Boolean;
    function IsDigit: Boolean;
  end;

  TFluentString = record helper for string
  private
    function AsEnumerable(const AString: string): IFluentEnumerable<Char>;
  public
    procedure Partition(const APredicate: TFunc<Char, Boolean>; out ALeft, ARight: String);
    function Filter(const APredicate: TFunc<Char, Boolean>): IFluentEnumerable<Char>;
    function Collect: IFluentEnumerable<String>;
    function Map<TResult>(const ATransform: TFunc<Char, TResult>): IFluentEnumerable<TResult>;
    function FlatMap(const ATransform: TFunc<Char, String>): IFluentEnumerable<Char>;
    function Sum: Integer;
    function First: Char;
    function Last: Char;
    function Reduce<T>(const AInitialValue: T; const AAccumulator: TFunc<T, Char, T>): T;
    function Exists(const APredicate: TFunc<Char, Boolean>): Boolean;
    function All(const APredicate: TFunc<Char, Boolean>): Boolean;
    function Any(const APredicate: TFunc<Char, Boolean>): Boolean;
    function Sort: IFluentEnumerable<Char>;
    function Take(const ACount: Integer): IFluentEnumerable<Char>;
    function Skip(const ACount: Integer): IFluentEnumerable<Char>;
    function GroupBy<TKey>(const AKeySelector: TFunc<Char, TKey>): IGroupedEnumerator<TKey, Char>;
    function Reverse: IFluentEnumerable<Char>;
    function CountWhere(const APredicate: TFunc<Char, Boolean>): Integer;
  end;

  TFluentInteger = record helper for Integer
  public
    function Map(const ATransform: TFunc<Integer, Integer>): Integer;
    function IsEven: Boolean;
    function IsOdd: Boolean;
    function Times(const ATransform: TFunc<Integer, Integer>): Integer;
  end;

  TFluentBoolean = record helper for Boolean
  public
    function Map<T>(const ATrueValue, AFalseValue: T): T;
    procedure IfTrue(const AAction: TProc);
    procedure IfFalse(const AAction: TProc);
  end;

  TFluentFloat = record helper for Double
  public
    function Map(const ATransform: TFunc<Double, Double>): Double;
    function Round: Integer;
    function ApproxEqual(const AValue: Double; const ATolerance: Double = 0.0001): Boolean;
  end;

  TFluentDateTime = record helper for TDateTime
  public
    function Map(const ATransform: TFunc<TDateTime, TDateTime>): TDateTime;
    function AddDays(ADays: Integer): TDateTime;
    function IsPast: Boolean;
    function ToFormat(const AFormat: String): String;
  end;

implementation

{ TFluentChar }

function TFluentChar.ToUpper: Char;
begin
  if CharInSet(Self, ['a'..'z']) then
    Result := Chr(Ord(Self) - 32)
  else
    Result := Self;
end;

function TFluentChar.ToLower: Char;
begin
  Result := System.SysUtils.LowerCase(Self)[1];
end;

function TFluentChar.IsLetter: Boolean;
begin
  Result := System.SysUtils.CharInSet(Self, ['A'..'Z', 'a'..'z']);
end;

function TFluentChar.IsDigit: Boolean;
begin
  Result := System.SysUtils.CharInSet(Self, ['0'..'9']);
end;

{ TFluentString }

function TFluentString.AsEnumerable(const AString: string): IFluentEnumerable<Char>;
begin
  Result := IFluentEnumerable<Char>.Create(TStringAdapter.Create(AString));
end;

procedure TFluentString.Partition(const APredicate: TFunc<Char, Boolean>; out ALeft, ARight: String);
var
  LChar: Char;
begin
  ALeft := '';
  ARight := '';
  for LChar in Self do
    if APredicate(LChar) then
      ALeft := ALeft + LChar
    else
      ARight := ARight + LChar;
end;

function TFluentString.Filter(const APredicate: TFunc<Char, Boolean>): IFluentEnumerable<Char>;
begin
  Result := AsEnumerable(Self).Filter(APredicate);
end;

function TFluentString.Collect: IFluentEnumerable<String>;
var
  LWords: TArray<string>;
begin
  LWords := SplitString(Self, ' ');
  Result := IFluentEnumerable<String>.Create(TArrayAdapter<string>.Create(LWords));
end;

function TFluentString.Map<TResult>(const ATransform: TFunc<Char, TResult>): IFluentEnumerable<TResult>;
begin
  Result := AsEnumerable(Self).Map<TResult>(ATransform);
end;

function TFluentString.FlatMap(const ATransform: TFunc<Char, String>): IFluentEnumerable<Char>;
var
  LTransformed: IFluentEnumerable<String>;
begin
  LTransformed := AsEnumerable(Self).Map<String>(function(LChar: Char): String
                                                 begin
                                                   Result :=
                                                   ATransform(LChar)
                                                 end);
  Result := LTransformed.FlatMap<Char>(
    function(LStr: String): TArray<Char>
    var
      LArray: TArray<Char>;
      LFor: Integer;
    begin
      SetLength(LArray, Length(LStr));
      for LFor := 1 to Length(LStr) do
        LArray[LFor - 1] := LStr[LFor];
      Result := LArray;
    end);
end;

function TFluentString.Sum: Integer;
var
  LEnum: IFluentEnumerator<Char>;
  LSum: Integer;
begin
  LEnum := AsEnumerable(Self).GetEnumerator;
  LSum := 0;
  while LEnum.MoveNext do
    Inc(LSum, Ord(LEnum.Current));
  Result := LSum;
end;

function TFluentString.First: Char;
begin
  if Length(Self) > 0 then
    Result := Self[1]
  else
    Result := #0;
end;

function TFluentString.Last: Char;
begin
  if Length(Self) > 0 then
    Result := Self[Length(Self)]
  else
    Result := #0;
end;

function TFluentString.Reduce<T>(const AInitialValue: T;
  const AAccumulator: TFunc<T, Char, T>): T;
begin
  Result := AsEnumerable(Self).Reduce<T>(AInitialValue, AAccumulator);
end;

function TFluentString.Exists(const APredicate: TFunc<Char, Boolean>): Boolean;
begin
  Result := AsEnumerable(Self).Any(APredicate);
end;

function TFluentString.All(const APredicate: TFunc<Char, Boolean>): Boolean;
var
  LEnum: IFluentEnumerator<Char>;
begin
  LEnum := AsEnumerable(Self).GetEnumerator;
  while LEnum.MoveNext do
    if not APredicate(LEnum.Current) then
      Exit(False);
  Result := True;
end;

function TFluentString.Any(const APredicate: TFunc<Char, Boolean>): Boolean;
begin
  Result := AsEnumerable(Self).Any(APredicate);
end;

function TFluentString.Sort: IFluentEnumerable<Char>;
begin
  Result := AsEnumerable(Self).OrderBy(
    function(LA, LB: Char): Integer
    begin
      Result := CompareStr(string(LA), string(LB));
    end);
end;

function TFluentString.Take(const ACount: Integer): IFluentEnumerable<Char>;
begin
  Result := AsEnumerable(Self).Take(ACount);
end;

function TFluentString.Skip(const ACount: Integer): IFluentEnumerable<Char>;
begin
  Result := AsEnumerable(Self).Skip(ACount);
end;

function TFluentString.GroupBy<TKey>(const AKeySelector: TFunc<Char, TKey>): IGroupedEnumerator<TKey, Char>;
begin
  Result := AsEnumerable(Self).GroupBy<TKey>(AKeySelector);
end;

function TFluentString.Reverse: IFluentEnumerable<Char>;
var
  LArray: TArray<Char>;
  LIndex: Integer;
begin
  SetLength(LArray, Length(Self));
  for LIndex := 1 to Length(Self) do
    LArray[LIndex - 1] := Self[Length(Self) - LIndex + 1];
  Result := IFluentEnumerable<Char>.Create(TArrayAdapter<Char>.Create(LArray));
end;

function TFluentString.CountWhere(const APredicate: TFunc<Char, Boolean>): Integer;
begin
  Result := AsEnumerable(Self).Count(APredicate);
end;

{ TFluentInteger }

function TFluentInteger.Map(const ATransform: TFunc<Integer, Integer>): Integer;
begin
  Result := ATransform(Self);
end;

function TFluentInteger.IsEven: Boolean;
begin
  Result := (Self mod 2) = 0;
end;

function TFluentInteger.IsOdd: Boolean;
begin
  Result := (Self mod 2) <> 0;
end;

function TFluentInteger.Times(const ATransform: TFunc<Integer, Integer>): Integer;
var
  LCount: Integer;
  LResult: Integer;
begin
  LResult := Self;
  for LCount := 1 to Self do
    LResult := ATransform(LResult);
  Result := LResult;
end;

{ TFluentBoolean }

function TFluentBoolean.Map<T>(const ATrueValue, AFalseValue: T): T;
begin
  if Self then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

procedure TFluentBoolean.IfTrue(const AAction: TProc);
begin
  if Self then
    AAction;
end;

procedure TFluentBoolean.IfFalse(const AAction: TProc);
begin
  if not Self then
    AAction;
end;

{ TFluentFloat }

function TFluentFloat.Map(const ATransform: TFunc<Double, Double>): Double;
begin
  Result := ATransform(Self);
end;

function TFluentFloat.Round: Integer;
begin
  Result := System.Round(Self);
end;

function TFluentFloat.ApproxEqual(const AValue: Double; const ATolerance: Double): Boolean;
begin
  Result := Abs(Self - AValue) < ATolerance;
end;

{ TFluentDateTime }

function TFluentDateTime.Map(const ATransform: TFunc<TDateTime, TDateTime>): TDateTime;
begin
  Result := ATransform(Self);
end;

function TFluentDateTime.AddDays(ADays: Integer): TDateTime;
begin
  Result := Self + ADays;
end;

function TFluentDateTime.IsPast: Boolean;
begin
  Result := Self < Now;
end;

function TFluentDateTime.ToFormat(const AFormat: String): String;
begin
  Result := FormatDateTime(AFormat, Self);
end;

end.
