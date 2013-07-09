package com.mebius.format.fbf
{
	import flash.utils.ByteArray;

	internal class FBFFormatData
	{
		private var _fileData:ByteArray;
		
		public function FBFFormatData()
		{
			init();
		}
		
		
		private function init():void
		{
			this._fileData = new ByteArray();
		}
		
		/**
		 * 
		 * @param val 图片的二进制文件数据
		 * 
		 */		
		public function pushFile(val:ByteArray):void
		{
			this._fileData.writeBytes( val );
		}
		
		public function get currentPosition():uint
		{
			return this._fileData.position;
		}
		
		public function get byteLength():uint
		{
			return this._fileData.length;
		}
		
		public function get fileData():ByteArray
		{
			return _fileData;
		}
	}
}