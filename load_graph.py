"""Carrega um arquivo Cypher em uma instância Neo4j configurada por ambiente."""

import os
import sys

from dotenv import load_dotenv
from neo4j import GraphDatabase


def executar_script(uri, usuario, senha, arquivo):
    """Executa os comandos separados por ponto e vírgula e sempre fecha o driver."""
    with open(arquivo, "r", encoding="utf-8") as arquivo_cypher:
        script = arquivo_cypher.read()

    comandos = script.split(";")
    driver = GraphDatabase.driver(uri, auth=(usuario, senha))
    database = os.getenv("NEO4J_DATABASE")

    try:
        with driver.session(database=database) as session:
            for comando in comandos:
                comando = comando.strip()
                if comando:
                    session.run(comando)
    finally:
        driver.close()

    print("Script executado com sucesso!")


def main(argv=None):
    argumentos = sys.argv[1:] if argv is None else argv
    if len(argumentos) != 1:
        print("Digite python load_graph.py arquivo.cypher")
        return 2

    load_dotenv()

    uri = os.getenv("NEO4J_URI")
    usuario = os.getenv("NEO4J_USER", "neo4j")
    senha = os.getenv("NEO4J_PASSWORD")

    if not uri or not senha:
        print("Configure as variáveis de ambiente.")
        return 2

    executar_script(uri, usuario, senha, argumentos[0])
    return 0


if __name__ == "__main__":
    sys.exit(main())
