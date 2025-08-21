`ifndef I2C_DRV_SVH
`define I2C_DRV_SVH


class i2c_drv extends uvm_driver#(i2c_tx);
  `uvm_component_utils(i2c_drv)
  `new_comp
  virtual i2c_intf vif;
  i2c_tx tx;
  int ct;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual i2c_intf)::get(this,"","i2c_intf",vif);
  endfunction
  
  task run_phase(uvm_phase phase);
    vif.scl <= 1'b1;
    ct=0;
    fork
      clock();
    join_none
    
    forever begin
      seq_item_port.get_next_item(req);
      drive_tx(req);
      seq_item_port.item_done();
    end
  endtask
  
  task drive_tx(i2c_tx tx);
    // Combine the slave address and write bit into one byte
    logic [7:0] slave_addr_byte = {tx.slave_addr, tx.wr_rd};
    `uvm_info("DRV_DEBUG", $sformatf("About to drive slave_addr_byte. Value: 0x%h", slave_addr_byte), UVM_NONE)
  
    // 1. Start the transaction
    start();
    
    // 2. Drive the SLAVE ADDRESS byte
    drive_byte(slave_addr_byte);
    check_ack();
    
    // 3. Drive the REGISTER ADDRESS byte
    drive_byte(tx.addr_in);
    check_ack();
    
    // 4. Loop through and drive all DATA bytes
    foreach (tx.data[0][i]) begin
      drive_byte(tx.data[0][i]);
      check_ack();
    end
    
    // 5. Stop the transaction
    stopped();
  endtask
  
  task clock();
    forever begin
      @(posedge vif.clk);
      
      if (ct == 139) begin
          vif.scl <= ~vif.scl;
          ct <= 0;       
      end else begin
          ct <= ct + 1;
      end
    end
  endtask
  
  task start();
    // Ensure SCL is high
    @(posedge vif.clk iff vif.scl == 1);
    
    // Make sure SDA is high before we start
    vif.sda <= 1'b1;
    #1; // Small delay
    
    // Pull SDA low to signal START
    vif.sda <= 1'b0;
  endtask
  
  task drive_byte(logic [7:0] byte_to_drive);
    // Loop 8 times to send each bit
    for (int i = 7; i >= 0; i--) begin
      // Ensure SCL is low before changing SDA
      @(posedge vif.clk iff vif.scl == 0);
      
      //`uvm_info("DRV_BIT_OUT", $sformatf("Driving bit[%0d]: %b", i, byte_to_drive[i]), UVM_NONE)
      // Drive the current bit
      vif.sda <= byte_to_drive[i];
      
      // Pulse SCL high to clock the bit in
      @(posedge vif.clk iff vif.scl == 1);
    end
    
    @(posedge vif.clk iff vif.scl == 0);
  endtask
  
  task check_ack_old();
    bit ack_received;
    
    // Ensure SCL is low
    @(posedge vif.clk iff vif.scl == 0);
    
    // Release SDA so the slave can drive it
    vif.sda <= 1'bz; 
    
    // On the rising edge of SCL, sample SDA
    @(posedge vif.clk iff vif.scl == 1);
    if (vif.sda == 1'b0) begin
      ack_received = 1;
      `uvm_info("DRV", "ACK received", UVM_HIGH)
    end else begin
      ack_received = 0;
      `uvm_error("DRV", "NACK received or bus not driven")
    end
  endtask
  
  task check_ack();
    bit ack_received;

    // SCL is already low, so we can release SDA immediately
    vif.sda <= 1'bz;
    
    // Now wait for SCL to go high to sample the ACK bit
    @(posedge vif.clk iff vif.scl == 1);

    if (vif.sda == 1'b0) begin
      `uvm_info("DRV", "ACK received", UVM_HIGH)
    end else begin
      `uvm_error("DRV", "NACK received or bus not driven")
    end
  endtask

  
  
  
  task stopped();
    // Ensure SCL is low
    @(posedge vif.clk iff vif.scl == 0);
    
    // Make sure SDA is low before we start
    vif.sda <= 1'b0;
    #1; // Small delay
  
    // Ensure SCL is high
    @(posedge vif.clk iff vif.scl == 1);
    
    // Pull SDA high to signal STOP
    vif.sda <= 1'b1;
  endtask



endclass

`endif