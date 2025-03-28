module tron_bram_p1 (
    input clk,
    input resetn,
    input [7:0] p1_x,
    input [6:0] p1_y,
    input data_p1, data_p2,  // Dados da memória (recebidos do módulo principal)
    output reg p1_lost,
    output reg debug_data_p1
);

    always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            p1_lost <= 0;
            debug_data_p1 <= 0;
        end else begin
            // Atualiza debug
            debug_data_p1 <= data_p1;

            // P1 perde se sua posição já estiver ocupada por qualquer trilha
            if (!p1_lost && (data_p1 || data_p2)) begin
                p1_lost <= 1;
            end
        end
    end

endmodule
