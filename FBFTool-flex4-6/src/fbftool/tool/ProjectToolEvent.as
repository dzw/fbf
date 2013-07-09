package fbftool.tool
{
	import flash.events.Event;
	
	public class ProjectToolEvent extends Event
	{
		public static const CREATED_PRO:String = "created_pro_event";
		public static const OPENED_PRO:String = "opened_pro_event";
		public static const LOADER_COMPLETE:String = "loaderImageComplete_event";
		
		public function ProjectToolEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}