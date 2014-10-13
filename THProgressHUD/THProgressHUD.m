//
//  THProgressHUD.m
//  THProgressHUD
//
//  Created by Hannes Tribus on 13/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "THProgressHUD.h"

@implementation THProgressHUD

@synthesize interaction = _interaction;
@synthesize window = _window;
@synthesize background = _background;
@synthesize hud = _hud;
@synthesize spinner =_spinner;
@synthesize image =_image;
@synthesize label = _label;

+ (THProgressHUD *)sharedInstance {
    static dispatch_once_t once = 0;
    static THProgressHUD *progressHUD;
    dispatch_once(&once, ^{
        progressHUD = [[THProgressHUD alloc] init];
    });
    return progressHUD;
}

+ (void)dismiss {
    [[self sharedInstance] hudHide];
}

+ (void)show:(NSString *)status {
    [self sharedInstance].interaction = YES;
    [[self sharedInstance] hudMake:status _image:nil spin:YES hide:NO];
}

+ (void)show:(NSString *)status Interaction:(BOOL)Interaction {
    [self sharedInstance].interaction = Interaction;
    [[self sharedInstance] hudMake:status _image:nil spin:YES hide:NO];
}

+ (void)showSuccess:(NSString *)status {
    [self sharedInstance].interaction = YES;
    [[self sharedInstance] hudMake:status _image:HUD_IMAGE_SUCCESS spin:NO hide:YES];
}

+ (void)showSuccess:(NSString *)status Interaction:(BOOL)Interaction {
    [self sharedInstance].interaction = Interaction;
    [[self sharedInstance] hudMake:status _image:HUD_IMAGE_SUCCESS spin:NO hide:YES];
}

+ (void)showError:(NSString *)status {
    [self sharedInstance].interaction = YES;
    [[self sharedInstance] hudMake:status _image:HUD_IMAGE_ERROR spin:NO hide:YES];
}

+ (void)showError:(NSString *)status Interaction:(BOOL)Interaction {
    [self sharedInstance].interaction = Interaction;
    [[self sharedInstance] hudMake:status _image:HUD_IMAGE_ERROR spin:NO hide:YES];
}

- (id)init {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate respondsToSelector:@selector(window)])
        _window = [delegate performSelector:@selector(window)];
    else
        _window = [[UIApplication sharedApplication] keyWindow];
    
    _background = nil;
    _hud = nil;
    _spinner = nil;
    _image = nil;
    _label = nil;
    
    self.alpha = 0;
    
    return self;
}

- (void)hudMake:(NSString *)status _image:(UIImage *)img spin:(BOOL)spin hide:(BOOL)hide {
    [self hudCreate];

    _label.text = status;
    _label.hidden = (status == nil) ? YES : NO;

    _image.image = img;
    _image.hidden = (img == nil) ? YES : NO;

    if (spin) [_spinner startAnimating]; else [_spinner stopAnimating];

    [self hudSize];
    [self hudPosition:nil];
    [self hudShow];

    if (hide) [NSThread detachNewThreadSelector:@selector(timedHide) toTarget:self withObject:nil];
}

- (void)hudCreate {
    if (_hud == nil) {
        _hud = [[UIToolbar alloc] initWithFrame:CGRectZero];
        _hud.translucent = YES;
        _hud.backgroundColor = HUD_BACKGROUND_COLOR;
        _hud.layer.cornerRadius = 10;
        _hud.layer.masksToBounds = YES;
        [self registerNotifications];
    }

    if (_hud.superview == nil) {
        if (_interaction == NO) {
            CGRect frame = CGRectMake(_window.frame.origin.x, _window.frame.origin.y, _window.frame.size.width, _window.frame.size.height);
            _background = [[UIView alloc] initWithFrame:frame];
            _background.backgroundColor = HUD_WINDOW_COLOR;
            [_window addSubview:_background];
            [_background addSubview:_hud];
        }
        else [_window addSubview:_hud];
    }

    if (_spinner == nil) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.color = HUD_SPINNER_COLOR;
        _spinner.hidesWhenStopped = YES;
    }
    if (_spinner.superview == nil) [_hud addSubview:_spinner];
    
    if (_image == nil) {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    }
    if (_image.superview == nil) [_hud addSubview:_image];

    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.font = HUD_STATUS_FONT;
        _label.textColor = HUD_STATUS_COLOR;
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _label.numberOfLines = 0;
    }
    if (_label.superview == nil) [_hud addSubview:_label];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)hudDestroy {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_label removeFromSuperview];		_label = nil;
    [_image removeFromSuperview];		_image = nil;
    [_spinner removeFromSuperview];		_spinner = nil;
    [_hud removeFromSuperview];			_hud = nil;
    [_background removeFromSuperview];	_background = nil;
}

