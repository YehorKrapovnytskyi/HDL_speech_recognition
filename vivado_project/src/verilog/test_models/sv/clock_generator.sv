`timescale 1ns/1ps
module clock_generator 
#(parameter PERIOD = 1)
(
    output logic o_clk 
);

    initial o_clk = 0;

    always o_clk = #(PERIOD / 2) ~o_clk;

endmodule