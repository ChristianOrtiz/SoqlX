// Copyright (c) 2006,2014 Simon Fell
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the 
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
// THE SOFTWARE.
//

#import "PlusMinusWidget.h"
#import "SchemaView.h"

@interface PlusMinusWidget ()
-(void)clearTrackingRect;
-(void)setTrackingRect;
-(void)setState:(pmButtonState)newState;
@end

@implementation PlusMinusWidget

@synthesize visible;

- (instancetype)initWithFrame:(NSRect)frame view:(SchemaView *)v andStyle:(pmButtonStyle)s {
    self = [super init];
    view = v;
    rect = frame;
    style = s;
    visible = YES;
    [self setTrackingRect];
    return self;
}

-(void)dealloc {
    [self clearTrackingRect];
}

-(NSPoint)origin {
    return rect.origin;
}

-(void)setOrigin:(NSPoint)aPoint {
    rect.origin = aPoint;
    [self resetTrackingRect];
}

-(pmButtonState)state {
    return state;
}

-(void)setState:(pmButtonState)newState {
    if (state == newState) return;
    state = newState;
    [view setNeedsDisplayInRect:rect];
}

-(void)setTarget:(id)aTarget andAction:(SEL)anAction {
    // we explicity don't retain this to stop a ref counting loop.
    target = aTarget;
    action = anAction;
}

- (void)resetTrackingRect {
    [self clearTrackingRect];
    [self setTrackingRect];
}

-(void)clearTrackingRect {
    [view removeTrackingRect:tagRect];
    tagRect = 0;    
}

-(void)setTrackingRect {
    tagRect = [view addTrackingRect:rect owner:self];
    [self setState:[view mousePointerIsInsideRect:rect] ? pmInside : pmOutside];
}

-(void)mouseEntered:(NSEvent *)event {
    [self setState:pmInside];
}

-(void)mouseExited:(NSEvent *)event {
    [self setState:pmOutside];
}

-(void)mouseDown:(NSEvent *)event {
    [self setState:pmDown];
}

-(void)mouseUp:(NSEvent *)event {
    if (state != pmDown) return;
    [self setState:pmInside];
    [target performSelector:action];
}

-(void)drawRect:(NSRect)dirtyRect
{
    if (!visible) return;
    if (state != pmOutside)
        [[NSColor blackColor] set];
    else 
        [[NSColor whiteColor] set];
    NSFrameRect(rect);
    if (state == pmDown)
        [[NSColor blackColor] set];
    else
        [[NSColor whiteColor] set];
    NSRectFill(NSInsetRect(rect,2,rect.size.height/2-1));
    if (style == pmPlusButton) 
        NSRectFill(NSInsetRect(rect,rect.size.width/2-1,2));
}


@end
