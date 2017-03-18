//
//  ViewController.h
//  PID Test
//
//  Created by John Silvester on 3/18/17.
//  Copyright © 2017 FlyPhone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *ball;
@property(strong,nonnull) UIDynamicAnimator *animator;

@property(strong,nonatomic) UIGravityBehavior *pidBehavior;



@property (nonatomic) double P;
@property (nonatomic) double I;
@property (nonatomic) double windMagnitude;
@property (nonatomic) CGVector direction;

@property (nonatomic) double setLocation;
@property (nonatomic) double actualLocation;

@property (nonatomic) double sumError;

@property (nonatomic) BOOL loopIsRunning;



@end

