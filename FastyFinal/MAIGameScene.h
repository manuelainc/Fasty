//
//  MAIGameScene.h
//  Fancy2
//
//  Created by Manuel Amado on 28/12/2013.
//  Copyright (c) 2013 Manuel Amado. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Joystick;
@class MAIGameViewController;

@interface MAIGameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic,strong) Joystick *joystick;

@property (nonatomic,weak) MAIGameViewController *viewController;




@end
