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
- **程式**
- ```
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
  ```
- **Testbench**
- ```
  `timescale 1ns / 1ps

  module tb_random();
    // 1. 定義驅動訊號 (reg) 與 觀測訊號 (wire)
    reg clk;
    reg rst_n;
    reg load;
    wire [1:0] out;

    // 2. 實例化你寫好的模組 (要把 random_gen 叫進來測試)
    random_gen uut (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .out(out)
    );

    // 3. 定義 clk (心跳)
    // 這裡每 5ns 翻轉一次，代表週期為 10ns
    initial clk = 0;
    always #5 clk = ~clk;

    // 4. 定義測試流程 (動作)
    initial begin
        // 初始設定
        rst_n = 0;  // 啟動重置
        load = 0;
        #20;        // 等待 20ns
        
        rst_n = 1;  // 解除重置，電路開始運作
        #10;
        
        // 題目要求：展示 10 個連續隨機數
        repeat(10) begin
            #10 load = 1; // 給出觸發訊號
            #10 load = 0; // 拉低
        end
        
        #100 $finish; // 結束模擬
    end
  endmodule
  ```
- **邏輯**：使用 CRC5 (LFSR) 多項式產生 0~3 的隨機序列。
- **重點**：當 `load` 訊號為 1 時觸發輸出，展示了 10 次連續隨機數的模擬結果。
- **模擬結果
  
  ![Random Gen Waveform](<Screenshot 2026-04-01 001425.png>)
### 3. PWM 脈波寬度調變 (PWM Generator)
- **程式**
- ```
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
  ```
- **Testbench**
- ```
  `timescale 1ns / 1ps

  module tb_pwm();
    reg clk;
    reg rst_n;
    reg [3:0] duty_idx;
    wire pwm_out;

    // 接上你的 PWM 模組
    pwm_gen uut (
        .clk(clk),
        .rst_n(rst_n),
        .duty_idx(duty_idx),
        .pwm_out(pwm_out)
    );

    // 產生時鐘 (週期 10ns)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // 1. 初始化並重置
        rst_n = 0; duty_idx = 0; #20;
        rst_n = 1; #10;
        
        // 2. 測試 10% 佔空比 (輸入 1)
        duty_idx = 1; #200;
        
        // 3. 測試 50% 佔空比 (輸入 5)
        duty_idx = 5; #200;
        
        // 4. 測試 80% 佔空比 (輸入 8)
        duty_idx = 8; #200;
        
        $finish;
    end
  endmodule
  ```
  
- **邏輯**：輸入 1~9 代表 10%~90% 的 Duty Cycle。
- **重點**：展示了三種不同佔空比的波形模擬，驗證輸出寬度隨輸入準確變化。
- **模擬結果
  
  ![PWM Waveform](<Screenshot 2026-04-01 001705.png>)
