package com.mebius.format.fbf
{
	import com.mebius.format.ftf.FTFErrorEvent;

	public class FBFEventTrigger
	{
		private static var fbf:FBFManage;
		
		public function FBFEventTrigger( fbfm:FBFManage )
		{
			fbf = fbfm;
		}
		
		public static function disEvent(eventType:String, info:String):void
		{
			var evt:FBFErrorEvent = new FBFErrorEvent( eventType );
			evt.errorInfo = info + " file path:" + fbf.readFilePath;
			fbf.dispatchEvent( evt );
		}
	}
}