# MY3E Firefox Theme

Tema **Material 3 Expressive** para o Firefox: página inicial, nova aba e interface do navegador, com formas que se transformam, movimento com mola e linhas onduladas e em zigzag. A paleta é gerada a partir da **cor de destaque do Windows**, nos modos claro e escuro.

<img width="1919" height="912" alt="image" src="https://github.com/user-attachments/assets/27fb5ac0-b230-489b-adc0-56ccd2f472b2" />

**Página inicial:** https://vitzzalt.github.io/MY3EFirefoxTheme/

## O que tem aqui

| Arquivo | Para quê |
| --- | --- |
| `index.html` | Página inicial e de nova aba (busca, atalhos, saudação por horário) |
| `userChrome.css` | Visual da interface do Firefox (abas, barra de endereço, botões, favoritos, menus) |
| `fonts/SymbolsNerdFont-Regular.ttf` | Fonte de ícones da [Nerd Fonts](https://www.nerdfonts.com/) usada nos atalhos |
| `via/` | Versão para o Via Browser (Android): `homepage.css` e `logo-snippet.html` |

## Instalação no Firefox

### 1. Página inicial

1. Abra `about:preferences#home`.
2. Em **Página inicial e novas janelas**, escolha **URLs personalizadas** e use o endereço da página acima (ou o de uma cópia sua, veja "Fazer a sua própria cópia").

### 2. Nova aba

O Firefox não deixa trocar a nova aba sem extensão.

1. Instale a extensão **New Tab Override**.
2. Nas opções, escolha **URL personalizada** e cole o mesmo endereço.

O aviso da extensão diz que arquivos locais (`file://`) não funcionam como URL. Por isso a página é hospedada no GitHub Pages.

### 3. Interface (userChrome.css)

1. Em `about:config`, ative `toolkit.legacyUserProfileCustomizations.stylesheets`.
2. Em `about:support`, clique em **Abrir pasta** ao lado de "Pasta do perfil".
3. Crie uma pasta chamada `chrome` (minúscula) e coloque o `userChrome.css` dentro.
4. Feche o Firefox por completo e abra de novo.

No Windows, confira se o arquivo não ficou como `userChrome.css.txt`.

## Fazer a sua própria cópia

1. Faça um fork deste repositório (ou crie um novo e envie os arquivos).
2. Em **Settings → Pages**, escolha **Deploy from a branch**, branch `main` e pasta `/ (root)`.
3. Use o endereço que o GitHub mostrar (`https://SEU-USUARIO.github.io/NOME-DO-REPO/`) na página inicial e na extensão.

O conteúdo fica público, então não coloque nada pessoal nos atalhos.

## Personalização

### Buscadores e atalhos

No `index.html`, edite o trecho marcado com `EDITE AQUI`:

- `ENGINES`: lista de buscadores. O primeiro é o padrão (hoje, Brave Search).
- `FAVS`: atalhos no formato `[nome, endereço, ícone]`. O ícone é opcional.

### Ícones dos atalhos

Os ícones usam códigos da fonte Nerd Fonts, no formato `\uXXXX`. Procure o código no [cheat sheet](https://www.nerdfonts.com/cheat-sheet). Se a fonte não carregar, o atalho mostra a primeira letra do nome.

### Cores

- **Automáticas:** a cor de destaque do Windows (Configurações → Personalização → Cores) vira a base da paleta. Se o navegador não entender a cor do sistema, usa uma paleta roxa padrão.
- **Manuais:** as cores ficam nas variáveis no início do `index.html` e do `userChrome.css`.

### Remover partes

Cada bloco do `userChrome.css` tem um comentário numerado. Apague o bloco para desligar aquela parte (por exemplo, a onda na aba selecionada ou o zigzag sob a barra).

## Via Browser (Android)

A pasta `via/` tem uma versão para o Via, com paleta fixa (sem cor dinâmica):

1. Em **Custom CSS** nas configurações do Via, cole o conteúdo de `via/homepage.css`.
2. No campo do **logo** da homepage, cole o conteúdo de `via/logo-snippet.html`.

O Via refaz a homepage sozinho quando você adiciona favoritos, e só os campos de configuração são mantidos. Por isso o tema fica nesses dois campos, e não no arquivo HTML.

## Observações

- A interface do Firefox muda entre versões, então alguns seletores do `userChrome.css` podem precisar de ajuste.
- O endereço da página inicial é escondido na barra enquanto a aba ativa se chamar "Início" (e você não estiver digitando). Isso é feito pelo CSS, não pela extensão.
- Para desfazer tudo, apague o `userChrome.css` e reinicie o Firefox.

## Créditos

- Design baseado no [Material 3 Expressive](https://m3.material.io/blog/building-with-m3-expressive), do Google.
- Ícones: [Nerd Fonts](https://www.nerdfonts.com/) (a fonte tem as suas próprias licenças, veja o repositório do projeto).
