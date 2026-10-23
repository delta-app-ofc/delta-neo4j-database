# Modelo em Grafo (Neo4j)

Este diretório contém a modelagem em grafo do projeto DELTA (equivalente ao schema
relacional em SQL), o script de carga (`setup.cypher`), o loader Python para
rodar tudo de uma vez no Neo4j Aura, e as queries usadas para responder
perguntas de negócio via *traversal* (não apenas busca por nó).

> Documentação completa: [`delta-handbook/DADOS/NoSQL/modelagem-neo4j.md`](https://github.com/DELTA-docs/delta-handbook/blob/main/DADOS/NoSQL/modelagem-neo4j.md)

## Arquivos

| Arquivo | O que é |
|---|---|
| `setup.cypher` | Cria constraints, popula o grafo base com MERGE (idempotente) |
| `seed.cypher` | Adiciona usuários e dados adicionais para enriquecer o grafo |
| `load_graph.py` | Executa qualquer `.cypher` inteiro no Aura via Python |
| `querys/querys.cypher` | Queries de negócio e visualização (8 queries) |
| `querys/transversal.cypher` | Query transversal da pergunta de negócio principal |
| `.env.example` | Modelo das variáveis de ambiente |
| `diagrams/` | PNGs gerados (query1.png, query2.png, ...) |


## 1. Modelo de grafo

```
(User:Pessoa)-[:OWNS]->(Property:Casa|Predio:Residencial)
(Property)-[:LOCATED_AT]->(Address)-[:IN_REGION]->(Region)-[:HAS_RATE]->(RegionRate)
(Property)-[:HAS_DEVICE]->(Device)
(User)-[:HAS_BILL]->(WaterBill)
(User)-[:HAS_HABIT]->(UserHabit)-[:IS_HABIT]->(Habit)
(UserHabit)-[:ON_DAY]->(Day)
```

`UserHabit` é um nó de interseção: existe porque frequência e dias da semana
de um hábito variam **por usuário**, não pelo hábito em si.

### Multi-labels

Todo `User` também carrega o label `:Pessoa`, permitindo buscas genéricas por
entidades humanas. Os imóveis usam labels para tipo e classificação:

| Label | Significado |
|---|---|
| `:Casa` | Imóvel do tipo casa |
| `:Predio` | Imóvel do tipo prédio/apartamento |
| `:Residencial` | Classificação residencial |
| `:Comercial` | Classificação comercial |

Exemplo: `MATCH (p:Casa:Residencial)` filtra diretamente sem varredura por propriedade de texto.

### Entidades do grafo

| Nó | Labels | Representação |
|---|---|---|
| `User` | `:User:Pessoa` | Usuário do sistema |
| `Property` | `:Property:Casa:Residencial` ou `:Property:Predio:Residencial` | Imóvel associado ao usuário |
| `Address` | `:Address` | Endereço do imóvel |
| `Region` | `:Region` | Região onde o imóvel está localizado |
| `RegionRate` | `:RegionRate` | Tarifa de água da região |
| `Device` | `:Device` | Dispositivo instalado no imóvel |
| `WaterBill` | `:WaterBill` | Fatura de água do usuário |
| `Habit` | `:Habit` | Tipo de hábito do catálogo |
| `UserHabit` | `:UserHabit` | Relação usuário-hábito com frequência |
| `Day` | `:Day` | Dia da semana |

### Relacionamentos

| Relacionamento | Significado |
|---|---|
| `OWNS` | Usuário possui um imóvel |
| `LOCATED_AT` | Imóvel está em um endereço |
| `IN_REGION` | Endereço pertence a uma região |
| `HAS_RATE` | Região possui uma tarifa |
| `HAS_DEVICE` | Imóvel possui um dispositivo |
| `HAS_BILL` | Usuário possui uma fatura |
| `HAS_HABIT` | Usuário possui um hábito registrado |
| `IS_HABIT` | `UserHabit` representa determinado hábito |
| `ON_DAY` | Hábito do usuário ocorre em determinado dia |


## 2. Como obter as credenciais do Aura

1. Acesse [console.neo4j.io](https://console.neo4j.io) e faça login.
2. Clique na sua instância na lista de *Instances*.
3. Copie o campo **Connection URI** (começa com `neo4j+s://`) → `NEO4J_URI`.
4. O `NEO4J_USER` e `NEO4J_DATABASE` são o ID da instância (ex: `a6b95128`).
5. A `NEO4J_PASSWORD` só aparece **uma vez**, na criação da instância. Se perdeu,
   use o botão **Reset DB Password** na página da instância.

Copie o `.env.example` para `.env` e preencha:

```
NEO4J_URI=neo4j+s://<instance-id>.databases.neo4j.io
NEO4J_USER=<instance-id>
NEO4J_PASSWORD=<senha>
NEO4J_DATABASE=<instance-id>
```


## 3. Popular o banco

```bash
pip install neo4j python-dotenv

python load_graph.py setup.cypher
python load_graph.py seed.cypher
```

O `setup.cypher` usa `MERGE` em todos os nós de referência — pode ser
re-executado sem duplicar dados.


## 4. Pergunta de negócio com Traversal

> **Quais usuários possuem hábitos praticados aos sábados e moram em regiões onde a tarifa de água é superior a R$ 8,00 por m³?**

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

O traversal percorre:

```text
                    ┌── UserHabit ── Day (SÁBADO)
                   /         \
User ─────────────             Habit
                   \
                    └── Property ── Address ── Region ── RegionRate (> 8.00)
```


## 5. Estrutura do repositório

```
delta-neo4j/
  ├── setup.cypher         # modelo base (idempotente com MERGE)
  ├── seed.cypher          # dados adicionais
  ├── load_graph.py        # executor Python
  ├── .env.example
  ├── .gitignore           # .env está ignorado
  ├── README.md
  ├── querys/
  │   ├── querys.cypher    # 8 queries de negócio
  │   └── transversal.cypher
  └── diagrams/
      ├── query1.png
      ├── query2.png
      ├── query3.png
      └── query4.png
```
