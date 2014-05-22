//
//  AccountTableViewCell.m
//  DigitalEstate
//
//  Created by Yi Chen on 14/05/2014.
//  Copyright (c) 2014 Yi Chen. All rights reserved.
//

#import "AccountTableViewCell.h"
#import "AccountViewController.h"

@implementation AccountTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_nameTextField == textField || _valueTextField == textField)
    {
        UITableView* tableView = (UITableView*)self.superview.superview;
        AccountViewController* controller = (AccountViewController*)tableView.dataSource;
        NSIndexPath* indexPath = [controller.tableView indexPathForCell:self];
        [controller tableView:controller.tableView commitEditingStyle:UITableViewCellEditingStyleNone forRowAtIndexPath:indexPath];
    }
}

#pragma mark - IBAction

- (IBAction)deleteButtonClicked:(id)sender
{
    UITableView* tableView = (UITableView*)self.superview.superview;
    AccountViewController* controller = (AccountViewController*)tableView.dataSource;
    NSIndexPath* indexPath = [controller.tableView indexPathForCell:self];
    [controller tableView:controller.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
}



@end