@echo off
chcp 65001 >nul
echo ========================================
echo 威纶通宏脚本复制工具
echo ========================================
echo.
echo 正在将宏脚本复制到剪贴板...
echo.

type modbus_to_local_bit.txt | clip

if %errorlevel% equ 0 (
    echo [成功] 宏脚本已复制到剪贴板！
    echo.
    echo 下一步：
    echo 1. 打开 EasyBuilder Pro
    echo 2. 菜单：编辑 → 宏
    echo 3. 点击"新建"
    echo 4. 按 Ctrl+V 粘贴
    echo 5. 点击"编译"检查语法
    echo 6. 点击"确定"保存
) else (
    echo [错误] 复制失败，请手动打开 modbus_to_local_bit.txt
)

echo.
echo 按任意键退出...
pause >nul
