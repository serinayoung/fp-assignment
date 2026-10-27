#!/bin/bash
# Startup script: FP concurrent log processor

echo "=== Linux version ==="
lsb_release -a

echo "=== Checking Elixir ==="
if ! command -v elixir &> /dev/null; then
  echo "Elixir not found. Install it with:"
  echo "  sudo apt update && sudo apt install -y elixir"
  exit 1
fi
elixir -v

echo "=== Running program ==="
if ls logs/server_*.log &> /dev/null; then
  elixir main.exs logs/server_*.log
else
  elixir main.exs
fi
