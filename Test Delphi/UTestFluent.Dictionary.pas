unit UTestFluent.Dictionary;

interface

uses
  DUnitX.TestFramework,
  Rtti,
  SysUtils,
  Generics.Collections,
  Generics.Defaults,
  Fluent.Core,
  Fluent.Adapters,
  Fluent.Collections;

type
  TDictionaryHelperTest = class
  private
    FKeyNotified: Boolean;
    FValueNotified: Boolean;
    procedure OnKeyNotify(Sender: TObject; const Item: Integer; Action: TCollectionNotification);
    procedure OnValueNotify(Sender: TObject; const Item: String; Action: TCollectionNotification);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestForEach;
    [Test]
    procedure TestMap;
    [Test]
    procedure TestFilter;
    [Test]
    procedure TestReduce;
    [Test]
    procedure TestTake;
    [Test]
    procedure TestAny;
    [Test]
    procedure TestSkip;
    [Test]
    procedure TestZip;
    [Test]
    procedure TestJoin;
    [Test]
    procedure TestAddRange;
    [Test]
    procedure TestDistinct;
    [Test]
    procedure TestAdd;
    [Test]
    procedure TestAddRangeEnumerable;
    [Test]
    procedure TestRemove;
    [Test]
    procedure TestClear;
    [Test]
    procedure TestTrimExcess;
    [Test]
    procedure TestAddOrSetValue;
    [Test]
    procedure TestExtractPair;
    [Test]
    procedure TestTryGetValue;
    [Test]
    procedure TestTryAdd;
    [Test]
    procedure TestContainsKey;
    [Test]
    procedure TestContainsValue;
    [Test]
    procedure TestToArray;
    [Test]
    procedure TestCapacity;
    [Test]
    procedure TestCount;
    [Test]
    procedure TestIsEmpty;
    [Test]
    procedure TestGrowThreshold;
    [Test]
    procedure TestCollisions;
    [Test]
    procedure TestKeys;
    [Test]
    procedure TestValues;
    [Test]
    procedure TestComparer;
    [Test]
    procedure TestItemsGet;
    [Test]
    procedure TestItemsSet;
    [Test]
    procedure TestOnKeyNotify;
    [Test]
    procedure TestOnValueNotify;
    [Test]
    procedure TestCreateWithComparer;
    [Test]
    procedure TestCreateWithCapacityAndComparer;
    [Test]
    procedure TestCreateWithEnumerable;
    [Test]
    procedure TestCreateWithEnumerableAndComparer;
    [Test]
    procedure TestCreateWithArray;
    [Test]
    procedure TestCreateWithArrayAndComparer;
    [Test]
    procedure TestCreateWithDictOwns;
    [Test]
    procedure TestCreateWithDictNoOwns;
    [Test]
    procedure TestFromDict;
    [Test]
    procedure TestFromArray;
    [Test]
    procedure TestGetEnumerator;
    [Test]
    procedure TestCycle;
    [Test]
    procedure TestTee;
    [Test]
    procedure TestElementAt;
    [Test]
    procedure TestElementAtOrDefault;
    [Test]
    procedure TestTakeWhile;
    [Test]
    procedure TestSkipWhile;
    [Test]
    procedure TestFirst;
    [Test]
    procedure TestFirstOrDefault;
    [Test]
    procedure TestLast;
    [Test]
    procedure TestLastOrDefault;
    [Test]
    procedure TestSingle;
    [Test]
    procedure TestSingleOrDefault;
    [Test]
    procedure TestOfType;
    [Test]
    procedure TestExclude;
    [Test]
    procedure TestIntersect;
    [Test]
    procedure TestUnion;
    [Test]
    procedure TestConcat;
    [Test]
    procedure TestSequenceEqual;
    [Test]
    procedure TestOrderByDesc;
    [Test]
    procedure TestMin;
    [Test]
    procedure TestMinWithComparer;
    [Test]
    procedure TestMax;
    [Test]
    procedure TestMaxWithComparer;
    [Test]
    procedure TestMinBy;
    [Test]
    procedure TestMaxBy;
    [Test]
    procedure TestFlatMap;
    [Test]
    procedure TestSelectMany;
    [Test]
    procedure TestGroupBy;
    [Test]
    procedure TestGroupJoin;
    [Test]
    procedure TestReduceNoInitial;
    [Test]
    procedure TestReduceRight;
    [Test]
    procedure TestReduceRightNoInitial;
    [Test]
    procedure TestSumInteger;
    [Test]
    procedure TestSumDouble;
    [Test]
    procedure TestAverage;
    [Test]
    procedure TestCountWithPredicate;
    [Test]
    procedure TestLongCount;
    [Test]
    procedure TestAll;
    [Test]
    procedure TestContainsFluent;
    [Test]
    procedure TestToList;
  end;

implementation

{ TDictionaryHelperTest }

procedure TDictionaryHelperTest.Setup;
begin
  FKeyNotified := False;
  FValueNotified := False;
end;

procedure TDictionaryHelperTest.TearDown;
begin
end;

procedure TDictionaryHelperTest.OnKeyNotify(Sender: TObject; const Item: Integer; Action: TCollectionNotification);
begin
  FKeyNotified := True;
end;

procedure TDictionaryHelperTest.OnValueNotify(Sender: TObject; const Item: String; Action: TCollectionNotification);
begin
  FValueNotified := True;
end;

procedure TDictionaryHelperTest.TestForEach;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LCollectedValues: TList<String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  LCollectedValues := TList<String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LDictionary.AsEnumerable.ForEach(
      procedure(const Pair: TPair<Integer, String>)
      begin
        LCollectedValues.Add(Pair.Value);
      end);

    Assert.AreEqual(3, LCollectedValues.Count, 'Deveria ter coletado 3 valores');
    Assert.IsTrue(LCollectedValues.Contains('One'), 'Deveria conter "One"');
    Assert.IsTrue(LCollectedValues.Contains('Two'), 'Deveria conter "Two"');
    Assert.IsTrue(LCollectedValues.Contains('Three'), 'Deveria conter "Three"');
  finally
    LDictionary.Free;
    LCollectedValues.Free;
  end;
end;

procedure TDictionaryHelperTest.TestMap;
var
  LDictionary: IFluentDictionary<Integer, String>;
  LMapped: IFluentEnumerable<TPair<Integer, String>>;
  LResult: TDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LMapped := LDictionary.AsEnumerable.Map<TPair<Integer, String>>(
      function(Pair: TPair<Integer, String>): TPair<Integer, String>
      begin
        Result.Key := Pair.Key;
        Result.Value := Pair.Value + 'Mapped';
      end);

    LResult := LMapped.ToDictionary<Integer, String>(
      function(Pair: TPair<Integer, String>): Integer
      begin
        Result := Pair.Key;
      end,
      function(Pair: TPair<Integer, String>): String
      begin
        Result := Pair.Value;
      end);

    Assert.AreEqual(3, LResult.Count, 'Deveria ter 3 elementos após o Map');
    Assert.AreEqual('OneMapped', LResult[1], 'Deveria ter mapeado "One" para "OneMapped"');
    Assert.AreEqual('TwoMapped', LResult[2], 'Deveria ter mapeado "Two" para "TwoMapped"');
    Assert.AreEqual('ThreeMapped', LResult[3], 'Deveria ter mapeado "Three" para "ThreeMapped"');
  finally
    LResult.Free;
  end;
end;

