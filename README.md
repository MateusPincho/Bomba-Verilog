# Jogo Digital - Desarmando Bombas 💣
Jogo digital na linguagem de descrição de hardware Verilog em que o objetivo é desativar uma bomba relógio inserindo corretamente a senha de desarme
<p align="center">
<img src="blob:https://web.whatsapp.com/ac7be1b8-be8f-42ce-bbbe-642bb241be9a" height="200" align="center">
</p>

## Sobre o Projeto 📖
Inspirado pelo jogo [*Keep Talking and Nobody Explodes*](https://keeptalkinggame.com/), o objetivo do usuário é desativar uma bomba-relógio ao inserir corretamente a senha que irá desarmá-la. Esta senha é formada por uma palavra binária de quatro letras **(ABCD)** e deve ser definida previamente dentro do ambiente de desenvolvimento [*Quartus II*](https://www.intel.com/content/www/us/en/software-kit/666221/intel-quartus-ii-web-edition-design-software-version-13-1-for-windows.html)

Cada letra possui um código binário correspondente. Para inserir a senha, o jogador deve inserir o código da letra utilizando as chaves presentes na placa [Altera DE2](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=139&No=502#contents) e confirmando com um botão **[KEY 0]**. O valor inserido pode ser verificado nos LEDs vermelhos, que são ligados após a inserção da letra. 

O jogador possui 1 minuto para decifrar qual é a senha correta que irá desarmar a bomba. Ao inserir corretamente, todos os LEDs verdes irão acender e o cronômetro irá pausar, indicando que o jogador conseguiu desarmá-la. Caso o tempo se esgote, o cronômetro irá parar e todos os LEDs vermelhos acendem, indicando que a bomba explodiu. 

### Como funciona? 🔎

### Diagrama lógico

## Tecnologias utilizadas  🖥️
- Placa Altera DE2
- Linguagem de Descrisção de Hardware Verilog
- Ambiente de Desenvolvimento Quartus II 

## Como executar 👨‍💻

## Trabalho futuro





> Desenvolvido por Mateus Pincho e Lorenzo Carrera
