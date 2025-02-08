//////////////AddRoundKey

module addroundkey(
    input [0:127] key,  
    input [0:127] word, 
    output reg [127:0] out 
);
always @(*) begin
    out = key ^ word;
end

endmodule

//////////////keyExpantion

module keyExp#(parameter Nk=8)(key,ExpKey);

input [(Nk*32)-1:0] key;// 6*32=192

localparam Nb = 4;//always equal to 4
localparam Nr = Nk+6;
localparam keyLn = Nb*(Nr+1)*32 - 1;

output wire [0:keyLn] ExpKey;
//parameter Nr = 10;

wire [31:0] w [0: Nb*(Nr+1)-1];
wire [31:0] subKey [0:Nb*(Nr+1)-1];

function [31:0] rotWord(input [31:0] origin);
    begin
    rotWord={origin[23:0],origin[31:24]};
end
endfunction

// function [0:7]sWord(input [0:7]in);

// case (in)
//         8'h00: sWord=8'h63;       8'h01: sWord=8'h7c;         8'h02: sWord=8'h77;         8'h03: sWord=8'h7b;
// 	    8'h04: sWord=8'hf2;       8'h05: sWord=8'h6b;         8'h06: sWord=8'h6f;         8'h07: sWord=8'hc5;
// 	    8'h08: sWord=8'h30;       8'h09: sWord=8'h01;         8'h0a: sWord=8'h67;         8'h0b: sWord=8'h2b;
// 	    8'h0c: sWord=8'hfe;       8'h0d: sWord=8'hd7;         8'h0e: sWord=8'hab;         8'h0f: sWord=8'h76;
// 	    8'h10: sWord=8'hca;       8'h11: sWord=8'h82;         8'h12: sWord=8'hc9;         8'h13: sWord=8'h7d;
// 	    8'h14: sWord=8'hfa;       8'h15: sWord=8'h59;         8'h16: sWord=8'h47;         8'h17: sWord=8'hf0;
// 	    8'h18: sWord=8'had;       8'h19: sWord=8'hd4;         8'h1a: sWord=8'ha2;         8'h1b: sWord=8'haf;
// 	    8'h1c: sWord=8'h9c;       8'h1d: sWord=8'ha4;         8'h1e: sWord=8'h72;         8'h1f: sWord=8'hc0;
// 	    8'h20: sWord=8'hb7;       8'h21: sWord=8'hfd;         8'h22: sWord=8'h93;         8'h23: sWord=8'h26;
// 	    8'h24: sWord=8'h36;       8'h25: sWord=8'h3f;         8'h26: sWord=8'hf7;         8'h27: sWord=8'hcc;
// 	    8'h28: sWord=8'h34;       8'h29: sWord=8'ha5;         8'h2a: sWord=8'he5;         8'h2b: sWord=8'hf1;
// 	    8'h2c: sWord=8'h71;       8'h2d: sWord=8'hd8;         8'h2e: sWord=8'h31;         8'h2f: sWord=8'h15;
//         8'h30: sWord=8'h04;       8'h31: sWord=8'hc7;         8'h32: sWord=8'h23;         8'h33: sWord=8'hc3;
//         8'h34: sWord=8'h18;       8'h35: sWord=8'h96;         8'h36: sWord=8'h05;         8'h37: sWord=8'h9a;
// 	    8'h38: sWord=8'h07;       8'h39: sWord=8'h12;         8'h3a: sWord=8'h80;         8'h3b: sWord=8'he2;
//         8'h3c: sWord=8'heb;       8'h3d: sWord=8'h27;         8'h3e: sWord=8'hb2;         8'h3f: sWord=8'h75;
//         8'h40: sWord=8'h09;       8'h41: sWord=8'h83;         8'h42: sWord=8'h2c;         8'h43: sWord=8'h1a;
//         8'h44: sWord=8'h1b;       8'h45: sWord=8'h6e;         8'h46: sWord=8'h5a;         8'h47: sWord=8'ha0;
//         8'h48: sWord=8'h52;       8'h49: sWord=8'h3b;         8'h4a: sWord=8'hd6;         8'h4b: sWord=8'hb3;
//         8'h4c: sWord=8'h29;       8'h4d: sWord=8'he3;         8'h4e: sWord=8'h2f;         8'h4f: sWord=8'h84;
//         8'h50: sWord=8'h53;       8'h51: sWord=8'hd1;         8'h52: sWord=8'h00;         8'h53: sWord=8'hed;
//         8'h54: sWord=8'h20;       8'h55: sWord=8'hfc;         8'h56: sWord=8'hb1;         8'h57: sWord=8'h5b;
//         8'h58: sWord=8'h6a;       8'h59: sWord=8'hcb;         8'h5a: sWord=8'hbe;         8'h5b: sWord=8'h39;
//         8'h5c: sWord=8'h4a;       8'h5d: sWord=8'h4c;         8'h5e: sWord=8'h58;         8'h5f: sWord=8'hcf;
//         8'h60: sWord=8'hd0;       8'h61: sWord=8'hef;         8'h62: sWord=8'haa;         8'h63: sWord=8'hfb;
//         8'h64: sWord=8'h43;       8'h65: sWord=8'h4d;         8'h66: sWord=8'h33;         8'h67: sWord=8'h85;
//         8'h68: sWord=8'h45;       8'h69: sWord=8'hf9;         8'h6a: sWord=8'h02;         8'h6b: sWord=8'h7f;
//         8'h6c: sWord=8'h50;       8'h6d: sWord=8'h3c;         8'h6e: sWord=8'h9f;         8'h6f: sWord=8'ha8;
//         8'h70: sWord=8'h51;       8'h71: sWord=8'ha3;         8'h72: sWord=8'h40;         8'h73: sWord=8'h8f;
//         8'h74: sWord=8'h92;       8'h75: sWord=8'h9d;         8'h76: sWord=8'h38;         8'h77: sWord=8'hf5;
//         8'h78: sWord=8'hbc;       8'h79: sWord=8'hb6;         8'h7a: sWord=8'hda;         8'h7b: sWord=8'h21;
//         8'h7c: sWord=8'h10;       8'h7d: sWord=8'hff;         8'h7e: sWord=8'hf3;         8'h7f: sWord=8'hd2;
//         8'h80: sWord=8'hcd;       8'h81: sWord=8'h0c;         8'h82: sWord=8'h13;         8'h83: sWord=8'hec;
//         8'h84: sWord=8'h5f;       8'h85: sWord=8'h97;         8'h86: sWord=8'h44;         8'h87: sWord=8'h17;
//         8'h88: sWord=8'hc4;       8'h89: sWord=8'ha7;         8'h8a: sWord=8'h7e;         8'h8b: sWord=8'h3d;
//         8'h8c: sWord=8'h64;       8'h8d: sWord=8'h5d;         8'h8e: sWord=8'h19;         8'h8f: sWord=8'h73;
//         8'h90: sWord=8'h60;       8'h91: sWord=8'h81;         8'h92: sWord=8'h4f;         8'h93: sWord=8'hdc;
//         8'h94: sWord=8'h22;       8'h95: sWord=8'h2a;         8'h96: sWord=8'h90;         8'h97: sWord=8'h88;
//         8'h98: sWord=8'h46;       8'h99: sWord=8'hee;         8'h9a: sWord=8'hb8;         8'h9b: sWord=8'h14;
//         8'h9c: sWord=8'hde;       8'h9d: sWord=8'h5e;         8'h9e: sWord=8'h0b;         8'h9f: sWord=8'hdb;
//         8'ha0: sWord=8'he0;       8'ha1: sWord=8'h32;         8'ha2: sWord=8'h3a;         8'ha3: sWord=8'h0a;
//         8'ha4: sWord=8'h49;       8'ha5: sWord=8'h06;         8'ha6: sWord=8'h24;         8'ha7: sWord=8'h5c;
//         8'ha8: sWord=8'hc2;       8'ha9: sWord=8'hd3;         8'haa: sWord=8'hac;         8'hab: sWord=8'h62;
//         8'hac: sWord=8'h91;       8'had: sWord=8'h95;         8'hae: sWord=8'he4;         8'haf: sWord=8'h79;
//         8'hb0: sWord=8'he7;       8'hb1: sWord=8'hc8;         8'hb2: sWord=8'h37;         8'hb3: sWord=8'h6d;
//         8'hb4: sWord=8'h8d;       8'hb5: sWord=8'hd5;         8'hb6: sWord=8'h4e;         8'hb7: sWord=8'ha9;
//         8'hb8: sWord=8'h6c;       8'hb9: sWord=8'h56;         8'hba: sWord=8'hf4;         8'hbb: sWord=8'hea;
//         8'hbc: sWord=8'h65;       8'hbd: sWord=8'h7a;         8'hbe: sWord=8'hae;         8'hbf: sWord=8'h08;
//         8'hc0: sWord=8'hba;       8'hc1: sWord=8'h78;         8'hc2: sWord=8'h25;         8'hc3: sWord=8'h2e;
//         8'hc4: sWord=8'h1c;       8'hc5: sWord=8'ha6;         8'hc6: sWord=8'hb4;         8'hc7: sWord=8'hc6;
//         8'hc8: sWord=8'he8;       8'hc9: sWord=8'hdd;         8'hca: sWord=8'h74;         8'hcb: sWord=8'h1f;
//         8'hcc: sWord=8'h4b;       8'hcd: sWord=8'hbd;         8'hce: sWord=8'h8b;         8'hcf: sWord=8'h8a;
//         8'hd0: sWord=8'h70;       8'hd1: sWord=8'h3e;         8'hd2: sWord=8'hb5;         8'hd3: sWord=8'h66;
//         8'hd4: sWord=8'h48;       8'hd5: sWord=8'h03;         8'hd6: sWord=8'hf6;         8'hd7: sWord=8'h0e;
//         8'hd8: sWord=8'h61;       8'hd9: sWord=8'h35;         8'hda: sWord=8'h57;         8'hdb: sWord=8'hb9;
//         8'hdc: sWord=8'h86;       8'hdd: sWord=8'hc1;         8'hde: sWord=8'h1d;         8'hdf: sWord=8'h9e;
//         8'he0: sWord=8'he1;       8'he1: sWord=8'hf8;         8'he2: sWord=8'h98;         8'he3: sWord=8'h11;
//         8'he4: sWord=8'h69;       8'he5: sWord=8'hd9;         8'he6: sWord=8'h8e;         8'he7: sWord=8'h94;
//         8'he8: sWord=8'h9b;       8'he9: sWord=8'h1e;         8'hea: sWord=8'h87;         8'heb: sWord=8'he9;
//         8'hec: sWord=8'hce;       8'hed: sWord=8'h55;         8'hee: sWord=8'h28;         8'hef: sWord=8'hdf;
//         8'hf0: sWord=8'h8c;       8'hf1: sWord=8'ha1;         8'hf2: sWord=8'h89;         8'hf3: sWord=8'h0d;
//         8'hf4: sWord=8'hbf;       8'hf5: sWord=8'he6;         8'hf6: sWord=8'h42;         8'hf7: sWord=8'h68;
//         8'hf8: sWord=8'h41;       8'hf9: sWord=8'h99;         8'hfa: sWord=8'h2d;         8'hfb: sWord=8'h0f;
//         8'hfc: sWord=8'hb0;       8'hfd: sWord=8'h54;         8'hfe: sWord=8'hbb;         8'hff: sWord=8'h16;

