package com.mebius.format.fbf
{
	import flash.events.Event;
	
	public class FBFErrorEvent extends Event
	{
		public static const SYSTEM_IO_ERROR:String = "system_io_error_event";  //系统IO异步流错误
		public static const FILE_NOT_FOUND:String = "file_not_found_error_event";  //文件未找到错误
		public static const FILE_TYPE_ERROR:String = "file_type_error_event";  //文件类型错误
		public static const VERSION_UNRECOGNIZED_ERROR:String = "version_unrecognized_error_event";  //版本不能识别
		public static const FILE_CORRUPTION_ERROR:String = "file_corruption_error_event"; //文件损坏
		public static const IMAGE_DATA_CORRUPTION_ERROR:String = "image_data_corruption_error_event";  //图片数据损坏
		public static const CHAR_NOT_FOUND:String = "char_not_found_error_event";   //指定的字符未找到
		
		public var errorInfo:String = "";
		public function FBFErrorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}