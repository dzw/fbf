import com.mebius.format.fbf.FBFManage;

import fbftool.data.BitmapFontData;
import fbftool.tool.ImageSelectTool;
import fbftool.tool.ProjectTool;
import fbftool.tool.ProjectToolEvent;
import fbftool.utils.MaxRectsBinPack;
import fbftool.view.ListChangeEvent;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayList;
import mx.controls.Alert;
import mx.events.FlexEvent;
import mx.graphics.codec.PNGEncoder;
import mx.managers.PopUpManager;

import spark.events.IndexChangeEvent;



//------------------------------------------------------------------

private var _saveFile:File;
private var _fbfByte:ByteArray;


//执行算法
private function executionMacRect():void
{
	//存在图片
	if( this._projectTool.bdfvec && this._projectTool.bdfvec.length!=0 )
	{
		var rel:Boolean = true;
		var maxRect:MaxRectsBinPack = new MaxRectsBinPack(this.stageWidthL.selectedItem, this.stageHeightL.selectedItem,false);
		// insert new rectangle
		for( var i:uint = 0;i<this._projectTool.bdfvec.length; i++ )
		{
			var data:BitmapFontData = this._projectTool.bfd[this._projectTool.bdfvec[i]] as BitmapFontData;
			var rect:Rectangle = maxRect.insert(data.w,data.h,this.maxRectTypeL.selectedIndex);
			if( rect.width != 0 )
			{
				data.x = rect.x;
				data.y = rect.y;
				this.bfontStage.setBitmapFontLocation( data.id, rect );
			}
			else
			{
				//放不开了，显示红色的框
				rel = false;
				this.warningScene.show();
				break;
			}
		}
		if( rel )
		{
			this.warningScene.hide();
		}
	}
	
	
}

//-----------------



private function changeStageSize():void
{
	this.bfontStage.setStageSize( this.stageWidthL.selectedItem, this.stageHeightL.selectedItem);
	
	this._projectTool.stageWidth = this.stageWidthL.selectedItem;
	this._projectTool.stageHeight = this.stageHeightL.selectedItem;
}

protected function stageWidthL_changeHandler(event:IndexChangeEvent):void
{
	// TODO Auto-generated method stub
	changeStageSize();
	this.executionMacRect();
}

protected function stageHeightL_changeHandler(event:IndexChangeEvent):void
{
	// TODO Auto-generated method stub
	changeStageSize();
	this.executionMacRect();
}

protected function maxRectTypeL_changeHandler(event:IndexChangeEvent):void
{
	// TODO Auto-generated method stub
	this._projectTool.layout = this.maxRectTypeL.selectedItem;
	this.executionMacRect();
}

private function addScaleEvent(evt:MouseEvent):void
{
	this.bfontStage.scaleX += 0.1;
	this.bfontStage.scaleY += 0.1;
}

private function subScaleEvent(evt:MouseEvent):void
{
	this.bfontStage.scaleX -= 0.1;
	this.bfontStage.scaleY -= 0.1;
}

private function changeScaleList(evt:IndexChangeEvent):void
{
	var scaleNum:Number = 0;
	switch( this.stageScaleL.selectedIndex )
	{
		case 0:
			scaleNum = 2;
			break;
		case 1:
			scaleNum = 1;
			break;
		case 2:
			scaleNum = 0.5;
			break;
		case 3:
			scaleNum = 0.25;
			break;
		
	}
	this.bfontStage.scaleX = scaleNum;
	this.bfontStage.scaleY = scaleNum;
}


