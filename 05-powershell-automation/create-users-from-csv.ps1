# ==============================================================================
# create-users-from-csv.ps1
#
# Objetivo: Reemplazar el proceso manual de "Bulk create" del módulo 01 por un
# script que crea usuarios en Microsoft Entra ID a partir de un CSV, usando el
# módulo de PowerShell de Microsoft Graph.
#
# Requiere: Módulo Microsoft.Graph instalado.
#   Install-Module Microsoft.Graph -Scope CurrentUser
#
# Permisos necesarios (se piden en el consentimiento al conectar):
#   User.ReadWrite.All
# ==============================================================================

# --- 1. Conectarse a Microsoft Graph ---
Connect-MgGraph -Scopes "User.ReadWrite.All"

# --- 2. Definir la ruta del CSV ---
# El CSV debe tener las columnas: DisplayName, UserPrincipalName, MailNickname, Department, JobTitle
$csvPath = "./empleados-ejemplo.csv"

if (-not (Test-Path $csvPath)) {
    Write-Error "No se encontró el archivo CSV en la ruta: $csvPath"
    exit 1
}

# Nota: Excel en configuración regional español/Argentina exporta CSVs usando
# punto y coma (;) como separador en vez de coma (,). Por eso especificamos
# -Delimiter ";" acá. Si tu CSV usa coma normal, cambiá esto a -Delimiter ","
# o simplemente sacá el parámetro (coma es el default de Import-Csv).
$employees = Import-Csv -Path $csvPath -Delimiter ";"

# --- 3. Password profile por defecto para las cuentas nuevas ---
# En un escenario real, esto se manejaría con una política más segura
# (ej. forzar cambio en el primer login, o integrarlo con SSPR).
$passwordProfile = @{
    Password                      = "TempPass123!"
    ForceChangePasswordNextSignIn = $true
}

# --- 4. Loop de creación de usuarios ---
$successCount = 0
$errorCount = 0

foreach ($employee in $employees) {

    # Evitar crear el usuario si ya existe (chequeo por UPN)
    $existingUser = Get-MgUser -Filter "userPrincipalName eq '$($employee.UserPrincipalName)'" -ErrorAction SilentlyContinue

    if ($existingUser) {
        Write-Host "Usuario ya existe, se omite: $($employee.UserPrincipalName)" -ForegroundColor Yellow
        continue
    }

    $userParams = @{
        DisplayName       = $employee.DisplayName
        UserPrincipalName = $employee.UserPrincipalName
        MailNickname      = $employee.MailNickname
        AccountEnabled    = $true
        Department        = $employee.Department
        JobTitle          = $employee.JobTitle
        UsageLocation     = "AR"
        PasswordProfile   = $passwordProfile
    }

    try {
        New-MgUser -BodyParameter $userParams -ErrorAction Stop
        Write-Host "Usuario creado: $($employee.DisplayName) ($($employee.Department))" -ForegroundColor Green
        $successCount++
    }
    catch {
        Write-Host "Error al crear a $($employee.DisplayName): $($_.Exception.Message)" -ForegroundColor Red
        $errorCount++
    }
}

# --- 5. Resumen final ---
Write-Host "`n--- Resumen ---"
Write-Host "Usuarios creados: $successCount"
Write-Host "Errores: $errorCount"

Disconnect-MgGraph
