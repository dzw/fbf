package com.mebius.display
{
	import com.mebius.format.fbf.FBFManage;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
//	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * FBF字体管理器 
	 * @author mebius
	 * 
	 */	
	public class FBFFontManage extends EventDispatcher
	{
		
		private static var _fonts:Dictionary;
		private var fbfs:Dictionary;
		
		//-------------------------------------------------------------------
		public function FBFFontManage()
		{
			this.fbfs = new Dictionary();
			FBFFontManage._fonts = new Dictionary();
		}
		
		/**
		 * 设置一个新的FBF字体 
		 * @param name  字体名称 
		 * @param fbf   FBF管理器
		 * 
		 */		
		public function setFBF( name:String, fbf:FBFManage ):void
		{
			this.fbfs[name] = fbf;
			
			var imgLoader:Loader= new Loader();
			imgLoader.name = name;
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onIMGComplete);
		//	imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			imgLoader.loadBytes( fbf.getImageByte() );//读取ByteArray    
			
		}
		
		public static function getBitmapDataByChar( font:String, char:String ):BitmapData
		{
			var bd:BitmapData = _fonts[font][char];
			return bd;
		}
		
		
		//-------------------------------------------------------------------
		private function onIMGComplete(evt:Event):void 
		{
			var bitMap:Bitmap=evt.target.content as Bitmap;//读取Bitmap    
			
			//开始截取位图
			var name:String = (evt.currentTarget as LoaderInfo).loader.name;
			var fbf:FBFManage = this.fbfs[ name ] as FBFManage;
			var chararr:Array = fbf.getChars();
			var l:int = chararr.length;
			
			var chars:Dictionary = new Dictionary();
			
			for( var i:int = 0;i<l;i++ )
			{
				var rect:Rectangle = fbf.getRectByChar( chararr[i] );
				var bd:BitmapData = new BitmapData( rect.width, rect.height, true, 0x000000 );
				bd.copyPixels( bitMap.bitmapData , new Rectangle(rect.x,rect.y,rect.width,rect.height), new Point(0,0) );
				
				chars[chararr[i]] = bd;
			}
			
			_fonts[name] = chars;
			
			var event:Event = new Event( Event.COMPLETE );
			this.dispatchEvent( event );
		}
	}
}