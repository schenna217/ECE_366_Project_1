module one_bit_full_adder_behav(A, B, Cin, S, Cout);
  input A, B, Cin;
  output S, Cout;
  
  assign S = A ^ B ^ Cin;
  assign Cout = (A & B) | (A & Cin) | (B & Cin);
  
endmodule

module one_bit_full_adder_struc(A, B, Cin, S, Cout);
  input A, B, Cin;
  output S, Cout;
  
  wire x1, x2, x3, x4;
  
  xor g1(x1, A, B);
  xor g2(S, x1, Cin);
  
  and g3(x2, A, B);
  and g4(x3, A, Cin);
  and g5(x4, B, Cin);
  
  or  g6(Cout, x2, x3, x4);
  
endmodule

module four_bit_RCA(A, B, Cin, S, Cout);
  input [3:0] A, B;
  input Cin;
  output [3:0] S;
  output Cout;
  
  wire C1, C2, C3;

  one_bit_full_adder_behav FA0 (A[0], B[0], Cin,  S[0], C1);
  one_bit_full_adder_behav FA1 (A[1], B[1], C1,   S[1], C2);
  one_bit_full_adder_behav FA2 (A[2], B[2], C2,   S[2], C3);
  one_bit_full_adder_behav FA3 (A[3], B[3], C3,   S[3], Cout);

endmodule

module four_bit_RCA_RCS(A, B, Cin, S, Cout);
  input [3:0] A, B;
  input Cin;
  output [3:0] S;
  output Cout;
  
  wire [3:0] B_xor_Cin;
  wire C1, C2, C3;

  // XOR B with Cin for 2's compliment if cin is 1
  assign B_xor_Cin = B ^ {4{Cin}};

  one_bit_full_adder_behav FA0 (A[0], B_xor_Cin[0], Cin,  S[0], C1);
  one_bit_full_adder_behav FA1 (A[1], B_xor_Cin[1], C1,   S[1], C2);
  one_bit_full_adder_behav FA2 (A[2], B_xor_Cin[2], C2,   S[2], C3);
  one_bit_full_adder_behav FA3 (A[3], B_xor_Cin[3], C3,   S[3], Cout);

endmodule

module CLA(A, B, Cin, S, Cout);
  
  input [31:0] A, B;
  input Cin;
  output [31:0] S;
  output Cout;

  wire [31:0] G, P;  // Generate and Propagate
  wire [7:0] C;      // Carry for the first 28 bits
  
  assign C[0] = Cin;
  assign G = A & B;
  assign P = A | B;

  // First 7 blocks use 4-bit Carry Lookahead logic
  genvar i;
  generate
    for (i = 0; i < 7; i = i + 1) begin : CLA_BLOCKS
      four_bit_RCA RCA (A[4*i +: 4], B[4*i +: 4], C[i], S[4*i +: 4], Cout);

      // Compute carry for the next carry using CLA logic
      assign C[i+1] = ((((((G[4*i] & P[4*i+1]) | G[4*i+1]) & P[4*i+2]) | G[4*i+2]) & P[4*i+3]) | G[4*i+3]) | ((P[4*i] & P[4*i+1] & P[4*i+2] & P[4*i+3]) & C[i]);
    end
  endgenerate

  // Final 4-bit block uses a Ripple Carry Adder
  four_bit_RCA final_RCA (A[31:28], B[31:28], C[7], S[31:28], Cout);

endmodule

