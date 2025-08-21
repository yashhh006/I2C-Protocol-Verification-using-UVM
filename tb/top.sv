`ifndef TOP_SVH
`define TOP_SVH


`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "i2c_comm.sv"
`include "i2c_intf.sv"
`include "i2c_tx.sv"
`include "i2c_seq.sv"
`include "i2c_sqr.sv"
`include "i2c_drv.sv"
`include "i2c_cov.sv"
`include "i2c_mon.sv"
`include "i2c_agent.sv"
`include "i2c_sbd.sv"
`include "i2c_env.sv"
`include "i2c_test.sv"

module top;
  bit clk,rstn;
  i2c_intf pif(.clk(clk),.rstn(rstn));
  
  always #1.4 clk=~clk;
  
  initial begin
    rstn=1;
    repeat(2)@(posedge clk);
    rstn=0;
  end
  
  i2cSlaveTop dut(.clk(pif.clk),.sda(pif.sda),.scl(pif.scl),
                  .rst(pif.rstn),.myReg0(pif.myReg0));
  
  initial begin
    uvm_config_db#(virtual i2c_intf)::set(null,"*","i2c_intf",pif);
  end
  
  initial begin
    run_test("i2c_test");
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top.pif.clk);
    $dumpvars(0, top.pif.rstn);
    $dumpvars(0, top.pif.sda);
    $dumpvars(0, top.pif.scl);
    $dumpvars(0, top.pif.myReg0);
  
  // Add the specific internal DUT signals you need
    $dumpvars(0, top.dut.u_i2cSlave.u_serialInterface.CurrState_SISt);
    $dumpvars(0, top.dut.u_i2cSlave.u_serialInterface.rxData);
  end
  
endmodule

`endif