// 	endcase

// endfunction


// function [0:31] subWord(input [0:31] word);
//     integer i;
//     begin
//         for (i = 0; i < 4; i = i + 1) begin:cntWord
//            //word[i*8+:8] =  sWord (word[i*8+:8]);
// 	  subWord[i*8+:8] = sWord(word[i*8+:8]);
//         end
//     end
// endfunction


function [0:31]Rcon;
input [0:31]round;
begin
case(round)
    4'h1: Rcon=32'h01000000;
    4'h2: Rcon=32'h02000000;
    4'h3: Rcon=32'h04000000;
    4'h4: Rcon=32'h08000000;
    4'h5: Rcon=32'h10000000;
    4'h6: Rcon=32'h20000000;
    4'h7: Rcon=32'h40000000;
    4'h8: Rcon=32'h80000000;
    4'h9: Rcon=32'h1b000000;
    4'ha: Rcon=32'h36000000;
    default: Rcon=32'h00000000;
  endcase
    end
endfunction



//was okey if we were working 128 only :(
// assign w[0] = key[127:96];
// assign w[1] = key[95:64];
// assign w[2] = key[63:32];
// assign w[3] = key[31:0];

// assign ExpKey[0:31]=w[0];
// assign ExpKey[32:63]=w[1];
// assign ExpKey[64:95]=w[2];
// assign ExpKey[96:127]=w[3];


