# Personal Zsh overrides for omarchy
# This file contains jimmitjoo's custom Zsh settings

# PATH additions
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH="$HOME/.local/share/omarchy/bin:$PATH"

# Locale
export LC_TIME=sv_SE.UTF-8

# Editor configuration - VSCodium as primary editor
export EDITOR=codium
export VISUAL=codium

# Golang configuration
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# MySQL/MariaDB aliases
alias hyldedb='mariadb -u jimmitjoo hylde'
alias lazysql='~/.local/bin/lazysql'
alias sail='./vendor/bin/sail'

# Hylde stats script aliases
alias hyldestats='~/.local/bin/hylde-stats'
alias dagskassa='~/.local/bin/hylde-stats dagskassa'
alias forsaljning='~/.local/bin/hylde-stats forsaljning'
alias topprodukter='~/.local/bin/hylde-stats topprodukter'
alias saljare='~/.local/bin/hylde-stats saljare'
alias toppsaljare='~/.local/bin/hylde-stats toppsaljare'
alias venues='~/.local/bin/hylde-stats venues'
alias utbetalningar='~/.local/bin/hylde-stats utbetalningar'
alias ordrar='~/.local/bin/hylde-stats ordrar'
alias kassajournal='~/.local/bin/hylde-stats kassajournal'

# Database backup/connect functions removed - contained hardcoded credentials

# Database import function
db_import() {
    local DB_USER="${1:-jimmitjoo}"
    local DB_NAME="${2:-hylde}"
    local BACKUP_DIR="$HOME/backups/db"

    local LATEST_DUMP=$(find "$BACKUP_DIR" -maxdepth 1 -name "*.sql.gz" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -n1 | cut -d' ' -f2-)

    if [ -z "$LATEST_DUMP" ]; then
        echo "No backup files found in $BACKUP_DIR"
        return 1
    fi

    echo "Found latest dump: $(basename "$LATEST_DUMP")"
    echo "Importing to database '$DB_NAME' as user '$DB_USER'..."

    gunzip -c "$LATEST_DUMP" | mariadb -u "$DB_USER" "$DB_NAME"

    if [ $? -eq 0 ]; then
        echo "Import successful!"
    else
        echo "Import failed!"
        return 1
    fi
}

alias import_hylde='db_import "jimmitjoo" "hylde"'

# Database import function for Laravel Sail
db_import_sail() {
    local DB_NAME="${1:-laravel}"
    local BACKUP_DIR="$HOME/backups/db"
    local SAIL_DIR="${2:-.}"

    local LATEST_DUMP=$(find "$BACKUP_DIR" -maxdepth 1 -name "*.sql.gz" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -n1 | cut -d' ' -f2-)

    if [ -z "$LATEST_DUMP" ]; then
        echo "No backup files found in $BACKUP_DIR"
        return 1
    fi

    echo "Found latest dump: $(basename "$LATEST_DUMP")"
    echo "Importing to Sail database '$DB_NAME'..."

    if [ ! -f "$SAIL_DIR/vendor/bin/sail" ]; then
        echo "Error: Not in a Laravel Sail project directory. vendor/bin/sail not found."
        return 1
    fi

    gunzip -c "$LATEST_DUMP" | (cd "$SAIL_DIR" && ./vendor/bin/sail mysql "$DB_NAME")

    if [ $? -eq 0 ]; then
        echo "Import successful!"
    else
        echo "Import failed!"
        return 1
    fi
}

alias import_sail='db_import_sail "laravel"'

# VSCodium with Wayland support
alias code="/usr/bin/codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland"
alias codium="/usr/bin/codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland"

# Laravel shortcuts
alias art="php artisan"
alias tinker="php artisan tinker"
alias migrate="php artisan migrate"
alias mfs="php artisan migrate:fresh --seed"
alias seed="php artisan db:seed"
alias pest="./vendor/bin/pest"
alias pint="./vendor/bin/pint"
alias stan="./vendor/bin/phpstan analyse"
alias clear-all="php artisan cache:clear && php artisan config:clear && php artisan route:clear && php artisan view:clear"

