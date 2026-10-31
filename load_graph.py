"""Carrega um arquivo Cypher em uma instância Neo4j configurada por ambiente."""

import os
import sys
from pathlib import Path

from dotenv import load_dotenv
from neo4j import GraphDatabase


SCRIPT_ROOT = Path(__file__).resolve().parent


def _script_path(nome):
    """Seleciona somente scripts versionados, sem usar a entrada como caminho."""
    permitidos = {
        "setup.cypher": SCRIPT_ROOT / "setup.cypher",
        "seed.cypher": SCRIPT_ROOT / "seed.cypher",
        "querys/querys.cypher": SCRIPT_ROOT / "querys" / "querys.cypher",
        "querys/transversal.cypher": SCRIPT_ROOT / "querys" / "transversal.cypher",
    }
    if nome not in permitidos:
        raise ValueError("Script nao permitido. Use um dos scripts Cypher versionados.")
    caminho = permitidos[nome].resolve(strict=True)
    if not caminho.is_relative_to(SCRIPT_ROOT) or caminho.suffix != ".cypher":
        raise ValueError("O script deve permanecer dentro do repositorio e ter extensao .cypher.")
    if not caminho.is_file():
        raise ValueError("O script precisa ser um arquivo regular.")
    return caminho


def executar_script(uri, usuario, senha, arquivo):
    """Executa os comandos separados por ponto e vírgula e sempre fecha o driver."""
    script = _script_path(arquivo).read_text(encoding="utf-8")

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
