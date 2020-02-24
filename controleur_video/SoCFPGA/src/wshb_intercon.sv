module wshb_intercon #(parameter HDISP = 800,
			parameter VDISP = 480)
		      (wshb_if.master wshb_ifm,
		       wshb_if.slave wshb_ifs_mire,
		       wshb_if.slave wshb_ifs_vga);
	      
//0 si VGA
//1 si MIRE	
logic jeton;

always_ff @(posedge wshb_ifm.clk or posedge wshb_ifm.rst)
	if(wshb_ifm.rst)
		jeton <= 1;
	else
	begin
		if(jeton == 1 && wshb_ifs_mire.cyc == 0)
			jeton <= 0;
		else if(jeton == 0 && wshb_ifs_vga.cyc == 0)
			jeton <= 1;
	end



//Processus combinatoire pour faire l'arbitrage entre les signaux de VGA ou de
//la mire

assign wshb_ifm.cyc = (jeton) ? wshb_ifs_mire.cyc : wshb_ifs_vga.cyc;
assign wshb_ifm.stb = (jeton) ? wshb_ifs_mire.stb : wshb_ifs_vga.stb;
assign wshb_ifm.adr = (jeton) ? wshb_ifs_mire.adr : wshb_ifs_vga.adr;
assign wshb_ifm.we = (jeton) ? wshb_ifs_mire.we : wshb_ifs_vga.we;
assign wshb_ifm.dat_ms = (jeton) ? wshb_ifs_mire.dat_ms : wshb_ifs_vga.dat_ms;
assign wshb_ifm.sel = (jeton) ? wshb_ifs_mire.sel : wshb_ifs_vga.sel;
assign wshb_ifm.cti = (jeton) ? wshb_ifs_mire.cti : wshb_ifs_vga.cti;
assign wshb_ifm.bte = (jeton) ? wshb_ifs_mire.bte : wshb_ifs_vga.bte;


assign wshb_ifs_mire.err = '0;
assign wshb_ifs_mire.rty = '0;
assign wshb_ifs_mire.ack = (wshb_ifm.ack && jeton == 1);
assign wshb_ifs_mire.dat_sm = wshb_ifm.dat_sm;

assign wshb_ifs_vga.err = '0;
assign wshb_ifs_vga.rty = '0;
assign wshb_ifs_vga.ack = (wshb_ifm.ack && jeton == 0);
assign wshb_ifs_vga.dat_sm = wshb_ifm.dat_sm;


endmodule
