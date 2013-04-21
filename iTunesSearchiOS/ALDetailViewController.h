//
//  ALDetailViewController.h
//  iTunesSearchiOS
//
//  Created by Andrew Little on 2013-04-21.
//  Copyright (c) 2013 Andrew Little. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
