USE workshop_db;

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
WHERE w.id = 1                
ORDER BY pr.data, p.nome;

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
