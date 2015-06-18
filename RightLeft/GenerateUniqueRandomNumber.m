//
//  GenerateUniqueRandomNumber.m
//  BlockTheCat
//
//  Created by iappscrazy on 28/05/2015.
//  Copyright (c) 2015 iappscrazy. All rights reserved.
//

#import "GenerateUniqueRandomNumber.h"

NSMutableArray *totalIndexValue;
NSMutableArray        *randomValue;

@implementation GenerateUniqueRandomNumber

+ (NSMutableArray*)generateRamdomNumber:(int)from toValue:(int)to numberOfValue:(int)Numbers{
    totalIndexValue = [NSMutableArray array];
    randomValue = [NSMutableArray array];
    for(int i = 0 ; i <= to - from;i++){
        [totalIndexValue addObject:[NSNumber numberWithInt:from+i]];
    }
    
    for(int j = 0; j < Numbers;j++){
        int random = arc4random()%[totalIndexValue count];
        [randomValue addObject:[totalIndexValue objectAtIndex:random]];
        [totalIndexValue removeObjectAtIndex:random];
        
    }
    return randomValue;
}

@end
