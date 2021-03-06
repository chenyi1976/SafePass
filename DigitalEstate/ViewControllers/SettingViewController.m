//
//  SettingViewController.m
//  DigitalEstate
//
//  Created by Yi Chen on 29/04/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "SettingViewController.h"
#import "ConstantDefinition.h"
#import "DataSourceFactory.h"
#import "LTHPasscodeViewController.h"
#import "AttributeData.h"
#import "PassworldIAPHelper.h"
#import "iToast.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        
    int threshold = (int)[LTHPasscodeViewController timerDuration];
    
    if (threshold <= 0)
    {
        [_pinThresholdButton setTitle:NSLocalizedString(@"Auto Lock Immediately", @"") forState:UIControlStateNormal];
    }
    else if (threshold < 60)
    {
        NSString* title = [NSString stringWithFormat: @"Auto Lock After %d Seconds", threshold];
        [_pinThresholdButton setTitle:NSLocalizedString(title, @"") forState:UIControlStateNormal];
    }
    else
    {
        NSString* title = [NSString stringWithFormat: @"Auto Lock After %d Minutes", threshold / 60];
        [_pinThresholdButton setTitle:NSLocalizedString(title, @"") forState:UIControlStateNormal];
    }
    
    if (![LTHPasscodeViewController doesPasscodeExist])
    {
//        [[self.tableView headerViewForSection:0].textLabel setText:NSLocalizedString(@"Security PIN: OFF", @"")];
        [_switchPasswordButton setTitle:NSLocalizedString(@"Turn Security PIN On", @"") forState:UIControlStateNormal];
        _updatePasswordButton.enabled = FALSE;
        _pinThresholdButton.enabled = FALSE;
    }
    else
    {
//        [[self.tableView headerViewForSection:0].textLabel setText:NSLocalizedString(@"Security PIN: ON", @"")];
        [_switchPasswordButton setTitle:NSLocalizedString(@"Turn Security PIN Off", @"") forState:UIControlStateNormal];
        _updatePasswordButton.enabled = TRUE;
        _pinThresholdButton.enabled = TRUE;
    }
    
//    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
//    NSString* datasourceType = [prefs stringForKey:kDatasourceType];
//    DBAccount* account = [[DBAccountManager sharedManager] linkedAccount];
//    _dropboxSyncSwitch.on = [@"Dropbox" isEqualToString:datasourceType] && account != nil;
    
    if ([[PassworldIAPHelper sharedInstance] productPurchased:iap_id_pro]){
        [_upgradeButton setTitle:NSLocalizedString(@"Pro User", @"") forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        if (![LTHPasscodeViewController doesPasscodeExist])
        {
            return NSLocalizedString(@"Security PIN: OFF", @"");
        }
        else
        {
            return NSLocalizedString(@"Security PIN: ON", @"");
        }
    }
        
    return [super tableView:tableView titleForHeaderInSection:section];
}

#pragma mark Mail Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    long threshold = -1;
    if (buttonIndex == 0)
    {
        threshold = 0;
    }
    else if (buttonIndex == 1)
    {
        threshold = 5;
    }
    else if (buttonIndex == 2)
    {
        threshold = 15;
    }
    else if (buttonIndex == 3)
    {
        threshold = 60;
    }
    else if (buttonIndex == 4)
    {
        threshold = 300;
    }
    else if (buttonIndex == 5)
    {
        threshold = 600;
    }
    else
    {
        //user cancelled
        return;
    }

    [LTHPasscodeViewController saveTimerDuration:threshold];
//    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setInteger:threshold forKey:kPinThreshold];
//    [prefs synchronize];

    if (threshold <= 0)
    {
        [_pinThresholdButton setTitle:NSLocalizedString(@"Immediately", @"") forState:UIControlStateNormal];
    }
    else if (threshold < 60)
    {
        NSString* title = [NSString stringWithFormat: @"Auto Lock After %ld Seconds", threshold];
        [_pinThresholdButton setTitle:NSLocalizedString(title, @"") forState:UIControlStateNormal];
    }
    else
    {
        NSString* title = [NSString stringWithFormat: @"Auto Lock After %ld Minutes", threshold / 60];
        [_pinThresholdButton setTitle:NSLocalizedString(title, @"") forState:UIControlStateNormal];
    }
}

#pragma mark IBAction

- (IBAction)switchPasscodeButtonTouched:(id)sender
{
    if ([LTHPasscodeViewController doesPasscodeExist]) {
        [[LTHPasscodeViewController sharedUser] showForDisablingPasscodeInViewController:self asModal:NO];
    }
    else {
        [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self asModal:NO];
    }
}

- (IBAction)switchSyncButtonTouched:(id)sender
{
//    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
//    if (_dropboxSyncSwitch.on)
//    {
//        DBAccount* account = [[DBAccountManager sharedManager] linkedAccount];
//
//        [prefs setObject:@"Dropbox" forKey:kDatasourceType];
//        [prefs synchronize];
//
//        if (account)
//        {
//            NSLog(@"App already linked");
//
//            [[DataSourceFactory getDataSource] updateDataStrategy];
//        }
//        else
//        {
//            [[DBAccountManager sharedManager] linkFromController:self];
//
//            //comment following line, because this will happen in app delegate.
////            [[DataSourceFactory getDataSource] updateDataStrategy];
//        }
//    }
//    else
//    {
//        [prefs removeObjectForKey:kDatasourceType];
//        [prefs synchronize];
//        [[DataSourceFactory getDataSource] updateDataStrategy];
//    }
}

