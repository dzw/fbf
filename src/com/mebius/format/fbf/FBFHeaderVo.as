package com.mebius.format.fbf
{
	internal class FBFHeaderVo
	{
		//对应位 0x46  0x42 0x46 相对于ASCII编码位 FBF 字符
		private var _fileType:uint = 0x464246;
		
		//文件编码格式版本  s
		private var _fileVerison:int = 1;
		
		//---------- index data ---------
		//索引数据的起始点
		private var _indexDataPos:uint = 22;
		
		//索引数据块数量
		private var _indexDataNumBlock:uint = 0;
		
		//索引数据格式类型编号
		private var _indexDataType:int = 0;
		
		//---------- user data -------------
		//用户数据起始点
		private var _userDataIndexPos:uint = 0;
		
		//用户数据类型
		private var _userDataType:int = 1;
		
		//---------------- getter ---------------
		
		public function get fileType():uint
		{
			return _fileType;
		}
		
		public function get fileVerison():int
		{
			return _fileVerison;
		}
		
		public function get indexDataPos():uint
		{
			return _indexDataPos;
		}
		
		public function get indexDataNumBlock():uint
		{
			return _indexDataNumBlock;
		}
		
		public function get indexDataType():int
		{
			return _indexDataType;
		}
		
		public function get userDataIndexPos():uint
		{
			return _userDataIndexPos;
		}
		
		
		public function get userDataType():int
		{
			return _userDataType;
		}
		
		//------------- setter ----------------
		public function set indexDataNumBlock(value:uint):void
		{
			_indexDataNumBlock = value;
		}
		
		public function set userDataIndexPos(value:uint):void
		{
			_userDataIndexPos = value;
		}
		
		
	}
}