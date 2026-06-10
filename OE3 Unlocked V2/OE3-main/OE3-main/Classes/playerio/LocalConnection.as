package playerio {
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	public class LocalConnection implements Connection {
		private var _roomId:String;
		private var _roomType:String;
		private var _connected:Boolean;
		private var _handlers:Dictionary; // Dictionary of Array of Functions
		private var _disconnectHandlers:Array;

		public function LocalConnection(roomId:String, roomType:String) {
			this._roomId = roomId;
			this._roomType = roomType;
			this._connected = true;
			this._handlers = new Dictionary();
			this._disconnectHandlers = [];
		}

		public function addMessageHandler(type:String, handler:Function):void {
			if (!_handlers[type]) {
				_handlers[type] = [];
			}
			_handlers[type].push(handler);
		}

		public function removeMessageHandler(type:String, handler:Function):void {
			var list:Array = _handlers[type];
			if (list) {
				var idx:int = list.indexOf(handler);
				if (idx != -1) {
					list.splice(idx, 1);
				}
			}
		}

		public function addDisconnectHandler(handler:Function):void {
			_disconnectHandlers.push(handler);
		}

		public function removeDisconnectHandler(handler:Function):void {
			var idx:int = _disconnectHandlers.indexOf(handler);
			if (idx != -1) {
				_disconnectHandlers.splice(idx, 1);
			}
		}

		public function get connected():Boolean {
			return _connected;
		}

		public function createMessage(type:String, ...args:Array):Message {
			var msg:LocalMessage = new LocalMessage(type);
			for (var i:int = 0; i < args.length; i++) {
				msg.add(args[i]);
			}
			return msg;
		}

		public function send(type:String, ...args:Array):void {
			var msg:LocalMessage = new LocalMessage(type);
			for (var i:int = 0; i < args.length; i++) {
				msg.add(args[i]);
			}
			sendMessage(msg);
		}

		public function sendMessage(message:Message):void {
			if (!_connected) return;
			var self:LocalConnection = this;
			setTimeout(function():void {
				if (self.connected) {
					OfflineServer.getInstance().handleIncomingMessage(self, message);
				}
			}, 10);
		}

		public function disconnect():void {
			if (_connected) {
				_connected = false;
				// Notify server side that user left
				OfflineServer.getInstance().handleClientDisconnect(this);
			}
		}

		// --- Methods called by the Offline Server simulator ---
		
		public function get roomId():String {
			return _roomId;
		}

		public function get roomType():String {
			return _roomType;
		}

		/**
		 * Invokes registered message handlers on the client for a message received from the server.
		 */
		public function receiveFromServer(message:Message):void {
			if (!_connected) return;

			var type:String = message.type;
			
			// 1. Invoke type-specific handlers
			var list:Array = _handlers[type];
			if (list) {
				// Make a copy to avoid modification during execution
				var listCopy:Array = list.concat();
				for (var i:int = 0; i < listCopy.length; i++) {
					var handler:Function = listCopy[i];
					invokeHandler(handler, message);
				}
			}

			// 2. Invoke wildcard handlers
			var wildcards:Array = _handlers["*"];
			if (wildcards) {
				var wildcardsCopy:Array = wildcards.concat();
				for (var j:int = 0; j < wildcardsCopy.length; j++) {
					var wildcardHandler:Function = wildcardsCopy[j];
					invokeHandler(wildcardHandler, message);
				}
			}
		}

		private function invokeHandler(handler:Function, message:Message):void {
			// Extract arguments from message to pass as destructured parameters
			var args:Array = [];
			args.push(message); // First parameter is always the Message object
			
			var localMsg:LocalMessage = message as LocalMessage;
			if (localMsg && localMsg.data) {
				args = args.concat(localMsg.data);
			}
			
			try {
				// Wait! If the handler function expects fewer arguments than args.length,
				// AS3 might throw an error if the function is not a varargs function.
				// In AS3, calling a function with too many arguments throws an ArgumentError!
				// We should check the function's arity (number of expected arguments) if possible, 
				// or just slice the args array to match the function's length.
				// Function.length returns the number of parameters it expects!
				var expectedLen:int = handler.length;
				if (expectedLen > 0 && args.length > expectedLen) {
					args = args.slice(0, expectedLen);
				}
				handler.apply(null, args);
			} catch (e:Error) {
				trace("Error invoking handler for " + message.type + ": " + e.message);
			}
		}

		public function dispatchDisconnect():void {
			_connected = false;
			var list:Array = _disconnectHandlers.concat();
			for (var i:int = 0; i < list.length; i++) {
				var handler:Function = list[i];
				try {
					handler();
				} catch (e:Error) {
					trace("Error in disconnect handler: " + e.message);
				}
			}
		}
	}
}
