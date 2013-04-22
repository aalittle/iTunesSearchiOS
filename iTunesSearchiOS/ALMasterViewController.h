//
//  ALMasterViewController.h
//  iTunesSearchiOS
//
//  Created by Andrew Little on 2013-04-21.
//  Copyright (c) 2013 Andrew Little. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALSearchViewController.h"

@class ALDetailViewController;

#import <CoreData/CoreData.h>

@interface ALMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, TableSelectorDelegate>

@property (strong, nonatomic) ALDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
