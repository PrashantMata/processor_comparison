
		//*****************************************************************************
		
		
		//**********************************YACC_32 Bits***************************************
		
		
		
	
		
		
		
		
		
		
module mainMod(clk_10, clk_100,address,Data,mem_wstrb_yacc, mem_wdata_yacc, data_out_cache,foundDatainCache,address_delay5, counter);
input [31:0] counter;
input clk_10;
input clk_100;
//output reg ena;

input [31:0]Data;
input [31:0] mem_wdata_yacc;
input [3:0] mem_wstrb_yacc;
input [31:0]address;
output reg [31:0] data_out_cache;
output reg [31:0] address_delay5;
//tag-27 bits, index-3 bits, block id-2 bits
parameter dataSize=31; 
parameter way=7;
parameter set=7;
parameter SBtagsize=34;
//Superblock: valid_bits- 2 bits[34:33], tag-27 bits [32:6], comp_factor-2 bits[5:4], valid_bits-4 bits[3:0]

reg [SBtagsize:0]tagArray[set:0][way:0];
reg [dataSize:0]dataArray[set:0][way:0];
reg [2:0]lruShiftReg[set:0][way:0];
//wire [11:0] Address;
output reg foundDatainCache;
reg [31:0]data; //Data 
 
reg [1:0] CF;
reg [31:0] aa,bb;
reg [31:0] address_delay1,address_delay2, address_delay3, address_delay4, address_delay6, address_delay7;
//integer file_outputs; // var to see if file exists 
//integer scan_outputs; // captured text handler

integer cache_Hit=0,cache_Miss=0;
//integer count=0,enter=0;
reg [2:0] index;
reg [1:0] blockId;
reg [26:0] tag;
reg matchFlag;
reg [dataSize:0] updatedData;
reg [63:0] cachestatus;
//reg [2:0]check;
reg check1;
reg check2;
reg [3:0] mem_wstrb_yacc1,qq;
reg [2:0] w;
reg [31:0] data_delay,data_delay1;
//reg [2:0] i;
//reg k;

//initial k=0;
//always @(address) k=1;




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

bb=32'h00000000;




end

//assign address = address_new;

always @ (posedge clk_10)
begin

//address <= address_new;
/*address_delay1 <=aa;
address_delay2 <=address_delay1;
address_delay3 <=address_delay2;
address_delay4 <=address_delay3;
address_delay5 <=address_delay4;*/
//address_delay6 <=address_delay5;
//address_delay7 <=address_delay6;

//address <=aa;
bb<=address;


mem_wstrb_yacc1 <=mem_wstrb_yacc;
qq<=mem_wstrb_yacc1;

end


always @(posedge clk_10) 
begin
data_delay<=Data;
data_delay1<=data_delay;
end


/*always @ (address) begin

index = address[4:2]; //integer index
blockId = address[1:0];
tag = address[31:5];

end*/

//assign Data[127:32] = 0;
//assign mem_wdata_yacc [127:32] = 0;


	
	
