import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // ============================================================
  // ✅ COLE SUA CHAVE DO GROQ AQUI (obtenha em console.groq.com)
  // ============================================================
  static const String _apiKey = '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';
  // ============================================================

  static const String _groqBaseUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.3-70b-versatile';

  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  // Mantidos por compatibilidade com o restante do app
  void setApiKey(String key) {}
  String get apiKey => _apiKey;

  // -----------------------------------------------
  // MÉTODO PRINCIPAL — usado por todas as telas
  // -----------------------------------------------
  Future<String> generateContent(
    String prompt, {
    String? systemPrompt,
    String? type,
  }) async {
    final String finalSystemPrompt =
        _getSystemPrompt(type: type, customPrompt: systemPrompt);

    try {
      final response = await http.post(
        Uri.parse(_groqBaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': finalSystemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.8,
          'max_tokens': 3000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'] as String;
      } else if (response.statusCode == 401) {
        throw Exception(
          'API Key inválida. Verifique a constante _apiKey em ai_service.dart.',
        );
      } else {
        final error = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(
          error['error']?['message'] ??
              'Erro no servidor (${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(
        'Não foi possível conectar à API do Groq. Verifique sua conexão.',
      );
    }
  }

  // -----------------------------------------------
  // SYSTEM PROMPTS POR TIPO
  // -----------------------------------------------
  String _getSystemPrompt({String? type, String? customPrompt}) {
    if (customPrompt != null && customPrompt.isNotEmpty) return customPrompt;

    switch (type) {
      case 'landing_page':
        return '''Você é um Copywriter Sênior especializado em Landing Pages de alta conversão para o mercado brasileiro.

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

Responda sempre em português brasileiro com linguagem adequada ao tom de voz solicitado.''';

      case 'video_script':
        return '''Você é um Roteirista profissional especializado em vídeos para redes sociais e YouTube no mercado brasileiro.

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

Responda sempre em português brasileiro.''';

      case 'slogan':
        return '''Você é um especialista em Branding, Naming e Copywriting para o mercado brasileiro.

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

Responda sempre em português brasileiro.''';

      case 'proposal':
        return '''Você é um Consultor de Vendas B2B e especialista em propostas comerciais para agências de marketing brasileiras.

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
[Demonstre que entendeu o problema/necessidade do cliente]

---

## 💡 SOLUÇÃO PROPOSTA
[Descreva detalhadamente a solução]

---

## 📦 ESCOPO DE ENTREGA
### O que está INCLUÍDO nesta proposta:
- ✅ [entregável 1 com descrição]
- ✅ [entregável 2 com descrição]
- ✅ [entregável 3 com descrição]

### O que NÃO está incluído:
- ❌ [item não incluso 1]
- ❌ [item não incluso 2]

---

## 📅 CRONOGRAMA ESTIMADO
| Fase | Descrição | Prazo |
|------|-----------|-------|
| Fase 1 | Onboarding e alinhamento | Dias 1-3 |
| Fase 2 | [fase] | [prazo] |
| Entrega Final | [descrição] | [prazo total] |

---

## 💰 INVESTIMENTO
> **Valor Total: [valor]**

[Contextualize o valor mostrando o ROI esperado]

**Formas de pagamento sugeridas:**
- Opção 1: [pagamento à vista com desconto]
- Opção 2: [parcelamento]

---

## 🚀 PRÓXIMOS PASSOS
1. Aprovação desta proposta
2. Assinatura do contrato
3. Pagamento da entrada
4. Reunião de kickoff

---

*Esta proposta tem validade de 15 dias corridos a partir da data de envio.*

Responda sempre em português brasileiro com tom profissional e persuasivo.''';

      case 'instagram':
        return 'Você é um especialista em marketing de conteúdo para redes sociais, focado no mercado brasileiro. Crie conteúdo estratégico com legenda completa, hashtags relevantes e sugestão de visual. Responda sempre em português brasileiro.';

      case 'brand_name':
        return 'Você é um especialista em Naming e Branding para o mercado brasileiro. Sugira nomes de marca criativos, disponíveis para registro e que se conectem ao público-alvo. Organize por categorias e explique o conceito de cada nome. Responda sempre em português brasileiro.';

      case 'analysis':
        return 'Você é um especialista em marketing digital e análise de conteúdo para redes sociais. Analise o potencial de engajamento e sugira melhorias práticas. Responda sempre em português brasileiro.';

      case 'calendar':
        return 'Você é um estrategista de conteúdo digital para o mercado brasileiro. Crie calendários editoriais detalhados e estratégicos. Responda sempre em português brasileiro.';

      default:
        return 'Você é um especialista em marketing digital e criação de conteúdo para agências brasileiras. Responda sempre em português brasileiro.';
    }
  }

  // -----------------------------------------------
  // INSTAGRAM
  // -----------------------------------------------
  Future<String> generateInstagramContent({
    required String niche,
    required String audience,
    required String objective,
    required String platform,
    required String voiceTone,
    String? clientType,
  }) async {
    final prompt = '''Gere conteúdo estratégico para $platform:
Nicho: $niche
Público-alvo: $audience
Objetivo: $objective
Tom de Voz: $voiceTone
Tipo de Cliente: ${clientType ?? 'Não especificado'}''';
    return generateContent(prompt, type: 'instagram');
  }

  // -----------------------------------------------
  // ROTEIRO DE VÍDEO
  // -----------------------------------------------
  Future<String> generateVideoScript({
    required String niche,
    required String audience,
    required String objective,
    required String voiceTone,
    required String videoDuration,
    String? topic,
  }) async {
    final prompt = '''Crie um roteiro de vídeo detalhado:
Tema/Assunto: ${topic ?? 'Tendências do nicho'}
Nicho: $niche
Público-alvo: $audience
Objetivo: $objective
Duração Estimada: $videoDuration
Tom de Voz: $voiceTone''';
    return generateContent(prompt, type: 'video_script');
  }

  // -----------------------------------------------
  // LANDING PAGE
  // -----------------------------------------------
  Future<String> generateLandingPageCopy({
    required String niche,
    required String audience,
    required String objective,
    required String voiceTone,
    required String productService,
    String? mainBenefit,
  }) async {
    final prompt = '''Crie um prompt completo e esboço de Landing Page:
Produto/Serviço: $productService
Principal Benefício: ${mainBenefit ?? 'Não especificado'}
Nicho: $niche
Público-alvo: $audience
Objetivo da Página: $objective
Tom de Voz: $voiceTone''';
    return generateContent(prompt, type: 'landing_page');
  }

  // -----------------------------------------------
  // NOMES DE MARCA
  // -----------------------------------------------
  Future<String> generateBrandNames({
    required String niche,
    required String audience,
    required String voiceTone,
    String? keywords,
    String? style,
  }) async {
    final prompt = '''Sugira nomes de marca criativos:
Nicho: $niche
Público-alvo: $audience
Estilo Desejado: ${style ?? 'Moderno e Minimalista'}
Palavras-chave: ${keywords ?? 'Relacionadas ao nicho'}
Tom de Voz da Marca: $voiceTone''';
    return generateContent(prompt, type: 'brand_name');
  }

  // -----------------------------------------------
  // SLOGANS
  // -----------------------------------------------
  Future<String> generateSlogans({
    required String brandName,
    required String niche,
    required String audience,
    required String voiceTone,
    String? mainValue,
  }) async {
    final prompt = '''Gere slogans memoráveis para a marca:
Nome da Marca: $brandName
Nicho de Atuação: $niche
Público-alvo: $audience
Valor Principal/Diferencial: ${mainValue ?? 'Qualidade e Confiança'}
Tom de Voz: $voiceTone''';
    return generateContent(prompt, type: 'slogan');
  }

  // -----------------------------------------------
  // PROPOSTA COMERCIAL
  // -----------------------------------------------
  Future<String> generateCommercialProposal({
    required String serviceType,
    required String clientName,
    required String clientNiche,
    required String value,
    required String deadline,
    required String deliverables,
    String? agencyName,
  }) async {
    final prompt = '''Gere uma proposta comercial personalizada:
Agência/Profissional: ${agencyName ?? 'Consultoria Especializada'}
Cliente: $clientName
Nicho do Cliente: $clientNiche
Serviço a ser Prestado: $serviceType
Entregáveis: $deliverables
Valor do Investimento: $value
Prazo de Entrega: $deadline''';
    return generateContent(prompt, type: 'proposal');
  }

  // -----------------------------------------------
  // ANÁLISE DE ENGAJAMENTO
  // -----------------------------------------------
  Future<String> analyzeEngagement(String caption) async {
    return generateContent(
      'Analise o potencial de engajamento desta legenda e sugira melhorias:\nLegenda: "$caption"',
      type: 'analysis',
    );
  }

  // -----------------------------------------------
  // CALENDÁRIO DE CONTEÚDO
  // -----------------------------------------------
  Future<String> generateContentCalendar({
    required String niche,
    required String postsPerWeek,
    required String objective,
    required String platform,
    String? brandName,
  }) async {
    final prompt = '''Crie um calendário de conteúdo para 30 dias:
Marca: ${brandName ?? 'Agência de Conteúdo'}
Nicho: $niche
Plataforma: $platform
Frequência: $postsPerWeek posts por semana
Objetivo Principal: $objective''';
    return generateContent(prompt, type: 'calendar');
  }
}