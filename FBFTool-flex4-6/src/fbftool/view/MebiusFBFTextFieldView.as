package fbftool.view
{
	import com.mebius.display.FBFFontManage;
	import com.mebius.display.FBFTextField;
	import com.mebius.event.FBFTextFieldErrorEvent;
	import com.mebius.format.fbf.FBFManage;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	
	public class MebiusFBFTextFieldView extends UIComponent
	{
		private var txt:FBFTextField;
		private var loader:URLLoader = new URLLoader();
		
		public function MebiusFBFTextFieldView()
		{
			super();
			
		}
		
		public function openFBF(path:String):void
		{
			var fbf:FBFManage = new FBFManage();
			fbf.readFBF( path );
			
			var fm:FBFFontManage = new FBFFontManage();
			fm.addEventListener(Event.COMPLETE, fontok);
			fm.setFBF("abcfbf", fbf );
		}
		
		private function fontok(evt:Event):void
		{
			txt = new FBFTextField("abcfbf");
			txt.addEventListener( FBFTextFieldErrorEvent.CHAR_NO_FOUND, charNoFound_Event);
			this.addChild( txt );
			
			var event:Event = new Event( Event.COMPLETE );
			this.dispatchEvent( event );
		}
		
		public function get textField():FBFTextField
		{
			this.width = txt.width+100;
			this.height = txt.height+50;
			return txt;
		}
		
		
		/*
		\#001\#002
		*/
		
		private function charNoFound_Event(evt:FBFTextFieldErrorEvent):void
		{
			Alert.show( evt.errorInfo,"错误");
			
		}
	}
}