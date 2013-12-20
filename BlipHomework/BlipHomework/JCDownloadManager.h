//
//  JCDownloadManager.h
//  BlipHomework
//
//  Created by João Carreira on 20/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^DownloadCompletedBlock)(NSData* result);

@interface JCDownloadManager : NSObject

+(void)downloadData:(NSString *)url withCompletionBlock:(DownloadCompletedBlock)block;

@end
