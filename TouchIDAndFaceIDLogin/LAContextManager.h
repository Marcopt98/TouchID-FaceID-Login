//
//  LAContextManager.h
//  TouchIDAndFaceIDLogin
//
//  Created by Marco André Marinho Lopes on 04/05/2019.
//  Copyright © 2019 Marco. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LAContextErrorType) {
    LAContextErrorAuthorFailure   = 0,
    LAContextErrorAuthorNotAccess = 1,  
};

typedef void(^LAContext_Success)(void);
typedef void(^LAContext_Failure)(NSError *tyError, LAContextErrorType feedType);

@interface LAContextManager : NSObject

+ (void)callLAContextManagerWithController:(UIViewController *)currentVC
                                   success:(LAContext_Success)success
                                   failure:(LAContext_Failure)failure;

@end
