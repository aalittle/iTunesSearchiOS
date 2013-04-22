//
//  ALSearchViewController.h
//  iTunesSearchiOS
//
//  Created by Andrew Little on 2013-04-21.
//  Copyright (c) 2013 Andrew Little. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface ALSearchViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *mediaSearchResults;
@property (weak, nonatomic) IBOutlet UITextField *searchTermField;
@property (strong, nonatomic) RKResponseDescriptor *responseDescriptor;

@end
