### Installation
```bash
git clone https://github.com/alltechdev/gplay-apk-downloader
cd gplay-apk-downloader
sudo apt install python3-venv
chmod +x setup.sh
./setup.sh
```

### For GUI
```bash
# Activate venv
source .venv/bin/activate

python3 server.py

# Go to http://localhost:5000 in your browser
```

### Usage
```bash

# Activate venv
source .venv/bin/activate

python3 gplay-downloader.py [-h] {auth,search,info,download} ...

Download APKs from Google Play Store

positional arguments:
  {auth,search,info,download}
    auth        Authenticate with Google Play
    search      Search for apps
    info        Get app details
    download    Download APK

options:
  -h, --help    Show this help message and exit

Examples:
  python3 gplay-downloader.py auth                    # Authenticate (anonymous)
  python3 gplay-downloader.py search whatsapp         # Search for apps
  python3 gplay-downloader.py info com.whatsapp       # Get app details
  python3 gplay-downloader.py download com.whatsapp   # Download APK
```
