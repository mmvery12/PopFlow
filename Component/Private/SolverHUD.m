//
//  SolverHUD.m
//  SolverHUD
//
//  Created by JD on 16/9/2.
//  Copyright © 2016年 com.Vacn. All rights reserved.
//

#import "SolverHUD.h"
#import "SolverHUDShareInstance.h"
#import <objc/runtime.h>
#import <objc/objc.h>
#import <objc/message.h>


typedef void(^Animate)(CAAnimation *anio);
typedef Animate AnimateDidStartBlock;
typedef Animate AnimateDidStopBlock;
@interface SolverHUD ()
@property (nonatomic,assign)BOOL joinQueue;
@property (nonatomic,assign)BOOL animate;
@property (nonatomic,weak)UIView *showInview;
@property (nonatomic,assign)BOOL tryCatcheUI;

@property (nonatomic,copy)CAAnimation *showAnio;
@property (nonatomic,copy)CAAnimation *disAAnio;

@property (nonatomic,copy)dispatch_block_t showNext;
@property (nonatomic,copy)AnimateDidStartBlock animateStart;
@property (nonatomic,copy)AnimateDidStopBlock animateStop;
@end


typedef SolverHUD *(*Imp)(id, SEL, ...);
typedef CAKeyframeAnimation * (*MImp)(id, SEL, ...);
typedef void (*SImp)(id, SEL, ...);
@implementation SolverHUD
@synthesize isCatchingUserInteraction = _isCatchingUserInteraction;
@synthesize position = _position;
@synthesize status = _status;
@synthesize duringTime = _duringTime;
/*******************************
 
 *******************************/
+(SolverHUD *)solverHUD
{
    return nil;
}

+(SolverHUD *)solverHUD:(id)params
{
    return nil;
}
+(CAAnimation *)solverHUDShowAnimate;
{
    CAKeyframeAnimation *anio = [CAKeyframeAnimation animation];
    anio.keyPath = @"opacity";
    anio.removedOnCompletion = NO;
    anio.fillMode = kCAFillModeForwards;
    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anio.values= @[[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:1]];
    return anio;
}

+(CAAnimation *)solverHUDDisappearAnimate;
{
    CAKeyframeAnimation *anio = [CAKeyframeAnimation animation];
    anio.keyPath = @"opacity";
    anio.removedOnCompletion = NO;
    anio.fillMode = kCAFillModeForwards;
    anio.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anio.values= @[[NSNumber numberWithFloat:1],[NSNumber numberWithFloat:0]];
    return anio;
}
/*******************************
 
 *******************************/
+(SolverHUD *)GenSolverHUD:(id)params
{
    /*防止子类和父类都没有实现，使用IMP探测*/
    id hud = nil;
    SEL sel = nil;
    sel = NSSelectorFromString(@"solverHUD:");
    Method meth = (Method)class_getClassMethod(self, sel);
    Imp imp = method_getImplementation(meth);
    hud = imp(self,sel,params);
    if (hud) {
        return hud;
    }
    return nil;
}

+(CAAnimation *)GenSolverHUDShowAnimate
{
    /*防止子类和父类都没有实现，使用IMP探测*/
    SEL sel = NSSelectorFromString(@"solverHUDShowAnimate");
    Method meth = (Method)class_getClassMethod(self, sel);
    if (meth) {
        MImp imp = method_getImplementation(meth);
        CAAnimation *anio =(CAAnimation *) imp(self,sel);
        if (anio) {
            return anio;
        }else
            return [SolverHUD solverHUDShowAnimate];
    }else
        return [SolverHUD solverHUDShowAnimate];
}

+(CAAnimation *)GenSolverHUDDisappearAnimate
{
    /*防止子类和父类都没有实现，使用IMP探测*/
    SEL sel = NSSelectorFromString(@"solverHUDDisappearAnimate");
    Method meth = (Method)class_getClassMethod(self, sel);
    if (meth) {
        MImp imp = method_getImplementation(meth);
        CAAnimation *anio =(CAAnimation *) imp(self,sel);
        if (anio) {
            return anio;
        }else
            return [SolverHUD solverHUDDisappearAnimate];
    }else
        return [SolverHUD solverHUDDisappearAnimate];
}

/*******************************
 
 *******************************/
+(id)ScheduledShowInView:(UIView *)view position:(SolverHUDPosition)position catchUI:(BOOL)tryCatchUI animate:(BOOL)animate during:(NSTimeInterval)during;
{
    id hud = [self cVi:view p:position c:tryCatchUI a:animate j:YES d:during];
    return hud;
}

+(id)ShowInView:(UIView *)view position:(SolverHUDPosition)position catchUI:(BOOL)tryCatchUI animate:(BOOL)animate during:(NSTimeInterval)during;
{
    id hud = [self cVi:view p:position c:tryCatchUI a:animate j:NO d:during];
    return hud;
}

/*******************************
 
 *******************************/
+(id)ScheduledShowInWindowWithPosition:(SolverHUDPosition)position catchUI:(BOOL)tryCatchUI animate:(BOOL)animate during:(NSTimeInterval)during;
{
    id hud = [self cVi:[UIApplication sharedApplication].keyWindow p:position c:tryCatchUI a:animate j:YES d:during];
    return hud;
}


+(id)ShowInWindowWithPosition:(SolverHUDPosition)position catchUI:(BOOL)tryCatchUI animate:(BOOL)animate during:(NSTimeInterval)during;
{
    id hud = [self cVi:[UIApplication sharedApplication].keyWindow p:position c:tryCatchUI a:animate j:NO d:during];
    return hud;
}

