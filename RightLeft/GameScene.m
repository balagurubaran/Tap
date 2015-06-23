//
//  GameScene.m
//  RightLeft
//
//  Created by iappscrazy on 14/06/2015.
//  Copyright (c) 2015 iappscrazy. All rights reserved.
//

#import "GameScene.h"
#import "RIghtLeftConstant.h"
#import "GenerateUniqueRandomNumber.h"
#import "utiliz.h"
#import <Foundation/Foundation.h>

@import AVFoundation;
SKLabelNode *colorChangeNode;
SKLabelNode *scoreLblNode;
SKLabelNode *timerLblNode;

NSMutableArray *colorArray;
NSTimer  *colorChangetimer;

NSMutableArray *colorRandomNumberArray;
NSMutableArray *randomTextArray;
int currentColor;
BOOL isTapped;
BOOL isGameFailed;
BOOL isGameStarted;
NSDate *startDate;
int maxTimerValue;
int timer;

int currentPoint;
BOOL isEffect;

AVAudioPlayer *clickPlayer;
AVAudioPlayer *wrongClickPlayer;
NSUserDefaults *defaults;

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    colorArray = [[NSMutableArray alloc] initWithObjects:REDHEX,GREENHEX,BLUEHEX,ORANGEHEX,nil];
    randomTextArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"9",@"0",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    colorChangeNode = (SKLabelNode*)[self childNodeWithName:@"colorChangeNode"];
    colorChangeNode.userData = [NSMutableDictionary dictionaryWithObject:@"colorChangeNode" forKey:@"userData"];
    
    scoreLblNode = (SKLabelNode*)[self childNodeWithName:@"scoreLblNode"];
    //timerLblNode = (SKLabelNode*)[self childNodeWithName:@"timerLblNode"];
    
    SKSpriteNode *redTap = (SKSpriteNode*)[self childNodeWithName:@"redTabNode"];
    redTap.userData = [NSMutableDictionary dictionaryWithObject:@"redTabNode" forKey:@"userData"];
    
    SKSpriteNode *greenTap = (SKSpriteNode*)[self childNodeWithName:@"greenTabNode"];
    greenTap.userData = [NSMutableDictionary dictionaryWithObject:@"greenTabNode" forKey:@"userData"];
    
    SKSpriteNode *blueTabNode = (SKSpriteNode*)[self childNodeWithName:@"blueTabNode"];
    blueTabNode.userData = [NSMutableDictionary dictionaryWithObject:@"blueTabNode" forKey:@"userData"];
    
    SKSpriteNode *orangeTabNode = (SKSpriteNode*)[self childNodeWithName:@"orangeTabNode"];
    orangeTabNode.userData = [NSMutableDictionary dictionaryWithObject:@"orangeTabNode" forKey:@"userData"];
    
    SKLabelNode *backNode = (SKLabelNode*)[self childNodeWithName:@"backNode"];
    backNode.userData = [NSMutableDictionary dictionaryWithObject:@"backNode" forKey:@"userData"];
    
    isTapped = YES;
    isGameStarted = NO;
    isGameFailed = NO;
    
    
     defaults = [NSUserDefaults standardUserDefaults];
    
    currentPoint = 0;
    maxTimerValue = 60;
    //colorChangetimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTheRandomLblText) userInfo:nil repeats:YES];
    
    colorRandomNumberArray = [GenerateUniqueRandomNumber generateRamdomNumber:0 toValue:[colorArray count]-1 numberOfValue:[colorArray count]];

    currentColor = [[colorRandomNumberArray objectAtIndex:0] intValue];
    colorChangeNode.fontColor = [utiliz colorFromHexString:[colorArray objectAtIndex:currentColor]];
    [colorRandomNumberArray removeObjectAtIndex:0];
    scoreLblNode.text = [NSString stringWithFormat:@"Score : %d",currentPoint];
    // timerLblNode.text = @"Time : 0.0";
  //  colorChangetimer.tolerance = 1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadAds" object:nil];
    
    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:@"click" withExtension:@"mp3"];
    clickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    //clickPlayer.volume = 70/100;
    [clickPlayer prepareToPlay];
    
    musicURL = [[NSBundle mainBundle] URLForResource:@"wrong" withExtension:@"wav"];
    wrongClickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    //wrongClickPlayer.volume = 70/100;
    [wrongClickPlayer prepareToPlay];
    
    isEffect = [[defaults objectForKey:ISEFFECT] boolValue];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKShapeNode *node = (SKShapeNode*)[self nodeAtPoint:location];
        NSDictionary *userDataDic = node.userData;
        
        NSString *userData = [userDataDic objectForKey:@"userData"];
        if([userData isEqualToString:@"redTabNode"] && !isGameFailed){
            [self checkGameStatus:RED];
        }else if ([userData isEqualToString:@"greenTabNode"] && !isGameFailed){
           [self checkGameStatus:GREEN];
        }else if ([userData isEqualToString:@"blueTabNode"] && !isGameFailed){
            [self checkGameStatus:BLUE];
        }else if ([userData isEqualToString:@"orangeTabNode"] && !isGameFailed){
            [self checkGameStatus:ORANGE];
        }else if ([userData isEqualToString:@"backNode"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMenuScene" object:nil];
        }
        
    }
}

- (void) checkGameStatus:(int)tapColor{
    timer = 0;
    if(currentPoint == 0){
         isGameStarted = YES;
        startDate = [NSDate date];
    }
    if(currentColor == tapColor){
        if(isEffect)
            [clickPlayer play];
        currentPoint++;
    }else{
        if(isEffect)
            [wrongClickPlayer play];
        isGameFailed = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadGameEndScene" object:nil];
    }
    scoreLblNode.text = [NSString stringWithFormat:@"Score : %d",currentPoint];
    [defaults setObject:[NSNumber numberWithInt:currentPoint] forKey:@"currentpoint"];
    
    int random = arc4random()%[randomTextArray count];
    
    NSString *text = [randomTextArray objectAtIndex:random];
    colorChangeNode.text = text;
    currentColor = [[colorRandomNumberArray objectAtIndex:0] intValue];
    colorChangeNode.fontColor = [utiliz colorFromHexString:[colorArray objectAtIndex:currentColor]];
    [colorRandomNumberArray removeObjectAtIndex:0];
    if([colorRandomNumberArray count] == 0){
        colorRandomNumberArray = [GenerateUniqueRandomNumber generateRamdomNumber:0 toValue:[colorArray count]-1 numberOfValue:[colorArray count]];
        if(currentColor == [[colorRandomNumberArray objectAtIndex:0] intValue]){
            [colorRandomNumberArray removeObjectAtIndex:0];
            [colorRandomNumberArray addObject:[NSString stringWithFormat:@"%d",currentColor]];
        }
    }
    
}

- (void) setTheRandomLblText{
    
    if(timer == maxTimerValue && isGameStarted) {
        if(isEffect)
            [wrongClickPlayer play];
        //[colorChangetimer invalidate];
        isGameFailed = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadGameEndScene" object:nil];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self setTheRandomLblText];
    timer++;

    
    if(isGameStarted){
        scoreLblNode.text = [NSString stringWithFormat:@"Score : %d",currentPoint];
        NSDate *endTime = [NSDate date];
        //timerLblNode.text = [NSString stringWithFormat:@"Time : %.1f",[endTime timeIntervalSinceDate:startDate]];
    }
}

@end
