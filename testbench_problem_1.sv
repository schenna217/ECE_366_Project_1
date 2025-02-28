// Code your testbench here
module four_bit_RCA_RCS_tb;
 
  reg [3:0] A, B; 
  reg Cin;       
  wire [3:0] S; 
  wire Cout;     
 
  four_bit_RCA_RCS uut (
    .A(A),
    .B(B),
    .Cin(Cin),
    .S(S),
    .Cout(Cout)
  );

  // Test procedure
  initial begin 
    $display("| A    B    Cin   | S    Cout | Operation");
    
    // Unsigned Addition Test Cases
    A = 4'b0011; B = 4'b0001; Cin = 0; #10; 
    $display("| %b  %b  %b   | %b  %b   | Addition", A, B, Cin, S, Cout);
    A = 4'b0110; B = 4'b0011; Cin = 0; #10;
    $display("| %b  %b  %b   | %b  %b   | Addition", A, B, Cin, S, Cout);
    A = 4'b1111; B = 4'b0001; Cin = 0; #10;
    $display("| %b  %b  %b   | %b  %b   | Addition", A, B, Cin, S, Cout);

    // Unsigned Subtraction Test Cases
    A = 4'b0110; B = 4'b0011; Cin = 1; #10;
    $display("| %b  %b  %b   | %b  %b   | Subtraction", A, B, Cin, S, Cout);
    A = 4'b1000; B = 4'b0111; Cin = 1; #10;
    $display("| %b  %b  %b   | %b  %b   | Subtraction", A, B, Cin, S, Cout);
    A = 4'b0011; B = 4'b1000; Cin = 1; #10;
    $display("| %b  %b  %b   | %b  %b   | Subtraction", A, B, Cin, S, Cout);
   
    // Signed Addition Test Cases
    A = 4'b1100; B = 4'b0100; Cin = 0; #10;
    $display("| %b  %b  %b   | %b  %b   | Addition", A, B, Cin, S, Cout);
    A = 4'b1010; B = 4'b0110; Cin = 0; #10;
    $display("| %b  %b  %b   | %b  %b   | Addition", A, B, Cin, S, Cout);

    // Signed Subtraction Test Cases
    A = 4'b0110; B = 4'b1010; Cin = 1; #10;
    $display("| %b  %b  %b   | %b  %b   | Subtraction", A, B, Cin, S, Cout);
    A = 4'b1101; B = 4'b0100; Cin = 1; #10;
    $display("| %b  %b  %b   | %b  %b   | Subtraction", A, B, Cin, S, Cout);

    $finish;
  end
 
endmodule