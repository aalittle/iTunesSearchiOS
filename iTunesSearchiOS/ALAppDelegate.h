//
//  ALAppDelegate.h
//  iTunesSearchiOS
//
//  Created by Andrew Little on 2013-04-21.
//  Copyright (c) 2013 Andrew Little. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
