import os
import sys
import json
import urllib.request
import tempfile
import shutil
import time
import zipfile
import subprocess

def get_current_version(game_dir):
    server_file = os.path.join(game_dir, "server.py")
    if os.path.exists(server_file):
        try:
            with open(server_file, "r", encoding="utf-8-sig") as f:
                for line in f:
                    if "VERSION =" in line:
                        parts = line.split("=")
                        if len(parts) >= 2:
                            return parts[1].strip().strip('"').strip("'")
        except Exception:
            pass
    return "v0.0_Beta"

def main():
    import argparse
    parser = argparse.ArgumentParser(description="OE3 Offline Updater")
    parser.add_argument("--game-dir", default=None, help="Path to the game directory")
    parser.add_argument("--force", action="store_true", help="Force update even if up to date")
    parser.add_argument("--silent", action="store_true", help="Run in non-interactive/silent mode")
    args = parser.parse_args()

    # Determine paths
    self_path = os.path.abspath(__file__)
    self_dir = os.path.dirname(self_path)
    temp_dir = tempfile.gettempdir()

    # If --game-dir is not specified, default to the directory of this script
    game_dir = args.game_dir
    if not game_dir:
        game_dir = self_dir
    game_dir = os.path.abspath(game_dir)

    is_temp_run = (self_dir.lower() == temp_dir.lower())

    if not is_temp_run:
        # Running from game directory. Check for updates first.
        print("Checking for updates...", flush=True)
        current_version = get_current_version(game_dir)
        api_url = "https://api.github.com/repos/DoctorQwack/Obliterate-Everything-3-Offline/releases/latest"
        
        try:
            req = urllib.request.Request(api_url, headers={"User-Agent": "OE3-Updater"})
            with urllib.request.urlopen(req, timeout=10) as response:
                res = json.loads(response.read().decode("utf-8"))
        except Exception as e:
            print(f"Failed to query GitHub API: {e}", flush=True)
            if not args.silent:
                input("Press Enter to exit...")
            sys.exit(1)

        latest_version = res["tag_name"]
        print(f"Current version: {current_version}", flush=True)
        print(f"Latest version:  {latest_version}", flush=True)

        force_update = False
        if current_version == latest_version:
            print("You are already up to date!", flush=True)
            if args.silent:
                if not args.force:
                    print("Exiting updater (already up to date).", flush=True)
                    sys.exit(0)
                force_update = True
            else:
                choice = input("Do you want to re-install/force update anyway? (y/n): ").strip().lower()
                if choice != "y":
                    sys.exit(0)
                force_update = True
        else:
            print(f"New version {latest_version} is available!", flush=True)
            if not args.silent:
                choice = input("Do you want to download and install this update? (y/n, default y): ").strip().lower()
                if choice == "n":
                    sys.exit(0)

        # Relocate self to temp folder to avoid locks
        print("\nRelocating updater to temporary directory to prevent file locks...", flush=True)
        temp_script = os.path.join(temp_dir, "oe3_update.py")
        shutil.copy2(self_path, temp_script)

        # Launch background process and exit
        cmd = [sys.executable, temp_script, "--game-dir", game_dir, "--silent"]
        if force_update or args.force:
            cmd.append("--force")
        
        # Start background process detached
        if sys.platform.startswith("win"):
            subprocess.Popen(cmd, creationflags=subprocess.CREATE_NEW_CONSOLE)
        else:
            subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True)
        
        sys.exit(0)

    # --- RUNNING FROM TEMP DIRECTORY ---
    print("=========================================", flush=True)
    print("    OE3 Offline Updater (Running)        ", flush=True)
    print("=========================================", flush=True)
    print(f"Game Directory: {game_dir}", flush=True)
    print("\nPlease close the game server (terminal window) and the game window if open.", flush=True)
    print("Waiting for running instances to close...", flush=True)

    test_files = ["server.py", "server.ps1", "Launch OE3 Offline.bat", "OE3_UPDATED.swf", "flashplayer.exe", "ruffle.exe", "flashplayer"]
    while True:
        locked = False
        for tf in test_files:
            p = os.path.join(game_dir, tf)
            if os.path.exists(p):
                try:
                    with open(p, "a"):
                        pass
                except IOError:
                    locked = True
                    break
        if not locked:
            break
        print(".", end="", flush=True)
        time.sleep(1.0)
    
    print("\nAll instances closed. Proceeding with update.", flush=True)

    # Fetch latest release details
    api_url = "https://api.github.com/repos/DoctorQwack/Obliterate-Everything-3-Offline/releases/latest"
    try:
        req = urllib.request.Request(api_url, headers={"User-Agent": "OE3-Updater"})
        with urllib.request.urlopen(req, timeout=10) as response:
            res = json.loads(response.read().decode("utf-8"))
    except Exception as e:
        print(f"Failed to query GitHub API: {e}", flush=True)
        if not args.silent:
            input("Press Enter to exit...")
        sys.exit(1)

    latest_version = res["tag_name"]
    is_legacy_edition = os.path.exists(os.path.join(game_dir, "converter.html"))

    download_url = None
    filename = None
    for asset in res.get("assets", []):
        name = asset.get("name", "")
        if is_legacy_edition:
            if "Legacy_Saves_Included.zip" in name:
                download_url = asset.get("browser_download_url")
                filename = name
                break
        else:
            if "Release.zip" in name and "Legacy_Saves_Included.zip" not in name:
                download_url = asset.get("browser_download_url")
                filename = name
                break

    if not download_url and res.get("assets"):
        download_url = res["assets"][0]["browser_download_url"]
        filename = res["assets"][0]["name"]

    if not download_url:
        print("Error: No download assets found in latest release.", flush=True)
        if not args.silent:
            input("Press Enter to exit...")
        sys.exit(1)

    print(f"Downloading: {filename}...", flush=True)
    temp_zip = os.path.join(temp_dir, filename)
    if os.path.exists(temp_zip):
        try:
            os.remove(temp_zip)
        except Exception:
            pass

    try:
        urllib.request.urlretrieve(download_url, temp_zip)
    except Exception as e:
        print(f"Failed to download update: {e}", flush=True)
        if not args.silent:
            input("Press Enter to exit...")
        sys.exit(1)

    print("Extracting update package...", flush=True)
    temp_extract = os.path.join(temp_dir, "oe3_extract")
    if os.path.exists(temp_extract):
        try:
            shutil.rmtree(temp_extract)
        except Exception:
            pass
    os.makedirs(temp_extract, exist_ok=True)

    try:
        with zipfile.ZipFile(temp_zip, 'r') as zip_ref:
            zip_ref.extractall(temp_extract)
    except Exception as e:
        print(f"Failed to extract update package: {e}", flush=True)
        if not args.silent:
            input("Press Enter to exit...")
        sys.exit(1)

    print("Applying update files...", flush=True)
    for root, dirs, files in os.walk(temp_extract):
        for name in files:
            src_file = os.path.join(root, name)
            rel_path = os.path.relpath(src_file, temp_extract)
            
            parts = rel_path.replace("\\", "/").split("/")
            if "saves" in parts or rel_path.lower() == "config.json":
                continue
                
            dest_file = os.path.join(game_dir, rel_path)
            os.makedirs(os.path.dirname(dest_file), exist_ok=True)
            try:
                shutil.copy2(src_file, dest_file)
            except Exception as e:
                print(f"Warning: Failed to copy {rel_path}: {e}", flush=True)

    # Clean up temp files
    try:
        os.remove(temp_zip)
    except Exception:
        pass
    try:
        shutil.rmtree(temp_extract)
    except Exception:
        pass
    try:
        os.remove(self_path)
    except Exception:
        pass

    print(f"\nSUCCESS! Obliterate Everything 3 has been updated to {latest_version}!", flush=True)
    print("Restarting game launcher...", flush=True)
    time.sleep(2.0)

    # Relaunch the launcher
    if sys.platform.startswith("win"):
        bat_file = os.path.join(game_dir, "Launch OE3 Offline.bat")
        subprocess.Popen(["cmd.exe", "/c", bat_file], cwd=game_dir)
    else:
        sh_file = os.path.join(game_dir, "launch.sh")
        if os.path.exists(sh_file):
            subprocess.Popen(["bash", sh_file], cwd=game_dir)
        else:
            subprocess.Popen(["python3", "server.py"], cwd=game_dir)

    sys.exit(0)

if __name__ == "__main__":
    main()
