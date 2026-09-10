# IAM-LAB
# Entra ID IAM Lab — HR-Driven Provisioning, Dynamic Groups & Lifecycle Workflows

Lab hands-on armado en un tenant de prueba de Microsoft Entra ID para practicar conceptos centrales de Identity and Access Management (IAM): automatización del ciclo de vida de identidades (Joiner-Mover-Leaver), grupos dinámicos, licenciamiento basado en grupo, y Lifecycle Workflows.

Este proyecto fue construido como parte de mi preparación para la certificación **SC-300: Microsoft Certified Identity and Access Administrator Associate**, y como práctica hands-on complementaria a mi experiencia en soporte IT / IAM.

## Objetivo del lab

Simular el flujo completo que usan las organizaciones reales para gestionar el acceso de empleados de punta a punta, sin depender de asignaciones manuales:

1. Un sistema de HR (simulado con un CSV) provisiona los datos de los empleados.
2. Entra ID los agrupa automáticamente por departamento usando **grupos dinámicos**.
3. El acceso a licencias (Entra ID P2, Microsoft 365 Business Premium) se asigna automáticamente **vía grupo**.
4. Cuando un empleado cambia de departamento, el acceso se actualiza solo.
5. Cuando un empleado se va, **Lifecycle Workflows** revoca todo el acceso automáticamente.

## Estructura del repo

- `01-hr-driven-provisioning/` — CSV simulando datos de HR, bulk creation de usuarios en Entra ID.
- `02-dynamic-groups/` — Reglas de membership dinámica por atributo `department`, validación de reglas.
- `03-group-based-licensing/` — Asignación de licencias (Entra ID P2 y M365 Business Premium) a nivel grupo, incluyendo el proceso de troubleshooting real que tuve que hacer.
- `04-lifecycle-workflows-leaver/` — Workflow de baja automática en tiempo real (real-time employee termination): remoción de grupos, remoción de Teams, eliminación de cuenta.

Cada carpeta tiene su propio README con capturas y explicación paso a paso.

## Qué practiqué

- **HR-driven provisioning**: cómo Entra ID puede recibir datos desde un sistema de HR (Workday/SuccessFactors en el mundo real) como fuente autoritativa del ciclo de vida de identidades.
- **Grupos dinámicos**: reglas de membership tipo `(user.department -eq "Finance")`, y cómo estas reglas conectan directamente el dato de HR con el acceso técnico.
- **Group-based licensing**: asignación de licencias de Entra ID P2 y M365 Business Premium a nivel grupo, en vez de usuario por usuario.
- **Lifecycle Workflows**: automatización del proceso de "Leaver" (baja de empleado) con tareas predefinidas de Microsoft Entra ID Governance.
- **Troubleshooting real de licenciamiento**: diagnostiqué por qué una licencia de grupo no se propagaba a los usuarios, descartando causas (usage location, group ownership, tipo de grupo) hasta llegar a la causa real: el backend de Exchange/OneDrive todavía no había terminado de aprovisionar la infraestructura para un tenant/trial recién creado.

## Herramientas y licencias usadas

- Microsoft Entra Admin Center
- Microsoft 365 Admin Center
- Trials: Microsoft Entra ID P2, Microsoft 365 Business Premium, Microsoft Entra ID Governance

## Notas

Este es un tenant de laboratorio personal, sin datos reales de ninguna organización. Los nombres de usuarios y departamentos son ficticios.
