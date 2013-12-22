//
//  JCNewsItemCD.h
//  BlipHomework
//
//  Created by João Carreira on 21/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface JCNewsItemCD : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * datePublished;

@end
