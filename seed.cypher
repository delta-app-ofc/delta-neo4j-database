// Novos usuários — multi-label :User:Pessoa
MERGE (u4:User:Pessoa {id: 4})
SET u4.name = "Carlos",
    u4.email = "carlos@email.com",
    u4.phone = "11966666666",
    u4.birthDate = date("1998-04-12"),
    u4.registrationDate = date("2026-02-10"),
    u4.isActive = true,
    u4.isAdmin = false,
    u4.isManager = false;

MERGE (u5:User:Pessoa {id: 5})
SET u5.name = "Beatriz",
    u5.email = "beatriz@email.com",
    u5.phone = "11955555555",
    u5.birthDate = date("1997-09-25"),
    u5.registrationDate = date("2026-02-15"),
    u5.isActive = true,
    u5.isAdmin = false,
    u5.isManager = false;

MERGE (u6:User:Pessoa {id: 6})
SET u6.name = "Lucas",
    u6.email = "lucas@email.com",
    u6.phone = "11944444444",
    u6.birthDate = date("2000-11-03"),
    u6.registrationDate = date("2026-03-01"),
    u6.isActive = true,
    u6.isAdmin = false,
    u6.isManager = false;

MERGE (u7:User:Pessoa {id: 7})
SET u7.name = "Julia",
    u7.email = "julia@email.com",
    u7.phone = "11933333333",
    u7.birthDate = date("1996-06-18"),
    u7.registrationDate = date("2026-03-05"),
    u7.isActive = true,
    u7.isAdmin = false,
    u7.isManager = false;


// Novos endereços
MERGE (:Address {id: 4, cep: "04004000", city: "São Paulo", state: "São Paulo"});
MERGE (:Address {id: 5, cep: "05005000", city: "São Paulo", state: "São Paulo"});
MERGE (:Address {id: 6, cep: "06006000", city: "São Paulo", state: "São Paulo"});
MERGE (:Address {id: 7, cep: "07007000", city: "São Paulo", state: "São Paulo"});


// Novos imóveis — multi-label :Property + tipo + classificação
MERGE (p4:Property:Casa:Residencial {id: 4})
SET p4.name = "Casa do Carlos",
    p4.registrationDate = date("2026-02-10");

MERGE (p5:Property:Casa:Residencial {id: 5})
SET p5.name = "Casa da Beatriz",
    p5.registrationDate = date("2026-02-15");

MERGE (p6:Property:Predio:Residencial {id: 6})
SET p6.name = "Apartamento do Lucas",
    p6.registrationDate = date("2026-03-01");

MERGE (p7:Property:Casa:Residencial {id: 7})
SET p7.name = "Casa da Julia",
    p7.registrationDate = date("2026-03-05");


// Usuários possuem imóveis
MATCH (u:User {id: 4}), (p:Property {id: 4})
MERGE (u)-[:OWNS {associationDate: date("2026-02-10")}]->(p);

MATCH (u:User {id: 5}), (p:Property {id: 5})
MERGE (u)-[:OWNS {associationDate: date("2026-02-15")}]->(p);

MATCH (u:User {id: 6}), (p:Property {id: 6})
MERGE (u)-[:OWNS {associationDate: date("2026-03-01")}]->(p);

MATCH (u:User {id: 7}), (p:Property {id: 7})
MERGE (u)-[:OWNS {associationDate: date("2026-03-05")}]->(p);


// Imóveis possuem endereços
MATCH (p:Property {id: 4}), (a:Address {id: 4})
MERGE (p)-[:LOCATED_AT]->(a);

MATCH (p:Property {id: 5}), (a:Address {id: 5})
MERGE (p)-[:LOCATED_AT]->(a);

MATCH (p:Property {id: 6}), (a:Address {id: 6})
MERGE (p)-[:LOCATED_AT]->(a);

MATCH (p:Property {id: 7}), (a:Address {id: 7})
MERGE (p)-[:LOCATED_AT]->(a);


// Endereços pertencem a regiões
MATCH (a:Address {id: 4}), (r:Region {id: 2})
MERGE (a)-[:IN_REGION]->(r);

MATCH (a:Address {id: 5}), (r:Region {id: 4})
MERGE (a)-[:IN_REGION]->(r);

MATCH (a:Address {id: 6}), (r:Region {id: 3})
MERGE (a)-[:IN_REGION]->(r);

MATCH (a:Address {id: 7}), (r:Region {id: 5})
MERGE (a)-[:IN_REGION]->(r);


// Carlos pratica LAVAR CARRO aos sábados
MATCH (u:User {id: 4}), (h:Habit {id: 5})
CREATE (uh:UserHabit {id: 7, frequency: 2})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);

MATCH (uh:UserHabit {id: 7}), (d:Day {id: 6})
MERGE (uh)-[:ON_DAY]->(d);


// Beatriz pratica BANHO LONGO aos sábados
MATCH (u:User {id: 5}), (h:Habit {id: 1})
CREATE (uh:UserHabit {id: 8, frequency: 4})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);

MATCH (uh:UserHabit {id: 8}), (d:Day {id: 6})
MERGE (uh)-[:ON_DAY]->(d);


// Lucas pratica LAVAR QUINTAL aos sábados
MATCH (u:User {id: 6}), (h:Habit {id: 2})
CREATE (uh:UserHabit {id: 9, frequency: 3})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);

MATCH (uh:UserHabit {id: 9}), (d:Day {id: 6})
MERGE (uh)-[:ON_DAY]->(d);


// Julia pratica LAVAR LOUÇA aos sábados
MATCH (u:User {id: 7}), (h:Habit {id: 6})
CREATE (uh:UserHabit {id: 10, frequency: 5})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);

MATCH (uh:UserHabit {id: 10}), (d:Day {id: 6})
MERGE (uh)-[:ON_DAY]->(d);


// Novas tarifas
MERGE (rr4:RegionRate {id: 4})
SET rr4.m3Value = 8.80,
    rr4.initialValidity = date("2026-01-01"),
    rr4.finalValidity = null;

MERGE (rr5:RegionRate {id: 5})
SET rr5.m3Value = 9.10,
    rr5.initialValidity = date("2026-01-01"),
    rr5.finalValidity = null;


// Regiões possuem tarifas
MATCH (r:Region {id: 2}), (rr:RegionRate {id: 4})
MERGE (r)-[:HAS_RATE]->(rr);

MATCH (r:Region {id: 4}), (rr:RegionRate {id: 5})
MERGE (r)-[:HAS_RATE]->(rr);
