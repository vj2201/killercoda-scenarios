#!/bin/bash
set -euo pipefail

echo "⏳ Preparing lab environment..."

echo "   Installing Docker..."
for i in {1..60}; do
  if command -v docker &> /dev/null; then
    echo "   ✓ Docker installed"
    break
  fi
  sleep 2
done

echo "   Downloading cri-dockerd package..."
for i in {1..30}; do
  if [ -f ~/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb ]; then
    echo "   ✓ Package ready"
    break
  fi
  sleep 2
done

echo ""
echo "✅ Ready! Proceed to the task."
echo ""
