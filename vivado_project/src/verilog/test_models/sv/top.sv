`timescale 1ns/1ps

module top;

    // 2MHz sampling rate
    localparam SAMPLING_TIME = 500;
    localparam FREQ1 = 1e3;
    localparam FREQ2 = 4e3;
    localparam SIM_END = SAMPLING_TIME * 50000;

    logic                 clk;
    logic                 i_rst_n;
    logic signed [2  : 0] pdm;
    logic signed [15 : 0] pcm_data;

    real sine1;
    real sine2;
    real sine_sum;

    clock_generator #(.PERIOD(SAMPLING_TIME)) clk_gen_inst1 (
        .o_clk(clk)
    );

    sine_cos_gen #(.SAMPLING_TIME(SAMPLING_TIME), .AMPLITUDE(1), .FREQ(FREQ1)) sine_inst1 (
        .sin_out(sine1),
        .cos_out()
    );

    sine_cos_gen #(.SAMPLING_TIME(SAMPLING_TIME), .AMPLITUDE(1), .FREQ(FREQ2)) sine_inst2 (
        .sin_out(sine2),
        .cos_out()
    );

    assign sine_sum = (sine2 + sine1) / 2;

    ds_modulator ds_modulator_inst1 (
        .i_clk(clk),
        .i_rst_n(i_rst_n),
        .i_data(sine_sum),
        .o_pdm_data(pdm)
    );

    CIC_decimator_HDL_model cic_inst1 (
        .i_clk(clk),
        .i_rst_n(i_rst_n),
        .clk_enable(1'b1),
        .i_pdm_speach_data(pdm),
        .ce_out(),
        .o_pcm_speach_data(pcm_data)
    );

    initial begin
        i_rst_n = 0;
        #5;
        i_rst_n = 1;
        #SIM_END;
        $finish;
    end

endmodule