package fbftool.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.core.FlexSprite;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	
	public class BitmapFontMap extends UIComponent
	{
		private var _container:Sprite;
		private var _bitFontLay:Sprite;
		private var _bakcground:Shape;
		private var _frame:Shape;
		private var bd:BitmapData;
		
	//	private var _fontBitmap:Vector.<Bitmap>;
		
		private var _fontBitmap:Dictionary;
		private var _fontList:Vector.<String>;
		
		public function BitmapFontMap()
		{
			super();
			init();
		}
		
		private function init():void
		{
			this._fontBitmap = new Dictionary();
			this._fontList = new Vector.<String>();
			
			bd = new BitmapData(40,40,false);
			bd.fillRect(new Rectangle(0,0,20,20),0xffffff);
			bd.fillRect(new Rectangle(20,0,20,20),0xcccccc);
			bd.fillRect(new Rectangle(0,20,20,20),0xcccccc);
			bd.fillRect(new Rectangle(20,20,20,20),0xffffff);
			
			this._bakcground = new Shape();
			this._frame = new Shape();
			
			this._container = new Sprite();
			this._container.x = 20;
			this._container.y = 20;
			this.addChild( this._container );
			
			this._bitFontLay = new Sprite();
		//	this._bitFontLay.x = 20;
		//	this._bitFontLay.y = 20;
			
			
			this._container.addChild( _bakcground );
			this._container.addChild( this._bitFontLay );
			this.addChild( _frame );
		}
		
		public function setStageSize(w:Number,h:Number):void
		{
			this.width = w+40;
			this.height = h+40;
			this.drawStage(w,h);
		}
		
		public function createFontNum(val:uint):void
		{
		//	this._fontBitmap = new Vector.<Bitmap>(val);
		//	接口废弃
		}
		public function addBitmapFont(bd:BitmapData,id:uint):void
		{
			//
			var bit:Bitmap = new Bitmap(bd);
			this._fontList.push( id );
			this._fontBitmap[id] = bit ;
			
			this._bitFontLay.addChild( bit );
		}
		
		public function clearAll():void
		{
			this._bitFontLay.removeChildren();
			this._fontBitmap = new Dictionary();
			this._fontList = new Vector.<String>();
		}
		
		public function setBitmapFontLocation(id:uint, rect:Rectangle):void
		{
			this._fontBitmap[id].x = rect.x;
			this._fontBitmap[id].y = rect.y;
		}
		
		public function get fontBitmapData():BitmapData
		{
			var bd:BitmapData = new BitmapData( this.width,this.height,true,0x000000 );
			bd.draw( this._bitFontLay );
			return bd;
		}
		
		//-----------
		
		private function drawStage(w:Number,h:Number):void
		{
			_bakcground.graphics.clear();
			_bakcground.graphics.beginBitmapFill(bd);
			_bakcground.graphics.drawRect(0,0,w,h);
			_bakcground.graphics.endFill();
			
			_frame.graphics.clear();
			_frame.graphics.lineStyle(1,0x000000,0);
		//	_frame.graphics.beginFill(0xff8888,0.3);
			_frame.graphics.drawRect( 0,0,w+40,h+40);
			_frame.graphics.endFill();
			
		}
		
		
	}
}