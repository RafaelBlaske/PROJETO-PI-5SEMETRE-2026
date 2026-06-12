class AppConstants {
  static const String appName = 'AGIX Creator AI';
  static const String appVersion = '1.0.0';

  // OpenAI
  static const String openAiModel = 'gpt-4.1-mini';
  static const int maxTokens = 2048;

  // Storage keys
  static const String historyKey = 'agix_history';
  static const String apiKeyKey = 'agix_api_key';

  // Content types
  static const List<String> contentTypes = [
    'Conteúdo para Instagram',
    'Roteiro de Vídeo',
    'Copy para Landing Page',
    'Nome de Marca',
    'Slogan',
    'Proposta Comercial',
  ];

  // Niches
  static const List<String> niches = [
    'Saúde e Bem-estar',
    'Beleza e Estética',
    'Fitness e Academia',
    'Alimentação e Gastronomia',
    'Moda e Vestuário',
    'Tecnologia',
    'Educação',
    'Finanças e Investimentos',
    'Imóveis',
    'Advocacia e Jurídico',
    'Odontologia',
    'Medicina',
    'Psicologia',
    'Arquitetura e Design',
    'Marketing Digital',
    'E-commerce',
    'Turismo e Viagens',
    'Automóveis',
    'Construção Civil',
    'Outro',
  ];

  // Audiences
  static const List<String> audiences = [
    'Jovens (18-25 anos)',
    'Adultos (25-35 anos)',
    'Adultos (35-45 anos)',
    'Meia idade (45-60 anos)',
    'Empreendedores',
    'Mães',
    'Profissionais liberais',
    'Estudantes',
    'Executivos',
    'Público geral',
  ];

  // Objectives
  static const List<String> objectives = [
    'Vender produto/serviço',
    'Gerar engajamento',
    'Captar leads',
    'Aumentar seguidores',
    'Educar o público',
    'Fortalecer marca',
    'Promover evento',
    'Lançar produto',
  ];

  // Platforms
  static const List<String> platforms = [
    'Instagram',
    'TikTok',
    'YouTube',
    'Facebook',
    'LinkedIn',
    'Site / Landing Page',
    'WhatsApp',
    'E-mail',
  ];

  // Voice tones
  static const List<String> voiceTones = [
    'Formal e Profissional',
    'Jovem e Descontraído',
    'Premium e Sofisticado',
    'Técnico e Especialista',
    'Empático e Acolhedor',
    'Motivacional e Inspirador',
    'Divertido e Humorístico',
    'Urgente e Persuasivo',
  ];
}
