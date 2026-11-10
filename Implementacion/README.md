# MediTag — Flutter Web

**Proyecto independiente**, sin instaladores y sin conexión obligatoria a repositorios.

## Cómo abrir

1. Extrae el ZIP; verás una sola carpeta llamada `MediTag`.
2. Abre esa carpeta en Visual Studio Code.
3. Abre una terminal en esa carpeta y ejecuta:

```powershell
flutter pub get
flutter analyze
flutter run -d chrome
```

En el equipo de Michell, si CMD no reconoce Flutter, ejecutar primero:
`set "PATH=C:\Users\Michell\Desktop\flutter\bin;%PATH%"`

## Qué contiene
Pantallas de inicio, medicamentos, simulación NFC, historial, recordatorios y estadísticas; código organizado por funcionalidades y capas de dominio, datos y presentación.

## Límites
Este es un prototipo académico. Las tarjetas NFC **no se leen físicamente en Chrome de Windows**. El escaneo es simulado. No reemplaza orientación médica. Las notificaciones no son notificaciones del sistema operativo. No se ha compilado ni probado en este entorno, por lo que se debe verificar con `flutter analyze` y `flutter run -d chrome`.

El proyecto es independiente de GitHub; puedes versionarlo después si quieres.
