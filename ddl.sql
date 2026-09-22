CREATE DATABASE IF NOT EXISTS controle_manutencao;
USE controle_manutencao;

CREATE TABLE Equipamento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50),
    marca VARCHAR(50),
    modelo VARCHAR(50),
    numero_serie VARCHAR(50) UNIQUE,
    data_aquisicao DATE,
    status VARCHAR(20) DEFAULT 'Operacional',
    setor VARCHAR(50),
    valor_de_aquisicao DECIMAL(12, 2)
);

CREATE TABLE Tecnico (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(50),
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Peca (
    id_peca INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    estoque_minimo INT NOT NULL DEFAULT 0,
    preco DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Ordem_Manutencao (
    id_ordem INT PRIMARY KEY AUTO_INCREMENT,
    id_equipamento INT NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    descricao TEXT NOT NULL,
    data_abertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_inicio DATETIME,
    data_fim DATETIME,
    status VARCHAR(20) DEFAULT 'Aberta',
    prioridade VARCHAR(15),
    FOREIGN KEY (id_equipamento) REFERENCES Equipamento(id) ON DELETE RESTRICT
);

CREATE TABLE Manutencao (
    id_manutencao INT PRIMARY KEY AUTO_INCREMENT,
    id_ordem INT NOT NULL,
    id_tecnico INT NOT NULL,
    descricao_servico TEXT NOT NULL,
    data_execucao DATETIME NOT NULL,
    horas_trabalhadas DECIMAL(5, 2) NOT NULL,
    observacoes TEXT,
    FOREIGN KEY (id_ordem) REFERENCES Ordem_Manutencao(id_ordem) ON DELETE CASCADE,
    FOREIGN KEY (id_tecnico) REFERENCES Tecnico(id) ON DELETE RESTRICT
);

CREATE TABLE Peca_Da_Manutencao (
    id_manutencao INT NOT NULL,
    id_peca INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    PRIMARY KEY (id_manutencao, id_peca),
    FOREIGN KEY (id_manutencao) REFERENCES Manutencao(id_manutencao) ON DELETE CASCADE,
    FOREIGN KEY (id_peca) REFERENCES Peca(id_peca) ON DELETE RESTRICT
);
