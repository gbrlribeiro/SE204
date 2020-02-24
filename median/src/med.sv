module MED #(parameter WIDTH = 8,
            parameter NUM = 9)
            (input [WIDTH-1:0]DI,
             input DSI, BYP, CLK,
             output [WIDTH-1:0] DO);

logic [WIDTH-1:0] R[0:NUM-1];
wire [WIDTH-1:0]MIN, MAX;
wire [WIDTH-1:0]D1, D2;

MCE #(.WIDTH(WIDTH)) MCE1(
	.A(DO),
	.B(R[NUM-2]),
	.MIN(MIN),
	.MAX(MAX)

);
assign D2 = (BYP) ? R[NUM-2] : MAX;
assign D1 = (DSI) ? DI : MIN;
assign DO = R[NUM-1];

         always_ff @(posedge CLK)
	 begin
		 R <= {D1, R[0:NUM-2]};		
			 
		 R[NUM-1] <= D2;		 
	 end

endmodule
