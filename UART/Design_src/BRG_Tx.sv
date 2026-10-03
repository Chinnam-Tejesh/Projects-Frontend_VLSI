/*
################################################################################
# -PARENT NAME: UART_Tx.sv
# -MODULE NAME: BRG_Tx.sv
# -FILE CREATED: 1-Oct-2026
# -FILE REVISED [DATE]: see commit history
# -DESCRIPTION: Baud Rate Generator for UART Transmitter
#
################################################################################
# Pre-Notes
#
# Notes
#
################################################################################
*/

`timescale 1ns / 1ps

module BRG_Tx #(
    parameter integer SYS_CLK_FREQ = 50_000_000,  // System Clock Frequency in Hz
    parameter integer BAUD_RATE = 9600  // Agreed Baud Rate
) (
    input Sys_Clk_In,  // System Clock
    input Rst_In,  // Reset - Synchronous & Active High 
    input BRG_En_In,  // Enable signal from FSM
    output Tick_Out  // Tick signal to FSM
);
  localparam int TICKS_PER_BAUD_COUNT = SYS_CLK_FREQ / BAUD_RATE;  // Calculate ticks per baud (result in integer, floor rounding)
  logic [($clog2(
TICKS_PER_BAUD_COUNT
) == 1) ? 1 : $clog2(
TICKS_PER_BAUD_COUNT
)-1 : 0]
      counter_ps, counter_ns;  // Counter to track ticks

  generate
    if (BAUD_RATE > SYS_CLK_FREQ || SYS_CLK_FREQ <= 0 || BAUD_RATE <= 0) begin : check_constraints
      $fatal(
          "Error: Config error (BAUD_RATE (%0d) and SYS_CLK_FREQ (%0d))", BAUD_RATE, SYS_CLK_FREQ
      );
    end
  endgenerate

  always_ff @(posedge Sys_Clk_In) begin
    if (Rst_In || !BRG_En_In) begin
      counter_ps <= 0;
    end else begin
      counter_ps <= counter_ns;
    end
  end
  assign counter_ns=(counter_ps == TICKS_PER_BAUD_COUNT - 1) ? 0 : counter_ps + 1;  // Next state logic for counter

  assign Tick_Out = (counter_ps == TICKS_PER_BAUD_COUNT - 1) ? 1'b1 : 1'b0;  // Generate tick when counter reaches max

endmodule
