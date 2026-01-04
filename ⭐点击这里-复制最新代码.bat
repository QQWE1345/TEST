@echo off
chcp 65001 >nul
color 0A
echo ========================================
echo    威纶通宏脚本 v1.2 - 快速复制工具
echo ========================================
echo.
echo [重要] 请先阅读以下说明：
echo.
echo 已修正的错误：
echo   ✓ error C38 - GetData 缓冲区参数
echo   ✓ error C45 - SetData 设备名称
echo   ✓ error C21 - for 循环结束语句
echo.
echo 当前版本：v1.2
echo 修正数量：18 处
echo 编译状态：应该可以完全通过
echo.
echo ========================================
echo.
echo 正在将最新代码复制到剪贴板...
echo.

type "最终修正版-请使用此文件.txt" | clip

if %errorlevel% equ 0 (
    echo [✓ 成功] 代码已复制到剪贴板！
    echo.
    echo ┌────────────────────────────────────┐
    echo │ 下一步操作：                        │
    echo ├────────────────────────────────────┤
    echo │ 1. 打开 EasyBuilder Pro            │
    echo │ 2. 菜单：编辑 → 宏                 │
    echo │ 3. 清空旧代码（如果有）            │
    echo │ 4. 粘贴（Ctrl+V）                  │
    echo │ 5. 点击"编译"                      │
    echo │ 6. 应显示：0 error(s) 0 warning(s)│
    echo └────────────────────────────────────┘
    echo.
    echo [提示] 只复制 macro_command 到 end macro_command
    echo        之间的内容，不要包含说明文字！
) else (
    echo [✗ 错误] 复制失败
    echo.
    echo 请手动操作：
    echo 1. 打开文件：最终修正版-请使用此文件.txt
    echo 2. 复制标记区域之间的代码
    echo 3. 粘贴到 EBPro
)

echo.
echo ========================================
echo.
echo 如果编译仍有错误，请检查：
echo   □ 设备名称是否为 "Modbus网关45"
echo   □ 是否完整复制所有代码
echo   □ EBPro 版本是否为 V6.0+
echo.
echo 详细文档：
echo   - 重要-v1.2更新说明.md
echo   - README_宏脚本说明.md
echo.
echo ========================================
echo.
pause
