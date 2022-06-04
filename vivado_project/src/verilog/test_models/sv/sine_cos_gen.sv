`timescale 1ns/1ps

module sine_cos_gen(output real sin_out,
                    output real cos_out);

    import test_package::*;

    // sampling rate
    parameter        SAMPLING_TIME = 10;
    parameter        FREQ = 1;
    parameter  real  AMPLITUDE = 1;

    const real pi = 3.1416;
    real       time_us, time_s ;
    bit        sampling_clock;
    

    always sampling_clock = #(SAMPLING_TIME) ~sampling_clock;


    always @(sampling_clock) begin
        time_us = $realtime/1000;
        time_s = time_us/1000000;
    end

    assign sin_out = AMPLITUDE * my_sin(2 * pi * FREQ * time_s);
    assign cos_out =  AMPLITUDE * my_cos(2 * pi * FREQ * time_s);

endmodule



