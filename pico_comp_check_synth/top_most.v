module Top_most(clock, foundDatainCache_core, Reset);
    
    
   input clock, Reset;
   output foundDatainCache_core;
   
   reg  resetn;
   //wire foundDatainCache_core; 
    wire foundDatainCache_core, clk_100, clk_10;
  picorv32 core (.clk_100(clock),.clk(clk_10), .resetn(Reset), .foundDatainCache_core(foundDatainCache_core));  
    
  //mainMod  cache (.foundDatainCache(foundDatainCache));
    
 clk_wiz_0 instance_name1 //// Processor and yacc are at 10 Mhz and ILA is running at 100 Mhz (As ILA was not showing correct result if everything is on 100 Mhz)
   (
    // Clock out ports
    .clk_out1(clk_100),     // output clk_out1
    .clk_out2(clk_10),     // output clk_out2
   // Clock in ports
    .clk_in1(clock));      // input clk_in1
   
/*    initial begin
    clock=0;
    clk_10=0;
    end
    
    always #10 clk_10 = ~clk_10;
    always #1 clock = ~clock;*/
    
    
    
endmodule