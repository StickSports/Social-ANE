package com.sticksports.nativeExtensions.social
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	public class Social extends EventDispatcher
	{
// static

		private static var staticExtensionContext : ExtensionContext;
		
		private static var _isSupported : Boolean;
		private static var _isSupportedSet : Boolean;

		public static function get isSupported() : Boolean
		{
			if( !_isSupportedSet )
			{
				if ( !staticExtensionContext )
				{
					staticExtensionContext = ExtensionContext.createExtensionContext( "com.sticksports.nativeExtensions.Social", "static" );
				}
				_isSupported = staticExtensionContext.call( "isSupported" ) as Boolean;
				_isSupportedSet = true;
			}
			return _isSupported;
		}
		
		public static function isAvailableForService( service : SocialService ) : Boolean
		{
			if( !isSupported )
			{
				return false;
			}
			return staticExtensionContext.call( "isAvailableForService", service.id ) as Boolean;
		}

// class variables

		private var extensionContext : ExtensionContext = null;

		private var _service : SocialService;

// methods

		public function Social( service : SocialService )
		{
			_service = service;
			if( !isSupported )
			{
				return;
			}
			extensionContext = ExtensionContext.createExtensionContext( "com.sticksports.nativeExtensions.Social", "object" );
			extensionContext.addEventListener( StatusEvent.STATUS, handleStatusEvent );
			var success : Boolean = extensionContext.call( "initialiseMessage", _service.id ) as Boolean;
			if( !success )
			{
				trace( "Failed to initialise social sevice" );
			}
		}
		
		private function handleStatusEvent( event : StatusEvent ) : void
		{
			trace( "StatusEvent", event.level );
			switch( event.level )
			{
				case InternalMessages.messageCancelled :
					dispatchEvent( new SocialEvent( SocialEvent.CANCELLED ) );
					break;
				case InternalMessages.messageComplete :
					dispatchEvent( new SocialEvent( SocialEvent.COMPLETE ) );
					break;
			}
		}
		
		public function get service() : SocialService
		{
			return _service;
		}
		
		public function setMessage( message : String ) : Boolean
		{
			if( !isSupported )
			{
				return false;
			}
			return extensionContext.call( "setMessage", message ) as Boolean;
		}
		
		public function addUrl( url : String ) : Boolean
		{
			if( !isSupported )
			{
				return false;
			}
			return extensionContext.call( "addUrl", url ) as Boolean;
		}
		
		public function clearUrls() : Boolean
		{
			if( !isSupported )
			{
				return false;
			}
			return extensionContext.call( "clearUrls" ) as Boolean;
		}
		
		public function addImage( image : BitmapData ) : Boolean
		{
			if( !isSupported )
			{
				return false;
			}
			return extensionContext.call( "addImage", image ) as Boolean;
		}

		public function clearImages() : Boolean
		{
			if( !isSupported )
			{
				return false;
			}
			return extensionContext.call( "clearImages" ) as Boolean;
		}
		
		public function launch() : Boolean
		{
			if( !isSupported )
			{
				return false;
			}
			return extensionContext.call( "launch" ) as Boolean;
		}
	}
}

