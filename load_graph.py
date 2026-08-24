import os
import sys
from neo4j import GraphDatabase
from dotenv import load_dotenv

load_dotenv()

def executar_script(uri, usuario, senha, arquivo):
    with open(arquivo, "r", encoding="utf-8") as f:
        script = f.read()

    comandos = script.split(";")

    driver = GraphDatabase.driver(uri, auth=(usuario, senha))

    with driver.session() as session:
        for comando in comandos:
            comando = comando.strip()

            if comando:
                session.run(comando)

    driver.close()

    print("Script executado com sucesso!")


if len(sys.argv) != 2:
    print("Digite python load_graph.py arquivo.cypher")
    sys.exit()

uri = os.getenv("NEO4J_URI")
usuario = os.getenv("NEO4J_USER", "neo4j")
senha = os.getenv("NEO4J_PASSWORD")

if not uri or not senha:
    print("Configure as variáveis de ambiente.")
    sys.exit()

executar_script(uri, usuario, senha, sys.argv[1])