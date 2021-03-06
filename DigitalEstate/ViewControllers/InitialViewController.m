//
//  InitialViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 16/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "InitialViewController.h"
#import "AppDelegate.h"
#import "ConstantDefinition.h"
#import "KeyChainUtil.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void)switchViewController{
//    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
//    
//    long pass1 = [prefs integerForKey:kPassword1];
//    long pass2 = [prefs integerForKey:kPassword2];
//    long pass3 = [prefs integerForKey:kPassword3];
//    long pass4 = [prefs integerForKey:kPassword4];
//    
//    NSString* encryptKey = nil;//[prefs objectForKey:kEncryptKey];
//    
//    if (encryptKey == nil)
//    {
//        encryptKey = [KeyChainUtil loadFromKeyChainForKey:kEncryptKey];
//    }
//    
//    if (encryptKey != nil)
//    {
//        if (pass1 != 0 || pass2 != 0 || pass3 != 0 || pass4 != 0)
//        {
//            [self gotoScreen:@"SecurityPassViewController"];
//            return;
//        }
//    }
//    
//    bool welcomed = [prefs boolForKey:kWelcomed];
//    
//    if (!welcomed)
//    {
//        [self gotoScreen:@"WelcomeNavigationController"];
//        return;
//    }
//    
//    //clear all setting before configuration
//    //    [prefs removeObjectForKey:kPhoneNo];
//    //    [prefs removeObjectForKey:kDiallingCode];
//    //    [prefs removeObjectForKey:kCountryCode];
//    //    [prefs synchronize];
//    
//    [self gotoScreen:@"EstateNavigationController"];
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.5f
                         animations:^{
                             NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                             NSLog(@"language: %@", language);
                             if ([language hasPrefix:@"zh"]){
                                 _logoImageView.frame = CGRectMake(175, 75, 41, 41);
                             }
                             else{
                                 _logoImageView.frame = CGRectMake(192, 67, 41, 41);
                             }
                         }
                         completion:^(BOOL cancelled){
                             [UIView animateWithDuration:.2f
                                              animations:^{
                                                  //                                                  _logoImageView.frame = CGRectMake(192, 67, 41, 41);
                                              }
                                              completion:^(BOOL cancelled){
                                                  [self performSegueWithIdentifier:@"EstateNavigationSegue" sender:self];
                                              }
                              ];
                         }
         ];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Jump to right view

//- (void)gotoScreen:(NSString *)theScreen
//{
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    UIViewController *screen = [self.storyboard instantiateViewControllerWithIdentifier:theScreen];
//    [app.window setRootViewController:screen];
//}

@end
