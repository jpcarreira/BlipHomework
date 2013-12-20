//
//  JCDownloadManager.m
//  BlipHomework
//
//  Created by João Carreira on 20/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import "JCDownloadManager.h"

@implementation JCDownloadManager

+(void)downloadData:(NSString *)url withCompletionBlock:(DownloadCompletedBlock)block
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    dispatch_async(queue,^{
        
        NSData * data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        
        dispatch_async(mainQueue, ^{
            block(data);
        });
    });
}

@end
