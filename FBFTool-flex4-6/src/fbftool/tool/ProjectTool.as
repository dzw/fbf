package fbftool.tool
{
	import fbftool.data.BitmapFontData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;

	public class ProjectTool extends EventDispatcher
	{
		private var _bfd:Dictionary;
		private var _bdfvec:Vector.<uint>;
		private var bitfontkey:int = 0 ; //提示加载的位图数量
		private var bitfontKeyNum:int = 0;//加载的总数
		
		private var _projectPath:String = "";
		private var _projectData:XML;
		private var chars:Array;   //如果是打开项目，这个chars会被开启
		
		private var _imageFileList:Array;
		
		private var _projectSelectFile:File;
		private var _openProjectSelectFile:File;
		
		public function ProjectTool()
		{
			this._projectSelectFile = new File();
			this._projectSelectFile.addEventListener(Event.SELECT, selectProjectFilePath);
			
			this._openProjectSelectFile = new File();
			this._openProjectSelectFile.addEventListener(Event.SELECT, selectOpenProjectFilePath );
		}
		
		public function openProject():void
		{
			this._openProjectSelectFile.browseForDirectory("选择项目目录");
		}
		
		public function newProject():void
		{
			this._projectSelectFile.browseForDirectory("选择项目目录");
		}
		
		public function saveProject():void
		{
			this._projectData.image = "";
			//将图片数据添加到XML中
			var l:uint = this._bdfvec.length;
			for( var i:int = 0;i<l;i++ )
			{
				var data:XML = new XML( "<pngImage source='"+_imageFileList[i].proImagePath+"' char='"+_imageFileList[i].char+"'/>" );
				this._projectData.image.appendChild(data);
			}
			
			//保存文件
			var file:File = new File( this._projectPath+"/fbf.fbfproject" );
			var stream:FileStream = new FileStream();
			stream.open( file, FileMode.WRITE );
			stream.writeUTFBytes( this._projectData.toString() );
			stream.close();
			Alert.show("保存完成","保存项目完成");
		}
		
		public function get stageWidth():Number
		{
			return Number(this._projectData.stageWidth);
		}
		public function set stageWidth(val:Number):void
		{
			if( _projectData )
			{
				this._projectData.stageWidth = val.toString();
			}
			
		}
		
		public function get stageHeight():Number
		{
			return Number(this._projectData.stageHeight);
		}
		public function set stageHeight(val:Number):void
		{
			if( _projectData )
			{
				this._projectData.stageHeight = val.toString();
			}
		}
		
		public function get layout():String
		{
			return this._projectData.layout;
		}
		public function set layout(val:String):void
		{
			if( _projectData )
			{
				this._projectData.layout = val;
			}
		}
		
		
		//删除元素
		public function delData(imageIndex:uint,id:uint):void
		{
			_imageFileList.splice( imageIndex, 1);
			
			var l:uint = this._bdfvec.length;
			for(var i:int = 0;i<l;i++)
			{
				trace(this._bdfvec[i] ,id);
				if( this._bdfvec[i] == id )
				{
					trace("ID相同");
					this._bdfvec.splice(i,1);
					trace(this._bdfvec);
					break;
				}
			}
			//发送消息，通知视图更新bitMap
			var event:ProjectToolEvent = new ProjectToolEvent(ProjectToolEvent.LOADER_COMPLETE);
			this.dispatchEvent(event);
		}
		
		//---------------------------------------------------------------------
		
		//打开项目路径
		private function selectOpenProjectFilePath(evt:Event):void
		{
			this._projectPath = this._openProjectSelectFile.url;
			var file:File = new File( this._projectPath+"/fbf.fbfproject" );
			if( file.exists )
			{
				//打开项目
				this.openProjectFile(file);
			}
			else
			{
				Alert.show("项目文件不存在","打开项目失败");
			}
		}
		
		//选择了项目路径
		private function selectProjectFilePath(evt:Event):void
		{
			this._projectPath = this._projectSelectFile.url;
			this.judgeProjectFile();
		}
		
		
		//判断当前路径是否存在项目文件，不存在则为新建项目，存在则为新建失败
		private function judgeProjectFile():void
		{
			var file:File = new File( this._projectPath+"/fbf.fbfproject" );
			if( file.exists )
			{
				//打开项目
				Alert.show("此目录存在项目文件","创建项目失败");
			}
			else
			{
				//创建项目
				this.createProjectFile( file );
			}
		}
		
		//打开项目
		private function openProjectFile(file:File):void
		{
			var stream:FileStream = new FileStream();
			stream.open( file, FileMode.READ );
			var str:String = stream.readUTFBytes( stream.bytesAvailable );
			stream.close();
			
			
			try
			{
				this._projectData = new XML(str);
				
				//解析XML中的image部分
				var l:int = this._projectData.image.pngImage.length();
				//	trace(this._projectData.image,this._projectData.image.pngImage.length );
				
				this.chars = new Array();
				var urls:Array = new Array();
				for( var i:int = 0;i<l;i++ )
				{
					//		trace(this._projectData.image.pngImage[i].@source);
					urls.push( this._projectData.image.pngImage[i].@source );
					chars.push( this._projectData.image.pngImage[i].@char );
				}
				
				
				var evt:ProjectToolEvent = new ProjectToolEvent(ProjectToolEvent.OPENED_PRO);
				this.dispatchEvent(evt);
				
				this.imageFileList = urls;
			}
			catch(e:Error)
			{
				Alert.show("项目文件损坏","打开项目失败");
			}
		}
		
		//创建项目
		private function createProjectFile(file:File):void
		{
			var stream:FileStream = new FileStream();
			stream.open( file, FileMode.WRITE );
			stream.writeUTFBytes( this.createDefaultProjectFile() );
			stream.close();
			
			var evt:ProjectToolEvent = new ProjectToolEvent(ProjectToolEvent.CREATED_PRO);
			this.dispatchEvent(evt);
		}
		
		
		//创建一个默认项目文件
		private function createDefaultProjectFile():String
		{
			var str:String = "<root><version>3.0.0</version><image/><stageWidth>1024</stageWidth><stageHeight>1024</stageHeight><layout>BestShortSideFit</layout></root>";
			this._projectData = new XML(str);
			return this._projectData.toString();
		}

		public function get imageFileList():Array
		{
			return _imageFileList;
		}

		public function set imageFileList(value:Array):void
		{
	//		trace("--",value);
			//生成 list 控件所需要的数据
			if( !_imageFileList )
			{
				_imageFileList = [];
			}
			
			var length:uint = value.length;
			
			///  生成 BitmapFontDat 数据
			if( !this._bfd )
			{
				this._bfd = new Dictionary();
				this._bdfvec = new Vector.<uint>();
			}
			
			this.bitfontkey = 0;
			this.bitfontKeyNum = length;
			//
			for(var q:uint = 0;q<length;q++)
			{
				
				var strurl:String = value[q];   //文件名
				var arru:Array = strurl.split("/");
				strurl = (arru[arru.length-1] as String).split(".")[0];
				
				//拷贝文件
				var sourceFile:File = new File(value[q]);
				var newPathFile:File = new File( this._projectPath+"/assets/"+strurl+".png" );
				if( sourceFile.exists )
				{
					sourceFile.copyTo( newPathFile, true );
				}
				
				var charstr:String = strurl;
				if( this.chars )
				{
					charstr= chars[q];
				}
				
				var currentID:String;
				if( this._bdfvec.length == 0 )
				{
					currentID = this._bdfvec.length.toString();
				}
				else
				{
					currentID = String( (uint(this._bdfvec[this._bdfvec.length-1])+1) );
				}
				
			//	trace("ID",currentID);
			//	fileurl 为assets中的图片,char 是文件名 proImagePath是相对路径
				_imageFileList.push( {fileurl:newPathFile.url,char:charstr,proImagePath:("/assets/"+strurl+".png"),id:currentID});
				
				
				///  生成 BitmapFontDat 数据
				
				this._bdfvec.push( uint(currentID) );
				var data:BitmapFontData = new BitmapFontData();
				data.id = uint(currentID);
				
				//itemIndex
				if( this.chars )
				{
					data.char = chars[q];
				}
				else
				{
					data.char = strurl;
				}
				
				data.path = newPathFile.url;
				data.x = 0;
				data.y = 0;
				this._bfd[currentID] = data;
				var loader:Loader = new Loader();
				loader.name = String(currentID);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderFontBitmap);
				loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR,eloaderFontBitmap);
				
				loader.load( new URLRequest(newPathFile.url) );
			}
			this.chars = null;
		}
		
		private function eloaderFontBitmap(evt:ErrorEvent):void
		{
	//		trace("error loader");
		}
		
		private function loaderFontBitmap(evt:Event):void
		{
	//		trace("88");
			var bd:BitmapData = ((evt.currentTarget.loader as Loader).content as Bitmap).bitmapData;
			(this._bfd[uint((evt.currentTarget.loader as Loader).name)] as BitmapFontData).w = bd.width;
			(this._bfd[uint((evt.currentTarget.loader as Loader).name)] as BitmapFontData).h = bd.height;
			(this._bfd[uint((evt.currentTarget.loader as Loader).name)] as BitmapFontData).bitmapData = bd;
			
			this.bitfontkey++;
			if( this.bitfontkey == this.bitfontKeyNum )
			{
				//发送消息，通知视图更新bitMap
				var event:ProjectToolEvent = new ProjectToolEvent(ProjectToolEvent.LOADER_COMPLETE);
				this.dispatchEvent(event);
			}
		}

		public function get bfd():Dictionary
		{
			return _bfd;
		}

		public function get bdfvec():Vector.<uint>
		{
			return _bdfvec;
		}

		
	}
}