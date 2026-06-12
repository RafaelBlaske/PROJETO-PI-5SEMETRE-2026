-- =====================================================
-- AGIX Creator AI - Banco de Dados
-- =====================================================

-- Tabela de usuários
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  agency_name TEXT,
  plan TEXT DEFAULT 'free' CHECK(plan IN ('free', 'pro', 'enterprise')),
  api_key TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  last_login TEXT
);

-- Tabela de conteúdos gerados
CREATE TABLE IF NOT EXISTS contents (
  id TEXT PRIMARY KEY,
  user_id INTEGER NOT NULL,
  type INTEGER NOT NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  form_data TEXT NOT NULL,
  is_favorite INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Tabela de clientes da agência
CREATE TABLE IF NOT EXISTS clients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  niche TEXT,
  target_audience TEXT,
  notes TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Tabela de templates salvos
CREATE TABLE IF NOT EXISTS templates (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  type INTEGER NOT NULL,
  form_data TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Tabela de uso da IA (métricas)
CREATE TABLE IF NOT EXISTS ai_usage (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  content_type INTEGER NOT NULL,
  tokens_used INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- =====================================================
-- DADOS FICTÍCIOS
-- =====================================================

-- Usuários
INSERT INTO users (name, email, agency_name, plan, created_at, last_login) VALUES
  ('Carlos Mendes', 'carlos@agenciaboost.com.br', 'Agência Boost', 'pro', '2024-11-01 09:00:00', '2025-01-15 14:32:00'),
  ('Fernanda Lima', 'fernanda@creativehub.com.br', 'Creative Hub', 'enterprise', '2024-10-15 10:30:00', '2025-01-15 16:45:00'),
  ('Rafael Santos', 'rafael@rsmarketing.com.br', 'RS Marketing', 'free', '2025-01-05 08:00:00', '2025-01-14 11:20:00'),
  ('Juliana Costa', 'juliana@julianadigital.com.br', 'Juliana Digital', 'pro', '2024-12-01 13:00:00', '2025-01-15 09:10:00'),
  ('Bruno Oliveira', 'bruno@nextagency.com.br', 'Next Agency', 'pro', '2024-09-20 15:00:00', '2025-01-13 17:55:00');

-- Clientes
INSERT INTO clients (user_id, name, niche, target_audience, notes) VALUES
  (1, 'Clínica Sorrir Mais', 'Saúde e Odontologia', 'Adultos 25-50 anos, classe média', 'Foco em implantes e estética dental'),
  (1, 'Escola Futuro Brilhante', 'Educação', 'Pais de crianças 4-12 anos', 'Período integral, método montessori'),
  (1, 'Loja ModaFit', 'Moda Fitness', 'Mulheres 20-35 anos ativas', 'E-commerce + loja física em SP'),
  (2, 'Restaurante Sabor Carioca', 'Gastronomia', 'Público geral, turistas', 'Culinária típica RJ, delivery'),
  (2, 'Construtora Vitória', 'Imóveis', 'Compradores imóveis 30-55 anos', 'Imóveis médio-alto padrão'),
  (2, 'Academia PowerFit', 'Fitness', 'Jovens adultos 18-40 anos', 'Musculação e cross training'),
  (3, 'Pet Shop Patinhas', 'Pet', 'Donos de pets classe B/C', 'Banho, tosa e produtos'),
  (4, 'Studio de Pilates Equilíbrio', 'Saúde e Bem-estar', 'Mulheres 30-60 anos', 'Pilates e yoga'),
  (5, 'Tech Solutions TI', 'Tecnologia B2B', 'Empresários e gestores de TI', 'Suporte e consultoria');

-- Conteúdos gerados
INSERT INTO contents (id, user_id, type, title, content, form_data, is_favorite, created_at) VALUES
  (
    'c001', 1, 0, 'Instagram - Clínica Sorrir Mais',
    '## 📱 CONTEÚDO PARA INSTAGRAM

**Legenda:**
Seu sorriso merece o melhor cuidado! 😁✨
Na Clínica Sorrir Mais, utilizamos tecnologia de ponta para transformar sua autoestima.
Agende sua avaliação gratuita hoje mesmo!

📞 (11) 99999-0001
📍 Av. Paulista, 1000 - SP

**CTA:** Clique no link da bio e garanta sua consulta!

**Hashtags:**
#SorrirMais #OdontologiaEstetica #ImplanteDental #SaúdeBucal #SãoPaulo #Dentista #SorrisoPerfeito #AutoEstima',
    '{"clientType": "Clínica Odontológica", "niche": "Saúde", "targetAudience": "Adultos 25-50", "objective": "Agendar consultas", "tone": "Profissional e acolhedor", "platform": "Instagram"}',
    1,
    '2025-01-10 10:15:00'
  ),
  (
    'c002', 1, 1, 'Roteiro - ModaFit Lançamento Coleção',
    '## 🎬 ROTEIRO: LANÇAMENTO COLEÇÃO VERÃO

**Gancho (0:00-0:05)**
"Você ainda usa roupa que não te deixa arrasar na academia? Para tudo!"

**Desenvolvimento**
Bloco 1: O problema - roupas desconfortáveis que atrapalham o treino
Bloco 2: A solução - Coleção Verão ModaFit com tecnologia DryFit Pro
Bloco 3: Benefícios - Conforto, estilo e desempenho em um só look

**CTA Final (últimos 10s)**
"Corre no link da bio! Frete grátis só até domingo!"

**Legenda sugerida:**
Nova coleção chegou e ela veio pra arrasar! 🔥💪 Tecnologia + estilo no mesmo look. Link na bio!',
    '{"clientType": "Loja de Moda Fitness", "niche": "Moda", "targetAudience": "Mulheres 20-35", "objective": "Vendas", "tone": "Jovem e descontraído", "platform": "Instagram Reels"}',
    1,
    '2025-01-11 14:30:00'
  ),
  (
    'c003', 2, 2, 'Landing Page - Academia PowerFit',
    '## 🖥️ LANDING PAGE - POWERFIT

### HERO
**Headline:** Transforme Seu Corpo em 90 Dias — Ou Devolvemos Seu Dinheiro
**Sub-headline:** Treinos personalizados com acompanhamento profissional. Sem enrolação, só resultado.
**CTA:** QUERO COMEÇAR AGORA →

### PROBLEMA
Você já se cansou de pagar academia e não ver resultado? De treinar sem direção e perder motivação?

### SOLUÇÃO
Na PowerFit, cada aluno tem um plano exclusivo criado por nossos especialistas.

### BENEFÍCIOS
✅ Avaliação física completa e gratuita
✅ Treino 100% personalizado
✅ Acompanhamento semanal de evolução
✅ Acesso a mais de 50 aulas em grupo

### CTA FINAL
Vagas limitadas para Janeiro! Garanta a sua agora.',
    '{"clientType": "Academia", "niche": "Fitness", "targetAudience": "Jovens adultos 18-40", "objective": "Captar leads", "tone": "Motivacional", "service": "Musculação e Cross Training"}',
    0,
    '2025-01-12 09:45:00'
  ),
  (
    'c004', 2, 5, 'Proposta Comercial - Construtora Vitória',
    '## 📋 PROPOSTA COMERCIAL

**Cliente:** Construtora Vitória
**Serviço:** Gestão de Redes Sociais + Google Ads
**Valor:** R$ 3.500/mês

### ESCOPO
✅ Gestão Instagram e Facebook (20 posts/mês)
✅ Stories diários (5x por semana)
✅ Google Ads (verba de R$ 2.000 inclusa)
✅ Relatório mensal de performance
✅ Atendimento prioritário via WhatsApp

### CRONOGRAMA
Fase 1 - Onboarding: Dias 1-5
Fase 2 - Criação de identidade: Dias 6-15
Fase 3 - Publicações e anúncios: A partir do dia 16

### PRÓXIMOS PASSOS
1. Aprovação da proposta
2. Assinatura do contrato
3. Reunião de kickoff',
    '{"clientType": "Construtora", "niche": "Imóveis", "service": "Gestão de Redes Sociais + Ads", "budget": "R$ 3.500/mês", "tone": "Profissional"}',
    1,
    '2025-01-13 16:00:00'
  ),
  (
    'c005', 4, 4, 'Slogans - Studio Equilíbrio',
    '## 💡 SLOGANS - STUDIO EQUILÍBRIO

### Emocionais
1. "Encontre seu centro, transforme sua vida" — Conexão corpo e mente
2. "Onde o movimento encontra a paz" — Sensação de harmonia
3. "Cuide de você, você merece" — Autocuidado

### Focados em Benefício
1. "Mais flexibilidade, menos dor, mais vida" — Resultado prático
2. "Força que vem de dentro para fora" — Benefício físico e emocional

### Curtos e Memoráveis
1. "Mova-se. Equilibre-se. Viva."
2. "Pilates que transforma"
3. "Seu corpo agradece"

### TOP 3 RECOMENDADOS
1. **"Encontre seu centro, transforme sua vida"**
2. **"Mova-se. Equilibre-se. Viva."**
3. **"Mais flexibilidade, menos dor, mais vida"**',
    '{"clientType": "Studio de Pilates", "niche": "Saúde e Bem-estar", "targetAudience": "Mulheres 30-60", "tone": "Sereno e motivador"}',
    1,
    '2025-01-14 11:20:00'
  );

-- Templates salvos
INSERT INTO templates (user_id, name, type, form_data) VALUES
  (1, 'Instagram Padrão - Saúde', 0, '{"niche": "Saúde", "targetAudience": "Adultos 25-50", "objective": "Fortalecer marca", "tone": "Profissional e acolhedor", "platform": "Instagram"}'),
  (1, 'Roteiro Reels - Promoção', 1, '{"objective": "Vendas", "duration": "30s", "tone": "Jovem e descontraído", "platform": "Instagram Reels"}'),
  (2, 'Proposta Gestão de Redes', 5, '{"service": "Gestão de Redes Sociais", "tone": "Profissional", "validity": "15 dias"}'),
  (4, 'Instagram Bem-estar', 0, '{"niche": "Saúde e Bem-estar", "tone": "Sereno e motivador", "platform": "Instagram"}');

-- Métricas de uso
INSERT INTO ai_usage (user_id, content_type, tokens_used, created_at) VALUES
  (1, 0, 850, '2025-01-10 10:15:00'),
  (1, 1, 1200, '2025-01-11 14:30:00'),
  (1, 0, 780, '2025-01-12 08:00:00'),
  (2, 2, 2100, '2025-01-12 09:45:00'),
  (2, 5, 1800, '2025-01-13 16:00:00'),
  (2, 0, 900, '2025-01-14 10:00:00'),
  (3, 0, 750, '2025-01-14 09:30:00'),
  (4, 4, 1100, '2025-01-14 11:20:00'),
  (5, 5, 1950, '2025-01-14 15:00:00'),
  (1, 3, 650, '2025-01-15 08:45:00');
