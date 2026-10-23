// Limpa o banco antes de criar a modelagem
MATCH (n)
DETACH DELETE n;


// Cria restrições para garantir IDs únicos
CREATE CONSTRAINT user_id_unique IF NOT EXISTS
FOR (u:User)
REQUIRE u.id IS UNIQUE;

CREATE CONSTRAINT property_id_unique IF NOT EXISTS
FOR (p:Property)
REQUIRE p.id IS UNIQUE;

CREATE CONSTRAINT address_id_unique IF NOT EXISTS
FOR (a:Address)
REQUIRE a.id IS UNIQUE;

CREATE CONSTRAINT region_id_unique IF NOT EXISTS
FOR (r:Region)
REQUIRE r.id IS UNIQUE;

CREATE CONSTRAINT device_id_unique IF NOT EXISTS
FOR (d:Device)
REQUIRE d.id IS UNIQUE;

CREATE CONSTRAINT habit_id_unique IF NOT EXISTS
FOR (h:Habit)
REQUIRE h.id IS UNIQUE;

CREATE CONSTRAINT day_id_unique IF NOT EXISTS
FOR (d:Day)
REQUIRE d.id IS UNIQUE;

CREATE CONSTRAINT bill_id_unique IF NOT EXISTS
FOR (b:WaterBill)
REQUIRE b.id IS UNIQUE;

CREATE CONSTRAINT rate_id_unique IF NOT EXISTS
FOR (rr:RegionRate)
REQUIRE rr.id IS UNIQUE;

CREATE CONSTRAINT userhabit_id_unique IF NOT EXISTS
FOR (uh:UserHabit)
REQUIRE uh.id IS UNIQUE;


// Regiões
MERGE (:Region {id: 1, name: "LESTE"});
MERGE (:Region {id: 2, name: "OESTE"});
MERGE (:Region {id: 3, name: "SUL"});
MERGE (:Region {id: 4, name: "NORTE"});
MERGE (:Region {id: 5, name: "CENTRO"});


// Dias da semana
MERGE (:Day {id: 1, name: "SEGUNDA"});
MERGE (:Day {id: 2, name: "TERÇA"});
MERGE (:Day {id: 3, name: "QUARTA"});
MERGE (:Day {id: 4, name: "QUINTA"});
MERGE (:Day {id: 5, name: "SEXTA"});
MERGE (:Day {id: 6, name: "SÁBADO"});
MERGE (:Day {id: 7, name: "DOMINGO"});


// Hábitos de consumo de água
MERGE (:Habit {id: 1, name: "BANHO LONGO", description: "Banho com duração prolongada"});
MERGE (:Habit {id: 2, name: "LAVAR QUINTAL", description: "Uso de água para limpeza do quintal"});
MERGE (:Habit {id: 3, name: "LAVAR ROUPA", description: "Uso de água para lavagem de roupas"});
MERGE (:Habit {id: 4, name: "REGAR PLANTAS", description: "Uso de água para irrigação de plantas"});
MERGE (:Habit {id: 5, name: "LAVAR CARRO", description: "Uso de água para lavagem de veículos"});
MERGE (:Habit {id: 6, name: "LAVAR LOUÇA", description: "Uso de água para lavagem de louças"});


// Endereços
MERGE (:Address {id: 1, cep: "01001000", city: "São Paulo", state: "São Paulo"});
MERGE (:Address {id: 2, cep: "02002000", city: "São Paulo", state: "São Paulo"});
MERGE (:Address {id: 3, cep: "03003000", city: "São Paulo", state: "São Paulo"});


// Usuários — multi-label :User:Pessoa (todo usuário é uma Pessoa)
MERGE (u1:User:Pessoa {id: 1})
SET u1.name = "Mariana",
    u1.email = "mariana@email.com",
    u1.phone = "11999999999",
    u1.birthDate = date("2000-05-10"),
    u1.registrationDate = date("2026-01-10"),
    u1.isActive = true,
    u1.isAdmin = false,
    u1.isManager = false;

MERGE (u2:User:Pessoa {id: 2})
SET u2.name = "João",
    u2.email = "joao@email.com",
    u2.phone = "11988888888",
    u2.birthDate = date("1999-08-20"),
    u2.registrationDate = date("2026-01-12"),
    u2.isActive = true,
    u2.isAdmin = false,
    u2.isManager = false;

MERGE (u3:User:Pessoa {id: 3})
SET u3.name = "Ana",
    u3.email = "ana@email.com",
    u3.phone = "11977777777",
    u3.birthDate = date("2001-02-15"),
    u3.registrationDate = date("2026-02-01"),
    u3.isActive = true,
    u3.isAdmin = false,
    u3.isManager = false;


// Imóveis — multi-label :Property + tipo (:Casa / :Predio) + classificação (:Residencial / :Comercial)
MERGE (p1:Property:Casa:Residencial {id: 1})
SET p1.name = "Casa da Mariana",
    p1.registrationDate = date("2026-01-10");

MERGE (p2:Property:Casa:Residencial {id: 2})
SET p2.name = "Casa do João",
    p2.registrationDate = date("2026-01-12");

MERGE (p3:Property:Predio:Residencial {id: 3})
SET p3.name = "Apartamento da Ana",
    p3.registrationDate = date("2026-02-01");


// Dispositivos de medição
MERGE (d1:Device {id: 1})
SET d1.deviceId = "ESP001",
    d1.isActive = true,
    d1.installationDate = date("2026-01-15");

MERGE (d2:Device {id: 2})
SET d2.deviceId = "ESP002",
    d2.isActive = true,
    d2.installationDate = date("2026-01-20");

