# Gunicorn configuration for production
# Usage: gunicorn -c gunicorn.conf.py server:app

import multiprocessing

# Worker configuration
# gevent provides async workers that handle SSE streaming well
worker_class = 'gevent'
workers = multiprocessing.cpu_count() * 2 + 1
worker_connections = 1000

# Timeout for long-running requests (APK downloads/merges can take time)
timeout = 300  # 5 minutes
graceful_timeout = 30

# Server socket
bind = '0.0.0.0:5000'

# Logging
accesslog = '-'
errorlog = '-'
loglevel = 'info'

# Process naming
proc_name = 'gplay-downloader'

# Security - request limits
limit_request_line = 4096
limit_request_fields = 100

# Keep-alive for SSE connections
keepalive = 65
