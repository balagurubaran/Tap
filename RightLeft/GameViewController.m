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

MenuScene *menuScene;
GameScene *gameScene;
AdmobViewController *adsController;
GameEndScene *gameEndScene;
SettingScene *settingsScene;
SKView * skView;
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
    menuScene.scaleMode = SKSceneScaleModeFill;
    
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
    
    
    adsController = [AdmobViewController singleton];

}

- (void) loadAds{
    [adsController resetAdView:self];
}

- (void) removeAds{
    [adsController removeADS];
}

- (void) loadGameScene{
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.5];
    
    [skView presentScene:gameScene transition:reveal];
}

- (void) loadMenuScene{
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.5];
    
    [skView presentScene:menuScene transition:reveal];
}

- (void) loadGameEndScene{
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.5];
    
    [skView presentScene:gameEndScene transition:reveal];
}

- (void) loadSettingScene{
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.5];
    
    [skView presentScene:settingsScene transition:reveal];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
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