ila_0 your_instance_name (
	.clk(clk_100), // input wire clk


	.probe0(cachestatus), // input wire [63:0]  probe0  
	.probe1(address), // input wire [31:0]  probe1 
	.probe2(clk_10), // input wire [0:0]  probe2
    .probe3(dataArray[2][0]),
    .probe4(dataArray[4][0]),
    .probe5(dataArray[6][0]),
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
                    //No need to go to memory and update cache or use LRU policy
                    //decompress the data and display 
                    
                    data=mem_wdata_yacc;
                    findCompFactor(data,CF);//task
                    updateCache_sw (address,data,CF,w); //YACC logic
            
            
                    //decompress();
                    //cache_Hit=cache_Hit+1;
                    //ena=0;
                    //$display($time ,"  Cache HIT & data read %h & Most_Recent=%b\n",data,lruShiftReg);
                end
            
                else 
                begin
                    //ena=1;
                    //findDataInMemory(address,data);//task
                    //compress();
                    
                    data=mem_wdata_yacc;
                    findCompFactor(data,CF);//task
                    updateCache(address,data,CF,updatedData,cachestatus); //YACC logic
            
                    //send uncompressed data to lower level cache
                    //cache_Miss=cache_Miss+1;
                    
                end	
                
              end  
              
              
         
       else                          //// No store word
       
       
              begin           
        
                if(foundDatainCache==1)
                begin
                    //No need to go to memory and update cache or use LRU policy
                    //decompress the data and display 
            
                    //decompress();
                    //cache_Hit=cache_Hit+1;
                    data_out_cache=data;
                    //ena=0;
                    //$display($time ,"  Cache HIT & data read %h & Most_Recent=%b\n",data,lruShiftReg);
                end
            
                else 
                begin
                    //ena=1;
                    //findDataInMemory(address,data);//task
                    //compress();
                    if(Data != data_delay) begin
                    data=Data;
                    findCompFactor(data,CF);//task
                    updateCache(address,data,CF,updatedData,cachestatus); //YACC logic
                    end
                    
            
                    //send uncompressed data to lower level cache
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

reg[26:0]tag;
reg[1:0]blockId;
reg[1:0]CF;
reg matchFlag;


begin
	index = address[4:2]; //integer index
	blockId = address[1:0];
	tag = address[31:5];
	$display($time,"  tag=%b index=%d blockId=%b ",tag,index,blockId);
	i=0;
	matchFlag = 0;
	foundDatainCache=0;
	while(i<=way && !matchFlag) //Four and 2 blocks will have the same tag in case of CF=00 and CF=01 
	begin
		if(tag == tagArray[index][i][32:6])//If there is a match of tag
		begin		
			if(tagArray[index][i][5:4] == 2'b11)begin
				if(blockId == tagArray[index][i][3:2])
				matchFlag = 1;
			end
			if(tagArray[index][i][5:4] == 2'b01)begin
				if( ((blockId == tagArray[index][i][3:2]) && (tagArray[index][i][34]==1'b1)) || ((blockId == tagArray[index][i][1:0]) && (tagArray[index][i][33]==1'b1)) )
				matchFlag = 1;
			end
			if(tagArray[index][i][5:4] == 2'b10)begin
				if( ((blockId==2'b00)&&(tagArray[index][i][0]==1'b1))||((blockId==2'b01)&&(tagArray[index][i][1]==1'b1))||((blockId==2'b10)&&(tagArray[index][i][2]==1'b1))||((blockId==2'b11)&&(tagArray[index][i][3]==1'b1)) )
					matchFlag = 1;	
			end
		end
	i=i+1;
	end
	
	
	
	//if (matchFlag==0) k=1;
	i=i-1;
	
	if(matchFlag == 1) begin
		CF = tagArray[index][i][5:4];
		
		case(CF)
            2'b11: //No compression
                data=dataArray[index][i];
    
            2'b01: //Compression /2
            begin
                if(blockId == tagArray[index][i][1:0])
                data=dataArray[index][i][15:0];
                if(blockId == tagArray[index][i][3:2])
                data=dataArray[index][i][31:16];
            end
    
            2'b10: //Compression /4
            begin
                if((blockId == 2'b00))
                data=dataArray[index][i][7:0];
                else if((blockId == 2'b01))
                data=dataArray[index][i][15:8];
                else if((blockId == 2'b10))
                data=dataArray[index][i][23:16];
                else
                data=dataArray[index][i][31:24];
            end
        
            2'b00:
                data=32'b0;
		endcase
	
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







task findCompFactor;
input [dataSize:0]data;
output[1:0]CF;
begin
	if(data == 32'b0)
		CF=2'b00;// To show all zeros
	else if(data[dataSize:8] == 24'b0) //CF is 4
		CF=2'b10;
	else if(data[dataSize:16] == 16'b0) //CF is 2
		CF=2'b01;	
	else CF=2'b11; //No compression	
	$display($time, "  Comp factor:%b",CF);
end
endtask



task updateCache_sw; //YACC algorithm            (Cache update for store word)
input [31:0]address;
input [dataSize:0]data;
input [1:0] CF;                           
input [2:0] w;
//output [dataSize:0]updatedData; //final concatenated data

reg [2:0] index;
reg[1:0]blockId;
reg[26:0]tag;

begin

	index = address[4:2];
	blockId = address[1:0];
	tag = address[31:5];    // Remember only case of CF=2 and CF=4 is considered for now, uncompressed is still remaining


            if(CF == 2'b01)begin
                dataArray[index][w][15:0]=data[15:0];
				
				//SBtag = {tag,CF,2'b00,blockId};
			end
			else begin
				//bit is 1 in that position to indicate data exist
				case(blockId)
					2'b00:begin
					 dataArray[index][w][7:0]=data[7:0];
						//updatedData = {384'b0,data[127:0]};
						//SBtag = {tag,CF,3'b0,1'b1}; 
					end
					2'b01:begin
					 dataArray[index][w][15:8]=data[7:0];
						//updatedData = {256'b0,data[127:0],128'b0};
						//SBtag = {tag,CF,2'b0,1'b1,1'b0}; 
					end
					2'b10:begin
					 dataArray[index][w][23:16]=data[7:0];
					    //updatedData = {128'b0,data[127:0],256'b0};
						//SBtag = {tag,CF,1'b0,1'b1,2'b0}; 
					end
					
					2'b11:begin
					 dataArray[index][w][31:24]=data[7:0];
						//updatedData = {data[127:0],384'b0};
						//SBtag = {tag,CF,1'b1,3'b0}; 
					end	
					
				
				endcase
			end		


end
endtask




task updateCache; //YACC algorithm
input [31:0]address;
input [dataSize:0]data;
input [1:0] CF;

reg [2:0] index,i;

output [dataSize:0]updatedData; //final concatenated data
reg[1:0]blockId;
reg[26:0]tag;

reg [5:0] cacheaddress;
output [63:0] cachestatus;

reg [SBtagsize:0]SBtag;

reg isEmpty,isMatch,isUpdated,isLRU; //flags

begin
/* First find the index where the data has to be stored..
Based on the CF check the matching block or an empty block
If yes, then add and update the tag array and counter array corresponding to CF
If none of the block is free, then find the LRU block and delete that whole block and update with a new
block. 
*/	
	i=0;
	isEmpty=1'b0; isMatch=1'b0; isUpdated=1'b0; isLRU=1'b0;
	index = address[4:2];
	blockId = address[1:0];
	tag = address[31:5];
	
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
	
            if(CF == 2'b11)begin
            // No point in finding the matching block because whole block has to be replaced.
                findEmptyBlock(index,i,isEmpty);//task
                
                if(!(isEmpty))begin
                    lruPolicy(index,i,isLRU); //index is input.. i is output
                end
                    
                SBtag = {2'b00, tag,CF,blockId,2'b00};  ////////////////////////////////////////////////////////changed as per cf2 req
                
                
                updateDataTagArray(data,SBtag,index,i,1'b0,isLRU);//task
                
                cacheaddress = {index,i};
                cachestatus[cacheaddress]=1;
                
            end
            
            else begin
            /*In case of /2 and /4 CF we have to find the blocks which are existing and which are half empty
              If Yes, then just update the required part
              If No, then find an empty block and then update the same
              If no empty block then use LRU policy 
              
              In each case updating data and tag array is different */	   
                findMatchingTags(tag,CF,index,i,isMatch);//task
                if(!isMatch)
                begin
                    findEmptyBlock(index,i,isEmpty);
                    
                    if(!(isEmpty))begin
                        lruPolicy(index,i,isLRU);
                    end
                    //No match found..  Update block as new block			
                    if(CF == 2'b01)begin
                        updatedData = {16'b0,data[15:0]};
                        SBtag = {2'b01, tag,CF,2'b00,blockId};             ////////////////////////////////////////////////////////changed as per cf2 req
                    end
                    else begin
                        //bit is 1 in that position to indicate data exist
                        case(blockId)
							2'b00:begin
								updatedData = {24'b0,data[7:0]};
								SBtag = {2'b00,tag,CF,3'b0,1'b1};   /////////////////////////////////////////// change as per cf2 req
							end
							2'b01:begin
								updatedData = {16'b0,data[7:0],8'b0};
								SBtag = {2'b00,tag,CF,2'b0,1'b1,1'b0};   /////////////////////////////////////////// change as per cf2 req
							end
							2'b10:begin
								updatedData = {8'b0,data[7:0],16'b0};
								SBtag = {2'b00,tag,CF,1'b0,1'b1,2'b0};    /////////////////////////////////////////// change as per cf2 req
							end
							
							2'b11:begin
								updatedData = {data[7:0],24'b0};
								SBtag = {2'b00,tag,CF,1'b1,3'b0};           /////////////////////////////////////////// change as per cf2 req
					        end	
                            
                            
                            //updatedData = {128'b0,data[127:0],256'b0};
                            //updatedData = {data[127:0],384'b0};				
                        endcase
                    end		
                    cacheaddress = {index,i};
                cachestatus[cacheaddress]=1;	
                end
                
                else begin
                //Match found...Update only required part
                    if(CF == 2'b01)begin
						updatedData = {data[15:0],dataArray[index][i][15:0]};
						SBtag = {2'b11,tagArray[index][i][32:4],blockId,tagArray[index][i][1:0]};   /////////////////////////////////////////// changed as per cf2 req
					end
					
					else begin
					/* for CF=10 3 possible vacant spaces can exist and the data has to be stored in corresponding
					  locations since blockId for CF=10 is not stored... */
						if( (tagArray[index][i][0] == 1'b0) && (blockId == 2'b00) )begin
							updatedData = {dataArray[index][i][31:8],data[7:0]};
							SBtag = {2'b00,tagArray[index][i][32:1],1'b1};  /////////////////////////////////////////// change as per cf2 req
						end
						
						if( (tagArray[index][i][1] == 1'b0) && (blockId == 2'b01) )begin
							updatedData = {dataArray[index][i][31:16],data[7:0],dataArray[index][i][7:0]};
							SBtag = {2'b00,tagArray[index][i][32:2],1'b1,tagArray[index][i][0]};   /////////////////////////////////////////// change as per cf2 req
						end
						
						if( (tagArray[index][i][2] == 1'b0) && (blockId == 2'b10) )begin
							updatedData = {dataArray[index][i][31:24],data[7:0],dataArray[index][i][15:0]};
							SBtag = {2'b00,tagArray[index][i][32:3],1'b1,tagArray[index][i][1:0]};   /////////////////////////////////////////// change as per cf2 req
						end
						
						if( (tagArray[index][i][3] == 1'b0) && (blockId == 2'b11) )begin
							updatedData = {data[7:0],dataArray[index][i][23:0]};
							SBtag = {2'b00,tagArray[index][i][32:4],1'b1,tagArray[index][i][2:0]};   /////////////////////////////////////////// change as per cf2 req
						end
                        
                            
                                        
                    end
                    isUpdated=1'b1;
                end		
                
                cacheaddress = {index,i};
                cachestatus[cacheaddress]=1;
                
                updateDataTagArray(updatedData,SBtag,index,i,isUpdated,isLRU);
            end
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
		if(dataArray[index][i] == 32'b0)//zeros are used for showing empty location
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

task findMatchingTags;
input [26:0]tag;//change to [26:0]
input [1:0]CF;
input integer index;
output integer i;
output isMatch;
begin
	i=0;isMatch=1'b0;
	while((i<=way) && (!isMatch))begin
		if( (tag == tagArray[index][i][32:6])&&(CF == tagArray[index][i][5:4]) )begin		
			if(CF == 2'b01)begin
				if(dataArray[index][i][31:16] == 16'b0)
					isMatch=1;
			end
			else begin
				if( (dataArray[index][i][7:0]==8'b0)||(dataArray[index][i][15:8]==8'b0)||(dataArray[index][i][23:16]==8'b0)||(dataArray[index][i][31:24]==8'b0) )
					isMatch=1;
			end
		end
		i=i+1;
	end
	i=i-1;
	$display($time, "  Entered matching tags Index=%d",i);
end 
endtask

task updateDataTagArray;
input[dataSize:0]updatedData;
input[SBtagsize:0]SBtag;
input integer index,i;
input isUpdated,isLRU;
integer j;
begin
		j=way;
		dataArray[index][i]=updatedData;
		tagArray[index][i]=SBtag;
		//update LRU shift register
		if( (isUpdated)||(isLRU) )
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





