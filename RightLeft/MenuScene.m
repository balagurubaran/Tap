//
//  MenuScene.m
//  RightLeft
//
//  Created by iappscrazy on 16/06/2015.
//  Copyright (c) 2015 iappscrazy. All rights reserved.
//

#import "MenuScene.h"

@implementation MenuScene
-(void)didMoveToView:(SKView *)view {
    SKSpriteNode *playNode = (SKSpriteNode*)[self childNodeWithName:@"playNode"];
    playNode.userData = [NSMutableDictionary dictionaryWithObject:@"playNode" forKey:@"userData"];
    
    SKSpriteNode *settingsNode = (SKSpriteNode*)[self childNodeWithName:@"settingsNode"];
    settingsNode.userData = [NSMutableDictionary dictionaryWithObject:@"settingsNode" forKey:@"userData"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAds" object:nil];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKShapeNode *node = (SKShapeNode*)[self nodeAtPoint:location];
        NSDictionary *userDataDic = node.userData;
        
        NSString *userData = [userDataDic objectForKey:@"userData"];
        if([userData isEqualToString:@"playNode"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadGameScene" object:nil];
        }else if([userData isEqualToString:@"settingsNode"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadSettingScene" object:nil];
        }
    }
}
@end
