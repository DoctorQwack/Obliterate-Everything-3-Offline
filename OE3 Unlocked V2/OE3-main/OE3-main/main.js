const { app, BrowserWindow, Menu } = require('electron');
const path = require('path');

function createWindow() {
	const win = new BrowserWindow({
		width: 820,
		height: 650,
		useContentSize: true,
		resizable: false,
		maximizable: false,
		title: "Obliterate Everything 3 - Offline Edition",
		backgroundColor: "#0b0c10",
		webPreferences: {
			nodeIntegration: false,
			contextIsolation: true,
			webSecurity: false // Disables CORS checks so Ruffle can load local WASM & SWF files
		}
	});

	// Hide the default menu bar (File, Edit, etc.) for a clean game look
	Menu.setApplicationMenu(null);
	win.setMenuBarVisibility(false);

	win.loadFile('index.html');
}

// Enable WebGL and GPU acceleration flags
app.commandLine.appendSwitch('ignore-gpu-blacklist');
app.commandLine.appendSwitch('enable-gpu-rasterization');

app.whenReady().then(() => {
	createWindow();

	app.on('activate', () => {
		if (BrowserWindow.getAllWindows().length === 0) {
			createWindow();
		}
	});
});

app.on('window-all-closed', () => {
	if (process.platform !== 'darwin') {
		app.quit();
	}
});
