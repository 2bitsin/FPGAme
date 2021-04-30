module widget (I_sys_clock, I_sys_reset, O_vid_clock, O_vid_blank, O_vid_hsync, O_vid_vsync, O_vid_red, O_vid_green, O_vid_blue);

  input  wire       I_sys_clock;
  input  wire       I_sys_reset;

  output wire       O_vid_clock;
  output wire       O_vid_blank;
  output wire       O_vid_hsync;
  output wire       O_vid_vsync;
  output wire[7:0]  O_vid_red;
  output wire[7:0]  O_vid_green;
  output wire[7:0]  O_vid_blue;
		
	wire[7:0]					W_data0;
	wire[15:0]				W_addr0;
	wire							W_clock0;  
  
  wire[7:0]         W_wr_data1;
  wire[7:0]         W_rd_data1;
  wire              W_rdwr1;
  wire[15:0]        W_addr1;
  wire              W_phy2;
	
  video inst_video (
    .I_clock      (I_sys_clock),
    .I_reset      (I_sys_reset),
	  .O_vid_clock  (O_vid_clock),
	  .O_vid_blank  (O_vid_blank),
	  .O_vid_hsync  (O_vid_hsync),
	  .O_vid_vsync  (O_vid_vsync),
	  .O_vid_red    (O_vid_red),
	  .O_vid_green  (O_vid_green),
	  .O_vid_blue   (O_vid_blue),
    .O_mem_addr   (W_addr0),
    .O_mem_clock  (W_clock0),
    .I_mem_data   (W_data0));
/*
  core inst_core (
    .I_clock      (I_sys_clock),
    .I_reset      (I_sys_reset),
    .I_irq        (0),
    .I_nmi        (O_vid_vsync),
    .I_ready      (1),
    .I_rd_data    (W_rd_data1),
    .O_wr_data    (W_wr_data1),
    .O_rdwr       (W_rdwr1),
    .O_addr       (W_addr1),
    .O_sync       (),
    .O_phy2       (W_phy2)
  );
  */  
  dpmem #(
    .P_data_bits  (8), 
    .P_addr_bits  (16),		
    .P_init_bin0  ("assets/8x8.mem"),
    .P_init_beg0  (16'h4000),
    .P_init_end0  (16'h47ff),
    .P_init_bin1  ("assets/vid.mem"),
    