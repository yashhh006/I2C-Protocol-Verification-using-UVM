`ifndef I2C_MON_SVH
`define I2C_MON_SVH


class i2c_mon extends uvm_monitor ;
  `uvm_component_utils(i2c_mon)
  uvm_analysis_port#(i2c_tx) ap_port;
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
    ap_port=new("ap_port",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  function void write(i2c_tx t);
    
  endfunction
  
  task run_phase(uvm_phase phase);
    
  endtask
endclass

`endif