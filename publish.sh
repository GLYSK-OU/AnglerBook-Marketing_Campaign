#!/usr/bin/env bash
# Refresh the live GitHub Pages dashboard from the vault copies, then push.
# Usage: ./publish.sh   (run after marketing_sync.py has rebuilt the vault HTML)
set -e
SRC="/Users/giuseppelopes/Obsidian/Obsidian Vault - MAIN/01 - Projects/01.01 - AnglerBook/01.01.06 - Marketing & Campaigns"
cd "$(dirname "$0")"
python3 - "$SRC" << 'PY'
import sys, pathlib
src = sys.argv[1]
noindex = '<head>\n<meta name="robots" content="noindex,nofollow">'
d = pathlib.Path(src, "marketing-dashboard.html").read_text(encoding="utf-8")
k = pathlib.Path(src, "marketing-kanban.html").read_text(encoding="utf-8")
d = d.replace("<head>", noindex, 1).replace("resync overwrites this file.",
      'resync overwrites this file. · <a href="kanban.html">Kanban board →</a>', 1)
k = k.replace("<head>", noindex, 1).replace('<span id="synced"></span>',
      '<span id="synced"></span> · <a href="index.html">Metrics dashboard →</a>', 1)
pathlib.Path("index.html").write_text(d, encoding="utf-8")
pathlib.Path("kanban.html").write_text(k, encoding="utf-8")
print("rebuilt index.html + kanban.html from vault")
PY
git add -A
git commit -q -m "Refresh dashboard $(date +%F)" && git push -q && echo "Published — live in ~1 min." || echo "Nothing to publish (no changes)."