genvar i;
generate
    for (i = 0; i < (Nb*(Nr+1)); i = i + 1) begin:keys//4*(10+1) ->44
		if(i < Nk)//until w[3]/w[5]/w[7] for 128/192/256
		begin
			assign w[i]= key[(32 * Nk) - 1 - i*32 -: 32];
		end 
        else if ((i % Nk) == 0) 
		begin
	    	subBytes sb(rotWord(w[i-1]),subKey[i]);//
	  		assign w[i]= subKey[i] ^ Rcon( (i) / Nk) ^ w[i-Nk];//
        end
		else if(Nk > 6 && ((i % Nk) == 4))
		begin
			subBytes sb(w[i-1],subKey[i]);
			assign w[i]= subKey[i] ^ w[i-Nk];
		end
		else	
		begin
			assign w[i]=w[i-1]^w[i-Nk];
		end
		assign ExpKey[(i*32)+:32] =w[i]; 

    end
endgenerate

endmodule

/////////////////subBytes

module sBox(in,out);
input [7:0]in;
output reg [7:0]out;

always @(*)
    case (in)
        8'h00: out=8'h63;       8'h01: out=8'h7c;         8'h02: out=8'h77;         8'h03: out=8'h7b;
	     8'h04: out=8'hf2;       8'h05: out=8'h6b;         8'h06: out=8'h6f;         8'h07: out=8'hc5;
	     8'h08: out=8'h30;       8'h09: out=8'h01;         8'h0a: out=8'h67;         8'h0b: out=8'h2b;
	     8'h0c: out=8'hfe;       8'h0d: out=8'hd7;         8'h0e: out=8'hab;         8'h0f: out=8'h76;
	     8'h10: out=8'hca;       8'h11: out=8'h82;         8'h12: out=8'hc9;         8'h13: out=8'h7d;
	     8'h14: out=8'hfa;       8'h15: out=8'h59;         8'h16: out=8'h47;         8'h17: out=8'hf0;
	     8'h18: out=8'had;       8'h19: out=8'hd4;         8'h1a: out=8'ha2;         8'h1b: out=8'haf;
	     8'h1c: out=8'h9c;       8'h1d: out=8'ha4;         8'h1e: out=8'h72;         8'h1f: out=8'hc0;
	     8'h20: out=8'hb7;       8'h21: out=8'hfd;         8'h22: out=8'h93;         8'h23: out=8'h26;
	     8'h24: out=8'h36;       8'h25: out=8'h3f;         8'h26: out=8'hf7;         8'h27: out=8'hcc;
	     8'h28: out=8'h34;       8'h29: out=8'ha5;         8'h2a: out=8'he5;         8'h2b: out=8'hf1;
	     8'h2c: out=8'h71;       8'h2d: out=8'hd8;         8'h2e: out=8'h31;         8'h2f: out=8'h15;
        8'h30: out=8'h04;       8'h31: out=8'hc7;         8'h32: out=8'h23;         8'h33: out=8'hc3;
        8'h34: out=8'h18;       8'h35: out=8'h96;         8'h36: out=8'h05;         8'h37: out=8'h9a;
	     8'h38: out=8'h07;       8'h39: out=8'h12;         8'h3a: out=8'h80;         8'h3b: out=8'he2;
        8'h3c: out=8'heb;       8'h3d: out=8'h27;         8'h3e: out=8'hb2;         8'h3f: out=8'h75;
        8'h40: out=8'h09;       8'h41: out=8'h83;         8'h42: out=8'h2c;         8'h43: out=8'h1a;
        8'h44: out=8'h1b;       8'h45: out=8'h6e;         8'h46: out=8'h5a;         8'h47: out=8'ha0;
        8'h48: out=8'h52;       8'h49: out=8'h3b;         8'h4a: out=8'hd6;         8'h4b: out=8'hb3;
        8'h4c: out=8'h29;       8'h4d: out=8'he3;         8'h4e: out=8'h2f;         8'h4f: out=8'h84;
        8'h50: out=8'h53;       8'h51: out=8'hd1;         8'h52: out=8'h00;         8'h53: out=8'hed;
        8'h54: out=8'h20;       8'h55: out=8'hfc;         8'h56: out=8'hb1;         8'h57: out=8'h5b;
        8'h58: out=8'h6a;       8'h59: out=8'hcb;         8'h5a: out=8'hbe;         8'h5b: out=8'h39;
        8'h5c: out=8'h4a;       8'h5d: out=8'h4c;         8'h5e: out=8'h58;         8'h5f: out=8'hcf;
        8'h60: out=8'hd0;       8'h61: out=8'hef;         8'h62: out=8'haa;         8'h63: out=8'hfb;
        8'h64: out=8'h43;       8'h65: out=8'h4d;         8'h66: out=8'h33;         8'h67: out=8'h85;
        8'h68: out=8'h45;       8'h69: out=8'hf9;         8'h6a: out=8'h02;         8'h6b: out=8'h7f;
        8'h6c: out=8'h50;       8'h6d: out=8'h3c;         8'h6e: out=8'h9f;         8'h6f: out=8'ha8;
        8'h70: out=8'h51;       8'h71: out=8'ha3;         8'h72: out=8'h40;         8'h73: out=8'h8f;
        8'h74: out=8'h92;       8'h75: out=8'h9d;         8'h76: out=8'h38;         8'h77: out=8'hf5;
        8'h78: out=8'hbc;       8'h79: out=8'hb6;         8'h7a: out=8'hda;         8'h7b: out=8'h21;
        8'h7c: out=8'h10;       8'h7d: out=8'hff;         8'h7e: out=8'hf3;         8'h7f: out=8'hd2;
        8'h80: out=8'hcd;       8'h81: out=8'h0c;         8'h82: out=8'h13;         8'h83: out=8'hec;
        8'h84: out=8'h5f;       8'h85: out=8'h97;         8'h86: out=8'h44;         8'h87: out=8'h17;
        8'h88: out=8'hc4;       8'h89: out=8'ha7;         8'h8a: out=8'h7e;         8'h8b: out=8'h3d;
        8'h8c: out=8'h64;       8'h8d: out=8'h5d;         8'h8e: out=8'h19;         8'h8f: out=8'h73;
        8'h90: out=8'h60;       8'h91: out=8'h81;         8'h92: out=8'h4f;         8'h93: out=8'hdc;
        8'h94: out=8'h22;       8'h95: out=8'h2a;         8'h96: out=8'h90;         8'h97: out=8'h88;
        8'h98: out=8'h46;       8'h99: out=8'hee;         8'h9a: out=8'hb8;         8'h9b: out=8'h14;
        8'h9c: out=8'hde;       8'h9d: out=8'h5e;         8'h9e: out=8'h0b;         8'h9f: out=8'hdb;
        8'ha0: out=8'he0;       8'ha1: out=8'h32;         8'ha2: out=8'h3a;         8'ha3: out=8'h0a;
        8'ha4: out=8'h49;       8'ha5: out=8'h06;         8'ha6: out=8'h24;         8'ha7: out=8'h5c;
        8'ha8: out=8'hc2;       8'ha9: out=8'hd3;         8'haa: out=8'hac;         8'hab: out=8'h62;
        8'hac: out=8'h91;       8'had: out=8'h95;         8'hae: out=8'he4;         8'haf: out=8'h79;
        8'hb0: out=8'he7;       8'hb1: out=8'hc8;         8'hb2: out=8'h37;         8'hb3: out=8'h6d;
        8'hb4: out=8'h8d;       8'hb5: out=8'hd5;         8'hb6: out=8'h4e;         8'hb7: out=8'ha9;
        8'hb8: out=8'h6c;       8'hb9: out=8'h56;         8'hba: out=8'hf4;         8'hbb: out=8'hea;
        8'hbc: out=8'h65;       8'hbd: out=8'h7a;         8'hbe: out=8'hae;         8'hbf: out=8'h08;
        8'hc0: out=8'hba;       8'hc1: out=8'h78;         8'hc2: out=8'h25;         8'hc3: out=8'h2e;
        8'hc4: out=8'h1c;       8'hc5: out=8'ha6;         8'hc6: out=8'hb4;         8'hc7: out=8'hc6;
        8'hc8: out=8'he8;       8'hc9: out=8'hdd;         8'hca: out=8'h74;         8'hcb: out=8'h1f;
        8'hcc: out=8'h4b;       8'hcd: out=8'hbd;         8'hce: out=8'h8b;         8'hcf: out=8'h8a;
        8'hd0: out=8'h70;       8'hd1: out=8'h3e;         8'hd2: out=8'hb5;         8'hd3: out=8'h66;
        8'hd4: out=8'h48;       8'hd5: out=8'h03;         8'hd6: out=8'hf6;         8'hd7: out=8'h0e;
        8'hd8: out=8'h61;       8'hd9: out=8'h35;         8'hda: out=8'h57;         8'hdb: out=8'hb9;
        8'hdc: out=8'h86;       8'hdd: out=8'hc1;         8'hde: out=8'h1d;         8'hdf: out=8'h9e;
        8'he0: out=8'he1;       8'he1: out=8'hf8;         8'he2: out=8'h98;         8'he3: out=8'h11;
        8'he4: out=8'h69;       8'he5: out=8'hd9;         8'he6: out=8'h8e;         8'he7: out=8'h94;
        8'he8: out=8'h9b;       8'he9: out=8'h1e;         8'hea: out=8'h87;         8'heb: out=8'he9;
        8'hec: out=8'hce;       8'hed: out=8'h55;         8'hee: out=8'h28;         8'hef: out=8'hdf;
        8'hf0: out=8'h8c;       8'hf1: out=8'ha1;         8'hf2: out=8'h89;         8'hf3: out=8'h0d;
        8'hf4: out=8'hbf;       8'hf5: out=8'he6;         8'hf6: out=8'h42;         8'hf7: out=8'h68;
        8'hf8: out=8'h41;       8'hf9: out=8'h99;         8'hfa: out=8'h2d;         8'hfb: out=8'h0f;
        8'hfc: out=8'hb0;       8'hfd: out=8'h54;         8'hfe: out=8'hbb;         8'hff: out=8'h16;

	endcase
