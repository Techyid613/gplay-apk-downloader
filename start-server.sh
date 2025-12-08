#!/bin/bash
# Start the GPlay APK Downloader server
# Usage: ./start-server.sh [dev|production]
# Default: production

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-production}"

# Kill existing server on port 5000
PID=$(lsof -ti:5000 2>/dev/null)
if [ -n "$PID" ]; then
    echo "Killing existing server (PID: $PID)"
    kill $PID 2>/dev/null
    sleep 2
fi

source "$SCRIPT_DIR/.venv/bin/activate"
cd "$SCRIPT_DIR"

# Log rotation - delete if older than 12 hours
if [ -f server.log ]; then
    if [ $(find server.log -mmin +720 2>/dev/null | wc -l) -gt 0 ]; then
        echo "Rotating old log file..."
        mv server.log "server.log.$(date +%Y%m%d_%H%M%S)"
        # Keep only last 7 days of logs
        find . -name 'server.log.*' -mtime +7 -delete 2>/dev/null
    fi
fi

if [ "$MODE" = "dev" ]; then
    echo "Starting in DEVELOPMENT mode (single-threaded, debug=True)..."
    FLASK_DEBUG=true python3 server.py 2>&1 | tee server.log
else
    echo "Starting in PRODUCTION mode with gunicorn (gevent workers)..."
    echo "Workers: $(python3 -c 'import multiprocessing; print(multiprocessing.cpu_count() * 2 + 1)')"
    nohup gunicorn -c gunicorn.conf.py server:app >> server.log 2>&1 &
    disown
    sleep 2
    NEW_PID=$(lsof -ti:5000 2>/dev/null)
    if [ -n "$NEW_PID" ]; then
        echo "Server started (PID: $NEW_PID)"
        echo "Logs: tail -f $SCRIPT_DIR/server.log"
    else
        echo "ERROR: Server failed to start. Check server.log for details."
        tail -20 server.log
        exit 1
    fi
fi
