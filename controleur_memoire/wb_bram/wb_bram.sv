//-----------------------------------------------------------------
// Wishbone BlockRAM
//-----------------------------------------------------------------
//
// Le paramètre mem_adr_width doit permettre de déterminer le nombre
// de mots de la mémoire : (2048 pour mem_adr_width=11)

module wb_bram #(parameter mem_adr_width = 11) (
      // Wishbone interface
      wshb_if.slave wb_s
      );
      // a vous de jouer a partir d'ici
      logic[3:0][7:0] mem0[0:2**mem_adr_width-1];
      logic[mem_adr_width-1:0] addr;
      logic mem_incr;

      logic ACK_rd, ACK_wr;
      assign wb_s.err = 0;
      assign wb_s.rty = 0;

      always_ff @(posedge wb_s.clk)
      begin

         if(ACK_wr)
          begin
		         if(wb_s.sel[3])
			          mem0[addr][3] <= wb_s.dat_ms[31:24];
             		 if(wb_s.sel[2])
			          mem0[addr][2] <= wb_s.dat_ms[23:16];
		         if(wb_s.sel[1])
			          mem0[addr][1] <= wb_s.dat_ms[15:8];
		         if(wb_s.sel[0])
			          mem0[addr][0] <= wb_s.dat_ms[7:0];
	        end

    		     wb_s.dat_sm <= mem0[addr];
      end


      //Signal ACK pour la lecture
      always_ff @(posedge wb_s.clk)
      begin
	      if(wb_s.rst || (ACK_rd && !(wb_s.cti == 3'b010 || wb_s.cti == 3'b001)))
		      ACK_rd <= 0;
	      else if(!wb_s.we && wb_s.stb)
		      ACK_rd <= 1;
      end



      always_ff @(posedge wb_s.clk)
      begin
          if(wb_s.cti == 3'b010 && !wb_s.we)
            mem_incr <= 1;
          else
            mem_incr <= 0;
      end

      //Signal ACK pour l'écriture
      assign ACK_wr = (wb_s.we && wb_s.stb);


      //Signal ACK final
      assign wb_s.ack = ACK_wr || ACK_rd;


      //Increment d'adresse
      assign addr = wb_s.adr[mem_adr_width+1:2] + mem_incr;


      endmodule
