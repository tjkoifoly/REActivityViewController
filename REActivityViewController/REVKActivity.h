//
//  REVKActivity.h
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REActivity.h"

@interface REVKActivity : REActivity

@property (copy, nonatomic) NSString *clientId;

- (id)initWithClientId:(NSString *)clientId;
- (void)share;

@end
