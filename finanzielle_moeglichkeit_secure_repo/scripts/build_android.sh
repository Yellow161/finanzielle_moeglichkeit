
#!/usr/bin/env bash
set -euo pipefail

if [ -z "${API_KEY:-}" ]; then
  echo "ERROR: Bitte API_KEY als Umgebungsvariable setzen (export API_KEY=...)"
  exit 1
fi

cd app
flutter clean
flutter pub get

mkdir -p ../output/debug_info

flutter build apk --release \
  --dart-define=API_KEY=$API_KEY \
  --dart-define=API_BASE_URL=${API_BASE_URL:-http://10.0.2.2:5000} \
  --obfuscate --split-debug-info=../output/debug_info

flutter build appbundle --release \
  --dart-define=API_KEY=$API_KEY \
  --dart-define=API_BASE_URL=${API_BASE_URL:-http://10.0.2.2:5000} \
  --obfuscate --split-debug-info=../output/debug_info

mkdir -p ../output
cp build/app/outputs/flutter-apk/app-release.apk ../output/
cp build/app/outputs/bundle/release/app-release.aab ../output/

echo "Build fertig. APK & AAB im Ordner output/"
