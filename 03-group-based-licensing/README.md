# 03 - Group-Based Licensing

## Objetivo
Asignar licencias de Microsoft Entra ID P2 y Microsoft 365 Business Premium automáticamente a través de los grupos dinámicos armados en el módulo 02, en vez de asignarlas usuario por usuario.

## Contexto
Este módulo conecta directamente el concepto de "grupo = departamento" con consecuencias reales de acceso: cuando alguien entra a un grupo, automáticamente recibe las licencias (y por lo tanto el acceso a Exchange, Teams, SharePoint, features premium de Entra ID) que le corresponden a ese departamento. Cuando se mueve de grupo, el acceso se ajusta solo.

## Proceso

1. Desde el Microsoft 365 Admin Center (`admin.microsoft.com`), fui a **Groups > el grupo > Licenses**.
2. Asigné Microsoft Entra ID P2 y Microsoft 365 Business Premium al grupo `SG-Finance`.
3. Verifiqué la propagación a nivel del usuario miembro del grupo (`Users > el usuario > Licenses and apps`).

## Troubleshooting real que tuve que hacer

Durante este módulo me encontré con que la licencia de grupo aparecía como "Assigned" a nivel grupo, pero **no se reflejaba en el usuario individual**, y el contador de licencias disponibles no bajaba. Pasos que seguí para diagnosticarlo:

1. Descarté que fuera un problema de **Usage Location** del usuario (ya estaba seteado en Argentina).
2. Descarté que el tipo de grupo (Security Group vs M365 Group) fuera la causa — ambos son compatibles con licensing basado en grupo.
3. Descarté que la falta de un owner en el grupo afectara la asignación de licencias (el owner solo gestiona membership, no licenciamiento).
4. Revisé la pestaña **Errors & Issues** del producto en el M365 Admin Center — no había ningún error reportado, lo cual descartaba un conflicto de licencias o un problema de configuración.
5. La causa real: fui al perfil del usuario y en la pestaña **OneDrive** apareció el mensaje *"We can't show the OneDrive settings. If this is a new user, their OneDrive might not be set up yet."* — esto confirmó que el problema no era de configuración sino de **tiempo de aprovisionamiento del backend** de M365 (Exchange/OneDrive) en un tenant/trial recién activado.
6. Con Microsoft Entra ID P2 (que no depende de aprovisionar buzón/OneDrive) la asignación vía grupo sí funcionó sin demoras, lo que confirmó que el mecanismo de group-based licensing en sí estaba funcionando correctamente — el retraso era específico de los servicios de M365 que necesitan infraestructura adicional.

## Archivos en esta carpeta

- `screenshots/licenses-assigned-group.png` — licencias tildadas en el grupo.
- `screenshots/errors-issues-tab.png` — la pestaña de errores, sin incidencias reportadas.
- `screenshots/onedrive-not-ready.png` — el mensaje que reveló la causa real del retraso.

## Resultado

![Licencias asignadas al grupo](screenshots/licenses-assigned-group.png)

## Aprendizajes

- No todo lo que parece un error de configuración lo es — a veces es simplemente el backend del servicio todavía terminando de aprovisionar infraestructura, sobre todo en tenants/trials recién creados.
- El orden correcto para diagnosticar un problema de licenciamiento por grupo: usage location → tipo de grupo/ownership → Errors & Issues del producto → estado real de los servicios en el perfil del usuario.
- Microsoft Entra ID P2 y Microsoft 365 Business Premium tienen tiempos de aprovisionamiento distintos porque dependen de infraestructura de backend diferente (P2 no requiere buzón/OneDrive, Business Premium sí).