procedure TDictionaryHelperTest.TestFilter;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LFiltered: IFluentEnumerable<TPair<Integer, String>>;
  LResult: TDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');
    LDictionary.Add(4, 'Four');

    LFiltered := LDictionary.AsEnumerable.Filter(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Length(Pair.Value) = 3;
      end);

    LResult := LFiltered.ToDictionary<Integer, String>(
      function(Pair: TPair<Integer, String>): Integer
      begin
        Result := Pair.Key;
      end,
      function(Pair: TPair<Integer, String>): String
      begin
        Result := Pair.Value;
      end);

    Assert.AreEqual(2, LResult.Count, 'Deveria ter 2 elementos após o Filter');
    Assert.IsTrue(LResult.ContainsKey(1), 'Deveria conter a chave 1 (One)');
    Assert.IsTrue(LResult.ContainsKey(2), 'Deveria conter a chave 2 (Two)');
    Assert.IsFalse(LResult.ContainsKey(3), 'Não deveria conter a chave 3 (Three)');
    Assert.IsFalse(LResult.ContainsKey(4), 'Não deveria conter a chave 4 (Four)');
  finally
    LDictionary.Free;
    LResult.Free;
  end;
end;

procedure TDictionaryHelperTest.TestReduce;
var
  LDictionary: TFluentDictionary<String, Integer>;
  LResult: TPair<String, Integer>;
begin
  LDictionary := TFluentDictionary<String, Integer>.Create;
  try
    LDictionary.Add('One', 1);
    LDictionary.Add('Two', 2);
    LDictionary.Add('Three', 3);
    LDictionary.Add('Four', 4);

    LResult := LDictionary.AsEnumerable.Reduce<TPair<String, Integer>>(
      TPair<String, Integer>.Create('', 0),
      function(Acc, Current: TPair<String, Integer>): TPair<String, Integer>
      begin
        Result.Key := Acc.Key + '+' + Current.Key;
        Result.Value := Acc.Value + Current.Value;
      end);

    Assert.IsTrue(LResult.Key.Contains('One'), 'Deveria conter "One" nas chaves');
    Assert.IsTrue(LResult.Key.Contains('Two'), 'Deveria conter "Two" nas chaves');
    Assert.IsTrue(LResult.Key.Contains('Three'), 'Deveria conter "Three" nas chaves');
    Assert.IsTrue(LResult.Key.Contains('Four'), 'Deveria conter "Four" nas chaves');
    Assert.AreEqual(10, LResult.Value, 'Deveria somar os valores (1 + 2 + 3 + 4 = 10)');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestTake;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LTaken: IFluentEnumerable<TPair<Integer, String>>;
  LResult: TDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');
    LDictionary.Add(4, 'Four');

    LTaken := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).Take(2);

    LResult := LTaken.ToDictionary<Integer, String>(
      function(Pair: TPair<Integer, String>): Integer
      begin
        Result := Pair.Key;
      end,
      function(Pair: TPair<Integer, String>): String
      begin
        Result := Pair.Value;
      end);

    Assert.AreEqual(2, LResult.Count, 'Deveria ter 2 elementos após o Take');
    Assert.IsTrue(LResult.ContainsKey(1), 'Deveria conter a chave 1 (One)');
    Assert.IsTrue(LResult.ContainsKey(2), 'Deveria conter a chave 2 (Two)');
    Assert.IsFalse(LResult.ContainsKey(3), 'Não deveria conter a chave 3');
    Assert.IsFalse(LResult.ContainsKey(4), 'Não deveria conter a chave 4');
  finally
    LDictionary.Free;
    LResult.Free;
  end;
end;

procedure TDictionaryHelperTest.TestAny;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LHasLongValue: Boolean;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LHasLongValue := LDictionary.AsEnumerable.Any(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Length(Pair.Value) > 4;
      end);

    Assert.IsTrue(LHasLongValue, 'Deveria ter valores com comprimento maior que 4');

    LHasLongValue := LDictionary.AsEnumerable.Any(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Length(Pair.Value) = 3;
      end);

    Assert.IsTrue(LHasLongValue, 'Deveria ter valores com comprimento igual a 3');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestSkip;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LSkipped: IFluentEnumerable<TPair<Integer, String>>;
  LResult: TDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');
    LDictionary.Add(4, 'Four');

    LSkipped := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).Skip(2);

    LResult := LSkipped.ToDictionary<Integer, String>(
      function(Pair: TPair<Integer, String>): Integer
      begin
        Result := Pair.Key;
      end,
      function(Pair: TPair<Integer, String>): String
      begin
        Result := Pair.Value;
      end);

    Assert.AreEqual(2, LResult.Count, 'Deveria ter 2 elementos após o Skip');
    Assert.IsFalse(LResult.ContainsKey(1), 'Não deveria conter a chave 1');
    Assert.IsFalse(LResult.ContainsKey(2), 'Não deveria conter a chave 2');
    Assert.IsTrue(LResult.ContainsKey(3), 'Deveria conter a chave 3 (Three)');
    Assert.IsTrue(LResult.ContainsKey(4), 'Deveria conter a chave 4 (Four)');
  finally
    LDictionary.Free;
    LResult.Free;
  end;
end;

procedure TDictionaryHelperTest.TestZip;
var
  LDictionary1, LDictionary2: IFluentDictionary<Integer, String>;
  LZipped: IFluentEnumerable<TPair<Integer, String>>;
  LResult: TDictionary<Integer, String>;
begin
  LDictionary1 := TFluentDictionary<Integer, String>.Create;
  LDictionary2 := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary1.Add(1, 'One');
    LDictionary1.Add(2, 'Two');
    LDictionary1.Add(3, 'Three');

    LDictionary2.Add(1, 'Uno');
    LDictionary2.Add(2, 'Dos');
    LDictionary2.Add(3, 'Tres');

    LZipped := LDictionary1.AsEnumerable.Zip<TPair<Integer, String>, TPair<Integer, String>>(
      LDictionary2.AsEnumerable,
      function(Pair1, Pair2: TPair<Integer, String>): TPair<Integer, String>
      begin
        Result.Key := Pair1.Key;
        Result.Value := Pair1.Value + ' | ' + Pair2.Value;
      end);

    LResult := LZipped.ToDictionary<Integer, String>(
      function(Pair: TPair<Integer, String>): Integer
      begin
        Result := Pair.Key;
      end,
      function(Pair: TPair<Integer, String>): String
      begin
        Result := Pair.Value;
      end);

    Assert.AreEqual(3, LResult.Count, 'Deveria ter 3 elementos após o Zip');
    Assert.AreEqual('One | Uno', LResult[1], 'Deveria combinar "One | Uno"');
    Assert.AreEqual('Two | Dos', LResult[2], 'Deveria combinar "Two | Dos"');
    Assert.AreEqual('Three | Tres', LResult[3], 'Deveria combinar "Three | Tres"');
  finally
    LResult.Free;
  end;
end;

procedure TDictionaryHelperTest.TestJoin;
var
  LDictionary1: TFluentDictionary<Integer, String>;
  LDictionary2: TFluentDictionary<Integer, String>;
  LJoined: IFluentEnumerable<TPair<Integer, String>>;
  LResult: TDictionary<Integer, String>;
begin
  LDictionary1 := TFluentDictionary<Integer, String>.Create;
  LDictionary2 := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary1.Add(1, 'One');
    LDictionary1.Add(2, 'Two');
    LDictionary1.Add(3, 'Three');

    LDictionary2.Add(1, 'Uno');
    LDictionary2.Add(2, 'Dos');
    LDictionary2.Add(4, 'Cuatro');

    LJoined := LDictionary1.AsEnumerable.Join<TPair<Integer, String>, Integer, TPair<Integer, String>>(
      LDictionary2.AsEnumerable,
      function(Pair1: TPair<Integer, String>): Integer
      begin
        Result := Pair1.Key;
      end,
      function(Pair2: TPair<Integer, String>): Integer
      begin
        Result := Pair2.Key;
      end,
      function(Pair1, Pair2: TPair<Integer, String>): TPair<Integer, String>
      begin
        Result := TPair<Integer, String>.Create(Pair1.Key, Pair1.Value + ' | ' + Pair2.Value);
      end);

    LResult := LJoined.ToDictionary<Integer, String>(
      function(Pair: TPair<Integer, String>): Integer
      begin
        Result := Pair.Key;
      end,
      function(Pair: TPair<Integer, String>): String
      begin
        Result := Pair.Value;
      end);

    Assert.AreEqual(2, LResult.Count, 'Deveria ter 2 elementos após o Join');
    Assert.AreEqual('One | Uno', LResult[1], 'Deveria combinar "One | Uno"');
    Assert.AreEqual('Two | Dos', LResult[2], 'Deveria combinar "Two | Dos"');
  finally
    LDictionary1.Free;
    LDictionary2.Free;
    LResult.Free;
  end;
