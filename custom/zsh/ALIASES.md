# Jimmitjoo's Omarchy Aliases

Quick reference for all custom shell aliases and functions.

## Laravel Development

| Alias | Command | Description |
|-------|---------|-------------|
| `art` | `php artisan` | Laravel Artisan CLI |
| `tinker` | `php artisan tinker` | Interactive REPL |
| `migrate` | `php artisan migrate` | Run migrations |
| `mfs` | `php artisan migrate:fresh --seed` | Fresh database with seeds |
| `seed` | `php artisan db:seed` | Run seeders |
| `serve` | `php artisan serve` | Start dev server |
| `queue` | `php artisan queue:work` | Process queue jobs |
| `clear-all` | cache:clear + config:clear + route:clear + view:clear | Clear all caches |

## Testing & Quality

| Alias | Command | Description |
|-------|---------|-------------|
| `pest` | `./vendor/bin/pest` | Run Pest tests |
| `pt` | `./vendor/bin/pest --testdox` | Tests with descriptions |
| `pf` | `./vendor/bin/pest --filter` | Filter tests |
| `pint` | `./vendor/bin/pint` | PHP code formatter |
| `stan` | `./vendor/bin/phpstan analyse` | Static analysis |
| `qa` | `lefthook run pre-commit` | Run all quality checks |

## Watch Commands (Auto-run on save)

| Alias | Description |
|-------|-------------|
| `wpint` | Auto-format PHP with Pint on save |
| `wpest` | Auto-run Pest tests on save |
| `wgo` | Auto-format Go code on save |
| `wgotest` | Auto-run Go tests on save |

## Composer

| Alias | Command | Description |
|-------|---------|-------------|
| `cu` | `composer update` | Update dependencies |
| `ci` | `composer install` | Install dependencies |
| `cda` | `composer dump-autoload` | Regenerate autoloader |
| `lnew` | `laravel new` | Create new Laravel project |

## Docker & Sail

| Alias | Command | Description |
|-------|---------|-------------|
| `sail` | `./vendor/bin/sail` | Laravel Sail CLI |
| `sailup` | `./vendor/bin/sail up -d` | Start Sail containers |
| `saildown` | `./vendor/bin/sail down` | Stop Sail containers |
| `sailartisan` | `./vendor/bin/sail artisan` | Artisan via Sail |
| `dcu` | `docker-compose up -d` | Start containers |
| `dcd` | `docker-compose down` | Stop containers |
| `dcr` | `docker-compose restart` | Restart containers |
| `dclogs` | `docker-compose logs -f` | Follow container logs |

## Go Development

| Alias | Command | Description |
|-------|---------|-------------|
| `gor` | `go run .` | Run current package |
| `gob` | `go build` | Build binary |
| `got` | `go test -v ./...` | Run all tests |
| `goi` | `go install` | Install binary |
| `gomod` | `go mod tidy` | Clean up go.mod |
| `goair` | `air` | Hot reload for Go |

## Debugging

| Alias | Description |
|-------|-------------|
| `xdebug-on` | Enable Xdebug |
| `xdebug-off` | Disable Xdebug |
| `php-debug` | Run PHP with Xdebug trigger |
| `artisan-debug` | Run Artisan with Xdebug |
| `godebug` | Start Delve debugger |
| `dlv-test` | Debug tests with Delve |
| `dlv-attach` | Attach Delve to process |

## Database

| Alias | Command | Description |
|-------|---------|-------------|
| `hyldedb` | `mariadb -u jimmitjoo hylde` | Connect to local Hylde DB |
| `mysql` | `mariadb` | MariaDB client |
| `redis` | `redis-cli` | Redis CLI |
| `hylde-cli` | mycli for Sail Hylde | MySQL CLI with autocomplete |
| `gomanager-cli` | pgcli for Go Manager | PostgreSQL CLI |

## Hylde Stats

| Alias | Description |
|-------|-------------|
| `hyldestats` | Hylde statistics tool |
| `dagskassa` | Daily cash report |
| `forsaljning` | Sales report |
| `topprodukter` | Top products |
| `saljare` | Sellers report |
| `toppsaljare` | Top sellers |
| `venues` | Venues report |
| `utbetalningar` | Payouts report |
| `ordrar` | Orders report |
| `kassajournal` | Cash journal |

## CLI Productivity

| Alias | Command | Description |
|-------|---------|-------------|
| `cat` | `bat` | Syntax-highlighted cat |
| `ls` | `eza` | Modern ls with icons |
| `ll` | `eza -la` | Long listing |
| `tree` | `eza --tree` | Tree view |
| `code` | `codium` (Wayland) | VSCodium editor |

## Functions

