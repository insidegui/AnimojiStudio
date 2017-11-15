//
//  Spotify Authentication Framework.h
//  Spotify Authentication Framework
//
//  Created by Dmytro Ankudinov on 26/09/16.
//  Copyright © 2016 Spotify AB. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for Spotify Authentication Framework.
FOUNDATION_EXPORT double SpotifyAuthenticationVersionNumber;

//! Project version string for Spotify Authentication Framework.
FOUNDATION_EXPORT const unsigned char SpotifyAuthenticationVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SpotifyAuthentication/PublicHeader.h>

#import <SpotifyAuthentication/SPTAuth.h>
#import <SpotifyAuthentication/SPTSession.h>

#if TARGET_OS_IPHONE
#import <SpotifyAuthentication/SPTConnectButton.h>
#import <SpotifyAuthentication/SPTAuthViewController.h>
#import <SpotifyAuthentication/SPTStoreViewController.h>
#import <SpotifyAuthentication/SPTEmbeddedImages.h>
#endif