end;

procedure TDictionaryHelperTest.TestAddRange;
var
  LSourceDict: TDictionary<Integer, String>;
  LTargetDict: IFluentDictionary<Integer, String>;
begin
  LSourceDict := TDictionary<Integer, String>.Create;
  LTargetDict := TFluentDictionary<Integer, String>.Create;
  try
    LSourceDict.Add(1, 'One');
    LSourceDict.Add(2, 'Two');
    LSourceDict.Add(3, 'Three');

    LTargetDict.AddRange(LSourceDict);

    Assert.AreEqual(3, LTargetDict.Count, 'Deveria conter 3 elementos após AddRange');
    Assert.AreEqual('One', LTargetDict[1], 'Deveria conter o valor "One" para a chave 1');
    Assert.AreEqual('Two', LTargetDict[2], 'Deveria conter o valor "Two" para a chave 2');
    Assert.AreEqual('Three', LTargetDict[3], 'Deveria conter o valor "Three" para a chave 3');
  finally
    LSourceDict.Free;
  end;
end;

procedure TDictionaryHelperTest.TestDistinct;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LDistinct: IFluentEnumerable<TPair<Integer, String>>;
  LResult: TDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'One');
    LDictionary.Add(3, 'Two');
    LDictionary.Add(4, 'Two');

    LDistinct := LDictionary.AsEnumerable.DistinctBy<String>(
      function(Pair: TPair<Integer, String>): String
      begin
        Result := Pair.Value;
      end);

    LResult := LDistinct.ToDictionary<Integer, String>(
      function(Pair: TPair<Integer, String>): Integer
      begin
        Result := Pair.Key;
      end,
      function(Pair: TPair<Integer, String>): String
      begin
        Result := Pair.Value;
      end);

    Assert.AreEqual(2, LResult.Count, 'Deveria ter 2 elementos após o Distinct');
    Assert.IsTrue(LResult.ContainsValue('One'), 'Deveria conter "One"');
    Assert.IsTrue(LResult.ContainsValue('Two'), 'Deveria conter "Two"');
  finally
    LDictionary.Free;
    LResult.Free;
  end;
end;

procedure TDictionaryHelperTest.TestAdd;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    Assert.AreEqual(2, LDictionary.Count, 'Deveria ter 2 elementos após Add');
    Assert.AreEqual('One', LDictionary[1], 'Deveria conter "One" para chave 1');
    Assert.AreEqual('Two', LDictionary[2], 'Deveria conter "Two" para chave 2');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestAddRangeEnumerable;
var
  LSource: TList<TPair<Integer, String>>;
  LTargetDict: TFluentDictionary<Integer, String>;
begin
  LSource := TList<TPair<Integer, String>>.Create;
  LTargetDict := TFluentDictionary<Integer, String>.Create;
  try
    LSource.Add(TPair<Integer, String>.Create(1, 'One'));
    LSource.Add(TPair<Integer, String>.Create(2, 'Two'));

    LTargetDict.AddRange(LSource);

    Assert.AreEqual(2, LTargetDict.Count, 'Deveria conter 2 elementos após AddRange');
    Assert.AreEqual('One', LTargetDict[1], 'Deveria conter "One" para chave 1');
    Assert.AreEqual('Two', LTargetDict[2], 'Deveria conter "Two" para chave 2');
  finally
    LSource.Free;
    LTargetDict.Free;
  end;
end;

