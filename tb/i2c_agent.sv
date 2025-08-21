`ifndef I2C_AGENT_SVH
`define I2C_AGENT_SVH


class i2c_agent extends uvm_agent;
  `uvm_component_utils(i2c_agent)
  
  i2c_sqr sqr;
  i2c_drv drv;
  i2c_mon mon;
  i2c_cov cov;
  
  `new_comp
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr=i2c_sqr::type_id::create("sqr",this);
    drv=i2c_drv::type_id::create("drv",this);
    mon=i2c_mon::type_id::create("mon",this);
    cov=i2c_cov::type_id::create("cov",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(sqr .seq_item_export);
    mon.ap_port.connect(cov.analysis_export);
  endfunction
endclass

`endif