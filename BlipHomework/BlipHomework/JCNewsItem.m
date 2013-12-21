//
//  JCNewsItem.m
//  BlipHomework
//
//  Created by João Carreira on 20/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import "JCNewsItem.h"

@implementation JCNewsItem

@synthesize title, description, datePublished, link;


-(NSComparisonResult)compare:(JCNewsItem *)otherNewsItem
{
    return ([self.datePublished compare:otherNewsItem.datePublished] == NSOrderedAscending);
}

@end
