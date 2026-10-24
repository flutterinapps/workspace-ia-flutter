---
trigger: always_on
---

# Accesibilidad e inclusión desde el día uno

- Áreas táctiles de al menos 48x48 dp. Contraste mínimo WCAG AA (4.5:1 texto).
- Todo icono interactivo lleva `tooltip` o `Semantics(label:)`; las imágenes
  decorativas se excluyen con `ExcludeSemantics`.
- Respeta `MediaQuery.textScaler`: el layout no se rompe con texto al 200%.
- Formularios inclusivos: nombres de una sola letra, con tildes, apóstrofos o
  guiones son válidos; no exijas apellido; no asumas formato de teléfono de un
  solo país; los campos opcionales aceptan vacío.
- Todo texto visible en `l10n` (EN/ES). Fechas y monedas con `intl`.
- Estados vacíos y de error con mensaje claro y una acción para salir de ahí.
