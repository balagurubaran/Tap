//
//  SettingScene.m
//  RightLeft
//
//  Created by iappscrazy on 17/06/2015.
//  Copyright (c) 2015 iappscrazy. All rights reserved.
//

#import "SettingScene.h"

SKLabelNode *effectNode;
@implementation SettingScene

-(void)didMoveToView:(SKView *)view {
    SKSpriteNode *backNode = (SKSpriteNode*)[self childNodeWithName:@"backNode"];
    backNode.userData = [NSMutableDictionary dictionaryWithObject:@"backNode" forKey:@"userData"];
    
    effectNode = (SKLabelNode*)[self childNodeWithName:@"effectNode"];
    
    SKSpriteNode *effectShapeNode = (SKSpriteNode*)[self childNodeWithName:@"effectShapeNode"];
    effectShapeNode.userData = [NSMutableDictionary dictionaryWithObject:@"effectShapeNode" forKey:@"userData"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAds" object:nil];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKShapeNode *node = (SKShapeNode*)[self nodeAtPoint:location];
        NSDictionary *userDataDic = node.userData;
        
        NSString *userData = [userDataDic objectForKey:@"userData"];
        if([userData isEqualToString:@"backNode"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMenuScene" object:nil];
        }else if([userData isEqualToString:@"effectShapeNode"]){
            if([effectNode.text isEqualToString:@"ON"]){
                effectNode.text = @"OFF";
            }else{
                effectNode.text = @"ON";
            }
        }
    }
}

@end
