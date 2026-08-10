# Homebrew Tap — Interpelly

Tap ufficiale per installare **Interpelly** (monitor degli interpelli per
supplenze di francese e sostegno, provincia di Milano / Lombardia).

## Installazione

```bash
brew tap eliobenigni7/interpelly
brew install interpelly

# monitor continuo (ingest + scan + notifiche, ogni ora) come servizio launchd:
brew services start interpelly
# stop: brew services stop interpelly

# comandi disponibili:
interpelly            # avvia la dashboard web su http://localhost:8000
interpelly-ingest     # ingest single-shot (vedi --help)
interpelly-scan       # scan dei siti delle secondarie II di Milano
interpelly-loop       # loop orario in foreground
```

Il tarball sorgente è pubblicato come release asset di questo stesso repo:
il codice applicativo resta nel repository privato `eliobenigni7/interpelly`.

## Configurazione notifiche

```bash
cat > ~/.interpelly.env <<'EOF'
TG_TOKEN=123456:ABC...
TG_CHAT=123456789
INTERPELLI_PROVINCES=MILANO
EOF
```

Il file viene caricato automaticamente dai comandi `interpelly*` e dal
servizio. Senza token, Interpelly funziona comunque (solo dashboard, senza
notifiche).

## Sviluppo

```bash
brew install --build-from-source eliobenigni7/interpelly/interpelly
brew audit --strict --online eliobenigni7/interpelly/interpelly
brew test eliobenigni7/interpelly/interpelly
```