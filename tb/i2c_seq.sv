`ifndef I2C_SEQ_SVH
`define I2C_SEQ_SVH


class i2c_seq extends uvm_sequence#(i2c_tx);
  `uvm_object_utils(i2c_seq)
  `new_obj
  i2c_tx tx;
  
  task body;
    
    //repeat(7)begin
    `uvm_do_with (req, {req.wr_rd==0;
                        req.addr_in==8'h01;
                        req.data.size()==7;
                        req.data[0]==8'hcc;})
    //end
  endtask
endclass

`endif