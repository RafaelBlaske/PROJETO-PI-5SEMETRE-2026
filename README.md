# 🚀 AGIX Creator AI
Projeto Integrador — 5º Semestre
Aplicativo mobile com Inteligência Artificial para geração de conteúdo criativo voltado para agências de marketing e publicidade.

## 📌 Sobre o Projeto
O AGIX Creator AI é um aplicativo mobile desenvolvido para auxiliar equipes criativas no processo de produção de conteúdo digital. A aplicação utiliza Inteligência Artificial para gerar:

💡 Ideias de posts para redes sociais
🎬 Roteiros para Reels e vídeos curtos
✍️ Copies persuasivas
📅 Calendário de conteúdo (30 dias)
🏷️ Nomes de marca e slogans
📄 Propostas comerciais
📚 Histórico organizado de conteúdos gerados


## ⚠️ Problema
Agências de marketing frequentemente enfrentam dificuldades no processo criativo, como:

⏱️ Demora para gerar ideias criativas
🔁 Retrabalho na criação de conteúdos
🧩 Falta de padronização nas estratégias
🗂️ Ausência de uma ferramenta centralizada


## 🎯 Público-Alvo

📱 Social Media
✍️ Copywriters
🎨 Designers
📊 Gestores de projetos criativos
🏢 Equipes internas de agências de marketing


## 🛠️ Tecnologias Utilizadas
CamadaTecnologiaMobileFlutter 3.x / DartBackendNode.js + ExpressIAGroq API (LLaMA 3)Banco de DadosSQLite (via sql.js)

## ⚙️ Funcionalidades do MVP

👤 Cadastro e login de usuários
💡 Geração de ideias de conteúdo com IA
🎬 Criação de roteiros para vídeos curtos
✍️ Geração de copy publicitária
📅 Calendário de conteúdo de 30 dias
📚 Histórico de conteúdos gerados com busca e favoritos
🧑‍💼 Painel administrativo para gerenciamento de usuários
✏️ Edição inline do conteúdo gerado
📋 Copiar e compartilhar com um toque


## 🚀 Como Executar
Pré-requisitos

Flutter SDK instalado
Node.js 18+ instalado


Backend
bashcd agix_backend
npm install
node index.js
PORT=3000

## ⚠️ Nunca commite o arquivo .env no repositório. Ele já está no .gitignore.

bashnode index.js
App Flutter
bashcd agix_creator_ai
flutter pub get
flutter run
Build para Android
bashflutter build apk --debug    # Para testes
flutter build apk --release  # Para distribuição

## 📂 Estrutura do Projeto
projeto-PI-5-semestre/
├── agix_backend/
│   ├── index.js          # Servidor Express + rotas da API
│   ├── db.js             # Configuração do banco SQLite
│   ├── database.sql      # Schema inicial do banco
│   ├── .env.example      # Modelo de variáveis de ambiente
│   └── package.json
├── agix_creator_ai/
│   ├── lib/              # Código Flutter
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
└── README.md

# 👥 Equipe
Guilherme Moltine Canhedo Soares
Rafael Alves Blaske
Caue Barroca Blenblen
Igor Roggati de Paiva
Fabio Henrique Bragagnolo

📚 Contexto Acadêmico
Projeto desenvolvido como parte do Projeto Integrador do 5º Semestre, com foco na aplicação prática de tecnologias modernas no desenvolvimento de soluções digitais para o mercado de marketing e publicidade.