endmodule

module subBytes(state,nextState);
input [127:0] state;
output [127:0] nextState;

genvar i;		//variable for generate loop
generate		//generate block
   for(i=0;i<16;i=i+1)	
	begin :cntstate
		sBox cntstate(state[i*8 +:8],nextState[i*8 +:8]);
	end
endgenerate

endmodule

//////////////////shiftRows

module shiftRows(input [0:127] state,output [0:127] shifted);

//first row not shifted
assign shifted[0+:8]=state[0+:8]; //0+:8 means 0:7 , x+ : y => x : x+y-1
assign shifted[32+:8]=state[32+:8];
assign shifted[64+:8]=state[64+:8];
assign shifted[96+:8]=state[96+:8];

//second row will be shifted by 1
assign shifted[8+:8]=state[40+:8];
assign shifted[40+:8]=state[72+:8];
assign shifted[72+:8]=state[104+:8];
assign shifted[104+:8]=state[8+:8];

//third row will be shifted by 2
assign shifted[16+:8]=state[80+:8];
assign shifted[48+:8]=state[112+:8];
assign shifted[80+:8]=state[16+:8];
assign shifted[112+:8]=state[48+:8];

//forth row will be shifted by 3
assign shifted[24+:8]=state[120+:8];
assign shifted[56+:8]=state[24+:8];
assign shifted[88+:8]=state[56+:8];
assign shifted[120+:8]=state[88+:8];

endmodule


//////////////////mixCol

module mixCol(input [0:127] state, output reg [0:127] mixed);
function[0:7] mul2 (input [0:7] state);
if(state[0]==1) 
begin
    mul2=(state << 1)^8'h1b;
end
else
    mul2=state << 1;
endfunction

function[7:0] mul3 (input [7:0] state);
mul3= mul2(state) ^ state;
endfunction

