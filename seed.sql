-- ============================================================
-- SQL Query Lab — Sistema de Biblioteca
-- seed.sql — Dados de exemplo
--
-- Cenários cobertos de propósito:
--  - 2 autores com mais de 1 livro cada (testar JOIN 1:N)
--  - 1 categoria sem nenhum livro vinculado ("História")
--  - 1 membro sem nenhum empréstimo (Carlos Souza)
--  - 2 empréstimos em aberto (data_devolucao NULL)
--  - 1 empréstimo claramente atrasado (> 30 dias sem devolução)
-- ============================================================

INSERT INTO autores (nome) VALUES
('Patrick'),
('Robert Martin');

INSERT INTO categorias (nome) VALUES
('Tecnologia'),
('Ficção'),
('História');

INSERT INTO livros (titulo, autor_id, categoria_id) VALUES
('As aventuras da tecnologia', 1, 1),
('Descobrimento dos scripts', 1, 1),
('Dora aventureira do crack', 2, 2),
('Dora aventureira do crack estudando TI', 2, 1);

INSERT INTO membros (nome, email) VALUES
('Gustavo Costa', 'gustavo@email.com'),
('Ana Silva', 'ana.silva@email.com'),
('Carlos Souza', 'carlos.souza@email.com');

INSERT INTO emprestimos (membro_id, livro_id, data_emprestimo, data_devolucao) VALUES
(1, 1, '2026-02-15', NULL),
(2, 3, '2026-05-20', '2026-06-01'),
(1, 2, '2026-07-15', NULL);
