# 威纶通 EasyBuilder Pro 宏脚本说明文档

## 📋 脚本功能
批量读取 Modbus 网关寄存器（3x149、3x152、3x155、3x158、3x161），并根据数值映射到本地位地址（LB60-LB64）。

---

## 🔑 关键语法点解析

### 1. **正确的宏入口与结束**
```
macro_command main()
  // 代码内容
end macro_command
```
✅ **正确**：使用 `macro_command` 和 `end macro_command`  
❌ **错误**：不要使用 C 语言的 `void main()` 或 `int main()`

### 2. **变量声明**
```
short buf[13]      // 数组声明
short result       // 单个变量
```
- 威纶通宏支持的数据类型：`short`（16位整数）、`float`（浮点数）
- 无需分号结束

### 3. **GetData 批量读取语法**
```
result = GetData(buf[0], "Modbus网关45", ReadHoldingReg, 148, 13)
```

**参数说明：**
- `buf[0]`：缓冲区起始位置（存放读取的数据）
- `"Modbus网关45"`：设备名称（必须与通讯设备列表中的名称完全一致）
- `ReadHoldingReg`：寄存器类型（3x 对应 Holding Register）
- `148`：起始地址（3x149 = 地址 148，因为 Modbus 从 0 开始）
- `13`：读取数量（从 3x149 到 3x161 共 13 个寄存器）

**返回值：**
- `1`：读取成功
- `0`：读取失败

### 4. **SetData 写入本地位语法**
```
SetData(1, "Local HMI", LB, 60, 1)
```

**参数说明：**
- `1`：要写入的值（1 = ON，0 = OFF）
- `"Local HMI"`：设备名称（本地 HMI 固定写法）
- `LB`：地址类型（Local Bit - 本地位）
- `60`：地址编号（LB60）
- `1`：数量（写入 1 个位）

### 5. **if-then-else 结构**
```
if buf[0] > 0 then
  SetData(1, "Local HMI", LB, 60, 1)
else
  SetData(0, "Local HMI", LB, 60, 1)
end if
```
✅ **正确**：`then` 后换行，使用 `end if` 结束  
❌ **错误**：不要写成单行 `if (condition) { ... }`

---

## 📊 寄存器地址映射表

| Modbus 地址 | 数组索引 | 本地位 | 条件 |
|------------|---------|-------|------|
| 3x149      | buf[0]  | LB60  | >0 则置位，否则清零 |
| 3x152      | buf[3]  | LB61  | >0 则置位，否则清零 |
| 3x155      | buf[6]  | LB62  | >0 则置位，否则清零 |
| 3x158      | buf[9]  | LB63  | >0 则置位，否则清零 |
| 3x161      | buf[12] | LB64  | >0 则置位，否则清零 |
| -          | -       | LB65  | 固定清零 |

---

## 🚀 使用步骤

### 1. 在 EasyBuilder Pro 中创建宏
1. 打开 EasyBuilder Pro 项目
2. 菜单：**编辑** → **宏**
3. 点击 **新建** 创建新宏
4. 将 `modbus_to_local_bit.txt` 的内容完整复制粘贴到宏编辑器中
5. 点击 **编译** 检查语法
6. 点击 **确定** 保存

### 2. 触发宏执行
选择以下任一方式：

**方式 A：定时触发**
- 在画面中创建一个 **数值输入对象** 或 **位状态开关**
- 设置控制地址为某个本地位（如 LB100）
- 在对象属性中，**控制** → **宏** → 选择刚创建的宏
- 设置为周期性执行（如每 1000ms 执行一次）

**方式 B：事件触发**
- 在 **系统参数** → **宏** 中设置
- 选择 **运行时执行** 或 **画面切换时执行**

**方式 C：按钮触发**
- 创建一个功能键，设置为 **执行宏**
- 手动点击按钮执行

---

## 🐛 常见错误与排查方法

### 错误 1：编译失败 - "Syntax Error"
**可能原因：**
- 设备名称不匹配
- 使用了分号 `;`
- `if-then-else` 结构错误

**解决方法：**
1. 检查设备名称：进入 **系统参数** → **设备** → **通讯设备**，确认设备名称是否为 `Modbus网关45`
2. 删除所有分号
3. 确保 `then` 后换行，使用 `end if` 结束

---

### 错误 2：读取失败（result = 0）
**可能原因：**
- 通讯未连接
- 设备名称错误
- Modbus 地址错误
- 从站号配置错误

**排查步骤：**
1. **检查通讯状态**：在 HMI 画面上显示通讯状态（系统位）
2. **验证设备名称**：确保脚本中的 `"Modbus网关45"` 与设备列表中的名称完全一致（区分大小写）
3. **确认 Modbus 地址**：
   - 3x149 = Holding Register 地址 148
   - 如果网关使用不同的地址偏移，需要调整
4. **检查从站号**：确认网关设备的 Station No. 是否正确配置