# Composer shortcuts
alias cu="composer update"
alias ci="composer install"
alias cda="composer dump-autoload"

# Additional Laravel shortcuts
alias lnew='laravel new'
alias lsail='./vendor/bin/sail'
alias pt='./vendor/bin/pest --testdox'
alias pf='./vendor/bin/pest --filter'
alias serve='php artisan serve'
alias queue='php artisan queue:work'

# Golang shortcuts
alias gor='go run .'
alias gob='go build'
alias got='go test -v ./...'
alias goi='go install'
alias gomod='go mod tidy'
alias goair='air'

# Docker/Sail productivity
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcr='docker-compose restart'
alias dclogs='docker-compose logs -f'
alias sailup='./vendor/bin/sail up -d'
alias saildown='./vendor/bin/sail down'
alias sailartisan='./vendor/bin/sail artisan'

# Database management
alias tp='~/.local/bin/tableplus'
alias redis='redis-cli'
alias mysql='mariadb'

# Kill process on port
killport() {
    if [ -z "$1" ]; then
        echo "Usage: killport <port>"
        return 1
    fi
    lsof -ti:$1 | xargs -r kill -9 && echo "Killed processes on port $1" || echo "No process found on port $1"
}

# Productivity aliases
alias cat="bat"
alias ls="eza"
alias ll="eza -la"
alias tree="eza --tree"

# ============================================
# Developer Automation (added by Claude Code)
# ============================================

# CLI database tools (komplement till TablePlus)
alias hylde-cli='mycli -h 127.0.0.1 -P 3307 -u sail --pass password hylde'
alias gomanager-cli='pgcli -h 127.0.0.1 -p 5432 -U postgres go_manager'

# Git automation (Lefthook)
alias lh='lefthook'
alias qa='lefthook run pre-commit'
alias ci='act -j test'

# Watch commands - auto-lint/test on save
alias wpint='watchexec -e php -- ./vendor/bin/pint --dirty'
alias wpest='watchexec -e php -- ./vendor/bin/pest --dirty'
alias wgo='watchexec -e go -- gofumpt -l -w . && go vet ./...'
alias wgotest='watchexec -e go -- go test -short ./...'

# PHP debugging
alias xdebug-on='export XDEBUG_MODE=debug'
alias xdebug-off='export XDEBUG_MODE=off'
alias php-debug='XDEBUG_TRIGGER=1 php'
alias artisan-debug='XDEBUG_TRIGGER=1 php artisan'

# Go debugging (Delve)
alias godebug='dlv debug .'
alias dlv-test='dlv test'
alias dlv-attach='dlv attach'

# Initialize starship prompt
eval "$(starship init zsh)"

# ============================================
# Sergey Brin Mode: Search Everything
# ============================================

# Fuzzy alias search - type 'a' to search all aliases
a() {
  local selection
  selection=$(alias | sed 's/=/ → /' | fzf --height=40% --reverse --prompt="alias> " | cut -d' ' -f1)
  if [[ -n "$selection" ]]; then
    print -z "$selection"
  fi
}

# Search alias documentation
alias-help() {
  local query="${1:-}"
  if [[ -n "$query" ]]; then
    grep -i "$query" "$OMARCHY_PATH/custom/zsh/ALIASES.md" 2>/dev/null || echo "No matches for: $query"
  else
    cat "$OMARCHY_PATH/custom/zsh/ALIASES.md" | fzf --height=80% --reverse --preview-window=hidden
  fi
}

# Fuzzy git branch switching (override oh-my-zsh alias)
unalias gb 2>/dev/null
gb() {
  local branch
  branch=$(git branch -a --format='%(refname:short)' 2>/dev/null | fzf --height=40% --reverse --prompt="branch> ")
  if [[ -n "$branch" ]]; then
    git checkout "$branch"
  fi
}

