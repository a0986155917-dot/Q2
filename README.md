# Q2
# FPGA Digital Logic Design Practice (Vivado 2018.3)

這個專案包含了三個使用 Verilog HDL 設計的數位電路練習題。

---

## 題目開發清單

### 1. 交通燈狀態機 (Traffic Light FSM)
- **邏輯**：綠燈 (8s) -> 黃燈 (2s) -> 紅燈 (10s) 循環切換。
- **重點**：使用 Finite State Machine (FSM) 配合 Counter 實作。

### 2. 隨機數產生器 (Random Number Generator)
- **邏輯**：使用 CRC5 (LFSR) 多項式產生 0~3 的隨機序列。
- **重點**：當 `load` 訊號為 1 時觸發輸出，展示了 10 次連續隨機數的模擬結果。

### 3. PWM 脈波寬度調變 (PWM Generator)
- **邏輯**：輸入 1~9 代表 10%~90% 的 Duty Cycle。
- **重點**：展示了三種不同佔空比的波形模擬，驗證輸出寬度隨輸入準確變化。

---

## 檔案說明
- **Design Sources**: `traffic_light.v`, `random_gen.v`, `pwm_gen.v`
- **Simulation Sources**: `tb_random.v`, `tb_pwm.v`

## 模擬結果觀察
> (可以在此下方貼入你的波形截圖)