**调试建议：**
```
// 在宏中添加调试代码
if result == 0 then
  // 显示错误信息到某个数值显示对象
  SetData(9999, "Local HMI", LW, 100, 1)  // LW100 显示错误代码
end if
```

---

### 错误 3：LB 位没有变化
**可能原因：**
- 寄存器值为负数或零
- SetData 语法错误
- 宏未被正确触发

**排查步骤：**
1. **确认寄存器值**：
   - 在画面上创建数值显示对象，直接显示 `3x149` 等寄存器的值
   - 验证值是否确实 > 0
2. **测试 SetData**：
   ```
   // 强制置位测试
   SetData(1, "Local HMI", LB, 60, 1)
   ```
3. **检查宏触发**：确认宏是否被周期性调用

---

### 错误 4：数组索引错误
**原因分析：**
- 一次读取 13 个寄存器：3x149 ~ 3x161
- 数组索引 0~12 对应：
  - buf[0] = 3x149
  - buf[1] = 3x150
  - buf[2] = 3x151
  - buf[3] = 3x152
  - ...
  - buf[12] = 3x161

**如果只需要读取 5 个寄存器：**
```
// 分别读取（通讯次数多）
result = GetData(buf[0], "Modbus网关45", ReadHoldingReg, 148, 1)  // 3x149
result = GetData(buf[1], "Modbus网关45", ReadHoldingReg, 151, 1)  // 3x152
result = GetData(buf[2], "Modbus网关45", ReadHoldingReg, 154, 1)  // 3x155
result = GetData(buf[3], "Modbus网关45", ReadHoldingReg, 157, 1)  // 3x158
result = GetData(buf[4], "Modbus网关45", ReadHoldingReg, 160, 1)  // 3x161
```

---

## ⚡ 性能优化建议

### 1. 批量读取优势
- **当前方案**：1 次通讯读取 13 个寄存器
- **分散读取**：5 次通讯分别读取
- **性能提升**：减少 80% 通讯开销

### 2. 执行频率建议
- **快速响应**：100-500ms（适合实时监控）
- **标准响应**：1000ms（适合一般应用）
- **节能模式**：2000ms 以上（适合低频更新）

### 3. 错误处理策略
```
// 添加通讯错误计数器
if result == 0 then
  error_count = error_count + 1
  if error_count > 5 then
    // 连续失败 5 次，触发报警
    SetData(1, "Local HMI", LB, 999, 1)  // LB999 = 通讯故障报警
  end if
else
  error_count = 0  // 成功后清零
end if
```

---

## 📝 完整示例（带错误处理）

如果需要更健壮的版本，可以使用：

```
macro_command main()
short buf[13]
short result
short error_count
short i

// 初始化
for i = 0 to 12
  buf[i] = 0
end for

// 批量读取
result = GetData(buf[0], "Modbus网关45", ReadHoldingReg, 148, 13)

if result == 1 then
  // 成功：清除错误计数
  error_count = 0
  
  // 处理每个寄存器
  if buf[0] > 0 then
    SetData(1, "Local HMI", LB, 60, 1)
  else
    SetData(0, "Local HMI", LB, 60, 1)
  end if
  
  if buf[3] > 0 then
    SetData(1, "Local HMI", LB, 61, 1)
  else
    SetData(0, "Local HMI", LB, 61, 1)
  end if
  
  if buf[6] > 0 then
    SetData(1, "Local HMI", LB, 62, 1)
  else
    SetData(0, "Local HMI", LB, 62, 1)
  end if
  
  if buf[9] > 0 then
    SetData(1, "Local HMI", LB, 63, 1)
  else
    SetData(0, "Local HMI", LB, 63, 1)
  end if
  
  if buf[12] > 0 then
    SetData(1, "Local HMI", LB, 64, 1)
  else
    SetData(0, "Local HMI", LB, 64, 1)
  end if
  
  // 清除故障位
  SetData(0, "Local HMI", LB, 999, 1)
  
else
  // 失败：累加错误计数
  error_count = error_count + 1
  if error_count >= 5 then
    SetData(1, "Local HMI", LB, 999, 1)  // 触发通讯故障报警
  end if
end if

// LB65 固定清零
SetData(0, "Local HMI", LB, 65, 1)

end macro_command
```

---

## 📞 技术支持

如果遇到问题：
1. 检查 EasyBuilder Pro 版本（建议使用 V6.00 以上）
2. 查看 HMI 的系统日志
3. 使用 Modbus 调试工具验证通讯
4. 确认网关配置正确

---

## ✅ 检查清单

在部署前，请确认：
- [ ] 设备名称 `Modbus网关45` 与实际配置一致
- [ ] Modbus 地址范围正确（3x149-3x161）
- [ ] 宏编译成功无错误
- [ ] 宏已设置触发方式（定时/事件/按钮）
- [ ] 通讯参数配置正确（波特率、站号等）
- [ ] 在画面上添加了 LB60-LB65 的监控显示

---

**版本**：1.0  
**日期**：2026-01-04  
**适用**：威纶通 EasyBuilder Pro V6.0 及以上