# Fuzzy git log browser (override oh-my-zsh alias)
unalias gl 2>/dev/null
gl() {
  git log --oneline --color=always | fzf --ansi --height=80% --reverse --preview 'git show --color=always {1}' --bind 'enter:execute(git show {1})'
}

# Fuzzy docker container selector
dex() {
  local container
  container=$(docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}' | fzf --height=40% --reverse --prompt="container> " | cut -f1)
  if [[ -n "$container" ]]; then
    docker exec -it "$container" "${1:-/bin/sh}"
  fi
}

# Fuzzy docker logs
dlf() {
  local container
  container=$(docker ps -a --format '{{.Names}}\t{{.Image}}\t{{.Status}}' | fzf --height=40% --reverse --prompt="logs> " | cut -f1)
  if [[ -n "$container" ]]; then
    docker logs -f "$container"
  fi
}

# Fuzzy file opener with preview
f() {
  local file
  file=$(fzf --height=80% --reverse --preview 'bat --color=always --style=numbers --line-range=:500 {}' --preview-window=right:60%)
  if [[ -n "$file" ]]; then
    ${EDITOR:-codium} "$file"
  fi
}

# Fuzzy ripgrep - search content, then open file
rg-fzf() {
  local selection
  selection=$(rg --color=always --line-number --no-heading "$@" | fzf --ansi --height=80% --reverse --preview 'bat --color=always --style=numbers --highlight-line {2} {1}' --preview-window=right:60% --delimiter=':')
  if [[ -n "$selection" ]]; then
    local file=$(echo "$selection" | cut -d':' -f1)
    local line=$(echo "$selection" | cut -d':' -f2)
    ${EDITOR:-codium} "$file:$line"
  fi
}
alias s='rg-fzf'

# Fuzzy process killer
fkill() {
  local pid
  pid=$(ps aux | sed 1d | fzf --height=40% --reverse --prompt="kill> " | awk '{print $2}')
  if [[ -n "$pid" ]]; then
    kill -9 "$pid" && echo "Killed PID $pid"
  fi
}

# ============================================
# Ollama / Local LLM Integration
# ============================================

# LLM history file
LLM_HISTORY="$HOME/.local/share/omarchy/llm-history.md"

# Log LLM interaction
_llm_log() {
  local type="$1"
  local question="$2"
  local answer="$3"
  mkdir -p "$(dirname "$LLM_HISTORY")"
  {
    echo ""
    echo "## $(date '+%Y-%m-%d %H:%M') - $type"
    echo ""
    echo "**Q:** $question"
    echo ""
    echo "**A:** $answer"
    echo ""
    echo "---"
  } >> "$LLM_HISTORY"
}

# Quick question to local LLM
q() {
  if ! command -v ollama &>/dev/null; then
    echo "Ollama not installed. Install with: paru -S ollama"
    return 1
  fi

  local web_search=false
  local system_info=false
  local question=""

  # Parse flags
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -w|--web) web_search=true; shift ;;
      -s|--system) system_info=true; shift ;;
      *) question="$question $1"; shift ;;
    esac
  done
  question="${question## }"  # Trim leading space

  if [[ -z "$question" ]]; then
    echo "Usage: q [-w] [-s] <question>"
    echo "       q -w <question>  - include web search for current info"
    echo "       q -s <question>  - include local system info"
    echo "       qw <question>    - web search only"
    echo "       qh               - search history"
    return 1
  fi

  local full_prompt=""
  local web_context=""
  local sys_context=""

  # Gather system info if requested
  if [[ "$system_info" == true ]]; then
    echo "🖥️  Gathering system info..."
    sys_context="LOCAL SYSTEM INFORMATION:
