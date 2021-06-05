
		//*****************************************************************************
		
		
		//**********************************Uncompressed_Cache_32_bits***************************************
		
		
		
	
		
		
		
		
		
		
module mainMod(clk_10, clk_100, address,Data,mem_wstrb_yacc, mem_wdata_yacc, data_out_cache,foundDatainCache,address_delay5, counter);

input [31:0] counter;
input clk_10;
input clk_100;



input [31:0]Data;
input [31:0] mem_wdata_yacc;
input [3:0] mem_wstrb_yacc;
input [31:0]address;
output reg [31:0] data_out_cache;
output reg [31:0] address_delay5;
//tag-29 bits, index-3 bits
parameter dataSize=31; 
parameter way=7;
parameter set=7;
parameter SBtagsize=29; // 29 tag bits and 1 valid bit


reg [SBtagsize:0]tagArray[set:0][way:0];
reg [dataSize:0]dataArray[set:0][way:0];
reg [2:0]lruShiftReg[set:0][way:0];

output reg foundDatainCache;
reg [31:0]data; //Data 

reg [31:0] aa,bb;
reg [31:0] address_delay1,address_delay2, address_delay3, address_delay4, address_delay6, address_delay7;


integer cache_Hit=0,cache_Miss=0;

reg [2:0] index;

reg [28:0] tag;
reg matchFlag;
reg [dataSize:0] updatedData;
reg [63:0] cachestatus;

reg check1;
reg check2;
reg [3:0] mem_wstrb_yacc1,qq;
reg [2:0] w;
reg [31:0] data_delay,data_delay1;
reg [3:0] p,q;




initial begin

tagArray[0][0] = 0;
dataArray[0][0]= 0;
tagArray[0][1] = 0;
dataArray[0][1]= 0;


dataArray[1][0]= 0;
tagArray[1][0] = 0;
dataArray[1][2]= 0;
tagArray[1][2] = 0;
dataArray[1][1]= 0;
tagArray[1][1] = 0;


dataArray[2][0]= 0;
dataArray[2][1]= 0;
tagArray[2][0] = 0;
tagArray[2][1] = 0;

dataArray[3][0]= 0;
dataArray[3][1]= 0;
tagArray[3][0] = 0;
tagArray[3][1] = 0;

dataArray[4][0]= 0;
dataArray[4][1]= 0;
tagArray[4][0] = 0;
tagArray[4][1] = 0;

dataArray[5][0]= 0;
dataArray[5][1]= 0;
tagArray[5][0] = 0;
tagArray[5][1] = 0;

dataArray[6][0]= 0;
dataArray[6][1]= 0;
tagArray[6][0] = 0;
tagArray[6][1] = 0;

dataArray[7][0]= 0;
tagArray[7][0] = 0;

dataArray[7][1]= 0;
tagArray[7][1] = 0;

dataArray[7][2]= 0;
tagArray[7][2] = 0;
cachestatus=0;
bb=32'h00000000;



end



always @ (posedge clk_10)
begin



bb<=address;


mem_wstrb_yacc1 <=mem_wstrb_yacc;
qq<=mem_wstrb_yacc1;

end


always @(posedge clk_10) 
begin
data_delay<=Data;
data_delay1<=data_delay;
end


/* always @ (address) begin

index = address[2:0]; 

tag = address[31:3];

end
 */
 
 
 
 ila_0 your_instance_name (
	.clk(clk_100), // input wire clk


	.probe0(cachestatus), // input wire [63:0]  probe0  
	.probe1(address), // input wire [31:0]  probe1 
	.probe2(clk_10), // input wire [0:0]  probe2
    .probe3(dataArray[2][0]),
    .probe4(cache_Hit),
    .probe5(cache_Miss),
    .probe6(Data),
    .probe7(foundDatainCache)	
);	
 
 
 
 


