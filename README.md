# Tema04 - Manutenção de equipamentos

 
## Um banco de dados de manutenção de equipamentos em uma fábrica, onde o objetivo é controlar os equipamentos, seu histórico de manutenção, os técnicos responsáveis, peças utilizadas e as ordens de serviço.



## MER DER

![Imagem do MER DER](MER_DER_conceitual.png)


![Imagem do MER DER](MER_DER_logico.png)


## Markdown

### Equipamento
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

### Ordem Manutenção
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

### Técnico
| Atributo | Tipo de Dado | Restrições | Descrição |
|---|---|---|---|
| `id` | INT | **PK**, Auto Increment | Registro do funcionário técnico |
| `nome` | VARCHAR(100) | NOT NULL | Nome completo do profissional |
| `especialidade` | VARCHAR(50) | - | Área de atuação principal (Ex: Elétrica) |
| `telefone` | VARCHAR(20) | - | Telefone de contato corporativo |
| `email` | VARCHAR(100) | UNIQUE | Endereço eletrônico de contato |

### Peça
| Atributo | Tipo de Dado | Restrições | Descrição |
|---|---|---|---|
| `id_peca` | INT | **PK**, Auto Increment | Identificador de almoxarifado |
| `nome` | VARCHAR(100) | NOT NULL | Nome do item técnico de reposição |
| `descricao` | TEXT | - | Detalhamento ou part number |
| `quantidade_estoque` | INT | DEFAULT 0 | Volume físico disponível em estoque |
| `estoque_minimo` | INT | DEFAULT 0 | Ponto de pedido mínimo de segurança |
| `preco` | DECIMAL(10,2) | NOT NULL | Valor unitário de mercado da peça |

### Manutenção
| Atributo | Tipo de Dado | Restrições | Descrição |
|---|---|---|---|
| `id_manutencao` | INT | **PK**, Auto Increment | Identificador da intervenção física |
| `id_ordem` | INT | **FK**, NOT NULL | Ordem vinculada (Ordem_Manutencao.id_ordem) |
| `id_tecnico` | INT | **FK**, NOT NULL | Técnico que realizou o trabalho (Tecnico.id) |
| `descricao_servico` | TEXT | NOT NULL | Notas detalhadas da atividade executada |
| `data_execucao` | DATETIME | NOT NULL | Dia e hora exatos em que ocorreu a ação |
| `horas_trabalhadas` | DECIMAL(5,2) | NOT NULL | Tempo computado (Homem-Hora) do técnico |
| `observacoes` | TEXT | - | Comentários extras adicionais |

### Peça da Manutenção
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
create database if not exists controle_manutencao; 
use controle_manutencao;  

create table if not exists equipamento (     
    id int primary key auto_increment,     
    nome varchar(100) not null,     
    tipo varchar(50),     
    marca varchar(50),     
    modelo varchar(50),     
    numero_serie varchar(50) unique,     
    data_aquisicao date,     
    status varchar(20) default 'operacional',     
    setor varchar(50),     
    valor_de_aquisicao decimal(12, 2) 
);  

create table if not exists tecnico (     
    id int primary key auto_increment,     
    nome varchar(100) not null,     
    especialidade varchar(50),     
    telefone varchar(20),     
    email varchar(100) unique 
);  

create table if not exists peca (     
    id_peca int primary key auto_increment,     
    nome varchar(100) not null,     
    descricao text,     
    quantidade_estoque int not null default 0,     
    estoque_minimo int not null default 0,     
    preco decimal(10, 2) not null 
);  

create table if not exists ordem_manutencao (     
    id_ordem int primary key auto_increment,     
    id_equipamento int not null,     
    tipo varchar(30) not null,     
    descricao text not null,     
    data_abertura datetime not null default current_timestamp,     
    data_inicio datetime,     
    data_fim datetime,     
    status varchar(20) default 'aberta',     
    prioridade varchar(15),     
    foreign key (id_equipamento) references equipamento(id) on delete restrict 
);  

create table if not exists manutencao (     
    id_manutencao int primary key auto_increment,     
    id_ordem int not null,     
    id_tecnico int not null,     
    descricao_servico text not null,     
    data_execucao datetime not null,     
    horas_trabalhadas decimal(5, 2) not null,     
    observacoes text,     
    foreign key (id_ordem) references ordem_manutencao(id_ordem) on delete cascade,     
    foreign key (id_tecnico) references tecnico(id) on delete restrict 
);  

create table if not exists peca_da_manutencao (     
    id_manutencao int not null,     
    id_peca int not null,     
    quantidade int not null check (quantidade > 0),     
    primary key (id_manutencao, id_peca),     
    foreign key (id_manutencao) references manutencao(id_manutencao) on delete cascade,     
    foreign key (id_peca) references peca(id_peca) on delete restrict 
);
```

## Código dml.sql

```sql
use controle_manutencao;

insert into equipamento (id, nome, tipo, marca, modelo, numero_serie, data_aquisicao, status, setor, valor_de_aquisicao) values
(1, 'prensa hidráulica 50t', 'mecânico', 'zequinha prensas', 'prensabem', 'serie12345', '2022-03-15', 'operacional', 'estamparia', 45000.00),
(2, 'torno mecânico cnc', 'usinagem', 'torneiros', 'torno 3000', 'serie67890', '2021-08-22', 'em manutenção', 'usinagem', 120000.00),
(3, 'compressor de ar', 'pneumático', 'superar', 'ca strong', 'serie11223', '2023-01-10', 'operacional', 'utilidades', 28000.00);

insert into tecnico (id, nome, especialidade, telefone, email) values
(1, 'carlos silva', 'mecânica industrial', '199959697989', 'carlos.silva@fabrica.com'),
(2, 'roberto santos', 'eletrotécnica', '119912131415', 'roberto.santos@fabrica.com'),
(3, 'aline costa', 'automação', '119934156702', 'aline.costa@fabrica.com');

insert into peca (id_peca, nome, descricao, quantidade_estoque, estoque_minimo, preco) values
(1, 'anel de vedação', 'anelado 50mm', 150, 20, 15.50),
(2, 'contator elétrico 24v', 'componente elétrico', 12, 5, 189.90),
(3, 'óleo lubrificante wd40', 'lata grande', 8, 2, 34.00);

insert into ordem_manutencao (id_ordem, id_equipamento, tipo, descricao, data_abertura, data_inicio, data_fim, status, prioridade) values
(1, 1, 'preventiva', 'troca periódica de fluidos e vedações', '2026-09-20', '2026-09-20', '2026-09-20', 'concluída', 'média'),
(2, 2, 'corretiva', 'superaquecimento no motor principal do eixo x', '2026-09-21', '2026-09-21', null, 'em execução', 'alta'),
(3, 3, 'preventiva', 'inspeção de rotina de ruídos e vibrações', '2026-09-22', null, null, 'aberta', 'baixa');

insert into manutencao (id_manutencao, id_ordem, id_tecnico, descricao_servico, data_execucao, horas_trabalhadas, observacoes) values
(1, 1, 1, 'realizada a substituição do óleo antigo e troca dos anéis de vedação desgastados.', '2026-09-20', 2.5, 'sistema operou sem vazamentos após testes.'),
(2, 2, 2, 'iniciada a medição das bobinas e verificação de curto circuito no motor.', '2026-09-21', 2.0, 'aguardando resfriamento completo para novos testes técnicos.');

insert into peca_da_manutencao (id_manutencao, id_peca, quantidade) values
(1, 1, 4),
(1, 3, 1);

```
