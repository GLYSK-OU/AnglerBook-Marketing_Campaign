#!/usr/bin/env bash
set -e
SRC="/Users/giuseppelopes/Obsidian/Obsidian Vault - MAIN/01 - Projects/01.01 - AnglerBook/01.01.05 - Marketing & Campaigns"
cd "$(dirname "$0")"
python3 - "$SRC" << 'PY'
import sys, pathlib
src=sys.argv[1]
noindex='<meta name="robots" content="noindex,nofollow">'
def fix(p, navold, navnew):
    h=pathlib.Path(src,p).read_text(encoding="utf-8")
    if "noindex,nofollow" not in h: h=h.replace("<head>","<head>\n"+noindex,1)
    if navnew not in h: h=h.replace(navold, navold+navnew, 1)
    return h
open("index.html","w",encoding="utf-8").write(fix("marketing-dashboard.html","resync overwrites this file.",' · <a href="kanban.html">Kanban board →</a>'))
open("kanban.html","w",encoding="utf-8").write(fix("marketing-kanban.html",'<span id="synced"></span>',' · <a href="index.html">Metrics dashboard →</a>'))
print("rebuilt from vault")
PY
git add -A && git commit -q -m "Refresh dashboard $(date +%F)" && git push -q && echo "Published." || echo "Nothing to publish."
