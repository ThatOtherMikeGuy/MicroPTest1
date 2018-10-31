// NZRbitGEN.v
// Generate NZR bitcode timing for WS2812B GRB LED Module,
// using a Digilent BASYS3 prototyping board with a
// Xilinx Artix-7 FPGA clocked at 100 MHz .
//
// This module must receive a qmode input which describes
// the current NZR bitcode to be produced ("0", "1", RESET).
// The value of qmode should be held constant until
// the Moore output bdone is asserted.  A new qmode should
// then be supplied within 1/100M = 10 ns to begin the generation
// of the next bitcode.
//
// Jerry C. Hamann
// EE 4490 Fall 2017
//
module NZRbitGEN(bout, bdone, qmode, startcoding, clk, reset);
    output  bout, bdone;        // bout  -- NZR signal
                                // bdone -- bitcode generation completed
    input   [1:0] qmode;        // Mode for generation:
                                // 2'b00 Produce a "0"
                                // 2'b01 Produce a "1"
                                // 2'b10 Solid low output (for resets)
                                // 2'b11 Solid high output
    input   startcoding;        // Like reset, drives counter to zero to synchronize code generation
    input   clk, reset;         // synchronous, 100 MHz assumed
    reg     bout;          
    reg     [6:0] bcount;       // 0-127 count for generating NZR timing
                                // Note:  128*(1/100M) = 1.28 microseconds

    // Implement state memory and next state for synchronous bcounter
    always @(posedge clk)
    begin
        if(reset || startcoding)
            bcount <= 0;
        else
            bcount <= bcount+1;  // Depends on 7'h7F->7'h00 rollover
    end

    always @(qmode or bcount) // bout produced based on qmode
    begin
        case(qmode)         // 90*(1/(100 MHz)) = 0.900 ns
            2'b00:  bout = (bcount < 40) ? 1 : 0 ; // "0"
            2'b01:  bout = (bcount < 90) ? 1 : 0 ; // "1"
            2'b10:  bout = 0; // Produces "RESET" compatible output
            2'b11:  bout = 1; // Reserved for future use
            default: bout = 0;
        endcase
    end
    assign bdone = (bcount == 127);  // Marks end of NZR bitcode generation
endmodule