### `killport <port>`
Kill all processes on a specific port.
```bash
killport 8000  # Kill Laravel dev server
```

### `db_import [user] [database]`
Import latest database backup.
```bash
db_import              # Default: jimmitjoo, hylde
db_import root mydb    # Custom user/database
```

### `db_import_sail [database] [directory]`
Import backup to Laravel Sail database.
```bash
db_import_sail laravel .
```

---

## Sergey Brin Mode: Search Everything

### Fuzzy Search (fzf)

| Command | Description |
|---------|-------------|
| `a` | Fuzzy search all aliases, puts selection in prompt |
| `alias-help [query]` | Search alias documentation |
| `f` | Fuzzy file finder with preview, opens in editor |
| `s <pattern>` | Search file contents with ripgrep + fzf |
| `fkill` | Fuzzy process killer |

### Git (fzf-powered)

| Command | Description |
|---------|-------------|
| `gb` | Fuzzy git branch switcher |
| `gl` | Fuzzy git log browser with preview |

### Docker (fzf-powered)

| Command | Description |
|---------|-------------|
| `dex [shell]` | Fuzzy select container and exec into it |
| `dlf` | Fuzzy select container and follow logs |

### Local LLM (Ollama)

| Command | Description |
|---------|-------------|
| `q <question>` | Ask Mistral with date context (logged) |
| `q -w <question>` | Ask with web search for current info |
| `qw <query>` | DuckDuckGo search only (no LLM) |
| `qh [search]` | Search LLM history with fzf |
| `review [file]` | Code review with CodeLlama (logged) |
| `explain <error>` | Explain error message (logged) |

All LLM interactions are saved to `~/.local/share/omarchy/llm-history.md`

Examples:
```bash
q "vad är en mutex?"              # Basic question with date context
q -w "senaste php version?"       # Web search + LLM for current info
qw "arch linux news"              # Just web search, no LLM
```

### System Metrics

| Command | Description |
|---------|-------------|
| `omarchy-metrics-collect` | Collect system metrics (run via cron) |
| `omarchy-metrics-show [hours]` | Show metrics trends |

To enable automatic metrics collection:
```bash
crontab -e
# Add: * * * * * ~/.local/share/omarchy/bin/omarchy-metrics-collect
```

---

## ML/AI Development

### GPU & Monitoring

| Command | Description |
|---------|-------------|
| `gpu` | Quick GPU status (memory, utilization, temp, power) |
| `gpu-watch` | Live GPU monitoring with processes |

### Project & Training

| Command | Description |
|---------|-------------|
| `ml-new <name> [template]` | Create new ML project with structure |
| `train [config]` | Run training with desktop notification |
| `train-watch [config]` | Training with auto-restart on code changes |
| `train-smart [config]` | Training + automatic LLM error analysis |
| `tb [logdir] [port]` | Start TensorBoard (default: ./runs, 6006) |
| `jl [port]` | Start JupyterLab (default: 8888) |

**Project Templates:**
```bash
ml-new my-project basic      # Minimal PyTorch (default)
ml-new my-project vision     # Image classification/detection
ml-new my-project nlp        # Text with transformers
ml-new my-project tabular    # scikit-learn/xgboost
ml-new my-project timeseries # Time series forecasting
ml-new my-project stream     # Real-time video
```

### Experiment Tracking & Data

| Command | Description |
|---------|-------------|
| `wb` | Open Weights & Biases dashboard |
| `wb-sync` | Sync offline runs to W&B |
| `dvc-push` | Push data/models to remote storage |
| `dvc-pull` | Pull data/models from remote |

### LLM-Powered Helpers

| Command | Description |
|---------|-------------|
| `ml-explain <error>` | Explain ML training errors |
| `ml-suggest <task> [size]` | Suggest hyperparameters |
| `ml-gen <type>` | Generate ML boilerplate code |

**ml-gen types:** `dataloader`, `model`, `training`, `augmentation`, `metrics`, `wandb`

### Example: Video Stream (stream template)

| Command | Description |
|---------|-------------|
| `stream-count <url>` | Count people from video/webcam |

```bash
stream-count 0                    # Webcam
stream-count rtsp://camera/stream # RTSP stream
stream-count video.mp4 yolov8m.pt # Specific model
```

### ML Metrics

| Command | Description |
|---------|-------------|
| `omarchy-ml-metrics-collect` | Collect ML training metrics (cron) |
| `omarchy-ml-metrics-show [hours]` | Show training statistics |

To enable ML metrics collection:
```bash
crontab -e
# Add: * * * * * ~/.local/share/omarchy/bin/omarchy-ml-metrics-collect
```

---

*Generated from custom/zsh/overrides.zsh*
