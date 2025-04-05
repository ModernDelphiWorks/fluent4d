# Fluent4D: Fluent Data Library for Delphi

**Fluent4D** é uma biblioteca moderna para manipulação fluida de dados em Delphi, inspirada em outras linguagens. Com uma API fluida e suporte a operações "lazy" (execução adiada), Fluent4D permite consultar e processar dados de forma intuitiva e eficiente em diversas fontes, como coleções, JSON, XML, SQL e mais.

## Visão Geral

Fluent4D traz uma abordagem contemporânea para trabalhar com dados em Delphi, oferecendo:
- **Fluent API**: Encadeamento de métodos para manipulação de dados (ex.: `Filter(...).Take(...).ToArray`).
- **Lazy Evaluation**: Operações são executadas apenas quando necessário, otimizando desempenho.
- **Suporte Versátil**: Compatível com tipos nativos do Delphi (como `TList<T>`, `TDictionary<K, V>`, `TArray<T>`) e expansível para outras fontes de dados.

## Status do Projeto

O Fluent4D está em desenvolvimento ativo. Atualmente, estamos focados em:
- Suporte inicial a coleções genéricas (`TList<T>`, `TDictionary<K, V>`, `TArray<T>`).
- Estrutura unificada baseada em `IFluentEnumerable<T>` e `IFluentQueryable<T>` como records.
- Planejamento para expansão a JSON, XML, SQL, streams, texto e mais.

Fique à vontade para acompanhar o progresso, contribuir ou sugerir ideias!

## Como Usar

(Em breve! Exemplos de código serão adicionados assim que a primeira versão estiver pronta.)

Exemplo básico (futuro):
```delphi
var
  LList: TFluentList<Integer>;
  LResult: TArray<Integer>;
begin
  LList := TFluentList<Integer>.Create([1, 2, 3, 4, 5]);
  LResult := LList.Filter(function(X: Integer): Boolean begin Result := X > 3 end).ToArray;
  // LResult = [4, 5]
end;```
