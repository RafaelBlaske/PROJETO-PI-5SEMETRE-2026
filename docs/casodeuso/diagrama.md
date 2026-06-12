# AGIX Creator AI - Casos de Uso

## 1. Visão Geral

O AGIX Creator AI é um aplicativo mobile que utiliza Inteligência Artificial para auxiliar equipes de marketing na criação de conteúdos criativos, como ideias de posts, roteiros para vídeos e copys publicitárias.

O sistema tem como objetivo aumentar a produtividade das equipes e reduzir o tempo gasto no processo criativo.

---

# 2. Atores do Sistema

## Usuário da Agência
Profissionais que utilizam o sistema para gerar conteúdos criativos.

Inclui:
- Social Media
- Redator
- Designer
- Gestor de Projetos

## Administrador
Responsável pela gestão do sistema e controle de usuários.

---

# 3. Casos de Uso

## UC01 - Criar Conta

**Ator:** Usuário  
**Descrição:** Permite que um novo usuário crie uma conta no aplicativo.

**Fluxo Principal**
1. Usuário acessa o aplicativo
2. Seleciona "Criar conta"
3. Informa nome, email e senha
4. Sistema valida os dados
5. Conta é criada
<img width="611" height="72" alt="image" src="https://github.com/user-attachments/assets/f47615e6-6e05-4c15-a88c-4e3d8329980a" />


---

## UC02 - Realizar Login

**Ator:** Usuário  
**Descrição:** Permite acesso ao sistema.

**Fluxo Principal**
1. Usuário abre o aplicativo
2. Insere email e senha
3. Sistema valida credenciais
4. Usuário é direcionado ao painel principal
<img width="993" height="109" alt="image" src="https://github.com/user-attachments/assets/8912088e-fe04-4413-a5e8-4fa3332810d2" />

---

## UC03 - Gerar Ideia de Conteúdo

**Ator:** Usuário  
**Descrição:** O usuário solicita ideias de conteúdo para redes sociais.

**Fluxo Principal**
1. Usuário seleciona "Gerar Ideia"
2. Informa tema ou nicho
3. Sistema envia solicitação para API de IA
4. IA gera sugestões de conteúdo
5. Sistema exibe as ideias
<img width="1250" height="111" alt="image" src="https://github.com/user-attachments/assets/59788b09-43dd-46d8-b42a-7a9d62a61ab9" />

---

## UC04 - Gerar Roteiro de Vídeo

**Ator:** Usuário  
**Descrição:** Permite criar roteiros para vídeos curtos.

**Fluxo Principal**
1. Usuário seleciona "Criar Roteiro"
2. Informa tema e objetivo
3. Sistema envia para a IA
4. IA gera roteiro
5. Sistema exibe roteiro
<img width="1182" height="111" alt="image" src="https://github.com/user-attachments/assets/38def327-de23-4493-a8a6-d325c61af132" />

---

## UC05 - Gerar Copy Publicitária

**Ator:** Usuário  
**Descrição:** Permite criar textos persuasivos para marketing.

**Fluxo Principal**
1. Usuário seleciona "Criar Copy"
2. Informa produto ou serviço
3. Sistema envia solicitação para IA
4. IA gera copy publicitária
5. Sistema exibe resultado
<img width="1258" height="113" alt="image" src="https://github.com/user-attachments/assets/8b33be98-fd96-4aba-9fca-f1644d8aa7af" />

---

## UC06 - Salvar Conteúdo Gerado

**Ator:** Usuário  
**Descrição:** Permite armazenar conteúdos gerados no histórico.

**Fluxo Principal**
1. Usuário visualiza conteúdo gerado
2. Seleciona "Salvar"
3. Sistema registra no banco de dados
4. Conteúdo fica disponível no histórico
<img width="1324" height="115" alt="image" src="https://github.com/user-attachments/assets/e6fb8331-7976-4f48-9d65-0ffe4598d514" />

---

## UC07 - Visualizar Histórico de Conteúdos

**Ator:** Usuário  
**Descrição:** Permite visualizar conteúdos gerados anteriormente.

**Fluxo Principal**
1. Usuário acessa "Histórico"
2. Sistema consulta banco de dados
3. Sistema exibe lista de conteúdos
<img width="997" height="111" alt="image" src="https://github.com/user-attachments/assets/b68c56ff-d3cd-48e1-b35a-53d772b58b73" />

---

## UC08 - Gerenciar Usuários

**Ator:** Administrador  
**Descrição:** Permite administrar usuários do sistema.

**Fluxo Principal**
1. Administrador acessa painel administrativo
2. Visualiza lista de usuários
3. Pode editar ou remover usuários
<img width="1111" height="170" alt="image" src="https://github.com/user-attachments/assets/b6bc1bf4-56f7-426e-8ee6-31b4fdc6c45f" />




---





Diagrama de Classes

<img width="509" height="712" alt="image" src="https://github.com/user-attachments/assets/c0577bba-bd02-43a0-8021-ec1d59cecad5" />





---




Diagrama de sequências

<img width="924" height="2728" alt="image" src="https://github.com/user-attachments/assets/52e34604-da64-47a6-8588-d17161da1d26" />





---




Diagrama de atividades

<img width="943" height="2011" alt="image" src="https://github.com/user-attachments/assets/42fd95d2-b2eb-4a56-bd09-6a99c82acb24" />






---




Diagrama de casos

<img width="613" height="872" alt="image" src="https://github.com/user-attachments/assets/b2c8be00-4ff2-4ef5-80f9-b410d9581a10" />





---





