# Guia Vim: Do JetBrains ao Neovim

> Para quem domina IntelliJ/GoLand e quer aprender o Vim Way de verdade.
> Este guia usa os keymaps da sua configuracao atual.

---

## Parte 1: A Filosofia do Vim

O Vim nao e uma IDE que voce usa com o mouse. E uma **linguagem de edicao**.
Voce compoe comandos como frases: **verbo + objeto**.

```
d  w       = delete word   (deletar palavra)
c  i  "    = change inside quotes (mudar dentro das aspas)
y  a  p    = yank a paragraph (copiar paragrafo inteiro)
```

Quando voce para de pensar "onde clico?" e passa a pensar
"o que quero fazer com esse texto?", o Vim comeca a fazer sentido.

A curva de aprendizado parece ingrata no inicio, mas o investimento
compensa: suas maos nunca saem do teclado, seus dedos nao viajam ate
o mouse, e voce edita mais rapido do que consegue imaginar.

---

## Parte 2: Os Modos

```
NORMAL   -> modo base, para navegar e editar com comandos
INSERT   -> digitar texto (como qualquer editor)
VISUAL   -> selecionar texto
VISUAL LINE (V) -> selecionar linhas inteiras
VISUAL BLOCK (Ctrl+v) -> selecionar colunas (multiline edit)
COMMAND  -> digitar comandos (:w, :q, :%s, etc.)
```

### Transicoes de modo

```
i       -> Normal para Insert (antes do cursor)
a       -> Normal para Insert (apos o cursor)
I       -> Normal para Insert (inicio da linha)
A       -> Normal para Insert (fim da linha)
o       -> Normal para Insert + nova linha abaixo
O       -> Normal para Insert + nova linha acima
s       -> deletar caracter e entrar em Insert
S       -> deletar linha e entrar em Insert
Esc     -> qualquer modo -> Normal
Ctrl+c  -> qualquer modo -> Normal (alternativa ao Esc)
v       -> Normal para Visual
V       -> Normal para Visual Line
Ctrl+v  -> Normal para Visual Block
:       -> Normal para Command
```

> REGRA DE OURO: Voce passa a maior parte do tempo em NORMAL.
> Entre no INSERT apenas para digitar, saia imediatamente depois.

---

## Parte 3: Movimentos (Motions)

Os movimentos sao o coração do Vim. Eles funcionam sozinhos (para navegar)
ou combinados com verbos (para operar).

### Basicos

```
h j k l     -> esquerda, baixo, cima, direita
              (substitui as setas - seus dedos ficam na home row)

w           -> proximo inicio de palavra
b           -> inicio de palavra anterior
e           -> fim da palavra atual/proxima
W B E       -> igual, mas ignorando pontuacao (palavra = ate espaco)

0           -> inicio da linha
^           -> primeiro caracter nao-branco da linha
$           -> fim da linha
gg          -> inicio do arquivo
G           -> fim do arquivo
50G         -> ir para linha 50
Ctrl+d      -> descer meia tela
Ctrl+u      -> subir meia tela
```

### Busca na linha (MUITO usado)

```
f{char}     -> pular para o proximo {char} na linha
F{char}     -> pular para o {char} anterior na linha
t{char}     -> pular ATE (antes de) o proximo {char}
T{char}     -> pular ATE (antes de) o {char} anterior
;           -> repetir o ultimo f/F/t/T (para frente)
,           -> repetir o ultimo f/F/t/T (para tras)
```

Exemplo pratico (cursor em `|`):
```
|fmt.Println("hello world")
fa          -> cursor vai para 'a' de Println
ta          -> cursor vai ATE o 'a' (uma posicao antes)
```

### Busca global

```
/{padrao}   -> buscar para frente
?{padrao}   -> buscar para tras
n           -> proxima ocorrencia
N           -> ocorrencia anterior
*           -> buscar palavra sob o cursor (para frente)
#           -> buscar palavra sob o cursor (para tras)
```

### Marcas (bookmarks)

