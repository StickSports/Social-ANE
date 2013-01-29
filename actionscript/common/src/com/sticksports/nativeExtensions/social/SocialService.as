package com.sticksports.nativeExtensions.social
{
	public class SocialService
	{
		public static const twitter : SocialService = new SocialService( 1 );
		
		public static const facebook : SocialService = new SocialService( 2 );

		public static const sinaWeibo : SocialService = new SocialService( 3 );
		
		internal var id : int;
		
		public function SocialService( id : int )
		{
			this.id = id;
		}
	}
}
