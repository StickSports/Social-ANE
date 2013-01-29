package com.sticksports.nativeExtensions.social
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;

	public class Social extends EventDispatcher
	{
// static

		public static function get isSupported() : Boolean
		{
			return false;
		}
		
		public static function isAvailableForService( service : SocialService ) : Boolean
		{
			return false;
		}

// class variables

		private var _service : SocialService;

// methods

		public function Social( service : SocialService )
		{
			_service = service;
		}
		
		public function get service() : SocialService
		{
			return _service;
		}
		
		public function setMessage( message : String ) : Boolean
		{
			return false;
		}
		
		public function addUrl( url : String ) : Boolean
		{
			return false;
		}
		
		public function clearUrls() : Boolean
		{
			return false;
		}
		
		public function addImage( image : BitmapData ) : Boolean
		{
			return false;
		}

		public function clearImages() : Boolean
		{
			return false;
		}
		
		public function launch() : Boolean
		{
			return false;
		}
	}
}

