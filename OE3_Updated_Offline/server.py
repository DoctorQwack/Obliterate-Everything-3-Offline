#!/usr/bin/env python3
# ================================================================================
#                     OBLITERATE EVERYTHING 3 OFFLINE EDITION
#                        PYTHON LAUNCHER & SERVER BACKEND
# ================================================================================
import os
import sys
import json
import re
import time
import urllib.parse
import http.server
import socketserver
import threading
import subprocess
import webbrowser
import shutil
import random

# Determine working directory
DIR = os.path.dirname(os.path.abspath(__file__))

# Global states
VERSION = "v0.8.0_Beta"
port = 8765
force_vault_refresh = False
force_logout = False
game_instances = []
instance_count = 0
shutdown_event = threading.Event()
autoshutdown_active = False

# Terminal Colors
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

# Logger function matching server.ps1 behavior
def log_message(msg, color="gray"):
    color_map = {
        "green": Colors.GREEN,
        "yellow": Colors.YELLOW,
        "red": Colors.FAIL,
        "cyan": Colors.CYAN,
        "blue": Colors.BLUE,
        "gray": "",
        "white": Colors.BOLD
    }
    c_start = color_map.get(color.lower(), "")
    c_end = Colors.ENDC if c_start else ""
    
    timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
    formatted_msg = f"[{timestamp}] {msg}"
    
    # Print to stdout
    print(f"{c_start}{formatted_msg}{c_end}", flush=True)
    
    # Write to log file
    try:
        with open(os.path.join(DIR, "log.txt"), "a", encoding="utf-8") as f:
            f.write(formatted_msg + "\n")
    except Exception:
        pass

# Default Configuration
config_path = os.path.join(DIR, "config.json")
config = {
    "launch_mode": "ask",
    "remember_mode": False,
    "ruffle_backend": "default",
    "default_quality": "medium",
    "disable_plat_purchase": False,
    "store_refresh_period_minutes": 60,
    "audio_quality": "standard",
    "multiplayer_mode": "local",
    "cpu_bot_enabled": True,
    "peer_target": ""
}

def load_config():
    global config
    if os.path.exists(config_path):
        try:
            with open(config_path, "r", encoding="utf-8-sig") as f:
                loaded = json.load(f)
                for k, v in loaded.items():
                    config[k] = v
            log_message("Loaded launcher config from config.json.", "green")
        except Exception as e:
            log_message(f"Error parsing config.json: {e}. Recreating defaults.", "yellow")
            save_config()
    else:
        save_config()

def save_config():
    try:
        with open(config_path, "w", encoding="utf-8") as f:
            json.dump(config, f, indent=2)
    except Exception as e:
        log_message(f"Error saving config.json: {e}", "red")

