//
//  IconView.m
//  IconView
//
//  Created by Marcus Crafter on 30/04/11.
//  http://redartisan.com/2011/05/13/porting-iconapp-core-graphics
//
//  Ported from IconApp created by Matt Gallagher at http://cocoawithlove.com/2011/01/advanced-drawing-using-appkit.html
//

#import "IconView.h"

@interface IconView ()
@property (nonatomic, readonly) CGRect nativeRect;
@end


@implementation IconView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1.0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    // determine aspect ratio and scale from native resolution to current bounds size
    
    CGSize boundsSize = self.bounds.size;
    CGSize nativeSize = self.nativeRect.size;
    CGFloat nativeAspect = nativeSize.width / nativeSize.height;
    CGFloat boundsAspect = boundsSize.width / boundsSize.height;
    CGFloat scale = nativeAspect > boundsAspect ?
        boundsSize.width / nativeSize.width :
        boundsSize.height / nativeSize.height;
    
    // transform to current bounds
    CGContextTranslateCTM(context, 
                          0.5 * (boundsSize.width  - scale * nativeSize.width),
                          0.5 * (boundsSize.height - scale * nativeSize.height));
    CGContextScaleCTM(context, scale, scale);
    
    // circle with shadow
    CGColorSpaceRef colourspace = CGColorSpaceCreateDeviceGray();
    CGFloat shadowComponents[] = { 0.0, 0.75 };
    CGColorRef shadowColor = CGColorCreate(colourspace, shadowComponents);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 8 * scale), 12 * scale, shadowColor);
    CGContextSetGrayFillColor(context, 0.9, 1.0);
    CGContextFillEllipseInRect(context, self.nativeRect);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0, NULL); // disable shadow
    CGColorRelease(shadowColor);
    CGColorSpaceRelease(colourspace);
    
    // inner circle with gradient
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, self.nativeRect);
    CGContextClip(context);
    
    colourspace = CGColorSpaceCreateDeviceGray();    
    CGFloat components[] = { 1.0, 1.0, 0.82, 1.0 };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colourspace, components, NULL, 2);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, nativeSize.height), 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colourspace);
    CGContextRestoreGState(context);
    
    // black center, inset within larger circle
    CGRect ellipseCenterRect = CGRectInset(self.nativeRect, 16, 16);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillEllipseInRect(context, ellipseCenterRect);
    CGContextAddEllipseInRect(context, ellipseCenterRect);
    CGContextClip(context);

    
    // bottom glow gradient
    colourspace = CGColorSpaceCreateDeviceRGB();
    CGFloat bComponents[] = { 0.0, 0.94, 0.82, 1.0,
                              0.0, 0.62, 0.56, 1.0,
                              0.0, 0.05, 0.35, 1.0,
                              0.0, 0.00, 0.00, 1.0 };
    CGFloat bGlocations[] = { 0.0, 0.35, 0.60, 0.7 };
    gradient = CGGradientCreateWithColorComponents(colourspace, bComponents, bGlocations, 4);
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(ellipseCenterRect), CGRectGetMidY(ellipseCenterRect) + (CGRectGetHeight(ellipseCenterRect) * 0.1));
    CGContextDrawRadialGradient(context, gradient, centerPoint, 0.0, centerPoint, CGRectGetHeight(ellipseCenterRect) * 0.8, 0);
    CGGradientRelease(gradient);
    
    // top glow gradient
    CGFloat tComponents[] = { 0.0, 0.68, 1.00, 0.75,
                              0.0, 0.45, 0.62, 0.55,
                              0.0, 0.45, 0.62, 0.00 };
    CGFloat tGlocations[] = { 0.0, 0.25, 0.40 };
    gradient = CGGradientCreateWithColorComponents(colourspace, tComponents, tGlocations, 3);
    centerPoint = CGPointMake(CGRectGetMidX(ellipseCenterRect), CGRectGetMidY(ellipseCenterRect) - (CGRectGetHeight(ellipseCenterRect) * 0.2));
    CGContextDrawRadialGradient(context, gradient, centerPoint, 0.0, centerPoint, CGRectGetHeight(ellipseCenterRect) * 0.8, 0);
    CGGradientRelease(gradient);

    // center glow gradient
    CGFloat cComponents[] = { 0.0, 0.90, 0.90, 0.90,
                              0.0, 0.49, 1.00, 0.00 };
    CGFloat cGlocations[] = { 0.0, 0.85 };
    gradient = CGGradientCreateWithColorComponents(colourspace, cComponents, cGlocations, 2);
    centerPoint = CGPointMake(CGRectGetMidX(ellipseCenterRect), CGRectGetMidY(ellipseCenterRect));
    CGContextDrawRadialGradient(context, gradient, centerPoint, 0.0, centerPoint, CGRectGetHeight(ellipseCenterRect) * 0.8, 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colourspace);

    // floral shadow
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeZero, 12 * scale, [UIColor blackColor].CGColor);
    
    // draw floral heart
    NSString * floralHeart = @"\u2766";
    UIFont * floralHeartFont = [UIFont fontWithName:@"Arial Unicode MS" size:420];
    CGSize textSize = [floralHeart sizeWithFont:floralHeartFont];
    
    CGPoint point = CGPointMake((CGRectGetWidth(ellipseCenterRect) - textSize.width) / 2.0,
                                (CGRectGetHeight(ellipseCenterRect) - textSize.height) / 2.0);
    
    CGContextSetGrayFillColor(context, 0.9, 1.0);
    [floralHeart drawAtPoint:point withFont:floralHeartFont];
    
    CGContextRestoreGState(context);

    // gloss arc
    const CGFloat glossInset = 8;
	CGFloat glossRadius = (CGRectGetWidth(ellipseCenterRect) * 0.5) - glossInset;
	double arcFraction = 0.1;
    
    CGPoint topArcCenter = CGPointMake(CGRectGetMidX(ellipseCenterRect), CGRectGetMidY(ellipseCenterRect));
    CGPoint arcStartPoint = CGPointMake(topArcCenter.x + glossRadius * cos((2 * M_PI) - arcFraction),
                                        topArcCenter.y + glossRadius * sin((2 * M_PI) - arcFraction));
    CGContextAddArc(context, topArcCenter.x, topArcCenter.y, glossRadius, (2 * M_PI) - arcFraction, M_PI + arcFraction, 1);

    const CGFloat bottomArcBulgeDistance = 70;
    CGContextAddQuadCurveToPoint(context, topArcCenter.x, topArcCenter.y + bottomArcBulgeDistance, arcStartPoint.x, arcStartPoint.y);
    CGContextClip(context);

    colourspace = CGColorSpaceCreateDeviceGray();
    CGFloat glossLocations[]  = { 0.0, 0.5, 1.0 };
    CGFloat glossComponents[] = { 1.0, 0.85, 1.0, 0.50, 1.0, 0.05 };
    gradient = CGGradientCreateWithColorComponents(colourspace, glossComponents, glossLocations, 3);
    
    CGRect clippedRect = CGContextGetClipBoundingBox(context);
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(topArcCenter.x, CGRectGetMinY(clippedRect)),
                                CGPointMake(topArcCenter.x, CGRectGetMaxY(clippedRect)),
                                0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colourspace);

    // all done
    CGContextRestoreGState(context);
}

- (CGRect)nativeRect {
    return CGRectMake(0, 0, 512, 512);
}

@end
