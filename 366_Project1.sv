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
