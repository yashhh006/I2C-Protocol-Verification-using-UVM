`ifndef I2C_SBD_SVH
`define I2C_SBD_SVH


class i2c_sbd extends uvm_scoreboard;
  `uvm_component_utils(i2c_sbd)
  uvm_analysis_imp#(i2c_tx,i2c_sbd) sbd_imp;
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
    sbd_imp=new("sbd_imp",this);
  endfunction

  function void write(i2c_tx t);
    
  endfunction
endclass

`endif