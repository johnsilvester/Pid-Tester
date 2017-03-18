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
int counter = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.ball.layer.cornerRadius = self.ball.frame.size.width/2;
    
    self.loopIsRunning = true;
    
    [self applyGravity]; //apply basic gravity.
    
    [self setValues];
    
    self.loopIsRunning = true;
   
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loop) userInfo:nil repeats:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    //run PID
    
}

-(void)setValues{
    
    self.windMagnitude = .2;
    
    self.setLocation = self.ball.center.x;
    
    
    
    
}
//set up gravity
-(void)applyGravity{ //gravit is applied horizantally.
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.ball]];
    
    CGVector gravDirection = CGVectorMake(1.0, 0.0);
    
    gravityBehavior.gravityDirection = gravDirection; // set the direction to go left
    
    gravityBehavior.magnitude = .2; //this is the value to be changed for varrying 'wind'
    
    [_animator addBehavior:gravityBehavior];
    
}



#pragma mark - PID

-(void)loop{
    
    counter++;
        
//        self.actualLocation = self.ball.center.x;
//        
//        double diff =  self.actualLocation - self.setLocation;
//    
//        NSLog(@"DIF %f",diff);
//    
//    if (diff < 0 ) {
//            //apply 0 force
//        
//        self.direction = CGVectorMake(1.0, 0.0);
//        self.windMagnitude = .2;
//            
//        }else{
//            //set force to a nominal amount (.5)
//            self.direction = CGVectorMake(-1.0, 0.0);
//            self.windMagnitude = .6;
//        
//           
//        }
    if (counter == 2) {
        self.direction = CGVectorMake(-1.0, 0.0);
         self.windMagnitude = .6;
        [self applyForce];
    }
              //create applying force
    
    
    
    
}

-(void)applyForce{
    
    if (_animator.behaviors.count > 2) {
        
        [_animator removeBehavior:[_animator.behaviors objectAtIndex:_animator.behaviors.count-1]];
        
    }
    
    UIGravityBehavior *newBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.ball]];

   
    
    newBehavior.magnitude = _windMagnitude; //this is the value to be changed for varrying 'wind'
    newBehavior.gravityDirection = self.direction;
    
 
    
    
    [_animator addBehavior:newBehavior];
    
    
 
    
  
    
    
   
    
}




@end
