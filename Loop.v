
module Loop(simgo,changecolor,speedlvl,LED1,LED2,LED3,strtcnt,delay,clr,Loop,Go,yes,clk,reset);
    input Go,Loop,yes,clk,reset;
    output simgo, changecolor,speedlvl,clr,LED1,LED2,LED3,strtcnt;
    input [64:0] delay;

    reg [1:0]   S,nS;
    reg speedlvl,nspeedlvl;
    parameter WAIT=2'b00, LOOP = 2'b01, LOOPBOUNCE = 2'b11, LOOPBOUNCE2 = 2'B10;
    parameter speed1=2'b01, speed2=2'b10,speed3=2'b11;
    wire    changecolor;
    reg [64:0] setdelay;
    always@(posedge clk)
        if(reset)
            S<=2'b00;
        else
            S<=nS;
    always@(S,Loop)
        case(S)
            WAIT:       nS =  Loop      ?   LOOPBOUNCE :   WAIT;   
            LOOPBOUNCE: nS = Loop       ?   LOOPBOUNCE :   LOOP;
            LOOP:       nS =  Loop      ?   LOOPBOUNCE2:   LOOP;
            LOOPBOUNCE2: nS = Loop      ?   LOOPBOUNCE2:   WAIT;
            default: nS = WAIT;
        endcase     
    assign simgo = (((S==LOOP)&&yes) || Go || (S==WAIT && Loop));
    assign strtcnt = S==LOOP;
    assign clr = simgo;
    assign changecolor = (S==LOOP)&&yes;
    //testing/debugging outputs
    assign LED1 = S==LOOP;
    assign LED2 = yes;
    assign LED3 = simgo;

endmodule