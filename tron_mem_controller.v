module tron_mem_controller (
    input clk,                      // Clock do sistema
    input resetn,                   // Reset global
    input [7:0] addr_x,             // Coordenada X do jogador
    input [6:0] addr_y,             // Coordenada Y do jogador
    input wr_en,                    // Sinal de escrita (1 para gravar trilha)
    output reg collision_detected,  // Indica se houve colisão
    inout [15:0] dram_data,         // Barramento de dados (16 bits)
    output reg [22:0] dram_addr,    // Endereço na memória DRAM
    output reg dram_we,             // Sinal de escrita na DRAM
    output reg dram_re              // Sinal de leitura na DRAM
);
    
    reg [15:0] data_out;
    reg [15:0] data_in;

    always @(posedge clk) begin
        if (!resetn) begin
            collision_detected <= 0;
            dram_we <= 0;
            dram_re <= 0;
        end
        else begin
            // Calcula endereço na DRAM baseado na posição (X, Y)
            dram_addr <= {addr_x, addr_y}; // 23 bits -> espaço grande de memória

            if (wr_en) begin
                dram_re <= 1;  // Ativa leitura para verificar se já tem trilha
                #2; // Simulação de tempo de latência da memória

                if (dram_data != 16'b0) begin
                    collision_detected <= 1; // Jogador colidiu com trilha
                end
                else begin
                    // Armazena posição do jogador na DRAM
                    dram_we <= 1;
                    data_out <= 16'b1;
                end
            end
            else begin
                dram_we <= 0;
                dram_re <= 0;
            end
        end
    end

    assign dram_data = (dram_we) ? data_out : 16'bz; // Controla barramento
endmodule
