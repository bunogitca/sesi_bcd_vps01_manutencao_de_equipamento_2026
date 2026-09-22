USE controle_manutencao;

INSERT INTO Equipamento (id, nome, tipo, marca, modelo, numero_serie, data_aquisicao, status, setor, valor_de_aquisicao) VALUES
(1, 'Prensa Hidráulica 50T', 'Mecânico', 'Marcon', 'PrensaBem', 'SERIE12345', '2022-03-15', 'Operacional', 'Estamparia', 45000.00),
(2, 'Torno Mecânico CNC', 'Usinagem', 'Romi', 'Torno 3000', 'SERIE67890', '2021-08-22', 'Em Manutenção', 'Usinagem', 120000.00),
(3, 'Compressor de Ar', 'Pneumático', 'Schulz', 'CA Strong', 'SERIE11223', '2023-01-10', 'Operacional', 'Utilidades', 28000.00);

INSERT INTO Tecnico (id, nome, especialidade, telefone, email) VALUES
(1, 'Carlos Silva', 'Mecânica Industrial', '199959697989', 'carlos.silva@fabrica.com'),
(2, 'Roberto Santos', 'Eletrotécnica', '119912131415', 'roberto.santos@fabrica.com'),
(3, 'Aline Costa', 'Automação', '119934156702', 'aline.costa@fabrica.com');

INSERT INTO Peca (id_peca, nome, descricao, quantidade_estoque, estoque_minimo, preco) VALUES
(1, 'Anel de Vedação', 'Anelado 50mm', 150, 20, 15.50),
(2, 'Contator Elétrico 24V', 'Componente elétrico', 12, 5, 189.90),
(3, 'Óleo Lubrificante WD40', 'Lata grande', 8, 2, 34.00);

INSERT INTO Ordem_Manutencao (id_ordem, id_equipamento, tipo, descricao, data_abertura, data_inicio, data_fim, status, prioridade) VALUES
(1, 1, 'Preventiva', 'Troca periódica de fluidos e vedações', '2026-09-20 08:00:00', '2026-09-20 09:00:00', '2026-09-20 11:30:00', 'Concluída', 'Média'),
(2, 2, 'Corretiva', 'Superaquecimento no motor principal do eixo X', '2026-09-21 14:00:00', '2026-09-21 14:30:00', NULL, 'Em Execução', 'Alta'),
(3, 3, 'Preventiva', 'Inspeção de rotina de ruídos e vibrações', '2026-09-22 07:00:00', NULL, NULL, 'Aberta', 'Baixa');

INSERT INTO Manutencao (id_manutencao, id_ordem, id_tecnico, descricao_servico, data_execucao, horas_trabalhadas, observacoes) VALUES
(1, 1, 1, 'Realizada a substituição do óleo antigo e troca dos anéis de vedação desgastados.', '2026-09-20 11:00:00', 2.5, 'Sistema operou sem vazamentos após testes.'),
(2, 2, 2, 'Iniciada a medição das bobinas e verificação de curto circuito no motor.', '2026-09-21 16:30:00', 2.0, 'Aguardando resfriamento completo para novos testes técnicos.');

INSERT INTO Peca_Da_Manutencao (id_manutencao, id_peca, quantidade) VALUES
(1, 1, 4),
(1, 3, 1);
