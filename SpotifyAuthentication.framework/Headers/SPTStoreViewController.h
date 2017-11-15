/*
 Copyright 2016 Spotify AB

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <UIKit/UIKit.h>
#import <StoreKit/SKStoreProductViewController.h>

@protocol SPTStoreControllerDelegate;

/**
 A Store View Controller to allow a user to download the Spotify iOS app.
 
 To present the store controller on top of your view controller:
 
 ```
    SPTStoreViewController *storeVC = [[SPTStoreViewController alloc] initWithCampaignToken:@"your_campaign_token" storeDelegate:self];
    [self presentViewController:storeVC animated:YES completion:nil];
 ```
 */
@interface SPTStoreViewController : SKStoreProductViewController

/// The Spotify-provided campaign token. Must be less than 40-bytes.
@property (nonatomic, copy, readonly) NSString *campaignToken;

/*
 * The designated initializer. Returns an instance of `SPTStoreViewController` presenting the Spotify iOS app.
 * @param campaignToken The Spotify-provided campaign token. Must be less than 40-bytes.
 * @param storeDelegate The delegate which will be called after a dismiss action is taken in the store view controller.
 */
- (instancetype)initWithCampaignToken:(NSString *)campaignToken
                        storeDelegate:(id<SPTStoreControllerDelegate>)storeDelegate NS_DESIGNATED_INITIALIZER;

/// Unavailable, use the designated initializer.
- (instancetype)init NS_UNAVAILABLE;
/// Unavailable, use the designated initializer.
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
/// Unavailable, use the designated initializer.
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
/// Unavailable, use the designated initializer.
+ (instancetype)new NS_UNAVAILABLE;

@end


@protocol SPTStoreControllerDelegate <NSObject>

/**
 Called when the user requests the page to be dismissed. 
 
 ```
    - (void)productViewControllerDidFinish:(SPTStoreViewController *)viewController {
        [viewController dismissViewControllerAnimated:YES completion:nil];
	}
 ```
 */
- (void)productViewControllerDidFinish:(SPTStoreViewController *)viewController;

@end
