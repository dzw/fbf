package com.mebius.format.fbf
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	
	
	public class FBFManage extends EventDispatcher
	{
		private var _header:FBFHeader;
		private var _charlistData:FBFCharList;
		private var _formatData:FBFFormatData;
		private var stream:FileStream ;
		private var _filePath:String;
		private var _eventTrigger:FBFEventTrigger;
		
		public function FBFManage()
		{
			init();
		}
		
		private function init():void
		{
			_eventTrigger = new FBFEventTrigger(this);
			this._header = new FBFHeader();
			this._charlistData = new FBFCharList();
			this._formatData = new FBFFormatData();
		}
		
		public function addCharData(char:String,x:Number,y:Number,width:Number,height:Number):void
		{
			this._charlistData.pushData( char,x,y,width,height );
		}
		
		public function addImageData(val:ByteArray):void
		{
			this._formatData.pushFile( val );
		}
		
		public function createFBF():ByteArray
		{
			this._header.setIndexDataNumBlock( this._charlistData.charNum );
			var byte:ByteArray = new ByteArray();
			
			var charlistByte:ByteArray = this._charlistData.getCharListData();
			this._header.setUserDataPos( 22+charlistByte.length );
			
			byte.writeBytes( this._header.headerData );
			byte.writeBytes( charlistByte );
			byte.writeBytes( this._formatData.fileData );
			
			return byte;
		}
		
		/**
		 * 读取文件 
		 * @param filePath
		 * 
		 */		
		public function readFBF(filePath:String):void
		{
			this._filePath = filePath;
			
			var file:File = new File(filePath);
			if( !file.exists )
			{
				//文件不存在
				FBFEventTrigger.disEvent( FBFErrorEvent.FILE_NOT_FOUND,"file with fbf format not found");
			}
			else
			{
				try
				{
					stream = new FileStream();
					stream.open( file, FileMode.READ );
					
					stream.position = 0;
					var header:ByteArray = new ByteArray();
					stream.readBytes( header,0,22);
					this._header.readHeaderData( header );
					
					
					stream.position = 22;
					var indexdata:ByteArray = new ByteArray();
					var length:uint = this._header.getUserDataPos() - 22;
					stream.readBytes( indexdata, 0, length );
					this._charlistData.readCharData( indexdata, this._header.getIndexDataNumBlock() );
					
				}
				catch(e:Error)
				{
					FBFEventTrigger.disEvent( FBFErrorEvent.FILE_CORRUPTION_ERROR,
						"file is error,is not FBF format or file corruption.");
				}
			}
					
			
		}
		
		public function getImageByte():ByteArray
		{
			var byte:ByteArray = new ByteArray();
			try
			{
				stream.position = this._header.getUserDataPos();
				stream.readBytes( byte, 0 , stream.bytesAvailable );
			}
			catch(e:Error)
			{
				FBFEventTrigger.disEvent( FBFErrorEvent.IMAGE_DATA_CORRUPTION_ERROR,"the image data is error.");
			}
			
			return byte;
		}
		
		public function getChars():Array
		{
			return this._charlistData.charArr;
		}
		
		public function getRectByChar(char:String):Rectangle
		{
			var rect:Rectangle = this._charlistData.getRectByChar( char );
			if(!rect)
			{
				FBFEventTrigger.disEvent( FBFErrorEvent.CHAR_NOT_FOUND,"the char:\'"+char+"\' not found.");
			}
			return rect;
		}
		
		public function get readFilePath():String
		{
			return this._filePath;
		}
	}
}