---
OS: $(cat /etc/os-release 2>/dev/null | grep -E '^(NAME|VERSION)=' | tr '\n' ' ')
Kernel: $(uname -r)
Hostname: $(hostname)
User: $(whoami)
Uptime: $(uptime -p 2>/dev/null || uptime)
Shell: $SHELL
CPU: $(lscpu 2>/dev/null | grep 'Model name' | cut -d: -f2 | xargs)
Memory: $(free -h 2>/dev/null | awk '/Mem:/{print $2 " total, " $3 " used, " $4 " free"}')
Disk: $(df -h / 2>/dev/null | awk 'NR==2{print $2 " total, " $3 " used, " $4 " free (" $5 " used)"}')
GPU: $(lspci 2>/dev/null | grep -i 'vga\|3d\|display' | sed 's/.*: //' | paste -sd', ' -)
Desktop: ${XDG_CURRENT_DESKTOP:-unknown}
Display: ${WAYLAND_DISPLAY:-${DISPLAY:-unknown}}
---"
  fi

  # Web search if requested
  if [[ "$web_search" == true ]]; then
    local web_search_script="$HOME/.local/share/omarchy/bin/omarchy-web-search"
    if [[ -x "$web_search_script" ]]; then
      # Use the crawler script that fetches actual page content
      web_context=$("$web_search_script" -n 3 "$question" 2>/dev/null)
      if [[ -n "$web_context" ]]; then
        full_prompt="Today: $(date '+%Y-%m-%d')
${sys_context:+
$sys_context
}
WEB SEARCH RESULTS (with page content):
$web_context

TASK: Based on the web content above, answer this question: $question

RULES:
- Use the actual page content to give a precise answer
- Be direct and specific - cite actual data from the pages
- If the content includes weather/numbers/facts, include them
- IMPORTANT: Answer in the same language as the question

YOUR ANSWER:"
      else
        echo "⚠️  No search results found"
        full_prompt="Today: $(date '+%Y-%m-%d'). Answer in the same language as the question.
${sys_context:+
$sys_context
}
Question: $question"
      fi
    elif command -v ddgr &>/dev/null; then
      # Fallback to ddgr snippets only
      echo "🔍 Searching web (snippets only)..."
      web_context=$(ddgr --np -n 5 "$question" 2>/dev/null | head -60)
      if [[ -n "$web_context" ]]; then
        full_prompt="Today: $(date '+%Y-%m-%d')
${sys_context:+
$sys_context
}
SEARCH RESULTS:
$web_context

TASK: Read the context above and answer this question: $question

RULES:
- Use the provided information to answer
- Be direct: just give the answer, no hedging
- IMPORTANT: Answer in the same language as the question

YOUR ANSWER:"
      else
        echo "⚠️  No search results found"
        full_prompt="Today: $(date '+%Y-%m-%d'). Answer in the same language as the question.
${sys_context:+
$sys_context
}
Question: $question"
      fi
    else
      echo "⚠️  ddgr not installed. Install with: sudo pacman -S ddgr"
      return 1
    fi
  elif [[ -n "$sys_context" ]]; then
    full_prompt="Today: $(date '+%Y-%m-%d'). Answer in the same language as the question.

$sys_context

Based on the system information above, answer this question: $question"
  else
    full_prompt="Today: $(date '+%Y-%m-%d'). Answer in the same language as the question.

Question: $question"
  fi

  local answer
  answer=$(ollama run qwen2.5:14b "$full_prompt")
  echo "$answer"
  _llm_log "question" "$question" "$answer"
}

# Web search only (no LLM)
qw() {
  if ! command -v ddgr &>/dev/null; then
    echo "ddgr not installed. Install with: sudo pacman -S ddgr"
    return 1
  fi
  if [[ -z "$*" ]]; then
    echo "Usage: qw <search query>"
    return 1
  fi
  ddgr --np "$*"
}

# Search LLM history
qh() {
  if [[ ! -f "$LLM_HISTORY" ]]; then
    echo "No LLM history yet"
    return 1
  fi
  if [[ -n "$1" ]]; then
    grep -i -A 10 "$1" "$LLM_HISTORY"
  else
    cat "$LLM_HISTORY" | fzf --height=80% --reverse --preview-window=hidden
  fi
}

