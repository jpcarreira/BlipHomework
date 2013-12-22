//
//  JCAllNewsViewController.h
//  BlipHomework
//
//  Created by João Carreira on 20/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "JCNewsDataModel.h"

@class Reachability;

@interface JCAllNewsViewController : UITableViewController<UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
{
    Reachability *hostReachable;
}

@property (nonatomic, strong) JCNewsDataModel *newsDataModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

-(void)checkConnection:(NSNotification *)notification;

@end
