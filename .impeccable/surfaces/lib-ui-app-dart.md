---
version: 1
slug: "lib-ui-app-dart"
primary_target: "lib/ui/app.dart"
related_targets: []
---

# Editor de nota (janela única)

Mode: Operate. A pessoa monta uma nota e a envia ao documento; sucesso é
montar e enviar sem pensar na sintaxe.

Audience/job: público geral escrevendo jianpu em outro programa.
Constraints: janela flutuante pequena que não rouba o foco; layout das
marcas definido pelo usuário (README); mundo visual fixado pelo
design_louvor v1.1.1.

## Direction contract

THESIS: a nota é uma folha de hinário com uma única nota impressa; as marcas
possíveis ficam impressas em linha fina, e as escolhidas em tinta cheia.
Recusa o "teclado de app" com botões coloridos e preenchimentos.

OWN-WORLD: design_louvor. Fundo `papel`, painéis em `folha` com linha de
1px (`linha`, `linha-forte` nos controles), raio 4px, tinta em três tons.
Marca apagada em `linha-forte`; acesa em `tinta`, ponto aceso com anel de
tinta (Outline Selection). Sem cor saturada, sem sombra. Noto Sans na
interface, Noto Sans Mono nos números, Noto Music nos símbolos.

STORY: a pessoa vê o número grande, clica nas marcas em volta, confere na
pauta embaixo o nome e a duração, e envia com Enter.

FIRST VIEWPORT: número grande em Noto Sans Mono numa folha central; marcas
em volta; botão de teclado numérico (só ícone) no canto superior esquerdo;
Enter primário (`acao`) no canto inferior direito do número; painel de
baixo em folha com Tom, pauta e leitura da nota.

FORM: aplicação direta do mundo fixado pelo usuário à composição que o
usuário especificou. seed: none (unavailable)

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
