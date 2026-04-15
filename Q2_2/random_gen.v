`timescale 1ns / 1ps

module random_gen(
    input clk,
    input rst_n,
    input load,          // 輸入為 1 時抓取隨機數
    output reg [1:0] out // 輸出 0~3
    );

    // 5-bit LFSR，對應 CRC5 關鍵字
    reg [4:0] lfsr; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr <= 5'h1F; // LFSR 初始值不能為 0
            out  <= 2'b00;
        end else begin
            // LFSR 多項式邏輯：x^5 + x^3 + 1
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]};
            
            // 當 load 訊號為 1 時，更新輸出值
            if (load) begin
                out <= lfsr[1:0]; 
            end
        end
    end
endmodule