# HTTP Server request handler
class OE3HTTPRequestHandler(http.server.BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        # Suppress standard logging to prevent console pollution
        pass

    def do_GET(self):
        parsed_url = urllib.parse.urlparse(self.path)
        path = parsed_url.path.lstrip('/')
        query = urllib.parse.parse_qs(parsed_url.query)
        
        if path.startswith('multiplayer/'):
            if handle_multiplayer_proxy(self, path, 'GET', query):
                return
            if path == 'multiplayer/match':
                handle_multiplayer_match(self, query)
            elif path == 'multiplayer/game/go':
                handle_game_go(self, query)
            else:
                self.send_error(404, "Not Found")
        elif path == 'config':
            self.handle_get_config()
        elif path == 'load':
            self.handle_get_load(query)
        elif path == 'legacy/convert':
            self.handle_get_legacy_convert(query)
        else:
            self.handle_get_static(path)

    def do_POST(self):
        parsed_url = urllib.parse.urlparse(self.path)
        path = parsed_url.path.lstrip('/')
        query = urllib.parse.parse_qs(parsed_url.query)
        
        if path.startswith('multiplayer/'):
            content_length = int(self.headers.get('Content-Length', 0))
            body_data = self.rfile.read(content_length) if content_length > 0 else b''
            
            if handle_multiplayer_proxy(self, path, 'POST', query, body_data):
                return
                
            try:
                body_json = json.loads(body_data.decode('utf-8')) if body_data else {}
            except Exception:
                body_json = {}
                
            if path == 'multiplayer/game/start_info':
                handle_game_start_info(self, body_json)
            elif path == 'multiplayer/game/ready':
                handle_game_ready(self, query)
            elif path == 'multiplayer/game/checkin':
                handle_game_checkin(self, body_json)
            elif path == 'multiplayer/game/gameover':
                handle_game_gameover(self, body_json)
            else:
                self.send_error(404, "Not Found")
        elif path == 'save':
            self.handle_post_save(query)
        elif path == 'log':
            self.handle_post_log()
        elif path == 'legacy/generate_index':
            self.handle_post_legacy_generate_index()
        else:
            self.send_error(404, "Not Found")

    def send_json_response(self, code, data):
        body = json.dumps(data).encode('utf-8')
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def handle_get_config(self):
        global force_vault_refresh, force_logout
        cfg_data = {
            "launch_mode": config["launch_mode"],
            "remember_mode": config["remember_mode"],
            "ruffle_backend": config["ruffle_backend"],
            "default_quality": config["default_quality"],
            "disable_plat_purchase": config["disable_plat_purchase"],
            "store_refresh_period_minutes": config["store_refresh_period_minutes"],
            "audio_quality": config.get("audio_quality", "standard"),
            "multiplayer_mode": config.get("multiplayer_mode", "local"),
            "cpu_bot_enabled": config.get("cpu_bot_enabled", True),
            "peer_target": config.get("peer_target", ""),
            "force_vault_refresh": force_vault_refresh,
            "force_logout": force_logout
        }
        # Reset one-shot flags
        force_vault_refresh = False
        force_logout = False
        
        self.send_json_response(200, cfg_data)
        log_message("Request: GET /config -> 200 OK (Served config)", "green")

    def handle_get_load(self, query):
        user = query.get("user", [""])[0]
        user_safe = re.sub(r'[^a-zA-Z0-9_\-]', '', user)
        if not user_safe:
            user_safe = "GuestPlayer"
            
        saves_dir = os.path.join(DIR, "saves")
        save_file = os.path.join(saves_dir, f"save_{user_safe}.json")
        
        # Case-insensitive resolution if file is not found
        if not os.path.exists(save_file) and os.path.exists(saves_dir):
            user_safe_lower = f"save_{user_safe}.json".lower()
            for filename in os.listdir(saves_dir):
                if filename.lower() == user_safe_lower:
                    save_file = os.path.join(saves_dir, filename)
                    break
                    
        # Fallback to root directory
        if not os.path.exists(save_file):
            fallback_file = os.path.join(DIR, f"save_{user_safe}.json")
            if os.path.exists(fallback_file):
                save_file = fallback_file
                
        if os.path.exists(save_file) and os.path.isfile(save_file):
            try:
                with open(save_file, "r", encoding="utf-8-sig") as f:
                    data = json.load(f)
                self.send_json_response(200, data)
                log_message(f"Request: GET /load?user={user_safe} -> 200 OK (Loaded profile)", "green")
            except Exception as e:
                self.send_json_response(500, {"error": f"Error reading save: {e}"})
        else:
            self.send_json_response(404, {"error": "no save file"})
            log_message(f"Request: GET /load?user={user_safe} -> 404 Not Found (No save file)", "yellow")

    def handle_post_save(self, query):
        user = query.get("user", [""])[0]
        user_safe = re.sub(r'[^a-zA-Z0-9_\-]', '', user)
        if not user_safe:
            user_safe = "GuestPlayer"
            
        content_length = int(self.headers.get('Content-Length', 0))
        body_data = self.rfile.read(content_length)
        
        saves_dir = os.path.join(DIR, "saves")
        if not os.path.exists(saves_dir):
            os.makedirs(saves_dir)
            
        save_file = os.path.join(saves_dir, f"save_{user_safe}.json")
        try:
            with open(save_file, "wb") as f:
                f.write(body_data)
            self.send_json_response(200, {"status": "ok"})
            log_message(f"Request: POST /save?user={user_safe} -> 200 OK (Saved profile)", "green")
        except Exception as e:
            self.send_json_response(500, {"error": f"Error saving profile: {e}"})

    def handle_post_log(self):
        content_length = int(self.headers.get('Content-Length', 0))
        body_data = self.rfile.read(content_length).decode('utf-8', errors='ignore')
        log_message(f"[CLIENT] {body_data}", "cyan")
        self.send_response(200)
        self.end_headers()

    def handle_post_legacy_generate_index(self):
        for f in ["index_status.json", "legacy_index.json"]:
            path = os.path.join(DIR, f)
            if os.path.exists(path):
                try:
                    os.remove(path)
                except Exception:
                    pass
                    
        log_message("Starting background scan of legacy database...", "cyan")
        try:
            subprocess.Popen([sys.executable, "generate_index.py"], cwd=DIR)
            self.send_json_response(200, {"status": "ok"})
        except Exception as e:
            self.send_json_response(500, {"error": f"Failed to start generator: {e}"})

    def handle_get_legacy_convert(self, query):
        user = query.get("user", [""])[0]
        line = query.get("line", [""])[0]
        
        log_message(f"Converting legacy save for: {user} (Line {line}) natively...", "cyan")
        
        convert_script = os.path.join(DIR, "convert_save.py")
        if not os.path.exists(convert_script):
            self.send_json_response(404, {"status": "error", "message": "Save converter script not available."})
            log_message("Conversion failed: convert_save.py not found", "red")
            return
            
        try:
            result = subprocess.run(
                [sys.executable, "convert_save.py", "--user", user, "--line", line],
                cwd=DIR, capture_output=True, text=True
            )
            if result.returncode == 0:
                self.send_json_response(200, {"status": "ok"})
                log_message(f"Conversion successful for legacy user: {user}", "green")
            else:
                error_msg = result.stderr or result.stdout or "Unknown conversion error"
                self.send_json_response(500, {"status": "error", "message": error_msg.strip()})
                log_message(f"Conversion failed for legacy user {user}: {error_msg.strip()}", "red")
        except Exception as e:
            self.send_json_response(500, {"status": "error", "message": str(e)})

    def handle_get_static(self, path):
        if path == '':
            path = 'index.html'
            
        # Security validation (prevent directory traversal)
        safe_path = os.path.normpath(os.path.join(DIR, path))
        if not safe_path.startswith(os.path.normpath(DIR)):
            self.send_error(403, "Access Denied")
            return
            
        if os.path.exists(safe_path) and os.path.isfile(safe_path):
            ext = os.path.splitext(safe_path)[1].lower()
            mime_types = {
                '.html': 'text/html; charset=utf-8',
                '.js': 'application/javascript; charset=utf-8',
                '.wasm': 'application/wasm',
                '.swf': 'application/x-shockwave-flash',
                '.css': 'text/css; charset=utf-8',
                '.png': 'image/png',
                '.jpg': 'image/jpeg',
                '.jpeg': 'image/jpeg',
                '.gif': 'image/gif',
                '.ico': 'image/x-icon',
                '.txt': 'text/plain; charset=utf-8',
                '.json': 'application/json; charset=utf-8'
            }
            content_type = mime_types.get(ext, 'application/octet-stream')
            
            try:
                with open(safe_path, "rb") as f:
                    body = f.read()
                self.send_response(200)
                self.send_header("Content-Type", content_type)
                self.send_header("Content-Length", str(len(body)))
                self.end_headers()
                self.wfile.write(body)
                
                # Exclude saves folder logging to reduce clutter
                if not path.startswith("saves/"):
                    log_message(f"Request: GET /{path} -> 200 OK ({len(body)} bytes, {content_type})", "green")
            except Exception as e:
                self.send_error(500, f"Error reading file: {e}")
        else:
            self.send_response(404)
            self.end_headers()
            if not path.startswith("saves/"):
                log_message(f"Request: GET /{path} -> 404 Not Found", "yellow")

def is_key_pressed():
    if sys.platform.startswith('win'):
        try:
            import msvcrt
            return msvcrt.kbhit()
        except Exception:
            pass
    else:
        try:
            import select
            r, _, _ = select.select([sys.stdin], [], [], 0.0)
            return bool(r)
        except Exception:
            pass
    return False

def is_wsl():
    if sys.platform.startswith('linux'):
        try:
            with open('/proc/version', 'r') as f:
                return 'microsoft' in f.read().lower()
        except Exception:
            pass
    return False

def open_browser_wsl(url):
    if shutil.which("wslview"):
        try:
            subprocess.Popen(["wslview", url], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            return True
        except Exception:
            pass
    for exe in ["powershell.exe", "cmd.exe", "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe", "/mnt/c/Windows/System32/cmd.exe"]:
        exe_path = shutil.which(exe) or (exe if os.path.exists(exe) else None)
        if exe_path:
            try:
                if "powershell.exe" in exe_path:
                    subprocess.Popen([exe_path, "-NoProfile", "-Command", f"Start-Process '{url}'"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                    return True
                elif "cmd.exe" in exe_path:
                    subprocess.Popen([exe_path, "/c", f"start \"\" \"{url}\""], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                    return True
            except Exception:
                pass
    return False

# Choose Launch Mode Prompt Menu
def choose_launch_mode():
    global config
    
    is_windows = sys.platform.startswith('win')
    flash_exe = os.path.join(DIR, "flashplayer.exe" if is_windows else "flashplayer")
    ruffle_exe = os.path.join(DIR, "ruffle.exe" if is_windows else "ruffle")
    
    has_flash = os.path.exists(flash_exe)
    has_ruffle = os.path.exists(ruffle_exe) or (not is_windows and shutil.which("ruffle") is not None)
    has_converter = os.path.exists(os.path.join(DIR, "converter.html"))
    
    flash_status = "Available - Recommended" if has_flash else "NOT FOUND"
    ruffle_status = "Available" if has_ruffle else "NOT FOUND"
    
    print("\n==================================================", flush=True)
    print(" Choose Graphics/Engine Launch Option:", flush=True)
    print("==================================================", flush=True)
    print(f" [1] Standalone Flash Player ({flash_status})", flush=True)
    print(f" [2] Ruffle Desktop Player ({ruffle_status})", flush=True)
    print(" [3] Web Browser (Local Ruffle WebAssembly)", flush=True)
    print(" [4] Auto-Detect (Uses best available)", flush=True)
    if has_converter:
        print(" [5] Web Save Converter", flush=True)
    print("==================================================", flush=True)
    
    max_choice = 5 if has_converter else 4
    choice = input(f" Enter choice (1-{max_choice}, Default is 1): ").strip()
    if not choice:
        choice = "1"
        
    mode_map = {
        "1": "flashplayer",
        "2": "ruffle",
        "3": "browser",
        "4": "auto",
        "5": "converter"
    }
    selected_mode = mode_map.get(choice, "flashplayer")
    
    rem = input(" Remember this selection for next launch? (y/n): ").strip().lower()
    if rem in ('y', 'yes'):
        config["launch_mode"] = selected_mode
        config["remember_mode"] = True
        save_config()
        log_message("Launch mode selection remembered.", "green")
        
    return selected_mode

# Launch Game Process Helper
def launch_game(mode=None, extra_args=None):
    global config, game_instances, instance_count, port
    if not extra_args:
        extra_args = []
    if not mode:
        mode = config["launch_mode"]
        if mode == "ask":
            mode = choose_launch_mode()
            
    is_windows = sys.platform.startswith('win')
    port_str = str(port)
    is_wsl_env = is_wsl()
    
    # Determine SWF based on configured audio quality
    swf_name = "OE3_HQ.swf" if config.get("audio_quality", "standard") == "high" else "OE3_UPDATED.swf"
    
    # Check for missing display server on WSL/Linux for GUI modes
    if mode in ("flashplayer", "ruffle") and not is_windows:
        has_display = bool(os.environ.get("DISPLAY") or os.environ.get("WAYLAND_DISPLAY"))
        if is_wsl_env and not has_display:
            log_message("[WARNING] Running in WSL without an active X/Wayland server or DISPLAY. Standalone GUI players (Flash/Ruffle) will fail to launch.", "yellow")
            log_message("To play, please either:", "yellow")
            log_message("  1. Configure an X server on Windows (like VcXsrv) and set export DISPLAY=127.0.0.1:0.0", "yellow")
            log_message("  2. Use Web Browser mode [3] which opens the game on your Windows host.", "yellow")
            log_message("Automatically falling back to Web Browser mode...", "yellow")
            return launch_game("browser", extra_args=extra_args)
            
    # Executable paths
    flash_exe = os.path.join(DIR, "flashplayer.exe" if is_windows else "flashplayer")
    ruffle_exe = os.path.join(DIR, "ruffle.exe" if is_windows else "ruffle")
    if not is_windows and not os.path.exists(ruffle_exe):
        system_ruffle = shutil.which("ruffle")
        if system_ruffle:
            ruffle_exe = system_ruffle
            
    proc = None
    
    if mode == "converter":
        url = f"http://127.0.0.1:{port_str}/converter.html"
        log_message(f"Opening Save Converter: {url}", "cyan")
        if is_wsl_env and open_browser_wsl(url):
            log_message("Browser launched successfully via WSL host bridge.", "green")
        else:
            try:
                webbrowser.open(url)
                log_message("Browser launched successfully.", "green")
            except Exception as e:
                log_message(f"Could not open browser automatically: {e}. Please open {url} manually.", "yellow")
        return
        
    elif mode == "flashplayer":
        if os.path.exists(flash_exe):
            url = f"http://127.0.0.1:{port_str}/{swf_name}"
            log_message(f"Launching Flash Player Projector: {url}", "cyan")
            try:
                args = [flash_exe, url] + extra_args
                if is_windows:
                    proc = subprocess.Popen(args)
                else:
                    log_err_path = os.path.join(DIR, "game_error.log")
                    log_err_file = open(log_err_path, "w", encoding="utf-8")
                    proc = subprocess.Popen(args, stdout=subprocess.DEVNULL, stderr=log_err_file)
                    log_err_file.close()
                log_message("Flash Player Projector launched successfully.", "green")
            except Exception as e:
                log_message(f"Failed to start Flash Player Projector: {e}. Falling back to Ruffle...", "yellow")
                return launch_game("ruffle", extra_args=extra_args)
        else:
            log_message("Flash Player Projector not found. Falling back to Ruffle...", "yellow")
            return launch_game("ruffle", extra_args=extra_args)
            
    elif mode == "ruffle":
        has_ruffle = os.path.exists(ruffle_exe) or (not is_windows and shutil.which("ruffle") is not None)
        if has_ruffle:
            url = f"http://127.0.0.1:{port_str}/{swf_name}"
            backend = config.get("ruffle_backend", "default")
            log_message(f"Launching Ruffle Desktop Player with graphics backend '{backend}'...", "cyan")
            try:
                args = [ruffle_exe, url]
                if backend != "default":
                    args.extend(["-g", backend])
                if extra_args:
                    args.extend(extra_args)
                if is_windows:
                    proc = subprocess.Popen(args)
                else:
                    log_err_path = os.path.join(DIR, "game_error.log")
                    log_err_file = open(log_err_path, "w", encoding="utf-8")
                    proc = subprocess.Popen(args, stdout=subprocess.DEVNULL, stderr=log_err_file)
                    log_err_file.close()
                log_message("Ruffle Desktop launched successfully.", "green")
            except Exception as e:
                log_message(f"Failed to start Ruffle Desktop: {e}. Falling back to browser...", "yellow")
                return launch_game("browser", extra_args=extra_args)
        else:
            log_message("Ruffle Desktop Player not found. Falling back to browser...", "yellow")
            return launch_game("browser", extra_args=extra_args)
            
    elif mode == "browser":
        url = f"http://127.0.0.1:{port_str}/"
        log_message(f"Opening game in Web Browser: {url}", "cyan")
        if is_wsl_env and open_browser_wsl(url):
            log_message("Browser launched successfully via WSL host bridge.", "green")
        else:
            try:
                webbrowser.open(url)
                log_message("Browser launched successfully.", "green")
            except Exception as e:
                log_message(f"Could not open browser automatically: {e}. Please open {url} manually.", "yellow")
            
    elif mode == "auto":
        has_flash = os.path.exists(flash_exe)
        has_ruffle = os.path.exists(ruffle_exe) or (not is_windows and shutil.which("ruffle") is not None)
        if has_flash:
            return launch_game("flashplayer", extra_args=extra_args)
        elif has_ruffle:
            return launch_game("ruffle", extra_args=extra_args)
        else:
            return launch_game("browser", extra_args=extra_args)
            
    if proc:
        instance_count += 1
        actual_mode = mode
        if actual_mode in ("ask", "auto"):
            actual_mode = "ruffle" if (os.path.exists(ruffle_exe) or not os.path.exists(flash_exe)) else "flashplayer"
        inst = {
            "id": instance_count,
            "process": proc,
            "mode": actual_mode,
            "start_time": time.strftime("%H:%M:%S"),
            "start_timestamp": time.time()
        }
        game_instances.append(inst)

# Diagnostics function matching server.ps1
def run_diagnostics():
    print("=== Launcher & Server Diagnostics ===", flush=True)
    print(f"  Python Version:         {sys.version.split()[0]}", flush=True)
    print(f"  OS Platform:            {sys.platform}", flush=True)
    print(f"  Working Directory:      {DIR}", flush=True)
    print(f"  Port Binding:           http://127.0.0.1:{port}/", flush=True)
    
    is_windows = sys.platform.startswith('win')
    files = ["index.html", "OE3_UPDATED.swf", "OE3_HQ.swf", "flashplayer.exe" if is_windows else "flashplayer", "ruffle.exe" if is_windows else "ruffle"]
    print("  File Checks:", flush=True)
    for f in files:
        p = os.path.join(DIR, f)
        exists = os.path.exists(p)
        status = "FOUND" if exists else "NOT FOUND"
        color = Colors.GREEN if exists else Colors.YELLOW
        if f in ("index.html", "OE3_UPDATED.swf") and not exists:
            status = "CRITICAL MISSING"
            color = Colors.FAIL
        print(f"    {f}: {color}{status}{Colors.ENDC}", flush=True)

# Scan Saves function matching server.ps1
def check_saves():
    saves_dir = os.path.join(DIR, "saves")
    if not os.path.exists(saves_dir):
        print(f"{Colors.FAIL}Saves folder not found at: {saves_dir}{Colors.ENDC}", flush=True)
        return
        
    files = [f for f in os.listdir(saves_dir) if f.startswith("save_") and f.endswith(".json")]
    if not files:
        print(f"{Colors.YELLOW}No save files found in saves/ folder.{Colors.ENDC}", flush=True)
        return
        
    print(f"{Colors.CYAN}Scanning save profiles:{Colors.ENDC}", flush=True)
    for filename in files:
        path = os.path.join(saves_dir, filename)
        user = filename.replace("save_", "").replace(".json", "")
        size = os.path.getsize(path)
        modified = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(os.path.getmtime(path)))
        status = "OK"
        error_msg = ""
        
        try:
            with open(path, "r", encoding="utf-8-sig") as f:
                json_data = json.load(f)
            if not json_data:
                status = "EMPTY FILE"
            elif "credits" not in json_data or "platinum" not in json_data:
                status = "WARNING (Keys missing)"
        except Exception as e:
            status = "CORRUPT JSON"
            error_msg = str(e)
            
        print(f"  User: {user}", flush=True)
        print(f"    Size: {size} bytes", flush=True)
        print(f"    Last Modified: {modified}", flush=True)
        color = Colors.GREEN if status == "OK" else Colors.FAIL
        print(f"    Status: {color}{status}{Colors.ENDC}", flush=True)
        if error_msg:
            print(f"    Error: {Colors.YELLOW}{error_msg}{Colors.ENDC}", flush=True)

# Execute Console CLI Command
def execute_command(input_str):
    global config, force_vault_refresh, force_logout, game_instances, autoshutdown_active
    parts = input_str.strip().split()
    if not parts:
        return
        
    action = parts[0].lower()
    
    if action in ("exit", "resume"):
        print(f"{Colors.GREEN}Server remains running in background mode.{Colors.ENDC}", flush=True)
        return

    if action == "help":
        print("Commands List:", flush=True)
        print("  help                 Display this help menu", flush=True)
        print("  launch [mode] [args] Launch a new instance of the game with optional custom args", flush=True)
        print("  instances            List all active game instances", flush=True)
        print("  close <id>           Close a specific running game instance", flush=True)
        print("  logout               Push logout signal to all connected clients", flush=True)
        print("  logs                 Output the last 20 log entries", flush=True)
        print("  config               Display current configurations", flush=True)
        print("  mode <type>          Set launch mode (ask, flashplayer, ruffle, browser, auto)", flush=True)
        print("  quality <val>        Set default Ruffle graphics quality (high, medium, low)", flush=True)
        print("  backend <type>       Set default Ruffle backend (vulkan, dx12, dx11, gl, default)", flush=True)
        print("  audio <type>         Set default audio quality (standard, high)", flush=True)
        print("  plat <on/off>        Toggle Platinum purchases (on/off)", flush=True)
        print("  store-period <min>   Set store refresh period in minutes", flush=True)
        print("  refresh-store        Force immediate shop items and vault clock refresh", flush=True)
        print("  saves                Open local saves folder", flush=True)
        print("  check-saves          Perform diagnostic integrity scan on all user saves", flush=True)
        print("  diagnostics          Run server health diagnostics check", flush=True)
        print("  multiplayer <local|lan> Switch active multiplayer mode", flush=True)
        print("  cpu-bot <on|off>     Enable/disable simulated CPU opponent in matchmaking", flush=True)
        print("  peer <ip:port>       Set remote host target for P2P play (empty to clear)", flush=True)
        print("  update [force]       Check and apply system updates in the background", flush=True)
        print("  shutdown             Stop server and exit launcher terminal", flush=True)
        
    elif action == "launch":
        mode = None
        extra_args = []
        if len(parts) > 1:
            val = parts[1].lower()
            if val in ("ask", "flashplayer", "ruffle", "browser", "auto", "converter"):
                mode = val
                extra_args = parts[2:]
            else:
                extra_args = parts[1:]
        launch_game(mode=mode, extra_args=extra_args)
        
    elif action == "instances":
        if not game_instances:
            print(f"{Colors.YELLOW}No active game instances tracked.{Colors.ENDC}", flush=True)
        else:
            print(f"{Colors.CYAN}Active game instances:{Colors.ENDC}", flush=True)
            for inst in game_instances:
                print(f"  Instance {inst['id']}: PID {inst['process'].pid} | Mode: {inst['mode']} | Started: {inst['start_time']}", flush=True)
                
    elif action == "close":
        if len(parts) < 2:
            print(f"{Colors.YELLOW}Usage: close <id>{Colors.ENDC}", flush=True)
            return
        try:
            inst_id = int(parts[1])
            target = None
            for inst in game_instances:
                if inst["id"] == inst_id:
                    target = inst
                    break
            if target:
                target["process"].kill()
                print(f"Terminated game instance {inst_id}.", flush=True)
            else:
                print(f"{Colors.FAIL}Instance ID {inst_id} not found.{Colors.ENDC}", flush=True)
        except ValueError:
            print(f"{Colors.FAIL}Invalid Instance ID.{Colors.ENDC}", flush=True)
            
    elif action == "logout":
        force_logout = True
        log_message("Force logout pushed to all connected client sessions.", "green")
        print(f"{Colors.GREEN}Logout instruction queued. Client profiles will sign out on next status poll.{Colors.ENDC}", flush=True)
        
    elif action == "logs":
        log_path = os.path.join(DIR, "log.txt")
        if os.path.exists(log_path):
            with open(log_path, "r", encoding="utf-8") as f:
                lines = f.readlines()
            print("Recent Logs:", flush=True)
            for line in lines[-20:]:
                print(line.strip(), flush=True)
        else:
            print("No log entries written yet.", flush=True)
            
    elif action == "config":
        print(json.dumps(config, indent=2), flush=True)
        
    elif action == "mode":
        if len(parts) < 2:
            print(f"Current Launch Mode: {config['launch_mode']}", flush=True)
            print("Valid Options: ask, flashplayer, ruffle, browser, auto, converter", flush=True)
        else:
            new_mode = parts[1].lower()
            if new_mode in ("ask", "flashplayer", "ruffle", "browser", "auto", "converter"):
                config["launch_mode"] = new_mode
                if new_mode == "ask":
                    config["remember_mode"] = False
                else:
                    config["remember_mode"] = True
                save_config()
                print(f"{Colors.GREEN}Launch mode set to '{new_mode}' in config.json.{Colors.ENDC}", flush=True)
            else:
                print(f"{Colors.FAIL}Invalid mode option: '{new_mode}'.{Colors.ENDC}", flush=True)
                
    elif action == "quality":
        if len(parts) < 2:
            print(f"Current Quality: {config['default_quality']}", flush=True)
        else:
            q = parts[1].lower()
            if q in ("high", "medium", "low"):
                config["default_quality"] = q
                save_config()
                print(f"{Colors.GREEN}Default Ruffle quality set to '{q}' in config.json.{Colors.ENDC}", flush=True)
            else:
                print(f"{Colors.FAIL}Invalid quality value. Choose: high, medium, low{Colors.ENDC}", flush=True)
                
    elif action == "backend":
        if len(parts) < 2:
            print(f"Current Backend: {config['ruffle_backend']}", flush=True)
        else:
            b = parts[1].lower()
            if b in ("vulkan", "dx12", "dx11", "gl", "default"):
                config["ruffle_backend"] = b
                save_config()
                print(f"{Colors.GREEN}Ruffle backend set to '{b}' in config.json.{Colors.ENDC}", flush=True)
            else:
                print(f"{Colors.FAIL}Invalid backend choice. Choose: vulkan, dx12, dx11, gl, default{Colors.ENDC}", flush=True)
                
    elif action == "audio":
        if len(parts) < 2:
            print(f"Current Audio Quality: {config.get('audio_quality', 'standard')}", flush=True)
            print("Valid Options: standard, high", flush=True)
        else:
            aq = parts[1].lower()
            if aq in ("standard", "high"):
                config["audio_quality"] = aq
                save_config()
                print(f"{Colors.GREEN}Audio quality set to '{aq}' in config.json.{Colors.ENDC}", flush=True)
            else:
                print(f"{Colors.FAIL}Invalid audio quality choice. Choose: standard, high{Colors.ENDC}", flush=True)
                
    elif action == "plat":
        if len(parts) < 2:
            print(f"Platinum purchases disabled: {config['disable_plat_purchase']}", flush=True)
        else:
            v = parts[1].lower()
            disable = v in ("disable", "off", "true")
            config["disable_plat_purchase"] = disable
            save_config()
            status_str = "DISABLED" if disable else "ENABLED"
            print(f"{Colors.GREEN}Platinum purchases are now {status_str}.{Colors.ENDC}", flush=True)
            
    elif action == "store-period":
        if len(parts) < 2:
            print(f"Current Store Period: {config['store_refresh_period_minutes']} minutes", flush=True)
        else:
            try:
                minutes = int(parts[1])
                if minutes < 1:
                    print(f"{Colors.FAIL}Minutes must be at least 1.{Colors.ENDC}", flush=True)
                else:
                    config["store_refresh_period_minutes"] = minutes
                    save_config()
                    force_vault_refresh = True
                    log_message(f"Store refresh period set to {minutes} minutes. Store refresh flag set.", "green")
                    print(f"{Colors.GREEN}Store period updated and vault reset queued.{Colors.ENDC}", flush=True)
            except ValueError:
                print(f"{Colors.FAIL}Invalid number of minutes.{Colors.ENDC}", flush=True)
                
    elif action == "refresh-store":
        force_vault_refresh = True
        log_message("Force store refresh triggered by launcher console.", "green")
        print(f"{Colors.GREEN}Vault refresh flagged. Store items will roll over on the client's next poll.{Colors.ENDC}", flush=True)
        
    elif action == "saves":
        saves_dir = os.path.join(DIR, "saves")
        if not os.path.exists(saves_dir):
            os.makedirs(saves_dir)
        print(f"Opening folder: {saves_dir}", flush=True)
        try:
            if sys.platform.startswith('win'):
                os.startfile(saves_dir)
            elif sys.platform.startswith('dar'):
                subprocess.Popen(["open", saves_dir])
            else:
                subprocess.Popen(["xdg-open", saves_dir])
        except Exception as e:
            print(f"Could not open directory automatically: {e}", flush=True)
            
    elif action == "check-saves":
        check_saves()
        
    elif action == "diagnostics":
        run_diagnostics()
        
    elif action == "update":
        force = False
        if len(parts) >= 2 and parts[1].lower() == "force":
            force = True
        print(f"{Colors.YELLOW}Triggering system update from interactive terminal...{Colors.ENDC}", flush=True)
        update_script = os.path.join(DIR, "update.py")
        if os.path.exists(update_script):
            cmd = [sys.executable, update_script, "--game-dir", DIR, "--silent"]
            if force:
                cmd.append("--force")
            
            if sys.platform.startswith("win"):
                subprocess.Popen(cmd, creationflags=subprocess.CREATE_NEW_CONSOLE)
            else:
                subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True)
            shutdown_server()
        else:
            print(f"{Colors.FAIL}Error: update.py not found in game directory.{Colors.ENDC}", flush=True)
            
    elif action == "multiplayer":
        if len(parts) < 2:
            print(f"Current Multiplayer Mode: {config.get('multiplayer_mode', 'local')}", flush=True)
        else:
            m = parts[1].lower()
            if m in ("local", "lan"):
                config["multiplayer_mode"] = m
                save_config()
                print(f"{Colors.GREEN}Multiplayer mode set to '{m}' in config.json.{Colors.ENDC}", flush=True)
            else:
                print(f"{Colors.FAIL}Invalid multiplayer mode choice. Choose: local, lan{Colors.ENDC}", flush=True)
                
    elif action == "cpu-bot":
        if len(parts) < 2:
            print(f"CPU Bot enabled: {config.get('cpu_bot_enabled', True)}", flush=True)
        else:
            val = parts[1].lower()
            enabled = val in ("on", "true", "enabled")
            config["cpu_bot_enabled"] = enabled
            save_config()
            status_str = "ENABLED" if enabled else "DISABLED"
            print(f"{Colors.GREEN}CPU Bot matchmaking is now {status_str}.{Colors.ENDC}", flush=True)
            
    elif action == "peer":
        if len(parts) < 2:
            print(f"Current P2P Peer Target: '{config.get('peer_target', '')}'", flush=True)
        else:
            target = parts[1]
            if target.lower() in ("clear", "none", "off", "empty"):
                target = ""
            config["peer_target"] = target
            save_config()
            if target:
                print(f"{Colors.GREEN}P2P Peer Target set to '{target}' in config.json.{Colors.ENDC}", flush=True)
            else:
                print(f"{Colors.GREEN}P2P Peer Target cleared in config.json.{Colors.ENDC}", flush=True)
                
    elif action == "shutdown":
        shutdown_server()
        
    else:
        print(f"Unknown command: '{action}'. Type 'help' for options.", flush=True)

# Shutdown helper
def shutdown_server():
    global game_instances, shutdown_event
    log_message("Shutting down HTTP server...", "red")
    for inst in game_instances:
        try:
            inst["process"].kill()
            log_message(f"Killed game instance PID {inst['process'].pid}", "yellow")
        except Exception:
            pass
    shutdown_event.set()
    # Force process exit to stop threads and TCPServer
    os._exit(0)

# Monitoring game processes for cleanups and auto-shutdown
def monitor_instances():
    global game_instances, autoshutdown_active
    while not shutdown_event.is_set():
        time.sleep(1.0)
        exited = []
        for inst in game_instances:
            if inst["process"] and inst["process"].poll() is not None:
                exit_code = inst["process"].poll()
                duration = time.time() - inst.get("start_timestamp", 0.0)
                log_message(f"Game Instance {inst['id']} (PID {inst['process'].pid}) has closed (Exit Code: {exit_code}).", "yellow")
                
                # Check for quick crash (within 3 seconds) on Linux/WSL
                if duration < 3.0 and not sys.platform.startswith('win'):
                    log_err_path = os.path.join(DIR, "game_error.log")
                    if os.path.exists(log_err_path):
                        try:
                            with open(log_err_path, "r", encoding="utf-8-sig") as f:
                                err_content = f.read().strip()
                            if err_content:
                                print(f"\n{Colors.FAIL}=== GAME PROCESS ERROR LOG ==={Colors.ENDC}", flush=True)
                                print(err_content, flush=True)
                                print(f"{Colors.FAIL}=============================={Colors.ENDC}\n", flush=True)
                                
                                # Check for common library errors
                                if "libgtk-x11" in err_content or "libnss3" in err_content or "libnspr4" in err_content:
                                    print(f"{Colors.YELLOW}Troubleshooting Tip:{Colors.ENDC}", flush=True)
                                    print("It looks like you are missing required GTK or NSS shared libraries.", flush=True)
                                    print("Please run one of the following commands to install them:", flush=True)
                                    print("  - Debian/Ubuntu/Mint:  sudo apt install -y libgtk2.0-0 libnss3 libnspr4", flush=True)
                                    print("  - Arch Linux/Manjaro:  sudo pacman -S --needed gtk2 nss", flush=True)
                                    print("  - Fedora/RedHat:       sudo dnf install -y gtk2 nss", flush=True)
                                    print("", flush=True)
                                elif "cannot open display" in err_content.lower():
                                    print(f"{Colors.YELLOW}Troubleshooting Tip:{Colors.ENDC}", flush=True)
                                    print("It looks like the player could not connect to a display server.", flush=True)
                                    print("If you are running in WSL/WSL2, make sure you have WSLg active or an X server running on Windows.", flush=True)
                                    print("You can also launch the game in Web Browser mode [3] to run it natively on your Windows host.", flush=True)
                                    print("", flush=True)
                        except Exception:
                            pass
                
                exited.append(inst)
                
        if exited:
            game_instances = [i for i in game_instances if i not in exited]
            # If all instances exited, start the 5-sec countdown
            if not game_instances:
                autoshutdown_active = True
                print("\nAll game instances have closed. Server will auto-shutdown in 5 seconds.", flush=True)
                print("Press Enter or type any command to cancel countdown and open console.", flush=True)
                for sec in range(5, 0, -1):
                    if not autoshutdown_active:
                        break
                    print(f"{sec}... ", end="", flush=True)
                    # Check for keypress during sleep interval responsively
                    for _ in range(10):
                        if not autoshutdown_active or is_key_pressed():
                            autoshutdown_active = False
                            break
                        time.sleep(0.1)
                print("")
                if autoshutdown_active:
                    shutdown_server()
                else:
                    print("Auto-shutdown cancelled. Console opened.", flush=True)

# Setup clean log.txt on start
def setup_log():
    log_path = os.path.join(DIR, "log.txt")
    if os.path.exists(log_path):
        try:
            os.remove(log_path)
        except Exception:
            pass
    log_message("=========================================", "green")
    log_message(f"   OE3 Offline Server Starting ({VERSION})...", "green")
    log_message(f"   Serving from: {DIR}", "cyan")
    log_message("=========================================", "green")

# Main Boot Sequence
def main():
    global port, autoshutdown_active
    setup_log()
    load_config()
    
    # Save files migration
    saves_dir = os.path.join(DIR, "saves")
    if not os.path.exists(saves_dir):
        os.makedirs(saves_dir)
    for filename in os.listdir(DIR):
        if filename.startswith("save_") and filename.endswith(".json"):
            src = os.path.join(DIR, filename)
            dest = os.path.join(saves_dir, filename)
            try:
                if not os.path.exists(dest):
                    log_message(f"Migrating save file: {filename} -> saves/", "cyan")
                    shutil.move(src, dest)
                else:
                    os.remove(src)
            except Exception as e:
                log_message(f"Error migrating saves: {e}", "yellow")

    # Start HTTP listener with port conflict checking
    max_tries = 20
    httpd = None
    for i in range(max_tries):
        current_port = port + i
        log_message(f"Checking port conflict for port {current_port}...", "gray")
        try:
            httpd = socketserver.ThreadingTCPServer(("127.0.0.1", current_port), OE3HTTPRequestHandler)
            port = current_port
            break
        except OSError:
            log_message(f"Port {current_port} is currently in use. Checking next...", "yellow")
            continue
            
    if not httpd:
        log_message("ERROR: Could not find any available loopback port to bind loopback listener.", "red")
        sys.exit(1)
        
    log_message(f"HTTP Server successfully started and listening at http://127.0.0.1:{port}/", "green")

    # Start HTTP serving thread
    server_thread = threading.Thread(target=httpd.serve_forever, daemon=True)
    server_thread.start()

    # Start instances monitor thread
    monitor_thread = threading.Thread(target=monitor_instances, daemon=True)
    monitor_thread.start()

    # Launch first instance
    launch_game()

    # Interactive CLI Input Loop
    print("\nServer running. Keep this window open while playing.", flush=True)
    print("Type commands directly below. Type 'help' for command list.\n", flush=True)
    
    while not shutdown_event.is_set():
        try:
            line = input("Console> ").strip()
            if autoshutdown_active:
                autoshutdown_active = False
                print("Auto-shutdown cancelled.", flush=True)
                continue
            if not line:
                continue
            execute_command(line)
        except (KeyboardInterrupt, EOFError):
            execute_command("shutdown")
            break

# ================================================================================
#                     MULTIPLAYER LOBBY & TICKS COORDINATOR (LAN / P2P)
# ================================================================================
import urllib.request

mp_lock = threading.Lock()
match_queue = []
active_rooms = {}

def update_player_stats(user, won):
    user_safe = re.sub(r'[^a-zA-Z0-9_\-]', '', user)
    if not user_safe:
        user_safe = "GuestPlayer"
        
    saves_dir = os.path.join(DIR, "saves")
    save_file = os.path.join(saves_dir, f"save_{user_safe}.json")
    
    if not os.path.exists(save_file):
        save_file = os.path.join(DIR, f"save_{user_safe}.json")
        
    if os.path.exists(save_file):
        try:
            with open(save_file, "r", encoding="utf-8-sig") as f:
                data = json.load(f)
                
            if "wins" not in data: data["wins"] = 0
            if "losses" not in data: data["losses"] = 0
            if "rating" not in data: data["rating"] = 1000
            
            if won:
                data["wins"] += 1
                data["rating"] += 15
            else:
                data["losses"] += 1
                data["rating"] -= 10
                if data["rating"] < 1000:
                    data["rating"] = 1000
                    
            with open(save_file, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2)
                
            log_message(f"Updated rating stats for {user_safe}: Won={won}, Rating={data['rating']}", "green")
        except Exception as e:
            log_message(f"Error updating stats in save file: {e}", "red")

def handle_multiplayer_proxy(handler, path, method, query, body=None):
    peer = config.get("peer_target", "")
    if not peer:
        return False
        
    url = f"http://{peer}/{path}"
    if query:
        q_str = urllib.parse.urlencode(query, doseq=True)
        url += f"?{q_str}"
        
    log_message(f"Proxying multiplayer request to peer: {method} {url}", "cyan")
    
    try:
        req = urllib.request.Request(url, method=method)
        if body:
            req.data = body
            req.add_header("Content-Type", "application/json")
            
        with urllib.request.urlopen(req, timeout=15) as res:
            res_body = res.read()
            
            # If gameover succeeded, update our local stats
            if path == 'multiplayer/game/gameover' and res.status == 200:
                try:
                    res_data = json.loads(res_body.decode('utf-8'))
                    if res_data.get("status") == "ok":
                        my_result = res_data.get("myResult", 0)
                        user = query.get("user", [""])[0] or (json.loads(body.decode('utf-8')).get("user", "") if body else "")
                        update_player_stats(user, my_result == 1)
                except Exception as ex:
                    log_message(f"Error updating local stats after proxy gameover: {ex}", "red")
            
            handler.send_response(res.status)
            for k, v in res.getheaders():
                if k.lower() not in ("content-length", "transfer-encoding", "connection"):
                    handler.send_header(k, v)
            handler.send_header("Content-Length", str(len(res_body)))
            handler.end_headers()
            handler.wfile.write(res_body)
            return True
    except Exception as e:
        log_message(f"Failed to proxy to peer: {e}", "red")
        handler.send_json_response(502, {"status": "error", "reason": f"Peer server offline: {e}"})
        return True

def handle_multiplayer_match(handler, query):
    global match_queue
    user = query.get("user", [""])[0]
    rating = int(query.get("rating", [1000])[0])
    
    with mp_lock:
        # Check if user is already waiting
        for entry in match_queue:
            if entry["user"] == user:
                condition = entry["condition"]
                break
        else:
            if len(match_queue) > 0:
                peer_entry = match_queue.pop(0)
                room_id = f"room_{int(time.time()*1000)}_{random.randint(100, 999)}"
                
                peer_entry["result"] = {"roomId": room_id, "role": 1}
                peer_entry["condition"].notify_all()
                
                handler.send_json_response(200, {"roomId": room_id, "role": 2})
                log_message(f"Matchmaker: Paired {peer_entry['user']} (P1) and {user} (P2) in room {room_id}", "green")
                return
            else:
                condition = threading.Condition(mp_lock)
                entry = {
                    "user": user,
                    "rating": rating,
                    "condition": condition,
                    "result": None
                }
                match_queue.append(entry)
                
        success = condition.wait(timeout=25.0)
        if not success or entry["result"] is None:
            if entry in match_queue:
                match_queue.remove(entry)
            handler.send_json_response(200, {"roomId": "", "role": 0, "status": "timeout"})
            log_message(f"Matchmaker: Timeout waiting for opponent for {user}", "yellow")
        else:
            handler.send_json_response(200, entry["result"])

def handle_game_start_info(handler, body_json):
    global active_rooms
    room_id = body_json.get("roomId")
    user = body_json.get("user")
    rating = body_json.get("rating", 1000)
    armory = body_json.get("armory", [])
    
    with mp_lock:
        if room_id not in active_rooms:
            active_rooms[room_id] = {
                "players": [],
                "start_condition": threading.Condition(mp_lock),
                "go_condition": threading.Condition(mp_lock),
                "level_index": None,
                "readies": set(),
                "logins": set(),
                "ticks": {},
                "tick_conditions": {},
                "gameover": {},
                "gameover_condition": threading.Condition(mp_lock),
                "aborted": False
            }
        room = active_rooms[room_id]
        
        player_exists = False
        for p in room["players"]:
            if p["user"] == user:
                player_exists = True
                p["rating"] = rating
                p["armory"] = armory
                break
        if not player_exists:
            room["players"].append({
                "user": user,
                "rating": rating,
                "armory": armory
            })
            
        if len(room["players"]) == 2:
            room["start_condition"].notify_all()
        else:
            room["start_condition"].wait(timeout=25.0)
            
        if len(room["players"]) < 2:
            handler.send_json_response(200, {"status": "aborted", "reason": "timeout_waiting_for_peer"})
            return
            
        players = room["players"]
        role = 1 if user == players[0]["user"] else 2
        
        response_data = {
            "role": role,
            "player1": {
                "name": players[0]["user"],
                "rating": players[0]["rating"],
                "armory": players[0]["armory"]
            },
            "player2": {
                "name": players[1]["user"],
                "rating": players[1]["rating"],
                "armory": players[1]["armory"]
            }
        }
        handler.send_json_response(200, response_data)

def handle_game_ready(handler, query):
    room_id = query.get("roomId", [""])[0]
    user = query.get("user", [""])[0]
    
    with mp_lock:
        room = active_rooms.get(room_id)
        if room:
            room["readies"].add(user)
            
    handler.send_json_response(200, {"status": "ok"})

def handle_game_go(handler, query):
    room_id = query.get("roomId", [""])[0]
    user = query.get("user", [""])[0]
    
    with mp_lock:
        room = active_rooms.get(room_id)
        if not room:
            handler.send_json_response(400, {"status": "error", "reason": "Room not found"})
            return
            
        room["logins"].add(user)
        if len(room["logins"]) == 2:
            room["level_index"] = random.randint(0, 4)
            room["go_condition"].notify_all()
        else:
            room["go_condition"].wait(timeout=25.0)
            
        if room["level_index"] is None:
            handler.send_json_response(200, {"status": "error", "reason": "timeout"})
        else:
            handler.send_json_response(200, {"status": "ok", "levelIndex": room["level_index"]})

def handle_game_checkin(handler, body_json):
    room_id = body_json.get("roomId")
    user = body_json.get("user")
    move0 = body_json.get("move0", 0)
    move1 = body_json.get("move1", 0)
    move2 = body_json.get("move2", 0)
    hash_val = body_json.get("hash", 0)
    
    with mp_lock:
        room = active_rooms.get(room_id)
        if not room or room.get("aborted", False):
            handler.send_json_response(200, {"status": "aborted", "reason": "room_closed"})
            return
            
        p_idx = -1
        for idx, p in enumerate(room["players"]):
            if p["user"] == user:
                p_idx = idx
                break
                
        if p_idx == -1:
            handler.send_json_response(200, {"status": "aborted", "reason": "not_in_room"})
            return
            
        if "player_moves" not in room:
            room["player_moves"] = [[], []]
            
        my_moves = room["player_moves"][p_idx]
        my_moves.append([move0, move1, move2, hash_val])
        t = len(my_moves) - 1
        
        peer_idx = 1 - p_idx
        peer_moves = room["player_moves"][peer_idx]
        
        if t not in room["tick_conditions"]:
            room["tick_conditions"][t] = threading.Condition(mp_lock)
            
        if len(peer_moves) > t:
            room["tick_conditions"][t].notify_all()
        else:
            success = room["tick_conditions"][t].wait(timeout=15.0)
            if not success or len(peer_moves) <= t or room.get("aborted", False):
                room["aborted"] = True
                handler.send_json_response(200, {"status": "aborted", "reason": "peer_timeout"})
                return
                
        p1_move = room["player_moves"][0][t]
        p2_move = room["player_moves"][1][t]
        
        response_data = {
            "status": "ok",
            "clock": t + 1,
            "moves": [p1_move[0], p1_move[1], p1_move[2], p2_move[0], p2_move[1], p2_move[2]]
        }
        handler.send_json_response(200, response_data)

def handle_game_gameover(handler, body_json):
    room_id = body_json.get("roomId")
    user = body_json.get("user")
    results = body_json.get("results", [0, 0])
    
    with mp_lock:
        room = active_rooms.get(room_id)
        if not room:
            handler.send_json_response(400, {"status": "error", "reason": "Room not found"})
            return
            
        room["gameover"][user] = results
        
        if len(room["gameover"]) == 2:
            room["gameover_condition"].notify_all()
        else:
            room["gameover_condition"].wait(timeout=10.0)
            
        p_idx = -1
        for idx, p in enumerate(room["players"]):
            if p["user"] == user:
                p_idx = idx
                break
                
        p1_alive = results[0]
        p2_alive = results[1]
        
        my_alive = p1_alive if p_idx == 0 else p2_alive
        won = (my_alive == 1)
        
        update_player_stats(user, won)
        
        if user == room["players"][-1]["user"]:
            def cleanup():
                time.sleep(5)
                with mp_lock:
                    if room_id in active_rooms:
                        del active_rooms[room_id]
            threading.Thread(target=cleanup).start()
            
        handler.send_json_response(200, {"status": "ok", "myResult": 1 if won else 0})

if __name__ == "__main__":
    main()
