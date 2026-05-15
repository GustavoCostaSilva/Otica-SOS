# Ótica SOS - App de Vitrine

App em Flutter para exibir ofertas, clima local e elogios na TV da loja, junto com um painel de administração básico.

## Setup Inicial

O banco de dados (Supabase) não tá versionado no git por segurança. Antes de rodar, você precisa do arquivo `.env` com as chaves.

1. Pega o arquivo `.env` que te enviei ou cria um na pasta raiz do projeto.
2. O formato dele tá no `.env.example`:
```
SUPABASE_URL=...
SUPABASE_ANON_KEY=...
```

Depois disso é só instalar os pacotes e rodar normal:
```bash
flutter pub get
flutter run -d chrome
```

## Painel Admin

Pra acessar a administração:
- Vai na rota `/admin` (ex: `localhost:5555/#/admin`)
- Ou dá 2 cliques na logo "ÓTICA SOS" no canto superior esquerdo da vitrine principal.

As credenciais do painel eu te passei junto com o arquivo .env.

---
Stack: Flutter, Riverpod, GoRouter, Supabase.
