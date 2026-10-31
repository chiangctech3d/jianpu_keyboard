# Teclado Jianpu

Escreva partituras em **jianpu** (a partitura de números, muito usada na Ásia)
sem precisar decorar nenhum código.

Você monta cada nota clicando nela como ela aparece no papel: pontinhos em
cima ou embaixo, linhas embaixo, sustenido ou bemol do lado. Depois aperta
**Escrever**, e a nota aparece no programa onde você está escrevendo (Word,
Google Docs, Bloco de Notas…).

Funciona no **Windows** e no **Mac**. É grátis.

## O que é jianpu?

No jianpu, cada nota é um número:

| Número | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 0 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Nota | Dó | Ré | Mi | Fá | Sol | Lá | Si | pausa |

Os sinais em volta do número mudam a nota:

- **Ponto em cima** → uma oitava mais aguda (dois pontos: duas oitavas).
- **Ponto embaixo** → uma oitava mais grave.
- **Linha embaixo** → a nota dura metade (colcheia). Duas linhas: um quarto
  (semicolcheia).
- **Ponto do lado** → a nota dura mais a metade dela.
- **Traço do lado** → a nota dura mais um tempo.
- **♯ ou ♭** antes do número → sustenido ou bemol.

## Como baixar

Vá em [**Releases**](../../releases/latest) e baixe o arquivo do seu sistema.

### Windows

1. Baixe `teclado-jianpu-windows.zip`.
2. Clique com o botão direito no arquivo → **Extrair tudo**.
3. Abra `jianpu_keyboard.exe`.

Se aparecer um aviso azul do Windows ("O Windows protegeu o computador"),
clique em **Mais informações → Executar assim mesmo**. O aviso aparece porque
o app é novo e ainda não é conhecido pela Microsoft.

### Mac

1. Baixe `teclado-jianpu-macos.dmg` e abra.
2. Arraste o **Teclado Jianpu** para a pasta **Aplicativos**.
3. Na primeira vez, o Mac vai bloquear. Vá em **Ajustes do Sistema →
   Privacidade e Segurança** e clique em **Abrir Mesmo Assim**.
4. Ainda em **Privacidade e Segurança → Acessibilidade**, ligue o
   **Teclado Jianpu**. É isso que deixa o app escrever no seu documento.

Sem a permissão de Acessibilidade o app ainda funciona: ele copia a nota e
você cola com **⌘V**.

## Como usar

1. Abra o documento onde vai escrever e clique nele (o cursor fica lá).
2. No Teclado Jianpu, clique no botão do canto de cima à esquerda para
   abrir o **teclado numérico** e escolha o número.
3. Clique nas marcas em volta do número. A marca escolhida fica escura;
   clicar nela de novo desmarca.
4. Confira embaixo: a nota aparece na pauta, com o nome dela e quanto tempo
   dura.
5. Clique em **Escrever**. A nota vai para o seu documento e o teclado fica
   limpo para a próxima.

A janela fica sempre por cima das outras e não tira o cursor do seu
documento, então você pode usar o teclado do computador e o Teclado Jianpu
ao mesmo tempo.

### Tom da música

Embaixo, em **Tom**, escolha quanto vale o "1" (por exemplo, *1 = G*).
O app passa a mostrar o nome certo de cada nota nesse tom.

## Para a partitura aparecer bonita no documento

O app escreve a nota como texto simples, por exemplo `#4'//`. Para ver isso
como partitura, instale a fonte gratuita
[**Jianpu ASCII**](https://github.com/RobertWinslow/jianpu-ascii-font) e use
essa fonte no texto.

No Word, desligue as **aspas inteligentes**
(Arquivo → Opções → Revisão de Texto → Opções de AutoCorreção → AutoFormatação
ao Digitar). Senão o `'` vira `’` e a fonte não reconhece.

<details>
<summary>Tabela do texto que o app escreve</summary>

| Na tela | Texto |
| --- | --- |
| ♯ / ♭ | `#` / `b` antes do número |
| 1 / 2 pontos em cima | `'` / `''` |
| 1 / 2 pontos embaixo | `,` / `,,` |
| 1 / 2 linhas embaixo | `/` / `//` |
| ponto do lado | `.` |
| traço do lado | ` -` |

Exemplos: `#4'//` (Fá sustenido agudo, semicolcheia), `b7,.` (Si bemol grave,
pontuado), `5 -` (Sol com dois tempos).

</details>

## Ainda não faz

- A **ligadura** aparece na tela, mas ainda não vai para o texto.
- Não coloca **espaço** entre as notas sozinho. Use a barra de espaço do
  seu teclado quando precisar.
- **Windows:** programas abertos como administrador não aceitam a
  digitação de outros programas.

Encontrou um problema ou tem uma ideia? Abra uma
[issue](../../issues).

## Privacidade

O app não coleta nem envia nenhum dado. Não usa internet.

---

## Para desenvolvedores

Feito em Flutter. Requisitos: Flutter (canal stable); no Windows, Visual
Studio 2022 com **Desenvolvimento para desktop com C++**; no Mac, Xcode.

```bash
flutter pub get
flutter test
flutter run -d windows   # ou -d macos
```

- Regras dos cliques: `lib/model/note.dart`
- Texto gerado: `lib/model/encoding.dart`
- Nome da nota, tom e duração: `lib/model/pitch.dart`
- Tela: `lib/ui/`

Para publicar uma versão: `git tag v0.2.0 && git push origin v0.2.0`. O
GitHub Actions gera o `.zip` e o `.dmg` em **Releases**.

O visual segue o [design_louvor](https://github.com/chiangctech3d/design_louvor)
(veja [DESIGN.md](DESIGN.md)). A janela que não rouba o foco vem do
[Teclado Taiwanês](https://github.com/chiangctech3d/taiwanese_keyboard).

## Licença

Código: GPL-3.0 ([LICENSE](LICENSE)). Fontes Noto embutidas: SIL Open Font
License ([assets/fonts/OFL.txt](assets/fonts/OFL.txt)).
