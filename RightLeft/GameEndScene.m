//
//  GameEndScene.m
//  RightLeft
//
//  Created by iappscrazy on 16/06/2015.
//  Copyright (c) 2015 iappscrazy. All rights reserved.
//


#import "GameEndScene.h"

#import "RIghtLeftConstant.h"
@implementation GameEndScene

NSUserDefaults *defaults_GES;

-(void)didMoveToView:(SKView *)view {
    SKLabelNode *playNode = (SKLabelNode*)[self childNodeWithName:@"playNode"];
    playNode.userData = [NSMutableDictionary dictionaryWithObject:@"playNode" forKey:@"userData"];
    
    SKLabelNode *menuNode = (SKLabelNode*)[self childNodeWithName:@"menuNode"];
    menuNode.userData = [NSMutableDictionary dictionaryWithObject:@"menuNode" forKey:@"userData"];
    
    SKLabelNode *currentScoreNode = (SKLabelNode*)[self childNodeWithName:@"currentScoreNode"];
    
    SKSpriteNode *settingsNode = (SKSpriteNode*)[self childNodeWithName:@"settingsNode"];
    settingsNode.userData = [NSMutableDictionary dictionaryWithObject:@"settingsNode" forKey:@"userData"];
    
    defaults_GES = [NSUserDefaults standardUserDefaults];
    int currentPoint = [[defaults_GES objectForKey:CURRENTPOINT] integerValue];
    currentScoreNode.text = [NSString stringWithFormat:@"%d",currentPoint];
    
    int bestScore = [[defaults_GES objectForKey:BESTSCORE] integerValue];
    
    if(currentPoint <= bestScore){
        bestScore = currentPoint;
        [defaults_GES setObject:[NSString stringWithFormat:@"%d",bestScore] forKey:BESTSCORE];
    }
    
    SKLabelNode *bestScoreNode = (SKLabelNode*)[self childNodeWithName:@"bestScoreNode"];
    bestScoreNode.text = [NSString stringWithFormat:@"%d",bestScore];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAds" object:nil];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKShapeNode *node = (SKShapeNode*)[self nodeAtPoint:location];
        NSDictionary *userDataDic = node.userData;
        
        NSString *userData = [userDataDic objectForKey:@"userData"];
        if([userData isEqualToString:@"playNode"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadGameScene" object:nil];
        }
        if([userData isEqualToString:@"menuNode"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMenuScene" object:nil];
        }else if([userData isEqualToString:@"settingsNode"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadSettingScene" object:nil];
        }
    }
}
@end