# Code review with local LLM
review() {
  if ! command -v ollama &>/dev/null; then
    echo "Ollama not installed"
    return 1
  fi
  local file="${1:-}"
  if [[ -z "$file" ]]; then
    file=$(fzf --height=40% --reverse --prompt="review> ")
  fi
  if [[ -n "$file" && -f "$file" ]]; then
    echo "Reviewing $file..."
    local answer
    answer=$(cat "$file" | ollama run codellama "Review this code for bugs and improvements. Be concise:")
    echo "$answer"
    _llm_log "review" "$file" "$answer"
  fi
}

# Explain error message
explain() {
  if ! command -v ollama &>/dev/null; then
    echo "Ollama not installed"
    return 1
  fi
  if [[ -z "$*" ]]; then
    echo "Usage: explain <error message>"
    echo "Or pipe: some-command 2>&1 | explain"
    return 1
  fi
  local question="$*"
  local answer
  answer=$(echo "$question" | ollama run qwen2.5:14b "Explain this error message and suggest a fix. Be concise:")
  echo "$answer"
  _llm_log "explain" "$question" "$answer"
}

# ============================================
# ML/AI Development (Lazy ML Developer Mode)
# ============================================

# Quick GPU status - all info at a glance
unalias gpu 2>/dev/null
gpu() {
  if ! command -v nvidia-smi &>/dev/null; then
    echo "NVIDIA drivers not installed"
    return 1
  fi

  echo ""
  echo "=== GPU Status ==="
  nvidia-smi --query-gpu=name,memory.used,memory.total,utilization.gpu,temperature.gpu,power.draw --format=csv,noheader | \
    awk -F',' '{printf "GPU: %s\nMemory: %s /%s\nUtilization:%s\nTemp:%s\nPower:%s\n", $1, $2, $3, $4, $5, $6}'
  echo ""

  # Show running processes on GPU
  local procs=$(nvidia-smi --query-compute-apps=pid,name,used_memory --format=csv,noheader 2>/dev/null)
  if [[ -n "$procs" ]]; then
    echo "=== GPU Processes ==="
    echo "$procs" | while read line; do
      echo "  $line"
    done
    echo ""
  fi
}

# Extended GPU monitoring for training
gpu-watch() {
  watch -n 1 'nvidia-smi --query-gpu=name,memory.used,memory.total,utilization.gpu,temperature.gpu,power.draw --format=csv && echo "" && nvidia-smi --query-compute-apps=pid,name,used_memory --format=csv 2>/dev/null'
}

# JupyterLab shortcut
jl() {
  local port="${1:-8888}"
  local dir="${2:-.}"

  echo "Starting JupyterLab on port $port..."
  cd "$dir"
  jupyter lab --no-browser --port="$port" &

  sleep 2
  echo "JupyterLab running at: http://localhost:$port"
  echo "Press Ctrl+C to stop"
}

# TensorBoard shortcut
tb() {
  local logdir="${1:-./runs}"
  local port="${2:-6006}"

  if [[ ! -d "$logdir" ]]; then
    echo "Log directory not found: $logdir"
    echo "Usage: tb [logdir] [port]"
    return 1
  fi

  echo "Starting TensorBoard..."
  tensorboard --logdir="$logdir" --port="$port" &

  sleep 2
  echo "TensorBoard running at: http://localhost:$port"
}

# Weights & Biases shortcuts
wb() {
  xdg-open "https://wandb.ai" 2>/dev/null || echo "Open https://wandb.ai in your browser"
}

wb-sync() {
  if ! command -v wandb &>/dev/null; then
    echo "wandb not installed. Run: pip install wandb"
    return 1
  fi
  wandb sync "$@"
}

# DVC shortcuts
dvc-push() {
  if ! command -v dvc &>/dev/null; then
    echo "DVC not installed. Run: pip install dvc"
    return 1
  fi
  dvc push "$@"
}

dvc-pull() {
  if ! command -v dvc &>/dev/null; then
    echo "DVC not installed. Run: pip install dvc"
    return 1
  fi
  dvc pull "$@"
}

