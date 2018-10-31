// SSStateMachine.v

module SSStateMachine(shipGRB,Done,Go,inLoop,clk,reset);
	output	shipGRB;
	input	Done, Go,inLoop;
	input	clk, reset;

	reg [1:0]	S, nS;
	parameter	SWAIT=2'b00, SSHIP=2'b01, SDBOUNCE=2'b11;

	always @(posedge clk)
		if(reset)
			S <= SWAIT;
		else
			S <= nS;

	always @(S, Go, Done)
		case(S)
			SWAIT: 		nS = Go   ? SSHIP    : SWAIT;
			SSHIP:		nS = Done ? (inLoop ? SWAIT:SDBOUNCE) : SSHIP;
			SDBOUNCE:	nS = Go   ? SDBOUNCE : SWAIT;
			default:	nS = SWAIT;
		endcase

	assign shipGRB = (S==SSHIP);
endmodule

