package connection
{
	import com.Rijndael.crypto.symmetric.AESKey;
	import com.Rijndael.crypto.symmetric.CBCMode;
	import com.Rijndael.util.Hex;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author zazuna
	 */
	public class ConnectionManager extends MovieClip
	{
		public static var ON_CONNECTION:String = "Connected_to_Server";
		public static var ON_SOCKET_DATA:String = "New_Data_Arrived";
		public static var ON_CONNECTION_LOST:String = "Connection_Lost";
		static public const INTERNET_ERROR:String = "internetError";
		
		public var pingTimer:Timer;
		
		public var lastPing:uint;
		
		public var recievedString:String = "";
		
		public var obj:Object;
		
		private var sock:Socket;
		
		public var connected:Boolean;
		
		private var randomNumber:uint;
		
		public function ConnectionManager():void
		{
			sock = new Socket()
			sock.addEventListener(Event.CONNECT, handleConnect);
			sock.addEventListener(IOErrorEvent.IO_ERROR, traceIoError)
			sock.addEventListener(Event.CLOSE, onClose)
			sock.addEventListener(ProgressEvent.SOCKET_DATA, onSockData);
			sock.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		public function connect(host:String, port:int):void
		{
			//clearSocket();
			//Security.loadPolicyFile("xmlsocket://" + host + ":" + port);
			Tracer._log("connecting");
			sock.connect(host, port);
		}
		
		public function clearSocket():void
		{
			if (!sock)
			{
				return
			}
			
			sock.removeEventListener(Event.CONNECT, handleConnect);
			sock.removeEventListener(IOErrorEvent.IO_ERROR, traceIoError)
			sock.removeEventListener(Event.CLOSE, onClose)
			sock.removeEventListener(ProgressEvent.SOCKET_DATA, onSockData);
			sock.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError)
			
			if (sock.connected)
			{
				sock.close();
			}
			
			sock = null;
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			//Root.main.showError("Security Error")
			//connected = false;
		}
		
		private function onClose(e:Event):void
		{
			//Root.main.showError("Connection Closed")
			Tracer._log("Connection Closed")
			connected = false;
			dispatchEvent(new Event(ON_CONNECTION_LOST));
			
			if (pingTimer)
			{
				pingTimer.stop();
				pingTimer.removeEventListener(TimerEvent.TIMER, sendPing)
			}
		}
		
		private function traceIoError(e:IOErrorEvent):void
		{
			
			//Root.main.showError("Connection Lost"))
			Tracer._log("Connection Lost");
			connected = false;
			dispatchEvent(new Event(ON_CONNECTION_LOST));
		}
		
		private function handleConnect(e:Event):void
		{
		
			//sock.timeout = 7000;
			connected = true;
			dispatchEvent(new Event(ConnectionManager.ON_CONNECTION));
			//pingServer();
		
		}
		
		private function pingServer():void
		{
			lastPing = 0
			pingTimer = new Timer(10000);
			pingTimer.addEventListener(TimerEvent.TIMER, sendPing)
			pingTimer.start();
		}
		
		private function sendPing(e:TimerEvent):void
		{
			Tracer._log("ping");
			var d:uint = Math.round(new Date().getTime() / 1000)
			
			if (lastPing == 0)
			{
				lastPing = d;
			}
			
			/*if (d - lastPing > 25000)
			   {
			   onClose(null);
			   }
			   else*/
			{
				sock.writeUTFBytes("{messageType:'Ping'}øø");
				sock.flush();
			}
			
			lastPing = d;
		
		}
		
		public function sendData(obj:Object, withUserId:Boolean = true):void
		{
			if (!connected)
			{
				return;
			}
			
			//enable loadermc
			if (SocketAnaliser.shouldEnableLoader(obj.MT) == true)
			{
				
				//LoaderMc.container.enable();
			}
			
			var sendObj:Object = new Object();
			//sendObj.SID = Root.SessionID;
			
			if (withUserId)
			{
				sendObj.UID = Number(Root.userRoomId);
			}
			
			for (var i:String in obj)
			{
				sendObj[i] = obj[i];
			}
			
			if (sendObj.InnerMessage)
			{
				
				/*if (obj.MessageType != 7)
				   {
				   randomNumber = Math.round(Math.random() * 100000);
				   }*/
				
					   //sendObj.InnerMessage.rnd = randomNumber;
			}
			
			
			var str:String = JSON.stringify(sendObj);
			
			Tracer._log("----------------------" + str);
			
			str = str + "øø";
			sock.writeUTFBytes(str);
			sock.flush();
			/*var b:ByteArray = encrypt(Root.Key, str);
			sock.writeBytes(b);
			sock.flush();*/
		}
		
		private function onSockData(e:ProgressEvent):void
		{
			
			/*var key:ByteArray = Root.Key;
			var bytes:ByteArray = new ByteArray;
			sock.readBytes(bytes);
			var bstr:Array = Hex.fromArray(bytes).split("f8f0f8f0");
			for (var i:int = 0; i < bstr.length; i++)
			{
				if (bstr[i].length < 32) continue;
				var bdata:ByteArray = Hex.toArray(bstr[i]);
				if (bdata[0] == 1 && bdata[1] == 1)
				{
					key = Root.Key1;
					var btemp:ByteArray = new ByteArray;
					btemp.writeBytes(bdata, 2);
					bdata = btemp;
				}
				var str:String = decrypt(key, bdata);
				
				
				lastPing = Math.round(new Date().getTime() / 1000)
				
				if (str != "1")
				{
					analyzeData(str);
				}
			}*/
			
			var str:String = sock.readUTFBytes(sock.bytesAvailable);
			//lastPing = Math.round(new Date().getTime() / 1000)
			
			if (str != "1")
			{
				analyzeData(str);
			}
		
		}
		
		private function analyzeData(message:String):void
		{
			//trace("+++++++++ "+message);
			
			if (message.substr(message.length - 2) != "øø")
			{
				recievedString += message;
				return;
			}
			
			if (recievedString != "")
			{
				recievedString += message;
				message = recievedString;
				recievedString = "";
			}
			
			//Root.main.makeTrace(message);
			
			var str:String = message.substr(0, message.indexOf("øø"));
			message = message.substr(message.indexOf("øø") + 2);
			
			var readObj:Object;
			
			try
			{
				readObj = JSON.parse(str);
			}
			catch (e:SyntaxError)
			{
				Tracer._log("ConnectionManager onSockData SyntaxError: " + str)
			}
			
			/*if (readObj.FacebookID != Root.FacebookID) {
			   trace ("ConnectionManager onSockData: Not My Facebook Id")
			   ObjectExplorer.explore("ConnectionManager analyzeData", readObj);
			   return;
			   }
			
			   if (readObj.SessionID != Root.SessionID) {
			   trace ("ConnectionManager onSockData: Wrong SessionId")
			   return;
			   }*/
			
			/*if (!readObj.messageType)
			   {
			   trace("ConnectionManager onSockData: Unknown Message")
			   return;
			   }*/
			
			obj = readObj;
			
			Tracer._log("+++++++++ " + JSON.stringify(obj));
			dispatchEvent(new Event(ConnectionManager.ON_SOCKET_DATA));
			
			if (message.indexOf("øø") > 0)
			{
				//trace("ConnectionManager analyzeData: Recursion - " + message);
				analyzeData(message);
			}
		}
		
		private function encrypt(key:ByteArray, txt:String):ByteArray
		{
			var data:ByteArray = Hex.toArray(Hex.fromString(txt));
			var mode:CBCMode = new CBCMode(new AESKey(key));
			mode.encrypt(data);
			var ret:ByteArray = new ByteArray();
			ret.length = (mode.IV.length + data.length);
			ret.writeBytes(mode.IV);
			ret.writeBytes(data);
			return ret;
		}
		
		private function decrypt(key:ByteArray, data:ByteArray):String
		{
			var iv:ByteArray = new ByteArray();
			iv.writeBytes(data, 0, 16);
			var bdata:ByteArray = new ByteArray();
			bdata.writeBytes(data, 16, data.length - 16);
			var mode:CBCMode = new CBCMode(new AESKey(key));
			mode.IV = iv;
			mode.decrypt(bdata);
			return Hex.toString(Hex.fromArray(bdata));
		}
	}
}