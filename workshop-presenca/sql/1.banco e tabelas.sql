-- ============================================================
--  01_SCHEMA.SQL
--  Criação do banco de dados e tabelas
--  Sistema de Presença em Workshops
-- ============================================================

CREATE DATABASE IF NOT EXISTS workshop_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE workshop_db;

-- Workshops disponíveis
CREATE TABLE IF NOT EXISTS workshop (
    id            INT             NOT NULL AUTO_INCREMENT,
    nome          VARCHAR(150)    NOT NULL,
    descricao     TEXT,
    data_inicio   DATE            NOT NULL,
    data_fim      DATE            NOT NULL,
    instrutor     VARCHAR(100)    NOT NULL,
    local         VARCHAR(200),
    carga_horaria INT             NOT NULL COMMENT 'em horas',
    vagas         INT             DEFAULT 30,
    created_at    TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Participantes cadastrados
CREATE TABLE IF NOT EXISTS participante (
    id         INT           NOT NULL AUTO_INCREMENT,
    nome       VARCHAR(150)  NOT NULL,
    email      VARCHAR(150)  NOT NULL,
    cpf        CHAR(11)      UNIQUE,
    telefone   VARCHAR(20),
    created_at TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_email (email)
);

-- Inscrições: vínculo entre participante e workshop
CREATE TABLE IF NOT EXISTS inscricao (
    id               INT       NOT NULL AUTO_INCREMENT,
    workshop_id      INT       NOT NULL,
    participante_id  INT       NOT NULL,
    data_inscricao   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status           ENUM('confirmada', 'cancelada', 'lista_espera') DEFAULT 'confirmada',
    PRIMARY KEY (id),
    UNIQUE KEY uq_inscricao (workshop_id, participante_id),
    CONSTRAINT fk_inscricao_workshop     FOREIGN KEY (workshop_id)      REFERENCES workshop(id),
    CONSTRAINT fk_inscricao_participante FOREIGN KEY (participante_id)  REFERENCES participante(id)
);

-- Registro de presença por dia/sessão
CREATE TABLE IF NOT EXISTS presenca (
    id           INT      NOT NULL AUTO_INCREMENT,
    inscricao_id INT      NOT NULL,
    data         DATE     NOT NULL,
    hora_entrada TIME,
    hora_saida   TIME,
    status       ENUM('presente', 'ausente', 'justificado') DEFAULT 'presente',
    observacao   VARCHAR(255),
    PRIMARY KEY (id),
    UNIQUE KEY uq_presenca_dia (inscricao_id, data),
    CONSTRAINT fk_presenca_inscricao FOREIGN KEY (inscricao_id) REFERENCES inscricao(id)
);

-- Certificados emitidos para quem cumpriu os requisitos
CREATE TABLE IF NOT EXISTS certificado (
    id                INT          NOT NULL AUTO_INCREMENT,
    inscricao_id      INT          NOT NULL UNIQUE,
    data_emissao      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    codigo_validacao  VARCHAR(64)  NOT NULL UNIQUE COMMENT 'UUID para autenticação do certificado',
    caminho_arquivo   VARCHAR(300) COMMENT 'Caminho do PDF gerado',
    PRIMARY KEY (id),
    CONSTRAINT fk_certificado_inscricao FOREIGN KEY (inscricao_id) REFERENCES inscricao(id)
);
