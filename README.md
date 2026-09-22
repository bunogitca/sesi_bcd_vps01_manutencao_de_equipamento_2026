# Tema04 - Manutenção de equipamentos

 
## Um banco de dados de manutenção de equipamentos em uma fábrica, onde o objetivo é controlar os equipamentos, seu histórico de manutenção, os técnicos responsáveis, peças utilizadas e as ordens de serviço.



## MER DER

![Imagem do MER DER](MER_DER_conceitual.png)


![Imagem do MER DER](MER_DER_logico.png)


## Markdown


| Atributo | Tipo de Dado | Restrições | Descrição |
|---|---|---|---|
| `id` | INT | **PK**, Auto Increment | Identificador único do equipamento |
| `nome`| VARCHAR(100) | NOT NULL | Nome descritivo (Ex: Prensa Hidráulica) |
| `tipo`| VARCHAR(50) | - | Categoria (Ex: Mecânico, Elétrico) |
| `marca`| VARCHAR(50) | - | Fabricante do equipamento |
| `modelo` | VARCHAR(50) | - | Modelo técnico de fábrica |
| `numero_serie` | VARCHAR(50) | UNIQUE | Número de série impresso na carcaça |
| `data_aquisicao` | DATE | - | Data de compra |
| `status` | VARCHAR(20) | DEFAULT 'Operacional' | Condição física atual do ativo |
| `setor` | VARCHAR(50) | - | Linha de produção ou área instalada |
| `valor_aquisicao` | DECIMAL(12,2) | - | Custo total de compra do bem |


| Atributo | Tipo de Dado | Restrições | Descrição |
|---|---|---|---|
| `id_ordem` | INT | **PK**, Auto Increment | Identificador único da O.M. |
| `id_equipamento` | INT | **FK**, NOT NULL | Referência ao Equipamento (Equipamento.id) |
| `tipo` | VARCHAR(30) | NOT NULL | Modelo do chamado (Preventiva/Corretiva) |
| `descricao` | TEXT | NOT NULL | Problema relatado ou plano de ação |
| `data_abertura` | DATETIME | NOT NULL, DEFAULT | Registro da abertura do chamado |
| `data_inicio` | DATETIME | - | Início real da execução técnica |
| `data_fim` | DATETIME | - | Fechamento definitivo da ordem |
| `status` | VARCHAR(20) | DEFAULT 'Aberta' | Status da etapa (Aberta/Em Execução/Concluída) |
|  `prioridade` | VARCHAR(15) | - | Grau de urgência (Baixa/Média/Alta/Crítica) |


| Atributo | Tipo de Dado | Restrições | Descrição |
|---|---|---|---|
| `id` | INT | **PK**, Auto Increment | Registro do funcionário técnico |
| `nome` | VARCHAR(100) | NOT NULL | Nome completo do profissional |
| `especialidade` | VARCHAR(50) | - | Área de atuação principal (Ex: Elétrica) |
| `telefone` | VARCHAR(20) | - | Telefone de contato corporativo |
| `email` | VARCHAR(100) | UNIQUE | Endereço eletrônico de contato |


| Atributo | Tipo de Dado | Restrições | Descrição |
|---|---|---|---|
| `id_peca` | INT | **PK**, Auto Increment | Identificador de almoxarifado |
| `nome` | VARCHAR(100) | NOT NULL | Nome do item técnico de reposição |
| `descricao` | TEXT | - | Detalhamento ou part number |
| `quantidade_estoque` | INT | DEFAULT 0 | Volume físico disponível em estoque |
| `estoque_minimo` | INT | DEFAULT 0 | Ponto de pedido mínimo de segurança |
| `preco` | DECIMAL(10,2) | NOT NULL | Valor unitário de mercado da peça |


| Atributo | Tipo de Dado | Restrições | Descrição |
|---|---|---|---|
| `id_manutencao` | INT | **PK**, Auto Increment | Identificador da intervenção física |
| `id_ordem` | INT | **FK**, NOT NULL | Ordem vinculada (Ordem_Manutencao.id_ordem) |
| `id_tecnico` | INT | **FK**, NOT NULL | Técnico que realizou o trabalho (Tecnico.id) |
| `descricao_servico` | TEXT | NOT NULL | Notas detalhadas da atividade executada |
| `data_execucao` | DATETIME | NOT NULL | Dia e hora exatos em que ocorreu a ação |
| `horas_trabalhadas` | DECIMAL(5,2) | NOT NULL | Tempo computado (Homem-Hora) do técnico |
| `observacoes` | TEXT | - | Comentários extras adicionais |


