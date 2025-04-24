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

unit System.Fluent.Objects;

interface

uses
  Rtti,
  TypInfo,
  SysUtils,
  Classes,
  Variants,
  SyncObjs,
  Generics.Collections;

type
  TArrayValue = array of TValue;

  IFluentObject = interface
    ['{486D1BA3-6AEE-46A6-A845-D5154BEBE31C}']
    function Factory(const AClass: TClass): TObject; overload;
    function Factory(const AClass: TClass; const AArgs: TArrayValue;
      const AMethodName: String): TObject; overload;
  end;

  TFluentObject = class sealed(TInterfacedObject, IFluentObject)
  strict private
    class var FContext: TRttiContext;
    class var FAutoRefLock: TCriticalSection;
  protected
    class function AutoRefLock: TCriticalSection; static;
    class procedure InitializeContext; static;
    class procedure FinalizeContext; static;
    class function Context: TRttiContext; static;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IFluentObject;
    function Factory(const AClass: TClass): TObject; overload;
    function Factory(const AClass: TClass; const AArgs: TArrayValue;
      const AMethodName: String): TObject; overload;
    function Factory<T: IInterface>: T; overload;
  end;

  IFluentSmartPtr<T> = interface
    ['{42718709-DE8D-4E8B-9B9E-75BACBF68C8E}']
    function IsNull: Boolean;
    function IsLoaded: Boolean;
  end;

  IFluentAutoRefLock = interface
    ['{AA0A5629-0E09-4865-98D9-355D0CD7DE31}']
    procedure Acquire;
    procedure Release;
  end;

  TFluentAutoRefLock = class(TInterfacedObject, IFluentAutoRefLock)
  private
    FAutoRefLock: TCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Acquire;
    procedure Release;
  end;

  TFluentSmartPtr<T: class, constructor> = record
  strict private
    FValue: T;
    FSmartPtr: IFluentSmartPtr<T>;
    FAutoRefLock: IFluentAutoRefLock;
    FObjectEx: IFluentObject;
    function _GetAsRef: T;
  strict private
    type
      TFluentSmartPtr = class(TInterfacedObject, IFluentSmartPtr<T>)
      private
        FValue: TObject;
        FIsLoaded: Boolean;
      public
        constructor Create(const AObjectRef: TObject);
        destructor Destroy; override;
        function IsNull: Boolean;
        function IsLoaded: Boolean;
      end;
  public
    constructor Create(const AObjectRef: T);
    class operator Implicit(const AObjectRef: T): TFluentSmartPtr<T>;
    class operator Implicit(const AAutoRef: TFluentSmartPtr<T>): T;
    function IsNull: Boolean;
    function IsLoaded: Boolean;
    function Match<R>(const ANullFunc: TFunc<R>; const AValidFunc: TFunc<T, R>): R;
    procedure Scoped(const AAction: TProc<T>);
    property AsRef: T read _GetAsRef;
  end;

//  TImmutableHook = class
//  private
//    FInstance: TObject;
//    FOriginalSetters: TDictionary<string, Pointer>;
//    FContext: TRttiContext;
//    procedure _HookAllSetters;
//    procedure _RestoreAllSetters;
//  public
//    constructor Create(AInstance: TObject);
//    destructor Destroy; override;
//    function GetProperty(const APropertyName: string): TValue;
//  end;

  TFluentMutableRef<T> = record
  strict private
    FValue: TValue;
    FSmartPtr: IFluentSmartPtr<T>;
    FAutoRefLock: IFluentAutoRefLock;
    FObjectEx: IFluentObject;
    FIsMutable: Boolean;
    function _GetAsRef: T;
  strict private
    type
      TFluentSmartPtr = class(TInterfacedObject, IFluentSmartPtr<T>)
      private
        FValue: TValue;
        FIsLoaded: Boolean;
//        FImmutableHook: TImmutableHook;
      public
        constructor Create(const AValue: TValue);
        destructor Destroy; override;
        function IsNull: Boolean;
        function IsLoaded: Boolean;
      end;
  public
    constructor Create(const AValueRef: T; const AMutable: Boolean = False); overload;
    class operator Implicit(const AValueRef: T): TFluentMutableRef<T>;
    class operator Implicit(const AAutoRef: TFluentMutableRef<T>): T;
    function IsNull: Boolean;
    function IsLoaded: Boolean;
    function IsMutable: Boolean;
    function Match<R>(const ANullFunc: TFunc<R>; const AValidFunc: TFunc<T, R>): R;
    procedure Scoped(const AAction: TFunc<T, TValue>);
    property AsRef: T read _GetAsRef;
  end;

