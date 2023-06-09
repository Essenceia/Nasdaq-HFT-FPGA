
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

int h;

initial
begin
	h = 34;
	$hello(h);
	$display("Got %d", h);
	$dumpfile("build/wave.vcd"); // create a VCD waveform dump called "wave.vcd"
    $dumpvars(0, hft_tb);
	$display("Test start");
	udp_axis_tvalid_i = 1'b0;
	udp_axis_tkeep_i  = {AXI_KEEP_W{1'bx}};
	udp_axis_tdata_i  = {AXI_DATA_W{1'bx}};
	udp_axis_tlast_i  = 1'bx;
	udp_axis_tuser_i  = 1'bx;
	# 10
	nreset = 1'b1;
	#10
	/* axi stream */ 
	udp_axis_tvalid_i = 1'b1;	
	udp_axis_tkeep_i  = {AXI_KEEP_W{ 1'b1}};
	udp_axis_tlast_i = 1'b0;
	udp_axis_tuser_i = 1'b0;
	// header : sid
	moldudp_header[SID_W-1:0] = 80'hDEADBEEF;
	// header : seq num
	moldudp_header[(SID_W+SEQ_NUM_W)-1:SID_W] = 64'hF0F0F0F0F0F0F0F0;
	// header : msg cnt
	moldudp_header[MH_W-1:MH_W-ML_W] = 'd3;

	moldudp_msg_len = 16'd16;
	/* Header 0*/
	udp_axis_tdata_i = moldudp_header[AXI_DATA_W-1:0];
	#10
	/* header 1*/
	udp_axis_tdata_i = moldudp_header[(AXI_DATA_W*2)-1:AXI_DATA_W];
	#10
	/* header 2 + msg 0*/
	udp_axis_tdata_i ={ 16'hffff, moldudp_msg_len, moldudp_header[MH_W-1:AXI_DATA_W*2] };
	#10
	/* payload 0 of msg 0 */
	udp_axis_tdata_i = {16{4'ha}};
	#10
	/* payload 1 of msg 0 + payload 0 of msg 1*/
	moldudp_msg_len = 16'd8;
	udp_axis_tdata_i = { moldudp_msg_len, {12{4'hB}}};
	#10
	/* payload 1 of msg 1 */
	udp_axis_tdata_i = {16{4'hD}};
	#10
	/* payload 0 of msg 2 */
	moldudp_msg_len = 16'd11;
	udp_axis_tdata_i = { {12{4'hE}} , moldudp_msg_len};
	#10
	/* payload 1 of msg 2 */
	udp_axis_tdata_i = {'X ,8'hAB ,{8{4'hF}}};
	udp_axis_tkeep_i = { '0, 4'b1111};
	udp_axis_tlast_i = 1'b1;
	#10
	/* no msg */
	udp_axis_tvalid_i = 1'b0;
	udp_axis_tkeep_i  = 'x;
	udp_axis_tlast_i  = 'x; 
	udp_axis_tdata_i  = 'x;
	#10	
	#10	
	#10	
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
