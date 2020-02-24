`default_nettype none

module Top #(parameter HDISP = 800,
 	     parameter VDISP = 480)
(
    // Les signaux externes de la partie FPGA
	input  wire         FPGA_CLK1_50,
	input  wire  [1:0]	KEY,
	output logic [7:0]	LED,
	input  wire	 [3:0]	SW,
    // Les signaux du support matériel son regroupés dans une interface
    	hws_if.master       hws_ifm,
    	video_if.master video_ifm
);

//====================================
//  Déclarations des signaux internes
//====================================
  wire        sys_rst;   // Le signal de reset du système
  wire        sys_clk;   // L'horloge système a 100Mhz
  wire        pixel_clk; // L'horloge de la video 32 Mhz

//=======================================================
//  La PLL pour la génération des horloges
//=======================================================

sys_pll  sys_pll_inst(
		   .refclk(FPGA_CLK1_50),   // refclk.clk
		   .rst(1'b0),              // pas de reset
		   .outclk_0(pixel_clk),    // horloge pixels a 32 Mhz
		   .outclk_1(sys_clk)       // horloge systeme a 100MHz
);

//=============================
//  Les bus Wishbone internes
//=============================
wshb_if #( .DATA_BYTES(4)) wshb_if_sdram  (sys_clk, sys_rst);
wshb_if #( .DATA_BYTES(4)) wshb_if_stream (sys_clk, sys_rst);

//=============================
//  Le support matériel
//=============================
hw_support hw_support_inst (
    .wshb_ifs (wshb_if_sdram),
    .wshb_ifm (wshb_if_stream),
    .hws_ifm  (hws_ifm),
	.sys_rst  (sys_rst), // output
    .SW_0     ( SW[0] ),
    .KEY      ( KEY )
 );

//=============================
// On neutralise l'interface
// du flux video pour l'instant
// A SUPPRIMER PLUS TARD
//=============================

//=============================
// On neutralise l'interface SDRAM
// pour l'instant
// A SUPPRIMER PLUS TARD
//=============================
/*
assign wshb_if_sdram.stb  = 1'b0;
assign wshb_if_sdram.cyc  = 1'b0;
assign wshb_if_sdram.we   = 1'b0;
assign wshb_if_sdram.adr  = '0  ;
assign wshb_if_sdram.dat_ms = '0 ;
assign wshb_if_sdram.sel = '0 ;
assign wshb_if_sdram.cti = '0 ;
assign wshb_if_sdram.bte = '0 ;
*/

//--------------------------
//------- Code Eleves ------
//--------------------------


//Bus Wishbone PARTIE 4

wshb_if #(.DATA_BYTES(4)) wshb_if_vga (sys_clk, sys_rst);

//Instance de l'arbitre
wshb_intercon INTERCON_I (
	.wshb_ifm(wshb_if_sdram),
	.wshb_ifs_mire(wshb_if_stream),
	.wshb_ifs_vga(wshb_if_vga));



`ifdef SIMULATION
  localparam hcmpt=50;
  localparam hcmpt2=16;
`else
  localparam hcmpt=50000000;
  localparam hcmpt2=16000000;
`endif

assign LED[0] = KEY[0];
logic[31:0]compteur;


//Processus pour faire clignoter à 1Hz le LED 1
always_ff @(posedge sys_clk or posedge sys_rst)
begin
	if(sys_rst)
	begin
		compteur <= 0;
		LED[1] <= 0;		
	end
	else if(compteur == hcmpt)
	begin
		LED[1] <= ~LED[1];
		compteur <= 0;
	end

	else
		compteur <= compteur +1;

end

logic pixel_rst;
logic D1, D2, Q1;
assign D1 = 0;
assign D2 = Q1;

logic[31:0] compteur2;

//Processus pour reset dans le domaine d'horloge pixel_clk
always_ff @(posedge pixel_clk or posedge sys_rst)
begin

	if(sys_rst)
	begin
		Q1 <= 1;
		pixel_rst <= 1;
	end

	else
	begin
		Q1 <= D1;
		pixel_rst <= D2;
	end
	
end

//Processus pour faire clignoter à 1Hz le LED 2
always_ff @(posedge pixel_clk or posedge pixel_rst)
begin

	if(pixel_rst)
	begin
		compteur2 <= 0;
		LED[2] <= 0;
	end

	else if(compteur2 == hcmpt2)
	begin
		LED[2] <= ~LED[2];
		compteur2 <= 0;
	end

	else
		compteur2 <= compteur2 +1;

end

vga #(.HDISP (HDISP), .VDISP(VDISP)) I_VGA(
	.pixel_clk(pixel_clk),
	.pixel_rst(pixel_rst),
	.video_ifm(video_ifm),
	.wshb_ifm(wshb_if_vga)
	);




endmodule
