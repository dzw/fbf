package com.mebius.display
{
	import com.mebius.event.FBFTextFieldErrorEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * FBF字体呈现器 
	 * @author mebius
	 * 
	 */	
	public class FBFTextField extends Sprite
	{
		private var _str:String = "";
		private var _spacing:int = 0;
		private var _font:String = "";
		private var _bits:Vector.<Bitmap>;
		
		private var _textScale:Number = 1;
		
		public function FBFTextField( font:String )
		{
			this._font = font;
			this._bits = new Vector.<Bitmap>();
		}
		
		public function get length():uint
		{
			return this._bits.length;
		}
		
		/**
		 * 设置文本颜色，起始坐标与终点坐标保持默认则渲染所有文本
		 * @param color
		 * @param startIndex
		 * @param endIndex  
		 * 
		 */		
		public function setColor( color:uint, startIndex:uint=0, endIndex:int=-1 ):void
		{
			if( startIndex == 0 && endIndex == -1 )
			{
				//渲染所有文本
				endIndex = this.length;
			}
			
			var tranfrom:ColorTransform = new ColorTransform();
			tranfrom.color = color ;
			for( startIndex;startIndex <= endIndex;startIndex++ )
			{
				if( startIndex >= this.length )
				{
					break;
				}
				var bd:BitmapData = (this._bits[startIndex] as Bitmap).bitmapData;
				bd.colorTransform( new Rectangle(0,0,bd.width,bd.height), tranfrom );
			}
		}
		
		/**
		 *  设置文本颜色，起始坐标与终点坐标保持默认则渲染所有文本
		 * @param color
		 * @param startIndex
		 * @param length
		 * 
		 */		
		public function setColorStartLength(color:uint, startIndex:uint,length:uint):void
		{
			var tranfrom:ColorTransform = new ColorTransform();
			tranfrom.color = color ;
			var endIndex:uint = startIndex+length;
			for( startIndex;startIndex < endIndex;startIndex++ )
			{
				if( startIndex >= this.length )
				{
					break;
				}
				var bd:BitmapData = (this._bits[startIndex] as Bitmap).bitmapData;
				bd.colorTransform( new Rectangle(0,0,bd.width,bd.height), tranfrom );
			}
		}
		
		/**
		 * 获取对应字符的宽高范围 
		 * @param i 字符下标
		 * @return 
		 * 
		 */		
		public function getCharRectAt(i:uint):Rectangle
		{
			trace( this.text, i );
			var rect:Rectangle = new Rectangle();
			rect.x = this._bits[i].x;
			rect.y = this._bits[i].y;
			rect.width = this._bits[i].width ;//* this._textScale;
			rect.height = this._bits[i].height ;//* this._textScale;
			
			return rect;
		}
		
		public function get spacing():uint
		{
			return _spacing;
		}
		
		public function set spacing(value:uint):void
		{
			_spacing = value;
		//	this.removeChildren();
			var _w:Number = 0;
			for( var t:int = 0;t<this._bits.length;t++)
			{
				this._bits[t].x = _w ;
			//	this.addChild( this._bits[t] );
			//	trace(_bits[t].width);
				_w += this._bits[t].width + this._spacing;
			}
	//		this.width = _w;
		}
		
		public function get text():String
		{
			return this._str;
		}
		public function set text(val:String):void
		{
	//		trace(val);
			this._str = val;
			this.drawText();
		}
		
		public function get textScale():Number
		{
			return _textScale;
		}
		
		public function set textScale(value:Number):void
		{
			_textScale = value;
			this.draw();
		}
		
		private function draw():void
		{
			var _w:Number = 0;
			for( var t:int = 0;t<this._bits.length;t++)
			{
				this._bits[t].x = _w ;
				if( this._textScale < 0.1 )
				{
					this._textScale = 0.1;
				}
				this._bits[t].scaleX = this._textScale;
				this._bits[t].scaleY = this._textScale;
				this.addChild( this._bits[t] );
				_w += this._bits[t].width + this._spacing;
			}
		//	this.width = _w;
		}
		
		private function drawText():void
		{
			this._bits = new Vector.<Bitmap>();
			this.removeChildren();
			var currentStr:String="";
			try
			{
				for(var i:int = 0;i<this._str.length;i++)
				{
					var bit:Bitmap ;
					if( this._str.charAt(i) == " " )
					{
						bit = new Bitmap( new BitmapData(20,1,true,0x000000) );
					}
					else if( this._str.charAt(i) == "\\" )
					{
						//特殊字符，转义特殊编码字符  \#系列
						if( this._str.substr(i,2) == "\\#" )
						{
							//共取5位 例如：\#001
							currentStr = this._str.substr(i,5);
					//		bit = new Bitmap( FBFFontManage.getBitmapDataByChar( this._font,this._str.substr(i,5) ).clone() );
							bit = new Bitmap( FBFFontManage.getBitmapDataByChar( this._font,currentStr ).clone() );
							i+=4;
						}
					}
					else
					{
						currentStr = this._str.charAt(i);
					//	bit = new Bitmap( FBFFontManage.getBitmapDataByChar( this._font,this._str.charAt(i) ).clone() );
						bit = new Bitmap( FBFFontManage.getBitmapDataByChar( this._font,currentStr ).clone() );
					}
					
					
					this._bits.push( bit );
					bit.smoothing = true;
					
				}
				
			//	trace(currentStr);
				var _w:Number = 0;
				for( var t:int = 0;t<this._bits.length;t++)
				{
					this._bits[t].x = _w ;
					this._bits[t].scaleX = this._textScale;
					this._bits[t].scaleY = this._textScale;
					this.addChild( this._bits[t] );
					_w += this._bits[t].width + this._spacing;
				}
			//	this.width = _w;
			}
			catch(e:Error)
			{
				//字符不存在
			//	trace( "您输入不存在的字符,请先打开FBF字体文件！", "遇到了错误" );
				var event:FBFTextFieldErrorEvent = new FBFTextFieldErrorEvent(FBFTextFieldErrorEvent.CHAR_NO_FOUND);
				event.errorInfo = "not found char ' "+currentStr+" '";
				this.dispatchEvent( event );
			}
		}

		

	}
}