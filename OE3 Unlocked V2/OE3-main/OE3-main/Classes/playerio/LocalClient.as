package playerio {
	import flash.display.Stage;

	public class LocalClient implements Client {
		private var _stage:Stage;
		private var _userId:String;
		private var _multiplayer:LocalMultiplayer;

		public function LocalClient(stage:Stage, userId:String) {
			this._stage = stage;
			this._userId = userId;
			this._multiplayer = new LocalMultiplayer();
		}

		public function get connectUserId():String {
			return _userId;
		}

		public function get partnerPay():PartnerPay {
			return null;
		}

		public function get payVault():PayVault {
			return null;
		}

		public function get gameFS():GameFS {
			return null;
		}

		public function get bigDB():BigDB {
			return null;
		}

		public function get errorLog():ErrorLog {
			return null;
		}

		public function get multiplayer():Multiplayer {
			return _multiplayer;
		}

		public function get stage():Stage {
			return _stage;
		}
	}
}
