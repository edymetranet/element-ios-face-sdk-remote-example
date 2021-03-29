//
//  UIViewController+Objc.m
//  fm-demo-public
//
//  Created by Laurent Grandhomme on 3/27/20.
//  Copyright © 2020 Element. All rights reserved.
//

#import "UIViewController+Objc.h"

@implementation UIViewController (Objc)

- (void)remoteAuthentication:(NSString *)userId {
#if !(TARGET_IPHONE_SIMULATOR)
    [ElementSDKConfiguration shared].faceAntiSpoofingType = ELTFaceAntiSpoofingPassive;
    
    RemoteFaceAuthenticationViewController *vc = [[RemoteFaceAuthenticationViewController alloc] initWithAsyncVerifyBlock:^(NSArray<TaggedImage *> *  images, NSNumber *  latitude, NSNumber *  longitude, NSDictionary *logs, FaceMatchingResultBlock resultCallBack) {
        for (TaggedImage *cornerImage in images) {
            NSLog(@"img: %@", [cornerImage.data base64EncodedStringWithOptions:0]);
        }
        FaceMatchingResult *res = [FaceMatchingResult new];
        res.verified = YES;
        resultCallBack(res);
        // TODO: notify caller
    } onAuthentication:^(UIViewController * viewController, CGFloat confidenceScore) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
        // TODO: notify caller
    } onEarlyExit:^(UIViewController * viewController, ELTEarlyExitReason reason) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
        // TODO: notify caller
    }];
    vc.showAuthenticationSuccessScreen = NO;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window.rootViewController presentViewController:vc animated:YES completion:nil];
#endif // simulator
}

@end