procedure BlockedSetter(const Value: Variant);

implementation

uses
  Windows;

procedure BlockedSetter(const Value: Variant);
begin
  raise Exception.Create('Property is immutable');
end;


{ TFluentObject }

class function TFluentObject.AutoRefLock: TCriticalSection;
begin
  Result := FAutoRefLock;
end;

class function TFluentObject.Context: TRttiContext;
begin
  Result := FContext;
end;

constructor TFluentObject.Create;
begin

end;

destructor TFluentObject.Destroy;
begin
  inherited;
end;

class procedure TFluentObject.InitializeContext;
begin
  FContext := TRttiContext.Create;
  FAutoRefLock := TCriticalSection.Create;
end;

class procedure TFluentObject.FinalizeContext;
begin
  FAutoRefLock.Free;
  FContext.Free;
end;

class function TFluentObject.New: IFluentObject;
begin
  Result := TFluentObject.Create;
end;

function TFluentObject.Factory(const AClass: TClass): TObject;
begin
  Result := Factory(AClass, [], 'Create');
end;

function TFluentObject.Factory(const AClass: TClass; const AArgs: TArrayValue;
  const AMethodName: String): TObject;
var
  LConstructor: TRttiMethod;
  LInstance: TValue;
  LType: TRttiType;
begin
  LType := FContext.GetType(AClass);
  LConstructor := LType.GetMethod(AMethodName);
  if LConstructor = nil then
    raise Exception.CreateFmt('Constructor "%s" not found in class %s', [AMethodName, AClass.ClassName]);
  try
    LInstance := LConstructor.Invoke(LType.AsInstance.MetaClassType, AArgs);
    Result := LInstance.AsObject;
  except
    on E: Exception do
      raise Exception.CreateFmt('Failed to invoke constructor "%s" in class %s: %s', [AMethodName, AClass.ClassName, E.Message]);
  end;
end;

function TFluentObject.Factory<T>: T;
var
  LType: TRttiType;
  LInstance: TValue;
begin
  LType := FContext.GetType(TypeInfo(T));
  LInstance := LType.GetMethod('Create').Invoke(LType.AsInstance.MetaClassType, []);
  Result := LInstance.AsType<T>;
end;

{ TFluentSmartPtr<T>.TFluentSmartPtr }

constructor TFluentSmartPtr<T>.TFluentSmartPtr.Create(const AObjectRef: TObject);
begin
  FValue := AObjectRef;
  FIsLoaded := Assigned(FValue);
end;

destructor TFluentSmartPtr<T>.TFluentSmartPtr.Destroy;
begin
  if Assigned(FValue) then
    FValue.Free;
  inherited;
end;

function TFluentSmartPtr<T>.TFluentSmartPtr.IsNull: Boolean;
begin
  Result := FValue = nil;
end;

function TFluentSmartPtr<T>.TFluentSmartPtr.IsLoaded: Boolean;
begin
  Result := FIsLoaded;
end;

{ TFluentSmartPtr<T> }

constructor TFluentSmartPtr<T>.Create(const AObjectRef: T);
begin
  FValue := AObjectRef;
  if Assigned(FValue) then
    FSmartPtr := TFluentSmartPtr.Create(FValue);
  FObjectEx := TFluentObject.New;
  FAutoRefLock := TFluentAutoRefLock.Create;
end;

function TFluentSmartPtr<T>._GetAsRef: T;
begin
  if not Assigned(FAutoRefLock) then
  begin
    TFluentObject.AutoRefLock.Acquire;
    try
      if not Assigned(FAutoRefLock) then
        FAutoRefLock := TFluentAutoRefLock.Create;
    finally
      TFluentObject.AutoRefLock.Release;
    end;
  end;

  FAutoRefLock.Acquire;
  try
    if (FSmartPtr = nil) or FSmartPtr.IsNull then
    begin
      if FObjectEx = nil then
        FObjectEx := TFluentObject.New;
      FValue := FObjectEx.Factory(T) as T;
      FSmartPtr := TFluentSmartPtr.Create(FValue);
    end;
    Result := FValue;
  finally
    FAutoRefLock.Release;
  end;
end;

class operator TFluentSmartPtr<T>.Implicit(const AObjectRef: T): TFluentSmartPtr<T>;
begin
  Result := TFluentSmartPtr<T>.Create(AObjectRef);
end;

class operator TFluentSmartPtr<T>.Implicit(const AAutoRef: TFluentSmartPtr<T>): T;
begin
  Result := AAutoRef.AsRef;