procedure TDictionaryHelperTest.TestRemove;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LDictionary.Remove(1);

    Assert.AreEqual(1, LDictionary.Count, 'Deveria ter 1 elemento após Remove');
    Assert.IsFalse(LDictionary.ContainsKey(1), 'Não deveria conter a chave 1');
    Assert.AreEqual('Two', LDictionary[2], 'Deveria conter "Two" para chave 2');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestClear;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LDictionary.Clear;

    Assert.AreEqual(0, LDictionary.Count, 'Deveria estar vazio após Clear');
    Assert.IsTrue(LDictionary.IsEmpty, 'Deveria estar vazio');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestTrimExcess;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LInitialCapacity: Integer;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create(10);
  try
    LInitialCapacity := LDictionary.Capacity;
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LDictionary.TrimExcess;

    Assert.AreEqual(2, LDictionary.Count, 'Deveria manter 2 elementos');
    Assert.IsTrue(LDictionary.Capacity < LInitialCapacity, 'Capacidade deveria ser reduzida');
    Assert.AreEqual('One', LDictionary[1], 'Deveria conter "One"');
    Assert.AreEqual('Two', LDictionary[2], 'Deveria conter "Two"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestAddOrSetValue;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.AddOrSetValue(1, 'One');
    LDictionary.AddOrSetValue(1, 'Uno');

    Assert.AreEqual(1, LDictionary.Count, 'Deveria ter 1 elemento após AddOrSetValue');
    Assert.AreEqual('Uno', LDictionary[1], 'Deveria ter substituído "One" por "Uno"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestExtractPair;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LPair: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');

    LPair := LDictionary.ExtractPair(1);

    Assert.AreEqual(0, LDictionary.Count, 'Deveria estar vazio após ExtractPair');
    Assert.AreEqual(1, LPair.Key, 'Chave extraída deveria ser 1');
    Assert.AreEqual('One', LPair.Value, 'Valor extraído deveria ser "One"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestTryGetValue;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LValue: String;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');

    Assert.IsTrue(LDictionary.TryGetValue(1, LValue), 'Deveria encontrar a chave 1');
    Assert.AreEqual('One', LValue, 'Valor deveria ser "One"');
    Assert.IsFalse(LDictionary.TryGetValue(2, LValue), 'Não deveria encontrar a chave 2');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestTryAdd;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    Assert.IsTrue(LDictionary.TryAdd(1, 'One'), 'Deveria adicionar a chave 1');
    Assert.IsFalse(LDictionary.TryAdd(1, 'Uno'), 'Não deveria adicionar a chave 1 novamente');
    Assert.AreEqual(1, LDictionary.Count, 'Deveria ter 1 elemento');
    Assert.AreEqual('One', LDictionary[1], 'Valor deveria ser "One"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestContainsKey;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');

    Assert.IsTrue(LDictionary.ContainsKey(1), 'Deveria conter a chave 1');
    Assert.IsFalse(LDictionary.ContainsKey(2), 'Não deveria conter a chave 2');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestContainsValue;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');

    Assert.IsTrue(LDictionary.ContainsValue('One'), 'Deveria conter o valor "One"');
    Assert.IsFalse(LDictionary.ContainsValue('Two'), 'Não deveria conter o valor "Two"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestToArray;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LArray: TArray<TPair<Integer, String>>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LArray := LDictionary.ToArray;

    Assert.AreEqual(2, Length(LArray), 'Deveria ter 2 elementos no array');
    Assert.IsTrue((LArray[0].Key = 1) and (LArray[0].Value = 'One') or
                  (LArray[1].Key = 1) and (LArray[1].Value = 'One'), 'Deveria conter par 1:One');
    Assert.IsTrue((LArray[0].Key = 2) and (LArray[0].Value = 'Two') or
                  (LArray[1].Key = 2) and (LArray[1].Value = 'Two'), 'Deveria conter par 2:Two');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestCapacity;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LInitialCapacity: Integer;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create(10);
  try
    Assert.IsTrue(LDictionary.Capacity >= 10, 'Capacidade inicial deveria ser pelo menos 10, mas foi ' + IntToStr(LDictionary.Capacity));
    Assert.IsTrue(LDictionary.Capacity <= 32, 'Capacidade inicial não deveria exceder o mínimo padrão de 32, mas foi ' + IntToStr(LDictionary.Capacity));
    LInitialCapacity := LDictionary.Capacity;

    LDictionary.Capacity := 5;
    Assert.IsTrue(LDictionary.Capacity >= 5, 'Capacidade deveria ser ajustada para pelo menos 5, mas foi ' + IntToStr(LDictionary.Capacity));
    Assert.IsTrue(LDictionary.Capacity <= LInitialCapacity, 'Capacidade ajustada não deveria exceder a inicial, mas foi ' + IntToStr(LDictionary.Capacity));
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestCount;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    Assert.AreEqual(0, LDictionary.Count, 'Count inicial deveria ser 0');

    LDictionary.Add(1, 'One');
    Assert.AreEqual(1, LDictionary.Count, 'Count deveria ser 1 após adicionar');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestIsEmpty;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    Assert.IsTrue(LDictionary.IsEmpty, 'Deveria estar vazio inicialmente');

    LDictionary.Add(1, 'One');
    Assert.IsFalse(LDictionary.IsEmpty, 'Não deveria estar vazio após adicionar');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestGrowThreshold;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create(10);
  try
    Assert.IsTrue(LDictionary.GrowThreshold > 0, 'GrowThreshold deveria ser maior que 0');
    Assert.IsTrue(LDictionary.GrowThreshold <= LDictionary.Capacity, 'GrowThreshold deveria ser menor ou igual à capacidade');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestCollisions;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    Assert.AreEqual(0, LDictionary.Collisions, 'Collisions deveria ser 0 inicialmente');

    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    Assert.IsTrue(LDictionary.Collisions >= 0, 'Collisions deveria ser não-negativo após adicionar');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestKeys;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LKeys: TDictionary<Integer, String>.TKeyCollection;
  LKeyArray: TArray<Integer>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LKeys := LDictionary.Keys;
    LKeyArray := LKeys.ToArray;

    Assert.AreEqual(2, LKeys.Count, 'Keys deveria ter 2 elementos');
    Assert.IsTrue(TArray.Contains<Integer>(LKeyArray, 1), 'Deveria conter a chave 1');
    Assert.IsTrue(TArray.Contains<Integer>(LKeyArray, 2), 'Deveria conter a chave 2');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestValues;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LValues: TDictionary<Integer, String>.TValueCollection;
  LValueArray: TArray<String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LValues := LDictionary.Values;
    LValueArray := LValues.ToArray;

    Assert.AreEqual(2, LValues.Count, 'Values deveria ter 2 elementos');
    Assert.IsTrue(TArray.Contains<String>(LValueArray, 'One'), 'Deveria conter o valor "One"');
    Assert.IsTrue(TArray.Contains<String>(LValueArray, 'Two'), 'Deveria conter o valor "Two"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestComparer;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LComparer: IEqualityComparer<Integer>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LComparer := LDictionary.Comparer;

    Assert.IsNotNull(LComparer, 'Comparer não deveria ser nulo');
    Assert.IsTrue(LComparer.Equals(1, 1), 'Comparer deveria considerar 1 igual a 1');
    Assert.IsFalse(LComparer.Equals(1, 2), 'Comparer não deveria considerar 1 igual a 2');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestItemsGet;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');

    Assert.AreEqual('One', LDictionary.Items[1], 'Deveria retornar "One" para chave 1');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestItemsSet;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Items[1] := 'Uno';

    Assert.AreEqual('Uno', LDictionary[1], 'Deveria ter atualizado o valor para "Uno"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestOnKeyNotify;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.OnKeyNotify := OnKeyNotify;
    LDictionary.Add(1, 'One');

    Assert.IsTrue(FKeyNotified, 'OnKeyNotify deveria ter sido disparado ao adicionar');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestOnValueNotify;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.OnValueNotify := OnValueNotify;
    LDictionary.Add(1, 'One');

    Assert.IsTrue(FValueNotified, 'OnValueNotify deveria ter sido disparado ao adicionar');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestCreateWithComparer;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LComparer: IEqualityComparer<Integer>;
begin
  LComparer := TEqualityComparer<Integer>.Default;
  LDictionary := TFluentDictionary<Integer, String>.Create(LComparer);
  try
    LDictionary.Add(1, 'One');
    Assert.AreEqual(1, LDictionary.Count, 'Deveria ter 1 elemento');
    Assert.AreEqual('One', LDictionary[1], 'Deveria conter "One" para chave 1');
    Assert.AreEqual(LComparer, LDictionary.Comparer, 'Deveria usar o comparador fornecido');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestCreateWithCapacityAndComparer;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LComparer: IEqualityComparer<Integer>;
begin
  LComparer := TEqualityComparer<Integer>.Default;
  LDictionary := TFluentDictionary<Integer, String>.Create(5, LComparer);
  try
    Assert.IsTrue(LDictionary.Capacity >= 5, 'Capacidade inicial deveria ser pelo menos 5');
    LDictionary.Add(1, 'One');
    Assert.AreEqual(1, LDictionary.Count, 'Deveria ter 1 elemento');
    Assert.AreEqual('One', LDictionary[1], 'Deveria conter "One" para chave 1');
    Assert.AreEqual(LComparer, LDictionary.Comparer, 'Deveria usar o comparador fornecido');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestCreateWithEnumerable;
var
  LSource: TList<TPair<Integer, String>>;
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LSource := TList<TPair<Integer, String>>.Create;
  try
    LSource.Add(TPair<Integer, String>.Create(1, 'One'));
    LSource.Add(TPair<Integer, String>.Create(2, 'Two'));

    LDictionary := TFluentDictionary<Integer, String>.Create(LSource);
    try
      Assert.AreEqual(2, LDictionary.Count, 'Deveria ter 2 elementos');
      Assert.AreEqual('One', LDictionary[1], 'Deveria conter "One" para chave 1');
      Assert.AreEqual('Two', LDictionary[2], 'Deveria conter "Two" para chave 2');
    finally
      LDictionary.Free;
    end;
  finally
    LSource.Free;
  end;
end;

procedure TDictionaryHelperTest.TestCreateWithEnumerableAndComparer;
var
  LSource: TList<TPair<Integer, String>>;
  LDictionary: TFluentDictionary<Integer, String>;
  LComparer: IEqualityComparer<Integer>;
begin
  LSource := TList<TPair<Integer, String>>.Create;
  LComparer := TEqualityComparer<Integer>.Default;
  try
    LSource.Add(TPair<Integer, String>.Create(1, 'One'));
    LSource.Add(TPair<Integer, String>.Create(2, 'Two'));

    LDictionary := TFluentDictionary<Integer, String>.Create(LSource, LComparer);
    try
      Assert.AreEqual(2, LDictionary.Count, 'Deveria ter 2 elementos');
      Assert.AreEqual('One', LDictionary[1], 'Deveria conter "One" para chave 1');
      Assert.AreEqual('Two', LDictionary[2], 'Deveria conter "Two" para chave 2');
      Assert.AreEqual(LComparer, LDictionary.Comparer, 'Deveria usar o comparador fornecido');
    finally
      LDictionary.Free;
    end;
  finally
    LSource.Free;
  end;
end;

procedure TDictionaryHelperTest.TestCreateWithArray;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create([TPair<Integer, String>.Create(1, 'One'), TPair<Integer, String>.Create(2, 'Two')]);
  try
    Assert.AreEqual(2, LDictionary.Count, 'Deveria ter 2 elementos');
    Assert.AreEqual('One', LDictionary[1], 'Deveria conter "One" para chave 1');
    Assert.AreEqual('Two', LDictionary[2], 'Deveria conter "Two" para chave 2');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestCreateWithArrayAndComparer;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LComparer: IEqualityComparer<Integer>;
begin
  LComparer := TEqualityComparer<Integer>.Default;
  LDictionary := TFluentDictionary<Integer, String>.Create([TPair<Integer, String>.Create(1, 'One'), TPair<Integer, String>.Create(2, 'Two')], LComparer);
  try
    Assert.AreEqual(2, LDictionary.Count, 'Deveria ter 2 elementos');
    Assert.AreEqual('One', LDictionary[1], 'Deveria conter "One" para chave 1');
    Assert.AreEqual('Two', LDictionary[2], 'Deveria conter "Two" para chave 2');
    Assert.AreEqual(LComparer, LDictionary.Comparer, 'Deveria usar o comparador fornecido');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestCreateWithDictOwns;
var
  LSourceDict: TDictionary<Integer, String>;
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LSourceDict := TDictionary<Integer, String>.Create;
  try
    LSourceDict.Add(1, 'One');
    LSourceDict.Add(2, 'Two');

    LDictionary := TFluentDictionary<Integer, String>.Create(LSourceDict, True);
    try
      Assert.AreEqual(2, LDictionary.Count, 'Deveria ter 2 elementos');
      Assert.AreEqual('One', LDictionary[1], 'Deveria conter "One" para chave 1');
      Assert.AreEqual('Two', LDictionary[2], 'Deveria conter "Two" para chave 2');
    finally
      LDictionary.Free; // LSourceDict será liberado aqui por FOwnsDict = True
    end;
  finally
    // Não libera LSourceDict aqui, pois LDictionary já o fez
  end;
end;

procedure TDictionaryHelperTest.TestCreateWithDictNoOwns;
var
  LSourceDict: TDictionary<Integer, String>;
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LSourceDict := TDictionary<Integer, String>.Create;
  try
    LSourceDict.Add(1, 'One');
    LSourceDict.Add(2, 'Two');

    LDictionary := TFluentDictionary<Integer, String>.Create(LSourceDict, False);
    try
      Assert.AreEqual(2, LDictionary.Count, 'Deveria ter 2 elementos');
      Assert.AreEqual('One', LDictionary[1], 'Deveria conter "One" para chave 1');
      Assert.AreEqual('Two', LDictionary[2], 'Deveria conter "Two" para chave 2');
    finally
      LDictionary.Free; // Não libera LSourceDict aqui por FOwnsDict = False
    end;
    Assert.AreEqual(2, LSourceDict.Count, 'LSourceDict deveria ainda existir com 2 elementos');
  finally
    LSourceDict.Free; // Libera aqui por FOwnsDict = False
  end;
end;


procedure TDictionaryHelperTest.TestFromDict;
var
  LSourceDict: TDictionary<Integer, String>;
  LTempDict: TFluentDictionary<Integer, String>;
  LEnumerable: IFluentEnumerable<TPair<Integer, String>>;
  LResult: TDictionary<Integer, String>;
begin
  LSourceDict := TDictionary<Integer, String>.Create;
  try
    LSourceDict.Add(1, 'One');
    LSourceDict.Add(2, 'Two');

    LTempDict := TFluentDictionary<Integer, String>.Create(LSourceDict);
    try
      LEnumerable := LTempDict.AsEnumerable;
      LResult := LEnumerable.ToDictionary<Integer, String>(
        function(Pair: TPair<Integer, String>): Integer
        begin
          Result := Pair.Key;
        end,
        function(Pair: TPair<Integer, String>): String
        begin
          Result := Pair.Value;
        end);

      Assert.AreEqual(2, LResult.Count, 'Deveria ter 2 elementos');
      Assert.AreEqual('One', LResult[1], 'Deveria conter "One" para chave 1');
      Assert.AreEqual('Two', LResult[2], 'Deveria conter "Two" para chave 2');
    finally
      LTempDict.Free;
    end;
  finally
    LSourceDict.Free;
    LResult.Free;
  end;
end;

procedure TDictionaryHelperTest.TestFromArray;
var
  LTempDict: TFluentDictionary<Integer, String>;
  LEnumerable: IFluentEnumerable<TPair<Integer, String>>;
  LResult: TDictionary<Integer, String>;
begin
  LTempDict := TFluentDictionary<Integer, String>.Create([TPair<Integer, String>.Create(1, 'One'), TPair<Integer, String>.Create(2, 'Two')]);
  try
    LEnumerable := LTempDict.AsEnumerable;
    LResult := LEnumerable.ToDictionary<Integer, String>(
      function(Pair: TPair<Integer, String>): Integer
      begin
        Result := Pair.Key;
      end,
      function(Pair: TPair<Integer, String>): String
      begin
        Result := Pair.Value;
      end);
    try
      Assert.AreEqual(2, LResult.Count, 'Deveria ter 2 elementos');
      Assert.AreEqual('One', LResult[1], 'Deveria conter "One" para chave 1');
      Assert.AreEqual('Two', LResult[2], 'Deveria conter "Two" para chave 2');
    finally
      LResult.Free;
    end;
  finally
    LTempDict.Free;
  end;
end;

procedure TDictionaryHelperTest.TestGetEnumerator;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LEnum: IFluentEnum<TPair<Integer, String>>;
  LCount: Integer;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LEnum := LDictionary.AsEnumerable.GetEnumerator;
    LCount := 0;
    while LEnum.MoveNext do
      Inc(LCount);

    Assert.AreEqual(2, LCount, 'Deveria enumerar 2 elementos');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestCycle;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LResult: TArray<TPair<Integer, String>>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LResult := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).Cycle(3).ToArray;

    Assert.AreEqual(6, Length(LResult), 'Deveria repetir 3 vezes (2 elementos x 3 = 6)');
    Assert.AreEqual('One', LResult[0].Value, 'Primeiro ciclo deveria conter "One"');
    Assert.AreEqual('Two', LResult[1].Value, 'Primeiro ciclo deveria conter "Two"');
    Assert.AreEqual('One', LResult[2].Value, 'Segundo ciclo deveria conter "One"');
    Assert.AreEqual('Two', LResult[3].Value, 'Segundo ciclo deveria conter "Two"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestTee;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LResult: TArray<TPair<Integer, String>>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LResult := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).Tee(2).ToArray;

    Assert.AreEqual(4, Length(LResult), 'Deveria duplicar 2 vezes (2 elementos x 2 = 4)');
    Assert.AreEqual('One', LResult[0].Value, 'Primeira repetição deveria conter "One"');
    Assert.AreEqual('Two', LResult[1].Value, 'Primeira repetição deveria conter "Two"');
    Assert.AreEqual('One', LResult[2].Value, 'Segunda repetição deveria conter "One"');
    Assert.AreEqual('Two', LResult[3].Value, 'Segunda repetição deveria conter "Two"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestElementAt;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LElement: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LElement := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).ElementAt(1);

    Assert.AreEqual(2, LElement.Key, 'Elemento no índice 1 deveria ter chave 2');
    Assert.AreEqual('Two', LElement.Value, 'Elemento no índice 1 deveria ser "Two"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestElementAtOrDefault;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LElement: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');

    LElement := LDictionary.AsEnumerable.ElementAtOrDefault(1);

    Assert.AreEqual(0, LElement.Key, 'Elemento fora do índice deveria ter chave default 0');
    Assert.AreEqual('', LElement.Value, 'Elemento fora do índice deveria ter valor default vazio');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestTakeWhile;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LResult: TArray<TPair<Integer, String>>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LResult := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).TakeWhile(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key < 3;
      end).ToArray;

    Assert.AreEqual(2, Length(LResult), 'Deveria pegar 2 elementos até chave < 3');
    Assert.AreEqual('One', LResult[0].Value, 'Deveria conter "One"');
    Assert.AreEqual('Two', LResult[1].Value, 'Deveria conter "Two"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestSkipWhile;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LResult: TArray<TPair<Integer, String>>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LResult := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).SkipWhile(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key < 2;
      end).ToArray;

    Assert.AreEqual(2, Length(LResult), 'Deveria pular até chave >= 2');
    Assert.AreEqual('Two', LResult[0].Value, 'Deveria começar com "Two"');
    Assert.AreEqual('Three', LResult[1].Value, 'Deveria conter "Three"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestFirst;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LFirst: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LFirst := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).First(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key > 0; // Pega o primeiro com chave > 0
      end);

    Assert.AreEqual(1, LFirst.Key, 'Primeiro elemento deveria ter chave 1');
    Assert.AreEqual('One', LFirst.Value, 'Primeiro elemento deveria ser "One"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestFirstOrDefault;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LFirst: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LFirst := LDictionary.AsEnumerable.FirstOrDefault(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key = 1;
      end);

    Assert.AreEqual(0, LFirst.Key, 'Primeiro elemento de dicionário vazio deveria ter chave default 0');
    Assert.AreEqual('', LFirst.Value, 'Primeiro elemento de dicionário vazio deveria ter valor default vazio');

    LDictionary.Add(1, 'One');
    LFirst := LDictionary.AsEnumerable.FirstOrDefault(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key = 1;
      end);

    Assert.AreEqual(1, LFirst.Key, 'Primeiro elemento deveria ter chave 1');
    Assert.AreEqual('One', LFirst.Value, 'Primeiro elemento deveria ser "One"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestLast;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LLast: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LLast := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).Last(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key > 0; // Pega o último com chave > 0
      end);

    Assert.AreEqual(2, LLast.Key, 'Último elemento deveria ter chave 2');
    Assert.AreEqual('Two', LLast.Value, 'Último elemento deveria ser "Two"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestLastOrDefault;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LLast: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LLast := LDictionary.AsEnumerable.LastOrDefault(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key = 2;
      end);

    Assert.AreEqual(0, LLast.Key, 'Último elemento de dicionário vazio deveria ter chave default 0');
    Assert.AreEqual('', LLast.Value, 'Último elemento de dicionário vazio deveria ter valor default vazio');

    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LLast := LDictionary.AsEnumerable.LastOrDefault(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key = 2;
      end);

    Assert.AreEqual(2, LLast.Key, 'Último elemento deveria ter chave 2');
    Assert.AreEqual('Two', LLast.Value, 'Último elemento deveria ser "Two"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestSingle;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LSingle: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');

    LSingle := LDictionary.AsEnumerable.Single(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key = 1;
      end);

    Assert.AreEqual(1, LSingle.Key, 'Elemento único deveria ter chave 1');
    Assert.AreEqual('One', LSingle.Value, 'Elemento único deveria ser "One"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestSingleOrDefault;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LSingle: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LSingle := LDictionary.AsEnumerable.SingleOrDefault(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key = 1;
      end);

    Assert.AreEqual(0, LSingle.Key, 'Elemento único de dicionário vazio deveria ter chave default 0');
    Assert.AreEqual('', LSingle.Value, 'Elemento único de dicionário vazio deveria ter valor default vazio');

    LDictionary.Add(1, 'One');
    LSingle := LDictionary.AsEnumerable.SingleOrDefault(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key = 1;
      end);

    Assert.AreEqual(1, LSingle.Key, 'Elemento único deveria ter chave 1');
    Assert.AreEqual('One', LSingle.Value, 'Elemento único deveria ser "One"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestOfType;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LResult: TArray<TPair<Integer, String>>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LResult := LDictionary.AsEnumerable.OfType<TPair<Integer, String>>(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key > 1;
      end,
      function(Pair: TPair<Integer, String>): TPair<Integer, String>
      begin
        Result := Pair;
      end).ToArray;

    Assert.AreEqual(1, Length(LResult), 'Deveria ter 1 elemento do tipo filtrado');
    Assert.AreEqual(2, LResult[0].Key, 'Deveria conter chave 2');
    Assert.AreEqual('Two', LResult[0].Value, 'Deveria conter "Two"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestExclude;
var
  LDictionary1, LDictionary2: IFluentDictionary<Integer, String>;
  LResult: TArray<TPair<Integer, String>>;
begin
  LDictionary1 := TFluentDictionary<Integer, String>.Create;
  LDictionary2 := TFluentDictionary<Integer, String>.Create;
  LDictionary1.Add(1, 'One');
  LDictionary1.Add(2, 'Two');
  LDictionary1.Add(3, 'Three');

  LDictionary2.Add(2, 'Two');

  LResult := LDictionary1.AsEnumerable
                         .Exclude(LDictionary2.AsEnumerable)
                         .OrderBy(function(A, B: TPair<Integer, String>): Integer
                                  begin
                                    Result := A.Key - B.Key;
                                  end)
                         .ToArray;

  Assert.AreEqual(2, Length(LResult), 'Deveria excluir 1 elemento');
  Assert.AreEqual('One', LResult[0].Value, 'Deveria conter "One"');
  Assert.AreEqual('Three', LResult[1].Value, 'Deveria conter "Three"');
end;

procedure TDictionaryHelperTest.TestIntersect;
var
  LDictionary1, LDictionary2: TFluentDictionary<Integer, String>;
  LResult: TArray<TPair<Integer, String>>;
begin
  LDictionary1 := TFluentDictionary<Integer, String>.Create;
  LDictionary2 := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary1.Add(1, 'One');
    LDictionary1.Add(2, 'Two');
    LDictionary1.Add(3, 'Three');

    LDictionary2.Add(2, 'Two');
    LDictionary2.Add(3, 'Three');

    LResult := LDictionary1.AsEnumerable.Intersect(LDictionary2.AsEnumerable).OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).ToArray;

    Assert.AreEqual(2, Length(LResult), 'Deveria ter 2 elementos em comum');
    Assert.AreEqual('Two', LResult[0].Value, 'Deveria conter "Two"');
    Assert.AreEqual('Three', LResult[1].Value, 'Deveria conter "Three"');
  finally
    LDictionary1.Free;
    LDictionary2.Free;
  end;
end;

procedure TDictionaryHelperTest.TestUnion;
var
  LDictionary1, LDictionary2: TFluentDictionary<Integer, String>;
  LResult: TArray<TPair<Integer, String>>;
begin
  LDictionary1 := TFluentDictionary<Integer, String>.Create;
  LDictionary2 := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary1.Add(1, 'One');
    LDictionary1.Add(2, 'Two');

    LDictionary2.Add(2, 'Two');
    LDictionary2.Add(3, 'Three');

    LResult := LDictionary1.AsEnumerable.Union(LDictionary2.AsEnumerable).OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).ToArray;

    Assert.AreEqual(3, Length(LResult), 'Deveria ter 3 elementos únicos');
    Assert.AreEqual('One', LResult[0].Value, 'Deveria conter "One"');
    Assert.AreEqual('Two', LResult[1].Value, 'Deveria conter "Two"');
    Assert.AreEqual('Three', LResult[2].Value, 'Deveria conter "Three"');
  finally
    LDictionary1.Free;
    LDictionary2.Free;
  end;
end;

procedure TDictionaryHelperTest.TestConcat;
var
  LDictionary1, LDictionary2: TFluentDictionary<Integer, String>;
  LResult: TArray<TPair<Integer, String>>;
begin
  LDictionary1 := TFluentDictionary<Integer, String>.Create;
  LDictionary2 := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary1.Add(1, 'One');
    LDictionary1.Add(2, 'Two');

    LDictionary2.Add(3, 'Three');
    LDictionary2.Add(4, 'Four');

    LResult := LDictionary1.AsEnumerable.Concat(LDictionary2.AsEnumerable).OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).ToArray;

    Assert.AreEqual(4, Length(LResult), 'Deveria concatenar todos os 4 elementos');
    Assert.AreEqual('One', LResult[0].Value, 'Deveria conter "One"');
    Assert.AreEqual('Two', LResult[1].Value, 'Deveria conter "Two"');
    Assert.AreEqual('Three', LResult[2].Value, 'Deveria conter "Three"');
    Assert.AreEqual('Four', LResult[3].Value, 'Deveria conter "Four"');
  finally
    LDictionary1.Free;
    LDictionary2.Free;
  end;
end;

procedure TDictionaryHelperTest.TestSequenceEqual;
var
  LDictionary1, LDictionary2: TFluentDictionary<Integer, String>;
begin
  LDictionary1 := TFluentDictionary<Integer, String>.Create;
  LDictionary2 := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary1.Add(1, 'One');
    LDictionary1.Add(2, 'Two');

    LDictionary2.Add(1, 'One');
    LDictionary2.Add(2, 'Two');

    Assert.IsTrue(LDictionary1.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).SequenceEqual(
      LDictionary2.AsEnumerable.OrderBy(
        function(A, B: TPair<Integer, String>): Integer
        begin
          Result := A.Key - B.Key;
        end)), 'Deveria ser igual com mesmas chaves e valores');

    LDictionary2.Clear;
    LDictionary2.Add(1, 'One');
    LDictionary2.Add(3, 'Three');

    Assert.IsFalse(LDictionary1.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).SequenceEqual(
      LDictionary2.AsEnumerable.OrderBy(
        function(A, B: TPair<Integer, String>): Integer
        begin
          Result := A.Key - B.Key;
        end)), 'Não deveria ser igual com valores diferentes');
  finally
    LDictionary1.Free;
    LDictionary2.Free;
  end;
