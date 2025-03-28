module tron_bram_player1 (
    input clk,                    // Clock 50 MHz
    input resetn,                 // Reset global (ativo em 0)
    input [9:0] x1, y1,           // Coordenadas do Jogador 1
    input [9:0] x2, y2,           // Coordenadas do Jogador 2
    output reg dead1,             // Sinal de morte do Jogador 1
    output reg wren_signal1       // Sinal para mostrar o wren para Jogador 1
);

    // Instância da memória BRAM (tron_memory)
    reg [14:0] rdaddress1, wraddress1;
    reg [0:0] data;
    reg wren1;
    wire [0:0] q1;

    tron_memory memory_inst1 (
        .clock(clk),
        .data(data),
        .rdaddress(rdaddress1),
        .wraddress(wraddress1),
        .wren(wren1),
        .q(q1)
    );

    // Pipeline
    reg [0:0] q_reg1;
    reg [1:0] step1;  // Controle do ciclo (0: leitura, 1: espera, 2: escrita)

    always @(posedge clk) begin
        if (!resetn) begin
            dead1 <= 0;
            wren1 <= 0;
            wren_signal1 <= 0;
            step1 <= 0;
        end else begin
            case (step1)
                0: begin
                    // **Fase de Leitura**
                    rdaddress1 <= {x1, y1};  // Verifica a posição do Jogador 1
                    step1 <= 1;
                end

                1: begin
                    // **Fase de Espera (latência da BRAM)**
                    q_reg1 <= q1;
                    if (q_reg1 == 1) begin
                        dead1 <= 1;  // Jogador 1 colidiu
                    end else begin
                        // **Se não colidiu, marca a trilha do Jogador 1**
                        wraddress1 <= {x1, y1};
                        data        <= 1;
                        wren1       <= 1;
                        wren_signal1 <= 1;  // Ativa o sinal de wren para Jogador 1
                    end
                    step1 <= 2;
                end

                2: begin
                    // **Finaliza ciclo - Desativa escrita**
                    wren1 <= 0;
                    wren_signal1 <= 0;  // Desativa o sinal de wren para Jogador 1
                    step1 <= 0;
                end
            endcase
        end
    end

endmodule
