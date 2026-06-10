package playerio {
	import flash.display.Stage;

	public class QuickConnect {
		public function QuickConnect(proxy:Function = null) {
		}

		public function simpleConnect(stage:Stage, gameid:String, usernameOrEmail:String, password:String, callback:Function=null, errorhandler:Function=null):void {
			var client:LocalClient = new LocalClient(stage, usernameOrEmail);
			if (callback != null) {
				callback(client);
			}
		}

		public function simpleRegister(stage:Stage, gameid:String, username:String, password:String, email:String, captchaKey:String="", captchaValue:String="", extraData:Object = null, partnerId:String = "", callback:Function=null, errorhandler:Function=null):void {
			var client:LocalClient = new LocalClient(stage, username);
			if (callback != null) {
				callback(client);
			}
		}

		public function simpleGetCaptcha(gameId:String, width:int, height:int, callback:Function=null, errorHandler:Function=null):void {
			if (callback != null) {
				callback("dummyKey", "dummyUrl");
			}
		}

		public function simpleRecoverPassword(gameId:String, usernameOrEmail:String, callback:Function=null, errorHandler:Function=null):void {
			if (callback != null) {
				callback();
			}
		}

		public function kongregateConnect(stage:Stage, gameid:String, userid:String, gameauthtoken:String, callback:Function=null, errorhandler:Function=null):void {
			var client:LocalClient = new LocalClient(stage, "kong" + userid);
			if (callback != null) {
				callback(client);
			}
		}

		public function facebookConnect(stage:Stage, gameId:String, uid:String, sessionKey:String, partnerId:String = "", callback:Function=null, errorHandler:Function=null):void {
			var client:LocalClient = new LocalClient(stage, "fb" + uid);
			if (callback != null) {
				callback(client);
			}
		}

		public function facebookConnectPopup(stage:Stage, gameId:String, window:String, permissions:Array, partnerId:String = "", callback:Function=null, errorHandler:Function=null):void {
			var client:LocalClient = new LocalClient(stage, "fb_popup");
			if (callback != null) {
				callback(client, "dummy_api_key", "dummy_uid", "dummy_session", "dummy_secret");
			}
		}

		public function facebookOAuthConnect(stage:Stage, gameId:String, accessToken:String, partnerId:String = "", callback:Function=null, errorHandler:Function=null):void {
			var client:LocalClient = new LocalClient(stage, "fb_oauth");
			if (callback != null) {
				callback(client, "dummy_uid");
			}
		}

		public function facebookOAuthConnectPopup(stage:Stage, gameId:String, window:String, permissions:Array, partnerId:String = "", callback:Function=null, errorHandler:Function=null):void {
			var client:LocalClient = new LocalClient(stage, "fb_oauth_popup");
			if (callback != null) {
				callback(client, "dummy_token", "dummy_uid");
			}
		}
	}
}