end;

procedure TDictionaryHelperTest.TestOrderByDesc;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LResult: TArray<TPair<Integer, String>>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LResult := LDictionary.AsEnumerable.OrderByDesc(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).ToArray;

    Assert.AreEqual(3, Length(LResult), 'Deveria ter 3 elementos');
    Assert.AreEqual(3, LResult[0].Key, 'Primeiro deveria ser chave 3');
    Assert.AreEqual(1, LResult[2].Key, 'Último deveria ser chave 1');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestMin;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LMin: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LMin := LDictionary.AsEnumerable.Min;

    Assert.AreEqual(1, LMin.Key, 'Mínimo deveria ter chave 1');
    Assert.AreEqual('One', LMin.Value, 'Mínimo deveria ser "One"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestMinWithComparer;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LMin: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'Three');
    LDictionary.Add(2, 'One');
    LDictionary.Add(3, 'Two');

    LMin := LDictionary.AsEnumerable.Min(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := CompareStr(A.Value, B.Value);
      end);

    Assert.AreEqual(2, LMin.Key, 'Mínimo por valor deveria ter chave 2');
    Assert.AreEqual('One', LMin.Value, 'Mínimo por valor deveria ser "One"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestMax;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LMax: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LMax := LDictionary.AsEnumerable.Max;

    Assert.AreEqual(3, LMax.Key, 'Máximo deveria ter chave 3');
    Assert.AreEqual('Three', LMax.Value, 'Máximo deveria ser "Three"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestMaxWithComparer;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LMax: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Three');
    LDictionary.Add(3, 'Two');

    LMax := LDictionary.AsEnumerable.Max(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := CompareStr(A.Value, B.Value);
      end);

    Assert.AreEqual(3, LMax.Key, 'Máximo por valor deveria ter chave 2');
    Assert.AreEqual('Two', LMax.Value, 'Máximo por valor deveria ser "Three"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestMinBy;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LMin: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LMin := LDictionary.AsEnumerable.MinBy<String>(
      function(Pair: TPair<Integer, String>): String
      begin
        Result := Pair.Value;
      end,
      function(A, B: String): Integer
      begin
        Result := CompareStr(A, B);
      end);

    Assert.AreEqual(1, LMin.Key, 'Mínimo por valor deveria ter chave 1');
    Assert.AreEqual('One', LMin.Value, 'Mínimo por valor deveria ser "One"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestMaxBy;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LMax: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LMax := LDictionary.AsEnumerable.MaxBy<String>(
      function(Pair: TPair<Integer, String>): String
      begin
        Result := Pair.Value;
      end,
      function(A, B: String): Integer
      begin
        Result := CompareStr(A, B);
      end);

    Assert.AreEqual(2, LMax.Key, 'Máximo por valor deveria ter chave 2');
    Assert.AreEqual('Two', LMax.Value, 'Máximo por valor deveria ser "Two"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestFlatMap;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LResult: TArray<String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LResult := LDictionary.AsEnumerable.FlatMap<String>(
      function(Pair: TPair<Integer, String>): TArray<String>
      begin
        Result := [Pair.Value, Pair.Value + 'Flat'];
      end).ToArray;

    Assert.AreEqual(4, Length(LResult), 'Deveria achatar pra 4 elementos');
    Assert.IsTrue(TArray.Contains<String>(LResult, 'One'), 'Deveria conter "One"');
    Assert.IsTrue(TArray.Contains<String>(LResult, 'OneFlat'), 'Deveria conter "OneFlat"');
    Assert.IsTrue(TArray.Contains<String>(LResult, 'Two'), 'Deveria conter "Two"');
    Assert.IsTrue(TArray.Contains<String>(LResult, 'TwoFlat'), 'Deveria conter "TwoFlat"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestSelectMany;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LResult: TArray<String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LResult := LDictionary.AsEnumerable.SelectMany<String>(
      function(Pair: TPair<Integer, String>): IFluentWrapper<String>
      var
        LArray: TArray<String>;
        LEnum: IFluentEnumerable<String>;
      begin
        LArray := TArray<String>.Create(Pair.Value, Pair.Value + 'Many');
        LEnum := IFluentEnumerable<String>.Create(TArrayAdapter<String>.Create(LArray));
        Result := TFluentWrapper<String>.Create(LEnum, nil);
      end).ToArray;

    Assert.AreEqual(4, Length(LResult), 'Deveria achatar pra 4 elementos');
    Assert.IsTrue(TArray.Contains<String>(LResult, 'One'), 'Deveria conter "One"');
    Assert.IsTrue(TArray.Contains<String>(LResult, 'OneMany'), 'Deveria conter "OneMany"');
    Assert.IsTrue(TArray.Contains<String>(LResult, 'Two'), 'Deveria conter "Two"');
    Assert.IsTrue(TArray.Contains<String>(LResult, 'TwoMany'), 'Deveria conter "TwoMany"');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestGroupBy;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LGroups: IGroupedEnumerator<String, TPair<Integer, String>>;
  LEnum: IFluentEnum<IGrouping<String, TPair<Integer, String>>>;
  LGroup: IGrouping<String, TPair<Integer, String>>;
  LCount: Integer;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LGroups := LDictionary.AsEnumerable.GroupBy<String>(
      function(Pair: TPair<Integer, String>): String
      begin
        Result := Copy(Pair.Value, 1, 1); // Agrupa pela primeira letra
      end);

    LEnum := LGroups.GetEnumerator;
    LCount := 0;
    while LEnum.MoveNext do
    begin
      Inc(LCount);
      LGroup := LEnum.Current;
      if LGroup.Key = 'O' then
        Assert.AreEqual(1, Length(LGroup.Items.ToArray), 'Grupo "O" deveria ter 1 elemento ("One")')
      else if LGroup.Key = 'T' then
        Assert.AreEqual(2, Length(LGroup.Items.ToArray), 'Grupo "T" deveria ter 2 elementos ("Two", "Three")');
    end;
    Assert.AreEqual(2, LCount, 'Deveria ter 2 grupos');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestGroupJoin;
var
  LDictionary1, LDictionary2: TFluentDictionary<Integer, String>;
  LResult: TArray<String>;
begin
  LDictionary1 := TFluentDictionary<Integer, String>.Create;
  LDictionary2 := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary1.Add(1, 'One');
    LDictionary1.Add(2, 'Two');

    LDictionary2.Add(1, 'Uno'); // Removemos a duplicata
    LDictionary2.Add(2, 'Dos');

    LResult := LDictionary1.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).GroupJoin<TPair<Integer, String>, Integer, String>(
      LDictionary2.AsEnumerable.OrderBy(
        function(A, B: TPair<Integer, String>): Integer
        begin
          Result := A.Key - B.Key;
        end),
      function(Pair1: TPair<Integer, String>): Integer
      begin
        Result := Pair1.Key;
      end,
      function(Pair2: TPair<Integer, String>): Integer
      begin
        Result := Pair2.Key;
      end,
      function(Pair1: TPair<Integer, String>; Inner: IFluentWrapper<TPair<Integer, String>>): String
      var
        LInnerArray: TArray<TPair<Integer, String>>;
      begin
        LInnerArray := Inner.Value.OrderBy(
          function(A, B: TPair<Integer, String>): Integer
          begin
            Result := CompareStr(A.Value, B.Value);
          end).ToArray;
        if Length(LInnerArray) > 0 then
          Result := Pair1.Value + ' | ' + LInnerArray[0].Value
        else
          Result := Pair1.Value;
      end).ToArray;

    Assert.AreEqual(2, Length(LResult), 'Deveria ter 2 grupos juntados');
    Assert.AreEqual('One | Uno', LResult[0], 'Deveria juntar "One | Uno"'); // Ajustado para refletir o novo valor
    Assert.AreEqual('Two | Dos', LResult[1], 'Deveria juntar "Two | Dos"');
  finally
    LDictionary1.Free;
    LDictionary2.Free;
  end;
end;

procedure TDictionaryHelperTest.TestReduceNoInitial;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LResult: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LResult := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).Reduce(
      function(Acc, Current: TPair<Integer, String>): TPair<Integer, String>
      begin
        Result.Key := Acc.Key + Current.Key;
        Result.Value := Acc.Value + Current.Value;
      end);

    Assert.AreEqual(3, LResult.Key, 'Deveria somar as chaves (1 + 2 = 3)');
    Assert.AreEqual('OneTwo', LResult.Value, 'Deveria concatenar os valores');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestReduceRight;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LResult: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LResult := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).ReduceRight(
      function(Acc, Current: TPair<Integer, String>): TPair<Integer, String>
      begin
        Result.Key := Acc.Key + Current.Key;
        Result.Value := Current.Value + Acc.Value;
      end,
      TPair<Integer, String>.Create(0, ''));

    Assert.AreEqual(3, LResult.Key, 'Deveria somar as chaves da direita (2 + 1 = 3)');
    Assert.AreEqual('TwoOne', LResult.Value, 'Deveria concatenar os valores da direita');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestReduceRightNoInitial;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LResult: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LResult := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).ReduceRight(
      function(Acc, Current: TPair<Integer, String>): TPair<Integer, String>
      begin
        Result.Key := Acc.Key + Current.Key;
        Result.Value := Current.Value + Acc.Value;
      end);

    Assert.AreEqual(3, LResult.Key, 'Deveria somar as chaves da direita (2 + 1 = 3)');
    Assert.AreEqual('TwoOne', LResult.Value, 'Deveria concatenar os valores da direita');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestSumInteger;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LSum: Integer;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LSum := LDictionary.AsEnumerable.Sum(
      function(Pair: TPair<Integer, String>): Integer
      begin
        Result := Pair.Key;
      end);

    Assert.AreEqual(6, LSum, 'Deveria somar as chaves (1 + 2 + 3 = 6)');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestSumDouble;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LSum: Double;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LSum := LDictionary.AsEnumerable.Sum(
      function(Pair: TPair<Integer, String>): Double
      begin
        Result := Pair.Key * 1.5;
      end);

    Assert.AreEqual(Double(9.0), LSum, 'Deveria somar as chaves ajustadas (1.5 + 3.0 + 4.5 = 9.0)');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestAverage;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LAverage: Double;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LAverage := LDictionary.AsEnumerable.Average(
      function(Pair: TPair<Integer, String>): Double
      begin
        Result := Pair.Key;
      end);

    Assert.AreEqual(Double(2.0), LAverage, 'Deveria calcular a média das chaves (1 + 2 + 3) / 3 = 2.0');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestCountWithPredicate;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LCount: Integer;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LCount := LDictionary.AsEnumerable.Count(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key > 1;
      end);

    Assert.AreEqual(2, LCount, 'Deveria contar 2 elementos com chave > 1');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestLongCount;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LCount: Int64;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    LCount := LDictionary.AsEnumerable.LongCount(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Pair.Key > 1;
      end);

    Assert.AreEqual(Int64(2), LCount, 'Deveria contar 2 elementos com chave > 1 em Int64');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestAll;
