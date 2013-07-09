package fbftool.view
{
	import flash.display.Shape;
	
	import mx.core.UIComponent;

	public class WarningView extends UIComponent
	{
		private var scene:Shape;
		
		public function WarningView()
		{
			this.init();
		}
		
		public function hide():void
		{
			this.visible = false;
		}
		
		public function show():void
		{
			this.visible = true;
			
		}
		
		private function init():void
		{
			this.scene = new Shape();
			this.scene.graphics.beginFill(0xff0000,0.5);
			this.scene.graphics.drawRect(0,0,100,100);
			this.scene.graphics.beginFill(0xff0000);
			this.scene.graphics.drawCircle(50,50,40);
			this.scene.graphics.lineStyle(14,0xffffff);
			this.scene.graphics.moveTo(50,30);
			this.scene.graphics.lineTo(50,55);
			this.scene.graphics.lineStyle(0,0xffffff);
			this.scene.graphics.beginFill(0xffffff);
			this.scene.graphics.drawCircle(50,75,7);
			this.scene.graphics.endFill();
			this.addChild( scene );
			
		}
		
		public override function set width(val:Number):void
		{
			super.width = val;
			this.scene.width = val;
			
		}
		
		public override function set height(val:Number):void
		{
			super.height = val;
			this.scene.height = val;
			
		}
	}
}