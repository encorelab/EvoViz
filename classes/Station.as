package classes
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Station extends MovieClip
	{
		private var stationID:String; //A, B, C, D	
		private var contentList:Array;
		private var contentHolder:MovieClip;
		private var swfMask:Sprite;
		private var stationState:String;
		
		public function Station( station_id:String, content_list:Array )		
		{
			stationID = station_id;			
			contentList = content_list;
			setupContentHolder();
			trace("instatiate Station: "+ stationID );
		}
		public function loadOrientation( swf_url:String ):void
		{
			stationState = "orientation";
			startLoad( swf_url );
		}
		public function loadRotation( rotation_num:uint ):void 
		{
			stationState = "rotation";
			var swfName:String = contentList[rotation_num - 1]; 
			startLoad( getSWFurl(swfName) );
		}
		public function startTransitionAnimation():void
		{
			stationState = "transition";
			if ( stationID == "C"){
				startLoad( EvoViz.transitionURL );				
			} else {
				startLoad( EvoViz.forestURL );
			}
		}
		public function startPresent():void
		{
			stationState = "present";
			if ( stationID == "A" || stationID == "B"){
				startLoad( EvoViz.borneoURL );				
			} else if ( stationID == "C" || stationID == "D"){
				startLoad( EvoViz.sumatraURL );
			}
		}
		private function setupContentHolder():void
		{
			contentHolder = new MovieClip();
			addChild( contentHolder );

			swfMask = new Sprite();
			addChild( swfMask );
			swfMask.graphics.beginFill(0x0000FF);
			swfMask.graphics.drawRect(0, 0, EvoViz.stage_width, EvoViz.stage_height);
			swfMask.graphics.endFill();
			contentHolder.mask = swfMask;
		}
		//***SWF LOADING MECHANISM 
		private function startLoad( url:String )
		{
			clearContent();
			trace("url: "+ url);
			var mLoader:Loader = new Loader();
			var mRequest:URLRequest = new URLRequest( url );
			mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			mLoader.load(mRequest);
		}
		private function onCompleteHandler(loadEvent:Event)
		{
			contentHolder.addChild(loadEvent.currentTarget.content);
			if ( stationState == "present" ){
				if( stationID == "A" || stationID == "C" ){
					//do nothing
				} else if ( stationID == "B" || stationID == "D" ){
					var swf:* = contentHolder.getChildAt( contentHolder.numChildren-1 );
					swf.x = -1536;
				}
			}
		}
		private function onProgressHandler(mProgress:ProgressEvent)
		{
			var percent:Number = mProgress.bytesLoaded/mProgress.bytesTotal;
			trace(percent);
		}
		private function clearContent():void
		{
		
			if ( contentHolder.numChildren > 0 ){
				var num:Number = contentHolder.numChildren-1
	
				for ( var i:uint=0; i < num; i++ ){
					contentHolder.removeChildAt( i );
					trace( "cleared child "+i);
				}
			}
		}
		public function resetStation():void
		{
			//trace( "reset station " + stationID );
			clearContent();
		}
		//same function as in EvoViz, refactor?
		private function getSWFurl( swf_name:String ):String
		{			
			var url:String = "swfs/" + stripspaces( swf_name ) + ".swf";
			return url;
		}
		private function stripspaces( originalstring:String ):String
		{
			var original:Array = originalstring.split(" ");
			return(original.join(""));
		}
		/*
		200 mya	 station A
		150 mya	 station B
		100 mya	 station C
		50 mya	 station D
		25 mya	 station A
		10 mya	 station B
		5 mya	 station C
		2 mya	 station D
		Present day - Borneo 1	station A
		Present day - Borneo 2	station B
		Present day - Sumatra 1	station C
		Present day - Sumatra 2	station D
		*/
	}
}