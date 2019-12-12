//
//  ViewController.m
//  TouchIDAndFaceIDLogin
//
//  Created by Marco André Marinho Lopes on 04/05/2019.
//  Copyright © 2019 Marco. All rights reserved.
//

#import "ViewController.h"
#import "LAContextManager.h"
#import "KeychainItemWrapper.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Username;
@property (weak, nonatomic) IBOutlet UITextField *Password;


@property (strong,nonatomic) KeychainItemWrapper *keychainItem;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*----------------------------------------------------------------
     KeychainItemWrapper by APPLE
     ----------------------------------------------------------------*/
    
    self.keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"TouchIDAndFaceIDLogin" accessGroup:nil];

    

    NSString *user = [self.keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    
    if (user.length > 0) {
        self.Username.text = user;
        [self Login];
    }

}

- (IBAction)onLoginClick:(UIButton *)sender {
    [self checkLogin];
}

- (IBAction)resetData:(UIButton *)sender {
    [self.keychainItem resetKeychainItem];
}


- (void) checkLogin {
    if ([self.Username.text isEqualToString:@"Marco"] && [self.Password.text isEqualToString:@"Marco1904"]) {
        NSLog(@"LOGIN COM SUCESSO!");
        NSString *user = @"Marco";
        NSString *pass = @"Marco1904";
        
        //because keychain saves password as NSData object
        NSData *pwdData = [pass dataUsingEncoding:NSUTF8StringEncoding];
        
        [self.keychainItem setObject:user forKey:(__bridge id)(kSecAttrAccount)];
        [self.keychainItem setObject:pwdData forKey:(__bridge id)(kSecValueData)];
        
    }else{
        NSLog(@"ERRO NO LOGIN");
    }
}

- (void) Login{
    
    [LAContextManager callLAContextManagerWithController:self success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"success");
            
            //because label uses NSString and password is NSData object, conversion necessary
            NSData *pwdDataSaved = [self.keychainItem objectForKey:(__bridge id)(kSecValueData)];
            NSString *passwordSaved = [[NSString alloc] initWithData:pwdDataSaved encoding:NSUTF8StringEncoding];
            
            if (passwordSaved != nil) {
                self.Password.text = passwordSaved;
                self.Password.userInteractionEnabled = NO;
                [self checkLogin];
            }
            
            
        });
    } failure:^(NSError *tyError, LAContextErrorType feedType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (tyError.code == -8) {
                NSLog(@"To much attempts, Locked");
            }
            else if (tyError.code == -7) {
                NSLog(@"TouchID permission is not turned on (no fingerprint available)");
            }
            else if (tyError.code == -6) {
                NSLog(@"Non-iPhoneX phone OR the phone does not support TouchID (such as iPhone5, iPhone4s)");
            }
            else {
                NSLog(@"Other error cases, such as user cancellation, etc. ");
            }
        });
    }];
}


@end
