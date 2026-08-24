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
CREATE
(:Region {id: 1, name: "LESTE"}),
(:Region {id: 2, name: "OESTE"}),
(:Region {id: 3, name: "SUL"}),
(:Region {id: 4, name: "NORTE"}),
(:Region {id: 5, name: "CENTRO"});


// Dias da semana
CREATE
(:Day {id: 1, name: "SEGUNDA"}),
(:Day {id: 2, name: "TERÇA"}),
(:Day {id: 3, name: "QUARTA"}),
(:Day {id: 4, name: "QUINTA"}),
(:Day {id: 5, name: "SEXTA"}),
(:Day {id: 6, name: "SÁBADO"}),
(:Day {id: 7, name: "DOMINGO"});


// Hábitos de consumo de água
CREATE
(:Habit {id: 1, name: "BANHO LONGO", description: "Banho com duração prolongada"}),
(:Habit {id: 2, name: "LAVAR QUINTAL", description: "Uso de água para limpeza do quintal"}),
(:Habit {id: 3, name: "LAVAR ROUPA", description: "Uso de água para lavagem de roupas"}),
(:Habit {id: 4, name: "REGAR PLANTAS", description: "Uso de água para irrigação de plantas"}),
(:Habit {id: 5, name: "LAVAR CARRO", description: "Uso de água para lavagem de veículos"}),
(:Habit {id: 6, name: "LAVAR LOUÇA", description: "Uso de água para lavagem de louças"});


// Endereços
CREATE
(:Address {id: 1, cep: "01001000", city: "São Paulo", state: "São Paulo"}),
(:Address {id: 2, cep: "02002000", city: "São Paulo", state: "São Paulo"}),
(:Address {id: 3, cep: "03003000", city: "São Paulo", state: "São Paulo"});


// Usuários
CREATE
(:User {
    id: 1,
    name: "Mariana",
    email: "mariana@email.com",
    phone: "11999999999",
    birthDate: date("2000-05-10"),
    registrationDate: date("2026-01-10"),
    isActive: true,
    isAdmin: false,
    isManager: false
}),
(:User {
    id: 2,
    name: "João",
    email: "joao@email.com",
    phone: "11988888888",
    birthDate: date("1999-08-20"),
    registrationDate: date("2026-01-12"),
    isActive: true,
    isAdmin: false,
    isManager: false
}),
(:User {
    id: 3,
    name: "Ana",
    email: "ana@email.com",
    phone: "11977777777",
    birthDate: date("2001-02-15"),
    registrationDate: date("2026-02-01"),
    isActive: true,
    isAdmin: false,
    isManager: false
});


// Imóveis
CREATE
(:Property {
    id: 1,
    name: "Casa da Mariana",
    type: "CASA",
    classification: "RESIDENCIAL",
    registrationDate: date("2026-01-10")
}),
(:Property {
    id: 2,
    name: "Casa do João",
    type: "CASA",
    classification: "RESIDENCIAL",
    registrationDate: date("2026-01-12")
}),
(:Property {
    id: 3,
    name: "Apartamento da Ana",
    type: "PRÉDIO",
    classification: "RESIDENCIAL",
    registrationDate: date("2026-02-01")
});


// Dispositivos de medição
CREATE
(:Device {
    id: 1,
    deviceId: "ESP001",
    isActive: true,
    installationDate: date("2026-01-15")
}),
(:Device {
    id: 2,
    deviceId: "ESP002",
    isActive: true,
    installationDate: date("2026-01-20")
}),
(:Device {
    id: 3,
    deviceId: "ESP003",
    isActive: true,
    installationDate: date("2026-02-05")
});


// Faturas de água
CREATE
(:WaterBill {
    id: 1,
    month: date("2026-06-01"),
    totalValue: 120.50,
    m3Value: 15.20
}),
(:WaterBill {
    id: 2,
    month: date("2026-06-01"),
    totalValue: 180.00,
    m3Value: 22.50
}),
(:WaterBill {
    id: 3,
    month: date("2026-06-01"),
    totalValue: 95.75,
    m3Value: 11.30
}),
(:WaterBill {
    id: 4,
    month: date("2026-07-01"),
    totalValue: 140.00,
    m3Value: 17.80
});


