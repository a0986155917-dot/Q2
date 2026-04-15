`timescale 1ns / 1ps

module pwm_gen(
    input clk,
    input rst_n,
    input [3:0] duty_idx, // 輸入 1~9 代表 10%~90% 佔空比
    output reg pwm_out
    );

    reg [3:0] cnt; // 0~9 計數器

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'd0;
        end else begin
            // 建立一個 0 到 9 的循環 (共 10 個週期)
            if (cnt == 4'd9) 
                cnt <= 4'd0;
            else 
                cnt <= cnt + 4'd1;
        end
    end

    // 組合邏輯：決定 PWM 輸出
    // 如果計數器小於輸入值，輸出 1；否則輸出 0
    always @(*) begin
        if (cnt < duty_idx) 
            pwm_out = 1'b1;
        else 
            pwm_out = 1'b0;
    end
endmodule
