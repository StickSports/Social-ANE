package
{
	import com.sticksports.nativeExtensions.social.Social;
	import com.sticksports.nativeExtensions.social.SocialEvent;
	import com.sticksports.nativeExtensions.social.SocialService;

	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	[SWF(width='320', height='480', frameRate='30', backgroundColor='#000000')]
	
	public class SocialTest extends Sprite
	{
		private var direction : int = 1;
		private var shape : Shape;
		private var feedback : TextField;
		
		private var buttonFormat : TextFormat;
		
		private var social : Social;
		
		public function SocialTest()
		{
			shape = new Shape();
			shape.graphics.beginFill( 0x666666 );
			shape.graphics.drawCircle( 0, 0, 100 );
			shape.graphics.endFill();
			shape.x = 0;
			shape.y = 240;
			addChild( shape );
			
			feedback = new TextField();
			var format : TextFormat = new TextFormat();
			format.font = "_sans";
			format.size = 16;
			format.color = 0xFFFFFF;
			feedback.defaultTextFormat = format;
			feedback.width = 320;
			feedback.height = 270;
			feedback.x = 10;
			feedback.y = 210;
			feedback.multiline = true;
			feedback.wordWrap = true;
			feedback.text = "Hello";
			addChild( feedback );
			
			createButtons();
			
			addEventListener( Event.ENTER_FRAME, animate );
			addEventListener( Event.ENTER_FRAME, init );
		}
		
		private function init( event : Event ) : void
		{
			removeEventListener( Event.ENTER_FRAME, init );
		}
		
		private function createButtons() : void
		{
			var tf : TextField;
			
			tf = createButton( "isSupported" );
			tf.x = 10;
			tf.y = 10;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, isSupported );
			addChild( tf );
			
			tf = createButton( "TwitterAvailable" );
			tf.x = 10;
			tf.y = 50;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, twitterIsAvailable );
			addChild( tf );
			
			tf = createButton( "FacebookAvailable" );
			tf.x = 170;
			tf.y = 50;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, facebookIsAvailable );
			addChild( tf );
			
			tf = createButton( "createTwitter" );
			tf.x = 10;
			tf.y = 90;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, createTwitter );
			addChild( tf );
			
			tf = createButton( "createFacebook" );
			tf.x = 170;
			tf.y = 90;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, createFacebook );
			addChild( tf );
			
			tf = createButton( "setMessage" );
			tf.x = 10;
			tf.y = 130;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, setMessage );
			addChild( tf );
			
			tf = createButton( "addUrl" );
			tf.x = 170;
			tf.y = 130;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, addUrl );
			addChild( tf );
			
			tf = createButton( "addImage" );
			tf.x = 10;
			tf.y = 170;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, addImage );
			addChild( tf );
			
			tf = createButton( "launch" );
			tf.x = 170;
			tf.y = 170;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, launch );
			addChild( tf );
		}
		
		private function createButton( label : String ) : TextField
		{
			if( !buttonFormat )
			{
				buttonFormat = new TextFormat();
				buttonFormat.font = "_sans";
				buttonFormat.size = 14;
				buttonFormat.bold = true;
				buttonFormat.color = 0xFFFFFF;
				buttonFormat.align = TextFormatAlign.CENTER;
			}
			
			var textField : TextField = new TextField();
			textField.defaultTextFormat = buttonFormat;
			textField.width = 140;
			textField.height = 30;
			textField.text = label;
			textField.backgroundColor = 0xCC0000;
			textField.background = true;
			textField.selectable = false;
			textField.multiline = false;
			textField.wordWrap = false;
			return textField;
		}
				
		private function isSupported( event : MouseEvent ) : void
		{
			feedback.text = ( "Social.isSupported - " + Social.isSupported );
		}
				
		private function twitterIsAvailable( event : MouseEvent ) : void
		{
			feedback.appendText( "\nSocial.isAvailableForService( SocialService.twitter ) - " + Social.isAvailableForService( SocialService.twitter ) );
		}
				
		private function facebookIsAvailable( event : MouseEvent ) : void
		{
			feedback.appendText( "\nSocial.isAvailableForService( SocialService.facebook ) - " + Social.isAvailableForService( SocialService.facebook ) );
		}
		
		private function createTwitter( event : MouseEvent ) : void
		{
			if( social )
			{
				removeSocialListeners( social );
			}
			feedback.appendText( "\nnew Social( SocialService.twitter );" );
			social = new Social( SocialService.twitter );
			setSocialListeners( social );
		}
		
		private function createFacebook( event : MouseEvent ) : void
		{
			feedback.appendText( "\nnew Social( SocialService.facebook );" );
			social = new Social( SocialService.facebook );
		}
		
		private function setMessage( event : MouseEvent ) : void
		{
			feedback.appendText( "\nsocial.setMessage( \"A test message\" ) - " + social.setMessage( "A test message" ) );
		}
		
		private function addUrl( event : MouseEvent ) : void
		{
			feedback.appendText( "\nsocial.addUrl( \"http://www.sticksports.com/\" ) - " + social.addUrl( "http://www.sticksports.com/" ) );
		}
		
		private function addImage( event : MouseEvent ) : void
		{
			var shape : Shape = new Shape();
			shape.graphics.beginFill( 0x0000FF, 1 );
			shape.graphics.drawCircle( 100, 100, 100 );
			shape.graphics.endFill();
			var bmp : BitmapData = new BitmapData( 200, 200 );
			bmp.draw( shape );
			feedback.appendText( "\nsocial.addImage( bmp ) - " + social.addImage( bmp ) );
		}
		
		private function launch( event : MouseEvent ) : void
		{
			feedback.appendText( "\nsocial.launch() - " + social.launch() );
		}
		
		private function setSocialListeners( social : Social ) : void
		{
			social.addEventListener( SocialEvent.CANCELLED, eventReceived );
			social.addEventListener( SocialEvent.COMPLETE, eventReceived );
		}
		
		private function removeSocialListeners( social : Social ) : void
		{
			social.removeEventListener( SocialEvent.CANCELLED, eventReceived );
			social.removeEventListener( SocialEvent.COMPLETE, eventReceived );
		}
		
		private function eventReceived( event : SocialEvent ) : void
		{
			feedback.appendText( "\n  " + event.type );
		}
				
		private function animate( event : Event ) : void
		{
			shape.x += direction;
			if( shape.x <= 0 )
			{
				direction = 1;
			}
			if( shape.x > 320 )
			{
				direction = -1;
			}
		}
	}
}