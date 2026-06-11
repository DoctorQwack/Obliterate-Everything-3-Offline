# Obliterate Everything 3 - Offline Edition

A fully-featured, standalone offline player wrapper and mock server emulator for **Obliterate Everything 3 (OE3)**. Enjoy the full campaign, unlock achievements, buy items from the vault and packs shop, and customize your fleet with zero network dependencies.

---

## Key Features

- **Local Profiles & Save Files**: All progress is automatically stored in standard JSON format in the `saves/` folder.
- **Direct Login by Callsign**: Log in using your readable Kongregate username (case-insensitively!) instead of the numeric ID key (e.g. typing `CristianoP5` or `cristianop5` directly on the login screen).
- **Legacy Save Converter**: Convert old online saves to the new offline format using a cybernetic Web UI.
- **Working Store & Item Packs**: Access the shop vault and themed item packs using free, offline-earned Credits and Platinum.
- **Configurable Store Refresh Period**: Change the store refresh frequency from hourly to whatever you prefer using the console.
- **Interactive CLI Console**: Manage game windows, force store refreshes, toggle platinum purchasing, list running processes, and analyze save file health directly from the terminal.
- **Multiple Launch Modes**: Run the game in your choice of:
  - **Flash Player Projector** (Native desktop, recommended for maximum performance)
  - **Ruffle Desktop Player** (Fully offline emulator with GPU hardware rendering support)
  - **Default Web Browser** (Powered by Ruffle WebAssembly)
- **Multi-Instance Support**: Launch multiple client windows simultaneously connected to the same local server.
- **Auto-Shutdown Grace Period**: Detection when all game clients close, triggering a 5-second countdown to shut down the server automatically (press any key to cancel and open the console).

---

## Installation & Running Recommendations

### System Requirements
- **OS**: Windows (PowerShell 5.1 or higher)
- **Local Assets**: Keep the directory structure intact so the server can locate `flashplayer.exe`, `ruffle.exe`, and Ruffle WebAssembly assets.

### Quick Start
1. **Download & Extract**: Download the latest release ZIP from the [Releases](https://github.com/DoctorQwack/Obliterate-Everything-3-Offline/releases) page and extract it.
   - **`OE3_Offline_Release.zip`** (Standard version): Clean, lightweight (under 30MB) package for offline gameplay.
   - **`OE3_Offline_Release_Legacy_Saves_Included.zip`** (Legacy Save version): Includes the Save Converter, search index, and the raw online database files for users migrating online profiles.
2. **Launch the Game**: Double-click **`Launch OE3 Offline.bat`** (located in the extracted folder).
3. **Select Player Mode**: Choose your preferred graphics/engine launch option (Standalone Flash Player is highly recommended for best performance). You can choose `y` to remember this choice for future runs.
4. **Log In**: 
   - Click **Start** once the player loads.
   - Enter any desired username into the text box.
   - Click **Login** (no passwords or signup required).

> [!TIP]
> To log out or switch user profiles, click the red **LOGOUT** button in the top-right corner of the screen in-game, or type `logout` in the server terminal window.

---

## Legacy Save Converter & Online Migration

If you played the original online version on Kongregate, you can restore your progress using the built-in save conversion pipeline:

1. **Open the Converter**: Click the **Save Converter** link in the top-right corner of the launcher web page, choose Option `[5] Web Save Converter` when booting the launcher, or type `converter` in the server console.
2. **Search Your Account**: You can search by your readable Kongregate username (callsign) or your numeric user ID. The pre-bundled index contains all **107,744** online accounts.
3. **Import to Launcher**:
   - Select your profile and click **Convert Save**.
   - Review your profile stats, inventory grid, and equipped items in the preview dashboard.
   - Click the **Import to Launcher** button to automatically copy the converted JSON profile to the active `saves/` folder on your disk.
   - Alternatively, click **Download Save File** to download the `save_[Username].json` file to share or distribute.
4. **Log In Case-Insensitively**: Close the converter, return to the game login page, and log in typing your readable username (case-insensitively). The launcher resolves the save path and preserves your original name casing in-game!

*Note: If using the Standard release version, you must copy your legacy database backup JSON (`oe3_PlayerObjects_Default_*.json`) inside a folder named `Legacy Save Files` next to the launcher bat script for conversion to run.*

---

## Interactive Console Commands

To input commands, click on the running server terminal window and press **ANY KEY** (except `Ctrl+C`). Type your command and press **Enter**. To return to background logging mode, type `exit` or `resume`.

| Command | Usage | Description |
|:---|:---|:---|
| **`help`** | `help` | Displays a list of all available commands and brief descriptions. |
| **`launch`** | `launch` | Starts another game client window connected to the same local server. |
| **`instances`** | `instances` | Lists all active client windows, including their Instance IDs and Process IDs (PIDs). |
| **`close`** | `close <id>` | Closes a specific client instance (e.g. `close 2`). |
| **`logout`** | `logout` | Pushes a logout instruction, instantly returning all clients to the login page. |
| **`store-period`** | `store-period <min>` | Sets a custom store refresh cycle in minutes (e.g. `store-period 30`) and refreshes vault items. |
| **`refresh-store`**| `refresh-store` | Instantly regenerates shop items with a unique randomized seed. |
| **`plat`** / **`platt`** | `plat <on/off>` | Enables or disables the in-game platinum purchasing buttons. |
| **`saves`** | `saves` | Opens the local `saves/` directory in Windows Explorer. |
| **`check-saves`** | `check-saves` | Scans all user save files on disk and checks them for structural integrity. |
| **`converter`** | `converter` | Opens the legacy save converter web interface in your default browser. |
| **`logs`** | `logs` | Outputs the last 20 log entries from the server. |
| **`config`** | `config` | Displays current active launcher configuration parameters. |
| **`diagnostics`** | `diagnostics` | Runs a system health check verifying port bindings and folder assets. |
| **`shutdown`** | `shutdown` | Gracefully closes all game windows, stops the server, and exits. |

---

## Configuration (`config.json`)

Your choices are saved in **`config.json`** inside the folder. Missing config keys are automatically populated with standard defaults on boot.

- **`launch_mode`**: `"ask"` (always prompt), `"flashplayer"`, `"ruffle"`, `"browser"`, `"converter"`, or `"auto"` (fallback list).
- **`remember_mode`**: `true` or `false` (skips start menu if launch mode is remembered).
- **`ruffle_backend`**: Graphics API backend for Ruffle Desktop (`"dx12"`, `"vulkan"`, `"dx11"`, `"gl"`, or `"default"`).
- **`default_quality`**: Graphics quality setting (`"high"`, `"medium"`, `"low"`).
- **`disable_plat_purchase`**: `true` or `false` (disables in-game Platinum purchases if set to `true`).
- **`store_refresh_period_minutes`**: Vault rollover period in minutes (defaults to `60`).

---

## Building / Modifying Source SWF

If you are modifying client-side files (`OfflineServer.as`, `BaseScreen.as`, `Library.as`, etc.) in Adobe Animate/Flash:

1. Open **`OE3 Unlocked V2\OE3-main\OE3-main\OE3.fla`** in Adobe Animate.
2. Compile the project by pressing <kbd>Ctrl</kbd> + <kbd>Enter</kbd>.
3. Run the script **`Update Offline SWF.bat`** in the root workspace folder to copy and deploy the newly built SWF directly to the standalone player directory.
