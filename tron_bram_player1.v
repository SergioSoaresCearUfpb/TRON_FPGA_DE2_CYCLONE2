module tron_bram_player1 (
    input clk,                    // Clock 50 MHz
    input resetn,                 // Reset global (ativo em 0)
    input [9:0] x1, y1,           // Coordenadas do Jogador 1
    input [9:0] x2, y2,           // Coordenadas do Jogador 2
    output reg dead1              // Sinal de morte do Jogador 1
);

    // Instância da memória BRAM compartilhada
    reg [14:0] rdaddress, wraddress;
    reg data;
    reg wren;
    wire q;  // Saída da memória BRAM (latência de 1 ciclo)

    tron_memory memory_inst (
        .clock(clk),
        .data(data),
        .rdaddress(rdaddress),
        .wraddress(wraddress),
        .wren(wren),
        .q(q)
    );

    reg [3:0] step;  // Controle de estados

    always @(posedge clk) begin
        if (!resetn) begin
            dead1 <= 0;
            wren  <= 0;
            step  <= 0;
        end else begin
            case (step)
                0: begin
                    // **Leitura da posição do Jogador 1**
                    rdaddress <= {x1, y1};
                    step <= 1;
                end

                1: begin
                    // **Verificação de colisão** (BRAM tem latência de 1 ciclo)
                    if (q == 1) begin
                        dead1 <= 1;  // Colisão detectada
                    end else begin
                        step <= 2;   // Segue para escrita
                    end
                end

                2: begin
                    // **Escrita da posição do Jogador 1 (se ainda estiver vivo)**
                    if (!dead1) begin
                        wraddress <= {x1, y1};
                        data      <= 1;
                        wren      <= 1;
                    end
                    step <= 3;
                end

                3: begin
                    // **Desativa escrita do Jogador 1**
                    wren <= 0;
                    step <= 4;
                end

                4: begin
                    // **Jogador 2 escreve sua posição**
                    wraddress <= {x2, y2};
                    data      <= 1;
                    wren      <= 1;
                    step <= 5;
                end

                5: begin
                    // **Desativa escrita do Jogador 2 e finaliza ciclo**
                    wren <= 0;
                    step <= 0;
                end
            endcase
        end
    end
endmodule
