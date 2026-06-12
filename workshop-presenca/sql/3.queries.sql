-- ============================================================
--  03_QUERIES.SQL
--  Relatórios e geração de certificados
--  Execute após 01_schema.sql e 02_seeds.sql
-- ============================================================

USE workshop_db;

-- ------------------------------------------------------------
-- Q1: Lista de presença completa por workshop e dia
-- ------------------------------------------------------------
SELECT
    w.nome                  AS workshop,
    p.nome                  AS participante,
    p.email,
    pr.data,
    pr.hora_entrada,
    pr.hora_saida,
    pr.status               AS presenca
FROM presenca pr
JOIN inscricao i    ON i.id  = pr.inscricao_id
JOIN participante p ON p.id  = i.participante_id
JOIN workshop w     ON w.id  = i.workshop_id
WHERE w.id = 1                -- altere para o ID do workshop desejado
ORDER BY pr.data, p.nome;


-- ------------------------------------------------------------
-- Q2: Percentual de frequência por participante
-- ------------------------------------------------------------
SELECT
    p.nome                                              AS participante,
    p.email,
    COUNT(pr.id)                                        AS total_dias,
    SUM(pr.status = 'presente')                         AS dias_presentes,
    ROUND(SUM(pr.status = 'presente') * 100.0
          / COUNT(pr.id), 1)                            AS frequencia_pct
FROM presenca pr
JOIN inscricao i    ON i.id = pr.inscricao_id
JOIN participante p ON p.id = i.participante_id
JOIN workshop w     ON w.id = i.workshop_id
WHERE w.id = 1
GROUP BY p.id, p.nome, p.email
ORDER BY frequencia_pct DESC;


-- ------------------------------------------------------------
-- Q3: Quem tem direito a certificado (>= 75% de presença)
-- ------------------------------------------------------------
SELECT
    p.nome                                              AS participante,
    p.email,
    w.nome                                              AS workshop,
    ROUND(SUM(pr.status = 'presente') * 100.0
          / COUNT(pr.id), 1)                            AS frequencia_pct,
    CASE
        WHEN SUM(pr.status = 'presente') * 100.0
             / COUNT(pr.id) >= 75 THEN 'Apto'
        ELSE 'Inapto'
    END                                                 AS situacao
FROM presenca pr
JOIN inscricao i    ON i.id = pr.inscricao_id
JOIN participante p ON p.id = i.participante_id
JOIN workshop w     ON w.id = i.workshop_id
WHERE w.id = 1
GROUP BY p.id, p.nome, p.email, w.nome
ORDER BY frequencia_pct DESC;


-- ------------------------------------------------------------
-- Q4: Gerar certificados para os aptos (INSERT)
-- Executa uma única vez por workshop
-- ------------------------------------------------------------
INSERT INTO certificado (inscricao_id, codigo_validacao)
SELECT
    i.id,
    UPPER(REPLACE(UUID(), '-', ''))  AS codigo_validacao
FROM inscricao i
JOIN workshop w ON w.id = i.workshop_id
WHERE w.id = 1
  AND i.status = 'confirmada'
  AND (
      SELECT ROUND(SUM(pr.status = 'presente') * 100.0 / COUNT(pr.id), 1)
      FROM presenca pr
      WHERE pr.inscricao_id = i.id
  ) >= 75
  AND NOT EXISTS (
      SELECT 1 FROM certificado c WHERE c.inscricao_id = i.id
  );


-- ------------------------------------------------------------
-- Q5: Relatório final — certificados emitidos
-- ------------------------------------------------------------
SELECT
    p.nome                  AS participante,
    p.email,
    w.nome                  AS workshop,
    c.data_emissao,
    c.codigo_validacao
FROM certificado c
JOIN inscricao i    ON i.id = c.inscricao_id
JOIN participante p ON p.id = i.participante_id
JOIN workshop w     ON w.id = i.workshop_id
WHERE w.id = 1
ORDER BY p.nome;


-- ------------------------------------------------------------
-- Q6: Resumo de presenças e ausências por dia
-- ------------------------------------------------------------
SELECT
    pr.data,
    SUM(pr.status = 'presente')    AS presentes,
    SUM(pr.status = 'ausente')     AS ausentes,
    SUM(pr.status = 'justificado') AS justificados,
    COUNT(*)                       AS total_inscritos
FROM presenca pr
JOIN inscricao i ON i.id = pr.inscricao_id
WHERE i.workshop_id = 1
GROUP BY pr.data
ORDER BY pr.data;