# Create new ML project with best-practice structure
ml-new() {
  local project_name="$1"
  local template="${2:-basic}"

  if [[ -z "$project_name" ]]; then
    echo "Usage: ml-new <project-name> [template]"
    echo ""
    echo "Templates:"
    echo "  basic      - Minimal PyTorch setup (default)"
    echo "  vision     - Image classification/detection"
    echo "  nlp        - Text analysis with transformers"
    echo "  tabular    - Tabular data with scikit-learn/xgboost"
    echo "  timeseries - Time series forecasting"
    echo "  stream     - Real-time video processing"
    return 1
  fi

  if [[ -d "$project_name" ]]; then
    echo "Directory already exists: $project_name"
    return 1
  fi

  echo "Creating ML project: $project_name (template: $template)"

  # Create project structure
  mkdir -p "$project_name"/{src,data/{raw,processed,models},notebooks,configs,runs,scripts,tests}
  cd "$project_name"

  # Initialize git
  git init -q

  # Create .gitignore
  cat > .gitignore << 'GITIGNORE'
# Python
__pycache__/
*.py[cod]
*.egg-info/
.eggs/
*.egg
venv/
.venv/

# ML artifacts
*.pt
*.pth
*.onnx
*.h5
*.pkl
*.joblib
runs/
checkpoints/
*.weights
wandb/

# Data (use DVC for large files)
data/raw/
data/processed/
*.mp4
*.avi
*.mov
*.csv
*.parquet

# Jupyter
.ipynb_checkpoints/

# IDE
.idea/
.vscode/
*.swp

# OS
.DS_Store
Thumbs.db

# Environment
.env
.env.local
GITIGNORE

  # Create pyproject.toml for uv
  cat > pyproject.toml << PYPROJECT
[project]
name = "$project_name"
version = "0.1.0"
description = "ML project: $project_name"
requires-python = ">=3.10"

[project.optional-dependencies]
dev = ["pytest", "black", "ruff", "mypy"]

[tool.ruff]
line-length = 100
target-version = "py310"

[tool.black]
line-length = 100
target-version = ['py310']
PYPROJECT

  # Create requirements based on template
  case "$template" in
    basic)
      cat > requirements.txt << 'REQS'
torch>=2.0.0
torchvision>=0.15.0
numpy>=1.24.0
pandas>=2.0.0
matplotlib>=3.7.0
tensorboard>=2.13.0
tqdm>=4.65.0
PyYAML>=6.0
wandb>=0.15.0
REQS
      ;;
    vision)
      cat > requirements.txt << 'REQS'
torch>=2.0.0
torchvision>=0.15.0
ultralytics>=8.0.0
albumentations>=1.3.0
opencv-python>=4.8.0
numpy>=1.24.0
pandas>=2.0.0
matplotlib>=3.7.0
tensorboard>=2.13.0
tqdm>=4.65.0
Pillow>=9.5.0
wandb>=0.15.0
REQS
      ;;
    nlp)
      cat > requirements.txt << 'REQS'
torch>=2.0.0
transformers>=4.30.0
tokenizers>=0.13.0
datasets>=2.12.0
numpy>=1.24.0
pandas>=2.0.0
matplotlib>=3.7.0
tensorboard>=2.13.0
tqdm>=4.65.0
wandb>=0.15.0
accelerate>=0.20.0
REQS
      ;;
    tabular)
      cat > requirements.txt << 'REQS'
numpy>=1.24.0
pandas>=2.0.0
scikit-learn>=1.3.0
xgboost>=2.0.0
lightgbm>=4.0.0
matplotlib>=3.7.0
seaborn>=0.12.0
optuna>=3.3.0
wandb>=0.15.0
REQS
      ;;
    timeseries)
      cat > requirements.txt << 'REQS'
torch>=2.0.0
pytorch-forecasting>=1.0.0
pytorch-lightning>=2.0.0
numpy>=1.24.0
pandas>=2.0.0
matplotlib>=3.7.0
tensorboard>=2.13.0
wandb>=0.15.0
REQS
      ;;
    stream)
      cat > requirements.txt << 'REQS'
