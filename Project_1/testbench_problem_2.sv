module CLA_tb;

  reg [31:0] A, B;
  reg Cin;

  wire [31:0] S; 
  wire Cout;
  
  CLA uut (
    .A(A),
    .B(B),
    .Cin(Cin),
    .S(S),
    .Cout(Cout)
   );

  // Testbench procedure
  initial begin

    $display("Test Case N: A =         , B =         , Cin =  , S =         , Cout =  ");
      
    // Test case 0: Zero addition
    A = 32'h0000_0000; B = 32'h0000_0000; Cin = 0;#10;
    $display("Test Case 0: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A, B, Cin, S, Cout);
      
    // Test case 1: Simple addition
    A = 32'h0000_0002; B = 32'h0000_0002; Cin = 0;#10;
    $display("Test Case 1: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A, B, Cin, S, Cout);

    // Test case 2: Addition with carry-in
    A = 32'h0000_0004; B = 32'h0000_0005; Cin = 1; #10;
    $display("Test Case 2: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A, B, Cin, S, Cout);

    // Test case 3: Maximum value addition
    A = 32'hFFFF_FFFF;B = 32'h0000_0001; Cin = 0; #10;
    $display("Test Case 3: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A, B, Cin, S, Cout);

    // Test case 4: Random addition
    A = 32'h6758_4132; B = 32'h3241_5867; Cin = 0; #10;
    $display("Test Case 4: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A, B, Cin, S, Cout);

    // Test case 5: Overflow case
    A = 32'hFFFF_FFFF; B = 32'hFFFF_FFFF; Cin = 0; #10;
    $display("Test Case 5: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A, B, Cin, S, Cout);


    // Test case 6: Large numbers
    A = 32'h9999_9999; B = 32'h9999_9999; Cin = 1; #10;
    $display("Test Case 6: A = %h, B = %h, Cin = %b, S = %h, Cout = %b", A, B, Cin, S, Cout);

    $finish;
  end

endmodule