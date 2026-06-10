package playerio {
	import flash.utils.ByteArray;

	public class LocalMessage implements Message {
		private var _type:String;
		private var _data:Array;

		public function LocalMessage(type:String, data:Array = null) {
			this._type = type;
			this._data = data ? data : [];
		}

		public function add(...args:*):void {
			for (var i:int = 0; i < args.length; i++) {
				_data.push(args[i]);
			}
		}

		public function getNumber(index:int):Number {
			return Number(_data[index]);
		}

		public function getInt(index:int):int {
			return int(_data[index]);
		}

		public function getUInt(index:int):uint {
			return uint(_data[index]);
		}

		public function getString(index:int):String {
			return String(_data[index]);
		}

		public function getBoolean(index:int):Boolean {
			return Boolean(_data[index]);
		}

		public function getByteArray(index:int):ByteArray {
			return _data[index] as ByteArray;
		}

		public function get data():Array {
			return _data;
		}

		public function get length():int {
			return _data.length;
		}

		public function get type():String {
			return _type;
		}

		public function set type(type:String):void {
			_type = type;
		}

		public function toString():String {
			return "[LocalMessage type=" + _type + " length=" + length + " data=[" + _data.join(", ") + "]]";
		}
	}
}
