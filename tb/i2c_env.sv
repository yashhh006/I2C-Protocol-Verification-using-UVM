`ifndef I2C_ENV_SVH
`define I2C_ENV_SVH


class i2c_env extends uvm_env;
  `uvm_component_utils(i2c_env)
  
  i2c_agent agt;
  i2c_sbd sbd;
  
  `new_comp
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sbd=i2c_sbd::type_id::create("sbd",this);
	agt=i2c_agent::type_id::create("agt",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.ap_port.connect(sbd.sbd_imp);
  endfunction
endclass

`endif