// GRBStateMachine.v

module GRBStateMachine(qmode,Done,LoadGRBPattern,ShiftPattern,StartCoding,ClrCounter,IncCounter,ShipGRB,theBit,bdone,Count,NumLEDs,clk,reset);
	output	[1:0]	qmode;
	output		Done,LoadGRBPattern, ShiftPattern, StartCoding, ClrCounter, IncCounter;
	input		ShipGRB, theBit, bdone;
	input   [7:0]	Count;
	input   [3:1]   NumLEDs;
	input		clk, reset;

	reg	     	S, nS;
	parameter	SSHIPRET=1'b0, SSHIPGRB=1'b1;

    reg      [7:0]   COMPAREVAL;

	always @(posedge clk)
		if(reset)
			S <= SSHIPRET;
		else
			S <= nS;

	always @(S, ShipGRB, bdone, Count)
		case(S)
			SSHIPRET:  nS = ShipGRB ? SSHIPGRB : SSHIPRET;
			SSHIPGRB:  nS = (bdone && (Count==COMPAREVAL)) ? SSHIPRET : SSHIPGRB;
			default:   nS = SSHIPRET;
		endcase

	assign LoadGRBPattern = (S==SSHIPRET)&&ShipGRB;
	assign ClrCounter     = (S==SSHIPRET)&&ShipGRB;
	assign StartCoding    = (S==SSHIPRET)&&ShipGRB;
	assign ShiftPattern   = (S==SSHIPGRB)&&bdone;
	assign IncCounter     = (S==SSHIPGRB)&&bdone;
	assign qmode          = (S==SSHIPRET) ? 2'b10 : {1'b0,theBit};
	assign Done           = (S==SSHIPGRB)&&bdone&&(Count==COMPAREVAL);
	
    always @(NumLEDs)
        case(NumLEDs)
            3'b000:  COMPAREVAL = 23;
            3'b001:  COMPAREVAL = 47;
            3'b011:  COMPAREVAL = 71;
            3'b111:  COMPAREVAL = 95;
            3'b100,3'b110:  COMPAREVAL = 119;
            default:  COMPAREVAL = 23;
        endcase
endmodule
