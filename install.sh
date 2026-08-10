#!/usr/bin/env bash
# Interpelly — installatore one-shot (macOS / Linux).
# Scarica il tarball pubblico, crea venv e dipendenze, mostra i comandi.
# Uso:  curl -fsSL https://raw.githubusercontent.com/eliobenigni7/homebrew-interpelly/main/install.sh | bash
set -euo pipefail

VERSION="${INTERPELLY_VERSION:-v1.0.0}"
DIR="${INTERPELLY_DIR:-$HOME/interpelly}"
URL="https://github.com/eliobenigni7/homebrew-interpelly/releases/download/${VERSION}/interpelly-${VERSION}.tar.gz"

echo "✻ Interpelly ${VERSION}"
echo "  download: ${URL}"
mkdir -p "${DIR}"
curl -fsSL "${URL}" | tar -xzf - -C "${DIR}" --strip-components=1

echo "  creazione venv + dipendenze…"
python3 -m venv "${DIR}/.venv"
"${DIR}/.venv/bin/pip" install -q -r "${DIR}/requirements.txt"

[ -f "$HOME/.interpelly.env" ] || cp "${DIR}/.env.example" "$HOME/.interpelly.env"

cat <<EOF

✅ Interpelly installato in ${DIR}

  dashboard web:
    ${DIR}/.venv/bin/python -m uvicorn web.app:app --host 0.0.0.0 --port 8000
    → http://localhost:8000

  monitor continuo (ingest + scan + notifiche, ogni ora):
    ${DIR}/.venv/bin/python run_loop.py --interval 1 --scan --notify

  notifiche: completa prima ~/.interpelly.env (TG_TOKEN / TG_CHAT)

  Mac + Homebrew (modo nativo, servizio launchd):
    brew tap eliobenigni7/interpelly && brew install interpelly
    brew services start interpelly
EOF