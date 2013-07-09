package fbftool.view
{
	import flash.events.Event;
	
	public class ListChangeEvent extends Event
	{
		public static const CHANG_CHAR:String = "change_char_event";
		
		public var _id:uint = 0;
		public var _char:String = "";
		
		public function ListChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}