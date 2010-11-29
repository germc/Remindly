//
//  DrawingView.m
//  IoGee
//
//  Created by Nathan Stitt on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DrawingViewController.h"

@implementation DrawingViewController

@synthesize note;

- (id)init {
    self = [super init ];
	self.view.backgroundColor = [ UIColor whiteColor ];
	alarmLabel = [[UILabel alloc ] initWithFrame:CGRectMake(220, 10, 100, 50)];
	alarmLabel.lineBreakMode = UILineBreakModeTailTruncation;
	alarmLabel.textAlignment = UITextAlignmentRight;
	alarmLabel.numberOfLines = 0;
	alarmLabel.backgroundColor = [ UIColor clearColor ];
	
	[ self.view addSubview:alarmLabel ];
	
	drawImage = [[UIImageView alloc] initWithImage:nil];
	drawImage.frame = CGRectMake(0, 0, self.view.frame.size.width, 420);
	[ self.view addSubview:drawImage];
	mouseMoved = 0;
    return self;
}

-(void)setNote:(Note *)n{
	if ( note != n ){
		[ note release ];
		[ n retain ];
		note = n;
		[ self noteUpdated ];
	}
}

- (void)noteUpdated{
	mouseMoved = 0;
	alarmLabel.text = [note alarmDescription];
   	drawImage.image = note.image;
}

-(Note*)note{
	note.image = drawImage.image;
	return note;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		drawImage.image = nil;
		return;
	}

	lastPoint = [touch locationInView:self.view];
	//lastPoint.y -= 20;

}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = YES;

	UITouch *touch = [touches anyObject];	
	pointBeforeLast = lastPoint;

	CGPoint currentPoint = [touch locationInView:self.view];

//	NSLog(@"MOVED: y=%li",currentPoint.y );
//	currentPoint.y -= 20;

	UIGraphicsBeginImageContext(self.view.frame.size);
	[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);

	CGContextAddCurveToPoint(UIGraphicsGetCurrentContext(), 
							 pointBeforeLast.x,
							 pointBeforeLast.y,
							 lastPoint.x,
							 lastPoint.y,
							 currentPoint.x,
							 currentPoint.y );
	
	//CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	lastPoint = currentPoint;

	mouseMoved++;
	
	if (mouseMoved == 10) {
		mouseMoved = 0;
	}

}

- (void)clear {
	drawImage.image = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSLog(@"Touches Ended");
	
	if(!mouseSwiped) {
		UIGraphicsBeginImageContext(self.view.frame.size);
		[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
		drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end