end;

function TFluentSmartPtr<T>.IsNull: Boolean;
begin
  Result := True;
  if FSmartPtr = nil then
    Exit;
  Result := FSmartPtr.IsNull;
end;

function TFluentSmartPtr<T>.IsLoaded: Boolean;
begin
  Result := (FSmartPtr <> nil) and FSmartPtr.IsLoaded;
end;

function TFluentSmartPtr<T>.Match<R>(const ANullFunc: TFunc<R>; const AValidFunc: TFunc<T, R>): R;
begin
  if IsNull then
    Result := ANullFunc()
  else
    Result := AValidFunc(AsRef);
end;

procedure TFluentSmartPtr<T>.Scoped(const AAction: TProc<T>);
begin
  try
    AAction(AsRef);
  finally
    FSmartPtr := nil;
  end;
end;

{ TFluentAutoRefLock }

procedure TFluentAutoRefLock.Acquire;
begin
  FAutoRefLock.Acquire;
end;

constructor TFluentAutoRefLock.Create;
begin
  FAutoRefLock := TCriticalSection.Create;
end;

destructor TFluentAutoRefLock.Destroy;
begin
  FAutoRefLock.Free;
  inherited;
end;

procedure TFluentAutoRefLock.Release;
begin
  FAutoRefLock.Release;
end;

{ TFluentMutableRef<T> }

constructor TFluentMutableRef<T>.Create(const AValueRef: T; const AMutable: Boolean);
begin
  FIsMutable := AMutable;
  FValue := TValue.From<T>(AValueRef);
  FSmartPtr := TFluentSmartPtr.Create(FValue);
  FObjectEx := TFluentObject.New;
  FAutoRefLock := TFluentAutoRefLock.Create;
end;

class operator TFluentMutableRef<T>.Implicit(const AValueRef: T): TFluentMutableRef<T>;
begin
  if Result.IsLoaded then
    if not Result.IsMutable then
      raise Exception.Create('Attempt to modify an immutable value.');
  Result := TFluentMutableRef<T>.Create(AValueRef);
end;

class operator TFluentMutableRef<T>.Implicit(const AAutoRef: TFluentMutableRef<T>): T;
begin
  if AAutoRef.IsLoaded then
    if not AAutoRef.IsMutable then
      raise Exception.Create('Attempt to modify an immutable value.');
  Result := AAutoRef.AsRef;
end;

function TFluentMutableRef<T>.IsLoaded: Boolean;
begin
  Result := (FSmartPtr <> nil) and FSmartPtr.IsLoaded;
end;

function TFluentMutableRef<T>.IsMutable: Boolean;
begin
  Result := FIsMutable;
end;

function TFluentMutableRef<T>.IsNull: Boolean;
begin
  Result := True;
  if FSmartPtr = nil then
    Exit;
  Result := FSmartPtr.IsNull;
end;

function TFluentMutableRef<T>.Match<R>(const ANullFunc: TFunc<R>; const AValidFunc: TFunc<T, R>): R;
begin
  if IsNull then
    Result := ANullFunc()
  else
    Result := AValidFunc(AsRef);
end;

procedure TFluentMutableRef<T>.Scoped(const AAction: TFunc<T, TValue>);
begin
  if IsNull then
    Exit;
  if not FIsMutable then
    raise Exception.Create('Attempt to modify an immutable value.');
  FValue := AAction(FValue.AsType<T>);
end;

function TFluentMutableRef<T>._GetAsRef: T;
var
  LType: TRttiType;
begin
  if not Assigned(FAutoRefLock) then
  begin
    TFluentObject.AutoRefLock.Acquire;
    try
      if not Assigned(FAutoRefLock) then
        FAutoRefLock := TFluentAutoRefLock.Create;
    finally
      TFluentObject.AutoRefLock.Release;
    end;
  end;

  FAutoRefLock.Acquire;
  try
    if (FSmartPtr = nil) or FSmartPtr.IsNull then
    begin
      if FValue.IsEmpty then
      begin
        if FObjectEx = nil then
          FObjectEx := TFluentObject.New;
        LType := TFluentObject.Context.GetType(TypeInfo(T));
        if LType.IsInstance then
        begin
          FValue := FObjectEx.Factory(LType.AsInstance.MetaclassType);
          FIsMutable := False;
        end
        else
          raise Exception.Create('MutableRef<T> can only create instances of class types');
      end;
      FSmartPtr := TFluentSmartPtr.Create(FValue);
    end;
    Result := FValue.AsType<T>;
  finally
    FAutoRefLock.Release;
  end;
