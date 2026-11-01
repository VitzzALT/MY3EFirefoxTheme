# MY3E Firefox Theme - instalador para Windows
# Uso:   powershell -ExecutionPolicy Bypass -File .\install.ps1
# Opções: -Uninstall   remove o tema
#         -NoHomepage  não define a página inicial
param([switch]$Uninstall, [switch]$NoHomepage)
$ErrorActionPreference = 'Stop'

$Raw  = 'https://raw.githubusercontent.com/VitzzALT/MY3EFirefoxTheme/main'
$Page = 'https://vitzzalt.github.io/MY3EFirefoxTheme/'
$Mark = '// MY3E'

if (Get-Process firefox -ErrorAction SilentlyContinue) {
    Write-Host 'Feche o Firefox por completo (inclusive na bandeja) e rode o script de novo.' -ForegroundColor Yellow
    exit 1
}

# 1) Descobre o perfil padrão
$ffDir = Join-Path $env:APPDATA 'Mozilla\Firefox'
$ini   = Join-Path $ffDir 'profiles.ini'
if (-not (Test-Path $ini)) {
    Write-Host "Não encontrei o profiles.ini em $ffDir. Abra o Firefox uma vez e tente de novo." -ForegroundColor Red
    exit 1
}
$sec = @{}; $cur = $null
foreach ($l in Get-Content $ini) {
    if ($l -match '^\[(.+)\]\s*$') { $cur = $Matches[1]; $sec[$cur] = @{} }
    elseif ($cur -and $l -match '^([^=]+)=(.*)$') { $sec[$cur][$Matches[1]] = $Matches[2] }
}
$path = $null
foreach ($k in $sec.Keys) {
    if ($k -like 'Install*' -and $sec[$k]['Default']) { $path = $sec[$k]['Default']; break }
}
if (-not $path) {
    foreach ($k in $sec.Keys) {
        if ($k -like 'Profile*' -and $sec[$k]['Default'] -eq '1') { $path = $sec[$k]['Path']; break }
    }
}
if (-not $path) {
    Write-Host 'Não consegui descobrir o perfil padrão do Firefox.' -ForegroundColor Red
    exit 1
}
$path = $path -replace '/', '\'
$prof = if ([IO.Path]::IsPathRooted($path)) { $path } else { Join-Path $ffDir $path }
Write-Host "Perfil: $prof"

$chrome = Join-Path $prof 'chrome'
$css    = Join-Path $chrome 'userChrome.css'
$userjs = Join-Path $prof 'user.js'
$utf8   = New-Object Text.UTF8Encoding $false

# Remove do user.js só as linhas que este script adicionou
function Clear-Mine {
    if (Test-Path $userjs) {
        $keep = @(Get-Content $userjs | Where-Object { $_ -notlike "*$Mark*" })
        [IO.File]::WriteAllLines($userjs, [string[]]$keep, $utf8)
    }
}

if ($Uninstall) {
    if (Test-Path $css) { Remove-Item $css -Force }
    Clear-Mine
    Write-Host 'Tema removido. Abra o Firefox para voltar ao visual normal.' -ForegroundColor Green
    exit 0
}

# 2) Instala o userChrome.css (com backup do que já existir)
New-Item -ItemType Directory -Force -Path $chrome | Out-Null
if (Test-Path $css) {
    $bak = "$css.bak-" + (Get-Date -Format 'yyyyMMdd-HHmmss')
    Copy-Item $css $bak
    Write-Host "Backup do CSS anterior: $bak"
}
Invoke-WebRequest -Uri "$Raw/userChrome.css" -OutFile $css -UseBasicParsing

# 3) Ativa o suporte ao userChrome.css (e define a página inicial)
Clear-Mine
$lines = @('user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true); ' + $Mark)
if (-not $NoHomepage) {
    $lines += ('user_pref("browser.startup.homepage", "{0}"); {1}' -f $Page, $Mark)
    $lines += ('user_pref("browser.startup.page", 1); ' + $Mark)
}
[IO.File]::AppendAllLines($userjs, [string[]]$lines, $utf8)

Write-Host ''
Write-Host 'Pronto! Abra o Firefox.' -ForegroundColor Green
Write-Host 'Falta só a nova aba: instale a extensão "New Tab Override" e use a URL personalizada:'
Write-Host "  $Page"
