//
//  GameViewController.m
//  RightLeft
//
//  Created by iappscrazy on 14/06/2015.
//  Copyright (c) 2015 iappscrazy. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "GameEndScene.h"
#import "AdmobViewController.h"
#import "GameCenterClass.h"
#import "SettingScene.h"
#import "RIghtLeftConstant.h"

MenuScene *menuScene;
GameScene *gameScene;
AdmobViewController *adsController;
GameEndScene *gameEndScene;
SettingScene *settingsScene;
SKView * skView;

int adsLoadcounter;

@import GameKit;

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
     skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    menuScene = [MenuScene unarchiveFromFile:@"MenuScene"];
    menuScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Create and configure the scene.
    gameScene = [GameScene unarchiveFromFile:@"GameScene"];
    gameScene.scaleMode = SKSceneScaleModeFill;
    // Create and configure the scene.
    gameEndScene = [GameEndScene unarchiveFromFile:@"GameEndScene"];
    gameEndScene.scaleMode = SKSceneScaleModeFill;
    
    settingsScene = [SettingScene unarchiveFromFile:@"SettingScene"];
    settingsScene.scaleMode = SKSceneScaleModeFill;
    
    // Present the scene.
    [skView presentScene:menuScene];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAds) name:@"loadAds" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAds) name:@"removeAds" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGameScene) name:@"loadGameScene" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMenuScene) name:@"loadMenuScene" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGameEndScene) name:@"loadGameEndScene" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSettingScene) name:@"loadSettingScene" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadLeaderBoard)
                                                 name:@"loadLeaderBoard"
                                               object:nil];
    
    defaults = [NSUserDefaults standardUserDefaults];
    adsController = [AdmobViewController singleton];
    
    adsLoadcounter = [[defaults objectForKey:ADSLOADCOUNTER] intValue];
}

- (void) loadAds{
    [adsController resetAdView:self];
}

- (void) removeAds{
    [adsController removeADS];
}

- (void) loadGameScene{
    adsLoadcounter++;
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.5];
    
    [skView presentScene:gameScene transition:reveal];

    if(adsLoadcounter == 8){
        [adsController reLoadInterstitialAds];
    }
}

- (void) loadMenuScene{
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.5];
    
    [skView presentScene:menuScene transition:reveal];
}

- (void) loadGameEndScene{
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.5];
    
    [skView presentScene:gameEndScene transition:reveal];
    if(adsLoadcounter > 8){
        [adsController LoadInterstitialAds:self];
        adsLoadcounter = 0;
    }
    
    [defaults setObject:[NSString stringWithFormat:@"%d",adsLoadcounter] forKey:ADSLOADCOUNTER];
}

- (void) loadSettingScene{
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.5];
    
    [skView presentScene:settingsScene transition:reveal];
}

- (void)loadLeaderBoard{
    
    [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
        if(error == nil){
            GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
            if (gameCenterController != nil)
            {
                gameCenterController.gameCenterDelegate = self;
                gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
                gameCenterController.leaderboardIdentifier = @"tapcolor_topscore";
                [self presentViewController: gameCenterController animated: YES completion:nil];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Game Center Disabled"message:@"For Game Center make sure you have an account and you have a proper device connection."delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil];
            [alert show];
        }
    }];
}
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
