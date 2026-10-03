/*
################################################################################
# -PARENT NAME: UART_Tx.sv
# -MODULE NAME: BRG_Tx_tb.sv
# -FILE CREATED: 3-Oct-2026
# -FILE REVISED [DATE]: see commit history
# -DESCRIPTION: Testbench for Baud Rate Generator (BRG_Tx)
#
################################################################################
*/

`timescale 1ns / 1ps

module BRG_Tx_tb;

  // Testbench Parameters
  // Defaults match BRG_Tx.sv: 50 MHz system clock, 9600 baud
  parameter integer SYS_CLK_FREQ = 50_000_000;
  parameter integer BAUD_RATE    = 9600;

  // Clock timing: 50 MHz -> 20 ns period -> 10 ns half-period
  localparam real CLK_PERIOD_NS = 1.0e9 / SYS_CLK_FREQ;

  // DUT Interface Signals
  logic Sys_Clk_In;
  logic Rst_In;
  logic BRG_En_In;
  wire  Tick_Out;

  // Internal testbench variables
  int tick_count = 0;

  // Instantiate the Device Under Test (DUT)
  BRG_Tx #(
      .SYS_CLK_FREQ(SYS_CLK_FREQ),
      .BAUD_RATE(BAUD_RATE)
  ) dut (
      .Sys_Clk_In(Sys_Clk_In),
      .Rst_In    (Rst_In),
      .BRG_En_In (BRG_En_In),
      .Tick_Out  (Tick_Out)
  );

  // Clock generation: 50 MHz (toggles every 10 ns)
  initial begin
    Sys_Clk_In = 1'b0;
    forever #(CLK_PERIOD_NS / 2.0) Sys_Clk_In = ~Sys_Clk_In;
  end

  // Watchdog timeout to prevent simulation hanging
  initial begin
    #10_000_000; // 10 ms timeout
    $display("[%0t] ERROR: Watchdog timeout reached!", $time);
    $finish;
  end

  // Main stimulus and verification
  initial begin
    $timeformat(-9, 2, " ns", 12);

    // Setup VCD waveform dump
    $dumpfile("BRG_Tx_tb.vcd");
    $dumpvars(0, BRG_Tx_tb);

    // Initialize inputs
    Rst_In    = 1'b1;
    BRG_En_In = 1'b0;

    $display("==================================================");
    $display(" Starting BRG_Tx Testbench");
    $display(" SYS_CLK_FREQ = %0d Hz", SYS_CLK_FREQ);
    $display(" BAUD_RATE    = %0d baud", BAUD_RATE);
    $display(" Ticks/Baud   = %0d clock cycles", SYS_CLK_FREQ / BAUD_RATE);
    $display("==================================================");

    // Apply Reset for 5 clock cycles
    repeat (5) @(posedge Sys_Clk_In);
    Rst_In = 1'b0;
    $display("[%0t] Reset deasserted.", $time);

    // Wait 2 clock cycles before enabling BRG
    repeat (2) @(posedge Sys_Clk_In);
    BRG_En_In = 1'b1;
    $display("[%0t] BRG_En_In asserted. Generator running...", $time);

    // Wait until Tick_Out gets triggered 3 times
    repeat (3) begin
      @(posedge Tick_Out);
      tick_count++;
      $display("[%0t] Tick_Out triggered! (Count = %0d/3)", $time, tick_count);
    end

    // Wait a few clock cycles after 3rd trigger to clearly see the pulse return to 0 in waveform
    repeat (5) @(posedge Sys_Clk_In);

    $display("==================================================");
    $display("[%0t] Success: Tick_Out triggered 3 times!", $time);
    $display(" Waveform saved to BRG_Tx_tb.vcd");
    $display("==================================================");

    $finish;
  end

endmodule
