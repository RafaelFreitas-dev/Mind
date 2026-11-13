<#
    Mind - instalacao completa do ambiente de desenvolvimento (Windows)

    Instala, se faltar: Git, Node.js LTS, JDK 21, MongoDB Server,
    Android Studio, Flutter SDK e um emulador Android. Depois baixa as
    dependencias do backend, do site e do app.

    Pode rodar varias vezes: o que ja existe e apenas verificado.

    Uso:  .\setup-completo.bat   (duplo clique tambem funciona)
#>

$ErrorActionPreference = 'Stop'
$raiz = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $raiz

$FLUTTER_DIR = 'C:\src\flutter'
$AVD_NOME    = 'Mind_Emulator'
$API_LEVEL   = 35

function Titulo($t) {
    Write-Host ''
    Write-Host ('=' * 52) -ForegroundColor DarkCyan
    Write-Host "  $t" -ForegroundColor Cyan
    Write-Host ('=' * 52) -ForegroundColor DarkCyan
}
function Ok($m)    { Write-Host "  [ok] $m"   -ForegroundColor Green }
function Info($m)  { Write-Host "  [..] $m"   -ForegroundColor Gray }
function Aviso($m) { Write-Host "  [!]  $m"   -ForegroundColor Yellow }
function Erro($m)  { Write-Host "  [X]  $m"   -ForegroundColor Red }

function TemComando($nome) {
    return [bool](Get-Command $nome -ErrorAction SilentlyContinue)
}

function RecarregarPath {
    $maquina = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $usuario = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$maquina;$usuario"
}

function InstalarWinget($id, $nomeAmigavel, $comandoTeste) {
    if ($comandoTeste -and (TemComando $comandoTeste)) {
        Ok "$nomeAmigavel ja instalado."
        return $true
    }
    Info "Instalando $nomeAmigavel ..."
    winget install --id $id --silent --accept-package-agreements --accept-source-agreements | Out-Null
    RecarregarPath
    if ($comandoTeste -and -not (TemComando $comandoTeste)) {
        Aviso "$nomeAmigavel foi instalado mas ainda nao aparece no PATH desta janela."
        return $false
    }
    Ok "$nomeAmigavel pronto."
    return $true
}

# ---------------------------------------------------------------- 0. winget
Titulo 'Mind - instalacao completa do ambiente'

if (-not (TemComando winget)) {
    Erro 'O winget nao esta disponivel nesta maquina.'
    Write-Host '       Atualize o "Instalador de Aplicativo" pela Microsoft Store e rode de novo.'
    Read-Host 'Enter para sair'
    exit 1
}

# ---------------------------------------------------------------- 1. basicos
Titulo '1/7  Ferramentas basicas'

InstalarWinget 'Git.Git'              'Git'        'git'      | Out-Null
InstalarWinget 'OpenJS.NodeJS.LTS'    'Node.js'    'node'     | Out-Null
InstalarWinget 'Microsoft.OpenJDK.21' 'JDK 21'     'java'     | Out-Null

# ---------------------------------------------------------------- 2. mongodb
Titulo '2/7  MongoDB'

# Com a connection string do MongoDB Atlas em backend\.env, o banco e online
# e o MongoDB local nao precisa ser instalado (ver backend\.env.example).
$envBackend = Join-Path $raiz 'backend\.env'
$usaAtlas = (Test-Path $envBackend) -and [bool](Select-String -Path $envBackend -Pattern '^\s*MONGODB_URI=mongodb' -Quiet)

if ($usaAtlas) {
    Ok 'Banco no MongoDB Atlas (backend\.env): o MongoDB local nao e necessario.'
} else {
    $servico = Get-Service -Name MongoDB -ErrorAction SilentlyContinue
    if (-not $servico) {
        Info 'Instalando MongoDB Server ...'
        winget install --id MongoDB.Server --silent --accept-package-agreements --accept-source-agreements | Out-Null
        Start-Sleep -Seconds 5
        $servico = Get-Service -Name MongoDB -ErrorAction SilentlyContinue
    }

    if ($servico) {
        if ($servico.Status -ne 'Running') {
            Info 'Iniciando o servico do MongoDB ...'
            try { Start-Service MongoDB; Ok 'MongoDB rodando.' }
            catch { Aviso 'Nao consegui iniciar o servico. Rode como administrador: Start-Service MongoDB' }
        } else {
            Ok 'MongoDB rodando.'
        }
    } else {
        Aviso 'MongoDB nao ficou instalado. Instale manualmente: winget install MongoDB.Server'
        Aviso 'Ou use o MongoDB Atlas: copie backend\.env.example para backend\.env.'
    }
}

# ---------------------------------------------------------------- 3. flutter
Titulo '3/7  Flutter SDK'

