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

unit System.Fluent.SafeTry;

interface

uses
  SysUtils,
  Rtti;

type
  TFluentSafeResult = record
  private
    FIsOk: Boolean;
    FValue: TValue;
    FException: String;
    procedure _Ok(const AValue: TValue);
    procedure _Err(const AException: String);
    class function _CreateOk(const AValue: TValue): TFluentSafeResult; static;
    class function _CreateErr(const AException: String): TFluentSafeResult; static;
  public
    function IsOk: Boolean;
    function IsErr: Boolean;
    function GetValue: TValue;
    function TryGetValue(out AValue: TValue): Boolean;
    function ExceptionMessage: String;
    function AsType<T>: T;
    function IsType<T>: Boolean;
  end;

  TFluentSafeTry = record
  private
    FTryFunc: TFunc<TValue>;
    FTryProc: TProc;
    FExcept: TProc<Exception>;
    FFinally: TProc;
    function _EndExecute: TValue;
  public
    class function SafeTry(const AFunc: TFunc<TValue>): TFluentSafeTry; overload; static;
    class function SafeTry(const AProc: TProc = nil): TFluentSafeTry; overload; static;
    function SafeExcept(const AProc: TProc<Exception>): TFluentSafeTry;
    function SafeFinally(const AProc: TProc): TFluentSafeTry;
    function SafeEnd: TFluentSafeResult;
  end;

function SafeTry(const AFunc: TFunc<TValue>): TFluentSafeTry; overload;
function SafeTry(const AProc: TProc): TFluentSafeTry; overload;
function SafeTry: TFluentSafeTry; overload;

implementation

{ TFluentSafeResult }

procedure TFluentSafeResult._Ok(const AValue: TValue);
begin
  FIsOk := True;
  FValue := AValue;
  FException := '';
end;

procedure TFluentSafeResult._Err(const AException: String);
begin
  FIsOk := False;
  FValue := TValue.Empty;
  FException := AException;
end;

function TFluentSafeResult.IsOk: Boolean;
begin
  Result := FIsOk;
end;

function TFluentSafeResult.IsErr: Boolean;
begin
  Result := not FIsOk;
end;

function TFluentSafeResult.GetValue: TValue;
begin
  if not FIsOk then
    raise Exception.Create('Cannot get value when result is an error.');
  Result := FValue;
end;

function TFluentSafeResult.TryGetValue(out AValue: TValue): Boolean;
begin
  Result := FIsOk;
  if Result then
    AValue := FValue
  else
    AValue := TValue.Empty;
end;

function TFluentSafeResult.ExceptionMessage: String;
begin
  Result := FException;
end;

function TFluentSafeResult.AsType<T>: T;
begin
  Result := GetValue.AsType<T>;
end;

function TFluentSafeResult.IsType<T>: Boolean;
begin
  Result := FIsOk and FValue.IsType(TypeInfo(T));
end;

class function TFluentSafeResult._CreateOk(const AValue: TValue): TFluentSafeResult;
begin
  Result._Ok(AValue);
end;

class function TFluentSafeResult._CreateErr(const AException: String): TFluentSafeResult;
begin
  Result._Err(AException);
end;

{ TFluentSafeTry }

class function TFluentSafeTry.SafeTry(const AFunc: TFunc<TValue>): TFluentSafeTry;
begin
  Result.FTryFunc := AFunc;
  Result.FTryProc := nil;
  Result.FExcept := nil;
  Result.FFinally := nil;
end;

class function TFluentSafeTry.SafeTry(const AProc: TProc): TFluentSafeTry;
begin
  Result.FTryProc := AProc;
  Result.FTryFunc := nil;
  Result.FExcept := nil;
  Result.FFinally := nil;
end;

function TFluentSafeTry.SafeExcept(const AProc: TProc<Exception>): TFluentSafeTry;
begin
  FExcept := AProc;
  Result := Self;
end;

function TFluentSafeTry.SafeFinally(const AProc: TProc): TFluentSafeTry;
begin
  FFinally := AProc;
  Result := Self;
end;

function TFluentSafeTry._EndExecute: TValue;
var
  LExceptMessage: String;
begin
  try
    try
      if Assigned(FTryFunc) then
      begin
        Result := FTryFunc();
        if Result.IsEmpty then
          Result := TValue.From(True);
      end
      else if Assigned(FTryProc) then
      begin
        FTryProc();
        Result := TValue.From(True);
      end
      else
        Result := TValue.From(True);
    except
      on E: Exception do
      begin
        LExceptMessage := E.Message;
        if Assigned(FExcept) then
        begin
          try
            FExcept(E);
          except
            on EInner: Exception do
              LExceptMessage := E.Message + ' (Except handler failed: ' + EInner.Message + ')';
          end;
        end;
        raise Exception.Create(LExceptMessage);
      end;
    end;
  finally
    if Assigned(FFinally) then
    begin
      try
        FFinally();
      except
        on E: Exception do
          // Ignora exceções em Finally silenciosamente
          // Futuro: Poderia logar se houver um mecanismo global
      end;
    end;
  end;
end;

function TFluentSafeTry.SafeEnd: TFluentSafeResult;
var
  LValue: TValue;
begin
  try
    LValue := _EndExecute;
    Result := TFluentSafeResult._CreateOk(LValue);
  except
    on E: Exception do
      Result := TFluentSafeResult._CreateErr(E.Message);
  end;
end;

function SafeTry(const AFunc: TFunc<TValue>): TFluentSafeTry;
begin
  Result := TFluentSafeTry.SafeTry(AFunc);
end;

function SafeTry(const AProc: TProc): TFluentSafeTry;
begin
  Result := TFluentSafeTry.SafeTry(AProc);
end;

function SafeTry: TFluentSafeTry;
begin
  Result := TFluentSafeTry.SafeTry;
end;

end.


