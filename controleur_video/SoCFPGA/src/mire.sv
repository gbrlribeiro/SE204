module mire #(parameter HDISP = 800 ,
	      parameter VDISP = 480 )
	   (wshb_if.master wshb_ifm);
	
logic [5:0]compt_main; //Compteur pour laisser la main chaque 64 cycles

logic cyc_sg;


//Processus pour compter et laisser la main a chaque 64 cycles
always_ff @(posedge wshb_ifm.clk or posedge wshb_ifm.rst)
	if(wshb_ifm.rst)
	begin
		compt_main <= 0;
		cyc_sg <= 0;
	end

	else
	begin
		if(compt_main == 63)
		begin
			compt_main <= 0;
			cyc_sg <= 0;
		end
		else
			cyc_sg <= 1;
		if(wshb_ifm.ack)
			compt_main <= compt_main +1;
	end


//Compteur de pixels et lignes
logic [$clog2(HDISP)-1:0] pix_cmpt;
logic [$clog2(VDISP)-1:0] line_cmpt;

//Processus pour compter pixels et lignes
always_ff @(posedge wshb_ifm.clk or posedge wshb_ifm.rst)
	if(wshb_ifm.rst)
	begin
		pix_cmpt <= 0;
		line_cmpt <= 0;
	end
	else if(wshb_ifm.ack)
	begin
		if(pix_cmpt == HDISP-1)
		begin
			pix_cmpt <= 0;
			if(line_cmpt == VDISP -1)
				line_cmpt <= 0;
			else
				line_cmpt <= line_cmpt +1;
		end
		else
			pix_cmpt <= pix_cmpt +1;
	end



//Processus pour incrementer l'adresse
always_ff @(posedge wshb_ifm.clk or posedge wshb_ifm.rst)
	if(wshb_ifm.rst)
		wshb_ifm.adr <= 0;
	else if(wshb_ifm.ack)
		if(wshb_ifm.adr == 4*(HDISP*VDISP -1))
			wshb_ifm.adr <= '0;
		else
			wshb_ifm.adr <= wshb_ifm.adr + 4;



assign wshb_ifm.cti = '0;
assign wshb_ifm.bte = '0;
assign wshb_ifm.we = 1'b1;
assign wshb_ifm.sel = 4'b1111;

//Cyc et Stb passent à 0 chaque fois que le compteur passe à 0
assign wshb_ifm.cyc = cyc_sg;
assign wshb_ifm.stb = cyc_sg;




assign wshb_ifm.dat_ms = ((line_cmpt % 16 == 0) || (pix_cmpt % 16 == 0)) ? 32'h00ffffff : 32'h00000000;

endmodule
