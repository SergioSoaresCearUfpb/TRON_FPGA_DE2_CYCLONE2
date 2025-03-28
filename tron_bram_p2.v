module tron_bram_p2 (
    input clk,
    input resetn,
    input [7:0] p2_x,
    input [6:0] p2_y,
    input data_p1, data_p2,  // Dados da memória (recebidos do módulo principal)
    output reg p2_lost,
    output reg debug_data_p2
);

    always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            p2_lost <= 0;
            debug_data_p2 <= 0;
        end else begin
            // Atualiza debug
            debug_data_p2 <= data_p2;

            // P2 perde se sua posição já estiver ocupada por qualquer trilha
            if (!p2_lost && (data_p1 || data_p2)) begin
                p2_lost <= 1;
            end
        end
    end

endmodule
