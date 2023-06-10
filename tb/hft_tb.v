
parameter AXI_DATA_W = 64;
parameter AXI_KEEP_W = AXI_DATA_W/8;
parameter LEN   = 8;
parameter ML_W  = 2*LEN;
parameter SID_W = 10*LEN;// session id
parameter SEQ_NUM_W = 8*LEN; // sequence number
parameter MH_W  = 20*LEN;// header 
parameter MSG_MAX_W = 50*LEN;
parameter CNT_MAX   = 7;
parameter CNT_MAX_W = $clog2(CNT_MAX);

module hft_tb;	
reg clk = 0;
reg nreset = 1'b0;	

logic [MH_W-1:0]       moldudp_header;
logic [ML_W-1:0]       moldudp_msg_len;
logic                  udp_axis_tvalid_i;
logic [AXI_KEEP_W-1:0] udp_axis_tkeep_i;
logic [AXI_DATA_W-1:0] udp_axis_tdata_i;
logic                  udp_axis_tlast_i;
logic                  udp_axis_tuser_i;
logic                  udp_axis_tready_o;

logic                  mold_msg_v_o;
logic                  mold_msg_start_o;
logic [AXI_KEEP_W-1:0] mold_msg_mask_o;
logic [AXI_DATA_W-1:0] mold_msg_data_o;

`ifdef MOLD_MSG_IDS
logic [SID_W-1:0]      mold_msg_sid_o;
logic [SEQ_NUM_W-1:0]  mold_msg_seq_num_o;
`endif

int t;
logic tb_ready;
logic tb_valid;
logic [63:0] tb_data;
logic [7:0]  tb_keep;

task vpi_task;
begin
	integer i;
	for(i=0; i < 100; i++ ) begin
		#10	
		tb_ready = udp_axis_tready_o;
		$tb(tb_ready, tb_valid, tb_data, tb_keep);
		udp_axis_tvalid_i = tb_valid;
		udp_axis_tdata_i  = tb_data;
		udp_axis_tkeep_i  = tb_keep;
		udp_axis_tlast_i  = ~&tb_keep;
	end
end
endtask

initial
begin
	$dumpfile("build/wave.vcd"); // create a VCD waveform dump called "wave.vcd"
    $dumpvars(0, hft_tb);
	$display("Test start");
	#10

	t = $tb_init("/home/pitchu/rtl/hft/tb/12302019.NASDAQ_ITCH50");
	$display("TB");
	tb_ready = 1'b0;
	nreset = 1'b0;
	#10
	tb_ready = 1'b1;
 	nreset = 1'b1;
	udp_axis_tuser_i = 1'b0;	
	#10
	vpi_task();
	#10
	$display("Test end");
	$finish;
end
 /* Make a regular pulsing clock. */
always #5 clk = !clk;

hft #(
	.AXI_DATA_W(AXI_DATA_W),
	.AXI_KEEP_W(AXI_KEEP_W),
	.SID_W(SID_W),
	.SEQ_NUM_W(SEQ_NUM_W),
	.ML_W(ML_W),
	.EOS_MSG_CNT(16'hffff)
) m_hft(
	.clk(clk),
	.nreset(nreset)
);
	
assign m_hft.udp_mold_axis_tvalid = udp_axis_tvalid_i;
assign m_hft.udp_mold_axis_tkeep  = udp_axis_tkeep_i;
assign m_hft.udp_mold_axis_tdata  = udp_axis_tdata_i;
assign m_hft.udp_mold_axis_tlast  = udp_axis_tlast_i;
assign m_hft.udp_mold_axis_tuser  = udp_axis_tuser_i;

assign udp_axis_tready_o = m_hft.mold_udp_axis_tready;

`ifdef MOLD_MSG_IDS
assign mold_msg_sid_o    = m_hft.mold_itch_msg_sid;    
assign mold_msg_seq_num_o= m_hft.mold_itch_msg_seq_num;
`endif

assign mold_msg_v_o     = m_hft.mold_itch_msg_v;    
assign mold_msg_start_o = m_hft.mold_itch_msg_start;
assign mold_msg_mask_o  = m_hft.mold_itch_msg_mask; 
assign mold_msg_data_o  = m_hft.mold_itch_msg_data; 


endmodule
