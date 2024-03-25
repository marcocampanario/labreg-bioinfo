# Tmux cheatsheet

    Por Tiago Minuzzi

## Observações

- Comandos iniciando com `tmux` são feitos fora da sessão.

- O comando `ctrl+b` é o modificador principal de dentro de uma sessão.

- Quando se tem o `+` significa que se deve manter pressionada a primeira e apertar a outra, como no caso do modificador principal.

- Um comando como, por exemplo, `ctrl+b`, `D`, significa =  manter pressionado `ctrl` e pressionar `b`, soltar ambos, e em seguida, pressionar `D`.

- `ctrl+b`, `:` abre a linha de comando do `tmux` dentro da sessão.

- Atenção à capitalização (maiúsculas/minúsculas) das letras.

## Comandos

### Básico de manejo de sessão

- `tmux -s meuExemplo` =  criar sessão com nome.

- `tmux -s meuExemplo -n janela` =  criar sessão com nome e com nome para janela.    

- `ctrl+b` , `w` =  visualizar janelas abertas enquanto dentro da sessão do tmux.

- `ctrl+b`, `D` =  sair da sessão sem fechá-la (deattach).

- `tmux ls` =  listar sessões.

- `tmux a` =  retornar à sessão.

- `tmux a -t meuExemplo` =  retornar a sessão usando nome da sessão (caso não haja nome, o número).

- `ctrl+b`, `c` =  abrir uma nova janela dentro da mesma sessão.

- `ctrl+b`, `0..9` =  seleciona a janela da sessão atual de acordo com o número.

- `ctrl+b`, `:`, `rename-session novoNome` =  renomeia a sessão atual com o nome `novoNome`.

- `ctrl+b`, `:`, `rename-window janelaNovoNome` =  renomeia a janela atual com o nome `janelaNovoNome`.

- `ctrl+b`, `?` =  mostra os comandos disponíveis no tmux.

### Movimentação e relacionados

- `ctrl+b`, `[` =  Entrar no modo "cópia" (comportamento como do mouse) com o teclado.

- Movimentando-se no modo "cópia"
  
  - `seta esquerda` =  movimento para a esquerda.
  
  - `seta direita` =  movimento para a direita.
  
  - `seta baixo` =  movimento para a baixo.
  
  - `seta cima` =  movimento para cima.
  
- `Esc` =  sair do modo "cópia".

- Selecionar texto para copiar enquanto no modo "cópia".
  
  - ir até o início da palavra/linha desejada e pressionar `ctrl+space`;
  
  - usando as setas, ir até a posição final e pressionar `alt+w` (sai do modo "cópia" com o conteúdo copiado).

- `ctrl+b`, `]` =  colar texto selecionado.

- `ctrl+b`, `:`, `setw -g mode-keys vi` =  usa vim keys no modo cópia.

	- no modo vim, seleciona-se o texto apenas com `space` e confirma seleção com `enter`.
### Criando e administrando _panes_ (_splits_ na mesma tela)

- `ctrl+b`, `%` =  cria uma janela à direita da atual dividindo a tela.

- `ctrl+b`, `"` =  cria uma janela abaixo da atual dividindo a tela.
  
- `ctrl+b`, `o` =  mover-se para _pane_ seguinte.

- `ctrl+b`, `x` ou `ctrl+d` =  "matar" o _pane_ atual.

- `ctrl+b`, `crtl+o` =  fazer a troca de posição entre o _pane_ atual e o anteriormente selecionado.

- `ctrl+b+seta` =  redimensiona o _pane_ atual na direção da seta pressionada.

- `ctrl+b`, `space` =  rotaciona os layouts disponíveis.

- `ctrl+b`, `z` =  alterna zoom no _pane_ atual.

- `ctrl+b`, `q` =  mostra o número de cada _pane_.

- `ctrl+b`, `q`, `0..9` =  seleciona o _pane_ de acordo com o número.

- `ctrl+b`, `!` =  transforma o _pane_ em janela.

- `ctrl+b`, `:`, `setw synchronize-panes (on/off)` = liga ou desliga a sincronia de escrita entre _panes_, i.e., escrever a mesma linha de comando em todos os _panes_ abertos.
