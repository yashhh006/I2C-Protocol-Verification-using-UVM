`define new_comp\
function new(string name="",uvm_component parent);\
  super.new(name,parent);\
endfunction

`define new_obj\
function new(string name="");\
  super.new(name);\
endfunction