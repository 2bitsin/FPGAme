`timescale 10ns/1ps

module tb_uart_tx ();
 
   bit      clock, reset, txen;
   bit[7:0] data;
   wire     txd, cts;

   uart_tx
    #(.Clock   (50000000), 
      .Baud    (9600)) 
     _dut 
     (.clock   (clock), 
      .reset   (reset), 
      .txen    (txen), 
      .data    (data), 
      .txd     (txd), 
      .cts     (cts));
            
  initial 
  begin
    $dumpfile("trace/tb_uart_tx.vcd");
    $dumpvars(1, _dut);

    reset <= 1;
  #1;
    clock <= 0;
    reset <= 0;
    data  <= 8'h5A;
    txen  <= 1;
  #1;
    reset <= 1;
    while ($realtime < 100000)
    begin
      clock <= 0; #1;
      clock <= 1; #1;
    end
  end

endmodule