`timescale 1ns / 1ps

module tb;

  reg clk = 0;
  reg clk50 = 0;

  // Generate 100 MHz clock (10 ns period)
  always #5 clk = ~clk;

  // Clock generation parameters
  real phase;
  real ton;
  real toff;

  // Task to calculate ton and toff based on frequency and duty cycle
  task calc (
    input real freq_hz,
    input real duty_cycle,
    input real phase_ns,
    output real phase_out,
    output real ton_out,
    output real toff_out
  );
    begin
      phase_out = phase_ns;
      ton_out = (1.0 / freq_hz) * duty_cycle * 1e9;  // ns
      toff_out = (1e9 / freq_hz) - ton_out;          // ns
    end
  endtask

  // Task to generate clock with given ton, toff, and phase
  task clkgen (
    input real phase_ns,
    input real ton_ns,
    input real toff_ns
  );
    integer i;
    begin
      @(posedge clk);
      #phase_ns;
      for (i = 0; i < 10; i = i + 1) begin // generate 10 pulses
        clk50 = 1;
        #ton_ns;
        clk50 = 0;
        #toff_ns;
      end
    end
  endtask

  // Initialize and run
  initial begin
    calc(100_000_000, 0.1, 2, phase, ton, toff); // 100 MHz, 10% duty, 2 ns phase
    clkgen(phase, ton, toff);
    $finish;
  end

  initial begin
    $dumpfile("dut.vcd");
    $dumpvars(0, tb);
  end

endmodule
