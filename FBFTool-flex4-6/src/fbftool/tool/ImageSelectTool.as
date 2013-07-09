package fbftool.tool
{
	import flash.events.*;
	import flash.filesystem.*;
	
	public class ImageSelectTool extends EventDispatcher
	{
		
		private var openFile:File;
		private var key:int;//递归结束标志
		private var _pngFileList:Array=[];

		private var _selectFileList:Array;
		
		public function ImageSelectTool()
		{
			this.openFile = new File();
			
		}
		
		public function selectImageFiles():void
		{
			this._pngFileList = [];
			this.openFile.removeEventListener(Event.SELECT, selectSingleFileEvent);
			this.openFile.addEventListener(Event.SELECT, selectOpenFile);
			openFile.browseForDirectory("请选择您的位图字体文件夹");
		}
		
		public function selectSingleFile():void
		{
			this._pngFileList = [];
			this.openFile.removeEventListener(Event.SELECT, selectOpenFile);
			this.openFile.addEventListener(Event.SELECT, selectSingleFileEvent);
			openFile.browse();
		}
		
		private function selectSingleFileEvent(evt:Event):void
		{
			var filename:String = String( this.openFile.url ).split(".")[1];
		//		trace(filename);
			if( filename=="png" )
			{
				_selectFileList = new Array();
				this._selectFileList.push( this.openFile.url );
				//完成图片格式检查
				var evt:Event = new Event(Event.COMPLETE);
				this.dispatchEvent( evt );
			}
		}
		
		private function selectOpenFile(evt:Event):void
		{
			
		//	trace("me");
			/*
			if( this._pngFileList.length!=0 )
			{
				this._pngFileList = [];
			}
			*/
			
			getFileArr();
		}
		/**
		 递归函数开始递归
		 **/
		private function getFileArr(_url:String=""):void{
			key++;
			if(_url!=""){
				openFile.url = _url;
			}
			var arr:Array = openFile.getDirectoryListing();
			var leg:int = arr.length;
			for(var i:int=0;i<leg;i++){
				var file:File = arr[i] as File;
				if(file.isDirectory){
					getFileArr(file.url);
				}else{
					_pngFileList.push(file.url);
				}
			}
			key--;
			if(key==0){//判断递归是否结束
				Idone();
			}
		}
		/**
		 这里可以切一个断点看看结果，或者干脆用用trace
		 **/
		private function Idone():void
		{
			_selectFileList = new Array();
			
			for( var i:int=0;i<_pngFileList.length;i++ )
			{
				var filename:String = String( _pngFileList[i] ).split(".")[1];
				//	trace(filename);
				if( filename=="png" )
				{
					this._selectFileList.push( _pngFileList[i] );
				}
			}
			
			//完成图片格式检查
			var evt:Event = new Event(Event.COMPLETE);
			this.dispatchEvent( evt );
			
			/*
			this.bfontStage.createFontNum( this._pngFileList.length );
			this.bitfontkey = 0;
			this._bfd = new Dictionary();
			this._bdfvec = new Vector.<uint>();
			//将图片全部读取进来
			for( var i:int=0;i<_pngFileList.length;i++ )
			{
				var filename:String = String( _pngFileList[i] ).split(".")[1];
				//	trace(filename);
				if( filename=="png" )
				{
					this._bdfvec.push( i );
					var data:BitmapFontData = new BitmapFontData();
					data.id = i;
					
					var str:String = String(_pngFileList[i]);
					//itemIndex
					var arr:Array = str.split("/");
					str = (arr[arr.length-1] as String).split(".")[0];
					data.char = str;
					data.path = _pngFileList[i];
					data.x = 0;
					data.y = 0;
					this._bfd[i] = data;
					var loader:Loader = new Loader();
					loader.name = String(i);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderFontBitmap);
					loader.load( new URLRequest(_pngFileList[i]) );
				}
				else
				{
					//			_pngFileList.splice(i,1);
				}
				
			}
			
			this.infoLabel.text = "共选择了 "+this._bdfvec.length+"张位图字体图片";
			
			var listdata:Array = [];
			var length:uint = this._pngFileList.length;
			for(var q:uint = 0;q<length;q++)
			{
				
				var strurl:String = this._pngFileList[q];
				var arru:Array = strurl.split("/");
				strurl = (arru[arru.length-1] as String).split(".")[0];
				listdata.push( {fileurl:this._pngFileList[q],char:strurl});
			}
			this.imageList.dataProvider = new ArrayList(listdata);
			*/
		}

		public function get selectFileList():Array
		{
			return _selectFileList;
		}
		
		
	}
}