- (IBAction)updatePasscodeButtonTouched:(id)sender {
    if ([LTHPasscodeViewController doesPasscodeExist]) {
        [[LTHPasscodeViewController sharedUser] showForChangingPasscodeInViewController:self asModal:NO];
    }
}

- (IBAction)pinThresholdButtonTouched:(id)sender {
    
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Auto Lock", @"")
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:NSLocalizedString(@"Immediately", @""), NSLocalizedString(@"5 seconds", @""), NSLocalizedString(@"15 seconds", @""), NSLocalizedString(@"1 minute", @""), NSLocalizedString(@"5 minutes", @""), NSLocalizedString(@"10 minutes", @""), nil];
    [sheet showInView:self.view];
}

- (IBAction)upgradeButtonTouched:(id)sender {
    
    if ([[PassworldIAPHelper sharedInstance] productPurchased:iap_id_pro]){
        [_upgradeButton setTitle:NSLocalizedString(@"Pro User", @"") forState:UIControlStateNormal];
        return;
    }
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    [view setTag:103];
//    [view setBackgroundColor:[UIColor blackColor]];
//    [view setAlpha:0.8];
//    [self.view addSubview:view];
//    
//    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
//    [activityIndicator setCenter:view.center];
//    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
//    [view addSubview:activityIndicator];
//    
//    [activityIndicator startAnimating];

    [[PassworldIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
//        [activityIndicator stopAnimating];
//        [activityIndicator removeFromSuperview];
//        UIView *view = (UIView *)[self.view viewWithTag:103];
//        [view removeFromSuperview];

        if (products == nil || [products count] == 0){
            [[iToast makeText:NSLocalizedString(@"Error: IAP not avaiable, please retry.", @"")] show];
        }
        else{
            [[PassworldIAPHelper sharedInstance] buyProduct:[products lastObject]];
        }
    }];
}

- (IBAction)restoreButtonTouched:(id)sender {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    [view setBackgroundColor:[UIColor blackColor]];
//    [view setAlpha:0.8];
//    [self.view addSubview:view];
//    
//    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
//    [activityIndicator setCenter:view.center];
//    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
//    [view addSubview:activityIndicator];
//    
//    [activityIndicator startAnimating];
    
    [[PassworldIAPHelper sharedInstance] restoreCompletedTransactions];

//    [activityIndicator stopAnimating];
//    [activityIndicator removeFromSuperview];
//    [view removeFromSuperview];
//
//    if ([[PassworldIAPHelper sharedInstance] productPurchased:iap_id_pro]){
//        [[iToast makeText:NSLocalizedString(@"Thanks for upgrading", @"")] show];
//        [_upgradeButton setTitle:NSLocalizedString(@"Pro User", @"") forState:UIControlStateNormal];
//        return;
//    }
}

- (void)productPurchased:(NSNotification *)notification {
    if ([[PassworldIAPHelper sharedInstance] productPurchased:iap_id_pro]){
        [[iToast makeText:NSLocalizedString(@"Thanks for upgrading", @"")] show];
        [_upgradeButton setTitle:NSLocalizedString(@"Pro User", @"") forState:UIControlStateNormal];
    }
}

- (IBAction)exportButtonTouched:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Passworld Export"];
//        [mail setToRecipients:@[@"passworld@chenyi.me"]];
        
        NSMutableString* message = [[NSMutableString alloc] init];
        [message appendString:@"# Passworld\n"];
        NSArray* estates = [DataSourceFactory getDataSource].estatesByName;
        for (EstateData* data in estates){
            [message appendString:[NSString stringWithFormat:@"- %@\n", data.name]];
            for (AttributeData* attrData in data.attributeValues){
                [message appendString:[NSString stringWithFormat:@"+ Name:%@, Value:%@\n", attrData.attrName, attrData.attrValue]];
            }
            [message appendString:@"---\n"];
        }
        [mail setMessageBody:message isHTML:FALSE];
        
        [self presentViewController:mail animated:NO completion:^(void){
            //for security reason, user have to enter passcode before export.
            if ([LTHPasscodeViewController doesPasscodeExist])
                if ([LTHPasscodeViewController didPasscodeTimerEnd])
                    [[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:NO
                                                                             withLogout:NO
                                                                         andLogoutTitle:nil];
        }];
    }
    else
    {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert"  message:@"This device cannot send email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"This device cannot send email");
    }
}

- (IBAction)mailButtonTouched:(id)sender{
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Passworld Support"];
        [mail setToRecipients:@[@"passworld@chenyi.me"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert"  message:@"This device cannot send email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

        NSLog(@"This device cannot send email");
    }
}

- (IBAction)urlButtonTouched:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://github.com/chenyi1976/Passworld/"]];
}


@end
