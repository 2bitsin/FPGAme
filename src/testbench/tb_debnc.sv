`timescale 10ns/1ps

module tb_debnc ();

  bit clock;

  wire sigout0, sigout1, sigin;

  bit[31:0] t = 0;

  assign sigin = (t % 233 < 20 ? (t % 5 > 2) : 0);

  debnc #(.TimeOut (64), .Inverted(0)) _dut0 (.clock(clock), .sigin( sigin), .sigout(sigout0));
  debnc #(.TimeOut (64), .Inverted(1)) _dut1 (.clock(clock), .sigin(~sigin), .sigout(sigout1));

  initial begin    
    $dumpfile("trace/tb_debnc.vcd");        
    $dumpvars(1, _dut0, _dut1);

    clock = 0;
  #1;
    while($realtime < 100000)
    begin
      clock = 0; t = $realtime; #1;
      clock = 1; t = $realtime; #1;
    end
  end

endmodule