- (void)hudSize {
    CGRect _labelRect = CGRectZero;
    CGFloat hudWidth = 100, hudHeight = 100;

    if (_label.text != nil) {
        NSDictionary *attributes = @{NSFontAttributeName:_label.font};
        NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
        _labelRect = [_label.text boundingRectWithSize:CGSizeMake(200, 300) options:options attributes:attributes context:NULL];
        
        _labelRect.origin.x = 12;
        _labelRect.origin.y = 66;
        
        hudWidth = _labelRect.size.width + 24;
        hudHeight = _labelRect.size.height + 80;
        
        if (hudWidth < 100) {
            hudWidth = 100;
            _labelRect.origin.x = 0;
            _labelRect.size.width = 100;
        }
    }

    _hud.bounds = CGRectMake(0, 0, hudWidth, hudHeight);

    CGFloat imagex = hudWidth/2;
    CGFloat imagey = (_label.text == nil) ? hudHeight/2 : 36;
    _image.center = _spinner.center = CGPointMake(imagex, imagey);

    _label.frame = _labelRect;
}

- (void)hudPosition:(NSNotification *)notification {
    CGFloat heightKeyboard = 0;
    NSTimeInterval duration = 0;
   
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
   
    if (notification != nil) {
        NSDictionary *keyboardInfo = [notification userInfo];
        duration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect keyboard = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        
        if ((notification.name == UIKeyboardWillShowNotification) || (notification.name == UIKeyboardDidShowNotification)) {
            if (UIInterfaceOrientationIsPortrait(orientation))
                heightKeyboard = keyboard.size.height;
            else heightKeyboard = keyboard.size.width;
        }
    }
    else heightKeyboard = [self keyboardHeight];

    CGRect screen = [UIScreen mainScreen].bounds;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        CGFloat temp = screen.size.width;
        screen.size.width = screen.size.height;
        screen.size.height = temp;
    }

    CGFloat posX = screen.size.width / 2;
    CGFloat posY = (screen.size.height - heightKeyboard) / 2;

    CGPoint center;
    if (orientation == UIInterfaceOrientationPortrait)				center = CGPointMake(posX, posY);
    if (orientation == UIInterfaceOrientationPortraitUpsideDown)	center = CGPointMake(posX, screen.size.height-posY);
    if (orientation == UIInterfaceOrientationLandscapeLeft)			center = CGPointMake(posY, posX);
    if (orientation == UIInterfaceOrientationLandscapeRight)		center = CGPointMake(screen.size.height-posY, posX);

    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _hud.center = CGPointMake(center.x, center.y);
        } completion:nil];
}

- (CGFloat)keyboardHeight {
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows])
    {
        if ([[testWindow class] isEqual:[UIWindow class]] == NO)
        {
            for (UIView *possibleKeyboard in [testWindow subviews])
            {
                if ([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] ||
                    [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")])
                    return possibleKeyboard.bounds.size.height;
            }
        }
    }
    return 0;
}

- (void)hudShow {
    if (self.alpha == 0) {
        self.alpha = 1;
        
        _hud.alpha = 0;
        _hud.transform = CGAffineTransformScale(_hud.transform, 1.4, 1.4);
        
        NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut;
        [UIView animateWithDuration:0.15 delay:0 options:options animations:^{
            _hud.transform = CGAffineTransformScale(_hud.transform, 1/1.4, 1/1.4);
            _hud.alpha = 1;
        } completion:nil];
    }
}

- (void)hudHide {
    if (self.alpha == 1) {
        NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
        [UIView animateWithDuration:0.15 delay:0 options:options
                         animations:^{
                             _hud.transform = CGAffineTransformScale(_hud.transform, 0.7, 0.7);
                             _hud.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self hudDestroy];
                             self.alpha = 0;
                         }];
    }
}

- (void)timedHide {
    @autoreleasepool {
        double length = _label.text.length;
        NSTimeInterval sleep = length * 0.04 + 0.5;
        
        [NSThread sleepForTimeInterval:sleep];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hudHide];
        });
    }
}


@end
