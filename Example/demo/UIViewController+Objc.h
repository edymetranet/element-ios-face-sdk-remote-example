//
//  UIViewController+Objc.h
//  fm-demo-public
//
//  Created by Laurent Grandhomme on 3/27/20.
//  Copyright © 2020 Element. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ElementSDK/ElementSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Objc)
- (void)remoteAuthentication:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
