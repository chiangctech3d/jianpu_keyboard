# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

Desktop: Windows e macOS (Flutter). Uma só linguagem visual nos dois
sistemas, a do design_louvor; não segue o visual nativo de cada SO.

## Users

- Público geral (distribuição aberta e gratuita no GitHub), incluindo
  músicos de igreja do projeto louvor.
- Situação comum: estão escrevendo uma partitura em jianpu em outro
  programa e precisam montar cada nota com pontos de oitava, linhas de
  duração, ponto/traço e acidentes sem decorar a sintaxe de texto.

## Product Purpose

Janela flutuante que monta uma nota de jianpu de forma visual (o número no
centro, as marcas em volta) e, no Enter, digita a nota no programa em uso
no formato de texto da fonte Jianpu ASCII.

Sucesso = escrever uma partitura em jianpu nota a nota, sem tirar o cursor
do documento e sem precisar saber a sintaxe `#4'//`.

## Positioning

A nota é montada como ela aparece no papel (pontos em cima e embaixo,
linhas embaixo, acidente ao lado) e sai como texto puro, então funciona em
qualquer programa: Word/Docs com a fonte instalada, arquivos do louvor ou
um editor de texto simples.

## Operating Context

- Janela pequena, sempre por cima, ao lado do documento; não rouba o foco.
- Uso alternado: mouse no editor de nota, teclado físico no documento.
- Windows: digitação via SendInput. macOS: via CGEvent, requer permissão de
  Acessibilidade; sem ela, a nota é copiada e o usuário cola com ⌘V.
- Destinos: documentos com a fonte Jianpu ASCII, arquivos do projeto louvor
  e editores de texto simples.

## Capabilities and Constraints

- Regras de clique definidas pelo usuário (README, `lib/model/note.dart`):
  pontos de oitava 1/2 em cima e embaixo, linhas 1/2, ponto ou traço à
  direita, ♯ ou ♭ à esquerda, ligadura, Enter.
- Tom selecionável; mostra a nota na pauta, o nome, a figura e os tempos.
- Teclado numérico (1–7, 0 = pausa) abre à esquerda e recolhe.
- Em aberto: como escrever a ligadura no texto; se o ponto deve apagar as
  linhas (impede colcheia pontuada); espaço automático entre notas.
- Interface em português (Brasil).

## Brand Commitments

- Nome: "Teclado Jianpu". Repositório: `jianpu_keyboard`.
- Segue o design_louvor (chiangctech3d/design_louvor), por pedido do
  usuário. Tokens espelhados em Dart, sem redefinir tokens universais.
- Fontes Noto Sans, Noto Music e Noto Sans Mono embutidas no app (OFL).

## Evidence on Hand

- Sintaxe da fonte Jianpu ASCII (github.com/RobertWinslow/jianpu-ascii-font).
- Não há logotipo, ícone próprio, depoimentos nem usuários registrados;
  não inventar.

## Product Principles

1. O foco é do documento do usuário: a janela nunca o rouba.
2. A nota se monta como se lê no papel.
3. Cada marca acesa precisa ser legível de relance; o apagado não compete.
4. Ocupar pouco espaço na tela.
5. O texto gerado é o da fonte Jianpu ASCII, sem dialeto próprio.

## Accessibility & Inclusion

Contraste AA nos dois temas (regra do design_louvor). Estado aceso nunca
só por cor: o ponto aceso ganha anel, a linha/traço aceso fica mais escuro
e mais grosso, o acidente aceso vai para o meio.
