//
//  JCAllNewsViewController.h
//  BlipHomework
//
//  Created by João Carreira on 20/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class Reachability;

@interface JCAllNewsViewController : UITableViewController<UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
{
    Reachability *hostReachable;
}

-(void)checkConnection:(NSNotification *)notification;

@end
