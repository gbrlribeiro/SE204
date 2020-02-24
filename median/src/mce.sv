module MCE #(parameter WIDTH = 8)
		   (input	[WIDTH-1:0]A,
		    input	[WIDTH-1:0]B,
		    output	[WIDTH-1:0]MAX,
		    output	[WIDTH-1:0]MIN);

	assign MAX = (A>B) ? A : B;
	assign MIN = (A>B) ? B : A;


endmodule
