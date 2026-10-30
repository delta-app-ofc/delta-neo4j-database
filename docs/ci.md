# CI técnico

Em pull requests e por execução manual, o workflow inicia um Neo4j 5 temporário, verifica a sintaxe de `load_graph.py`, carrega `setup.cypher` e `seed.cypher` com o próprio carregador e confere as quantidades de usuários, dias e relações de posse. Uma falha interrompe o job. O workflow não acessa o Aura nem valida todas as consultas ou regras de negócio.

Para reproduzir localmente, use um Neo4j 5 descartável e configure `NEO4J_URI`, `NEO4J_USER`, `NEO4J_PASSWORD` e `NEO4J_DATABASE`. Instale `neo4j` e `python-dotenv`, execute `python -m py_compile load_graph.py`, `python load_graph.py setup.cypher` e `python load_graph.py seed.cypher`. O passo final de verificação está no workflow. **O setup apaga todos os nós do banco usado**; nunca execute em produção.
