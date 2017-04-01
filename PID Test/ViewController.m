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
    
    self.loopIsRunning = true;
    
    [self setInitValues];
    
    [self applyForce]; //apply basic gravity.
    
    
    //NSTimer *pidTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(loop) userInfo:nil repeats:YES]; //rather than while loop using timer to run PID function, for debug purposes
    
   
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    //run PID
   
}

-(void)setInitValues{
    
    self.setLocation = self.ball.center.x; // set init location as center of screen for goal state of PID
    self.direction = CGVectorMake(1.0, 0.0);
    
    self.P = 2; // init P
    self.I = .5; // init I
    
    self.windMagnitude = 1;
    
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
    
    @synchronized (self) {
        iCounter ++; // used for division of I
        
        self.actualLocation = self.ball.center.x; // represents actual location of ball
        
        double diff =  self.setLocation - self.actualLocation; // find the difference between center of screen and ball location
        
       //double diffP = diff + self.P; // multiply diff by P
        double diffP = diff; // multiply diff by P

        
        diffI += diff; //sum up all the differences
        
        double avgDiffI = diffI / iCounter; // gives an average of differences
        
        avgDiffI = self.I * avgDiffI; // multiply average by  I factor
        
        if (diff == 0) {
            self.windMagnitude = 0;
            

        }else{
            self.windMagnitude = 1; // set magnitude for I
            
            self.direction = CGVectorMake(diff, 0); //combine I and P for a direction and power
            
            //change = (diffP +diffI)/2;
            
            [self forceChecker];
        }
        
        
        NSLog(@"diffP: %f, diff: %f, center:%f",diffP,diff,self.actualLocation+diff);
    }
    
    
    
    
}

-(void)forceChecker{ //failsafe not to break the UIDynamicAnimator
    
    
   
    if (_animator.behaviors.count > 2) {
        
        [_animator removeBehavior:[_animator.behaviors objectAtIndex:_animator.behaviors.count-1]]; //if too many behaviors stack up, will remove some.
        
    } else{
        
        [self applyForce]; // will apply updated for values based on results from PID
        
    }
    
    
}



#pragma mark - actions


- (IBAction)pStepper:(UIStepper*)sender {
    self.P =sender.value;
    self.pLabel.text = [NSString stringWithFormat:@"%f",self.P];
}

- (IBAction)iStepper:(UIStepper*)sender {
    self.I =sender.value/10;
    self.iLabel.text = [NSString stringWithFormat:@"%f",self.I];
}

- (IBAction)buttonRandom:(UIButton *)sender {
    
    
  
    
    UIPushBehavior *pushBehvaior = [[UIPushBehavior alloc]initWithItems:@[self.ball] mode:UIPushBehaviorModeInstantaneous];
    
    pushBehvaior.pushDirection = CGVectorMake(1, 0); // create a push with a basic direction of CGVectorMake(1.0, 0.0);
    pushBehvaior.magnitude = 4; //keep constant speed of one
    
    
    [_animator addBehavior:pushBehvaior]; // adds the behaviors and excutes.
    
}

- (IBAction)callPID:(id)sender {
    
    
        [self loop];
    
}
@end
