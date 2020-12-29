`timescale 10ns/1ps


module tb_clkdiv ();

  bit   clock, reset;    

  wire[16:1] ckout;

  genvar i;

  generate 
    for(i = 1; i <= 16; ++i) 
    begin : _instances
      clkdiv 
       #( .From   (50000000), 
          .DownTo (50000000/i)) 
        _dut 
        ( .clock  (clock), 
          .reset  (reset), 
          .ckout  (ckout[i]),
          .ckena  (reset));
    end
  endgenerate;

  initial
  begin
    $dumpfile("trace/tb_clkdiv.vcd");
    $dumpvars(1, clock, reset, ckout,
      _instances[ 1]._dut, 
      _instances[ 2]._dut, 
      _instances[ 3]._dut, 
      _instances[ 4]._dut, 
      _instances[ 5]._dut, 
      _instances[ 6]._dut, 
      _instances[ 7]._dut, 
      _instances[ 8]._dut, 
      _instances[ 9]._dut, 
      _instances[10]._dut, 
      _instances[11]._dut, 
      _instances[12]._dut, 
      _instances[13]._dut, 
      _instances[14]._dut, 
      _instances[15]._dut, 
      _instances[16]._dut);

    reset <= 1;
    clock <= 0;
  #1;
    reset <= 0;
  #1;
    reset <= 1;

    while($realtime < 10000)
    begin
      clock <= 1; #1;
      clock <= 0; #1;
    end
  #1;
    reset <= 1;
    clock <= 0;
    
  #1;
    reset <= 0;
  #1;
    reset <= 1;

    while($realtime < 20000)
    begin
      clock <= 1; #1;
      clock <= 0; #1;
    end

  end

endmodule