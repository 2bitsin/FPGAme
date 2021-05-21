
module video (
  I_clock, 
  I_reset, 
  O_vid_clock, 
  O_vid_rise,
  O_vid_blank, 
  O_vid_hsync,
  O_vid_vsync, 
  O_vid_red, 
  O_vid_green, 
  O_vid_blue,

  I_host_addr,
  I_host_wren,
  I_host_rden,
  I_host_data,
  O_host_data,
  O_host_nmi,

  O_cart_addr,  
  O_cart_wren,
  I_cart_data,
  O_cart_data);

/* I/O ports */

  input   wire        I_clock ;
  input   wire        I_reset ;

  output  wire        O_vid_clock ;
  output  wire        O_vid_rise  ;
  output  wire        O_vid_blank ;
  output  wire        O_vid_hsync ;
  output  wire        O_vid_vsync ;
  output  wire[7:0]   O_vid_red   ;
  output  wire[7:0]   O_vid_green ;
  output  wire[7:0]   O_vid_blue  ;

  input   wire[2:0]   I_host_addr ;
  input   wire        I_host_wren ;
  input   wire        I_host_rden ;
  input   wire[7:0]   I_host_data ;
  output  bit[7:0]    O_host_data ;
  output  bit         O_host_nmi  ;

  output  bit[13:0]   O_cart_addr ;  
  output  bit         O_cart_wren ;
  input   wire[7:0]   I_cart_data ;
  output  bit[7:0]    O_cart_data ;
  
/* Video timing generator */

  wire[15:0]      W_hcount         ;
  wire[15:0]      W_vcount         ;
  wire            W_not_vblank     ;
  wire            W_not_hblank     ;

  wire            W_hcount_zero    = W_hcount == 16'd0 ;
  wire            W_prerender_line = W_vcount == 16'd261;
  wire            W_rendering_line = W_not_vblank | W_prerender_line;

  video_timing inst_timing (
    .I_clock      (I_clock),
    .I_reset      (I_reset),
    .O_clock      (O_vid_clock),
    .O_rise       (O_vid_rise),
    .O_not_blank  (O_vid_blank),
    .O_hsync      (O_vid_hsync),
    .O_vsync      (O_vid_vsync),
    .O_hcount     (W_hcount),
    .O_vcount     (W_vcount),
    .O_not_hblank (W_not_hblank),
    .O_not_vblank (W_not_vblank)
  );

/* Vblank flag */
  
  wire            W_vblank_flag   ;
  assign          O_host_nmi      = ~(W_vblank_flag & W_enable_nmi);

  wire            W_vblank_clear  ;
  assign          W_vblank_clear  = W_decode_register[2] & W_host_rden; 

  sr_latch #(.P_width (1)) inst_vblank_flag (
    .I_clock      (I_clock), 
    .I_reset      (I_reset),
    .I_set        ((W_hcount_zero & (W_vcount == 16'd241))),
    .I_clear      ((W_hcount_zero & (W_vcount == 16'd261)) | W_vblank_clear),
    .O_value      (W_vblank_flag)
  );

/* Color palette and lookup */
  wire            W_palette_select = O_cart_addr >= 14'h3f00;
  wire[5:0]       W_palette_O_data;

  video_color_tab inst_color_tab(
    .I_clock      (I_clock),
    .I_reset      (I_reset),
    .I_addr       (I_host_addr [4:0]),
    .I_wren       (W_host_wren & W_palette_select),
    .I_data       (R_data_latch),
    .O_data       (W_palette_O_data), 
    .I_index      ({W_vcount[7:6], W_hcount[7:5]}),
    .O_red        (O_vid_red),
    .O_green      (O_vid_green),
    .O_blue       (O_vid_blue)
  );

/* Primary OAM */

  memory #(.P_addr_bits (8)) inst_primary_oam (
    .I_clock      (I_clock),

    .I_addr0      (R_OAM_addr),
    .I_data0      (R_data_latch),
    .I_wren0      (W_host_wren & W_decode_register[4] & ~W_rendering_line),    
    .O_data0      (R_OAM_data),

    .I_addr1      (8'b0),
    .I_data1      (8'b0),
    .I_wren1      (1'b0),    
    .O_data1      ()
  );

/* Decode host address */

  wire[7:0]       W_decode_register;

  decoder #(.P_width(3)) inst_decode_register( 
    .O_unpacked   (W_decode_register),
    .I_packed     (I_host_addr[2:0] )
  );
  
/* PPU Register logic 