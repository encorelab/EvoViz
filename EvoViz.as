package
{
	//This is the evoboard application for step 1 of the biodiversity run in Nov/Dec 2011
	
	import classes.Station;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	
	public class EvoViz extends Sprite
	{
		private var screen_height:Number = 768;
		private var screen_width:Number = 1024;
		private var event_debug:TextField;
		private var version_num:TextField;
		
		public static var stage_width = 1536;
		public static var stage_height = 768;
		public static var contentA:Array = ["200 mya", "25 mya", "Borneo"];
		public static var contentB:Array = ["150 mya", "10 mya", "Borneo"];
		public static var contentC:Array = ["100 mya", "5 mya", "Sumatra"];
		public static var contentD:Array = ["50 mya", "2 mya", "Sumatra"];
		public static var transitionURL:String = "swfs/transition.swf";
		public static var forestURL:String = "swfs/forest.swf";
		public static var borneoURL:String = "swfs/present_borneo.swf";
		public static var sumatraURL:String = "swfs/present_sumatra.swf";
			
		private var station:Station;
		
		public function EvoViz()
		{
			trace("instantiate EvoVis");
			event_debug = event_debug_txt;
			event_debug.text = "Waiting for event...";		
			version_num = versionNum_txt;
			version_num.text = "Feb 15, 2012 v.2";
			ExternalInterface.addCallback("sevToFlash", handleSev);
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, reportKeyDown );
		}		
		private function reportKeyDown( e:KeyboardEvent ):void
		{
			trace("e.keyCode: "+ e.keyCode);	
			if (e.keyCode == 65){ //a
				//station A
				addStation("A");
			} else if (e.keyCode == 66){//b
				//station B
				addStation("B");
			} else if (e.keyCode == 67){//c
				//station C
				addStation("C");
			} else if ( e.keyCode == 68){//d
				//station D
				addStation("D");
			} else if ( e.keyCode == 81 ){ //q
				//e.keyCode: 81
				//e.keyCode: 87
				//e.keyCode: 69
				//e.keyCode: 82
				station.loadOrientation( getSWFurl( "2 mya") );
				//station.startTransitionAnimation();
			} else if ( e.keyCode == 87 ){ //w
				//station.loadOrientation( getSWFurl( "150 mya") );
				//station.loadOrientation( getSWFurl( "150 mya") );
				station.startPresent();
			} else if ( e.keyCode == 69 ){ //e
				//station.loadRotation( 1 );
				//station.loadRotation( 2	);
			} else if ( e.keyCode == 82 ){ //e
				//addStation("A");
				
			}
		}
		private function addStation( id:String ):void
		{
			trace("add station: "+id);
			if ( station ){
				removeChild( station );
				station.resetStation();
				station = null;
			}
			station = new Station( id, getContentList(id) );
			addChild( station );
			version_num.text = "Station " + id;
		}
		//orient changes time period based on event
		//'orient', {time_period: "200 mya"}
		private function orient( eventData ):void
		{  
			event_debug.appendText("\n" + "Start orientation for "+ eventData.time_period );
			station.loadOrientation( getSWFurl( eventData.time_period )  );
		}
		//'observations_start', {rotation: 1}
		private function observations_start( eventData ):void
		{  	
			event_debug.appendText("\n" + "Start rotation: "+ eventData.rotation );
			station.loadRotation( eventData.rotation );
		}
		private function transition_animation( eventData ):void
		{  	
			event_debug.appendText("\n" + "Start transition" );
			station.startTransitionAnimation();
		}
		private function transition_to_present( eventData ):void
		{  	
			event_debug.appendText("\n" + "Start Borneo/Sumatra");
			station.startPresent();
		}
		private function brainstorming( eventData ):void
		{  	
			event_debug.appendText("\n" + "Start discussion for "+ eventData.time_period );
			station.loadOrientation( getSWFurl( eventData.time_period )  );
		}
		private function handleSev(eventType, eventData):void 
		{
			//trace(eventType);
			//trace(eventData);
			event_debug.appendText("\n"+"handleSev: "+eventType+", "+eventData);

			switch(eventType) {
				// add handlers for events here (one for each type of event)
				case "orient":
					orient(eventData);
					break;
				case "observations_start":
					observations_start(eventData); 
					break;
				case "transition_animation":
					transition_animation(eventData); 
					break;
				case "transition_to_present":
					transition_to_present(eventData); 
					break;
				case "brainstorming":
					brainstorming(eventData); 
					break;
				default:
					trace("Unrecognized event received: "+eventType);
			}
		}
		private function getContentList( station_id:String ):Array
		{
			var content_list:Array = new Array();
			
			switch ( station_id ) {
				case "A":
					content_list = EvoViz.contentA;
					break;
				case "B":
					content_list = EvoViz.contentB;
					break;
				case "C": 
					content_list = EvoViz.contentC;
					break;
				case "D":
					content_list = EvoViz.contentD;
					break;
				default:
					content_list = ["error"];
					trace( "Unrecognized station id received: " + station_id );
			}
			return content_list;
		}
		private function getSWFurl( time_period:String ):String
		{			
			var url:String = "swfs/" + stripspaces( time_period ) + ".swf";
			return url;
		}
		private function stripspaces( originalstring:String ):String
		{
			var original:Array = originalstring.split(" ");
			return(original.join(""));
		}
	}
}




