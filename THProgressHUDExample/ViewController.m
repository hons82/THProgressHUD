//
//  ViewController.m
//  THProgressHUDExample
//
//  Created by Hannes Tribus on 13/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "ViewController.h"

#import "THProgressHUD.h"

@interface ViewController ()
{
    NSMutableArray *items;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"THProgressHUDExample";
    
    items = [[NSMutableArray alloc] init];
    [items addObject:@"Dismiss HUD"];
    [items addObject:@"No text"];
    [items addObject:@"Some text"];
    [items addObject:@"Long text"];
    [items addObject:@"Success with text"];
    [items addObject:@"Success without text"];
    [items addObject:@"Error with text"];
    [items addObject:@"Error without text"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 2;
    if (section == 1) return [items count];
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) return [tableView dequeueReusableCellWithIdentifier:@"editableCell"];
        if (indexPath.row == 1) return [self tableView:tableView cellWithText:@"Dismiss Keyboard"];
    }
    if (indexPath.section == 1) {
        return [self tableView:tableView cellWithText:items[indexPath.row]];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellWithText:(NSString *)text {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.textLabel.text = text;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [self.view endEditing:YES];
        }
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: [THProgressHUD dismiss]; break;
            case 1: [THProgressHUD show:nil]; break;
            case 2: [THProgressHUD show:@"Please wait..."]; break;
            case 3: [THProgressHUD show:@"Please wait. We need some more time to work out this situation."]; break;
            case 4: [THProgressHUD showSuccess:@"That was great!"]; break;
            case 5: [THProgressHUD showSuccess:nil]; break;
            case 6: [THProgressHUD showError:@"Something went wrong."]; break;
            case 7: [THProgressHUD showError:nil]; break;
        }
    }
}

@end
