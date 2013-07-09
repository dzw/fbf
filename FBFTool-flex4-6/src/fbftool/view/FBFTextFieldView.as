package fbftool.view
{
	import com.mebius.format.fbf.FBFManage;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import mx.core.UIComponent;
	
	public class FBFTextFieldView extends UIComponent
	{
		private var filePath:String = "";
		private var _afbf:FBFManage;
		private var _con:Sprite;

		private var _bigbd:BitmapData;
		
		public function FBFTextFieldView()
		{
			super();
			
		}
		
		private function init():void
		{
			this._con = new Sprite();
			this.addChild( _con );
			
			_afbf = null;
			this._bigbd = null;
		}
		
		public function openFBF(path:String):void
		{
			this.filePath = path;
			
			this.removeChildren();
			init();
			
			this.read2();
		}
		
		private function read2():void
		{
			_afbf = new FBFManage();
			_afbf.readFBF(this.filePath);
			var byte:ByteArray = afbf.getImageByte();
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, ok);
			loader.loadBytes( byte );
		}
		private function ok(evt:Event):void
		{
			var bd:BitmapData = new BitmapData(evt.target.loader.width,evt.target.loader.height,true,0x000000);
			bd.draw( evt.target.loader );
			_bigbd = new BitmapData(bd.width,bd.height,true,0);
			
		//	trace( "--",evt.target.loader.width,evt.target.loader.height );
			
			this._bigbd.draw( bd );
			var bs:Bitmap = new Bitmap(bd);
			
			var arr:Array = afbf.getChars();
			
			var _w:Number = 0;
			for( var i:int = 0;i<arr.length;i++ )
			{
				var rect:Rectangle = afbf.getRectByChar( arr[i] );
		//		trace( "//",rect );
				
				var bds:BitmapData = new BitmapData(rect.width,rect.height,true,0x000000);
				bds.copyPixels( bd, new Rectangle(rect.x,rect.y,rect.width,rect.height), new Point(0,0) );
				var bit:Bitmap = new Bitmap(bds);
				bit.x = _w;
				bit.y = 10;
				_con.addChild( bit );
				
				_w += bds.width;
				
				var txt:TextField = new TextField();
				txt.x = bit.x + bit.width/2;
				txt.y = bit.y+bit.height+5;
				txt.text = arr[i];
				txt.height = 30;
				txt.textColor = 0xffffff;
				_con.addChild( txt );
			}
			this.width = _w+50;
			this.height = _con.height+100;
			
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}

		public function get bigbd():BitmapData
		{
			return _bigbd;
		}

		public function get afbf():FBFManage
		{
			return _afbf;
		}


	}
}