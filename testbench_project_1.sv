module tb;
  reg [3:0] A_4bit, B_4bit;
  reg Cin_4bit;
  wire [3:0] S_4bit;
  wire Cout_4bit;

  reg [31:0] A_32bit, B_32bit;
  reg Cin_32bit;
  wire [31:0] S_32bit;
  wire Cout_32bit;
  
  reg [15:0] A_16bit, B_16bit;
  reg Cin_16bit;
  wire [15:0] S_16bit;
  wire Cout_16bit;

  four_bit_RCA_RCS rca_tb (
    .A(A_4bit),
    .B(B_4bit),
    .Cin(Cin_4bit),
    .S(S_4bit),
    .Cout(Cout_4bit)
  );

  CLA cla_tb (
    .A(A_32bit),
    .B(B_32bit),
    .Cin(Cin_32bit),
    .S(S_32bit),
    .Cout(Cout_32bit)
  );
  
  // Instantiate the 16-bit Parallel Prefix Adder (PPA)
  PPA ppa_tb (
    .A(A_16bit),
    .B(B_16bit),
    .Cin(Cin_16bit),
    .S(S_16bit),
    .Cout(Cout_16bit)
  );

  // Test procedure
  initial begin
    // Run 4-bit RCA_RCS tests
    $display("===== 4-bit RCA_RCS Testbench =====");
    $display("| A    B    Cin   | S    Cout | Operation");
    
    // Unsigned Addition Test Cases
    A_4bit = 4'b0011; B_4bit = 4'b0001; Cin_4bit = 0; #10; 
    $display("| %b  %b  %b   | %b  %b   | Addition", A_4bit, B_4bit, Cin_4bit, S_4bit, Cout_4bit);
    A_4bit = 4'b0110; B_4bit = 4'b0011; Cin_4bit = 0; #10;
    $display("| %b  %b  %b   | %b  %b   | Addition", A_4bit, B_4bit, Cin_4bit, S_4bit, Cout_4bit);
    A_4bit = 4'b1111; B_4bit = 4'b0001; Cin_4bit = 0; #10;
    $display("| %b  %b  %b   | %b  %b   | Addition", A_4bit, B_4bit, Cin_4bit, S_4bit, Cout_4bit);

    // Unsigned Subtraction Test Cases
    A_4bit = 4'b0110; B_4bit = 4'b0011; Cin_4bit = 1; #10;
    $display("| %b  %b  %b   | %b  %b   | Subtraction", A_4bit, B_4bit, Cin_4bit, S_4bit, Cout_4bit);
    A_4bit = 4'b1000; B_4bit = 4'b0111; Cin_4bit = 1; #10;
    $display("| %b  %b  %b   | %b  %b   | Subtraction", A_4bit, B_4bit, Cin_4bit, S_4bit, Cout_4bit);
    A_4bit = 4'b0011; B_4bit = 4'b1000; Cin_4bit = 1; #10;
    $display("| %b  %b  %b   | %b  %b   | Subtraction", A_4bit, B_4bit, Cin_4bit, S_4bit, Cout_4bit);
   
    // Signed Addition Test Cases
    A_4bit = 4'b1100; B_4bit = 4'b0100; Cin_4bit = 0; #10;
    $display("| %b  %b  %b   | %b  %b   | Addition", A_4bit, B_4bit, Cin_4bit, S_4bit, Cout_4bit);
    A_4bit = 4'b1010; B_4bit = 4'b0110; Cin_4bit = 0; #10;
    $display("| %b  %b  %b   | %b  %b   | Addition", A_4bit, B_4bit, Cin_4bit, S_4bit, Cout_4bit);

    // Signed Subtraction Test Cases
    A_4bit = 4'b0110; B_4bit = 4'b1010; Cin_4bit = 1; #10;
    $display("| %b  %b  %b   | %b  %b   | Subtraction", A_4bit, B_4bit, Cin_4bit, S_4bit, Cout_4bit);
    A_4bit = 4'b1101; B_4bit = 4'b0100; Cin_4bit = 1; #10;
    $display("| %b  %b  %b   | %b  %b   | Subtraction", A_4bit, B_4bit, Cin_4bit, S_4bit, Cout_4bit);

    $display("===== End of 4-bit RCA_RCS Testbench =====\n");

    // Run 32-bit CLA tests
    $display("===== 32-bit CLA Testbench =====");
    $display("Test Case N: A =         , B =         , Cin =  , S =         , Cout =  ");
      
    // Test case 0: Zero addition
    A_32bit = 32'h0000_0000; B_32bit = 32'h0000_0000; Cin_32bit = 0; #10;
    $display("Test Case 0: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_32bit, B_32bit, Cin_32bit, S_32bit, Cout_32bit);
      
    // Test case 1: Simple addition
    A_32bit = 32'h0000_0002; B_32bit = 32'h0000_0002; Cin_32bit = 0; #10;
    $display("Test Case 1: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_32bit, B_32bit, Cin_32bit, S_32bit, Cout_32bit);

    // Test case 2: Addition with carry-in
    A_32bit = 32'h0000_0004; B_32bit = 32'h0000_0005; Cin_32bit = 1; #10;
    $display("Test Case 2: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_32bit, B_32bit, Cin_32bit, S_32bit, Cout_32bit);

    // Test case 3: Maximum value addition
    A_32bit = 32'hFFFF_FFFF; B_32bit = 32'h0000_0001; Cin_32bit = 0; #10;
    $display("Test Case 3: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_32bit, B_32bit, Cin_32bit, S_32bit, Cout_32bit);

    // Test case 4: Random addition
    A_32bit = 32'h6758_4132; B_32bit = 32'h3241_5867; Cin_32bit = 0; #10;
    $display("Test Case 4: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_32bit, B_32bit, Cin_32bit, S_32bit, Cout_32bit);

    // Test case 5: Overflow case
    A_32bit = 32'hFFFF_FFFF; B_32bit = 32'hFFFF_FFFF; Cin_32bit = 0; #10;
    $display("Test Case 5: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_32bit, B_32bit, Cin_32bit, S_32bit, Cout_32bit);

    // Test case 6: Large numbers
    A_32bit = 32'h9999_9999; B_32bit = 32'h9999_9999; Cin_32bit = 1; #10;
    $display("Test Case 6: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_32bit, B_32bit, Cin_32bit, S_32bit, Cout_32bit);

    $display("===== End of 32-bit CLA Testbench =====\n");
    
     // Run 32-bit CLA tests
    $display("===== 16-bit PPA Testbench =====");
    $display("Test Case N: A =      , B =      , Cin = , S =      , Cout = ");
 
    // Test case 0: Zero addition (Baseline case)
    A_16bit = 16'h0000; B_16bit = 16'h0000; Cin_16bit = 0; #10;
    $display("Test Case 0: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_16bit, B_16bit, Cin_16bit, S_16bit, Cout_16bit);
 
    // Test case 1: Simple addition
    A_16bit = 16'h0002; B_16bit = 16'h0003; Cin_16bit = 0; #10;
    $display("Test Case 1: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_16bit, B_16bit, Cin_16bit, S_16bit, Cout_16bit);
 
    // Test case 2: Addition with carry-in
    A_16bit = 16'h0004; B_16bit = 16'h0005; Cin_16bit = 1; #10;
    $display("Test Case 2: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_16bit, B_16bit, Cin_16bit, S_16bit, Cout_16bit);
 
    // Test case 3: Maximum value addition (Overflow Case)
    A_16bit = 16'hFFFF; B_16bit = 16'h0001; Cin_16bit = 0; #10;
    $display("Test Case 3: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_16bit, B_16bit, Cin_16bit, S_16bit, Cout_16bit);
 
    // Test case 4: Random addition
    A_16bit = 16'h6758; B_16bit = 16'h3241; Cin_16bit = 0; #10;
    $display("Test Case 4: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_16bit, B_16bit, Cin_16bit, S_16bit, Cout_16bit);
 
    // Test case 5: Overflow scenario (Largest possible values)
    A_16bit = 16'hFFFF; B_16bit = 16'hFFFF; Cin_16bit = 0; #10;
    $display("Test Case 5: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_16bit, B_16bit, Cin_16bit, S_16bit, Cout_16bit);
 
    // Test case 6: Large numbers addition with carry-in
    A_16bit = 16'h9999; B_16bit = 16'h9999; Cin_16bit = 1; #10;
    $display("Test Case 6: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_16bit, B_16bit, Cin_16bit, S_16bit, Cout_16bit);
 
    // **New Test Cases Based on Hints**
 
    // Test case 7: Carry propagation test
    A_16bit = 16'hF0F0; B_16bit = 16'h0F0F; Cin_16bit = 1; #10;
    $display("Test Case 7: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_16bit, B_16bit, Cin_16bit, S_16bit, Cout_16bit);
 
    // Test case 8: Alternating bits pattern
    A_16bit = 16'hAAAA; B_16bit = 16'h5555; Cin_16bit = 0; #10;
    $display("Test Case 8: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_16bit, B_16bit, Cin_16bit, S_16bit, Cout_16bit);
 
    // Test case 9: Checking all ones with carry-in
    A_16bit = 16'hFFFF; B_16bit = 16'h0000; Cin_16bit = 1; #10;
    $display("Test Case 9: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_16bit, B_16bit, Cin_16bit, S_16bit, Cout_16bit);
 
    // Test case 10: Random high-value numbers
    A_16bit = 16'hDEAD; B_16bit = 16'hBEEF; Cin_16bit = 0; #10;
    $display("Test Case A: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A_16bit, B_16bit, Cin_16bit, S_16bit, Cout_16bit);
    
    $display("===== End of 16-bit PPA Testbench =====");
    $finish;
  end

endmodule
