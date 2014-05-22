//
//  RecordViewController.h
//  DigitalEstate
//
//  Created by Yi Chen on 13/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstateData.h"
#import "DetailViewController.h"

@interface AccountViewController : DetailViewController<UITableViewDataSource, UITextFieldDelegate>

@property IBOutlet UITextField* nameTextField;
@property IBOutlet UITableView* tableView;
@property IBOutlet UIButton* deleteButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)okButtonTouched:(id)sender;
- (IBAction)addLineButtonTouched:(id)sender;
- (IBAction)deleteButtonTouched:(id)sender;

@end