var
  LDictionary: TFluentDictionary<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');
    LDictionary.Add(3, 'Three');

    Assert.IsTrue(LDictionary.AsEnumerable.All(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Length(Pair.Value) >= 3;
      end), 'Todos os valores deveriam ter comprimento >= 3');

    LDictionary.Add(4, 'Hi');
    Assert.IsFalse(LDictionary.AsEnumerable.All(
      function(Pair: TPair<Integer, String>): Boolean
      begin
        Result := Length(Pair.Value) >= 3;
      end), 'Nem todos os valores deveriam ter comprimento >= 3');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestContainsFluent;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LContainsOne: Boolean;
  LContainsThree: Boolean;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LContainsOne := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).Contains(TPair<Integer, String>.Create(1, 'One'));
    Assert.IsTrue(LContainsOne, 'Deveria conter o par 1:One');

    LContainsThree := LDictionary.AsEnumerable.Contains(TPair<Integer, String>.Create(3, 'Three'));
    Assert.IsFalse(LContainsThree, 'Não deveria conter o par 3:Three');
  finally
    LDictionary.Free;
  end;
end;

procedure TDictionaryHelperTest.TestToList;
var
  LDictionary: TFluentDictionary<Integer, String>;
  LList: TList<TPair<Integer, String>>;
  FoundOne, FoundTwo: Boolean;
  Pair: TPair<Integer, String>;
begin
  LDictionary := TFluentDictionary<Integer, String>.Create;
  try
    LDictionary.Add(1, 'One');
    LDictionary.Add(2, 'Two');

    LList := LDictionary.AsEnumerable.OrderBy(
      function(A, B: TPair<Integer, String>): Integer
      begin
        Result := A.Key - B.Key;
      end).ToList;
    try
      Assert.AreEqual(2, LList.Count, 'Deveria ter 2 elementos na lista');

      FoundOne := False;
      FoundTwo := False;
      for Pair in LList do
      begin
        if (Pair.Key = 1) and (Pair.Value = 'One') then
          FoundOne := True;
        if (Pair.Key = 2) and (Pair.Value = 'Two') then
          FoundTwo := True;
        if FoundOne and FoundTwo then
          Break;
      end;

      Assert.IsTrue(FoundOne, 'Deveria conter o par 1:One');
      Assert.IsTrue(FoundTwo, 'Deveria conter o par 2:Two');
    finally
      LList.Free;
    end;
  finally
    LDictionary.Free;
  end;
end;
initialization
  TDUnitX.RegisterTestFixture(TDictionaryHelperTest);

end.
