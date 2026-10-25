// QUERY 1 - visualizar todos os grafos
MATCH (n)-[r]->(m)
RETURN n, r, m;

// QUERY 2 - ver posse de imóvel, região e dispositivo instalado
MATCH (u:User)-[o:OWNS]->(p:Property)
OPTIONAL MATCH (p)-[l:LOCATED_AT]->(a:Address)-[ir:IN_REGION]->(r:Region)
OPTIONAL MATCH (p)-[d:HAS_DEVICE]->(device:Device)
RETURN u, o, p, l, a, ir, r, d, device;

// QUERY 3 - Faturas de água e tarifa vigente por região
MATCH (u:User)-[hb:HAS_BILL]->(b:WaterBill)
MATCH (u)-[:OWNS]->(:Property)-[:LOCATED_AT]->(:Address)-[ir:IN_REGION]->(r:Region)-[hr:HAS_RATE]->(rr:RegionRate)
RETURN u, hb, b, ir, r, hr, rr;

// QUERY 4 - Hábitos por usuário e dia da semana
MATCH (u:User)-[hh:HAS_HABIT]->(uh:UserHabit)-[ih:IS_HABIT]->(h:Habit)
OPTIONAL MATCH (uh)-[od:ON_DAY]->(d:Day)
RETURN u, hh, uh, ih, h, od, d;

// QUERY 5 - Todos os usuários pelo label :Pessoa (demonstra multi-label)
MATCH (p:Pessoa)
RETURN p.name AS nome, p.email AS email, p.registrationDate AS cadastro;

// QUERY 6 - Imóveis por tipo usando multi-label (:Casa / :Predio)
MATCH (p:Casa)
RETURN p.name AS imovel, "Casa" AS tipo
UNION
MATCH (p:Predio)
RETURN p.name AS imovel, "Prédio" AS tipo;

// QUERY 7 - Consumo consolidado por região usando UNWIND
MATCH (r:Region)-[:HAS_RATE]->(rr:RegionRate)
MATCH (a:Address)-[:IN_REGION]->(r)
MATCH (prop:Property)-[:LOCATED_AT]->(a)
MATCH (u:User)-[:OWNS]->(prop)
MATCH (u)-[:HAS_BILL]->(b:WaterBill)
WITH r.name AS regiao, rr.m3Value AS tarifaM3, COLLECT(b.m3Value) AS consumos
UNWIND consumos AS consumo
RETURN regiao, tarifaM3, SUM(consumo) AS totalConsumoM3, COUNT(consumo) AS qtdFaturas
ORDER BY totalConsumo DESC;

// QUERY 8 - Hábitos mais frequentes por região (travessia transversal)
MATCH (u:User)-[:OWNS]->(p:Property)-[:LOCATED_AT]->(a:Address)-[:IN_REGION]->(r:Region)
MATCH (u)-[:HAS_HABIT]->(uh:UserHabit)-[:IS_HABIT]->(h:Habit)
RETURN r.name AS regiao, h.name AS habito, SUM(uh.frequency) AS frequenciaTotal
ORDER BY regiao, frequenciaTotal DESC;
