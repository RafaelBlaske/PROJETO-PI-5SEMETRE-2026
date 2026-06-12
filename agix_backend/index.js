const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const Groq = require('groq-sdk');
const db = require('./db');

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// =====================================================
// COLOQUE SUA CHAVE GROQ NO ARQUIVO .env:
// GROQ_API_KEY=gsk_...sua_chave_aqui...
// Obtenha grátis em: https://console.groq.com
// =====================================================
const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });

app.get('/', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'AGIX Creator AI Backend está rodando! 🚀',
    apiKeyConfigured: !!process.env.GROQ_API_KEY && process.env.GROQ_API_KEY !== 'sua_chave_aqui...'
  });
});

// =====================================================
// ROTA PRINCIPAL DE GERAÇÃO DE CONTEÚDO
// =====================================================
app.post('/api/generate', async (req, res) => {
  try {
    const { prompt, systemPrompt, type } = req.body;

    if (!prompt) {
      return res.status(400).json({ error: 'O prompt é obrigatório.' });
    }

    // Verifica se a chave está configurada
    if (!process.env.GROQ_API_KEY || process.env.GROQ_API_KEY === 'sua_chave_aqui...') {
      return res.status(500).json({ 
        error: 'Chave do Groq não configurada. Edite o arquivo .env e adicione sua GROQ_API_KEY.' 
      });
    }

    let finalSystemPrompt = systemPrompt || "Você é um especialista em marketing digital e criação de conteúdo para agências brasileiras. Responda sempre em português brasileiro.";

    // -----------------------------------------------
    // LANDING PAGE
    // -----------------------------------------------
    if (type === 'landing_page') {
      finalSystemPrompt = `Você é um Copywriter Sênior especializado em Landing Pages de alta conversão para o mercado brasileiro.
      
Sua tarefa é criar um PROMPT COMPLETO e um ESBOÇO ESTRUTURADO de Landing Page baseado nas informações fornecidas pelo usuário.

Formate a resposta em Markdown com as seguintes seções obrigatórias:

## 🎯 PROMPT PARA IA (para usar em ferramentas como Midjourney, ChatGPT, etc.)
> Escreva aqui um prompt detalhado que o usuário pode copiar e usar em outra IA para gerar o design completo da landing page

---

## 📐 ESBOÇO DA LANDING PAGE

### 1. SEÇÃO HERO (Topo)
- **Headline Principal:** [título impactante]
- **Sub-headline:** [complemento persuasivo]
- **CTA Principal:** [botão de ação]
- **Elemento visual sugerido:** [descrição]

### 2. SEÇÃO DE PROBLEMA
- [Descreva as dores do público-alvo]

### 3. SEÇÃO DE SOLUÇÃO / BENEFÍCIOS
- ✅ Benefício 1: ...
- ✅ Benefício 2: ...
- ✅ Benefício 3: ...

### 4. PROVA SOCIAL
- [Modelo de depoimento 1]
- [Modelo de depoimento 2]
- [Número social sugerido]

### 5. SOBRE / AUTORIDADE
- [Texto de autoridade]

### 6. FAQ (Perguntas Frequentes)
- **Pergunta 1?** Resposta...
- **Pergunta 2?** Resposta...

### 7. CTA FINAL
- **Headline de fechamento:** ...
- **Botão CTA:** ...
- **Garantia/Urgência:** ...

---

## 📝 COPY COMPLETA PARA CADA SEÇÃO
[Escreva o texto final pronto para usar em cada seção acima]

Responda sempre em português brasileiro com linguagem adequada ao tom de voz solicitado.`;
    }

    // -----------------------------------------------
    // ROTEIRO DE VÍDEO
    // -----------------------------------------------
    else if (type === 'video_script') {
      finalSystemPrompt = `Você é um Roteirista profissional especializado em vídeos para redes sociais e YouTube no mercado brasileiro.

Crie um roteiro COMPLETO e DETALHADO baseado nas informações fornecidas. 

Formate em Markdown com:

## 🎬 ROTEIRO: [TÍTULO DO VÍDEO]

**Duração estimada:** [X minutos/segundos]  
**Plataforma ideal:** [sugestão]  
**Tom:** [tom de voz]

---

### ⚡ GANCHO (0:00 - 0:05)
> [Texto exato a ser dito]  
> [Nota de cena: o que aparece na tela]

---

### 🔥 DESENVOLVIMENTO

**Bloco 1 - O Problema (0:05 - 0:XX)**
> [Texto exato]  
> [Nota de cena]

**Bloco 2 - A Solução (0:XX - 0:XX)**
> [Texto exato]  
> [Nota de cena]

**Bloco 3 - Prova/Argumentos (0:XX - 0:XX)**
> [Texto exato]  
> [Nota de cena]

---

### 🎯 CTA FINAL (últimos 10-15 segundos)
> [Texto exato do CTA]  
> [Nota de cena do CTA]

---

### 📌 LEGENDA SUGERIDA PARA O POST
[Legenda pronta para Instagram/TikTok/YouTube]

### #️⃣ HASHTAGS SUGERIDAS
[Lista de hashtags relevantes]

Responda sempre em português brasileiro.`;
    }

    // -----------------------------------------------
    // SLOGANS
    // -----------------------------------------------
    else if (type === 'slogan') {
      finalSystemPrompt = `Você é um especialista em Branding, Naming e Copywriting para o mercado brasileiro.

Baseado nas informações da marca fornecidas pelo usuário, gere slogans memoráveis, criativos e estratégicos.

Formate em Markdown:

## 💬 SLOGANS PARA: [NOME DA MARCA]

### 🧠 CATEGORIA 1 — Emocionais (conectam pelo sentimento)
1. "[slogan]" — *[breve explicação do apelo emocional]*
2. "[slogan]" — *[explicação]*
3. "[slogan]" — *[explicação]*
4. "[slogan]" — *[explicação]*
5. "[slogan]" — *[explicação]*

### 💡 CATEGORIA 2 — Focados em Benefício (o que o cliente ganha)
1. "[slogan]" — *[benefício destacado]*
2. "[slogan]" — *[explicação]*
3. "[slogan]" — *[explicação]*
4. "[slogan]" — *[explicação]*
5. "[slogan]" — *[explicação]*

### ⚡ CATEGORIA 3 — Curtos e Minimalistas (fáceis de memorizar)
1. "[slogan]"
2. "[slogan]"
3. "[slogan]"
4. "[slogan]"
5. "[slogan]"

### 🔥 CATEGORIA 4 — Provocativos/Disruptivos (chamam atenção)
1. "[slogan]" — *[explicação da provocação]*
2. "[slogan]" — *[explicação]*
3. "[slogan]" — *[explicação]*
4. "[slogan]" — *[explicação]*
5. "[slogan]" — *[explicação]*

### 🏆 TOP 3 RECOMENDADOS
> Baseado no nicho e tom de voz, estes são os mais estratégicos:
> 1. **"[slogan]"** — [motivo da recomendação]
> 2. **"[slogan]"** — [motivo]
> 3. **"[slogan]"** — [motivo]

Responda sempre em português brasileiro.`;
    }

    // -----------------------------------------------
    // PROPOSTA COMERCIAL
    // -----------------------------------------------
    else if (type === 'proposal') {
      finalSystemPrompt = `Você é um Consultor de Vendas B2B e especialista em propostas comerciais para agências de marketing brasileiras.

Crie uma Proposta Comercial PROFISSIONAL, COMPLETA e PERSUASIVA baseada nas informações fornecidas.

Formate em Markdown:

# PROPOSTA COMERCIAL

---

## 📋 DADOS DA PROPOSTA
| Campo | Informação |
|-------|-----------|
| **Agência/Profissional** | [nome] |
| **Cliente** | [nome] |
| **Serviço** | [tipo] |
| **Data** | [data atual] |
| **Validade** | 15 dias |

---

## 👋 APRESENTAÇÃO
[Parágrafo caloroso de apresentação da agência, destacando experiência e credibilidade]

---

## 🔍 ENTENDIMENTO DO DESAFIO
[Demonstre que entendeu o problema/necessidade do cliente. Mencione o nicho e os objetivos específicos]

---

## 💡 SOLUÇÃO PROPOSTA
[Descreva detalhadamente a solução, conectando cada elemento ao benefício para o cliente]

---

## 📦 ESCOPO DE ENTREGA
### O que está INCLUÍDO nesta proposta:
- ✅ [entregável 1 com descrição]
- ✅ [entregável 2 com descrição]
- ✅ [entregável 3 com descrição]
- ✅ [entregável 4 com descrição]

### O que NÃO está incluído:
- ❌ [item não incluso 1]
- ❌ [item não incluso 2]

---

## 📅 CRONOGRAMA ESTIMADO
| Fase | Descrição | Prazo |
|------|-----------|-------|
| Fase 1 | Onboarding e alinhamento | Dias 1-3 |
| Fase 2 | [fase] | [prazo] |
| Fase 3 | [fase] | [prazo] |
| Entrega Final | [descrição] | [prazo total] |

---

## 💰 INVESTIMENTO
> **Valor Total: [valor]**

[Contextualize o valor mostrando o ROI esperado e o custo-benefício]

**Formas de pagamento sugeridas:**
- Opção 1: [pagamento à vista com desconto]
- Opção 2: [parcelamento]

---

## 🚀 PRÓXIMOS PASSOS
1. Aprovação desta proposta
2. Assinatura do contrato
3. Pagamento da entrada
4. Reunião de kickoff
5. Início dos trabalhos

---

## 📞 CONTATO
[Nome da agência] | [sugestão de contato]

---
*Esta proposta tem validade de 15 dias corridos a partir da data de envio.*

Responda sempre em português brasileiro com tom profissional e persuasivo.`;
    }

    // -----------------------------------------------
    // INSTAGRAM
    // -----------------------------------------------
    else if (type === 'instagram') {
      finalSystemPrompt = "Você é um especialista em marketing de conteúdo para redes sociais, focado no mercado brasileiro. Crie conteúdo estratégico com legenda completa, hashtags relevantes e sugestão de visual. Responda sempre em português brasileiro.";
    }

    // -----------------------------------------------
    // NOME DE MARCA
    // -----------------------------------------------
    else if (type === 'brand_name') {
      finalSystemPrompt = "Você é um especialista em Naming e Branding para o mercado brasileiro. Sugira nomes de marca criativos, disponíveis para registro e que se conectem ao público-alvo. Organize por categorias e explique o conceito de cada nome. Responda sempre em português brasileiro.";
    }

    // -----------------------------------------------
    // CHAMADA AO GROQ
    // -----------------------------------------------
    const completion = await groq.chat.completions.create({
      model: 'llama-3.3-70b-versatile',
      messages: [
        { role: 'system', content: finalSystemPrompt },
        { role: 'user', content: prompt }
      ],
      temperature: 0.8,
      max_tokens: 3000,
    });

    const content = completion.choices[0].message.content;

    res.json({ content });

  } catch (error) {
    console.error('Erro no Groq:', error.message || error);

    if (error.message && error.message.includes('401')) {
      return res.status(401).json({ 
        error: 'Chave do Groq inválida. Verifique sua GROQ_API_KEY no arquivo .env' 
      });
    }

    res.status(500).json({ 
      error: 'Erro ao processar sua solicitação com a IA.',
      details: error.message 
    });
  }
});