// Tarifas de água por região
CREATE
(:RegionRate {
    id: 1,
    m3Value: 8.50,
    initialValidity: date("2026-01-01"),
    finalValidity: null
}),
(:RegionRate {
    id: 2,
    m3Value: 7.90,
    initialValidity: date("2026-01-01"),
    finalValidity: null
}),
(:RegionRate {
    id: 3,
    m3Value: 8.20,
    initialValidity: date("2026-01-01"),
    finalValidity: null
});


// Relaciona usuários aos seus imóveis
MATCH (u:User {id: 1}), (p:Property {id: 1})
CREATE (u)-[:OWNS {associationDate: date("2026-01-10")}]->(p);

MATCH (u:User {id: 2}), (p:Property {id: 2})
CREATE (u)-[:OWNS {associationDate: date("2026-01-12")}]->(p);

MATCH (u:User {id: 3}), (p:Property {id: 3})
CREATE (u)-[:OWNS {associationDate: date("2026-02-01")}]->(p);


// Relaciona imóveis aos endereços
MATCH (p:Property {id: 1}), (a:Address {id: 1})
CREATE (p)-[:LOCATED_AT]->(a);

MATCH (p:Property {id: 2}), (a:Address {id: 2})
CREATE (p)-[:LOCATED_AT]->(a);

MATCH (p:Property {id: 3}), (a:Address {id: 3})
CREATE (p)-[:LOCATED_AT]->(a);


// Relaciona endereços às regiões
MATCH (a:Address {id: 1}), (r:Region {id: 3})
CREATE (a)-[:IN_REGION]->(r);

MATCH (a:Address {id: 2}), (r:Region {id: 1})
CREATE (a)-[:IN_REGION]->(r);

MATCH (a:Address {id: 3}), (r:Region {id: 5})
CREATE (a)-[:IN_REGION]->(r);


// Relaciona imóveis aos dispositivos
MATCH (p:Property {id: 1}), (d:Device {id: 1})
CREATE (p)-[:HAS_DEVICE]->(d);

MATCH (p:Property {id: 2}), (d:Device {id: 2})
CREATE (p)-[:HAS_DEVICE]->(d);

MATCH (p:Property {id: 3}), (d:Device {id: 3})
CREATE (p)-[:HAS_DEVICE]->(d);


// Relaciona usuários às faturas
MATCH (u:User {id: 1}), (b:WaterBill {id: 1})
CREATE (u)-[:HAS_BILL]->(b);

MATCH (u:User {id: 1}), (b:WaterBill {id: 4})
CREATE (u)-[:HAS_BILL]->(b);

MATCH (u:User {id: 2}), (b:WaterBill {id: 2})
CREATE (u)-[:HAS_BILL]->(b);

MATCH (u:User {id: 3}), (b:WaterBill {id: 3})
CREATE (u)-[:HAS_BILL]->(b);


// Relaciona regiões às suas tarifas
MATCH (r:Region {id: 3}), (rr:RegionRate {id: 1})
CREATE (r)-[:HAS_RATE]->(rr);

MATCH (r:Region {id: 1}), (rr:RegionRate {id: 2})
CREATE (r)-[:HAS_RATE]->(rr);

MATCH (r:Region {id: 5}), (rr:RegionRate {id: 3})
CREATE (r)-[:HAS_RATE]->(rr);


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
CREATE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 1}), (d:Day {id: 3})
CREATE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 2}), (d:Day {id: 1})
CREATE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 3}), (d:Day {id: 6})
CREATE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 4}), (d:Day {id: 2})
CREATE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 4}), (d:Day {id: 5})
CREATE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 5}), (d:Day {id: 7})
CREATE (uh)-[:ON_DAY]->(d);

MATCH (uh:UserHabit {id: 6}), (d:Day {id: 6})
CREATE (uh)-[:ON_DAY]->(d);