
module top(
  input    wire      clock, 
  input    wire      reset,
  output   wire      io_tx, 
  output   wire      io_rx,
  output   wire      led,
  
  output   wire[7:0] vid_red,
  output   wire[7:0] vid_green,
  output   wire[7:0] vid_blue,
  output   wire      vid_hsync,
  output   wire      vid_vsync,
  output   wire      vid_blank,
  output   wire      vid_clock,
  
  output   wire      aud_mclk,
  output   wire      aud_wclk,
  output   wire      aud_sclk,
  output   wire      aud_data,
  
  output   wire      mb0_addr[18:0],
  inout    wire      mb0_data[7:0],
  output   wire      mb0_oe,
  output   wire      mb0_we,
  output   wire      mb0_ce,
  
  output   wire      mb1_addr[18:0],
  inout    wire      mb1_data[7:0],
  output   wire      mb1_oe,
  output   wire      mb1_we,
  output   wire      mb1_ce,
  
  input    wire      jp0_up,
  input    wire      jp0_down,
  input    wire      jp0_left,
  input    wire      jp0_right,
  input    wire      jp0_a_b,
  input    wire      jp0_c_s,
  output   wire      jp0_sel,
  
  input    wire      jp1_up,
  input    wire      jp1_down,
  input    wire      jp1_left,
  input    wire      jp1_right,
  input    wire      jp1_a_b,
  input    wire      jp1_c_s,
  output   wire      jp1_sel);

	
	bit[23:0] hold_reset;
	
	wire reset_is_held = hold_reset != 24'd0;
	
	always @(posedge clock)
	begin
		if (~reset)
			hold_reset <= 24'hffffff;			
		else if (hold_reset != 24'd0)
			hold_reset <= hold_reset - 24'd1;
	end
	
		
	wire W_pll_clock0;
	wire W_pll_locked;
	
	m_altera_pll instance_of_altera_pll(
    .refclk   (clock),
	  .rst      (reset_is_held),
    .outclk_0 (W_pll_clock0),
    .locked   (W_pll_locked));
	
  widget instance_of_widget (
    W_pll_clock0, 
    W_pll_locked, 
    vid_clock, 
    vid_blank, 
    vid_hsync, 
    vid_vsync, 
    vid_red, 
    vid_green, 
    vid_blue,		
		{	
			~jp1_c_s,   // v
			~jp1_a_b,   // v
			~jp1_right, // v
			~jp1_left,  // v
			~jp1_down,  // v
			~jp1_up 		// v
		}, 
		jp1_sel,			// v
		{	
			~jp0_c_s,   // v
			~jp0_a_b,   // v
			~jp0_right, // v
			~jp0_left,  // v
			~jp0_down,  // v
			~jp0_up 		// v
		},     
		jp0_sel,    	// v
		aud_mclk,
		aud_wclk,
		aud_sclk,
		aud_data); 
		
		assign io_tx = jp1_sel ;
		assign io_rx = jp1_c_s ;
  
endmodule