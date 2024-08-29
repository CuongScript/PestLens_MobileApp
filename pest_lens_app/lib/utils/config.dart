class Config {
  static const String apiUrl = 'http://192.168.20.104:8818';
  static const String mlAPIUrl = 'http://192.168.20.104:8000';
  static const String googleSearchAPiUrl = 'https://google.serper.dev/images';
  static const String googleSearchAPIKey =
      'c18cc3946046205eea7722e8f8cf48d6df8acfe7';

  // Camera URLs
  static const String camera1APIUrl =
      'https://814bffb9b389f652.mediapackage.ap-southeast-2.amazonaws.com/out/v1/eb9c9f2cbf2f42a481d5b5d7fe1d8b2e/index.m3u8';
  static const String camera2APIUrl =
      'http://tramquantrac.shop:10001/video_feed';
  static const String camera2Token = "Noodle7532Giraffe";

  // AWS S3 Configuration
  static const String s3Region = 'ap-southeast-1';
  static const String s3Bucket = 'rmit-graduglorious';

  // Google OAuth Configuration
  static const String googleClientId =
      '693379957002-o2ko1b2qjtjkmi4gliq82u6ee1u4ubc2.apps.googleusercontent.com';
  static const String googleClientSecret =
      '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';
  // static const String redirectUri = 'http://192.168.68.62:8818';

  static const String redirectUri = 'https://2fulpo10rtwr.share.zrok.io';
  // Google OAuth Endpoints
  static const String googleAuthEndpoint =
      'https://accounts.google.com/o/oauth2/v2/auth';
  static const String googleTokenEndpoint =
      'https://oauth2.googleapis.com/token';

  // OAuth Scopes
  static const String oauthScopes = 'openid email profile';

  // Other OAuth parameters
  static const String oauthResponseType = 'code';
  static const String oauthAccessType = 'offline';
  static const String oauthIncludeGrantedScopes = 'true';
  static const String oauthState = 'state_parameter_passthrough_value';

  // Callback URL scheme for mobile apps
  static const String callbackUrlScheme =
      'com.googleusercontent.apps.693379957002-o2ko1b2qjtjkmi4gliq82u6ee1u4ubc2';
}