torch>=2.0.0
torchvision>=0.15.0
ultralytics>=8.0.0
opencv-python>=4.8.0
numpy>=1.24.0
supervision>=0.16.0
av>=10.0.0
tensorboard>=2.13.0
tqdm>=4.65.0
wandb>=0.15.0
REQS
      ;;
    *)
      echo "Unknown template: $template"
      return 1
      ;;
  esac

  # Create main training script
  cat > src/train.py << 'TRAINPY'
#!/usr/bin/env python3
"""Training script with experiment tracking."""

import argparse
import yaml
from pathlib import Path
from datetime import datetime

def load_config(config_path: str) -> dict:
    """Load YAML configuration."""
    with open(config_path) as f:
        return yaml.safe_load(f)

def train(config: dict):
    """Main training loop."""
    print(f"Starting training with config:")
    for key, value in config.items():
        print(f"  {key}: {value}")

    # TODO: Implement your training logic here
    print("\nTraining not implemented yet. Edit src/train.py")

def main():
    parser = argparse.ArgumentParser(description="Train model")
    parser.add_argument("--config", type=str, default="configs/default.yaml")
    parser.add_argument("--epochs", type=int, default=None)
    parser.add_argument("--batch-size", type=int, default=None)
    args = parser.parse_args()

    config = load_config(args.config)

    # Override with CLI args
    if args.epochs:
        config["training"]["epochs"] = args.epochs
    if args.batch_size:
        config["training"]["batch_size"] = args.batch_size

    train(config)

if __name__ == "__main__":
    main()
TRAINPY

  # Create default config
  cat > configs/default.yaml << 'CONFIGYAML'
# Training configuration
model:
  name: "model"
  pretrained: true

training:
  epochs: 100
  batch_size: 16
  learning_rate: 0.001
  optimizer: "AdamW"
  scheduler: "cosine"

data:
  train_path: "data/processed/train"
  val_path: "data/processed/val"

logging:
  tensorboard: true
  wandb: false
  save_every: 10
CONFIGYAML

  # Create README
  cat > README.md << README
# $project_name

