# SQL Query Lab — Sistema de Biblioteca

Projeto de estudo focado em SQL avançado: modelagem relacional, normalização,
joins complexos, subqueries, CTEs e otimização com índices, usando SQLite.

## Objetivo

Simular o cenário comum de teste técnico de estágio: partir de um dado bruto
e desnormalizado e evoluir para um schema relacional correto, escrevendo
consultas que respondam perguntas de negócio reais sobre uma biblioteca
(livros emprestados, atrasos, membros inativos, etc).

## Modelagem

O ponto de partida era uma única tabela desnormalizada, com nome de autor,
categoria e e-mail do membro repetidos a cada linha — gerando risco de
anomalia de atualização (ex: alterar o nome de um autor exigiria atualizar
todas as linhas em que ele aparece).

O modelo final tem 5 entidades, normalizadas até a 3ª Forma Normal (3NF):

- **autores** (`id`, `nome`)
- **categorias** (`id`, `nome`)
- **livros** (`id`, `titulo`, `autor_id` FK, `categoria_id` FK)
- **membros** (`id`, `nome`, `email` UNIQUE)
- **emprestimos** (`id`, `membro_id` FK, `livro_id` FK, `data_emprestimo`, `data_devolucao` nullable)

### Decisões de design e trade-offs conscientes

- **Um autor por livro:** o modelo assume 1:N (um livro tem um único autor).
  Em um sistema com livros de múltiplos autores, o correto seria uma tabela
  associativa `livro_autor` (N:N). Optei por simplificar porque os dados do
  exercício não exigiam essa complexidade — mas o caminho para evoluir o
  schema está identificado.
- **Uma cópia por livro:** o modelo não distingue exemplares físicos. Um
  sistema real precisaria de uma tabela `exemplares`, com `emprestimos`
  referenciando o exemplar (não o livro diretamente), para saber qual cópia
  específica está emprestada.
- **`data_devolucao` aceita NULL de propósito:** NULL representa "empréstimo
  ainda em aberto", não um dado faltando por erro.
- **`ON DELETE RESTRICT`** nas FKs: impede apagar um autor/categoria/livro/membro
  que ainda tenha registros vinculados, evitando perda silenciosa de dados.

## Consultas (`queries.sql`)

| # | Consulta | Conceito praticado |
|---|---|---|
| 1 | Livro + autor + categoria | INNER JOIN triplo |
| 2 | Quantidade de livros por categoria (incluindo categorias vazias) | LEFT JOIN + COUNT |
| 3 | Membros que nunca fizeram empréstimo | LEFT JOIN + WHERE IS NULL |
| 4 | Empréstimos em aberto há mais de 30 dias | Subquery de data (`date('now', '-30 days')`) |
| 5 | Quantidade de livros por autor | GROUP BY + ORDER BY |
| 6 | Autores com mais de 1 livro | CTE (`WITH ... AS`) |
| 7 | Plano de execução da consulta de membros inativos | `EXPLAIN QUERY PLAN` |

## Índices e performance

Foram criados índices manuais em `emprestimos.membro_id` e `emprestimos.livro_id`,
colunas usadas com frequência em `JOIN` e `WHERE`. Colunas `UNIQUE`
(`categorias.nome`, `membros.email`) já recebem índice automático do SQLite,
então não precisaram de índice adicional.

Testado com `EXPLAIN QUERY PLAN` antes e depois da criação dos índices: sem
índice manual, o SQLite recorria a um índice automático **temporário**
(`AUTOMATIC COVERING INDEX`), recriado a cada execução da query. Com o índice
manual permanente, o plano passou a usar diretamente
`COVERING INDEX idx_emprestimos_membro`, eliminando esse custo repetido.

## Como rodar

Requer apenas Python 3 (usa o módulo `sqlite3` da biblioteca padrão — nenhuma
dependência externa).

```bash
python3 -c "
import sqlite3
conn = sqlite3.connect('biblioteca.db')
conn.executescript(open('schema.sql').read())
conn.executescript(open('seed.sql').read())
conn.commit()
print('Banco criado com sucesso: biblioteca.db')
"
```

Depois, para rodar as consultas:

```bash
python3 -c "
import sqlite3
conn = sqlite3.connect('biblioteca.db')
for row in conn.execute(open('queries.sql').read().split(';')[0]):
    print(row)
"
```

Ou, se tiver o CLI `sqlite3` instalado:

```bash
sqlite3 biblioteca.db < schema.sql
sqlite3 biblioteca.db < seed.sql
sqlite3 biblioteca.db < queries.sql
```

## Stack

- SQLite 3
- Python 3 (`sqlite3`, biblioteca padrão) para execução e testes

## Autor

Gustavo — estudante de ADS, em busca de estágio em TI.
