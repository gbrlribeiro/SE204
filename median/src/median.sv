module MEDIAN #(parameter WIDTH = 8)
    (input [WIDTH-1:0]DI,
     input DSI, nRST, CLK,
     output [WIDTH-1:0] DO,
     output logic DSO);

 
logic BYP;



MED #(.WIDTH(WIDTH), .NUM(9)) MED1(
     .DI(DI),
     .DSI(DSI),
     .CLK(CLK),
     .BYP(BYP),
     .DO(DO)
 );

//Machine à états finis

logic [3:0] counter;
logic [2:0] state;  
localparam INIT = 3'd0;
localparam S0 = 3'd1;
localparam S1 = 3'd2;
localparam S2 = 3'd3;
localparam S3 = 3'd4;
localparam S4 = 3'd5;
localparam S5 = 3'd6;



always_ff @(posedge CLK or negedge nRST)
begin
    if(!nRST)
    begin
    	counter <= 4'd0;
	state <= INIT;
    end

    else
    
    begin

    if(counter == 4'b1000)
    	counter <= 4'd0;

    else
    	counter <= counter + 4'd1;

    if(state == INIT)
    begin
        state <= (DSI) ? S0 : INIT;
    	counter <= 4'd0;
    end

    else if(state == S5 && counter == 4'd4)
	state <= DSI;
	

    else if(counter == 4'd8)
	state <= state + 3'd1;
    
    end

end



always_comb
begin
    case(state)
        INIT:    {BYP, DSO} = 2'b00;
        S0  :    {BYP, DSO} = (counter <= 4'd7) ? 2'b10 : 2'b00;
        S1  :    {BYP, DSO} = (counter > 4'd7) ? 2'b10 : 2'b00;
        S2  :    {BYP, DSO} = (counter > 4'd6) ? 2'b10 : 2'b00;
        S3  :    {BYP, DSO} = (counter > 4'd5) ? 2'b10 : 2'b00;
        S4  :    {BYP, DSO} = (counter > 4'd4) ? 2'b10 : 2'b00;
	S5  :    {BYP, DSO} = (counter == 4'd4) ? 2'b01 : 2'b00;
        default: {BYP, DSO} = 2'b00;

    endcase

end

endmodule
