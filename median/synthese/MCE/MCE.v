//
// Verilog description for cell MCE, 
// Wed Dec  4 18:27:28 2019
//
// Precision RTL Synthesis, 64-bit 2017.1.0.15//


module MCE ( A, B, MAX, MIN ) ;

    input [7:0]A ;
    input [7:0]B ;
    output [7:0]MAX ;
    output [7:0]MIN ;

    wire nx64574z1, nx64574z8, nx64574z7, nx64574z6, nx64574z5, nx64574z4, 
         nx64574z3, nx64574z2, nx_MCE_vcc_net;
    wire [64:0] xmplr_dummy ;




    cycloneii_lcell_comb ix64574z52924 (.combout (nx64574z1), .dataa (B[7]), .datab (
                         A[7]), .datac (1'b1), .datad (nx_MCE_vcc_net), .cin (
                         nx64574z2)) ;
                         defparam ix64574z52924.lut_mask = 16'hd4d4;
                         defparam ix64574z52924.sum_lutc_input = "cin";
    assign nx_MCE_vcc_net = 1'b1 ;
    cycloneii_lcell_comb ix64574z52926 (.cout (nx64574z2), .dataa (B[6]), .datab (
                         A[6]), .datac (1'b1), .datad (nx_MCE_vcc_net), .cin (
                         nx64574z3)) ;
                         defparam ix64574z52926.lut_mask = 16'h00d4;
                         defparam ix64574z52926.sum_lutc_input = "cin";
    cycloneii_lcell_comb ix64574z52927 (.cout (nx64574z3), .dataa (B[5]), .datab (
                         A[5]), .datac (1'b1), .datad (nx_MCE_vcc_net), .cin (
                         nx64574z4)) ;
                         defparam ix64574z52927.lut_mask = 16'h00d4;
                         defparam ix64574z52927.sum_lutc_input = "cin";
    cycloneii_lcell_comb ix64574z52928 (.cout (nx64574z4), .dataa (B[4]), .datab (
                         A[4]), .datac (1'b1), .datad (nx_MCE_vcc_net), .cin (
                         nx64574z5)) ;
                         defparam ix64574z52928.lut_mask = 16'h00d4;
                         defparam ix64574z52928.sum_lutc_input = "cin";
    cycloneii_lcell_comb ix64574z52929 (.cout (nx64574z5), .dataa (B[3]), .datab (
                         A[3]), .datac (1'b1), .datad (nx_MCE_vcc_net), .cin (
                         nx64574z6)) ;
                         defparam ix64574z52929.lut_mask = 16'h00d4;
                         defparam ix64574z52929.sum_lutc_input = "cin";
    cycloneii_lcell_comb ix64574z52930 (.cout (nx64574z6), .dataa (B[2]), .datab (
                         A[2]), .datac (1'b1), .datad (nx_MCE_vcc_net), .cin (
                         nx64574z7)) ;
                         defparam ix64574z52930.lut_mask = 16'h00d4;
                         defparam ix64574z52930.sum_lutc_input = "cin";
    cycloneii_lcell_comb ix64574z52931 (.cout (nx64574z7), .dataa (B[1]), .datab (
                         A[1]), .datac (1'b1), .datad (nx_MCE_vcc_net), .cin (
                         nx64574z8)) ;
                         defparam ix64574z52931.lut_mask = 16'h00d4;
                         defparam ix64574z52931.sum_lutc_input = "cin";
    cycloneii_lcell_comb ix64574z52932 (.cout (nx64574z8), .dataa (A[0]), .datab (
                         B[0]), .datac (1'b1), .datad (nx_MCE_vcc_net)) ;
                         defparam ix64574z52932.lut_mask = 16'h0022;
    cycloneii_lcell_comb ix35169z52923 (.combout (MIN[0]), .dataa (A[0]), .datab (
                         B[0]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix35169z52923.lut_mask = 16'hcaca;
    cycloneii_lcell_comb ix36166z52923 (.combout (MIN[1]), .dataa (A[1]), .datab (
                         B[1]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix36166z52923.lut_mask = 16'hcaca;
    cycloneii_lcell_comb ix37163z52923 (.combout (MIN[2]), .dataa (A[2]), .datab (
                         B[2]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix37163z52923.lut_mask = 16'hcaca;
    cycloneii_lcell_comb ix38160z52923 (.combout (MIN[3]), .dataa (A[3]), .datab (
                         B[3]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix38160z52923.lut_mask = 16'hcaca;
    cycloneii_lcell_comb ix39157z52923 (.combout (MIN[4]), .dataa (A[4]), .datab (
                         B[4]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix39157z52923.lut_mask = 16'hcaca;
    cycloneii_lcell_comb ix40154z52923 (.combout (MIN[5]), .dataa (A[5]), .datab (
                         B[5]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix40154z52923.lut_mask = 16'hcaca;
    cycloneii_lcell_comb ix41151z52923 (.combout (MIN[6]), .dataa (A[6]), .datab (
                         B[6]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix41151z52923.lut_mask = 16'hcaca;
    cycloneii_lcell_comb ix42148z52923 (.combout (MIN[7]), .dataa (A[7]), .datab (
                         B[7]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix42148z52923.lut_mask = 16'hcaca;
    cycloneii_lcell_comb ix57595z52923 (.combout (MAX[0]), .dataa (A[0]), .datab (
                         B[0]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix57595z52923.lut_mask = 16'hacac;
    cycloneii_lcell_comb ix58592z52923 (.combout (MAX[1]), .dataa (A[1]), .datab (
                         B[1]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix58592z52923.lut_mask = 16'hacac;
    cycloneii_lcell_comb ix59589z52923 (.combout (MAX[2]), .dataa (A[2]), .datab (
                         B[2]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix59589z52923.lut_mask = 16'hacac;
    cycloneii_lcell_comb ix60586z52923 (.combout (MAX[3]), .dataa (A[3]), .datab (
                         B[3]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix60586z52923.lut_mask = 16'hacac;
    cycloneii_lcell_comb ix61583z52923 (.combout (MAX[4]), .dataa (A[4]), .datab (
                         B[4]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix61583z52923.lut_mask = 16'hacac;
    cycloneii_lcell_comb ix62580z52923 (.combout (MAX[5]), .dataa (A[5]), .datab (
                         B[5]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix62580z52923.lut_mask = 16'hacac;
    cycloneii_lcell_comb ix63577z52923 (.combout (MAX[6]), .dataa (A[6]), .datab (
                         B[6]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix63577z52923.lut_mask = 16'hacac;
    cycloneii_lcell_comb ix64574z52923 (.combout (MAX[7]), .dataa (A[7]), .datab (
                         B[7]), .datac (nx64574z1), .datad (1'b1)) ;
                         defparam ix64574z52923.lut_mask = 16'hacac;
endmodule

