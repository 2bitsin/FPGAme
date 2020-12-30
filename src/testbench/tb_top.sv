`timescale 1ns/1ps

module tb_top();

  reg clock;
  reg reset;

  wire io_rx;
  wire io_tx;  

  top _dut (.clock(clock), .reset(reset), .io_rx(io_rx), .io_tx(io_tx));

  initial begin
    $dumpfile("trace/tb_top.vcd");        
    $dumpvars(1, _dut);
    
    reset <= 1;  #1;
    reset <= 0;  #1;
    reset <= 1;  #1;  
  
    while ($realtime < 10000)    
    begin
      clock <= 1;  #1; 
      clock <= 0;  #1;          
    end

    reset <= 1;  #1;
    reset <= 0;  #1;
    reset <= 1;  #1;  

    while ($realtime < 20000)    
    begin
      clock <= 1;  #1; 
      clock <= 0;  #1;          
    end


  end


endmodule