| Atributo | Tipo de Dado | Restrições | Descrição |
|---|---|---|---|
| `id_manutencao` | INT | **PK**, **FK** | Código da manutenção executada (Manutencao.id_manutencao) |
| `id_peca` | INT | **PK**, **FK** | Código da peça retirada do estoque (Peca.id_peca) |
| `quantidade` | INT | NOT NULL, CHECK > 0 | Volume de peças gastas nesta ação |

## Dados de Teste
[Tecnico](<Pasta1.CSV>)<br>
[Equipamento](<Pasta2.CSV>)<br>
[Peca](<Pasta3.CSV>)<br>
[Ordem Manutencao](<Pasta4.CSV>)<br>
[Manutencao](<Pasta5.CSV>)<br>
[Peca da Manutencao](<Pasta6.CSV>)<br>


## Código ddl.sql

```sql
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
```

## Código dml.sql

```sql
USE controle_manutencao;

INSERT INTO Equipamento (id, nome, tipo, marca, modelo, numero_serie, data_aquisicao, status, setor, valor_de_aquisicao) VALUES
(1, 'Prensa Hidráulica 50T', 'Mecânico', 'zequinha PRENSAS', 'PrensaBem', 'SERIE12345', '2022-03-15', 'Operacional', 'Estamparia', 45000.00),
(2, 'Torno Mecânico CNC', 'Usinagem', 'Torneiros', 'Torno 3000', 'SERIE67890', '2021-08-22', 'Em Manutenção', 'Usinagem', 120000.00),
(3, 'Compressor de Ar', 'Pneumático', 'SuperAr', 'CA Strong', 'SERIE11223', '2023-01-10', 'Operacional', 'Utilidades', 28000.00);

INSERT INTO Tecnico (id, nome, especialidade, telefone, email) VALUES
(1, 'Carlos Silva', 'Mecânica Industrial', '199959697989', 'carlos.silva@fabrica.com'),
(2, 'Roberto Santos', 'Eletrotécnica', '119912131415', 'roberto.santos@fabrica.com'),
(3, 'Aline Costa', 'Automação', '119934156702', 'aline.costa@fabrica.com');

INSERT INTO Peca (id_peca, nome, descricao, quantidade_estoque, estoque_minimo, preco) VALUES
(1, 'Anel de Vedação', 'Anelado 50mm', 150, 20, 15.50),
(2, 'Contator Elétrico 24V', 'Componente elétrico', 12, 5, 189.90),
(3, 'Óleo Lubrificante WD40', 'Lata grande', 8, 2, 34.00);

INSERT INTO Ordem_Manutencao (id_ordem, id_equipamento, tipo, descricao, data_abertura, data_inicio, data_fim, status, prioridade) VALUES
(1, 1, 'Preventiva', 'Troca periódica de fluidos e vedações', '2026-09-20', '2026-09-20', '2026-09-20', 'Concluída', 'Média'),
(2, 2, 'Corretiva', 'Superaquecimento no motor principal do eixo X', '2026-09-21', '2026-09-21', NULL, 'Em Execução', 'Alta'),
(3, 3, 'Preventiva', 'Inspeção de rotina de ruídos e vibrações', '2026-09-22', NULL, NULL, 'Aberta', 'Baixa');

INSERT INTO Manutencao (id_manutencao, id_ordem, id_tecnico, descricao_servico, data_execucao, horas_trabalhadas, observacoes) VALUES
(1, 1, 1, 'Realizada a substituição do óleo antigo e troca dos anéis de vedação desgastados.', '2026-09-20', 2.5, 'Sistema operou sem vazamentos após testes.'),
(2, 2, 2, 'Iniciada a medição das bobinas e verificação de curto circuito no motor.', '2026-09-21', 2.0, 'Aguardando resfriamento completo para novos testes técnicos.');

INSERT INTO Peca_Da_Manutencao (id_manutencao, id_peca, quantidade) VALUES
(1, 1, 4),
(1, 3, 1);
```
