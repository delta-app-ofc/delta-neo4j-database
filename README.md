# Modelo em Grafo (Neo4j)

Este diretório contém a modelagem em grafo do projeto (equivalente ao schema
relacional em SQL), o script de carga (`setup.cypher`), o loader Python para
rodar tudo de uma vez no Neo4j Aura, e as queries usadas para responder
perguntas de negócio via *traversal* (não apenas busca por nó).

## Arquivos

| Arquivo | O que é |
|---|---|
| `setup.cypher` | Cria constraints e popula o grafo |
| `load_graph.py` | Executa o `setup.cypher` inteiro no Aura numa única chamada |
| `querys/querys.cypher` | Queries de negócio e de visualização |
| `diagrams/` | PNGs gerados (query1.png, query2.png, ...) |
| `.env.example` | Modelo das variáveis de ambiente  |

## 1. Modelo de grafo

```
(User)-[:OWNS]->(Property)-[:LOCATED_AT]->(Address)-[:IN_REGION]->(Region)-[:HAS_RATE]->(RegionRate)
(Property)-[:HAS_DEVICE]->(Device)
(User)-[:HAS_BILL]->(WaterBill)
(User)-[:HAS_HABIT]->(UserHabit)-[:IS_HABIT]->(Habit)
(UserHabit)-[:ON_DAY]->(Day)
```

`UserHabit` é um nó de interseção: existe porque frequência e dias da semana
de um hábito variam **por usuário**, não pelo hábito em si. Por isso não há
relação direta `Habit -[:ON_DAY]-> Day` nem `User -[:PRACTICES]-> Habit` — só
existiria uma fonte de verdade duplicada.

## 2. Como obter as credenciais do Aura

1. Acesse [console.neo4j.io](https://console.neo4j.io) e faça login.
2. Clique na sua instância na lista de *Instances*.
3. Copie o campo **Connection URI** (começa com `neo4j+s://` e termina em
   `.databases.neo4j.io`) → isso é o `NEO4J_URI`.
4. O `NEO4J_USER` quase sempre é `neo4j` (usuário padrão).
5. A `NEO4J_PASSWORD` só aparece **uma vez**, no momento da criação da
   instância. Se você perdeu, use o botão **Reset DB Password** na página da
   instância para gerar uma nova (ela também só aparece uma vez — copie na
   hora).

## 3. Popular o banco

```bash
pip install neo4j --break-system-packages

python load_graph.py setup.cypher
```

Isso roda todas as instruções do `setup.cypher` em sequência (constraints,
dados, relacionamentos).

## 4. Pergunta de negócio e Traversal

Uma das perguntas de negócio respondidas pelo grafo é:

> **Quais usuários possuem hábitos praticados aos sábados e moram em regiões onde a tarifa de água é superior a R$ 8,00 por m³?**

Essa pergunta combina informações de diferentes partes do grafo. Para respondê-la, é necessário percorrer vários relacionamentos entre os nós.

O caminho relacionado aos hábitos é:

```text
User
  ↓ HAS_HABIT
UserHabit
  ↓ ON_DAY
Day (SÁBADO)
```

A partir do `UserHabit`, também é possível descobrir qual hábito está sendo praticado:

```text
UserHabit
  ↓ IS_HABIT
Habit
```

Além disso, é necessário descobrir a região onde o usuário está localizado e a tarifa correspondente:

```text
User
  ↓ OWNS
Property
  ↓ LOCATED_AT
Address
  ↓ IN_REGION
Region
  ↓ HAS_RATE
RegionRate
```

A consulta utilizada é:

```cypher
MATCH (u:User)-[:HAS_HABIT]->(uh:UserHabit)-[:ON_DAY]->(d:Day {name: "SÁBADO"})
MATCH (uh)-[:IS_HABIT]->(h:Habit)
MATCH (u)-[:OWNS]->(:Property)-[:LOCATED_AT]->(:Address)-[:IN_REGION]->(r:Region)-[:HAS_RATE]->(rr:RegionRate)
WHERE rr.m3Value > 8.00
RETURN
    u.name AS usuario,
    h.name AS habito,
    r.name AS regiao,
    rr.m3Value AS tarifa;
```

### Por que essa consulta é um Traversal?

A consulta não realiza apenas uma busca por um nó específico. Ela percorre diferentes nós e relacionamentos do grafo para cruzar informações sobre usuários, hábitos, dias, imóveis, endereços, regiões e tarifas.

O traversal pode ser representado da seguinte forma:

```text
                    ┌── UserHabit ── Day
                   /
User ─────────────
                   \
                    └── Property ── Address ── Region ── RegionRate
```

Dessa forma, a consulta utiliza a estrutura de relacionamentos do Neo4j para encontrar usuários que praticam hábitos aos sábados e que estão associados a regiões com tarifa superior a R$ 8,00 por m³.

## 5. Estrutura do repositório

```
delta-neo4j/
  ├── setup.cypher
  ├── load_graph.py
  ├── .env.example
  ├── .gitignore         
  ├── README.md
  ├── querys/
  │   └── querys.cypher
  └── diagrams/
      ├── query1.png
      ├── query2.png
      ├── query3.png
      └── query4.png
```