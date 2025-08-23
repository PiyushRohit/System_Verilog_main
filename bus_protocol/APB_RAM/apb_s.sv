`timescale 1ns/1ps

module apb_s
(
    input        pclk,
    input        presetn,
    input  [31:0] paddr,
    input        psel,
    input        penable,
    input  [7:0] pwdata,
    input        pwrite,

    output reg [7:0] prdata,
    output reg       pready,
    output           pslverr
);

  localparam [1:0] idle = 0, write = 1, read = 2;
  reg [7:0] mem[16];

  reg [1:0] state, nstate;

  reg addr_err, addv_err, data_err;

  // Reset + state update
  always @(posedge pclk or negedge presetn) begin
    if (!presetn)
      state <= idle;
    else
      state <= nstate;
  end

  // FSM + outputs
  always @(*) begin
    case (state)
      idle: begin
        prdata = 8'h00;
        pready = 1'b0;

        if (psel && pwrite)
          nstate = write;
        else if (psel && !pwrite)
          nstate = read;
        else
          nstate = idle;
      end

      write: begin
        if (psel && penable) begin
          if (!addr_err && !addv_err && !data_err) begin
            pready = 1'b1;
            mem[paddr] = pwdata;
            nstate = idle;
          end else begin
            pready = 1'b1;
            nstate = idle;
          end
        end
      end

      read: begin
        if (psel && penable) begin
          if (!addr_err && !addv_err && !data_err) begin
            pready = 1'b1;
            prdata = mem[paddr];
            nstate = idle;
          end else begin
            pready = 1'b1;
            prdata = 8'h00;
            nstate = idle;
          end
        end
      end

      default: begin
        nstate = idle;
        prdata = 8'h00;
        pready = 1'b0;
      end
    endcase
  end

  // Error checks
  always @(*) addv_err = 1'b0; // unsigned addr always >=0
  always @(*) data_err = 1'b0; // unsigned data always >=0

  assign addr_err = ((nstate == write) || (nstate == read)) && (paddr > 15);
  assign pslverr  = (psel && penable) ? (addr_err || addv_err || data_err) : 1'b0;

endmodule


interface apb_if();
   logic        pclk;
   logic        presetn;
   logic [31:0] paddr;
   logic        psel;
   logic        penable;
   logic [7:0]  pwdata;
   logic        pwrite;
   logic [7:0]  prdata;
   logic        pready;
   logic        pslverr;
endinterface