MERGE (d3:Device {id: 3})
SET d3.deviceId = "ESP003",
    d3.isActive = true,
    d3.installationDate = date("2026-02-05");


// Faturas de água
MERGE (b1:WaterBill {id: 1})
SET b1.month = date("2026-06-01"),
    b1.totalValue = 120.50,
    b1.m3Value = 15.20;

MERGE (b2:WaterBill {id: 2})
SET b2.month = date("2026-06-01"),
    b2.totalValue = 180.00,
    b2.m3Value = 22.50;

MERGE (b3:WaterBill {id: 3})
SET b3.month = date("2026-06-01"),
    b3.totalValue = 95.75,
    b3.m3Value = 11.30;

MERGE (b4:WaterBill {id: 4})
SET b4.month = date("2026-07-01"),
    b4.totalValue = 140.00,
    b4.m3Value = 17.80;


// Tarifas de água por região
MERGE (rr1:RegionRate {id: 1})
SET rr1.m3Value = 8.50,
    rr1.initialValidity = date("2026-01-01"),
    rr1.finalValidity = null;

MERGE (rr2:RegionRate {id: 2})
SET rr2.m3Value = 7.90,
    rr2.initialValidity = date("2026-01-01"),
    rr2.finalValidity = null;

MERGE (rr3:RegionRate {id: 3})
SET rr3.m3Value = 8.20,
    rr3.initialValidity = date("2026-01-01"),
    rr3.finalValidity = null;


// Relaciona usuários aos seus imóveis
MATCH (u:User {id: 1}), (p:Property {id: 1})
MERGE (u)-[:OWNS {associationDate: date("2026-01-10")}]->(p);

MATCH (u:User {id: 2}), (p:Property {id: 2})
MERGE (u)-[:OWNS {associationDate: date("2026-01-12")}]->(p);

MATCH (u:User {id: 3}), (p:Property {id: 3})
MERGE (u)-[:OWNS {associationDate: date("2026-02-01")}]->(p);


// Relaciona imóveis aos endereços
MATCH (p:Property {id: 1}), (a:Address {id: 1})
MERGE (p)-[:LOCATED_AT]->(a);

MATCH (p:Property {id: 2}), (a:Address {id: 2})
MERGE (p)-[:LOCATED_AT]->(a);

MATCH (p:Property {id: 3}), (a:Address {id: 3})
MERGE (p)-[:LOCATED_AT]->(a);


// Relaciona endereços às regiões
MATCH (a:Address {id: 1}), (r:Region {id: 3})
MERGE (a)-[:IN_REGION]->(r);

MATCH (a:Address {id: 2}), (r:Region {id: 1})
MERGE (a)-[:IN_REGION]->(r);

MATCH (a:Address {id: 3}), (r:Region {id: 5})
MERGE (a)-[:IN_REGION]->(r);


// Relaciona imóveis aos dispositivos
MATCH (p:Property {id: 1}), (d:Device {id: 1})
MERGE (p)-[:HAS_DEVICE]->(d);

MATCH (p:Property {id: 2}), (d:Device {id: 2})
MERGE (p)-[:HAS_DEVICE]->(d);

MATCH (p:Property {id: 3}), (d:Device {id: 3})
MERGE (p)-[:HAS_DEVICE]->(d);


// Relaciona usuários às faturas
MATCH (u:User {id: 1}), (b:WaterBill {id: 1})
MERGE (u)-[:HAS_BILL]->(b);

MATCH (u:User {id: 1}), (b:WaterBill {id: 4})
MERGE (u)-[:HAS_BILL]->(b);

MATCH (u:User {id: 2}), (b:WaterBill {id: 2})
MERGE (u)-[:HAS_BILL]->(b);

MATCH (u:User {id: 3}), (b:WaterBill {id: 3})
MERGE (u)-[:HAS_BILL]->(b);


// Relaciona regiões às suas tarifas
MATCH (r:Region {id: 3}), (rr:RegionRate {id: 1})
MERGE (r)-[:HAS_RATE]->(rr);

MATCH (r:Region {id: 1}), (rr:RegionRate {id: 2})
MERGE (r)-[:HAS_RATE]->(rr);

MATCH (r:Region {id: 5}), (rr:RegionRate {id: 3})
MERGE (r)-[:HAS_RATE]->(rr);


// Cria os hábitos praticados por cada usuário
MATCH (u:User {id: 1}), (h:Habit {id: 1})
CREATE (uh:UserHabit {id: 1, frequency: 5})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);

MATCH (u:User {id: 1}), (h:Habit {id: 6})
CREATE (uh:UserHabit {id: 2, frequency: 7})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);

MATCH (u:User {id: 2}), (h:Habit {id: 2})
CREATE (uh:UserHabit {id: 3, frequency: 2})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);

MATCH (u:User {id: 2}), (h:Habit {id: 3})
CREATE (uh:UserHabit {id: 4, frequency: 4})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);

MATCH (u:User {id: 3}), (h:Habit {id: 4})
CREATE (uh:UserHabit {id: 5, frequency: 3})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);

MATCH (u:User {id: 3}), (h:Habit {id: 5})
CREATE (uh:UserHabit {id: 6, frequency: 1})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);


// Relaciona os hábitos aos dias da semana
MATCH (uh:UserHabit {id: 1}), (d:Day {id: 1})
MERGE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 1}), (d:Day {id: 3})
MERGE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 2}), (d:Day {id: 1})
MERGE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 3}), (d:Day {id: 6})
MERGE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 4}), (d:Day {id: 2})
MERGE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 4}), (d:Day {id: 5})
MERGE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 5}), (d:Day {id: 7})
MERGE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 6}), (d:Day {id: 6})
MERGE (uh)-[:ON_DAY]->(d);
