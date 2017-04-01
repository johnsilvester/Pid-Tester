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
int iCounter = 0;
double diffI = 0;
double change = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.ball.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.ball.layer.cornerRadius = self.ball.frame.size.width/2;
    self.goalButton.layer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    self.goalButton.layer.borderWidth = 5;
    
    
    
    //NSTimer *pidTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(loop) userInfo:nil repeats:YES]; //rather than while loop using timer to run PID function, for debug purposes
    
   
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    //run PID
   
}

-(void)setInitValues{
    

    
}
//set up gravity
-(void)applyForce{ //gravit is initially applied horizantally.
    
    //NOTE: applyForce is called everytime the loop runs but runs with updated values based on PID loop
    
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
    UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc]initWithItems:@[self.ball]]; // add physics behaviors on ball
    item.friction = 10;
    item.density = 1;
    item.resistance = 3;
    item.elasticity = 0;
    
    UIPushBehavior *pushBehvaior = [[UIPushBehavior alloc]initWithItems:@[self.ball] mode:UIPushBehaviorModeInstantaneous];
    
    pushBehvaior.pushDirection = self.direction; // create a push with a basic direction of CGVectorMake(1.0, 0.0);
    pushBehvaior.magnitude = self.windMagnitude; //keep constant speed of one
    
    
    [_animator addBehavior:pushBehvaior];
    [_animator addBehavior:item]; // adds the behaviors and excutes.
    
    
    
    
    
    
}



#pragma mark - PID

-(void)loop{
    
    
    
    
    
}

-(void)forceChecker{ //failsafe not to break the UIDynamicAnimator
    
    
   
 
    
}



#pragma mark - actions


- (IBAction)pStepper:(UIStepper*)sender {
  
}

- (IBAction)iStepper:(UIStepper*)sender {
 
}

- (IBAction)buttonRandom:(UIButton *)sender {
    
  
}

- (IBAction)callPID:(id)sender {
    
    
        [self loop];
    
}
@end
