-- ============================================================
-- SQL Query Lab — Sistema de Biblioteca
-- queries.sql — Consultas de análise (JOINs, subqueries, CTE)
-- ============================================================

-- 1. INNER JOIN triplo: livro + autor + categoria
SELECT
    livros.titulo,
    autores.nome AS autor,
    categorias.nome AS categoria
FROM livros
INNER JOIN autores ON livros.autor_id = autores.id
INNER JOIN categorias ON livros.categoria_id = categorias.id;


-- 2. LEFT JOIN + COUNT: quantidade de livros por categoria,
--    incluindo categorias sem nenhum livro (COUNT(livros.id),
--    não COUNT(*), para não contar a linha NULL do LEFT JOIN)
SELECT
    categorias.nome AS categoria,
    COUNT(livros.id) AS quantidade_livros
FROM categorias
LEFT JOIN livros ON categorias.id = livros.categoria_id
GROUP BY categorias.id, categorias.nome;


-- 3. Membros que nunca fizeram nenhum empréstimo
--    (padrão LEFT JOIN + WHERE ... IS NULL para achar "ausência")
SELECT
    membros.nome,
    membros.email
FROM membros
LEFT JOIN emprestimos ON membros.id = emprestimos.membro_id
WHERE emprestimos.id IS NULL;


-- 4. Empréstimos em aberto há mais de 30 dias (atrasados)
SELECT
    membros.nome AS membro,
    livros.titulo AS livro,
    emprestimos.data_emprestimo
FROM emprestimos
INNER JOIN membros ON emprestimos.membro_id = membros.id
INNER JOIN livros ON emprestimos.livro_id = livros.id
WHERE emprestimos.data_devolucao IS NULL
  AND emprestimos.data_emprestimo < date('now', '-30 days');


-- 5. Quantidade de livros por autor, do maior para o menor
SELECT
    autores.nome AS autor,
    COUNT(livros.id) AS quantidade_livros
FROM autores
LEFT JOIN livros ON autores.id = livros.autor_id
GROUP BY autores.id, autores.nome
ORDER BY quantidade_livros DESC;


-- 6. CTE: autores com mais de 1 livro cadastrado
WITH contagem_autores AS (
    SELECT
        autores.nome,
        COUNT(livros.id) AS quantidade_livros
    FROM autores
    LEFT JOIN livros ON autores.id = livros.autor_id
    GROUP BY autores.id, autores.nome
)
SELECT
    nome,
    quantidade_livros
FROM contagem_autores
WHERE quantidade_livros > 1;


-- 7. EXPLAIN QUERY PLAN: verificar uso do índice criado em
--    emprestimos.membro_id na query de membros sem empréstimo
EXPLAIN QUERY PLAN
SELECT membros.nome, membros.email
FROM membros
LEFT JOIN emprestimos ON membros.id = emprestimos.membro_id
WHERE emprestimos.id IS NULL;
