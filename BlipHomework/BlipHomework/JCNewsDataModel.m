//
//  JCNewsDataModel.m
//  BlipHomework
//
//  Created by João Carreira on 21/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import "JCNewsDataModel.h"
#import "JCNewsItem.h"

@implementation JCNewsDataModel

@synthesize allNews;


#pragma mark - inits

-(id)init
{
    if((self = [super init]))
    {
        self.allNews = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}


#pragma mark - Instance methods
-(void)sortNewsByDate
{
    [self.allNews sortUsingSelector:@selector(compare:)];
}

@end
