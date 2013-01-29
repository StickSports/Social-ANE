package com.sticksports.nativeExtensions.social
{
	import flash.events.Event;

	public class SocialEvent extends Event
	{
		public static const COMPLETE : String = "SocialEvent.COMPLETE";
		public static const CANCELLED : String = "SocialEvent.CANCELLED";		

		public function SocialEvent( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		override public function clone() : Event
		{
			return new SocialEvent( type, bubbles, cancelable );
		}
	}
}
