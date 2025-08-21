`ifndef I2C_TEST_SVH
`define I2C_TEST_SVH


class i2c_test extends uvm_test;
  `uvm_component_utils(i2c_test)
  `new_comp
  
  i2c_env env;
  
  function void build_phase(uvm_phase phase);
    env=i2c_env::type_id::create("env",this);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
  task run_phase(uvm_phase phase);
    i2c_seq seq;
    seq=i2c_seq::type_id::create("seq1");
    
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this,100000);
    seq.start(env.agt.sqr);
    phase.drop_objection(this);
  endtask
endclass

`endif