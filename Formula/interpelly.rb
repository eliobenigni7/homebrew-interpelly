class Interpelly < Formula
  desc "Monitor degli interpelli per supplenze (francese/sostegno) — Milano e Lombardia"
  homepage "https://github.com/eliobenigni7/interpelly"
  url "https://github.com/eliobenigni7/homebrew-interpelly/releases/download/v1.0.1/interpelly-v1.0.1.tar.gz"
  sha256 "556cf4904ed043675cab32a94d545497037d7010fd02b546edc3a377b714a4cc"
  license "CC-BY-NC-4.0"

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    # dati persistenti fuori dal Cellar (sopravvivono agli aggiornamenti)
    (var/"lib/interpelly").mkpath
    system "ln", "-sfn", var/"lib/interpelly", libexec/"data"

    python = Formula["python@3.12"].opt_bin/"python3.12"
    system python, "-m", "venv", libexec/".venv"
    system libexec/".venv/bin/python", "-m", "pip", "install",
           "--no-cache-dir", "-r", libexec/"requirements.txt"

    (bin/"interpelly").write_exec_script wrapper(
      libexec/".venv/bin/python", libexec/"web/app.py"
    )
    (bin/"interpelly-ingest").write_exec_script wrapper(
      libexec/".venv/bin/python", libexec/"run_ingest.py", "$@"
    )
    (bin/"interpelly-scan").write_exec_script wrapper(
      libexec/".venv/bin/python", libexec/"scan_scuole.py", "$@"
    )
    (bin/"interpelly-loop").write_exec_script wrapper(
      libexec/".venv/bin/python", libexec/"run_loop.py", "$@"
    )
  end

  def wrapper(python, script, args = nil)
    <<~EOS
      #!/usr/bin/env bash
      [ -f "$HOME/.interpelly.env" ] && . "$HOME/.interpelly.env"
      exec "#{python}" "#{script}" #{args}
    EOS
  end

  service do
    run [bin/"interpelly-loop", "--interval", "1", "--scan", "--notify"]
    keep_alive true
    working_dir libexec
    log_path var/"log/interpelly.log"
    error_log_path var/"log/interpelly.log"
  end

  def caveats
    <<~EOS
      Dati in: #{var}/lib/interpelly

      Notifiche Telegram/email:
        cat > ~/.interpelly.env <<'EOF'
        TG_TOKEN=123456:ABC...
        TG_CHAT=123456789
        EOF

      Dashboard:  interpelly   (poi apri http://localhost:8000)
      Monitor:    brew services start interpelly
    EOS
  end

  test do
    assert_match(/since-days/, shell_output("#{bin}/interpelly-ingest --help"))
  end
end