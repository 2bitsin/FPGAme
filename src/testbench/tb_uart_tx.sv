`timescale 10ns/1ps

module tb_uart_tx ();
 
   bit      clock, reset, reptx;
   wire     txd0, cts0, txd1, cts1;

   uart_tx
    #(.Clock   (50000000), 
      .Baud    (9600),
      .Stop    (2)) 
     _dut0
     (.clock   (clock), 
      .reset   (reset),       
      .data    (8'hA5), 
      .txd     (txd0), 
      .cts     (cts0),
      .reptx   (reptx));

   uart_tx
    #(.Clock   (50000000), 
      .Baud    (9600),
      .Stop    (4)) 
     _dut1 
     (.clock   (clock), 
      .reset   (reset),       
      .data    (8'h5A), 
      .txd     (txd1), 
      .cts     (cts1),
      .reptx   (reptx));
            
  initial 
  begin
    $dumpfile("trace/tb_uart_tx.vcd");
    $dumpvars(1, _dut0, _dut1);
    reptx <= 0;
    reset <= 1;
  #1;
    reset <= 0;
    clock <= 0;    
  #1;
    reset <= 1;
  #1000;
    while ($realtime < 200000)
    begin
      clock <= 0; #1;
      clock <= 1; #1;
    end
    reptx <= 1;
    reset <= 0;
  #1;
    reset <= 1;
    while ($realtime < 600000)
    begin
      clock <= 0; #1;
      clock <= 1; #1;
    end
  end

endmodule