if (TemComando flutter) {
    Ok 'Flutter ja esta no PATH.'
} elseif (Test-Path "$FLUTTER_DIR\bin\flutter.bat") {
    Ok "Flutter encontrado em $FLUTTER_DIR."
} else {
    Info "Clonando o Flutter em $FLUTTER_DIR (alguns GB, demora) ..."
    New-Item -ItemType Directory -Force -Path (Split-Path $FLUTTER_DIR) | Out-Null
    git clone -b stable https://github.com/flutter/flutter.git $FLUTTER_DIR
}

# Garante o Flutter no PATH do usuario e desta janela
$pathUsuario = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($pathUsuario -notlike "*$FLUTTER_DIR\bin*") {
    Info 'Adicionando o Flutter ao PATH do usuario ...'
    [Environment]::SetEnvironmentVariable('Path', "$pathUsuario;$FLUTTER_DIR\bin", 'User')
}
if ($env:Path -notlike "*$FLUTTER_DIR\bin*") {
    $env:Path = "$FLUTTER_DIR\bin;$env:Path"
}

Info 'Preparando o Flutter (primeira execucao baixa o Dart SDK) ...'
flutter --version

# ---------------------------------------------------------------- 4. android
Titulo '4/7  Android Studio e SDK'

$androidStudio = Test-Path "$env:ProgramFiles\Android\Android Studio\bin\studio64.exe"
if (-not $androidStudio) {
    Info 'Instalando o Android Studio (download grande) ...'
    winget install --id Google.AndroidStudio --silent --accept-package-agreements --accept-source-agreements | Out-Null
} else {
    Ok 'Android Studio ja instalado.'
}

$sdkRaiz = "$env:LOCALAPPDATA\Android\Sdk"
$sdkmanager = Get-ChildItem -Path $sdkRaiz -Recurse -Filter 'sdkmanager.bat' -ErrorAction SilentlyContinue |
              Select-Object -First 1 -ExpandProperty FullName

if (-not $sdkmanager) {
    Aviso 'O SDK do Android ainda nao existe.'
    Write-Host '       Abra o Android Studio uma vez e conclua o assistente inicial,'
    Write-Host '       depois rode este script de novo para criar o emulador.'
} else {
    Ok 'SDK do Android encontrado.'
    Info 'Instalando componentes (platform-tools, emulator, imagem do sistema) ...'
    & $sdkmanager --install 'platform-tools' 'emulator' "platforms;android-$API_LEVEL" "system-images;android-$API_LEVEL;google_apis;x86_64" | Out-Null

    Info 'Aceitando as licencas do Android ...'
    cmd /c "echo y| flutter doctor --android-licenses" | Out-Null

    # ------------------------------------------------------------ emulador
    Titulo '5/7  Emulador Android'

    $avdmanager = Join-Path (Split-Path $sdkmanager) 'avdmanager.bat'
    $existentes = & $avdmanager list avd 2>$null | Select-String 'Name:'

    if ($existentes) {
        Ok ('Emulador ja existe: ' + ($existentes[0] -replace '.*Name:\s*', ''))
    } else {
        Info "Criando o emulador $AVD_NOME ..."
        cmd /c "echo no| `"$avdmanager`" create avd -n $AVD_NOME -k `"system-images;android-$API_LEVEL;google_apis;x86_64`" -d pixel_7" | Out-Null
        Ok "Emulador $AVD_NOME criado."
    }
}

# ---------------------------------------------------------------- 6. projeto
Titulo '6/7  Dependencias do projeto'

Info 'Raiz (concurrently, driver do mongo) ...'
npm install | Out-Null
Ok 'Raiz pronta.'

Info 'Site (React + Vite) ...'
npm install --prefix frontend | Out-Null
Ok 'Site pronto.'

Info 'App (http, shared_preferences) ...'
Push-Location mobile
flutter pub get | Out-Null
Pop-Location
Ok 'App pronto.'

Info 'Backend (Spring Boot via Maven) - baixa centenas de MB na primeira vez ...'
Push-Location backend
cmd /c 'mvnw.cmd -B dependency:go-offline' | Out-Null
Pop-Location
Ok 'Backend pronto.'

# ---------------------------------------------------------------- 7. conferencia
Titulo '7/7  Conferencia final'
flutter doctor

Write-Host ''
Write-Host ('=' * 52) -ForegroundColor DarkGreen
Write-Host '  Ambiente pronto.' -ForegroundColor Green
Write-Host ''
Write-Host '  Para rodar tudo:   npm start'
Write-Host '  Site ...........   http://localhost:3000'
Write-Host '  API ............   http://localhost:8080'
Write-Host '  Login de teste .   gabriel / 2000'
Write-Host ('=' * 52) -ForegroundColor DarkGreen
Write-Host ''
Write-Host '  Feche e reabra o terminal para o PATH novo valer em todo lugar.' -ForegroundColor Yellow
Write-Host ''
Read-Host 'Enter para sair'
