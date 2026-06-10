package playerio {
	import flash.display.Stage;

	/**
	 * Offline PlayerIO SDK mock entry point.
	 */
	public final class PlayerIO {
		private static var _quickConnect:QuickConnect;

		public function PlayerIO() {
			throw new Error("You cannot create an instance of the PlayerIO class!");
		}

		public static function connect(stage:Stage, gameid:String, connectionid:String, userid:String, auth:String, partnerId:String, callback:Function, errorhandler:Function = null):void {
			var client:LocalClient = new LocalClient(stage, userid);
			if (callback != null) {
				callback(client);
			}
		}

		public static function get quickConnect():QuickConnect {
			if (!_quickConnect) {
				_quickConnect = new QuickConnect();
			}
			return _quickConnect;
		}

		public static function gameFS(gameId:String):GameFS {
			return new SimpleGameFS(gameId, {});
		}

		public static function showLogo(stage:Stage, align:String):void {
			// Do nothing - no logo is needed offline
		}
	}
}