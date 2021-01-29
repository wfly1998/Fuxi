`timescale 1ns / 1ps

module SoC_tb;

//***************************************************************************
// The following parameters refer to width of various ports
//***************************************************************************
parameter CS_WIDTH              = 1;
                                 // # of unique CS outputs to memory.
parameter DM_WIDTH              = 4;
                                 // # of DM (data mask)
parameter DQ_WIDTH              = 32;
                                 // # of DQ (data)
parameter DQS_WIDTH             = 4;
                                 // # of DQ per DQS
parameter ECC                   = "OFF";
parameter ODT_WIDTH             = 1;
                                 // # of ODT outputs to memory.
parameter ROW_WIDTH             = 15;
                                 // # of memory Row Address bits.
//***************************************************************************
// The following parameters are mode register settings
//***************************************************************************
parameter CA_MIRROR             = "OFF";
                                 // C/A mirror opt for DDR3 dual rank
//***************************************************************************
// IODELAY and PHY related parameters
//***************************************************************************
parameter RST_ACT_LOW           = 1;
                                 // =1 for active low reset,
                                 // =0 for active high.
//**************************************************************************//
// Local parameters Declarations
//**************************************************************************//
localparam real TPROP_DQS          = 0.00;
                                   // Delay for DQS signal during Write Operation
localparam real TPROP_DQS_RD       = 0.00;
                   // Delay for DQS signal during Read Operation
localparam real TPROP_PCB_CTRL     = 0.00;
                   // Delay for Address and Ctrl signals
localparam real TPROP_PCB_DATA     = 0.00;
                   // Delay for data signal during Write operation
localparam real TPROP_PCB_DATA_RD  = 0.00;
                   // Delay for data signal during Read operation
localparam MEMORY_WIDTH            = 16;
localparam NUM_COMP                = DQ_WIDTH/MEMORY_WIDTH;
// localparam ECC_TEST 		   	= "OFF" ;
// localparam ERR_INSERT = (ECC_TEST == "ON") ? "OFF" : ECC ;
localparam RESET_PERIOD = 7; //in pSec  

//**************************************************************************//
// Wire Declarations
//**************************************************************************//
reg                     sys_rst_n;
wire                    sys_rst;

wire                    ddr3_reset_n;
wire [DQ_WIDTH-1:0]     ddr3_dq_fpga;
wire [DQS_WIDTH-1:0]    ddr3_dqs_p_fpga;
wire [DQS_WIDTH-1:0]    ddr3_dqs_n_fpga;
wire [ROW_WIDTH-1:0]    ddr3_addr_fpga;
wire [3-1:0]            ddr3_ba_fpga;
wire                    ddr3_ras_n_fpga;
wire                    ddr3_cas_n_fpga;
wire                    ddr3_we_n_fpga;
wire [1-1:0]            ddr3_cke_fpga;
wire [1-1:0]            ddr3_ck_p_fpga;
wire [1-1:0]            ddr3_ck_n_fpga;
wire                    init_calib_complete;
wire [(CS_WIDTH*1)-1:0] ddr3_cs_n_fpga;
wire [DM_WIDTH-1:0]     ddr3_dm_fpga;
wire [ODT_WIDTH-1:0]    ddr3_odt_fpga;
reg [(CS_WIDTH*1)-1:0]  ddr3_cs_n_sdram_tmp;
reg [DM_WIDTH-1:0]      ddr3_dm_sdram_tmp;
reg [ODT_WIDTH-1:0]     ddr3_odt_sdram_tmp;
wire [DQ_WIDTH-1:0]     ddr3_dq_sdram;
reg [ROW_WIDTH-1:0]     ddr3_addr_sdram [0:1];
reg [3-1:0]             ddr3_ba_sdram [0:1];
reg                     ddr3_ras_n_sdram;
reg                     ddr3_cas_n_sdram;
reg                     ddr3_we_n_sdram;
wire [(CS_WIDTH*1)-1:0] ddr3_cs_n_sdram;
wire [ODT_WIDTH-1:0]    ddr3_odt_sdram;
reg [1-1:0]             ddr3_cke_sdram;
wire [DM_WIDTH-1:0]     ddr3_dm_sdram;
wire [DQS_WIDTH-1:0]    ddr3_dqs_p_sdram;
wire [DQS_WIDTH-1:0]    ddr3_dqs_n_sdram;
reg [1-1:0]             ddr3_ck_p_sdram;
reg [1-1:0]             ddr3_ck_n_sdram;

//**************************************************************************//
// Reset Generation
//**************************************************************************//
initial begin
    sys_rst_n = 1'b0;
    #RESET_PERIOD
        sys_rst_n = 1'b1;
end

assign sys_rst = RST_ACT_LOW ? sys_rst_n : ~sys_rst_n;


always @( * ) begin
    ddr3_ck_p_sdram      <=  #(TPROP_PCB_CTRL) ddr3_ck_p_fpga;
    ddr3_ck_n_sdram      <=  #(TPROP_PCB_CTRL) ddr3_ck_n_fpga;
    ddr3_addr_sdram[0]   <=  #(TPROP_PCB_CTRL) ddr3_addr_fpga;
    ddr3_addr_sdram[1]   <=  #(TPROP_PCB_CTRL) (CA_MIRROR == "ON") ?
                                                 {ddr3_addr_fpga[ROW_WIDTH-1:9],
                                                  ddr3_addr_fpga[7], ddr3_addr_fpga[8],
                                                  ddr3_addr_fpga[5], ddr3_addr_fpga[6],
                                                  ddr3_addr_fpga[3], ddr3_addr_fpga[4],
                                                  ddr3_addr_fpga[2:0]} :
                                                 ddr3_addr_fpga;
    ddr3_ba_sdram[0]     <=  #(TPROP_PCB_CTRL) ddr3_ba_fpga;
    ddr3_ba_sdram[1]     <=  #(TPROP_PCB_CTRL) (CA_MIRROR == "ON") ?
                                                 {ddr3_ba_fpga[3-1:2],
                                                  ddr3_ba_fpga[0],
                                                  ddr3_ba_fpga[1]} :
                                                 ddr3_ba_fpga;
    ddr3_ras_n_sdram     <=  #(TPROP_PCB_CTRL) ddr3_ras_n_fpga;
    ddr3_cas_n_sdram     <=  #(TPROP_PCB_CTRL) ddr3_cas_n_fpga;
    ddr3_we_n_sdram      <=  #(TPROP_PCB_CTRL) ddr3_we_n_fpga;
    ddr3_cke_sdram       <=  #(TPROP_PCB_CTRL) ddr3_cke_fpga;
end
    

always @( * )
    ddr3_cs_n_sdram_tmp   <=  #(TPROP_PCB_CTRL) ddr3_cs_n_fpga;
assign ddr3_cs_n_sdram =  ddr3_cs_n_sdram_tmp;
    

always @( * )
    ddr3_dm_sdram_tmp <=  #(TPROP_PCB_DATA) ddr3_dm_fpga;//DM signal generation
assign ddr3_dm_sdram = ddr3_dm_sdram_tmp;
    

always @( * )
    ddr3_odt_sdram_tmp  <=  #(TPROP_PCB_CTRL) ddr3_odt_fpga;
assign ddr3_odt_sdram =  ddr3_odt_sdram_tmp;

// Controlling the bi-directional BUS

genvar dqwd;
generate
    for (dqwd = 1;dqwd < DQ_WIDTH;dqwd = dqwd+1) begin : dq_delay
        WireDelay #
        (
            .Delay_g    (TPROP_PCB_DATA),
            .Delay_rd   (TPROP_PCB_DATA_RD),
            .ERR_INSERT ("OFF")
        )
        u_delay_dq
        (
            .A             (ddr3_dq_fpga[dqwd]),
            .B             (ddr3_dq_sdram[dqwd]),
            .reset         (sys_rst_n),
            .phy_init_done (init_calib_complete)
        );
    end
    WireDelay #
    (
        .Delay_g    (TPROP_PCB_DATA),
        .Delay_rd   (TPROP_PCB_DATA_RD),
        .ERR_INSERT ("OFF")
    )
    u_delay_dq_0
    (
        .A             (ddr3_dq_fpga[0]),
        .B             (ddr3_dq_sdram[0]),
        .reset         (sys_rst_n),
        .phy_init_done (init_calib_complete)
    );
endgenerate

genvar dqswd;
generate
    for (dqswd = 0;dqswd < DQS_WIDTH;dqswd = dqswd+1) begin : dqs_delay
        WireDelay #
        (
            .Delay_g    (TPROP_DQS),
            .Delay_rd   (TPROP_DQS_RD),
            .ERR_INSERT ("OFF")
        )
        u_delay_dqs_p
        (
            .A             (ddr3_dqs_p_fpga[dqswd]),
            .B             (ddr3_dqs_p_sdram[dqswd]),
            .reset         (sys_rst_n),
            .phy_init_done (init_calib_complete)
        );
        
        WireDelay #
        (
            .Delay_g    (TPROP_DQS),
            .Delay_rd   (TPROP_DQS_RD),
            .ERR_INSERT ("OFF")
        )
        u_delay_dqs_n
        (
            .A             (ddr3_dqs_n_fpga[dqswd]),
            .B             (ddr3_dqs_n_sdram[dqswd]),
            .reset         (sys_rst_n),
            .phy_init_done (init_calib_complete)
        );
    end
endgenerate

//**************************************************************************//
// Memory Models instantiations
//**************************************************************************//

genvar r,i;
generate
    for (r = 0; r < CS_WIDTH; r = r + 1) begin: mem_rnk
        if(DQ_WIDTH/16) begin: mem
            for (i = 0; i < NUM_COMP; i = i + 1) begin: gen_mem
                ddr3_model u_comp_ddr3
                (
                    .rst_n   (ddr3_reset_n),
                    .ck      (ddr3_ck_p_sdram),
                    .ck_n    (ddr3_ck_n_sdram),
                    .cke     (ddr3_cke_sdram[r]),
                    .cs_n    (ddr3_cs_n_sdram[r]),
                    .ras_n   (ddr3_ras_n_sdram),
                    .cas_n   (ddr3_cas_n_sdram),
                    .we_n    (ddr3_we_n_sdram),
                    .dm_tdqs (ddr3_dm_sdram[(2*(i+1)-1):(2*i)]),
                    .ba      (ddr3_ba_sdram[r]),
                    .addr    (ddr3_addr_sdram[r]),
                    .dq      (ddr3_dq_sdram[16*(i+1)-1:16*(i)]),
                    .dqs     (ddr3_dqs_p_sdram[(2*(i+1)-1):(2*i)]),
                    .dqs_n   (ddr3_dqs_n_sdram[(2*(i+1)-1):(2*i)]),
                    .tdqs_n  (),
                    .odt     (ddr3_odt_sdram[r])
                );
            end
        end
        if (DQ_WIDTH%16) begin: gen_mem_extrabits
            ddr3_model u_comp_ddr3
            (
                .rst_n   (ddr3_reset_n),
                .ck      (ddr3_ck_p_sdram),
                .ck_n    (ddr3_ck_n_sdram),
                .cke     (ddr3_cke_sdram[r]),
                .cs_n    (ddr3_cs_n_sdram[r]),
                .ras_n   (ddr3_ras_n_sdram),
                .cas_n   (ddr3_cas_n_sdram),
                .we_n    (ddr3_we_n_sdram),
                .dm_tdqs ({ddr3_dm_sdram[DM_WIDTH-1],ddr3_dm_sdram[DM_WIDTH-1]}),
                .ba      (ddr3_ba_sdram[r]),
                .addr    (ddr3_addr_sdram[r]),
                .dq      ({ddr3_dq_sdram[DQ_WIDTH-1:(DQ_WIDTH-8)],
                           ddr3_dq_sdram[DQ_WIDTH-1:(DQ_WIDTH-8)]}),
                .dqs     ({ddr3_dqs_p_sdram[DQS_WIDTH-1],
                           ddr3_dqs_p_sdram[DQS_WIDTH-1]}),
                .dqs_n   ({ddr3_dqs_n_sdram[DQS_WIDTH-1],
                           ddr3_dqs_n_sdram[DQS_WIDTH-1]}),
                .tdqs_n  (),
                .odt     (ddr3_odt_sdram[r])
            );
        end
    end
endgenerate

//**************************************************************************//
// Raw Fuxi SoC_tb.v
//**************************************************************************//

reg     clk, rst_n;
wire    diff_clk_p, diff_clk_n, cfg_si, cfg_so, cfg_ss;

assign  diff_clk_p = clk;
assign  diff_clk_n = ~clk;

always begin
    #2.5 clk <= ~clk;   // 5ns 200MHz
end

initial begin
    clk <= 0;
    rst_n <= 0;
    #RESET_PERIOD rst_n <= 1;
end

SoC soc_inst(
    .diff_clk_p     (diff_clk_p),
    .diff_clk_n     (diff_clk_n),
    .rst_n          (rst_n),
    
    .UART_rxd       (1'b0),
    .UART_txd       (),
    
    .SPI_FLASH_mosi (),
    .SPI_FLASH_miso (),
    .SPI_FLASH_ss   (),
    .SPI_FLASH_sck  (),
    
    .CFG_FLASH_mosi (cfg_si),
    .CFG_FLASH_miso (cfg_so),
    .CFG_FLASH_ss   (cfg_ss),
    
    .VGA_r          (),
    .VGA_g          (),
    .VGA_b          (),
    .VGA_hsync      (),
    .VGA_vsync      (),
    
    .DDR3_dq        (ddr3_dq_fpga),
    .DDR3_addr      (ddr3_addr_fpga),
    .DDR3_ba        (ddr3_ba_fpga),
    .DDR3_ras_n     (ddr3_ras_n_fpga),
    .DDR3_cas_n     (ddr3_cas_n_fpga),
    .DDR3_we_n      (ddr3_we_n_fpga),
    .DDR3_odt       (ddr3_odt_fpga),
    .DDR3_reset_n   (ddr3_reset_n),
    .DDR3_cke       (ddr3_cke_fpga),
    .DDR3_dm        (ddr3_dm_fpga),
    .DDR3_dqs_p     (ddr3_dqs_p_fpga),
    .DDR3_dqs_n     (ddr3_dqs_n_fpga),
    .DDR3_ck_p      (ddr3_ck_p_fpga),
    .DDR3_ck_n      (ddr3_ck_n_fpga),
    .DDR3_cs_n      (ddr3_cs_n_fpga),
    
    .MDIO_mdc       (),
    .MDIO_mdio      (),
    .MII_col        (1'b0),
    .MII_crs        (1'b0),
    .MII_rst_n      (),
    .MII_rx_clk     (1'b0),
    .MII_rx_dv      (1'b0),
    .MII_rx_er      (1'b0),
    .MII_rxd        (4'b0),
    .MII_tx_clk     (1'b0),
    .MII_tx_en      (),
    .MII_tx_er      (),
    .MII_txd        ()
);

s25fl128s cfg_flash(
    .SI             (cfg_si),
    .SO             (cfg_so),
    .SCK            (clk),
    .CSNeg          (cfg_ss),
    .RSTNeg         (1'b1),
    .HOLDNeg        (),
    .WPNeg          ()
);

endmodule
