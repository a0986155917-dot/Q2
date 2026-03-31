# Q2
# FPGA Digital Logic Design Practice (Vivado 2018.3)



---

## 題目開發清單

### 1. 交通燈狀態機 (Traffic Light FSM)
- **程式**
- ```
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
  ```
  
- **Testbench**
- ```
  `timescale 1ns / 1ps

  module tb_traffic();
    reg clk;
    reg rst_n;
    wire [1:0] light;

      // 宣告你要測試的模組 (Unit Under Test)
      traffic_light uut (
        .clk(clk),
        .rst_n(rst_n),
        .light(light)
      );

      // 產生時鐘訊號 (每 5ns 反轉一次，週期 10ns)
    initial clk = 0;
    always #5 clk = ~clk;

      // 測試流程
    initial begin
        rst_n = 0;    // 開始時重置
        #20 rst_n = 1; // 20ns 後放開重置
        #500 $finish;  // 模擬 500ns 後結束
    end
  endmodule```
- **邏輯**：綠燈 (8s) -> 黃燈 (2s) -> 紅燈 (10s) 循環切換。
- **重點**：使用 Finite State Machine (FSM) 配合 Counter 實作。
- **模擬結果
  
  ![Traffic Light Waveform](<Screenshot 2026-04-01 001207.png>)

### 2. 隨機數產生器 (Random Number Generator)

- **邏輯**：使用 CRC5 (LFSR) 多項式產生 0~3 的隨機序列。
- **重點**：當 `load` 訊號為 1 時觸發輸出，展示了 10 次連續隨機數的模擬結果。
- **模擬結果
  
  ![Random Gen Waveform](<Screenshot 2026-04-01 001425.png>)
### 3. PWM 脈波寬度調變 (PWM Generator)
- **邏輯**：輸入 1~9 代表 10%~90% 的 Duty Cycle。
- **重點**：展示了三種不同佔空比的波形模擬，驗證輸出寬度隨輸入準確變化。
- **模擬結果
  
  ![PWM Waveform](<Screenshot 2026-04-01 001705.png>)
