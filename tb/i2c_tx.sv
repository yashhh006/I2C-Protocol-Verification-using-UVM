`ifndef I2C_TX_SVH
`define I2C_TX_SVH


class i2c_tx extends uvm_sequence_item;
  logic [6:0] slave_addr=7'h3c;
  rand logic [7:0] addr_in;
  rand logic wr_rd;
  rand logic [7:0] data[$];
  
  
  `new_obj
  `uvm_object_utils_begin(i2c_tx)
  //`uvm_field_int(sda,UVM_ALL_ON)
  `uvm_field_int(addr_in,UVM_ALL_ON)
  `uvm_object_utils_end
endclass

`endif