// Módulo de teste na placa ALTERA DE2

module Mod_Teste (
	//////////////////// Fonte de Clock ////////////////////
	CLOCK_27, // 27 MHz
	CLOCK_50, // 50 MHz
	//////////////////// Push Button ////////////////////
	KEY, // Botões [3:0]
	//////////////////// Chaves DPDT ////////////////////
	SW, // Chaves [17:0]
	//////////////////// Display de 7-hex_value ////////////////////
	HEX0, // Display de 7 segmentos 0
	HEX1, // Display de 7 segmentos 1
	HEX2, // Display de 7 segmentos 2
	HEX3, // Display de 7 segmentos 3
	HEX4, // Display de 7 segmentos 4
	HEX5, // Display de 7 segmentos 5
	HEX6, // Display de 7 segmentos 6
	HEX7, // Display de 7 segmentos 7
	//////////////////// LEDS ////////////////////////
	LEDG, // LEDs Verdes [8:0]
	LEDR  // LEDs Vermelhos [17:0]
);

	// Setup de entradas e saídas da placa ALTERA DE2
	input CLOCK_27;
	input CLOCK_50;
	input [3:0] KEY;
	input [17:0] SW;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [6:0] HEX6;
	output [6:0] HEX7;
	output [8:0] LEDG;
	output [17:0] LEDR;

	// --------------------------------------------------------------------------
	// Trecho para instanciação de módulos e interligação entre os mesmos
	// --------------------------------------------------------------------------

	// Visualização das entradas
	assign LEDR[0] = SW[0];
	assign LEDR[1] = SW[1];
	
	// Define todas as palavras possíveis. Como as palavras da senha são de 2 bits, existem 4 palavras distintas possíveis
	wire [1:0]A = 2'b00;
	wire [1:0]B = 2'b01;
	wire [1:0]C = 2'b10;
	wire [1:0]D = 2'b11;

	// Define a sequência de desativação da bomba (Nesse caso, ABDC)
	wire [1:0]P0 = A;
	wire [1:0]P1 = B;
	wire [1:0]P2 = D;
	wire [1:0]P3 = C;

	wire [1:0]Ss;
	wire [3:0]Q0;
	wire [3:0]Q1;

	// Registradores para salvar a sequência de palavras inseridas
	// Tem o botão KEY[0] como tecla enter
	registrador_desloc_direita_4 R0(Q0, Ss[0], SW[0], KEY[0], 1'b1); 
	registrador_desloc_direita_4 R1(Q1, Ss[1], SW[1], KEY[0], 1'b1);

	// Visualização da sequência inserida
	assign LEDR[17:16] = {Q1[3], Q0[3]};
	assign LEDR[15:14] = {Q1[2], Q0[2]};
	assign LEDR[13:12] = {Q1[1], Q0[1]};
	assign LEDR[11:10] = {Q1[0], Q0[0]};

	// Condição de desativação da bomba - A sequência de desativação está correta
	wire desativar;
	assign desativar = {Q1[0], Q0[0]} == P0 && 
					   {Q1[1], Q0[1]} == P1 && 
					   {Q1[2], Q0[2]} == P2 && 
					   {Q1[3], Q0[3]} == P3;
	
	// Pisca todos os LEDs verdes para indicar que a bomba foi desativada
	wire pisca;
	divisor_de_freq(pisca, CLOCK_50);      
	assign LEDG[7:0] = {8{pisca & desativar}}; 
	
	// Cronômetro
	wire [3:0]Us;
	wire [3:0]Ds;
	wire z;
	cronometro CR (Ds, Us, z, ~(z | desativar), CLOCK_50);
	
	// Display do tempo do cronômetro
	SEG7_LUT(HEX7[6:0], 4'b0000);
	SEG7_LUT(HEX6[6:0], 4'b0000);
	SEG7_LUT(HEX5[6:0], Ds);
	SEG7_LUT(HEX4[6:0], Us);
	
	// Apaga os outros displays não utilizados
	assign HEX3[6:0] = ~7'b0000000;
	assign HEX2[6:0] = ~7'b0000000;
	assign HEX1[6:0] = ~7'b0000000;
	assign HEX0[6:0] = ~7'b0000000;
	
endmodule 

module divisor_de_freq (clk_out, clk);

	input clk;
	output reg clk_out;
	reg rst;
	reg [24:0]counter;
	initial rst = 0; // Inicia rst para 0 (para bordas de descida)

	always @ (posedge clk or negedge rst) begin
		if(!rst) begin
			rst = 1; // Para permitir descer no próximo clock
			counter = 25'd0; // Número de 25 bits com decimal definido em 0
			clk_out = 1'b0; // clk out recebe um bit = 0;
		end
		else if(counter == 25'd24_999_999) begin // Converte um clock de 50MHz para 1Hz
			counter = 25'd0; // Recebe um decimal de 25 bits valor 0
			clk_out = ~clk_out; // Dá o pulso pro novo clock, ja dividido
		end
		else begin
			counter = counter + 1; // Ajusta o contador até chegar em 24 999 999
		end
	end

endmodule

// Contador decrescente de 5 a 0
module contador_decres_comport_mod6 (counter, clk);

	input clk;
	output reg [3:0]counter;
	initial counter = 4'b0101;
	
	always @ (posedge clk) begin
		counter <= counter == 4'b0000 ? 4'b0101 : counter - 4'b0001; 
	end
	
endmodule 

// Contador decrescente de 9 a 0
module contador_decres_comport_mod10 (counter, clk);

	input clk;
	output reg [3:0]counter;
	initial counter = 4'b1001;
	
	always @ (posedge clk) begin
		counter <= counter == 4'b0000 ? 4'b1001 : counter - 4'b0001; 
	end
	
endmodule 

// Contador decrescente de 59 a 0; Indica quando zera
module cronometro (Ds, Us, z, enable, clk);

	output [3:0]Ds;
	output [3:0]Us;
	output z;
	input enable; 
	input clk;

	wire segundos;
	divisor_de_freq(segundos, clk);

	contador_decres_comport_mod10 CD (Us, segundos & enable);
	
	contador_decres_comport_mod6 CU (Ds, Us[3]);
	
	assign z = ~((|Us) | (|Ds)); // Indica quando o cronômetro zera

endmodule

module ff_jk (q, q_bar, j, k, clk, clr, pr);

	input j, k, clk, clr, pr;
	
	output reg q, q_bar;
	
	always @ (posedge clk or negedge clr or negedge pr) begin 
		
		if (~clr) begin 
			q <= 1'b0;
		end
		else if (~pr) begin
			q <= 1'b1;
		end
		else begin
			case ({j, k})
				2'b00: q <= q;
				2'b01: q <= 0;
				2'b10: q <= 1;
				2'b11: q <= ~q;
			endcase
		end
		
		q_bar <= ~q;
	end

endmodule 

module registrador_desloc_direita_4(Sp, Ss, Es, clk, clr);

	input Es, clr, clk;
	output [3:0]Sp;
	
	output Ss;
	
	wire [3:0]q;
	wire [3:0]q_bar;
	
	ff_jk FF3(q[3], q_bar[3],   Es,    ~Es, clk, clr, 1'b1);
	ff_jk FF2(q[2], q_bar[2], q[3],  ~q[3], clk, clr, 1'b1);
	ff_jk FF1(q[1], q_bar[1], q[2],  ~q[2], clk, clr, 1'b1);
	ff_jk FF0(q[0], q_bar[0], q[1],  ~q[1], clk, clr, 1'b1);
	
	assign Ss = q[0]; // Saída serial
	assign Sp = q;    // Saída paralela

endmodule 

module SEG7_LUT (saida_7, entrada_4);

	input  [3:0] entrada_4;
	output [6:0] saida_7;
	reg    [6:0] saida_7;

	always @(entrada_4) begin	
		case(entrada_4)
			4'h0: saida_7 = ~7'b0111111;
			4'h1: saida_7 = ~7'b0000110;
			4'h2: saida_7 = ~7'b1011011;
			4'h3: saida_7 = ~7'b1001111;
			4'h4: saida_7 = ~7'b1100110;
			4'h5: saida_7 = ~7'b1101101;
			4'h6: saida_7 = ~7'b1111101;
			4'h7: saida_7 = ~7'b0000111;
			4'h8: saida_7 = ~7'b1111111;
			4'h9: saida_7 = ~7'b1100111;
			4'ha: saida_7 = ~7'b1110111;
			4'hb: saida_7 = ~7'b1111100;
			4'hc: saida_7 = ~7'b0111001;
			4'hd: saida_7 = ~7'b1011110;
			4'he: saida_7 = ~7'b1111001;
			4'hf: saida_7 = ~7'b1110001;
		endcase
	end

endmodule 