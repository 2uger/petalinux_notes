module bram #(
    parameter RAM_WIDTH = 32,
    parameter RAM_DEPTH = 512
) (
    input clka,
    input [clogb2(RAM_DEPTH-1)-1:0] addra,
    input [clogb2(RAM_DEPTH-1)-1:0] addrb,
    input [RAM_WIDTH-1:0] dina,
    input wea,
    input enb,
    output [RAM_WIDTH-1:0] doutb
);

    reg [RAM_WIDTH-1:0] BRAM [RAM_DEPTH-1:0];
    reg [RAM_WIDTH-1:0] ram_data = {RAM_WIDTH{1'b0}};

    // The following code either initializes the memory values to a specified file or to all zeros to match hardware
    integer ram_index;
    initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
            BRAM[ram_index] = {RAM_WIDTH{1'b0}};

    always @(posedge clka) begin
        if (wea)
            BRAM[addra] <= dina;
        ram_data <= BRAM[addrb];
    end
  
    assign doutb = ram_data;

    //  The following function calculates the address width based on specified RAM depth
    function integer clogb2;
        input integer depth;
            for (clogb2=0; depth>0; clogb2=clogb2+1)
                depth = depth >> 1;
    endfunction
endmodule