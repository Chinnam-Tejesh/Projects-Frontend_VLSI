/*
################################################################################
# -PARENT NAME: None
# -MODULE NAME: PISRAM.sv
# -FILE CREATED: 8-Oct-2026
# -FILE REVISED [DATE]: see commit history
# -DESCRIPTION: Parallel Interface SRAM
#
################################################################################
# Notes
# -Op stands for Operation (used in port identifiers)
#
################################################################################
*/

`timescale 1ns / 1ps

module PISRAM #(
    BIT_WIDTH = 8,
    RAM_SIZE  = 256
) (
    input clk_in,  // System Clock 
    arstOut_in,  // Reset (flush) Output ports (always_ff) - asynchronous 

    input dataOutEn_in,  // Enable data out for external read operation 
    dataInEn_in,  // Enable data in for internal write operation 

    input [BIT_WIDTH - 1 : 0] dataWriteOp_in,  // Data lines for internal write 

    input [$clog2(RAM_SIZE) - 1 : 0] addressReadOp_in,  // Address lines for external read
    addressWriteOp_in,  // Address lines for internal write

    output logic [BIT_WIDTH - 1 : 0] dataReadOp_out,  // Data lines for external read
    output logic invalidAddress  // High meaning that address is outside limits of storage 
);

  logic [BIT_WIDTH - 1 : 0] storage[0 : RAM_SIZE - 1];  // the storage

  always_ff @(posedge clk_in or negedge arstOut_in) begin
    if (!arstOut_in) begin
      dataReadOp_out <= 0;
      invalidAddress <= 1'b0;
    end else begin
      dataReadOp_out <= 0;  // Default value of dataReadOp_out
      invalidAddress <= 0;  // Default value of invalidAddress
      case ({
        dataOutEn_in, dataInEn_in
      })
        2'b10: begin : ReadOperation
          if (addressReadOp_in < RAM_SIZE)  // Not really needed to check if address is between zero
            dataReadOp_out <= storage[addressReadOp_in];  // External read operation
          else invalidAddress <= 1'b1;
        end

        2'b01: begin : WriteOperation
          if (addressWriteOp_in < RAM_SIZE)  // Not really needed to check if address is between zero
            storage[addressWriteOp_in] <= dataWriteOp_in;  // Internal write operation
          else invalidAddress <= 1'b1;
        end
      endcase
    end
  end

endmodule
