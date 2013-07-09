#FBF Format File

##What's the FBF Format File

FBF文件全称为Flash Bitmap Font ，顾名思义，就是将位图作为字体文件。


##FBF Format File Data

###Header部分
	数据头
	FBF        4字节 uint 0x464246 "FBF"的ASCII编码
	version    2字节 int      1     版本号

	字符索引数据段
	type       2字节 int      0     始终为0，表示当前数据为 字符索引数据段
	index_pos  4字节 uint     n     字符索引数据的起始下标
	num block  4字节 uint     n     字符表的数量

	png图片数据属性数据段
	type       2字节 int      1      始终为1，表示当前数据为 png图片数据属性数据段
	index_png  4字节 uint     n      png图片数据起始点

###字符索引数据数据表
	str        n字符 UTF-8编码        字符内容
	X          4字符 float单精度浮点数 X坐标
	Y          4字符 float单精度浮点数 Y坐标
	W          4字符 float单精度浮点数 宽度
	H          4字符 float单精度浮点数 高度

###PNG图片数据
	图片仅为一张，使用MaxRect算法生成，所有数据均无小数点，正整数

##如何使用库

###AS3版本

首先引入需要的类
```ActionScript3
	import com.mebius.format.fbf.FBFErrorEvent;
	import com.mebius.format.fbf.FBFManage;
```

创建一个FBFManage对象，并初始化
```ActionScript3
	private var _fontM:FBFManage ;
	this._fontM = new FBFManage();

	this._fontM.addEventListener( FBFErrorEvent.SYSTEM_IO_ERROR, fbfError1_event);
	this._fontM.addEventListener( FBFErrorEvent.FILE_NOT_FOUND, fbfError2_event);
	this._fontM.addEventListener( FBFErrorEvent.FILE_TYPE_ERROR, fbfError3_event);
	this._fontM.addEventListener( FBFErrorEvent.VERSION_UNRECOGNIZED_ERROR, fbfError4_event);
	this._fontM.addEventListener( FBFErrorEvent.FILE_CORRUPTION_ERROR, fbfError5_event);
	this._fontM.addEventListener( FBFErrorEvent.IMAGE_DATA_CORRUPTION_ERROR, fbfError6_event);
	this._fontM.addEventListener( FBFErrorEvent.CHAR_NOT_FOUND, fbfError7_event);
```

读取指定的FBF文件
```ActionScript3
	this._fontM.readFBF( File.applicationDirectory.nativePath+"/myFBF_file.fbf" );
```

字体的使用，通过FBFFontManage字体管理类来对加载的FBF字体文件进行使用
```ActionScript3
	private var _fbfFontManage:FBFFontManage;
	this._fbfFontManage = new FBFFontManage();
	this._fbfFontManage.addEventListener( Event.COMPLETE, fontInitComplete );
	this._fbfFontManage.setFBF("自定义字体名称",this._fontM );
```
