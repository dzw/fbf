package com.mebius.format.fbf
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	internal class FBFCharList
	{
		private var _voVec:Vector.<FBFCharListVo>;
		
		private var _charDic:Dictionary;
		private var _charArr:Array;
		
		public function FBFCharList()
		{
			init();
		}
		
		private function init():void
		{
			this._voVec = new Vector.<FBFCharListVo>();
			this._charArr = new Array();
			this._charDic = new Dictionary();
		}
		
		public function pushData(char:String,x:Number,y:Number,width:Number,height:Number):void
		{
			var data:FBFCharListVo = new FBFCharListVo();
			data.char = char;
			data.x = x;
			data.y = y;
			data.width = width;
			data.height = height;
			
			this._voVec.push( data );
		}
		
		public function getCharListData():ByteArray
		{
			var byte:ByteArray = new ByteArray();
			
			for( var i:int = 0; i<this._voVec.length; i++ )
			{
				var data:FBFCharListVo = this._voVec[i];
				byte.writeUTF( data.char );
				byte.writeFloat( data.x );
				byte.writeFloat( data.y );
				byte.writeFloat( data.width );
				byte.writeFloat( data.height );
			}
			
			return byte;
		}
		
		public function get charNum():uint
		{
			return this._voVec.length;
		}
		
		public function readCharData(val:ByteArray,blockNum:uint):void
		{
			val.position = 0;
			for( var i:uint=0;i<blockNum; i++ )
			{
				var char:String = val.readUTF();
				var x:Number = val.readFloat();
				var y:Number = val.readFloat();
				var w:Number = val.readFloat();
				var h:Number = val.readFloat();
				this._charArr.push( char );
				this._charDic[char] = new Rectangle(x,y,w,h);
				
			}
		}
		
		public function getRectByChar(char:String):Rectangle
		{
			return this._charDic[char] as Rectangle;
		}

		public function get charArr():Array
		{
			return _charArr;
		}

	}
}