```
m{a-z}      -> criar marca local com nome (ex: ma, mb)
'{a-z}      -> pular para a linha da marca
`{a-z}      -> pular para a posicao exata da marca
''          -> voltar para onde estava antes do ultimo salto
Ctrl+o      -> voltar na jump list
Ctrl+i      -> avancar na jump list
```

---

## Parte 4: Verbos (Operators)

Combinam com qualquer movimento ou text object.

```
d   -> delete (deletar = recortar)
c   -> change (deletar + entrar em Insert)
y   -> yank (copiar)
v   -> visual (selecionar)
=   -> formatar/indentar
>   -> indentar para direita
<   -> indentar para esquerda
~   -> alternar maiuscula/minuscula
gc  -> comentar (plugin Comment.nvim)
gsa -> adicionar surround (plugin mini.surround)
gsd -> remover surround
gsr -> substituir surround
```

### Formulas

```
verbo + movimento     = operar do cursor ate o movimento
verbo + verbo         = operar na linha inteira

dd  -> deletar linha inteira
cc  -> apagar linha + entrar em Insert
yy  -> copiar linha inteira
>>  -> indentar linha
==  -> auto-indentar linha
```

---

## Parte 5: Text Objects (O Segredo do Vim)

Text objects sao **o que diferencia o Vim de tudo**. Eles descrevem
regioes de texto baseadas em estrutura: "dentro das aspas",
"o paragrafo inteiro", "o argumento desta funcao".

### Sintaxe: `{verbo} {i|a} {objeto}`

- `i` = **inner** (dentro, sem os delimitadores)
- `a` = **around** (ao redor, inclui os delimitadores)

### Text Objects Nativos

```
iw / aw     -> palavra (inner/around)
is / as     -> sentenca
ip / ap     -> paragrafo
i" / a"     -> dentro/ao redor de aspas duplas
i' / a'     -> dentro/ao redor de aspas simples
i` / a`     -> dentro/ao redor de backticks
i( / a(     -> dentro/ao redor de ()  - tambem: ib/ab
i[ / a[     -> dentro/ao redor de []
i{ / a{     -> dentro/ao redor de {}  - tambem: iB/aB
i< / a<     -> dentro/ao redor de <>
it / at     -> dentro/ao redor de tags HTML/XML
```

### Text Objects do Treesitter (sua config)

```
if / af     -> funcao (inner/around)
ic / ac     -> struct/class (inner/around)
ia / aa     -> argumento/parametro (inner/around)
ib / ab     -> bloco (inner/around)
```

### Exemplos Reais em Go

```go
func ProcessUser(name string, age int) error {
    if age < 0 {
        return fmt.Errorf("invalid age: %d", age)
    }
    return nil
}
```

Com cursor em qualquer lugar dentro dos parenteses de `ProcessUser`:
```
dia     -> deleta o argumento atual (name string)
daa     -> deleta o argumento e a virgula (name string,)
cif     -> apaga o corpo da funcao e entra em Insert
yaf     -> copia a funcao INTEIRA
dib     -> apaga o conteudo do bloco if (o return)
ci"     -> apaga "invalid age: %d" e entra em Insert dentro das aspas
```

---

## Parte 6: Registros (Clipboard Multiplo)

O Vim tem 26 registros nomeados (a-z) alem de varios especiais.

```
"{reg}y     -> copiar para o registro
"{reg}p     -> colar do registro
"ayy        -> copiar linha para registro 'a'
"ap         -> colar do registro 'a'
"+y         -> copiar para clipboard do sistema
"+p         -> colar do clipboard do sistema (sua config ja tem isso automatico)
"0p         -> colar o que foi copiado por ultimo com y (nao afetado por d)
""p         -> registro sem nome (ultimo d/c/y)
```

> DICA: No seu config, `p` em visual mode cola sem sobrescrever o registro.
> Isso resolve o problema classico de "perder o que copiei ao deletar".

Ver registros: `:registers`

---

## Parte 7: Macros

Macros gravam e repetem sequencias de comandos. Sao poderosas para
transformacoes repetitivas em multiplas linhas.

```
q{a-z}      -> iniciar gravacao no registro {letra}
q           -> parar gravacao
@{a-z}      -> executar macro
@@          -> executar a ultima macro
10@a        -> executar macro 'a' 10 vezes
```

### Exemplo pratico

Voce tem 10 linhas assim e quer adicionar `:= nil` no fim de cada:
```
var name
var age
var email
```

1. Posicione na primeira linha
2. `qa` -> comecar gravacao no registro 'a'
3. `A := nil<Esc>j` -> adicionar no fim + descer linha
4. `q` -> parar gravacao
5. `9@a` -> executar 9 vezes nas linhas restantes

---

## Parte 8: Visual Block (Edicao Multiline)

Ctrl+v entra no Visual Block. E o "multiple cursors" do Vim.

```
Ctrl+v      -> entrar em Visual Block
j/k         -> expandir selecao
I           -> inserir no INICIO de cada linha selecionada
A           -> inserir no FIM de cada linha selecionada
d / x       -> deletar coluna selecionada
r{char}     -> substituir todos os chars por {char}
```

### Exemplo: adicionar // em varias linhas

```
Ctrl+v
jjj         -> selecionar 4 linhas na coluna 0
I           -> entrar em Insert no inicio
//          -> digitar //
Esc         -> aplicar em todas as linhas
```

### Exemplo: alinhar valores

```go
name  = "John"
age   = 30
email = "john@example.com"
```
Selecione a coluna dos "=" com Ctrl+v e manipule.

---

## Parte 9: Janelas, Buffers e Tabs

O Vim distingue os tres conceitos:
- **Buffer**: arquivo aberto na memoria (pode estar invisivel)
- **Window**: janela que exibe um buffer
- **Tab**: layout de janelas

### Buffers (sua config)

```
Shift+l     -> proximo buffer
Shift+h     -> buffer anterior
<leader>bd  -> fechar buffer atual
<leader>bo  -> fechar todos os outros buffers
<leader>bp  -> pin/unpin buffer
<leader>fb  -> listar e buscar buffers (Telescope)
```

### Splits (janelas)

```
<leader>sv  -> split vertical
<leader>sh  -> split horizontal
<leader>se  -> equalizar tamanhos
<leader>sx  -> fechar split atual
Ctrl+h/j/k/l -> navegar entre splits
Ctrl+setas  -> redimensionar splits
```

### Substituicao Global (:s e :%s)

```
:s/velho/novo/          -> substituir na linha atual (primeira ocorrencia)
:s/velho/novo/g         -> substituir na linha atual (todas)
:%s/velho/novo/g        -> substituir no arquivo inteiro
:%s/velho/novo/gc       -> substituir com confirmacao
:'<,'>s/velho/novo/g    -> substituir na selecao visual
```

Com regex:
```
:%s/\bfoo\b/bar/g       -> substituir palavra exata "foo"
:%s/func \(\w\+\)/func New\1/g  -> adicionar "New" antes de cada funcao
```

Para replace em multiplos arquivos: `<leader>sr` (nvim-spectre)

---

## Parte 10: Comandos Uteis do Dia a Dia

```
.           -> repetir ultimo comando de edicao (MUITO UTIL)
u           -> undo
Ctrl+r      -> redo
J           -> juntar linha abaixo com a atual
~           -> alternar maiuscula/minuscula do caracter
gU{motion}  -> maiuscula: gUiw = palavra em maiuscula
gu{motion}  -> minuscula: guiw = palavra em minuscula
x           -> deletar caracter sob cursor
r{char}     -> substituir caracter sob cursor por {char}
p           -> colar apos cursor
P           -> colar antes do cursor
Ctrl+a      -> incrementar numero sob cursor
Ctrl+x      -> decrementar numero sob cursor
```

---

## Parte 11: Seus Atalhos Customizados

### File Explorer (Neo-tree)
```
<leader>e   -> abrir/fechar explorer
<leader>o   -> focar no explorer
l / h       -> abrir / fechar no de pasta
H           -> mostrar/ocultar arquivos ocultos
```

### Telescope (Fuzzy Finder)
```
<leader>ff  -> buscar arquivos por nome
<leader>fg  -> grep em todo o projeto
<leader>fb  -> buffers abertos
<leader>fr  -> arquivos recentes
<leader>fs  -> simbolos LSP do arquivo atual
<leader>fw  -> simbolos LSP do workspace
<leader>fd  -> diagnosticos
<leader>fc  -> commits git
<leader>fk  -> atalhos configurados
<leader>f/  -> buscar no buffer atual
```
Dentro do Telescope: `Ctrl+j/k` navega, `Enter` abre, `Ctrl+q` manda para quickfix.

### LSP (Language Server)
```
gd          -> ir para definicao
gD          -> ir para declaracao
gr          -> ver todas as referencias
gi          -> ir para implementacao
gt          -> ir para definicao de tipo
K           -> documentacao inline (hover)
Ctrl+k      -> signature help (parametros da funcao)
<leader>rn  -> renomear simbolo (refactoring em todo o projeto)
<leader>ca  -> code actions (quick fixes, imports, etc.)
<leader>d   -> diagnostico flutuante na linha atual
[d / ]d     -> navegar entre diagnosticos
<leader>li  -> info do servidor LSP
<leader>uh  -> toggle inlay hints
```

### Debug (DAP)
```
F5          -> continuar (ou iniciar debug)
F10         -> step over (proximo passo, nao entra em funcao)
F11         -> step into (entra na funcao)
F12         -> step out (sair da funcao atual)
<leader>db  -> toggle breakpoint na linha atual
<leader>dB  -> breakpoint condicional
<leader>dt  -> debug test Go (o teste onde o cursor esta)
<leader>du  -> abrir/fechar painel do DAP UI
<leader>dx  -> terminar sessao de debug
<leader>dr  -> abrir REPL do debugger
```

### Go (go.nvim)
```
<leader>gor   -> GoRun (rodar main.go)
<leader>got   -> GoTest (testar pacote)
<leader>goT   -> GoTestFile (testar arquivo)
<leader>gof   -> GoTestFunc (testar funcao sob cursor)
<leader>goc   -> GoCoverage
<leader>goi   -> GoImports (organizar imports)
<leader>gos   -> GoFillStruct (preencher campos da struct)
<leader>goat  -> GoAddTag (adicionar JSON tags)
<leader>gort  -> GoRmTag (remover tags)
<leader>goe   -> snippet "if err != nil { return err }"
```

### Git
```
<leader>gg  -> LazyGit (interface visual completa)
]h / [h     -> proximo/anterior hunk
<leader>hp  -> preview do hunk
<leader>hs  -> stage hunk
<leader>hr  -> reset hunk
<leader>hb  -> blame da linha
<leader>tb  -> toggle blame inline
```

### Mover linhas (como Shift+Alt+Up/Down no IntelliJ)
```
Alt+j       -> mover linha/selecao para baixo
Alt+k       -> mover linha/selecao para cima
```

### Indentar no visual (sem perder selecao)
```
> e <       -> indentar/des-indentar mantendo selecao
```

### Diagnosticos (Trouble)
```
<leader>xx  -> todos os diagnosticos do workspace
<leader>xX  -> diagnosticos do buffer atual
<leader>xr  -> referencias LSP
<leader>xq  -> quickfix list
```

---

## Parte 12: Workflow Go no Neovim

### Fluxo tipico de desenvolvimento

1. Abrir projeto: `nvim .` (o explorer abre automaticamente se quiser)
2. Buscar arquivo: `<leader>ff`
3. Buscar funcao: `<leader>fs` (simbolos do arquivo)
4. Navegar entre arquivos: `Shift+l/h` (buffers)
5. Ver erros: `<leader>xx` (Trouble) ou `]d/[d`
6. Ir para definicao: `gd` / Voltar: `Ctrl+o`
7. Ver referencias: `gr` ou `<leader>xr`
8. Renomear: `<leader>rn`
9. Code actions: `<leader>ca` (import faltando, fix rapido)
10. Formatar: automatico ao salvar (gofumpt + goimports)

### Debug workflow

1. Colocar breakpoint: `<leader>db`
2. Iniciar debug: `F5` (escolher configuracao)
3. Navegar: `F10` (step over), `F11` (step into), `F12` (step out)
4. Inspecionar variaveis: no painel DAP UI (abre automatico)
5. Avaliar expressao: no painel REPL (`<leader>dr`)
6. Terminar: `<leader>dx`

### Snippets Go uteis no dia a dia

```
// if err != nil
<leader>goe    -> gera o bloco completo

// Preencher struct automaticamente
type Config struct {
    Host string
    Port int
}
c := Config{}   // cursor aqui
<leader>gos    -> preenche todos os campos

// Adicionar JSON tags
type User struct {
    Name  string    // cursor na struct
    Email string
}
<leader>goat   -> adiciona json:"name", json:"email"
```

---

## Parte 13: Transicao JetBrains -> Vim

| JetBrains                          | Vim / Neovim                    |
|------------------------------------|----------------------------------|
| Ctrl+P / Shift+Shift                | `<leader>ff` (Telescope)        |
| Ctrl+Shift+F (Find in files)        | `<leader>fg` (live grep)        |
| Ctrl+B / Ctrl+Click (definicao)     | `gd`                            |
| Alt+F7 (find usages)               | `gr` ou `<leader>xr`           |
| Shift+F6 (rename)                  | `<leader>rn`                   |
| Ctrl+Alt+L (formatar)              | Automatico ao salvar / `<leader>cf` |
| Ctrl+/ (comentar)                  | `gcc` (linha) / `gc` + motion  |
| Ctrl+D (duplicar linha)            | `yyp` (copiar + colar abaixo)  |
| Ctrl+Y (deletar linha)             | `dd`                           |
| Shift+Alt+Up/Down (mover linha)    | `Alt+j` / `Alt+k`             |
| Ctrl+W (fechar aba)                | `<leader>bd`                   |
| Alt+1 (explorador)                 | `<leader>e`                    |
| Ctrl+E (recentes)                  | `<leader>fr`                   |
| Alt+Enter (quick fix)              | `<leader>ca`                   |
| F2 (proximo erro)                  | `]d`                           |
| Ctrl+Shift+A (action)              | `:` + nome do comando          |
| Ctrl+G (ir para linha)             | `:{numero}` ou `{numero}G`    |
| Ctrl+F (buscar no arquivo)         | `/{padrao}`                    |
| Ctrl+R (replace no arquivo)        | `:%s/velho/novo/g`            |
| Ctrl+Shift+R (replace em arquivos) | `<leader>sr` (Spectre)        |
| F8 (step over)                     | `F10`                          |
| F7 (step into)                     | `F11`                          |
| Shift+F8 (step out)                | `F12`                          |
| F9 (continuar debug)               | `F5`                           |
| Ctrl+F8 (toggle breakpoint)        | `<leader>db`                   |
| Alt+F12 (terminal)                 | `:terminal` ou split + shell  |

---

## Parte 14: Exercicios Praticos

### Exercicio 1: Text Objects (15 minutos)
Crie um arquivo Go com uma struct e funcoes. Pratique:
- `cif` -> apagar corpo de funcao
- `ci"` -> mudar string
- `daa` -> deletar argumento
- `yaf` -> copiar funcao inteira
- `=if` -> re-indentar corpo da funcao

### Exercicio 2: Busca e Substituicao (10 minutos)
- `*` para buscar palavra sob cursor
- `n/N` para navegar
- `cgn` -> mudar proxima ocorrencia (pode repetir com `.`)
- `:%s/foo/bar/gc` -> replace com confirmacao

### Exercicio 3: Macros (10 minutos)
Crie 5 variaveis sem tipo e use macro para adicionar `: string` em cada uma.

### Exercicio 4: Visual Block (10 minutos)
- Crie 5 funcoes e comente todas de uma vez com Ctrl+v + I + //
- Selecione uma coluna de numeros e use `Ctrl+a` em cada um

### Exercicio 5: Navigation Flow (diario)
Por uma semana, NUNCA use o mouse no Neovim. Force-se a:
- Navegar com hjkl e motions
- Buscar com / e *
- Usar gd/gr/K em vez de passar o mouse sobre o codigo

---

## Regras de Ouro

1. **Se voce esta pressionando uma tecla mais de 3x seguidas, existe um jeito melhor.**
   Exemplo: kkkkk -> use `5k` ou `/funcao` para ir direto.

2. **Volte para NORMAL rapidamente.** Nao fique em INSERT navegando com setas.
   Termine de digitar, Esc, navegue, volte com i/a/o.

3. **Use `.` (ponto) constantemente.** Ele repete o ultimo comando de edicao.
   Mude uma coisa, vá para o proximo local com `n`, aplique com `.`.

4. **O movimento mais eficiente e o que leva voce ao lugar certo COM UMA COMBINACAO.**
   Prefira `f(` a `llll`. Prefira `ci"` a entrar no insert e selecionar manualmente.

5. **which-key e seu amigo.** Pressione `<Space>` e espere. Os grupos e atalhos
   aparecem. Voce nao precisa memorizar tudo de uma vez.

---

*"Vim is not an editor that does things, it's an editor that you compose things in."*
