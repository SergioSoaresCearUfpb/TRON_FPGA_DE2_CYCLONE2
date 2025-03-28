module tron_bram (
    input clk,                     // Clock 50 MHz
    input resetn,                     // Reset global (ativo em 0)
    input [9:0] x1, y1,            // Coordenadas do Jogador 1
    input [9:0] x2, y2,            // Coordenadas do Jogador 2
    output wire p1_lost,           // Sinal de morte do Jogador 1
    output wire p2_lost            // Sinal de morte do Jogador 2
);
wire p1_dead, p2_dead;
    // Instâncias dos módulos dos jogadores
	 assign p1_lost = p1_dead;
	 assign p2_lost = p2_dead;
     tron_bram_player1 player1 (
        .clk(clk),
        .resetn(resetn),
        .x1(x1),
        .y1(y1),
        .x2(x2),
        .y2(y2),
        .dead1(p1_dead)
    );

     tron_bram_player2 player2 (
        .clk(clk),
        .resetn(resetn),
        .x1(x1),
        .y1(y1),
        .x2(x2),
        .y2(y2),
        .dead2(p2_dead)
    );

endmodule