integer i;
always@(*)begin 
for(i=0;i<4;i=i+1)begin:first_32
 mixed[i*32+:8]=mul2(state[(i*32)+:8]) ^ mul3(state[(i*32+8)+:8]) ^ state[(i*32+16)+:8] ^ state[(i*32+24)+:8] ;
 mixed[(i*32+8)+:8]=(state[(i*32)+:8]) ^ mul2(state[(i*32+8)+:8]) ^ mul3(state[(i*32+16)+:8]) ^ state[(i*32+24)+:8] ;
 mixed[(i*32+16)+:8]=(state[(i*32)+:8]) ^ (state[(i*32+8)+:8]) ^ mul2(state[(i*32+16)+:8]) ^ mul3(state[(i*32+24)+:8]) ;
 mixed[(i*32+24)+:8]=mul3(state[(i*32)+:8]) ^ state[(i*32+8)+:8] ^ state[(i*32+16)+:8] ^ mul2(state[(i*32+24)+:8] );
end

end
endmodule

module round(stateReg,key,out);
input [127:0] stateReg;
input [127:0] key;
output wire[127:0] out;
wire [127:0] subToRows,rowsToMix,mixToKey;


subBytes sb(stateReg,subToRows);
shiftRows sr(subToRows,rowsToMix);
mixCol mc(rowsToMix,mixToKey);
//addroundkey ark2(keyReg,mixToKey,out); check it out !!!!!!!!

assign out = key ^ mixToKey;
endmodule




///////////////converter///////////

module binary_to_bcd(input [0:7] in,output reg [0:11]out);//1110

