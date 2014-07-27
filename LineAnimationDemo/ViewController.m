//
//  ViewController.m
//  LineAnimationDemo
//
//  Created by YourtionGuo on 7/27/14.
//  Copyright (c) 2014 yourtion. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIImageView *P1;
@property (strong, nonatomic) UIImageView *P2;
@property (strong, nonatomic) CAShapeLayer *line;
@end

#define Move 100.0f
#define Duration 0.25

#define Right @"Right"
#define Left @"Left"
#define Top @"Top"
#define Bottom @"Bottom"


@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Init Two Object to move
    // Top Object
    _P1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ObjD"]];
    _P1.highlightedImage = [UIImage imageNamed:@"Obj"];
    _P1.center = self.view.center;
    [self.view addSubview:_P1];
    // Move Object
    _P2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ObjD"]];
    _P2.highlightedImage = [UIImage imageNamed:@"Obj"];
    _P2.center = self.view.center;
    [self.view insertSubview:_P2 belowSubview:_P1];
    _P2.alpha = 0;
    
    // Test
    [self performSelector:@selector(startPoint:) withObject:Right afterDelay:1];
    [self performSelector:@selector(stopPoint:) withObject:Right afterDelay:3];
    [self performSelector:@selector(startPoint:) withObject:Left afterDelay:5];
    [self performSelector:@selector(stopPoint:) withObject:Left afterDelay:7];
    [self performSelector:@selector(startPoint:) withObject:Top afterDelay:9];
    [self performSelector:@selector(stopPoint:) withObject:Top afterDelay:11];
    [self performSelector:@selector(startPoint:) withObject:Bottom afterDelay:13];
    [self performSelector:@selector(stopPoint:) withObject:Bottom afterDelay:15];
}

-(void)startPoint:(NSString *)pos
{
    
    _P1.highlighted = YES;
    _P2.highlighted = NO;
    
    // Move Path
    CGPoint fromPoint = self.P2.center;
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];
    CGPoint toPoint = CGPointMake(fromPoint.x , fromPoint.y ) ;
    if ([pos isEqualToString:Right]) {
        toPoint = CGPointMake(fromPoint.x + Move , fromPoint.y);
    }else if ([pos isEqualToString:Left]) {
        toPoint = CGPointMake(fromPoint.x - Move , fromPoint.y);
    }else if ([pos isEqualToString:Top]) {
        toPoint = CGPointMake(fromPoint.x , fromPoint.y - Move);
    }else if ([pos isEqualToString:Bottom]){
        toPoint = CGPointMake(fromPoint.x , fromPoint.y + Move);
    }
    [movePath addLineToPoint:toPoint];
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    
    // Line Path
    UIBezierPath *path = [UIBezierPath bezierPath];
    // Make the line out of Obj
    if ([pos isEqualToString:@"Right"]) {
        [path moveToPoint:CGPointMake(fromPoint.x + _P2.frame.size.width/2, fromPoint.y)];
        [path addLineToPoint:CGPointMake(toPoint.x - _P2.frame.size.width/2, toPoint.y)];
    }else if ([pos isEqualToString:@"Left"]) {
        [path moveToPoint:CGPointMake(fromPoint.x - _P2.frame.size.width/2, fromPoint.y)];
        [path addLineToPoint:CGPointMake(toPoint.x + _P2.frame.size.width/2, toPoint.y)];
    }else if ([pos isEqualToString:@"Top"]) {
        [path moveToPoint:CGPointMake(fromPoint.x , fromPoint.y - _P2.frame.size.width/2)];
        [path addLineToPoint:CGPointMake(toPoint.x , toPoint.y + _P2.frame.size.width/2)];
    }else if ([pos isEqualToString:Bottom]){
        [path moveToPoint:CGPointMake(fromPoint.x , fromPoint.y + _P2.frame.size.width/2)];
        [path addLineToPoint:CGPointMake(toPoint.x , toPoint.y - _P2.frame.size.width/2)];
    }
    _line = [CAShapeLayer layer];
    _line.frame = self.P2.bounds;
    _line.path = path.CGPath;
    _line.strokeColor = [[UIColor whiteColor] CGColor];
    _line.fillColor = nil;
    _line.lineWidth = 2.0f;
    _line.lineJoin = kCALineJoinBevel;
    [self.view.layer insertSublayer:_line below:_P2.layer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = Duration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_line addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    // Opacity when Animating
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.6];
    opacityAnimation.toValue = [NSNumber numberWithFloat:1];
    
    // Add Animation to group
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:moveAnim, opacityAnimation,pathAnimation, nil];
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animGroup.duration=Duration;
    animGroup.repeatCount = 1;
    animGroup.removedOnCompletion = YES;
    _P2.center = toPoint;
    [_P2.layer addAnimation:animGroup forKey:nil];
    _P2.alpha = 1;
}

-(void)stopPoint:(NSString *)pos
{
    _P1.highlighted = NO;
    _P2.highlighted = YES;
    
    CGPoint fromPoint = self.P2.center;
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];
    CGPoint toPoint = CGPointMake(fromPoint.x , fromPoint.y) ;
    if ([pos isEqualToString:Right]) {
        toPoint = CGPointMake(fromPoint.x - Move , fromPoint.y) ;
    }else if ([pos isEqualToString:Left]) {
        toPoint = CGPointMake(fromPoint.x + Move , fromPoint.y) ;
    }else if ([pos isEqualToString:Top]) {
        toPoint = CGPointMake(fromPoint.x , fromPoint.y + Move) ;
    }else if ([pos isEqualToString:Bottom]){
        toPoint = CGPointMake(fromPoint.x , fromPoint.y - Move);
    }
    [movePath addLineToPoint:toPoint];
    
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    if ([pos isEqualToString:Right]) {
        [path moveToPoint:CGPointMake(fromPoint.x - _P2.frame.size.width/2, fromPoint.y)];
        [path addLineToPoint:CGPointMake(toPoint.x + _P2.frame.size.width/2, toPoint.y)];
    }else if ([pos isEqualToString:Left]) {
        [path moveToPoint:CGPointMake(fromPoint.x + _P2.frame.size.width/2, fromPoint.y)];
        [path addLineToPoint:CGPointMake(toPoint.x - _P2.frame.size.width/2, toPoint.y)];
    }else if ([pos isEqualToString:Top]) {
        [path moveToPoint:CGPointMake(fromPoint.x , fromPoint.y + _P2.frame.size.width/2)];
        [path addLineToPoint:CGPointMake(toPoint.x , toPoint.y - _P2.frame.size.width/2)];
    }else if ([pos isEqualToString:Bottom]) {
        [path moveToPoint:CGPointMake(fromPoint.x , fromPoint.y - _P2.frame.size.width/2)];
        [path addLineToPoint:CGPointMake(toPoint.x , toPoint.y + _P2.frame.size.width/2)];
    }
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = Duration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_line addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.6];
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:moveAnim, opacityAnimation,pathAnimation, nil];
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animGroup.duration = Duration;
    animGroup.repeatCount = 1;
    _P2.center = toPoint;
    [_P2.layer addAnimation:animGroup forKey:nil];
    _P2.alpha = 0;
}
@end
