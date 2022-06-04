module ds_modulator (
    input                 i_clk,
    input                 i_rst_n,
    input  real           i_data,
    output signed [2 : 0] o_pdm_data
);

    real delta;
    real integrator_ff;
    real feedback_ff;

    // calculate delta
    assign delta = i_data - feedback_ff;

    // integrator
    always @(posedge i_clk, negedge i_rst_n) begin
        if (~i_rst_n) integrator_ff <= 0;
        else integrator_ff <= integrator_ff + delta; 
    end

    // comparator
    assign o_pdm_data = (integrator_ff > 0) ? 1 : -1;

    // feedback
    always @(posedge i_clk, negedge i_rst_n) begin
        if (~i_rst_n) feedback_ff <= 0;
        else feedback_ff <= o_pdm_data; 
    end

endmodule