`ifndef I2C_COV_SVH
`define I2C_COV_SVH


class i2c_cov extends uvm_subscriber#(i2c_tx)	;
  `uvm_component_utils(i2c_cov)
  i2c_tx tx;
  
  covergroup cg;
    
  endgroup
  
  function new(string name="", uvm_component parent);
    super.new(name,parent);
    cg=new();
  endfunction
  
  function void write(i2c_tx t);
    this.tx=t;
    
  endfunction
endclass

`endif