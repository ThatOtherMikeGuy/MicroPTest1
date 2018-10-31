// SimpleSend.v

module SimpleSend(dataOut,LED1,LED2,LED3,LED4,LED5,sw,NumLEDs,Go,inc,dec,Loop,clk,reset);
	output	dataOut, LED1, LED2,LED3,LED4,LED5;
	input   [15:4] sw;
	input   [3:1]  NumLEDs;
	input	Go, Loop,inc,dec,clk, reset;

	wire		shipGRB, Done,simgo,delay, chngcolor,speedlvl,clr,inLoop,yes;
	wire [1:0]	qmode;
	wire		LoadGRBPattern, ShiftPattern, StartCoding, ClrCounter, IncCounter, theBit, bdone;
	wire [7:0]	Count;
	wire [15:0] delayCount;
	wire [15:4] simsw;

	SSStateMachine	sssm(shipGRB,Done,simgo,inLoop,clk,reset);
	GRBStateMachine grbsm(qmode,Done,LoadGRBPattern,ShiftPattern,StartCoding,ClrCounter,IncCounter,
                              shipGRB,theBit,bdone,Count,NumLEDs,clk,reset);
	ShiftRegister   shftr(theBit,simsw,LoadGRBPattern,ShiftPattern,clk,reset);
	BitCounter	btcnt(Count,ClrCounter,IncCounter,clk,reset);
	NZRbitGEN	nzrgn(dataOut,bdone,qmode,StartCoding,clk,reset);
	
	Loop loop(simgo,chngcolor,speedlvl,LED1,LED2,LED3,inLoop,delay,clr,Loop,Go,yes,clk,reset);
	Timer timr(delay,yes,LED4,LED5,clr,inLoop,Loop,inc,dec,clk, reset);
	Color color(simsw,chngcolor,sw,inLoop,simgo,clk,reset);
endmodule
