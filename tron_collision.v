module tron_collision (
    input clk,                     // Clock do jogo (mesmo que os datapaths)
    input resetn,                  // Reset global
    input [7:0] p1_x, p2_x,         // Coordenadas X dos jogadores
    input [6:0] p1_y, p2_y,         // Coordenadas Y dos jogadores
    output reg p1_lost, p2_lost     // Sinaliza se o jogador perdeu
);
    
    // Memórias para armazenar a trilha dos jogadores
    reg trail_x [159:0] [119:0]; // 160x120 para armazenar X
    reg [119:0] trail_p1, trail_p2; // Flags de ocupação das trilhas

    integer i, j;

    // Inicialização
    initial begin
        p1_lost = 0;
        p2_lost = 0;
        for (i = 0; i < 160; i = i + 1)
            for (j = 0; j < 120; j = j + 1)
                trail_x[i][j] = 0; // Nenhuma trilha ocupada no início
    end

    always @(posedge clk) begin
        if (!resetn) begin
            // Resetando a trilha e os status dos jogadores
            p1_lost <= 0;
            p2_lost <= 0;
            for (i = 0; i < 160; i = i + 1)
                for (j = 0; j < 120; j = j + 1)
                    trail_x[i][j] <= 0;
        end
        else begin
            // Verifica colisão para o Player 1
            if (trail_x[p1_x][p1_y] == 1) 
                p1_lost <= 1;
            else
                trail_x[p1_x][p1_y] <= 1; // Registra posição de P1 na trilha

            // Verifica colisão para o Player 2
            if (trail_x[p2_x][p2_y] == 1) 
                p2_lost <= 1;
            else
                trail_x[p2_x][p2_y] <= 1; // Registra posição de P2 na trilha
        end
    end
endmodule
