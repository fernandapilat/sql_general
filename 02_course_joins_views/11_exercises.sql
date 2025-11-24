-- Query 1: Retrieve the professor's name and the class (turma) they advise (orientador)

SELECT 
	p.nome_professor,
    t.nome_turma
FROM turmas t
LEFT JOIN professores p
	ON t.id_professor_orientador = p.id_professor;

-- ------------------------------------------------------------------------------------------------------------------

-- Query 2: Return the name and score of the student with the best (highest) grade in the 'Matemática' (Mathematics) discipline

SELECT
	a.nome_aluno,
    n.nota
FROM disciplinas d
JOIN notas n
	ON d.id_disciplina = n.id_disciplina
JOIN alunos a
	ON n.id_aluno = a.id_aluno
WHERE
	d.nome_disciplina = 'Matemática'
ORDER BY n.nota DESC
LIMIT 1;


-- Alternative Query 2 (Using MAX for highest score and filtering by ID)
SELECT 
	nome_aluno, 
    MAX(nota) as maior_nota
FROM Alunos A
JOIN Notas N 
	ON A.ID_Aluno = N.ID_Aluno
JOIN Disciplinas D 
	ON D.ID_Disciplina = N.ID_Disciplina 
WHERE N.ID_Disciplina = 1;


-- ------------------------------------------------------------------------------------------------------------------

-- Query 3: Identify the total number of students per class (turma)

SELECT
	t.id_turma,
    t.nome_turma,
    COUNT(a.nome_aluno) qty_aluno
FROM alunos a
JOIN turma_alunos ta
	ON ta.id_aluno = a.id_aluno 
JOIN turmas t
	ON ta.id_turma = ta.id_turma -- NOTE: This join condition should probably be 't.id_turma = ta.id_turma'
GROUP BY t.id_turma, t.nome_turma;

-- ------------------------------------------------------------------------------------------------------------------

-- Query 4: List the Students and the disciplines they are enrolled in

SELECT
	a.nome_aluno,
    d.nome_disciplina
FROM alunos a
JOIN turma_alunos ta
	ON a.id_aluno = ta.id_aluno
JOIN turma_disciplinas td
	ON ta.id_turma = td.id_turma
JOIN disciplinas d
	ON td.id_disciplina = d.id_disciplina;

-- ------------------------------------------------------------------------------------------------------------------

-- Query 5: Create a view that displays the name, discipline, and score of the students

create VIEW general_score AS
SELECT
	a.nome_aluno,
    d.nome_disciplina,
    n.nota
FROM alunos a
JOIN notas n
	ON a.id_aluno = n.id_aluno
JOIN disciplinas d
	ON n.id_disciplina = d.id_disciplina;