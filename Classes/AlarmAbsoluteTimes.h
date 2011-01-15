//
//  AlarmAbsoluteTimes.h
//  Mr Naggles
//
//  Created by Nathan Stitt on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Note;

@interface AlarmAbsoluteTimes : NSObject {
	UIDatePicker *picker;
}

-(void)reset;
-(void)saveToNote:(Note*)note;

@property (readonly,nonatomic) UIView *view;
@property (nonatomic,assign) NSDate *date;
@end