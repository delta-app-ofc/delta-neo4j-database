import os
import subprocess
import sys
from pathlib import Path
from types import SimpleNamespace

import pytest

import load_graph


class RecordingSession:
    def __init__(self, driver):
        self.driver = driver

    def __enter__(self):
        return self

    def __exit__(self, exception_type, exception, traceback):
        return False

    def run(self, statement):
        self.driver.statements.append(statement)
        if statement == self.driver.fail_on:
            raise RuntimeError("query failure")


class RecordingDriver:
    def __init__(self, fail_on=None):
        self.fail_on = fail_on
        self.statements = []
        self.database = None
        self.closed = False

    def session(self, database=None):
        self.database = database
        return RecordingSession(self)

    def close(self):
        self.closed = True


def install_driver_factory(monkeypatch, driver, calls):
    def make_driver(uri, auth):
        calls.append((uri, auth))
        return driver

    monkeypatch.setattr(load_graph, "GraphDatabase", SimpleNamespace(driver=make_driver))


def test_executar_script_runs_nonempty_commands_in_configured_database(tmp_path, monkeypatch, capsys):
    monkeypatch.setattr(load_graph, "SCRIPT_ROOT", tmp_path.resolve())
    cypher_file = tmp_path / "setup.cypher"
    cypher_file.write_text(
        "CREATE (n:Example {name: 'first'});\nMATCH (n:Example) RETURN n;\n ;",
        encoding="utf-8",
    )
    driver = RecordingDriver()
    driver_calls = []
    monkeypatch.setenv("NEO4J_DATABASE", "test-database")
    install_driver_factory(monkeypatch, driver, driver_calls)

    load_graph.executar_script("bolt://test", "test-user", "test-password", "setup.cypher")

    assert driver_calls == [("bolt://test", ("test-user", "test-password"))]
    assert driver.database == "test-database"
    assert driver.statements == [
        "CREATE (n:Example {name: 'first'})",
        "MATCH (n:Example) RETURN n",
    ]
    assert driver.closed is True
    assert "Script executado com sucesso!" in capsys.readouterr().out


def test_executar_script_closes_driver_when_a_query_fails(tmp_path, monkeypatch):
    monkeypatch.setattr(load_graph, "SCRIPT_ROOT", tmp_path.resolve())
    cypher_file = tmp_path / "setup.cypher"
    cypher_file.write_text("RETURN 1;", encoding="utf-8")
    driver = RecordingDriver(fail_on="RETURN 1")
    install_driver_factory(monkeypatch, driver, [])
    monkeypatch.delenv("NEO4J_DATABASE", raising=False)

    with pytest.raises(RuntimeError, match="query failure"):
        load_graph.executar_script("bolt://test", "test-user", "test-password", "setup.cypher")

    assert driver.closed is True


def test_main_rejects_missing_or_extra_arguments(capsys):
    assert load_graph.main([]) == 2
    assert "python load_graph.py arquivo.cypher" in capsys.readouterr().out

    assert load_graph.main(["one.cypher", "two.cypher"]) == 2
    assert "python load_graph.py arquivo.cypher" in capsys.readouterr().out


def test_main_rejects_missing_connection_configuration(monkeypatch, capsys):
    monkeypatch.setattr(load_graph, "load_dotenv", lambda: None)
    monkeypatch.delenv("NEO4J_URI", raising=False)
    monkeypatch.delenv("NEO4J_PASSWORD", raising=False)

    assert load_graph.main(["setup.cypher"]) == 2
    assert "Configure as variáveis de ambiente." in capsys.readouterr().out


def test_main_passes_configured_connection_to_loader(monkeypatch):
    monkeypatch.setattr(load_graph, "load_dotenv", lambda: None)
    monkeypatch.setenv("NEO4J_URI", "bolt://test")
    monkeypatch.setenv("NEO4J_USER", "graph-user")
    monkeypatch.setenv("NEO4J_PASSWORD", "graph-password")
    calls = []
    monkeypatch.setattr(load_graph, "executar_script", lambda *arguments: calls.append(arguments))

    assert load_graph.main(["seed.cypher"]) == 0
    assert calls == [("bolt://test", "graph-user", "graph-password", "seed.cypher")]


