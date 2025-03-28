module ps2_keyboard (
    input clk,               // Clock do sistema
    input ps2_clk,           // Clock do protocolo PS/2
    input ps2_data,          // Dados do protocolo PS/2
    output reg w, a, s, d,   // Sinais para player 1
    output reg up, left, down, right  // Sinais para player 2
);

    reg [10:0] shift_reg;  // Shift register para capturar o código da tecla
    reg [3:0] bit_count;   // Contador de bits recebidos
    reg [7:0] last_key;
    reg key_released;      // Indica se um break code (F0) foi detectado

    always @(negedge ps2_clk) begin
        if (bit_count < 11) begin
            shift_reg <= {ps2_data, shift_reg[10:1]}; // Shift para a direita
            bit_count <= bit_count + 1;
        end 
        if (bit_count == 10) begin
            last_key <= shift_reg[8:1]; // Pega apenas os bits de dados
            bit_count <= 0;             // Reinicia contagem
        end
    end

    always @(posedge clk) begin
        if (last_key == 8'b11110000) begin // 8'hF0 em binário
            key_released <= 1;
        end else if (key_released) begin
            case (last_key)
                8'b00011101: w <= 0;  // 8'h1D
                8'b00011011: s <= 0;  // 8'h1B
                8'b00011100: a <= 0;  // 8'h1C
                8'b00100011: d <= 0;  // 8'h23
                8'b01110101: up <= 0;  // 8'h75
                8'b01110010: down <= 0; // 8'h72
                8'b01101011: left <= 0; // 8'h6B
                8'b01110100: right <= 0; // 8'h74
            endcase
            key_released <= 0;
        end else begin
            case (last_key)
                8'b00011101: w <= 1;   // 8'h1D
                8'b00011011: s <= 1;   // 8'h1B
                8'b00011100: a <= 1;   // 8'h1C
                8'b00100011: d <= 1;   // 8'h23
                8'b01110101: up <= 1;  // 8'h75
                8'b01110010: down <= 1; // 8'h72
                8'b01101011: left <= 1; // 8'h6B
                8'b01110100: right <= 1; // 8'h74
            endcase
        end
    end

endmodule