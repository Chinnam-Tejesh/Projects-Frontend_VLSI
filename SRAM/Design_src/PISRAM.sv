/*
################################################################################
# -PARENT NAME: None
# -MODULE NAME: SRAM.sv
# -FILE CREATED: 8-Oct-2026
# -FILE REVISED [DATE]: see commit history
# -DESCRIPTION: (Parallel Interfaced) SRAM
#
################################################################################
# Notes
#
################################################################################
*/

`timescale 1ns / 1ps

module SRAM #(
    BIT_WIDTH = 8,
    RAM_SIZE  = 256
) (
    input clk_in,  // System Clock 
    arstOut_in,  // Reset Output ports - asynchronous 

    input dataOutEn_in,  // Enable data out for external read operation 
    dataInEn_in,  // Enable data in for internal write operation 

    input [BIT_WIDTH - 1 : 0] data_in,  // Data lines for internal write 

    input [$clog2(RAM_SIZE) - 1 : 0] addressRead_in,  // Address lines for external read
    addressWrite_in,  // Address lines for internal write

    output logic [BIT_WIDTH - 1 : 0] data_out  // Data lines for external read
);

  logic [BIT_WIDTH - 1 : 0] storage[0 : RAM_SIZE - 1];  // the storage

  always_ff @(posedge clk_in or negedge arstOut_in) begin
    if (arstOut_in == 0) begin
      data_out <= 0;
    end else begin
      data_out <= 0;  // Default value of data_out
      case ({
        dataOutEn_in, dataInEn_in
      })
        10: data_out <= storage[addressRead_in];  // External read operation
        01: storage[addressWrite_in] <= data_in;  // Internal write operation
      endcase
    end
  end
endmodule
