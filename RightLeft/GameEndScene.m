//
//  GameEndScene.m
//  RightLeft
//
//  Created by iappscrazy on 16/06/2015.
//  Copyright (c) 2015 iappscrazy. All rights reserved.
//

#import "GameEndScene.h"
#import "GameCenterClass.h"
#import "RIghtLeftConstant.h"
@implementation GameEndScene

NSUserDefaults *defaults_GES;

-(void)didMoveToView:(SKView *)view {
    SKLabelNode *playNode = (SKLabelNode*)[self childNodeWithName:@"playNode"];
    playNode.userData = [NSMutableDictionary dictionaryWithObject:@"playNode" forKey:@"userData"];
    
    SKLabelNode *menuNode = (SKLabelNode*)[self childNodeWithName:@"menuNode"];
    menuNode.userData = [NSMutableDictionary dictionaryWithObject:@"menuNode" forKey:@"userData"];
    
    SKLabelNode *currentScoreNode = (SKLabelNode*)[self childNodeWithName:@"currentScoreNode"];
    
    SKSpriteNode *leaderboardNode = (SKSpriteNode*)[self childNodeWithName:@"leaderboard"];
    leaderboardNode.userData = [NSMutableDictionary dictionaryWithObject:@"leaderboard" forKey:@"userData"];
    
    
    
    defaults_GES = [NSUserDefaults standardUserDefaults];
    int currentPoint = [[defaults_GES objectForKey:CURRENTPOINT] intValue];
    currentScoreNode.text = [NSString stringWithFormat:@"%d",currentPoint];
    
    int bestScore = [[defaults_GES objectForKey:BESTSCORE] intValue];
    
    GameCenterClass* GCenter = [GameCenterClass gameCenterSharedInstance];

    if(currentPoint >= bestScore){
        bestScore = currentPoint;
        [defaults_GES setObject:[NSString stringWithFormat:@"%d",bestScore] forKey:BESTSCORE];
        [GCenter postScore:bestScore];
    }else{
        int gameCenterScore = [[defaults_GES objectForKey:GAMECENTERSCORE] intValue];
        if(gameCenterScore < bestScore){
            [GCenter postScore:bestScore];
        }
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
        }else if([userData isEqualToString:@"leaderboard"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadLeaderBoard" object:nil];
        }
    }
}
@end
