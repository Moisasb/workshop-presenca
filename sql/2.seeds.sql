USE workshop_db;

INSERT INTO workshop (nome, descricao, data_inicio, data_fim, instrutor, local, carga_horaria, vagas)
VALUES (
    'Workshop de Power BI',
    'Fundamentos e dashboards avançados com Power BI.',
    '2025-06-10',
    '2025-06-12',
    'Ana Paula Souza',
    'Sala 302 – Bloco A',
    16,
    25
);


INSERT INTO participante (nome, email, cpf, telefone) VALUES
    ('Carlos Mendes',   'carlos@email.com',   '12345678901', '11999990001'),
    ('Fernanda Lima',   'fernanda@email.com', '98765432100', '11999990002'),
    ('Rodrigo Alves',   'rodrigo@email.com',  '11122233344', '11999990003'),
    ('Juliana Costa',   'juliana@email.com',  '55566677788', '11999990004'),
    ('Marcos Oliveira', 'marcos@email.com',   '99988877766', '11999990005');


INSERT INTO inscricao (workshop_id, participante_id, status) VALUES
    (1, 1, 'confirmada'),
    (1, 2, 'confirmada'),
    (1, 3, 'confirmada'),
    (1, 4, 'confirmada'),
    (1, 5, 'confirmada');

INSERT INTO presenca (inscricao_id, data, hora_entrada, hora_saida, status) VALUES
   
    (1, '2025-06-10', '08:00', '17:00', 'presente'),
    (1, '2025-06-11', '08:05', '17:00', 'presente'),
    (1, '2025-06-12', '08:00', '17:00', 'presente'),


    (2, '2025-06-10', '08:10', '17:00', 'presente'),
    (2, '2025-06-11', '08:00', '17:00', 'presente'),
    (2, '2025-06-12', '08:15', '17:00', 'presente'),

   
    (3, '2025-06-10', '08:00', '17:00', 'presente'),
    (3, '2025-06-11', NULL,    NULL,    'ausente'),
    (3, '2025-06-12', '08:00', '17:00', 'presente'),


    (4, '2025-06-10', '08:00', '17:00', 'presente'),
    (4, '2025-06-11', '08:00', '17:00', 'presente'),
    (4, '2025-06-12', '08:00', '17:00', 'presente'),


    (5, '2025-06-10', '08:00', '17:00', 'presente'),
    (5, '2025-06-11', NULL,    NULL,    'ausente'),
    (5, '2025-06-12', NULL,    NULL,    'ausente');
