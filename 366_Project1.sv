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
  
  assign P = A | B;
  assign G = A & B;
  
  wire [7:0] R1, R2, R3, R4; // Block-level signals
  
  // Block level signals for first row
  assign R1[0] = G[0] | (P[0] & Cin);
  assign R1[1] = G[2] | (P[2] & G[1]);
  assign R1[2] = G[4] | (P[4] & G[3]);
  assign R1[3] = G[6] | (P[6] & G[5]);
  assign R1[4] = G[8] | (P[8] & G[7]);
  assign R1[5] = G[10] | (P[10] & G[9]);
  assign R1[6] = G[12] | (P[12] & G[11]);
  assign R1[7] = G[14] | (P[14] & G[13]);
  
  // Block level signals for second row
  assign R2[0] = G[1] | (P[1] & R1[0]);
  assign R2[1] = R1[1] | (R1[1] & R1[0]);
  assign R2[2] = G[5] | (P[5] & R1[2]);
  assign R2[3] = R1[3] | (R1[3] & R1[2]);
  assign R2[4] = G[9] | (P[9] & R1[4]);
  assign R2[5] = R1[5] | (R1[5] & R1[4]);
  assign R2[6] = G[13] | (P[13] & R1[6]);
  assign R2[7] = R1[7] | (R1[7] & R1[6]);
  
  // Block level signals for third row
  assign R3[0] = G[3] | (P[3] & R2[1]);
  assign R3[1] = R1[2] | (R1[2] & R2[1]);
  assign R3[2] = R2[2] | (R2[2] & R2[1]);
  assign R3[3] = R2[3] | (R2[3] & R2[1]);
  assign R3[4] = G[11] | (P[11] & R2[5]);
  assign R3[5] = R1[6] | (R1[6] & R2[5]);
  assign R3[6] = R2[6] | (R2[6] & R2[5]);
  assign R3[7] = R2[7] | (R2[7] & R2[5]);
  
  // Block level signals for fourth row
  assign R4[0] = G[7] | (P[7] & R3[3]);
  assign R4[1] = R1[4] | (R1[4] & R3[3]);
  assign R4[2] = R2[4] | (R2[4] & R3[3]);
  assign R4[3] = R2[5] | (R2[5] & R3[3]);
  assign R4[4] = R3[4] | (R3[4] & R3[3]);
  assign R4[5] = R3[5] | (R3[5] & R3[3]);
  assign R4[6] = R3[6] | (R3[6] & R3[3]);
  assign R4[7] = R3[7] | (R3[7] & R3[3]);
  
  // Final assignments for G_(k-1):j
  assign G_Block[0] = Cin;
  assign G_Block[1] = R1[0];
  assign G_Block[2] = R2[0];
  assign G_Block[3] = R2[1];
  assign G_Block[4] = R3[0];
  assign G_Block[5] = R3[1];
  assign G_Block[6] = R3[2];
  assign G_Block[7] = R3[3];
  assign G_Block[8] = R4[0];
  assign G_Block[9] = R4[1];
  assign G_Block[10] = R4[2];
  assign G_Block[11] = R4[3];
  assign G_Block[12] = R4[4];
  assign G_Block[13] = R4[5];
  assign G_Block[14] = R4[6];
  assign G_Block[15] = R4[7];
  
  assign S = G_Block ^ (A ^ B);
  assign Cout = G_Block[15];
  
endmodule
