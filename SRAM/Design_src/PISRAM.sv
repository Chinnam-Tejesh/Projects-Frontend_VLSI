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
# -invalidOp_o covers address invalid OR (input) invalid case of en ports 
#
################################################################################
*/

`timescale 1ns / 1ps

module PISRAM #(
    parameter int unsigned BIT_WIDTH = 8,
    parameter int unsigned RAM_SIZE  = 256
) (
    input clk_i,  // System Clock 
    arst_i,  // Reset (flush) Output ports (always_ff) - asynchronous 

    input data_out_en_i,  // Enable data out lines for external read operation (read en) 
    data_in_en_i,  // Enable data in lines for internal write operation (write en)

    input [BIT_WIDTH - 1 : 0] data_writeOp_i,  // Data lines for internal write 

    input [$clog2(RAM_SIZE) - 1 : 0] address_readOp_i,  // Address lines for external read
    address_writeOp_i,  // Address lines for internal write

    output logic invalidOp_o,  // High meaning invalid operation 
    output logic [BIT_WIDTH - 1 : 0] data_readOp_o  // Data lines for external read
);

  generate
    begin : Parameters_Checks
      if (BIT_WIDTH <= 1) $fatal(1, "BIT_WIDTH with value %0d is not allowed", BIT_WIDTH);
      if (RAM_SIZE <= 1) $fatal(1, "RAM_SIZE with value %0d is not allowed", RAM_SIZE);
    end
  endgenerate

  logic [BIT_WIDTH - 1 : 0] storage[0 : RAM_SIZE - 1];  // the storage

  always_ff @(posedge clk_i or negedge arst_i) begin
    if (!arst_i) begin
      data_readOp_o <= 0;
      invalidOp_o   <= 1'b0;
    end else begin
      data_readOp_o <= 0;  // Default value of data_readOp_o
      invalidOp_o   <= 0;  // Default value of invalidOp_o
      case ({
        data_out_en_i, data_in_en_i
      })
        2'b10: begin : Read_Operation
          if (address_readOp_i < RAM_SIZE)  // Not really needed to check if address is between zero
            data_readOp_o <= storage[address_readOp_i];
          else invalidOp_o <= 1'b1;
        end

        2'b01: begin : Write_Operation
          if (address_writeOp_i < RAM_SIZE)  // Not really needed to check if address is between zero
            storage[address_writeOp_i] <= data_writeOp_i;
          else invalidOp_o <= 1'b1;
        end

        default: begin : Invalid_Case  // Covers 00 (design choice) and 11 case
          invalidOp_o <= 1'b1;
        end
      endcase
    end
  end

endmodule