//导出FBF
protected function saveFBFFileBtn_clickHandler(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	
	if( this._projectTool.bdfvec && this._projectTool.bdfvec.length !=0 )
	{
		var fbf:FBFManage = new FBFManage();
		for( var i:int = 0;i<this._projectTool.bdfvec.length;i++ )
		{
			var data:BitmapFontData = this._projectTool.bfd[this._projectTool.bdfvec[i]] as BitmapFontData;
			fbf.addCharData( data.char, data.x, data.y, data.w, data.h );
		}
		var encoder:PNGEncoder = new PNGEncoder();
		var byte:ByteArray = encoder.encode( this.bfontStage.fontBitmapData );
		fbf.addImageData( byte );
		this._fbfByte = fbf.createFBF();
		
		this._saveFile = new File();
		this._saveFile.addEventListener(Event.SELECT, selectsqlFile);
		this._saveFile.browseForSave("请选择您要存储文件路径");
	}
	
}

private function selectsqlFile(evt:Event):void
{
	var file:File = new File( this._saveFile.url + ".fbf" );
	var stream:FileStream = new FileStream();
	stream.open( file, FileMode.WRITE );
	stream.writeBytes( this._fbfByte );
	stream.close();
}

//预览
private function previewFBFFileEvent(evt:MouseEvent):void
{
	PopUpManager.createPopUp(this, PreviewFBF, false );
}

//修改了字符,同步数据
private function myitemrenderer1_CHANG_CHARHandler(evt:ListChangeEvent):void
{
	var data:BitmapFontData = this._projectTool.bfd[this._projectTool.bdfvec[evt._id]] as BitmapFontData;
	data.char = evt._char;
	this.imageList.dataProvider.getItemAt( evt._id ).char = evt._char;
	
}

//关于按钮
protected function aboutBtn_clickHandler(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	var aboutStr:String="FBFTool\n" +
		"版本：3.0.0" +
		"\n1、增加了工程项目操作。" +
		"\n2、增加了位图资源格式限制,仅支持PNG格式图片。" +
		"\n3、增加了资源文件添加删除功能。" +
		"\n4、修复了字体预览中的逻辑BUG。" +
		"\n5、优化了部分算法。" ;
	/*+
		"\n版本：2.2.0\n" +
		"1、修正了字体预览中的UI bug。\n" +
		"2、文本字体添加了转义编码字符的支持。\n" +
		"3、改进了字体预览界面的用户体验。\n" +
		"4、字体预览功能增加了手动刷新字符和自动刷新字符功能。\n" +
		"5、调整了一些字体预览属性参数。";*/
	Alert.show(aboutStr,"关于");
}


//---------------------------------- new code --------------------------------------------

private var _projectTool:ProjectTool;
private var _imageSelectTool:ImageSelectTool;

protected function windowedapplication1_creationCompleteHandler(event:FlexEvent):void
{
	// TODO Auto-generated method stub
	var arr:Array = [1024];
	var t:uint = 1024;
	for( var i:int = 0;i<10;i++ )
	{
		t = t/2;
		arr.push( t );
	}
	var ars:ArrayList = new ArrayList(arr);
	this.stageWidthL.dataProvider = ars;
	this.stageWidthL.selectedIndex = 0;
	this.stageHeightL.dataProvider = ars;
	this.stageHeightL.selectedIndex = 0;
	
	var maxrectType:ArrayList = new ArrayList(["BestShortSideFit","BestLongSideFit","BestAreaFit","BottomLeftRule","ContactPointRule"]);
	this.maxRectTypeL.dataProvider = maxrectType;
	this.maxRectTypeL.selectedIndex = 0;
	
	this.stageScaleL.dataProvider = new ArrayList(["200%","100%","50%","25%"]);
	this.stageScaleL.selectedIndex = 1;
	
	this.warningScene.width = this.stageCon.width;
	this.warningScene.height = this.stageCon.height;
	this.warningScene.hide();
	
	this.imageList.addEventListener( ListChangeEvent.CHANG_CHAR,myitemrenderer1_CHANG_CHARHandler);
	
//	this.executionMacRect();
	
	this._projectTool = new ProjectTool();
	this._projectTool.addEventListener( ProjectToolEvent.CREATED_PRO, createdProEvent);
	this._projectTool.addEventListener( ProjectToolEvent.OPENED_PRO, openedProEvent);
	this._projectTool.addEventListener( ProjectToolEvent.LOADER_COMPLETE, imageLoaderCompleteEvent);
	
	this._imageSelectTool = new ImageSelectTool();
	this._imageSelectTool.addEventListener(Event.COMPLETE, selectImageFilesComplete_event);
	
	
	changeStageSize();
}

