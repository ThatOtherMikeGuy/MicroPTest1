// ShiftRegister.v

module ShiftRegister(CurrentBit,sw,LoadRegister,RotateRegisterLeft,clk,reset);
	output		CurrentBit;
	input [15:4] sw;
	input		LoadRegister, RotateRegisterLeft;
	input		clk, reset;

	parameter	DEFAULTREG=24'h0F0F0F;
//	parameter RED=24'h00FF00,REDBLUE1=24'h00FF0F,REDBLUE2=24'h00FFF0,
//       MIDRB=24'h00FFFF,BLUERED2=24'h00F0FF,BLUERED1=24'h000FFF,
//       BLUE=24'h0000FF, BLUEGREEN1=24'h0F00FF,BLUEGREEN2=24'hF000FF,
//       MIDBG=24'hFF00FF,GREENBLUE2=24'hFF00F0,GREENBLUE1=24'hFF000F,
//       GREEN=24'hFF0000,GREENRED1=24'hFF0F00,GREENRED2=24'hFFF000,
//       MIDGR=24'hFFFF00, REDGREEN2=24'hF0FF00,REDGREEN1=24'h0FFF00;

	reg	[23:0]	TheReg, nTheReg;

	always @(posedge clk)
		if(reset)
			TheReg <= DEFAULTREG;
		else
			TheReg <= nTheReg;

	always @(TheReg, LoadRegister, RotateRegisterLeft,sw)
		if(LoadRegister)//add random color loop here set go to true somewhere to drive automatically
			nTheReg = {sw[15:12],4'b0000,sw[11:8],4'b0000,sw[7:4],4'b0000};
		else
			if(RotateRegisterLeft)
				nTheReg = {TheReg[22:0],TheReg[23]};
			else
				nTheReg = TheReg;

	assign	CurrentBit = TheReg[23];
endmodule
