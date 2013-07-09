package com.mebius.event
{
	import flash.events.Event;
	
	public class FBFTextFieldErrorEvent extends Event
	{
		public static const CHAR_NO_FOUND:String = "char_no_found_event";
		
		public var errorInfo:String = "";
		public function FBFTextFieldErrorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}