function[0:3] add3(input[0:3] state);
       
        begin
            if(state >= 4'b0101)
                add3 = state + 4'b0011;
            else
                add3 = state;
        end
endfunction


always @(*) begin
out=12'b000000000000;
out[11]=in[0];
out=out<<1;
out[11]=in[1];
out=out<<1;
out[11]=in[2];
out[8+:4]=add3(out[8+:4]);
out=out<<1;
out[11]=in[3];
out[8+:4]=add3(out[8+:4]);
out=out<<1;
out[11]=in[4];
out[8+:4]=add3(out[8+:4]);
out[4+:4]=add3(out[4+:4]);
out=out<<1;
out[11]=in[5];
out[8+:4]=add3(out[8+:4]);
out[4+:4]=add3(out[4+:4]);
out=out<<1;
out[11]=in[6];
out[8+:4]=add3(out[8+:4]);
out[4+:4]=add3(out[4+:4]);
out=out<<1;
out[11]=in[7];
end

endmodule

////////////////display////////////

module SSD(input [0:11]in,output[0:20] led);
function [0:6] to7Segment(input [0:3] state);
begin
case(state)
    4'b0000: to7Segment = 7'b1000000;// 0
    4'b0001: to7Segment = 7'b1111001;// 1
    4'b0010: to7Segment = 7'b0100100;// 2
    4'b0011: to7Segment = 7'b0110000;// 3
    4'b0100: to7Segment = 7'b0011001;// 4
    4'b0101: to7Segment = 7'b0010010;// 5
    4'b0110: to7Segment = 7'b0000010;// 6
    4'b0111: to7Segment = 7'b1111000;// 7
    4'b1000: to7Segment = 7'b0000000;// 8
    4'b1001: to7Segment = 7'b0010000;// 9
    default: to7Segment = 7'b1111111; 
endcase
end
endfunction
assign led[0+:7]=to7Segment(in[0+:4]);
assign led[7+:7]=to7Segment(in[4+:4]);
assign led[14+:7]=to7Segment(in[8+:4]);
endmodule

module SSD_tb();
reg [0:7] in;
wire [0:11] out;
wire [0:11] conv;
wire [0:20] led;
binary_to_bcd btb(in,conv);
SSD s(conv,led);
initial 
begin
assign in=8'b10100011;
#10;
$monitor("in = %h,leds = %h",in,led);
end
endmodule

///////////////cipher

module cipher#(parameter Nk=8)(in,key,clk,out,fullKeysCopy,flag,leds);


localparam Nr=Nk+6;
localparam Nb=4;
localparam keyLn = Nk*32;
localparam fullkeyLn = Nb*(Nr+1)*32 - 1;
//////parameters////
input clk;
//input reset;
input [127:0] in;
input [keyLn-1:0] key;
output reg [127:0] out;
output wire [0:fullkeyLn] fullKeysCopy;
output reg flag;
output wire [0:20] leds; 
//locals
wire [0:fullkeyLn] fullKeys;
reg [127:0] stateReg;
reg [127:0] stateRegTemp;
wire [127:0] state;
wire [127:0] subToRows2;
wire [127:0] rowsToKey;
wire [0:11] bcdOut;


keyExp#(.Nk(Nk)) ke(key,fullKeys);
//assign fullKeys =1408'h000102030405060708090a0b0c0d0e0fd6aa74fdd2af72fadaa678f1d6ab76feb692cf0b643dbdf1be9bc5006830b3feb6ff744ed2c2c9bf6c590cbf0469bf4147f7f7bc95353e03f96c32bcfd058dfd3caaa3e8a99f9deb50f3af57adf622aa5e390f7df7a69296a7553dc10aa31f6b14f9701ae35fe28c440adf4d4ea9c02647438735a41c65b9e016baf4aebf7ad2549932d1f08557681093ed9cbe2c974e13111d7fe3944a17f307a78b4d2b30c5;
assign fullKeysCopy=fullKeys;
//addroundKey ark(fullkeys[0:127],in,state[0]);
integer i=0;

always@(posedge clk)
begin
	if(i==0) 
	begin
		//stateRegTemp=fullKeys[0:191];
		stateReg=fullKeys[0:127] ^ in;//in ^ first 128,192,256  of key
		//stateReg<=keyReg;
		// keyReg<=fullKeys[i*128+:128];
		i<=1; 
		out=in;
		flag=1'b0;
	end
	else if (i<Nr)
	begin
		i = i+1;
		stateReg<=state;
		//stateReg<=keyReg;
		// keyReg<=fullKeys[i*128+:128];
		out<=state;
		//flag = (i==10)?1'b1:1'b0;
	end
	else begin
		out<=fullKeys[Nr*128+:128]^rowsToKey;//to get the last key 
		flag = 1'b1;
	end
end	

round r1(stateReg,fullKeys[i*128+:128],state);
wire [0:20] temp;
binary_to_bcd btb(out[7:0],bcdOut);
SSD ssd(bcdOut,leds);

//last round ->would be used and correct in last round i=10;
subBytes sb2(stateReg,subToRows2);
shiftRows sr2(subToRows2,rowsToKey);

endmodule

module invSbox(in,out);
input [0:7]in;
output reg [0:7]out;

always @(*)
    case (in)
     	8'h00:out =8'h52;
		8'h01:out =8'h09;
		8'h02:out =8'h6a;
		8'h03:out =8'hd5;
		8'h04:out =8'h30;
		8'h05:out =8'h36;
		8'h06:out =8'ha5;
		8'h07:out =8'h38;
		8'h08:out =8'hbf;
		8'h09:out =8'h40;
		8'h0a:out =8'ha3;
		8'h0b:out =8'h9e;
		8'h0c:out =8'h81;
		8'h0d:out =8'hf3;
		8'h0e:out =8'hd7;
		8'h0f:out =8'hfb;
		8'h10:out =8'h7c;
		8'h11:out =8'he3;
		8'h12:out =8'h39;
		8'h13:out =8'h82;
		8'h14:out =8'h9b;
		8'h15:out =8'h2f;
		8'h16:out =8'hff;
		8'h17:out =8'h87;
		8'h18:out =8'h34;
		8'h19:out =8'h8e;
		8'h1a:out =8'h43;
		8'h1b:out =8'h44;
		8'h1c:out =8'hc4;
		8'h1d:out =8'hde;
		8'h1e:out =8'he9;
		8'h1f:out =8'hcb;
		8'h20:out =8'h54;
		8'h21:out =8'h7b;
		8'h22:out =8'h94;
		8'h23:out =8'h32;
		8'h24:out =8'ha6;
		8'h25:out =8'hc2;
		8'h26:out =8'h23;
		8'h27:out =8'h3d;
		8'h28:out =8'hee;
		8'h29:out =8'h4c;
		8'h2a:out =8'h95;
		8'h2b:out =8'h0b;
		8'h2c:out =8'h42;
		8'h2d:out =8'hfa;
		8'h2e:out =8'hc3;
		8'h2f:out =8'h4e;
		8'h30:out =8'h08;
		8'h31:out =8'h2e;
		8'h32:out =8'ha1;
		8'h33:out =8'h66;
		8'h34:out =8'h28;
		8'h35:out =8'hd9;
		8'h36:out =8'h24;
		8'h37:out =8'hb2;
		8'h38:out =8'h76;
		8'h39:out =8'h5b;
		8'h3a:out =8'ha2;
		8'h3b:out =8'h49;
		8'h3c:out =8'h6d;
		8'h3d:out =8'h8b;
		8'h3e:out =8'hd1;
		8'h3f:out =8'h25;
		8'h40:out =8'h72;
		8'h41:out =8'hf8;
		8'h42:out =8'hf6;
		8'h43:out =8'h64;
		8'h44:out =8'h86;
		8'h45:out =8'h68;
		8'h46:out =8'h98;
		8'h47:out =8'h16;
		8'h48:out =8'hd4;
		8'h49:out =8'ha4;
		8'h4a:out =8'h5c;
		8'h4b:out =8'hcc;
		8'h4c:out =8'h5d;
		8'h4d:out =8'h65;
		8'h4e:out =8'hb6;
		8'h4f:out =8'h92;
		8'h50:out =8'h6c;
		8'h51:out =8'h70;
		8'h52:out =8'h48;
		8'h53:out =8'h50;
		8'h54:out =8'hfd;
		8'h55:out =8'hed;
		8'h56:out =8'hb9;
		8'h57:out =8'hda;
		8'h58:out =8'h5e;
		8'h59:out =8'h15;
		8'h5a:out =8'h46;
		8'h5b:out =8'h57;
		8'h5c:out =8'ha7;
		8'h5d:out =8'h8d;
		8'h5e:out =8'h9d;
		8'h5f:out =8'h84;
		8'h60:out =8'h90;
		8'h61:out =8'hd8;
		8'h62:out =8'hab;
		8'h63:out =8'h00;
		8'h64:out =8'h8c;
		8'h65:out =8'hbc;
		8'h66:out =8'hd3;
		8'h67:out =8'h0a;
		8'h68:out =8'hf7;
		8'h69:out =8'he4;
		8'h6a:out =8'h58;
		8'h6b:out =8'h05;
		8'h6c:out =8'hb8;
		8'h6d:out =8'hb3;
		8'h6e:out =8'h45;
		8'h6f:out =8'h06;
		8'h70:out =8'hd0;
		8'h71:out =8'h2c;
		8'h72:out =8'h1e;
		8'h73:out =8'h8f;
		8'h74:out =8'hca;
		8'h75:out =8'h3f;
		8'h76:out =8'h0f;
		8'h77:out =8'h02;
		8'h78:out =8'hc1;
		8'h79:out =8'haf;
		8'h7a:out =8'hbd;
		8'h7b:out =8'h03;
		8'h7c:out =8'h01;
		8'h7d:out =8'h13;
		8'h7e:out =8'h8a;
		8'h7f:out =8'h6b;
		8'h80:out =8'h3a;
		8'h81:out =8'h91;
		8'h82:out =8'h11;
		8'h83:out =8'h41;
		8'h84:out =8'h4f;
		8'h85:out =8'h67;
		8'h86:out =8'hdc;
		8'h87:out =8'hea;
		8'h88:out =8'h97;
		8'h89:out =8'hf2;
		8'h8a:out =8'hcf;
		8'h8b:out =8'hce;
		8'h8c:out =8'hf0;
		8'h8d:out =8'hb4;
		8'h8e:out =8'he6;
		8'h8f:out =8'h73;
		8'h90:out =8'h96;
		8'h91:out =8'hac;
		8'h92:out =8'h74;
		8'h93:out =8'h22;
		8'h94:out =8'he7;
		8'h95:out =8'had;
		8'h96:out =8'h35;
		8'h97:out =8'h85;
		8'h98:out =8'he2;
		8'h99:out =8'hf9;
		8'h9a:out =8'h37;
		8'h9b:out =8'he8;
		8'h9c:out =8'h1c;
		8'h9d:out =8'h75;
		8'h9e:out =8'hdf;
		8'h9f:out =8'h6e;
		8'ha0:out =8'h47;
		8'ha1:out =8'hf1;
		8'ha2:out =8'h1a;
		8'ha3:out =8'h71;
		8'ha4:out =8'h1d;
		8'ha5:out =8'h29;
		8'ha6:out =8'hc5;
		8'ha7:out =8'h89;
		8'ha8:out =8'h6f;
		8'ha9:out =8'hb7;
		8'haa:out =8'h62;
		8'hab:out =8'h0e;
		8'hac:out =8'haa;
		8'had:out =8'h18;
		8'hae:out =8'hbe;
		8'haf:out =8'h1b;
		8'hb0:out =8'hfc;
		8'hb1:out =8'h56;
		8'hb2:out =8'h3e;
		8'hb3:out =8'h4b;
		8'hb4:out =8'hc6;
		8'hb5:out =8'hd2;
		8'hb6:out =8'h79;
		8'hb7:out =8'h20;
		8'hb8:out =8'h9a;
		8'hb9:out =8'hdb;
		8'hba:out =8'hc0;
		8'hbb:out =8'hfe;
		8'hbc:out =8'h78;
		8'hbd:out =8'hcd;
		8'hbe:out =8'h5a;
		8'hbf:out =8'hf4;
		8'hc0:out =8'h1f;
		8'hc1:out =8'hdd;
		8'hc2:out =8'ha8;
		8'hc3:out =8'h33;
		8'hc4:out =8'h88;
		8'hc5:out =8'h07;
		8'hc6:out =8'hc7;
		8'hc7:out =8'h31;
		8'hc8:out =8'hb1;
		8'hc9:out =8'h12;
		8'hca:out =8'h10;
		8'hcb:out =8'h59;
		8'hcc:out =8'h27;
		8'hcd:out =8'h80;
		8'hce:out =8'hec;
		8'hcf:out =8'h5f;
		8'hd0:out =8'h60;
		8'hd1:out =8'h51;
		8'hd2:out =8'h7f;
		8'hd3:out =8'ha9;
		8'hd4:out =8'h19;
		8'hd5:out =8'hb5;
		8'hd6:out =8'h4a;
		8'hd7:out =8'h0d;
		8'hd8:out =8'h2d;
		8'hd9:out =8'he5;
		8'hda:out =8'h7a;
		8'hdb:out =8'h9f;
		8'hdc:out =8'h93;
		8'hdd:out =8'hc9;
		8'hde:out =8'h9c;
		8'hdf:out =8'hef;
		8'he0:out =8'ha0;
		8'he1:out =8'he0;
		8'he2:out =8'h3b;
		8'he3:out =8'h4d;
		8'he4:out =8'hae;
		8'he5:out =8'h2a;
		8'he6:out =8'hf5;
		8'he7:out =8'hb0;
		8'he8:out =8'hc8;
		8'he9:out =8'heb;
		8'hea:out =8'hbb;
		8'heb:out =8'h3c;
		8'hec:out =8'h83;
		8'hed:out =8'h53;
		8'hee:out =8'h99;
		8'hef:out =8'h61;
		8'hf0:out =8'h17;
		8'hf1:out =8'h2b;
		8'hf2:out =8'h04;
		8'hf3:out =8'h7e;
		8'hf4:out =8'hba;
		8'hf5:out =8'h77;
		8'hf6:out =8'hd6;
		8'hf7:out =8'h26;
		8'hf8:out =8'he1;
		8'hf9:out =8'h69;
		8'hfa:out =8'h14;
		8'hfb:out =8'h63;
		8'hfc:out =8'h55;
		8'hfd:out =8'h21;
		8'hfe:out =8'h0c;
		8'hff:out =8'h7d;
	endcase
endmodule

module invSubBytes(state,nextState);
input [127:0] state;
output [127:0] nextState;

genvar i;		//variable for generate loop
generate		//generate block
   for(i=0;i<16;i=i+1)	
	begin :cntstate
	    invSbox cntstate(state[i*8 +:8],nextState[i*8 +:8]);
	end
endgenerate

endmodule
//////////////////////inverse shiftRows\\\\\\\\\\\\\\\\\\\\\\

module invShiftRows(input [0:127] state,output [0:127] unShifted);
assign unShifted[0+:8]=state[0+:8]; //0+:8 means 0:7 , x+ : y => x : x+y-1
assign unShifted[32+:8]=state[32+:8];
assign unShifted[64+:8]=state[64+:8];
assign unShifted[96+:8]=state[96+:8];

//second row will be shifted by 1
assign unShifted[8+:8]=state[104+:8];
assign unShifted[40+:8]=state[8+:8];
assign unShifted[72+:8]=state[40+:8];
assign unShifted[104+:8]=state[72+:8];

//third row will be shifted by 2
assign unShifted[16+:8]=state[80+:8];
assign unShifted[48+:8]=state[112+:8];
assign unShifted[80+:8]=state[16+:8];
assign unShifted[112+:8]=state[48+:8];

//forth row will be shifted by 3
assign unShifted[24+:8]=state[56+:8];
assign unShifted[56+:8]=state[88+:8];
assign unShifted[88+:8]=state[120+:8];
assign unShifted[120+:8]=state[24+:8];

endmodule
///////////////////////////inverse mixCol\\\\\\\\\\\\\\\\\\\\\\

module inverseMixColumn(input [0:127] state, output reg [0:127] mixed);
function[0:7] mul2 (input [0:7] state);
if(state[0]==1) 
begin
    mul2=(state << 1)^8'h1b;
end
else
    mul2=state << 1;
endfunction

function[7:0] mule (input [7:0] state);//1110
mule= mul2(state) ^ mul2(mul2(state))^mul2(mul2(mul2(state)));
endfunction

function[7:0] mulb (input [7:0]state);//1011
mulb=mul2(mul2(mul2(state)))^mul2(state)^state;
endfunction

function[7:0] muld (input [7:0]state);//1101
muld=mul2(mul2(mul2(state)))^mul2(mul2(state))^state;
endfunction

function[7:0] mul9 (input [7:0]state);//1001
mul9=mul2(mul2(mul2(state)))^state;
endfunction

integer i;
always@(*)begin 
for(i=0;i<4;i=i+1)begin:first_32
 mixed[i*32+:8]=mule(state[(i*32)+:8]) ^ mulb(state[(i*32+8)+:8]) ^muld( state[(i*32+16)+:8]) ^mul9( state[(i*32+24)+:8]) ;
 mixed[(i*32+8)+:8]=mul9(state[(i*32)+:8]) ^ mule(state[(i*32+8)+:8]) ^ mulb(state[(i*32+16)+:8]) ^ muld(state[(i*32+24)+:8]) ;
 mixed[(i*32+16)+:8]=muld(state[(i*32)+:8]) ^ mul9(state[(i*32+8)+:8]) ^ mule(state[(i*32+16)+:8]) ^ mulb(state[(i*32+24)+:8]) ;
 mixed[(i*32+24)+:8]=mulb(state[(i*32)+:8]) ^ muld(state[(i*32+8)+:8]) ^ mul9(state[(i*32+16)+:8]) ^ mule(state[(i*32+24)+:8] );
end

end
endmodule

///////////////////////////inverse round/////////////////////
module invRound(stateReg,key,out);
input [127:0] stateReg;
input [127:0] key;
output wire[127:0] out;
wire [127:0] rowsToSub,subToKey,keyToMix,mixToOut;


invShiftRows isr(stateReg,rowsToSub);
invSubBytes isb(rowsToSub,subToKey);

assign keyToMix =subToKey ^ key;

inverseMixColumn imc(keyToMix,mixToOut);
//addroundkey ark2(keyReg,mixToKey,out); check it out !!!!!!!!

assign out = mixToOut;
endmodule


///////////////////////////inverse cipher//////////////////////

module invCipher#(parameter Nk=8)(in,clk,fullKeys,out,flag,leds);

localparam Nb=4;
localparam Nr=Nk+6;
localparam fullkeyLn = Nb*(Nr+1)*32 - 1;

//input reset;
input clk;
input [127:0] in;
output reg [127:0] out;
output wire [0:20] leds; 
input [0:fullkeyLn] fullKeys;
input flag;
//locals
reg [127:0] stateReg;
wire [127:0] state;
wire [127:0] rowToSub,subToOut;
wire [0:11] bcdOut;

integer i=Nr;

always@(negedge clk)
begin
	if(flag == 1'b1) 
	begin
		if(i==Nr) 
		begin
			stateReg=fullKeys[Nr*128+:128] ^ in;
			i<=i-1; 
			out=stateReg;
		end
		else if (i>0)
		begin
			i<=i-1;
			stateReg<=state;
			out<=state;
		end
		else begin
			out<=fullKeys[0+:128]^subToOut;
		end
		
	end
end

invRound r2(stateReg,fullKeys[i*128+:128],state);
binary_to_bcd btb(out[7:0],bcdOut);
SSD ssd(bcdOut,leds);

//last round ->would be used and correct in last round i=10;
invShiftRows sr2(stateReg,rowToSub);
invSubBytes sb2(rowToSub,subToOut);

endmodule

module invCipher_tb();
reg clk;
reg[127:0] in;
reg [0:1407] fullKeys;
wire [127:0]out;
always begin
    clk = 1;
    #20;
    clk = 0;
    #20;
end
invCipher invc (in,clk,fullKeys,out);

initial begin
	
	in = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
	fullKeys =1408'h000102030405060708090a0b0c0d0e0fd6aa74fdd2af72fadaa678f1d6ab76feb692cf0b643dbdf1be9bc5006830b3feb6ff744ed2c2c9bf6c590cbf0469bf4147f7f7bc95353e03f96c32bcfd058dfd3caaa3e8a99f9deb50f3af57adf622aa5e390f7df7a69296a7553dc10aa31f6b14f9701ae35fe28c440adf4d4ea9c02647438735a41c65b9e016baf4aebf7ad2549932d1f08557681093ed9cbe2c974e13111d7fe3944a17f307a78b4d2b30c5;
	$display("in = %h, fullkeys = %h, out=%h",in,fullKeys,out);
end
endmodule

///////////main aes function\\\\\\\\\\\\\\

module cryptoMain(clk,sel,led,seg);
//parameters
input clk;
input [0:1] sel;
//input rst;
output led1;
output wire [0:20] seg;
//locals
wire [127:0] in;
wire [127:0] key;

reg [0:20] segReg;
//reg [0:20] deSegReg;

wire [0:20] enSeg1, deSeg1, enSeg2, deSeg2, enSeg3, deSeg3;
wire [127:0] encrypted1, decrypted1, encrypted2, decrypted2, encrypted3, decrypted3;
//parameter Nr = (sel==2'b00)?10:12;
//assign key =128'h000102030405060708090a0b0c0d0e0f;
assign in = 128'h00112233445566778899aabbccddeeff;
reg ledReg;

assign led = ledReg;

integer i=0;
always@(posedge clk)
	i=i+1;
	
always@* begin

if(sel==2'b00)
begin
	if(i<=10)
	begin
		segReg=enSeg1;
	end
	else
	begin
		segReg=deSeg1;
		ledReg = (in==decrypted1)?1'b1:1'b0;
		end
end
else if(sel==2'b01)
begin
	if(i<=14)
	begin
		segReg=enSeg2;
	end
	else
	begin
		segReg=deSeg2;
		ledReg =(in==decrypted2)?1'b1:1'b0;
	end
end
else if(sel==2'b10)
begin
	if(i<=18)
	begin
		segReg=enSeg3;
	end
	else
	begin
		segReg=deSeg3;
		ledReg =(in==decrypted3)?1'b1:1'b0;
	end
end
// else if(i<=20)
// begin
// i<=i+1;
// end
end


wire [0:1407] fullKeys1;
wire flag1;
cipher#(.Nk(4)) c1(in,(128'h000102030405060708090a0b0c0d0e0f),clk,encrypted1,fullKeys1,flag1,enSeg1);
invCipher#(.Nk(4)) invc1(encrypted1,clk,fullKeys1,decrypted1,flag1,deSeg1);


wire [0:1663] fullKeys2;
wire flag2;
cipher#(.Nk(6)) c2(in,(192'h000102030405060708090a0b0c0d0e0f1011121314151617),clk,encrypted2,fullKeys2,flag2,enSeg2);
invCipher#(.Nk(6)) invc2(encrypted2,clk,fullKeys2,decrypted2,flag2,deSeg2);


wire [0:1919] fullKeys3;
wire flag3;
cipher#(.Nk(8)) c3(in,(256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f),clk,encrypted3,fullKeys3,flag3,enSeg3);
invCipher#(.Nk(8)) invc3(encrypted3,clk,fullKeys3,decrypted3,flag3,deSeg3);


assign seg= segReg;

endmodule