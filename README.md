# Teclado Jianpu

Janela flutuante para escrever partituras em **jianpu** (notação numérica).
Você monta a nota clicando nas marcas em volta do número e, no **Enter**, ela
é **digitada no programa que você estava usando**, no formato de texto da
fonte [Jianpu ASCII](https://github.com/RobertWinslow/jianpu-ascii-font).
A janela fica sempre por cima e não rouba o foco.

## Como usar

No centro fica a caixa do número; em volta, o que dá para colocar nele.
O que está aceso fica na cor verde; o resto, esmaecido.

| Onde | O quê | Regra |
| --- | --- | --- |
| Canto superior esquerdo | Teclado numérico | Abre à esquerda (1–7, 0 = pausa, apagar). Clicar de novo recolhe. Clicar na caixa vazia também abre. |
| Em cima | Pontos de oitava acima | O de perto acende um ponto; o de fora acende os dois. Com os dois acesos, o de perto deixa só ele. Clicar no que está aceso apaga. Acender aqui apaga os de baixo. |
| Embaixo | Duas linhas | A de cima acende uma (colcheia); a de baixo acende as duas (semicolcheia). Mesma regra de apagar. |
| Embaixo das linhas | Pontos de oitava abaixo | Iguais aos de cima, espelhados. Acender aqui apaga os de cima. |
| Direita | Traço (em cima) ou ponto (embaixo) | Um ou outro; o escolhido vai para a altura do meio do número. O ponto apaga as duas linhas. Clicar de novo apaga. |
| Esquerda | ♯ ou ♭ | Um ou outro; o escolhido vai para o meio. Clicar de novo apaga. |
| Canto superior direito do número | Ligadura | Um quarto de arco: firme perto do número, pontilhado na ponta. |
| Canto inferior direito do número | Enter | Digita a nota e limpa tudo. |
| Embaixo, à esquerda | Tom e pauta | Escolha o tom (1 = C, 1 = G…) e veja a nota na pauta, o nome (F♯4 · Fá♯), a figura e quantos tempos. |

### O que é digitado

`acidente + número + oitava + linhas + ponto/traço`

| Marca | Texto |
| --- | --- |
| ♯ / ♭ | `#` / `b` antes do número |
| 1 / 2 pontos em cima | `'` / `''` |
| 1 / 2 pontos embaixo | `,` / `,,` |
| 1 / 2 linhas | `/` / `//` |
| ponto | `.` |
| traço | ` -` |

Exemplos: `#4'//`, `b7,.`, `5 -`. Com a fonte Jianpu ASCII instalada no
editor (ligaduras ligadas e aspas inteligentes desligadas no Word), o texto
aparece como partitura.

**Ainda não sai no texto:** a ligadura (na fonte ela fica numa linha à parte,
acima das notas).

## Baixar

Na página **Releases** do repositório:

- **Windows:** `teclado-jianpu-windows.zip` → descompacte e abra
  `jianpu_keyboard.exe`.
- **Mac:** `teclado-jianpu-macos.dmg` → arraste para *Aplicativos*. O app não
  é assinado pela Apple: na primeira vez, vá em **Ajustes do Sistema →
  Privacidade e Segurança → Abrir Mesmo Assim**. Depois permita em
  **Privacidade e Segurança → Acessibilidade**. Sem essa permissão a nota é
  copiada e você cola com ⌘V.

## Desenvolver

Requisitos: Flutter (canal stable). Windows: Visual Studio 2022 com
**Desenvolvimento para desktop com C++**. Mac: Xcode.

```bash
flutter pub get
flutter test
flutter run -d windows   # ou -d macos
```

- Regras dos cliques: `lib/model/note.dart`
- Texto gerado: `lib/model/encoding.dart`
- Nome da nota, tom e duração: `lib/model/pitch.dart`
- Tela: `lib/ui/`

A digitação no programa em uso e a janela que não rouba o foco vêm do
[Teclado Taiwanês](https://github.com/chiangctech3d/taiwanese_keyboard).

## Design

Segue o [design_louvor](https://github.com/chiangctech3d/design_louvor);
veja [DESIGN.md](DESIGN.md). As fontes Noto Sans, Noto Sans Mono e Noto
Music vêm embutidas em `assets/fonts` (licença OFL).

## Licença

GPL-3.0. Veja [LICENSE](LICENSE).