// =====================================================
// ROTAS DO BANCO DE DADOS
// =====================================================

// Stats gerais
app.get('/api/stats', (req, res) => {
  try {
    res.json(db.getGeneralStats());
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Usuários
app.get('/api/users', (req, res) => {
  try {
    res.json(db.getAllUsers());
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/users/:id', (req, res) => {
  try {
    const user = db.getUserById(req.params.id);
    if (!user) return res.status(404).json({ error: 'Usuário não encontrado' });
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.post('/api/users', (req, res) => {
  try {
    const user = db.createUser(req.body);
    res.status(201).json(user);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
});

// Conteúdos
app.get('/api/users/:userId/contents', (req, res) => {
  try {
    const contents = db.getContentsByUser(req.params.userId);
    res.json(contents);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/users/:userId/favorites', (req, res) => {
  try {
    res.json(db.getFavoritesByUser(req.params.userId));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.post('/api/contents', (req, res) => {
  try {
    const content = db.saveContent(req.body);
    res.status(201).json(content);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
});

app.patch('/api/contents/:id/favorite', (req, res) => {
  try {
    res.json(db.toggleFavorite(req.params.id));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.delete('/api/contents/:id', (req, res) => {
  try {
    db.deleteContent(req.params.id);
    res.json({ success: true });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Clientes
app.get('/api/users/:userId/clients', (req, res) => {
  try {
    res.json(db.getClientsByUser(req.params.userId));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.post('/api/clients', (req, res) => {
  try {
    const client = db.createClient(req.body);
    res.status(201).json(client);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
});

// Templates
app.get('/api/users/:userId/templates', (req, res) => {
  try {
    res.json(db.getTemplatesByUser(req.params.userId));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.post('/api/templates', (req, res) => {
  try {
    const template = db.saveTemplate(req.body);
    res.status(201).json(template);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
});

// Métricas de uso
app.get('/api/users/:userId/usage', (req, res) => {
  try {
    res.json(db.getUsageByUser(req.params.userId));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Inicia o servidor após o banco estar pronto
async function start() {
  await db.initDatabase();
  app.listen(port, () => {
    console.log(`\n🚀 Servidor AGIX rodando em http://localhost:${port}`);
    console.log(`🔑 API Key configurada: ${!!process.env.GROQ_API_KEY && process.env.GROQ_API_KEY !== 'sua_chave_aqui...' ? '✅ Sim' : '❌ NÃO - edite o arquivo .env!'}`);
    console.log(`🗄️  Banco de dados: agix.db\n`);
  });
}

start().catch(err => {
  console.error('Erro ao iniciar o servidor:', err);
  process.exit(1);
});
