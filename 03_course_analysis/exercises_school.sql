-- Query 1: Retrieve all available subjects from the database
SELECT * FROM disciplinas;

-- Query 2: List students who passed Mathematics (Grade >= 7)
SELECT
    a.nome_aluno,
    n.nota
FROM notas n
JOIN disciplinas d
    ON n.ID_Disciplina = d.ID_Disciplina
JOIN alunos a
    ON n.ID_Aluno = a.ID_Aluno
WHERE
    d.nome_disciplina = 'Matemática'
    AND n.nota >= 7
ORDER BY 2 DESC;

-- Query 3: Count the total number of subjects assigned to each class
SELECT
    t.nome_turma,
    COUNT(d.id_disciplina) AS qty_disciplinas
FROM turmas t
JOIN turma_disciplinas td
    ON t.ID_Turma = td.ID_Turma
JOIN disciplinas d
    ON td.ID_Disciplina = d.ID_Disciplina
GROUP BY t.nome_turma;

-- Query 4: Calculate the overall student approval percentage
SELECT
    total_students,
    approved_students,
    -- Multiplying by 100.0 to ensure float division for accuracy
    ((approved_students * 100.0) / total_students) || '%' AS percentage
FROM (
    SELECT
        (SELECT COUNT(*) FROM alunos) AS total_students,
        (SELECT COUNT(*) FROM notas WHERE nota >= 7) AS approved_students
) AS summary_stats;

-- Query 5: Calculate the approval rate per subject
WITH approved_cte AS (
    SELECT
        d.nome_disciplina,
        COUNT(n.id_aluno) AS approved_students
    FROM notas n
    JOIN disciplinas d ON n.ID_Disciplina = d.ID_Disciplina
    WHERE n.nota >= 7
    GROUP BY d.nome_disciplina
), 
total_cte AS (
    SELECT
        d.nome_disciplina,
        COUNT(n.id_aluno) AS total_students
    FROM notas n
    JOIN disciplinas d ON n.ID_Disciplina = d.ID_Disciplina
    GROUP BY d.nome_disciplina  
)
SELECT
    t.nome_disciplina,
    -- ROUND handles decimal precision, COALESCE handles subjects with zero approvals
    ROUND((COALESCE(ap.approved_students, 0) * 100.0) / t.total_students, 2) AS approval_percentage
FROM total_cte t
LEFT JOIN approved_cte ap ON t.nome_disciplina = ap.nome_disciplina;