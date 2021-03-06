// -------------------------------------------------------------
// 
// File Name: ..\..\hw\CIC_decimator_HDL_model\CIC_decimator_HDL_model.v
// Created: 2022-05-20 22:52:52
// 
// Generated by MATLAB 9.5 and HDL Coder 3.13
// 
// 
// -- -------------------------------------------------------------
// -- Rate and Clocking Details
// -- -------------------------------------------------------------
// Model base rate: 5e-07
// Target subsystem base rate: 5e-07
// 
// 
// Clock Enable  Sample Time
// -- -------------------------------------------------------------
// ce_out        5e-07
// -- -------------------------------------------------------------
// 
// 
// Output Signal                 Clock Enable  Sample Time
// -- -------------------------------------------------------------
// o_pcm_speach_data             ce_out        5e-07
// -- -------------------------------------------------------------
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: CIC_decimator_HDL_model
// Source Path: CIC_decimator_HDL_model/CIC_decimator_HDL_model
// Hierarchy Level: 0
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module CIC_decimator_HDL_model
          (i_clk,
           i_rst_n,
           clk_enable,
           i_pdm_speach_data,
           ce_out,
           o_pcm_speach_data);


  input   i_clk;
  input   i_rst_n;
  input   clk_enable;
  input   signed [1:0] i_pdm_speach_data;  // sfix2
  output  ce_out;
  output  signed [15:0] o_pcm_speach_data;  // int16


  wire enb;
  reg [7:0] Counter_out1;  // uint8
  wire Decimation_factor_out1;
  wire signed [14:0] CIC_decimator_out1;  // sfix15
  wire signed [30:0] FIR_compensator_out1;  // sfix31
  wire signed [15:0] scaling_to_16bit_out1;  // int16


  assign enb = clk_enable;

  // Count limited, Unsigned Counter
  //  initial value   = 0
  //  step value      = 1
  //  count to value  = 127
  always @(posedge i_clk or negedge i_rst_n)
    begin : Counter_process
      if (i_rst_n == 1'b0) begin
        Counter_out1 <= 8'b00000000;
      end
      else begin
        if (enb) begin
          if (Counter_out1 >= 8'b01111111) begin
            Counter_out1 <= 8'b00000000;
          end
          else begin
            Counter_out1 <= Counter_out1 + 8'b00000001;
          end
        end
      end
    end



  assign Decimation_factor_out1 = Counter_out1 == 8'b01111111;



  CIC_decimator u_CIC_decimator (.i_clk(i_clk),
                                 .i_rst_n(i_rst_n),
                                 .enb(clk_enable),
                                 .i_data(i_pdm_speach_data),  // sfix2
                                 .i_clk_slow_en(Decimation_factor_out1),
                                 .o_data(CIC_decimator_out1)  // sfix15
                                 );

  FIR_compensator u_FIR_compensator (.i_clk(i_clk),
                                     .i_rst_n(i_rst_n),
                                     .enb(clk_enable),
                                     .i_data(CIC_decimator_out1),  // sfix15
                                     .i_en(Decimation_factor_out1),
                                     .o_data(FIR_compensator_out1)  // sfix31
                                     );

  scaling_to_16bit u_scaling_to_16bit (.i_clk(i_clk),
                                       .i_rst_n(i_rst_n),
                                       .enb(clk_enable),
                                       .i_data(FIR_compensator_out1),  // sfix31
                                       .i_en(Decimation_factor_out1),
                                       .o_data(scaling_to_16bit_out1)  // int16
                                       );

  assign o_pcm_speach_data = scaling_to_16bit_out1;

  assign ce_out = clk_enable;

endmodule  // CIC_decimator_HDL_model

