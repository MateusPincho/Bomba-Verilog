# Jogo Digital - Desarmando Bombas 💣
Jogo digital na linguagem de descrição de hardware Verilog em que o objetivo é desativar uma bomba relógio inserindo corretamente a senha de desarme
<p align="center">
<img src="https://github.com/MateusPincho/Bomba-Verilog/blob/main/fotos-e-videos/ligada.jpeg?raw=true" height="400" align="center">
</p>

## Sobre o Projeto 📖
Inspirado pelo jogo [*Keep Talking and Nobody Explodes*](https://keeptalkinggame.com/), o objetivo do usuário é desativar uma bomba-relógio ao inserir corretamente a senha que irá desarmá-la. Esta senha é formada por uma palavra binária de quatro letras **(ABCD)** e deve ser definida previamente dentro do ambiente de desenvolvimento [*Quartus II*](https://www.intel.com/content/www/us/en/software-kit/666221/intel-quartus-ii-web-edition-design-software-version-13-1-for-windows.html)

Cada letra possui um código binário correspondente. Para inserir a senha, o jogador deve inserir o código da letra utilizando as chaves presentes na placa [Altera DE2](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=139&No=502#contents) e confirmando com um botão **[KEY 0]**. O valor inserido pode ser verificado nos LEDs vermelhos, que são ligados após a inserção da letra. 

O jogador possui 1 minuto para decifrar qual é a senha correta que irá desarmar a bomba. Ao inserir corretamente, todos os LEDs verdes irão acender e o cronômetro irá pausar, indicando que o jogador conseguiu desarmá-la. Caso o tempo se esgote, o cronômetro irá parar e todos os LEDs vermelhos acendem, indicando que a bomba explodiu. 

### Como funciona? 🔎

O jogador possui um minuto para decifrar qual é a senha de desarme. Esta contagem é feita por um módulo **Cronômetro**, em que dois contadores assíncronos realizam a contagem de 60 segundos. Para mostrar o estado atual do contador nos Displays de 7 Segmentos, há um **Decodificador**, que recebe a saída do contador e converte no valor hexadecimal para ser passado para os displays. 

Para verificar se a senha inserida foi a correta, há um módulo **Verificador**, contendo dois registradores de deslocamento, que irão armazenar a letra inserida pelo usuário. Ao inserir as 4 letras, a palavra formada será comparada com a senha. Caso seja a senha correta, o **Verificador** manda um sinal para pausar a contagem e ligá-se os LEDs verde, indicando que o usuário foi capaz de desarmar a bomba. Caso contrário, o cronômetro continua, até que seja inserida a senha correta. 

Veja [aqui](https://github.com/MateusPincho/Bomba-Verilog/blob/main/fotos-e-videos/placa-em-funcionamento.mp4) o jogo em funcionamento! 

### Diagrama lógico

<p align="center">
<img src="https://github.com/MateusPincho/Bomba-Verilog/blob/main/fotos-e-videos/DiagramaL%C3%B3gico.jpeg" height="600" align="center">
</p>

## Tecnologias utilizadas  🖥️
- Placa Altera DE2
- Linguagem de Descrisção de Hardware Verilog
- Ambiente de Desenvolvimento Quartus II
<p align="center">
<img src="https://github.com/MateusPincho/Bomba-Verilog/blob/main/fotos-e-videos/desligada.jpeg?raw=true" height="300" align="center">
</p>

## Trabalho futuro

Há algumas melhorias que podem ser feitas para deixar o jogo mais imersivo: 
- Criar uma lógica para advinhar qual é a senha correta
- Fazer com que os LEDs vermelhos pisquem quando o tempo acabar, indicando que a bomba explodiu
- Adicionar um botão para reset assíncrono




> Desenvolvido por Mateus Pincho e Lorenzo Carrera
