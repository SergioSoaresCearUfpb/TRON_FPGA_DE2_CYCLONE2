`timescale 1ns/1ns

module tron_bram_tb;
    reg clk, resetn;
    reg [7:0] p1_x, p2_x;
    reg [6:0] p1_y, p2_y;
    wire p1_lost, p2_lost;

    // Instancia o módulo tron_bram
    tron_bram uut (
        .clk(clk),
        .resetn(resetn),
        .p1_x(p1_x),
        .p1_y(p1_y),
        .p2_x(p2_x),
        .p2_y(p2_y),
        .p1_lost(p1_lost),
        .p2_lost(p2_lost)
    );

    // Geração do clock (50 MHz = 20ns por ciclo)
    always #10 clk = ~clk;

    initial begin
        $dumpfile("tron_bram_tb.vcd");
        $dumpvars(0, tron_bram_tb);
        
        clk = 0;
        resetn = 0;
        p1_x = 8'd10; p1_y = 7'd10;
        p2_x = 8'd20; p2_y = 7'd20;
        
        // Reset inicial
        #50 resetn = 1;

        // Simulação: Player 1 se move e não deve colidir
        #50 p1_x = 8'd11;
        #50 p1_x = 8'd12;

        // Simulação: Player 2 entra na trilha do Player 1 -> Deve perder
        #50 p2_x = 8'd12; 
        #50 if (p2_lost) $display("Player 2 perdeu!");

        // Simulação: Player 1 colide com sua própria trilha -> Deve perder
        #50 p1_x = 8'd10;
        #50 if (p1_lost) $display("Player 1 perdeu!");

        #100;
        $finish;
    end
endmodule
