# Ótica SOS — Vitrine Digital & Painel Admin

Sistema de vitrine digital interativa para TVs e painel administrativo desenvolvido em Flutter. Conta com atualizações em tempo real (Supabase), previsão do tempo local e feed de notícias dinâmico (G1 Ceará).

## 🚀 Como Executar o Projeto

Este projeto utiliza variáveis de ambiente para proteger as credenciais do banco de dados (Supabase). **Você precisa do arquivo `.env` para rodar a aplicação.**

### 1. Configuração do Ambiente (.env)
1. Solicite o arquivo `.env` ao desenvolvedor ou crie um arquivo chamado `.env` na raiz do projeto.
2. O arquivo deve seguir o formato documentado em `.env.example`:
```env
SUPABASE_URL=https://[SEU_PROJETO].supabase.co
SUPABASE_ANON_KEY=[SUA_CHAVE_ANONIMA]
```

### 2. Rodando a Aplicação
Com o `.env` posicionado na raiz do projeto, instale as dependências e rode a aplicação (recomendado rodar no Chrome para visualização da TV):

```bash
flutter pub get
flutter run -d chrome
```

## ⚙️ Acesso ao Painel Admin
A rota do painel administrativo é `/admin`. 
Na tela inicial da vitrine, dê um duplo clique no texto "ÓTICA SOS" no topo esquerdo, ou acesse diretamente na URL (ex: `localhost:5555/#/admin`).

*Credenciais de acesso devem ser solicitadas ao administrador do sistema.*

## 🛠 Tecnologias Utilizadas
- **Flutter / Dart** (Interface UI / UX responsiva)
- **Supabase** (Backend as a Service, Realtime DB, Auth)
- **Riverpod** (Gerenciamento de Estado)
- **GoRouter** (Roteamento de Telas)
- **Open-Meteo API** (Clima) & **RSS2JSON API** (Notícias)
