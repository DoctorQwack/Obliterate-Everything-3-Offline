package playerio {
	import flash.utils.setTimeout;

	public class LocalMultiplayer implements Multiplayer {
		private var _devServer:String = "";

		public function LocalMultiplayer() {
		}

		public function createRoom(roomId:String, roomType:String, visible:Boolean, roomData:Object, callback:Function=null, errorHandler:Function=null):void {
			if (callback != null) {
				// Instantly return room ID
				callback(roomId ? roomId : "localRoom_" + Math.random());
			}
		}

		public function createJoinRoom(roomId:String, roomType:String, visible:Boolean, roomData:Object, joinData:Object, callback:Function=null, errorHandler:Function=null):void {
			var rId:String = roomId ? roomId : ("localRoom_" + Math.floor(Math.random() * 100000));
			var conn:LocalConnection = new LocalConnection(rId, roomType);
			
			if (callback != null) {
				callback(conn);
			}
			
			// Notify server side that a client joined this room, deferred to let client register handlers
			setTimeout(function():void {
				OfflineServer.getInstance().handleClientJoin(conn, joinData);
			}, 10);
		}

		public function joinRoom(roomId:String, joinData:Object, callback:Function=null, errorHandler:Function=null):void {
			var conn:LocalConnection = new LocalConnection(roomId, "Game");
			
			if (callback != null) {
				callback(conn);
			}
			
			// Notify server side that a client joined this room, deferred to let client register handlers
			setTimeout(function():void {
				OfflineServer.getInstance().handleClientJoin(conn, joinData);
			}, 10);
		}

		public function listRooms(roomType:String, searchCriteria:Object, resultLimit:int, resultOffset:int, callback:Function=null, errorHandler:Function=null):void {
			if (callback != null) {
				callback([]);
			}
		}

		public function set developmentServer(serverPort:String):void {
			_devServer = serverPort;
		}

		public function get developmentServer():String {
			return _devServer;
		}
	}
}
