// A pergunta de negócio busca identificar quais usuários possuem hábitos realizados aos sábados 
// e estão localizados em regiões cuja tarifa de água ultrapassa R$ 8,00 por m³. 
// Para responder à pergunta, é necessário realizar um traversal no grafo,
// percorrendo os relacionamentos entre usuários, hábitos, dias, imóveis, endereços, regiões e tarifas. 
// Dessa forma, a consulta cruza diferentes partes do grafo em vez de apenas localizar um nó específico.

MATCH (u:User)-[:HAS_HABIT]->(uh:UserHabit)-[:ON_DAY]->(d:Day {name: "SÁBADO"})
MATCH (uh)-[:IS_HABIT]->(h:Habit)
MATCH (u)-[:OWNS]->(:Property)-[:LOCATED_AT]->(:Address)-[:IN_REGION]->(r:Region)-[:HAS_RATE]->(rr:RegionRate)
WHERE rr.m3Value > 8.00
RETURN
    u.name AS usuario,
    h.name AS habito,
    r.name AS regiao,
    rr.m3Value AS tarifa;