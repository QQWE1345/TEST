# 威纶通宏脚本查看器
# 用于在 Windows PowerShell 中快速查看项目文件

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "威纶通 Modbus 宏脚本项目文件查看器" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# 菜单选项
Write-Host "请选择要查看的文件：" -ForegroundColor Yellow
Write-Host "[1] modbus_to_local_bit.txt - 宏脚本（可直接复制到 EBPro）" -ForegroundColor Green
Write-Host "[2] README_宏脚本说明.md - 详细技术文档" -ForegroundColor Green
Write-Host "[3] README.md - 项目总览" -ForegroundColor Green
Write-Host "[4] 在记事本中打开宏脚本" -ForegroundColor Green
Write-Host "[5] 在浏览器中查看 README" -ForegroundColor Green
Write-Host "[0] 退出" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "请输入选项 (0-5)"

switch ($choice) {
    "1" {
        Write-Host "`n正在显示 modbus_to_local_bit.txt..." -ForegroundColor Cyan
        Get-Content -Path ".\modbus_to_local_bit.txt" -Encoding UTF8
        Write-Host "`n提示：可以直接复制上述内容到 EasyBuilder Pro 宏编辑器" -ForegroundColor Yellow
    }
    "2" {
        Write-Host "`n正在显示 README_宏脚本说明.md..." -ForegroundColor Cyan
        Get-Content -Path ".\README_宏脚本说明.md" -Encoding UTF8
    }
    "3" {
        Write-Host "`n正在显示 README.md..." -ForegroundColor Cyan
        Get-Content -Path ".\README.md" -Encoding UTF8
    }
    "4" {
        Write-Host "`n正在用记事本打开宏脚本..." -ForegroundColor Cyan
        Start-Process notepad.exe -ArgumentList ".\modbus_to_local_bit.txt"
    }
    "5" {
        Write-Host "`n正在转换 Markdown 为 HTML..." -ForegroundColor Cyan
        
        # 检查是否安装了 pandoc
        if (Get-Command pandoc -ErrorAction SilentlyContinue) {
            pandoc ".\README.md" -o ".\README.html" --metadata title="威纶通宏脚本项目"
            Start-Process ".\README.html"
            Write-Host "已在浏览器中打开 README.html" -ForegroundColor Green
        } else {
            Write-Host "未安装 pandoc，将在默认浏览器中打开 README.md" -ForegroundColor Yellow
            Start-Process ".\README.md"
        }
    }
    "0" {
        Write-Host "`n再见！" -ForegroundColor Cyan
        exit
    }
    default {
        Write-Host "`n无效的选项，请重新运行脚本。" -ForegroundColor Red
    }
}

Write-Host "`n按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
