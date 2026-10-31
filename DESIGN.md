# Design do Teclado Jianpu

O app segue o **design_louvor v1.1.1** (github.com/chiangctech3d/design_louvor):
papel de hinário, lombada azul-noite, linhas finas, sem sombra nem cor
decorativa. Os tokens estão espelhados em Dart em `lib/ui/louvor.dart`, nos
temas claro e escuro, sem redefinir nenhum token universal. Mudança de token
vai para o repo design_louvor, não para cá.

## Tradução para o Flutter

| design_louvor | Aqui |
| --- | --- |
| `tokens.css` | `Louvor.claro` / `Louvor.escuro` (ThemeExtension) |
| `--f-ui`, `--f-mono`, Noto Music | `ui()`, `mono()`, `musica()`; fontes em `assets/fonts` (OFL) |
| `.btn`, `.btn.pri`, `aria-pressed` | `LvButton` (`primario`, `pressionado`) |
| `.ico` (traço 1,75, grade 24) | `LvIcon` desenhado em `CustomPainter` |
| `select.sel` + `.rot` | seletor de tom no painel de baixo |
| `.tag-tipo` | texto Jianpu ASCII da nota |
| `.aviso` | SnackBar plano em folha com linha forte |
| `--ease` | `louvorEase` |

## Do app

- **Tamanhos de leitura** (exceção do design_louvor para conteúdo musical):
  `jpNota` 64px para o número, `jpAcidente` 30px para ♯ e ♭. O resto usa a
  escala única 12/14/16/20/28.
- **Marcas da nota:** apagada em `--linha-forte`, `--tinta-3` sob o mouse,
  acesa em `--tinta`. Acesa nunca só por cor: o ponto ganha anel de tinta,
  linha/traço/ligadura engrossam, ♯/♭ e ponto/traço vão para o meio.
- **Teclado numérico:** o número escolhido fica pressionado (tinta).
- **Superfícies:** área da nota em `--papel`; teclado numérico e painel de
  baixo em `--folha`, separados por linha de 1px.
- **Movimento:** só o deslocamento de ♯/♭ e ponto/traço para o meio, 200ms
  em `--ease`; desligado com animações reduzidas do sistema.
