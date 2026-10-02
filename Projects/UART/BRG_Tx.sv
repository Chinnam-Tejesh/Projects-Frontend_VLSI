/*
################################################################################
# -PARENT NAME: UART_Tx.sv
# -MODULE NAME: BRG_Tx.sv
# -REVISION [DATE]: 2023-10-01
# -DESCRIPTION: Baud Rate Generator for UART Transmitter
#
################################################################################
*/

/* 
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
  localparam integer TICKS_PER_BAUD_COUNT = SYS_CLK_FREQ / BAUD_RATE;  // Calculate ticks per baud
  logic [$clog2(TICKS_PER_BAUD_COUNT)-1:0] counter_ps, counter_ns;  // Counter to track ticks

  always_ff @(posedge Sys_Clk_In) begin
    if (Rst_In || !BRG_En_In) begin
      counter_ps <= 0;
    end else begin
      if (counter_ns == TICKS_PER_BAUD_COUNT) begin
        counter_ps <= 0;
      end else begin
        counter_ps <= counter_ps + 1;
      end
    end
  end

  always_comb begin
    counter_ns = counter_ps + 1;  // Next state of counter
  end

  assign Tick_Out = (counter_ps == TICKS_PER_BAUD_COUNT - 1) ? 1'b1 : 1'b0;  // Generate tick when counter reaches max

endmodule