ML project created with \`ml-new $project_name $template\`.

## Quick Start

\`\`\`bash
# Activate environment
source .venv/bin/activate

# Start training
train

# Watch training with auto-restart
train-watch

# Monitor GPU
gpu
\`\`\`

## Project Structure

\`\`\`
$project_name/
├── src/           # Source code
│   └── train.py   # Main training script
├── data/
│   ├── raw/       # Original data
│   ├── processed/ # Preprocessed data
│   └── models/    # Saved models
├── notebooks/     # Jupyter notebooks
├── configs/       # Training configs
├── runs/          # TensorBoard logs
└── tests/         # Unit tests
\`\`\`

## Commands

- \`train\` - Start training
- \`train-watch\` - Training with auto-restart on code changes
- \`gpu\` - GPU status
- \`tb\` - TensorBoard
- \`jl\` - JupyterLab
README

  # Create virtual environment with uv (if available)
  if command -v uv &>/dev/null; then
    echo "Creating virtual environment with uv..."
    uv venv
    echo "Installing dependencies..."
    uv pip install -r requirements.txt
  else
    echo "uv not found. Creating venv with python..."
    python -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
  fi

  # Initialize DVC if available
  if command -v dvc &>/dev/null; then
    dvc init -q
    echo "DVC initialized"
  fi

  echo ""
  echo "Project created: $project_name"
  echo ""
  echo "Next steps:"
  echo "  cd $project_name"
  echo "  source .venv/bin/activate"
  echo "  train"
}

# Training command with notification on completion
train() {
  local config="${1:-configs/default.yaml}"
  local start_time=$(date +%s)

  echo "Starting training..."

  # Activate venv if exists
  [[ -f ".venv/bin/activate" ]] && source .venv/bin/activate

  # Run training
  python src/train.py --config "$config"
  local exit_code=$?

  local end_time=$(date +%s)
  local duration=$((end_time - start_time))
  local minutes=$((duration / 60))
  local seconds=$((duration % 60))

  if [[ $exit_code -eq 0 ]]; then
    notify-send "Training Complete" "Finished in ${minutes}m ${seconds}s" 2>/dev/null || true
    echo "Training completed in ${minutes}m ${seconds}s"
  else
    notify-send "Training Failed" "Exit code: $exit_code" 2>/dev/null || true
    echo "Training failed with exit code: $exit_code"
  fi

  return $exit_code
}

# Training with auto-restart on code changes
train-watch() {
  local config="${1:-configs/default.yaml}"

  echo "Starting training with auto-restart on code changes..."
  echo "Watching: src/, configs/"
  echo "Press Ctrl+C to stop"
  echo ""

  watchexec -e py,yaml -w src -w configs -- bash -c "train $config"
}

# Training with automatic LLM error analysis
train-smart() {
  local config="${1:-configs/default.yaml}"
  local log_file="train_$(date +%Y%m%d_%H%M%S).log"

  echo "Starting smart training (logs: $log_file)..."

  train "$config" 2>&1 | tee "$log_file"
  local exit_code=${PIPESTATUS[0]}

  if [[ $exit_code -ne 0 ]]; then
    echo ""
    echo "Training failed. Analyzing errors..."
    local error=$(grep -i -A5 "error\|exception\|traceback" "$log_file" | tail -30)
    if [[ -n "$error" ]]; then
      ml-explain "$error"
    fi
  fi

  return $exit_code
}

# People counting from video stream (example for stream template)
stream-count() {
  local url="$1"
  local model="${2:-yolov8n.pt}"
  local output="${3:-}"

  if [[ -z "$url" ]]; then
    echo "Usage: stream-count <video-url|file|0> [model] [output]"
    echo ""
    echo "Examples:"
    echo "  stream-count 0                    # Webcam"
    echo "  stream-count rtsp://...           # RTSP stream"
    echo "  stream-count video.mp4            # Video file"
    echo "  stream-count rtsp://... yolov8m.pt output.mp4"
    return 1
  fi

  local counter_script="$OMARCHY_PATH/bin/ml-people-counter"

  if [[ ! -f "$counter_script" ]]; then
    echo "People counter script not found at: $counter_script"
    echo "Creating a basic version..."
    return 1
  fi

  python "$counter_script" --source "$url" --model "$model" ${output:+--output "$output"}
}

# ML-specific LLM queries - explain training errors
ml-explain() {
  if [[ -z "$*" ]]; then
    echo "Usage: ml-explain <error message>"
    echo "Or pipe: python train.py 2>&1 | ml-explain"
    return 1
  fi

  local error="$*"
  local prompt="You are an ML debugging expert. Today: $(date '+%Y-%m-%d').

Explain this PyTorch/ML training error and suggest fixes. Be concise and practical.
Answer in the same language as the error message.

Error:
$error"

  ollama run qwen2.5:14b "$prompt"
}

# Suggest hyperparameters
ml-suggest() {
  local task="${1:-classification}"
  local dataset_size="${2:-medium}"

  local prompt="Suggest optimal hyperparameters for $task with a $dataset_size dataset.
Include: learning rate, batch size, epochs, optimizer, scheduler, regularization.
Format as YAML. Be concise and practical."

  ollama run qwen2.5:14b "$prompt"
}

# Generate ML boilerplate code
ml-gen() {
  local what="$1"
  shift 2>/dev/null
  local details="$*"

  if [[ -z "$what" ]]; then
    echo "Usage: ml-gen <type> [details]"
    echo ""
    echo "Types:"
    echo "  dataloader   - PyTorch DataLoader"
    echo "  model        - Neural network architecture"
    echo "  training     - Training loop"
    echo "  augmentation - Data augmentation pipeline"
    echo "  metrics      - Evaluation metrics"
    echo "  wandb        - Weights & Biases logging"
    return 1
  fi

  local prompt="Generate PyTorch code for: $what
${details:+Details: $details}
Use modern best practices. Include type hints. Be production-ready and concise."

  ollama run deepseek-coder-v2:16b "$prompt"
}
