// BitCounter.v

// BitCounter.v

module BitCounter(Count,ClearCounter,IncCounter,clk,reset);
	output	[7:0]	Count;
	input		ClearCounter, IncCounter;
	input		clk, reset;

	reg	[7:0]	Count, nCount;

	always @(posedge clk)
		if(reset)
			Count <= 0;
		else
			Count <= nCount;

	always @(Count, ClearCounter, IncCounter)
		if(ClearCounter)
			nCount = 0;
		else
			if(IncCounter)
				nCount = Count+1;
			else
				nCount = Count;
endmodule