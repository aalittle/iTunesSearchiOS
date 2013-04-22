//
//  ALSearchViewController.h
//  iTunesSearchiOS
//
//  Created by Andrew Little on 2013-04-21.
//  Copyright (c) 2013 Andrew Little. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@protocol TableSelectorDelegate <NSObject>

@optional
- (void)didMakeSelectionWithTitle:(NSString *)mediaTitle;
@end

@interface ALSearchViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id<TableSelectorDelegate> delegate;

@end
