//
//  LAContextManager.m
//  TouchIDAndFaceIDLogin
//
//  Created by Marco André Marinho Lopes on 04/05/2019.
//  Copyright © 2019 Marco. All rights reserved.
//

#import "LAContextManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation LAContextManager

+ (void)callLAContextManagerWithController:(UIViewController *)currentVC
                                   success:(LAContext_Success)success
                                   failure:(LAContext_Failure)failure {
    
    if (![currentVC isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    NSString *message = @"Touch ID OU Face ID Para Login"; //NSLOCALIZED NO ITLOG
    NSInteger deviceType = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    LAContext *laContext = [[LAContext alloc] init];
    laContext.localizedFallbackTitle = @""; 
    NSError *error = nil;
    BOOL isSupport = [laContext canEvaluatePolicy:(deviceType) error:&error];
    
    if (isSupport) {
        
        [laContext evaluatePolicy:(deviceType) localizedReason:message reply:^(BOOL s, NSError * _Nullable error) {
            
            if (s) {
                success();
            }else {
                failure(error, LAContextErrorAuthorFailure);
            }
        }];
    }else {

        failure(error, LAContextErrorAuthorNotAccess);
    }
}


@end
