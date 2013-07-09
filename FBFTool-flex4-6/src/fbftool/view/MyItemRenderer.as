package fbftool.view
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.supportClasses.ItemRenderer;
	
	[Event(name="CHANG_CHAR", type="fbftool.view.ListChangeEvent")]
	
	public class MyItemRenderer extends ItemRenderer
	{
		private var simg:Image;
		private var slabel:Label;
		private var stextInput:TextInput;
		
		public function MyItemRenderer()
		{
			super();
			init();
		}
		
		private function init():void
		{
			this.height = 40;
			
			this.simg = new Image();
			this.simg.y = 5;
			this.simg.width = 30;
			this.simg.height = 30;
			this.addElement( this.simg );
			//
			this.slabel = new Label();
			this.slabel.x = 35;
			this.slabel.y = 15;
		//	this.slabel.height = 30;
			this.addElement( this.slabel );
			this.slabel.doubleClickEnabled = true;
			this.slabel.addEventListener(MouseEvent.DOUBLE_CLICK, labelDoubleEvent);
			//
			this.stextInput = new TextInput();
			this.stextInput.x = 31;
			this.stextInput.y = 9;//(40-this.stextInput.height)/2;
//			this.stextInput.height=30;
			this.stextInput.visible = false;
			this.addElement( this.stextInput );
			this.stextInput.addEventListener(Event.CHANGE, changeTextEvent);
			this.stextInput.addEventListener(KeyboardEvent.KEY_DOWN,textKeyDownEvent);
			this.stextInput.addEventListener(FocusEvent.FOCUS_OUT, outFocuEvent);
		}
		
		override public function set data(value:Object):void {
	//		trace(this.itemIndex);
			var str:String = String(value.char);
			//itemIndex
	/*		var arr:Array = str.split("/");
			str = (arr[arr.length-1] as String).split(".")[0];
			this.slabel.text = str;
			this.stextInput.text = str;
			*/
			this.slabel.text = str;
			this.stextInput.text = str;
			//		txt.text = String(value);
			simg.source = String(value.fileurl);
		}
		
		private function labelDoubleEvent(evt:MouseEvent):void
		{
			this.slabel.visible = false;
			this.stextInput.visible = true;
		}
		
		private function changeTextEvent(evt:Event):void
		{
			this.slabel.text = this.stextInput.text;
		}
		
		private function textKeyDownEvent(evt:KeyboardEvent):void
		{
			if( evt.charCode == 13 )
			{
				this.slabel.visible = true;
				this.stextInput.visible = false;
				disEvent();
			}
		}
		private function outFocuEvent(evt:FocusEvent):void
		{
			this.slabel.visible = true;
			this.stextInput.visible = false;
			disEvent();
		}
		
		private function disEvent():void
		{
			var evt:ListChangeEvent = new ListChangeEvent(ListChangeEvent.CHANG_CHAR,true);
			evt._id = this.itemIndex;
			evt._char = this.slabel.text;
			this.dispatchEvent(evt);
		}
		
	}
}