module PPA(A, B, Cin, S, Cout);

  input [15:0] A, B; 
  input Cin;
  output [15:0] S;
  output Cout;

  wire [15:0] P, G; // Propagate and Generate signals
  wire [15:0] G_Block; // G_(k-1):j
  
  assign P = A | B; // Correct propagate signal
  assign G = A & B; // Generate signal
  
  wire [7:0] RP1, RP2, RP3, RP4; // Block-level propagate signals
  wire [7:0] RG1, RG2, RG3, RG4; // Block-level generate signals
  
  // Block level signals for first row
  assign RG1[0] = G[0] | (P[0] & Cin);
  assign RP1[0] = P[0] & 0;
    
  assign RG1[1] = G[2] | (P[2] & G[1]);
  assign RP1[1] = P[2] & P[1];
    
  assign RG1[2] = G[4] | (P[4] & G[3]);
  assign RP1[2] = P[4] & P[3];
    
  assign RG1[3] = G[6] | (P[6] & G[5]);
  assign RP1[3] = P[6] & P[5];
    
  assign RG1[4] = G[8] | (P[8] & G[7]);
  assign RP1[4] = P[8] & P[7];
    
  assign RG1[5] = G[10] | (P[10] & G[9]);
  assign RP1[5] = P[10] & P[9];
    
  assign RG1[6] = G[12] | (P[12] & G[11]);
  assign RP1[6] = P[12] & P[11];
    
  assign RG1[7] = G[14] | (P[14] & G[13]);
  assign RP1[7] = P[14] & P[13];
  
  // Block level signals for second row
  assign RG2[0] = G[1] | (P[1] & RG1[0]);
  assign RP2[0] = P[1] & RP1[0];
    
  assign RG2[1] = RG1[1] | (RP1[1] & RG1[0]);
  assign RP2[1] = RP1[1] & RP1[0];
  
  assign RG2[2] = G[5] | (P[5] & RG1[2]);
  assign RP2[2] = P[5] & RP1[2];
  
  assign RG2[3] = RG1[3] | (RP1[3] & RG1[2]);
  assign RP2[3] = RP1[3] & RP1[2];
  
  assign RG2[4] = G[9] | (P[9] & RG1[4]);
  assign RP2[4] = P[9] & RP1[4];
  
  assign RG2[5] = RG1[5] | (RP1[5] & RG1[4]);
  assign RP2[5] = RP1[5] & RP1[4];
  
  assign RG2[6] = G[13] | (P[13] & RG1[6]);
  assign RP2[6] = P[13] & RP1[6];
  
  assign RG2[7] = RG1[7] | (RP1[7] & RG1[6]);
  assign RP2[7] = RP1[7] & RP1[6];
  
  // Block level signals for third row
  assign RG3[0] = G[3] | (P[3] & RG2[1]);
  assign RP3[0] = P[3] & RP2[1];
  
  assign RG3[1] = RG1[2] | (RP1[2] & RG2[1]);
  assign RP3[1] = RP1[2] & RP2[1];
  
  assign RG3[2] = RG2[2] | (RP2[2] & RG2[1]);
  assign RP3[2] = RP2[2] & RP2[1];
  
  assign RG3[3] = RG2[3] | (RP2[3] & RG2[1]);
  assign RP3[3] = RP2[3] & RP2[1];
  
  assign RG3[4] = G[11] | (P[11] & RG2[5]);
  assign RP3[4] = P[11] & RP2[5];
  
  assign RG3[5] = RG1[6] | (RP1[6] & RG2[5]);
  assign RP3[5] = RP1[6] & RP2[5];
  
  assign RG3[6] = RG2[6] | (RP2[6] & RG2[5]);
  assign RP3[6] = RP2[6] & RP2[5];
  
  assign RG3[7] = RG2[7] | (RP2[7] & RG2[5]);
  assign RP3[7] = RP2[7] & RP2[5];
  
  // Block level signals for fourth row
  assign RG4[0] = G[7] | (P[7] & RG3[3]);
  assign RP4[0] = P[7] & RP3[3];
  
  assign RG4[1] = RG1[4] | (RP1[4] & RG3[3]);
  assign RP4[1] = RP1[4] & RP3[3];
  
  assign RG4[2] = RG2[4] | (RP2[4] & RG3[3]);
  assign RP4[2] = RP2[4] & RP3[3];
  
  assign RG4[3] = RG2[5] | (RP2[5] & RG3[3]);
  assign RP4[3] = RP2[5] & RP3[3];
  
  assign RG4[4] = RG3[4] | (RP3[4] & RG3[3]);
  assign RP4[4] = RP3[4] & RP3[3];
  
  assign RG4[5] = RG3[5] | (RP3[5] & RG3[3]);
  assign RP4[5] = RP3[5] & RP3[3];
  
  assign RG4[6] = RG3[6] | (RP3[6] & RG3[3]);
  assign RP4[6] = RP3[6] & RP3[3];
  
  assign RG4[7] = RG3[7] | (RP3[7] & RG3[3]);
  assign RP4[7] = RP3[7] & RP3[3];
  
  // Final assignments for G_(k-1):j
  assign G_Block[0] = Cin;
  assign G_Block[1] = RG1[0];
  assign G_Block[2] = RG2[0];
  assign G_Block[3] = RG2[1];
  assign G_Block[4] = RG3[0];
  assign G_Block[5] = RG3[1];
  assign G_Block[6] = RG3[2];
  assign G_Block[7] = RG3[3];
  assign G_Block[8] = RG4[0];
  assign G_Block[9] = RG4[1];
  assign G_Block[10] = RG4[2];
  assign G_Block[11] = RG4[3];
  assign G_Block[12] = RG4[4];
  assign G_Block[13] = RG4[5];
  assign G_Block[14] = RG4[6];
  assign G_Block[15] = RG4[7];
  
  assign S = G_Block ^ (A ^ B);
  assign Cout = G[15] | (P[15] & RG4[7]);
  
endmodule