def test_main_uses_default_user_when_unset(monkeypatch):
    monkeypatch.setattr(load_graph, "load_dotenv", lambda: None)
    monkeypatch.setenv("NEO4J_URI", "bolt://test")
    monkeypatch.setenv("NEO4J_PASSWORD", "graph-password")
    monkeypatch.delenv("NEO4J_USER", raising=False)
    calls = []
    monkeypatch.setattr(load_graph, "executar_script", lambda *arguments: calls.append(arguments))

    assert load_graph.main(["setup.cypher"]) == 0
    assert calls == [("bolt://test", "neo4j", "graph-password", "setup.cypher")]


def test_python_cli_usage_returns_nonzero_without_loading_dotenv(tmp_path):
    script = Path(load_graph.__file__).resolve()
    environment = {
        "PATH": os.environ.get("PATH", ""),
        "PYTHON_DOTENV_DISABLED": "true",
    }
    if os.name == "nt" and "SystemRoot" in os.environ:
        environment["SystemRoot"] = os.environ["SystemRoot"]

    result = subprocess.run(
        [sys.executable, str(script)],
        cwd=tmp_path,
        env=environment,
        capture_output=True,
        text=True,
        check=False,
    )

    assert result.returncode == 2
    assert "python load_graph.py arquivo.cypher" in result.stdout


@pytest.mark.parametrize("name", ["../secret.cypher", "..\\secret.cypher", "/tmp/secret.cypher", "C:/secret.cypher", "setup.cypher/../seed.cypher", "other.cypher", "setup.txt"])
def test_rejects_unapproved_paths_before_reading_or_connecting(name, monkeypatch):
    calls = []
    monkeypatch.setattr(load_graph, "GraphDatabase", SimpleNamespace(driver=lambda *args, **kwargs: calls.append(args)))
    with pytest.raises(ValueError, match="nao permitido"):
        load_graph.executar_script("bolt://test", "test-user", "test-password", name)
    assert calls == []


def test_allowed_script_is_resolved_from_repository_not_cwd(tmp_path, monkeypatch):
    root = tmp_path / "repo"
    root.mkdir()
    (root / "seed.cypher").write_text("RETURN 1;", encoding="utf-8")
    monkeypatch.setattr(load_graph, "SCRIPT_ROOT", root.resolve())
    monkeypatch.chdir(tmp_path)
    assert load_graph._script_path("seed.cypher") == root / "seed.cypher"


def test_rejects_resolved_path_outside_repository(tmp_path, monkeypatch):
    root = tmp_path / "repo"
    root.mkdir()
    monkeypatch.setattr(load_graph, "SCRIPT_ROOT", root)
    with monkeypatch.context() as patcher:
        patcher.setattr(Path, "resolve", lambda self, strict=False: tmp_path / "secret.cypher")
        with pytest.raises(ValueError, match="dentro do repositorio"):
            load_graph._script_path("setup.cypher")


def test_rejects_symlink_target_with_non_cypher_extension(tmp_path, monkeypatch):
    monkeypatch.setattr(load_graph, "SCRIPT_ROOT", tmp_path)
    with monkeypatch.context() as patcher:
        patcher.setattr(Path, "resolve", lambda self, strict=False: tmp_path / ".env")
        with pytest.raises(ValueError, match="extensao"):
            load_graph._script_path("seed.cypher")


def test_rejects_directory_named_as_allowed_script(tmp_path, monkeypatch):
    (tmp_path / "setup.cypher").mkdir()
    monkeypatch.setattr(load_graph, "SCRIPT_ROOT", tmp_path.resolve())
    with pytest.raises(ValueError, match="arquivo regular"):
        load_graph._script_path("setup.cypher")
