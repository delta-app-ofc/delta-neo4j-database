// QUERY 1 - visualizar todos os grafos
MATCH (n)-[r]->(m)
RETURN n, r, m

// QUERY 2 -  ver posse de imóvel, região e dispositivo instalado
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