+(id)ScheduledShowInView:(UIView *)view;
{
    return [self ScheduledShowInView:view position:SolverHUDMiddlePosition catchUI:YES animate:YES during:3];
}

+(id)ShowInView:(UIView *)view;
{
    return [self ShowInView:view position:SolverHUDMiddlePosition catchUI:YES animate:YES during:3];
}

+(id)ScheduledShowInWindow;
{
    return [self ScheduledShowInWindowWithPosition:SolverHUDMiddlePosition catchUI:YES animate:YES during:3];
}

+(id)ShowInWindow;
{
    return [self ShowInWindowWithPosition:SolverHUDMiddlePosition catchUI:YES animate:YES during:3];
}
/*******************************
 
 *******************************/
+(id)cVi:(UIView *)view p:(SolverHUDPosition)position c:(BOOL)tryCatchUI a:(BOOL)animate j:(BOOL)join d:(NSTimeInterval)during;
{
    return [self cVi:view p:position c:tryCatchUI a:animate j:join d:during parms:nil];
}

+(id)cVi:(UIView *)view p:(SolverHUDPosition)position c:(BOOL)tryCatchUI a:(BOOL)animate j:(BOOL)join d:(NSTimeInterval)during parms:(id)params;
{
    if (!view) {
        NSLog(@"[error]:*** SolverHUD super view cannot nil");
        return nil;
    }
    SolverHUD* hud = [self GenSolverHUD:params];
    if (hud==nil) {
        NSLog(@"[error]:*** +(SolverHUD *)solverHUD must to be overwrite!");
        return nil;
    }
    hud.position = position;
    hud.showInview = view;
    hud.tryCatcheUI = tryCatchUI;
    hud.joinQueue = join;
    hud.animate = animate;
    if (animate) {
        hud.showAnio = [self GenSolverHUDShowAnimate];
        hud.showAnio.delegate = hud;
        hud.disAAnio = [self GenSolverHUDDisappearAnimate];
        hud.disAAnio.delegate = hud;
    }
    hud.duringTime = during;
    [SolverHUDShareInstance ShowSolverHUD:hud];
    return hud;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.origin.x = (CGRectGetWidth(self.showInview.bounds)-frame.size.width)/2.;
    switch (self.position) {
        case SolverHUDTopPosition:
            frame.origin.y = 64.f;
            break;
        case SolverHUDMiddlePosition:
            frame.origin.y = (CGRectGetHeight(self.showInview.bounds)-frame.size.height)/2.;
            break;
        case SolverHUDBottomPosition:
            frame.origin.y = self.showInview.bounds.size.height-64-frame.size.height;
            break;
        default:
            break;
    }
    self.frame = frame;
}

-(void)setDuringTime:(NSTimeInterval)duringTime
{
    if (!((self.status == SolverHUDOutAnimateingStatus)||(self.status == SolverHUDInAnimateingStatus) || (self.status == SolverHUDShowingStatus) || (self.status == SolverHUDDidDisappearStatus))) {
        _duringTime = duringTime;
    }
}

-(void)setPosition:(SolverHUDPosition)position
{
    _position = position;
}

-(void)setStatus:(SolverHUDStatus)status
{
    /*防止子类和父类都没有实现，使用IMP探测*/
    _status = status;
    SEL sel = NSSelectorFromString(@"hudStatusDidChange:");
    Method meth = (Method)class_getInstanceMethod(object_getClass(self), sel);
    if (meth) {
        SImp imp = (SImp)method_getImplementation(meth);
        imp(self,sel,status);
    }
}

/*******************************
 
 *******************************/
-(void)animationDidStart:(CAAnimation *)anim
{
    if (self.animateStart) {
        objc_setAssociatedObject(anim, @"startAnio", self, OBJC_ASSOCIATION_ASSIGN);
        if ([self.layer animationForKey:@"animate"]==anim) {
            objc_setAssociatedObject(anim, @"startanimateType", @"0", OBJC_ASSOCIATION_COPY);
        }
        if ([self.layer animationForKey:@"disApWithAnimate"]==anim) {
            objc_setAssociatedObject(anim, @"startanimateType", @"1", OBJC_ASSOCIATION_COPY);
        }
        self.animateStart(anim);
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        if (self.animateStop) {
            objc_setAssociatedObject(anim, @"stopAnio", self, OBJC_ASSOCIATION_ASSIGN);
            if ([self.layer animationForKey:@"animate"]==anim) {
                objc_setAssociatedObject(anim, @"stopanimateType", @"0", OBJC_ASSOCIATION_COPY);
            }
            if ([self.layer animationForKey:@"disApWithAnimate"]==anim) {
                objc_setAssociatedObject(anim, @"stopanimateType", @"1", OBJC_ASSOCIATION_COPY);
            }
            self.animateStop(anim);
        }
    }
    
}
@end

@implementation SolverHUD (Params)

+(id)ScheduledShowInView:(UIView *)view params:(id)params;
{
    return [self cVi:view p:SolverHUDMiddlePosition c:YES a:YES j:YES d:3 parms:params];
}
+(id)ShowInView:(UIView *)view params:(id)params;
{
    return [self cVi:view p:SolverHUDMiddlePosition c:YES a:YES j:NO d:3 parms:params];
}
+(id)ScheduledShowInWindowWithParams:(id)params;
{
    return [self cVi:[UIApplication sharedApplication].keyWindow p:SolverHUDMiddlePosition c:YES a:YES j:YES d:3 parms:params];
}
+(id)ShowInWindowWithParams:(id)params;
{
    return [self cVi:[UIApplication sharedApplication].keyWindow p:SolverHUDMiddlePosition c:YES a:YES j:NO d:3 parms:params];
}

@end
