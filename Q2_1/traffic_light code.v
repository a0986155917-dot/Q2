`timescale 1ns / 1ps

module traffic_light(
    input clk,
    input rst_n,
    output reg [1:0] light // 0:綠, 1:黃, 2:紅
    );

    // 定義狀態常數 (Parameter)
    parameter S_GREEN  = 2'd0;
    parameter S_YELLOW = 2'd1;
    parameter S_RED    = 2'd2;

    reg [3:0] cnt; // 計數器，足以數到 10 (4-bit 可到 15)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            light <= S_GREEN;
            cnt <= 4'd0;
        end else begin
            case (light)
                S_GREEN: begin
                    if (cnt == 4'd7) begin // 8 clks (0~7)
                        light <= S_YELLOW;
                        cnt <= 4'd0;
                    end else cnt <= cnt + 4'd1;
                end
                S_YELLOW: begin
                    if (cnt == 4'd1) begin // 2 clks (0~1)
                        light <= S_RED;
                        cnt <= 4'd0;
                    end else cnt <= cnt + 4'd1;
                end
                S_RED: begin
                    if (cnt == 4'd9) begin // 10 clks (0~9)
                        light <= S_GREEN;
                        cnt <= 4'd0;
                    end else cnt <= cnt + 4'd1;
                end
                default: light <= S_GREEN;
            endcase
        end
    end
endmodule
