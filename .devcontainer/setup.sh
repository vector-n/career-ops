#!/bin/bash
# ============================================================
#  career-ops Codespaces Auto-Setup
#  Runs automatically after the container is created.
# ============================================================
set -e

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   career-ops Auto-Setup — Starting...   ║"
echo "╚══════════════════════════════════════════╝"

cd /workspaces/career-ops

# ── 1. Node dependencies ──────────────────────────────────
echo ""
echo "[1/5] Installing Node.js dependencies..."
npm install
echo "  ✓ npm install done"

# ── 2. Playwright + Chromium ──────────────────────────────
echo ""
echo "[2/5] Installing Playwright + Chromium (takes ~2 min)..."
npx playwright install chromium
npx playwright install-deps chromium
echo "  ✓ Playwright + Chromium ready"

# ── 3. OpenCode (free AI agent) ───────────────────────────
echo ""
echo "[3/5] Installing OpenCode..."
npm install -g opencode-ai
echo "  ✓ OpenCode $(opencode --version 2>/dev/null || echo 'installed')"

# ── 4. Go dashboard ───────────────────────────────────────
echo ""
echo "[4/5] Building Go dashboard..."
cd /workspaces/career-ops/dashboard
go build -o career-dashboard . 2>/dev/null && echo "  ✓ Dashboard built" || echo "  ⚠ Dashboard build skipped (Go not available)"
cd /workspaces/career-ops

# ── 5. Create folders + set up OpenCode config ────────────
echo ""
echo "[5/5] Creating output folders and configuring OpenCode..."
mkdir -p data reports output config

mkdir -p ~/.config/opencode
cat > ~/.config/opencode/config.json << 'EOF'
{
  "model": "groq/llama-3.3-70b-versatile",
  "providers": {
    "groq": {
      "models": [
        {
          "id": "llama-3.3-70b-versatile",
          "name": "Llama 3.3 70B (Free - Best Quality)",
          "contextWindow": 128000
        },
        {
          "id": "deepseek-r1-distill-llama-70b",
          "name": "DeepSeek R1 70B (Free - Best Reasoning)",
          "contextWindow": 131072
        },
        {
          "id": "llama-3.1-8b-instant",
          "name": "Llama 3.1 8B (Free - Fastest)",
          "contextWindow": 128000
        }
      ]
    }
  },
  "autocompact": true,
  "autoshare": false,
  "shell": "/bin/bash",
  "instructions": "You are helping Suhail Furas Hussein Al-Serri, a Petroleum Engineer from Yemen, run his job search using career-ops. His key skills: PETREL, CMG, PROSPER, MBAL, GAP, ArcGIS, T-navigator, Python, MATLAB, SolidWorks. Target roles: Petroleum Engineer, Drilling Engineer, Reservoir Engineer, Petrophysics Engineer. Preferred locations: Remote, UAE, Saudi Arabia, Qatar, Malaysia. When evaluating jobs, always check for petroleum software skill match. Minimum score to apply: 3.5/5."
}
EOF

# ── Verify cv.md exists ───────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║           Setup Complete! ✓             ║"
echo "╠══════════════════════════════════════════╣"

if [ -f "/workspaces/career-ops/cv.md" ]; then
  echo "║  ✓ cv.md found                          ║"
else
  echo "║  ⚠ cv.md NOT found — add it manually!  ║"
fi

if [ -f "/workspaces/career-ops/config/profile.yml" ]; then
  echo "║  ✓ config/profile.yml found             ║"
else
  echo "║  ⚠ profile.yml NOT found               ║"
fi

if [ -f "/workspaces/career-ops/portals.yml" ]; then
  echo "║  ✓ portals.yml found                    ║"
else
  echo "║  ⚠ portals.yml NOT found               ║"
fi

echo "╠══════════════════════════════════════════╣"
echo "║  NEXT STEPS:                            ║"
echo "║                                          ║"
echo "║  1. Get FREE Groq key:                  ║"
echo "║     → console.groq.com/keys             ║"
echo "║                                          ║"
echo "║  2. Set your key:                        ║"
echo "║     export GROQ_API_KEY=gsk_yourkey     ║"
echo "║                                          ║"
echo "║  3. Start the agent:                     ║"
echo "║     opencode                             ║"
echo "║                                          ║"
echo "║  4. Inside OpenCode:                     ║"
echo "║     /connect → Groq → paste key         ║"
echo "║     /career-ops scan                    ║"
echo "╚══════════════════════════════════════════╝"
