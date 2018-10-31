module Timer(count,yes,LED4,LED5,clr,strtcntr,Loop,inc,dec,clk,reset);
    input   clr,strtcntr,Loop,inc,dec,clk,reset;
    output [64:0] count;
    output yes, LED4,LED5;
    
    reg [64:0] count,ncount;
    reg speed;
    //reg maxcount;
    reg [64:0] maxcount,nmaxcount;
    parameter realmaxcount = 50000000;
    always@(posedge clk)
        if(reset) begin
            count <= 0;
            maxcount <= realmaxcount;
        end
        else   begin
            count <= ncount;
            maxcount <= nmaxcount;
        end
    always@(count,ncount,clr,strtcntr,Loop,yes)
        if(count==maxcount || clr) begin
            ncount = 0;
            nmaxcount = realmaxcount;
        end
        else begin
            ncount = count + 1;
            nmaxcount = realmaxcount;
        end
//    always@(maxcount,inc,dec)
//        if(inc&&(maxcount<50000000)) // 0.5 second interval is slowest
//            nmaxcount = maxcount + 5000000;
//        else if(dec&&(maxcount>5000000))
//            nmaxcount = maxcount - 5000000; // 0.05 second interval is min
//        else
//            nmaxcount = maxcount;
        
    assign yes = (count == maxcount-1);      
    assign LED4 = count >= 2000000;
    assign LED5 = count <= 25000000;           
    endmodule