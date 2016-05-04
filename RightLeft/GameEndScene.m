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
SKLabelNode *info;

-(void)didMoveToView:(SKView *)view {
    SKLabelNode *playNode = (SKLabelNode*)[self childNodeWithName:@"playNode"];
    playNode.userData = [NSMutableDictionary dictionaryWithObject:@"playNode" forKey:@"userData"];
    
    SKLabelNode *menuNode = (SKLabelNode*)[self childNodeWithName:@"menuNode"];
    menuNode.userData = [NSMutableDictionary dictionaryWithObject:@"menuNode" forKey:@"userData"];
    
    SKLabelNode *currentScoreNode = (SKLabelNode*)[self childNodeWithName:@"currentScoreNode"];
    
    SKSpriteNode *leaderboardNode = (SKSpriteNode*)[self childNodeWithName:@"leaderboard"];
    leaderboardNode.userData = [NSMutableDictionary dictionaryWithObject:@"leaderboard" forKey:@"userData"];
    
    SKSpriteNode *settingsNode = (SKSpriteNode*)[self childNodeWithName:@"settingsNode"];
    settingsNode.userData = [NSMutableDictionary dictionaryWithObject:@"settingsNode" forKey:@"userData"];
    
    SKSpriteNode *leaderBoardNode = (SKSpriteNode*)[self childNodeWithName:@"leaderBoardNode"];
    leaderBoardNode.userData = [NSMutableDictionary dictionaryWithObject:@"leaderboard" forKey:@"userData"];
    
    info        = (SKLabelNode*)[self childNodeWithName:@"Info"];
    defaults_GES = [NSUserDefaults standardUserDefaults];
    int currentPoint = [[defaults_GES objectForKey:CURRENTPOINT] intValue];
    currentScoreNode.text = [NSString stringWithFormat:@"%d",currentPoint];
    
    int bestScore = [[defaults_GES objectForKey:BESTSCORE] intValue];
    
    GameCenterClass* GCenter = [GameCenterClass gameCenterSharedInstance];

    if(currentPoint > bestScore){
        bestScore = currentPoint;
        [defaults_GES setObject:[NSString stringWithFormat:@"%d",bestScore] forKey:BESTSCORE];
    }
    [GCenter postScore:currentPoint];
    
    SKLabelNode *bestScoreNode = (SKLabelNode*)[self childNodeWithName:@"bestScoreNode"];
    bestScoreNode.text = [NSString stringWithFormat:@"%d",bestScore];
    
    info.text = @"Don't give up try hard to beat your own best";
    if(bestScore <= currentPoint){
        info.text = @"Congratulations! New high score";
    } else if(bestScore - 10 < currentPoint){
        info.text = @"OOPS! Close to your best score Don't give up ";
    }
    
  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAds" object:nil];
    
    
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
