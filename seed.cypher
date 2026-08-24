// Novos usuários
CREATE
(:User {
    id: 4,
    name: "Carlos",
    email: "carlos@email.com",
    phone: "11966666666",
    birthDate: date("1998-04-12"),
    registrationDate: date("2026-02-10"),
    isActive: true,
    isAdmin: false,
    isManager: false
}),
(:User {
    id: 5,
    name: "Beatriz",
    email: "beatriz@email.com",
    phone: "11955555555",
    birthDate: date("1997-09-25"),
    registrationDate: date("2026-02-15"),
    isActive: true,
    isAdmin: false,
    isManager: false
}),
(:User {
    id: 6,
    name: "Lucas",
    email: "lucas@email.com",
    phone: "11944444444",
    birthDate: date("2000-11-03"),
    registrationDate: date("2026-03-01"),
    isActive: true,
    isAdmin: false,
    isManager: false
}),
(:User {
    id: 7,
    name: "Julia",
    email: "julia@email.com",
    phone: "11933333333",
    birthDate: date("1996-06-18"),
    registrationDate: date("2026-03-05"),
    isActive: true,
    isAdmin: false,
    isManager: false
});

// Novos endereços
CREATE
(:Address {
    id: 4,
    cep: "04004000",
    city: "São Paulo",
    state: "São Paulo"
}),
(:Address {
    id: 5,
    cep: "05005000",
    city: "São Paulo",
    state: "São Paulo"
}),
(:Address {
    id: 6,
    cep: "06006000",
    city: "São Paulo",
    state: "São Paulo"
}),
(:Address {
    id: 7,
    cep: "07007000",
    city: "São Paulo",
    state: "São Paulo"
});

// Novos imóveis
CREATE
(:Property {
    id: 4,
    name: "Casa do Carlos",
    type: "CASA",
    classification: "RESIDENCIAL",
    registrationDate: date("2026-02-10")
}),
(:Property {
    id: 5,
    name: "Casa da Beatriz",
    type: "CASA",
    classification: "RESIDENCIAL",
    registrationDate: date("2026-02-15")
}),
(:Property {
    id: 6,
    name: "Apartamento do Lucas",
    type: "PRÉDIO",
    classification: "RESIDENCIAL",
    registrationDate: date("2026-03-01")
}),
(:Property {
    id: 7,
    name: "Casa da Julia",
    type: "CASA",
    classification: "RESIDENCIAL",
    registrationDate: date("2026-03-05")
});

// Usuários possuem imóveis
MATCH (u:User {id: 4}), (p:Property {id: 4})
CREATE (u)-[:OWNS {
    associationDate: date("2026-02-10")
}]->(p);

MATCH (u:User {id: 5}), (p:Property {id: 5})
CREATE (u)-[:OWNS {
    associationDate: date("2026-02-15")
}]->(p);

MATCH (u:User {id: 6}), (p:Property {id: 6})
CREATE (u)-[:OWNS {
    associationDate: date("2026-03-01")
}]->(p);

MATCH (u:User {id: 7}), (p:Property {id: 7})
CREATE (u)-[:OWNS {
    associationDate: date("2026-03-05")
}]->(p);

// Imóveis possuem endereços
MATCH (p:Property {id: 4}), (a:Address {id: 4})
CREATE (p)-[:LOCATED_AT]->(a);

MATCH (p:Property {id: 5}), (a:Address {id: 5})
CREATE (p)-[:LOCATED_AT]->(a);

MATCH (p:Property {id: 6}), (a:Address {id: 6})
CREATE (p)-[:LOCATED_AT]->(a);

MATCH (p:Property {id: 7}), (a:Address {id: 7})
CREATE (p)-[:LOCATED_AT]->(a);

// Endereços pertencem a regiões
MATCH (a:Address {id: 4}), (r:Region {id: 2})
CREATE (a)-[:IN_REGION]->(r);

MATCH (a:Address {id: 5}), (r:Region {id: 4})
CREATE (a)-[:IN_REGION]->(r);

MATCH (a:Address {id: 6}), (r:Region {id: 3})
CREATE (a)-[:IN_REGION]->(r);

MATCH (a:Address {id: 7}), (r:Region {id: 5})
CREATE (a)-[:IN_REGION]->(r);

// Carlos pratica LAVAR CARRO aos sábados
MATCH (u:User {id: 4}), (h:Habit {id: 5})
CREATE (uh:UserHabit {id: 7, frequency: 2})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);

MATCH (uh:UserHabit {id: 7}), (d:Day {id: 6})
CREATE (uh)-[:ON_DAY]->(d);

// Beatriz pratica BANHO LONGO aos sábados
MATCH (u:User {id: 5}), (h:Habit {id: 1})
CREATE (uh:UserHabit {id: 8, frequency: 4})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);

MATCH (uh:UserHabit {id: 8}), (d:Day {id: 6})
CREATE (uh)-[:ON_DAY]->(d);

// Lucas pratica LAVAR QUINTAL aos sábados
MATCH (u:User {id: 6}), (h:Habit {id: 2})
CREATE (uh:UserHabit {id: 9, frequency: 3})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);

MATCH (uh:UserHabit {id: 9}), (d:Day {id: 6})
CREATE (uh)-[:ON_DAY]->(d);

// Julia pratica LAVAR LOUÇA aos sábados
MATCH (u:User {id: 7}), (h:Habit {id: 6})
CREATE (uh:UserHabit {id: 10, frequency: 5})
CREATE (u)-[:HAS_HABIT]->(uh)
CREATE (uh)-[:IS_HABIT]->(h);

MATCH (uh:UserHabit {id: 10}), (d:Day {id: 6})
CREATE (uh)-[:ON_DAY]->(d);

// Novas tarifas
CREATE
(:RegionRate {
    id: 4,
    m3Value: 8.80,
    initialValidity: date("2026-01-01"),
    finalValidity: null
}),
(:RegionRate {
    id: 5,
    m3Value: 9.10,
    initialValidity: date("2026-01-01"),
    finalValidity: null
});

// Regiões possuem tarifas
MATCH (r:Region {id: 2}), (rr:RegionRate {id: 4})
CREATE (r)-[:HAS_RATE]->(rr);

MATCH (r:Region {id: 4}), (rr:RegionRate {id: 5})
CREATE (r)-[:HAS_RATE]->(rr);