protected function delCharBtn_clickHandler(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	this._projectTool.delData( imageList.selectedIndex,imageList.selectedItem.id );
}

private function addCharBtnClickEvent(event:MouseEvent):void
{
	this._imageSelectTool.selectSingleFile();
}

//新建项目
private function newProjectBtnClickEvent(evt:MouseEvent):void
{
	this._projectTool.newProject();
}

private function openProjectBtnClickEvent(evt:MouseEvent):void
{
	this._projectTool.openProject();
}

private function saveProjectBtnClickEvent(evt:MouseEvent):void
{
	this._projectTool.saveProject();
}

private function openedProEvent(evt:ProjectToolEvent):void
{
	this.projectController.enabled = false;
	this.projectResController.enabled = true;
	this.projectEditController.enabled = true;
	
}

private function createdProEvent(evt:ProjectToolEvent):void
{
	this.projectController.enabled = false;
	this.projectResController.enabled = true;
	this.projectEditController.enabled = true;
	
}

protected function selectFontImageFolder(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	this._imageSelectTool.selectImageFiles();
}

//图片资源选择完成
private function selectImageFilesComplete_event(evt:Event):void
{
//	trace( this._imageSelectTool.selectFileList );
	this._projectTool.imageFileList = this._imageSelectTool.selectFileList;
	
}

//图片全部加载完成
private function imageLoaderCompleteEvent(evt:ProjectToolEvent):void
{
	this.infoLabel.text = "共选择了 "+this._projectTool.imageFileList.length+"张位图字体图片";
	this.imageList.dataProvider = new ArrayList(this._projectTool.imageFileList);
	
	var l:uint = this._projectTool.bdfvec.length;
	this.bfontStage.createFontNum( l );
	this.bfontStage.clearAll();
	
	for( var i:int = 0;i<l;i++ )
	{
		var data:BitmapFontData = this._projectTool.bfd[ this._projectTool.bdfvec[i] ] ;
		this.bfontStage.addBitmapFont( data.bitmapData, data.id );
		
	}
	
	
	this.stageWidthL.selectedIndex = sizeIndex(this._projectTool.stageWidth);
	this.stageHeightL.selectedIndex = sizeIndex(this._projectTool.stageHeight);
	this.bfontStage.setStageSize( this.stageWidthL.selectedItem, this.stageHeightL.selectedItem);
	
	this.maxRectTypeL.selectedIndex = layoutIndex(this._projectTool.layout);
	
	
	this.executionMacRect();
}

private function sizeIndex(val:Number):uint
{
	var index:uint = 0;
	switch( val )
	{
		case 1024:
			index=0;
			break;
		case 512:
			index=1;
			break;
		case 256:
			index=2;
			break;
		case 128:
			index=3;
			break;
		case 64:
			index=4;
			break;
		case 32:
			index=5;
			break;
		case 16:
			index=6;
			break;
		case 8:
			index=7;
			break;
		case 4:
			index=8;
			break;
		case 2:
			index=9;
			break;
		case 1:
			index=10;
			break;
		
	}
	return index;
}

private function layoutIndex(val:String):uint
{
	var index:uint = 0;
	
	switch( val )
	{
		case "BestShortSideFit":
			index=0;
			break;
		case "BestLongSideFit":
			index=1;
			break;
		case "BestAreaFit":
			index=2;
			break;
		case "BottomLeftRule":
			index=3;
			break;
		case "ContactPointRule":
			index=4;
			break;
		
	}
	return index;
}