always @(posedge clk_10) //Only when there is a change in the address
begin

    
 if(address != bb) begin
    
        findDataInCache(address,foundDatainCache,data,matchFlag,w);//task
 end
    
    if((mem_wstrb_yacc1 [3:0] == 4'b1111)&& (mem_wstrb_yacc1 != qq)) //// when store word instruction is fetched by processor (different way of writing into the cache)
            begin
                
                if(foundDatainCache==1)
                begin
                    

                    data=mem_wdata_yacc;
                    
                    updateCache_sw (address,data,w); 
            
                    //cache_Hit=cache_Hit+1;
                    
                    //$display($time ,"  Cache HIT & data read %h & Most_Recent=%b\n",data,lruShiftReg);
                end
            
                else 
                begin
                    

                    data=mem_wdata_yacc;
                    updateCache(address,data,updatedData,cachestatus); 
					//cache_Miss=cache_Miss+1;
                    
                end	
                
              end  
              
              
         
       else if(mem_wstrb_yacc1 [3:0] == 4'b0000)                          //// No store word
       
       
              begin           
        
                if(foundDatainCache==1)
                begin
                    //No need to go to memory and update cache or use LRU policy

                    //cache_Hit=cache_Hit+1;
                    data_out_cache=data;
                    
                    //$display($time ,"  Cache HIT & data read %h & Most_Recent=%b\n",data,lruShiftReg);
                end
            
                else 
                begin

                    if(Data != data_delay) begin
                    data=Data;
                    updateCache(address,data,updatedData,cachestatus); 
                    end
                    //cache_Miss=cache_Miss+1;
                    
                end	
                
              end  
          
      
            
	//count=count+1;
end




task findDataInCache;
input [31:0] address;
output foundDatainCache;
output[dataSize:0]data;
output matchFlag;
output [2:0] w;
integer i;

integer index;

reg[28:0]tag;

reg matchFlag;


begin
	index = address[2:0]; //integer index
	//blockId = address[1:0];
	tag = address[31:3];
     //$display($time,"  tag=%b index=%d blockId=%b ",tag,index,blockId);
	i=0;
	matchFlag = 0;
	foundDatainCache=0;
	while(i<=way && !matchFlag) 
	begin
		if((tag == tagArray[index][i][28:0]) && (tagArray[index][i][29] == 1))//If there is a match of tag
		begin		
			matchFlag = 1;	
		
		end
	i=i+1;
	end
	
	
	
	//if (matchFlag==0) k=1;
	i=i-1;
	
	if(matchFlag == 1) begin
		
        data=dataArray[index][i];

		foundDatainCache = 1;
		cache_Hit=cache_Hit+1;
		//Update LRU shift register..
		/*i is the way where the data has been found
		  find i in shift reg and shift data till until i is not found.. It is for sure will be there
		  lruSR[index][0 to i]*/		  
		updateLruShiftRegister(index,i,check1,check2);
		w=i;
	end// only if there is a match of address in cache 
	
	else
		cache_Miss=cache_Miss+1;
end
endtask






task updateCache_sw; //           (Cache update for store word)
input [31:0]address;
input [dataSize:0]data;

input [2:0] w;
//output [dataSize:0]updatedData; //final concatenated data

reg [2:0] index;
reg[28:0]tag;

begin

	index = address[2:0];
	//blockId = address[1:0];
	tag = address[31:3];

		dataArray[index][w]=data;

end
endtask




task updateCache; 
input [31:0]address;
input [dataSize:0]data;

reg [2:0] index,i;

output [dataSize:0]updatedData; //final concatenated data
reg[28:0]tag;

reg [5:0] cacheaddress;
output [63:0] cachestatus;

reg [SBtagsize:0]SBtag;

reg isEmpty,isLRU; //flags

begin
	i=0;
	isEmpty=1'b0; isLRU=1'b0;
	index = address[2:0];
	tag = address[31:3];

if (data[6:0] == 7'b0110011) begin
	 cachestatus=0;
	 
	 
	 dataArray[0][0]= 0;
     dataArray[0][1]= 0;
     dataArray[0][2]= 0;
     dataArray[0][3]= 0;
	 
     dataArray[1][0]= 0;
     dataArray[1][1]= 0;
     dataArray[1][2]= 0;
     dataArray[1][3]= 0;
	 
     dataArray[2][0]= 0;
     dataArray[2][1]= 0;
	 dataArray[2][2]= 0;
     dataArray[2][3]= 0;

     dataArray[3][0]= 0;
     dataArray[3][1]= 0;
	 dataArray[3][2]= 0;
     dataArray[3][3]= 0;

     dataArray[4][0]= 0;
     dataArray[4][1]= 0;
	 dataArray[4][2]= 0;
     dataArray[4][3]= 0;

     dataArray[5][0]= 0;
     dataArray[5][1]= 0;
	 dataArray[5][2]= 0;
     dataArray[5][3]= 0;

     dataArray[6][0]= 0;
     dataArray[6][1]= 0;
	 dataArray[6][2]= 0;
     dataArray[6][3]= 0;
     
     dataArray[7][0]= 0;
     dataArray[7][1]= 0;
	 dataArray[7][2]= 0;
     dataArray[7][3]= 0;
     
     tagArray[0][0]= 0;
     tagArray[0][1]= 0;
	 tagArray[0][2]= 0;
     tagArray[0][3]= 0;
     
     tagArray[1][0]= 0;
     tagArray[1][1]= 0;
	 tagArray[1][2]= 0;
     tagArray[1][3]= 0;
     
     tagArray[2][0]= 0;
     tagArray[2][1]= 0;
	 tagArray[2][2]= 0;
     tagArray[2][3]= 0;

     tagArray[3][0]= 0;
     tagArray[3][1]= 0;
	 tagArray[3][2]= 0;
     tagArray[3][3]= 0;

     tagArray[4][0]= 0;
     tagArray[4][1]= 0;
	 tagArray[4][2]= 0;
     tagArray[4][3]= 0;

     tagArray[5][0]= 0;
     tagArray[5][1]= 0;
	 tagArray[5][2]= 0;
     tagArray[5][3]= 0;

     tagArray[6][0]= 0;
     tagArray[6][1]= 0;
	 tagArray[6][2]= 0;
     tagArray[6][3]= 0;
     
     tagArray[7][0]= 0;
     tagArray[7][1]= 0;
	 tagArray[7][2]= 0;
     tagArray[7][3]= 0;
	 
	 
	 dataArray[0][4]= 0;
     dataArray[0][5]= 0;
     dataArray[0][6]= 0;
     dataArray[0][7]= 0;
	 
     dataArray[1][4]= 0;
     dataArray[1][5]= 0;
     dataArray[1][6]= 0;
     dataArray[1][7]= 0;
	 
     dataArray[2][4]= 0;
     dataArray[2][5]= 0;
	 dataArray[2][6]= 0;
     dataArray[2][7]= 0;

     dataArray[3][4]= 0;
     dataArray[3][5]= 0;
	 dataArray[3][6]= 0;
     dataArray[3][7]= 0;

     dataArray[4][4]= 0;
     dataArray[4][5]= 0;
	 dataArray[4][6]= 0;
     dataArray[4][7]= 0;

     dataArray[5][4]= 0;
     dataArray[5][5]= 0;
	 dataArray[5][6]= 0;
     dataArray[5][7]= 0;

     dataArray[6][4]= 0;
     dataArray[6][5]= 0;
	 dataArray[6][6]= 0;
     dataArray[6][7]= 0;
     
     dataArray[7][4]= 0;
     dataArray[7][5]= 0;
	 dataArray[7][6]= 0;
     dataArray[7][7]= 0;
     
     tagArray[0][4]= 0;
     tagArray[0][5]= 0;
	 tagArray[0][6]= 0;
     tagArray[0][7]= 0;
     
     tagArray[1][4]= 0;
     tagArray[1][5]= 0;
	 tagArray[1][6]= 0;
     tagArray[1][7]= 0;
     
     tagArray[2][4]= 0;
     tagArray[2][5]= 0;
	 tagArray[2][6]= 0;
     tagArray[2][7]= 0;

     tagArray[3][4]= 0;
     tagArray[3][5]= 0;
	 tagArray[3][6]= 0;
     tagArray[3][7]= 0;

     tagArray[4][4]= 0;
     tagArray[4][5]= 0;
	 tagArray[4][6]= 0;
     tagArray[4][7]= 0;

     tagArray[5][4]= 0;
     tagArray[5][5]= 0;
	 tagArray[5][6]= 0;
     tagArray[5][7]= 0;

     tagArray[6][4]= 0;
     tagArray[6][5]= 0;
	 tagArray[6][6]= 0;
     tagArray[6][7]= 0;
     
     tagArray[7][4]= 0;
     tagArray[7][5]= 0;
	 tagArray[7][6]= 0;
     tagArray[7][7]= 0;
	 
	end
	else begin

	
            
            
                findEmptyBlock(index,i,isEmpty);//task
                
                if(!(isEmpty))begin
                    lruPolicy(index,i,isLRU); //index is input.. i is output
                end
                    
                SBtag = {1'b1,tag}; 
                
                
                updateDataTagArray(data,SBtag,index,i,isLRU);//task
                
                cacheaddress = {index,i};
                cachestatus[cacheaddress]=1;
                	
        end
end
endtask



task findEmptyBlock;
input integer index;
output integer i;
output isEmpty;
begin
	i=0;isEmpty=1'b0;
	while(i<=way && !isEmpty)begin
		if(dataArray[index][i] === 32'b0)//zeros are used for showing empty location
			isEmpty=1; //flag has been used in order to break from the loop...
		i=i+1;
	end
	i=i-1;
	$display($time, "  Empty block: Index=%d",i);
end 
endtask

task lruPolicy;
input integer index;
output integer i;
output isLRU;
begin
	i=lruShiftReg[index][way]; //Just return the least used way(that is way=7) to main function	
	isLRU=1'b1;
	$display($time, "  LRU index=%d",i);
end 
endtask



task updateDataTagArray;
input[dataSize:0]updatedData;
input[SBtagsize:0]SBtag;
input integer index,i;
input isLRU;
integer j;
begin
		j=way;
		dataArray[index][i]=updatedData;
		tagArray[index][i]=SBtag;
		//update LRU shift register
		if(isLRU)
			updateLruShiftRegister(index,i,check1,check2);
		else begin
			while(j!=0)
			begin
				lruShiftReg[index][j]=lruShiftReg[index][j-1];
				j=j-1;
			end
			lruShiftReg[index][j]=i;	
		end
		//$display($time , "  Data=%h  SBtag=%b  Most_Recent=%b",dataArray[index][i],tagArray[index][i],lruShiftReg);
end
endtask

task updateLruShiftRegister;
input integer index,i;
//output check;
output check1;
output check2;
integer j;
reg p; //for loop purpose
//reg [2:0]check;
reg check1;
reg check2;
begin
	j=0;
    p=0;
    check1=0;
    check2=0;
    
	if(lruShiftReg[index][0]!=i) begin
	
	
         /*while(lruShiftReg[index][j]!=i)
			j=j+1;
		  while (j!=0)begin
			lruShiftReg[index][j]=lruShiftReg[index][j-1];
			j=j-1;
		end
		lruShiftReg[index][0]=i;*/	
	
			
         
           
           
          if (lruShiftReg[index][1]==i) begin
              j=1;
              p=1;
              lruShiftReg[index][j]=lruShiftReg[index][j-1];end
              
          else if (j!=1)begin 
               if (lruShiftReg[index][2]==i) begin
               j=2;
              end
            
               else begin
                   if (lruShiftReg[index][3]==i) begin
                   j=3;
                   end
                   
                   else begin 
                      if (lruShiftReg[index][4]==i) begin
                      j=4;      
                       end
                       
                      else begin 
                          if (lruShiftReg[index][5]==i) begin
                          j=5;    
                         end
                          
                          else begin 
                             if (lruShiftReg[index][6]==i) begin
                             j=6;
                             end
                             
                             else begin
                             
                                if (lruShiftReg[index][7]==i) begin
                                j=7;
                                end
                                                                     
                             end
                          end
                      end
                   end
                end
                //check=j;
                p=1;
                
                      if (p==1) begin
                      check2=1;
                          if (j==0)begin
                            lruShiftReg[index][j]=lruShiftReg[index][j-1];
                            j=j-1;
                            end 
                            
                          else begin 
                               lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                j=j-1;
                                if(j==0) check1=1;
                                
                                else begin
                                    lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                    j=j-1;
                                    if(j==0) check1=1;
                                     
                                    else begin
                                        lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                        j=j-1;
                                        if(j==0) check1=1;
                                        
                                        else begin
                                            lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                            j=j-1;
                                            if(j==0) check1=1;
                                            
                                            else begin
                                                lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                                j=j-1;
                                                if(j==0) check1=1;
                                                
                                                else begin
                                                    lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                                    j=j-1;
                                                    if(j==0) check1=1;
                             
                                                    else begin
                                                        lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                                        j=j-1;
                                                     end
                                                 end       
                                             end
                                         end 
                                      end
                                  end
                             end                 
                                             
                                             
                                                     
                                                        
                                 /* else if (j!=0)begin
                                    lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                    j=j-1;
                                
                                end
                                
                                
                                   else if (j!=0)begin
                                    lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                    j=j-1;
                                    check1=1;
                                    
                                end
                                
                                   else if (j!=0)begin
                                    lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                    j=j-1;
                                
                                end
                                   
                                   else if (j!=0)begin
                                    lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                    j=j-1;
                                    
                                end
                                   
                                   else if (j!=0)begin
                                    lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                    j=j-1;
                                    
                                end
                                   
                                    else if (j!=0) begin
                                    lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                    j=j-1;
                                    
                                end
                                
                                    else if (j!=0) begin
                                    lruShiftReg[index][j]=lruShiftReg[index][j-1];
                                    j=j-1;
                                end*/
                end
                  
 
           end
           
          /*if (p==1) begin
             while (j!=0)begin
                lruShiftReg[index][j]=lruShiftReg[index][j-1];
                j=j-1;
            end
          end*/
          
          
          

	    
	     lruShiftReg[index][0]=i;

	end
	
	
end
endtask









endmodule



















