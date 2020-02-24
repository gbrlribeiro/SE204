module vga #(parameter HDISP = 800,
	     parameter VDISP = 480)
	   (input pixel_clk,
	   input pixel_rst,
	   wshb_if.master wshb_ifm,
	   video_if.master video_ifm);
	   

localparam HFP = 40;       //Horizontal Front Porch
localparam HPULSE = 48;    //Largeur de la synchro ligne
localparam HBP = 40;       //Horizontal Back Porch
localparam VFP = 13;	   //Vertical Front Porch
localparam VPULSE = 3;     //Largeur de la synchro image
localparam VBP = 29;       //Vertical Back Porch



//assign wshb_ifm.dat_ms = 32'hBABECAFE;
assign wshb_ifm.sel = 4'b0111;
assign wshb_ifm.we = '0;
assign wshb_ifm.cti = '0;
assign wshb_ifm.bte = '0;



assign video_ifm.CLK = pixel_clk;

//Processus pour les compteurs de pixels et de lignes

logic[$clog2(HFP+HPULSE+HBP+HDISP)-1:0] HDcompt;
logic[$clog2(VFP+VPULSE+VBP+VDISP)-1:0] VDcompt;
logic verBLANK, horBLANK;

//Compteur pour les pixels

always_ff @(posedge pixel_clk or posedge pixel_rst)

	if(pixel_rst)
	begin
		HDcompt <= 0;
		horBLANK <= 0;
	end
	
	else
	begin
		if(HDcompt == HDISP + HFP + HPULSE + HBP - 1)
			HDcompt <= 0;

		else
			HDcompt <= HDcompt +1;

		horBLANK <= (HDcompt >= HFP + HPULSE + HBP -1 && HDcompt < HDISP + HFP + HPULSE + HBP -1);
	end

//Compteur pour les lignes

always_ff @(posedge pixel_clk or posedge pixel_rst)
	if(pixel_rst)
	begin
		VDcompt <= 0;
		verBLANK <= 0;
	end

	else
	begin
		if(VDcompt == VFP + VPULSE + VBP + VDISP - 1)
			VDcompt <= 0;

		else
		begin
			if(HDcompt == HDISP + HFP + HBP + HPULSE -1) //Changer de ligne après avoir compté tous les pixels d'une ligne
				VDcompt <= VDcompt +1;
		end

		verBLANK <= (VDcompt >= VFP + VPULSE + VBP-1 && VDcompt < VDISP + VFP + VPULSE + VBP -1);
	end

//Processus pour générer les signaux BLANK, VS et HS
//En utilisant les compteurs de pixels et lignes

assign video_ifm.BLANK = verBLANK & horBLANK;

always_ff @(posedge pixel_clk)
begin
	video_ifm.HS <= !(HDcompt >= HFP-1 && HDcompt < HFP + HPULSE-1);
	video_ifm.VS <= !(VDcompt >= VFP-1 && VDcompt < VFP + VPULSE-1);
end


//Instance de la FIFO asynchrone

logic fifo_read, fifo_write, fifo_wfull, fifo_almost_full, fifo_rempty;
logic [31:0] fifo_rdata, fifo_wdata;

async_fifo #(.DATA_WIDTH(32), .DEPTH_WIDTH(8), .ALMOST_FULL_THRESHOLD(224)) I_FIFO(
	.rst(wshb_ifm.rst),
	.rclk(pixel_clk),
	.read(fifo_read),
	.rdata(fifo_rdata),
	.rempty(fifo_rempty),
	.wclk(wshb_ifm.clk),
	.wdata(fifo_wdata),
	.write(fifo_write),
	.wfull(fifo_wfull),
	.walmost_full(fifo_almost_full)
);


//Processus pour la Lecture SDRAM


always_ff @(posedge wshb_ifm.clk or posedge wshb_ifm.rst)
begin
	if(wshb_ifm.rst)
		wshb_ifm.adr <= 0;
	else
	begin
		if(wshb_ifm.ack == 1)
		begin
			if(wshb_ifm.adr == 4*(VDISP*HDISP -1))
			begin
				wshb_ifm.adr <= 0;
			end
			else
			begin
				wshb_ifm.adr <= wshb_ifm.adr + 4;
			end
		end
	end
end


assign fifo_write = wshb_ifm.ack; //écrire si donnée reçue
assign wshb_ifm.stb = wshb_ifm.cyc;
assign fifo_wdata = wshb_ifm.dat_sm;

logic cyc_en;
assign wshb_ifm.cyc = cyc_en & !fifo_wfull;


//Signal CYC pour partie 5
always_ff @(posedge wshb_ifm.clk or posedge wshb_ifm.rst)
	if(wshb_ifm.rst)
		cyc_en <= 1;
	else
	begin
		if(!fifo_almost_full)
			cyc_en <= 1;
		if(fifo_wfull)
			cyc_en <= 0;
	end



//Lecture FIFO
logic wfull_pixel;
logic fifo_deja_pleine;
assign video_ifm.RGB = fifo_rdata[23:0];

assign fifo_read = video_ifm.BLANK && fifo_deja_pleine && !fifo_rempty ; //Lire les données si en zone active et si la FIFO a été pleine au moins une fois

logic wfull1;

//Changement de domaine du signal wfull
always_ff @(posedge pixel_clk or posedge pixel_rst)
begin
	if(pixel_rst)
	begin
		wfull1 <= 0;
		wfull_pixel <= 0;
	end
	else
	begin
		wfull1 <= fifo_wfull;
		wfull_pixel <= wfull1;
	end

end

//Processus pour vérifier que la FIFO a été pleine

always_ff @(posedge pixel_clk or posedge pixel_rst)
begin
	if(pixel_rst)
		fifo_deja_pleine <= 0;
	else
		if(wfull_pixel && !video_ifm.VS && !video_ifm.HS)
			fifo_deja_pleine <= 1;
end

endmodule

