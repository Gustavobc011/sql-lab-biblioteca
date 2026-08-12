-- ============================================================
-- SQL Query Lab — Sistema de Biblioteca
-- schema.sql — Definição das tabelas (modelo normalizado até 3NF)
-- ============================================================

PRAGMA foreign_keys = ON;

CREATE TABLE autores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL
);

CREATE TABLE categorias (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE
);

CREATE TABLE livros (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT NOT NULL,
    autor_id INTEGER NOT NULL,
    categoria_id INTEGER NOT NULL,
    FOREIGN KEY (autor_id) REFERENCES autores(id) ON DELETE RESTRICT,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE RESTRICT
);

CREATE TABLE membros (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL UNIQUE,
    nome TEXT NOT NULL
);

CREATE TABLE emprestimos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    membro_id INTEGER NOT NULL,
    livro_id INTEGER NOT NULL,
    data_emprestimo TEXT NOT NULL,
    data_devolucao TEXT,
    FOREIGN KEY (membro_id) REFERENCES membros(id) ON DELETE RESTRICT,
    FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE RESTRICT
);

-- ============================================================
-- Índices
-- Justificativa: membro_id e livro_id são FKs usadas com
-- frequência em JOIN e em filtros (WHERE). Colunas com UNIQUE
-- (categorias.nome, membros.email) já ganham índice automático
-- do SQLite, então não precisam de índice manual adicional.
-- ============================================================

CREATE INDEX idx_emprestimos_membro ON emprestimos (membro_id);
CREATE INDEX idx_emprestimos_livro ON emprestimos (livro_id);