end;

{ TFluentMutableRef<T> }

constructor TFluentMutableRef<T>.TFluentSmartPtr.Create(const AValue: TValue);
begin
  FValue := AValue;
  FIsLoaded := not FValue.IsEmpty;
//  if PTypeInfo(TypeInfo(T))^.Kind = tkClass then
//    FImmutableHook := TImmutableHook.Create(AValue.AsObject);
end;

destructor TFluentMutableRef<T>.TFluentSmartPtr.Destroy;
begin
  if PTypeInfo(TypeInfo(T))^.Kind = tkClass then
  begin
    if not FValue.IsEmpty then
      TObject(FValue.AsObject).Free;
  end;
//  if Assigned(FImmutableHook) then
//    FImmutableHook.Free;
  inherited;
end;

function TFluentMutableRef<T>.TFluentSmartPtr.IsLoaded: Boolean;
begin
  Result := FIsLoaded;
end;

function TFluentMutableRef<T>.TFluentSmartPtr.IsNull: Boolean;
begin
  Result := FValue.IsEmpty;
end;

{ TImmutableHook }

//constructor TImmutableHook.Create(AInstance: TObject);
//begin
//  FInstance := AInstance;
//  FContext := TRttiContext.Create;
//  FOriginalSetters := TDictionary<string, Pointer>.Create;
//  _HookAllSetters;
//end;
//
//destructor TImmutableHook.Destroy;
//begin
//  _RestoreAllSetters;
//  FOriginalSetters.Free;
//  FContext.Free;
//  inherited;
//end;
//
//function TImmutableHook.GetProperty(const APropertyName: string): TValue;
//var
//  RttiType: TRttiType;
//  Prop: TRttiProperty;
//begin
//  RttiType := FContext.GetType(FInstance.ClassType);
//  Prop := RttiType.GetProperty(APropertyName);
//  if Assigned(Prop) then
//    Result := Prop.GetValue(FInstance)
//  else
//    raise Exception.CreateFmt('Propriedade "%s" não encontrada', [APropertyName]);
//end;
//
//procedure TImmutableHook._HookAllSetters;
//var
//  RttiType: TRttiType;
//  Prop: TRttiProperty;
//  Method: TRttiMethod;
//  MethodAddress: Pointer;
//  NewMethod: Pointer;
//  OldProtect: DWORD;
//  SetterName: string;
//begin
//  RttiType := FContext.GetType(FInstance.ClassType);
//  for Prop in RttiType.GetProperties do
//  begin
//    if Prop.IsWritable then
//    begin
//      SetterName := '_Set' + Prop.Name;
//      Method := RttiType.GetMethod(SetterName);
//      if Assigned(Method) then
//      begin
//        MethodAddress := Method.CodeAddress;
//        FOriginalSetters.Add(SetterName, MethodAddress);
//        NewMethod := @BlockedSetter;
//
//        if VirtualProtect(MethodAddress, SizeOf(Pointer), PAGE_EXECUTE_READWRITE, OldProtect) then
//        try
//          PPointer(MethodAddress)^ := NewMethod;
//        finally
//          VirtualProtect(MethodAddress, SizeOf(Pointer), OldProtect, OldProtect);
//        end
//        else
//          raise Exception.Create('Failed to hook setter for ' + Prop.Name);
//      end
//      else
//        raise Exception.Create('Setter ' + SetterName + ' not found for property ' + Prop.Name);
//    end;
//  end;
//end;
//
//procedure TImmutableHook._RestoreAllSetters;
//var
//  RttiType: TRttiType;
//  Method: TRttiMethod;
//  MethodAddress: Pointer;
//  OldProtect: DWORD;
//  SetterPair: TPair<string, Pointer>;
//begin
//  RttiType := FContext.GetType(FInstance.ClassType);
//  for SetterPair in FOriginalSetters do
//  begin
//    Method := RttiType.GetMethod(SetterPair.Key);
//    if Assigned(Method) then
//    begin
//      MethodAddress := Method.CodeAddress;
//      if VirtualProtect(MethodAddress, SizeOf(Pointer), PAGE_EXECUTE_READWRITE, OldProtect) then
//      try
//        PPointer(MethodAddress)^ := SetterPair.Value;
//      finally
//        VirtualProtect(MethodAddress, SizeOf(Pointer), OldProtect, OldProtect);
//      end;
//    end;
//  end;
//end;

initialization
  TFluentObject.InitializeContext;

finalization
  TFluentObject.FinalizeContext;

end.
