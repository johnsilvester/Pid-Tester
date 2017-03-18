//
//  ViewController.m
//  PID Test
//
//  Created by John Silvester on 3/18/17.
//  Copyright © 2017 FlyPhone. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.ball.layer.cornerRadius = self.ball.frame.size.width/2;
    
    [self applyGravity]; //apply basic gravity.
    
    
}
//set up gravity
-(void)applyGravity{ //gravit is applied horizantally.
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.ball]];
    
    CGVector gravDirection = CGVectorMake(1.0, 0.0);
    
    gravityBehavior.gravityDirection = gravDirection; // set the direction to go left
    
    gravityBehavior.magnitude = 2; //this is the value to be changed for varrying 'wind'
    
    [_animator addBehavior:gravityBehavior];
    
}




@end
