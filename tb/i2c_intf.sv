`ifndef I2C_INTF_SVH
`define I2C_INTF_SVH


interface i2c_intf(input logic clk,rstn);
  wire sda;
  logic scl;
  logic [7:0] myReg0;

  //assign sda = sda_out ;
  
endinterface

`endif