//
//  PHO_MainShowView.m
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "PHO_MainShowView.h"

#import "UIImage+processing.h"

@implementation PHO_MainShowView

@synthesize showImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initshowView];
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initshowView];
        // Initialization code
    }
    return self;
}

-(void)initshowView
{
    //    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 320, 320)];
    //    backView.backgroundColor = [UIColor clearColor];
    //    [self addSubview:backView];
    
    beginangel = 0;
    beginDistance = 0;
    
    showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    //    show.backgroundColor = [UIColor redColor];
    //    show.image = [UIImage imageNamed:@"image3.png"];
    showImageView.userInteractionEnabled = YES;
    [self addSubview:showImageView];
    
    //缩放旋转按扭
    //    resizeview = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width-20, self.bounds.size.height-20, 20, 20)];
    //    resizeview.backgroundColor = [UIColor clearColor];
    //    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    //    image.image = [UIImage imageNamed:@"scale.png"];
    //    [resizeview addSubview:image];
    //    [self addSubview:resizeview];
    
    //    beginangel = atan2f(self.frame.origin.y+self.frame.size.height - self.center.y,
    //                        self.frame.origin.x+self.frame.size.width - self.center.x);
    
    //    UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panrecognizerbegain:)];
    //    [resizeview addGestureRecognizer:panrecognizer];
    
    //移动手势
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [showImageView addGestureRecognizer:panRecognizer];
    
    //缩放手势
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [showImageView addGestureRecognizer:pinchRecognizer];
    
    //旋转手势
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [showImageView addGestureRecognizer:rotationRecognizer];
    
    pinchRecognizer.delegate = self;
    rotationRecognizer.delegate = self;
    panRecognizer.delegate = self;


}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if ([[[event allTouches]allObjects]count] == 2)
//    {
//        CGPoint point1_1 = [[[[event allTouches]allObjects] objectAtIndex:0] locationInView:self.superview];
//        CGPoint point2_1 = [[[[event allTouches]allObjects] objectAtIndex:1] locationInView:self.superview];
//        
//        
//        CGFloat sub_x=point1_1.x-point2_1.x;
//        CGFloat sub_y=point1_1.y-point2_1.y;
//        
//        beginDistance = sqrtf(sub_x*sub_x+sub_y*sub_y);
//        
//        beginangel = atan2f(point1_1.y-point2_1.y, point1_1.x-point2_1.x);
//    }
//    
//}

//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSArray *touchArray = [NSArray arrayWithArray:[[event allTouches] allObjects]];
//    
//    if ([touchArray count] == 1)
//    {
//        UITouch *touch = [touches anyObject];
//        CGPoint point2 = [touch locationInView:self.superview];
//        CGPoint point1 = [touch previousLocationInView:self.superview];
//        
//        self.center = CGPointMake(self.center.x + (point2.x-point1.x), self.center.y + (point2.y-point1.y));
//    }
//    else if ([touchArray count] == 2)
//    {
//        
//        CGPoint point1_1 = [[touchArray objectAtIndex:0] locationInView:self.superview];
//        CGPoint point2_1 = [[touchArray objectAtIndex:1] locationInView:self.superview];
//        
//		
//		CGFloat sub_x=point1_1.x-point2_1.x;
//		CGFloat sub_y=point1_1.y-point2_1.y;
//		
//		CGFloat currentDistance= sqrtf(sub_x*sub_x+sub_y*sub_y);
//        
//        CGFloat changeDistance = beginDistance - currentDistance;
//		
//		if (changeDistance > 0)
//        {
//			//缩小
//            showImageView.frame = CGRectMake(showImageView.frame.origin.x+changeDistance/2, showImageView.frame.origin.y+changeDistance/2, showImageView.frame.size.width-changeDistance, showImageView.frame.size.height-changeDistance);
//            beginDistance = currentDistance;
//		}
//        else
//        {
//            //放大
//            showImageView.frame = CGRectMake(showImageView.frame.origin.x+changeDistance/2, showImageView.frame.origin.y+changeDistance/2, showImageView.frame.size.width-changeDistance, showImageView.frame.size.height-changeDistance);
//            beginDistance = currentDistance;
//        }
//        //旋转
//        
//        
//        CGFloat changeAngel = beginangel - atan2f(point1_1.y-point2_1.y,point1_1.x-point2_1.x);
//        
//        self.transform = CGAffineTransformMakeRotation(-changeAngel);
//        [self setNeedsDisplay];
//    }
//    
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if ([[[event allTouches] allObjects] count] == 2)
//    {
//        beginangel = 0;
//        beginDistance = 0;
//    }
//}

/**********************************************************
 函数名称：-(void)getPicture:(UIImage *)picture
 函数描述：获得用户所选图片
 输入参数：（UIImage *）picture:用户选择的图片
 输出参数：无
 返回值：  无
 **********************************************************/

- (void)getPicture:(UIImage *)picture
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, self.frame.size.height), NO, 0);
    NSLog(@"%f---%f",self.frame.size.width,self.frame.size.height);
    //    [picture drawAtPoint:CGPointMake(0,0)];
    //
    //    [picture drawAtPoint:CGPointMake(self.frame.size.width,0)];
    
    [picture drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    UIImage *im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (im.size.width >= im.size.height)
    {
        if (im.size.height < 1080 )
        {
            im = [im rescaleImageToSize:CGSizeMake(im.size.height, im.size.height)];
        }
        else if (im.size.height > 1080)
        {
            im = [im rescaleImageToSize:CGSizeMake(1080, 1080)];
        }
    }
    else if (im.size.width < im.size.height)
    {
        if (im.size.width < 1080)
        {
            im = [im rescaleImageToSize:CGSizeMake(im.size.width, im.size.width)];
        }
        else if (im.size.width > 1080)
        {
            im = [im rescaleImageToSize:CGSizeMake(1080, 1080)];
        }
    }

    showImageView.image = im;
    
}


#pragma mark -
#pragma mark 缩放编辑图片
-(void)scale:(UIPinchGestureRecognizer*)sender
{
    
    //当手指离开屏幕时,将lastscale设置为1.0
    if([sender state] == UIGestureRecognizerStateEnded)
    {
        lastScale = 1.0;
        return;
    }
    
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = showImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [showImageView setTransform:newTransform];
    lastScale = [sender scale];
    
}


#pragma mark 旋转编译图片
- (void)rotate:(UIRotationGestureRecognizer *)sender
{
    
    if([sender state] == UIGestureRecognizerStateEnded)
    {
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [sender rotation]);
    CGAffineTransform currentTransform = sender.view.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [sender.view setTransform:newTransform];
    _lastRotation = [sender rotation];
}

#pragma mark -
#pragma mark 移动编译图片

-(void)move:(id)sender
{
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self];
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan)
    {
        _firstX = [showImageView center].x;
        _firstY = [showImageView center].y;
    }
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    [showImageView setCenter:translatedPoint];
}

- (void)handelPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)showOverlayWithFrame:(CGRect)rect
{
    [showImageView setFrame:rect];
}

#pragma mark -
#pragma mark 移动图片


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
