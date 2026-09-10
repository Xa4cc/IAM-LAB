05 - Automatización con PowerShell y Microsoft Graph
Objetivo

Reemplazar el proceso manual del módulo 01 (Bulk create desde la interfaz de Entra ID) por un script de PowerShell que use el SDK de Microsoft Graph para crear usuarios automáticamente a partir de un CSV.

Por qué este módulo

Todo el resto del lab se hizo a través de la interfaz web de Entra ID / M365 Admin Center. Eso está bien para entender los conceptos, pero en un entorno real, este tipo de tareas se automatiza con scripts — es lo que permite repetir el proceso de forma confiable, integrarlo con otros sistemas, y programarlo para que corra solo. Este módulo muestra esa misma tarea, pero resuelta por código.

Requisitos previos
Módulo de PowerShell de Microsoft Graph instalado:
powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
Permisos de Graph necesarios: User.ReadWrite.All (se solicitan en el consentimiento al conectarte con Connect-MgGraph).
Qué hace el script
Se conecta a Microsoft Graph.
Lee un CSV con los datos de los empleados (mismo formato que usé en el módulo 01: DisplayName, UserPrincipalName, MailNickname, Department, JobTitle).
Por cada fila, chequea si el usuario ya existe (evita duplicados si el script se corre más de una vez).
Crea el usuario vía New-MgUser, con una contraseña temporal y forzando el cambio en el primer inicio de sesión.
Imprime un resumen al final: cuántos usuarios se crearon y cuántos fallaron.
Cómo correrlo
powershell
./create-users-from-csv.ps1

El script espera el CSV en la misma carpeta, con el nombre empleados-ejemplo.csv (mismo archivo que usé en el módulo 01).

Troubleshooting real que tuve que hacer

Al correr el script por primera vez, los 3 usuarios fallaron con el error [Request_BadRequest]: Invalid value specified for property 'department' of resource 'User'. Investigando el contenido crudo del CSV con Get-Content ./empleados-ejemplo.csv -Raw, encontré la causa: Excel en configuración regional español/Argentina exporta CSVs usando punto y coma (;) como separador en vez de coma (,) — porque en esa configuración regional la coma se usa como separador decimal. Import-Csv de PowerShell espera coma por defecto, así que estaba interpretando cada fila entera como una sola columna, dejando el resto de los campos (incluido Department) vacíos o mal alineados.

La solución fue agregar el parámetro -Delimiter ";" a Import-Csv. Después de ese cambio, los 3 usuarios se crearon correctamente.

Aprendizajes
New-MgUser requiere varios campos obligatorios (AccountEnabled, PasswordProfile, MailNickname) que la interfaz web completa automáticamente, pero que hay que setear explícitamente al usar Graph.
Chequear si el usuario ya existe antes de crearlo es clave para que el script sea "idempotente" — se pueda correr varias veces sin generar duplicados ni errores.
Excel en configuración regional español/Argentina exporta CSVs usando punto y coma (;) como separador en vez de coma, lo cual rompe Import-Csv si no se especifica el delimitador correcto — un detalle fácil de pasar por alto pero muy común al trabajar con datos localizados.
Esto es solo el primer paso de automatización: el siguiente nivel natural sería que este mismo script también agregue a cada usuario al grupo dinámico correspondiente, o dispare la asignación de licencias, en vez de depender pura y exclusivamente de las reglas dinámicas de Entra ID.
Archivos en esta carpeta
create-users-from-csv.ps1 — el script.
screenshots/script-execution.png — la ejecución del script mostrando el resumen final.
