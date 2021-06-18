module core_audio (I_clock, I_reset, I_phy2, I_address, I_rdwr, I_data, O_data, O_data_rdy, O_irq, O_audio);

  input   wire        I_clock     ;
  input   wire        I_reset     ;
  input   wire        I_phy2      ;
  input   wire[15:0]  I_address   ;
  input   wire        I_rdwr      ;
  input   wire[7:0]   I_data      ;

  output  wire[7:0]   O_data      = 8'b0;
  output  wire        O_data_rdy  = 1'b0;
  output  wire        O_irq       = 1'b1;

  output  wire[15:0]  O_audio     = 16'd0;

  bit[15:0] lut [0:127];

  initial lut = '{
    16'h7FFF, 16'h7FD7, 16'h7F61, 16'h7E9C, 16'h7D89, 16'h7C28, 16'h7A7C, 16'h7883, 
    16'h7640, 16'h73B4, 16'h70E1, 16'h6DC9, 16'h6A6C, 16'h66CE, 16'h62F1, 16'h5ED6, 
    16'h5A81, 16'h55F4, 16'h5132, 16'h4C3F, 16'h471C, 16'h41CD, 16'h3C55, 16'h36B9, 
    16'h30FB, 16'h2B1E, 16'h2527, 16'h1F19, 16'h18F8, 16'h12C7, 16'h0C8B, 16'h0647, 
    16'h0000, 16'hF9B8, 16'hF374, 16'hED38, 16'hE707, 16'hE0E6, 16'hDAD8, 16'hD4E1, 
    16'hCF04, 16'hC946, 16'hC3AA, 16'hBE32, 16'hB8E3, 16'hB3C0, 16'hAECD, 16'hAA0B, 
    16'hA57E, 16'hA129, 16'h9D0E, 16'h9931, 16'h9593, 16'h9236, 16'h8F1E, 16'h8C4B, 
    16'h89BF, 16'h877C, 16'h8583, 16'h83D7, 16'h8276, 16'h8163, 16'h809E, 16'h8028, 
    16'h8000, 16'h8028, 16'h809E, 16'h8163, 16'h8276, 16'h83D7, 16'h8583, 16'h877C, 
    16'h89BF, 16'h8C4B, 16'h8F1E, 16'h9236, 16'h9593, 16'h9931, 16'h9D0E, 16'hA129, 
    16'hA57E, 16'hAA0B, 16'hAECD, 16'hB3C0, 16'hB8E3, 16'hBE32, 16'hC3AA, 16'hC946, 
    16'hCF04, 16'hD4E1, 16'hDAD8, 16'hE0E6, 16'hE707, 16'hED38, 16'hF374, 16'hF9B8, 
    16'h0000, 16'h0647, 16'h0C8B, 16'h12C7, 16'h18F8, 16'h1F19, 16'h2527, 16'h2B1E, 
    16'h30FB, 16'h36B9, 16'h3C55, 16'h41CD, 16'h471C, 16'h4C3F, 16'h5132, 16'h55F4, 
    16'h5A81, 16'h5ED6, 16'h62F1, 16'h66CE, 16'h6A6C, 16'h6DC9, 16'h70E1, 16'h73B4, 
    16'h7640, 16'h7883, 16'h7A7C, 16'h7C28, 16'h7D89, 16'h7E9C, 16'h7F61, 16'h7FD7,    
  };

   

endmodule