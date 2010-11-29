//
//  AlarmQuickTImes.m
//  IoGee
//
//  Created by Nathan Stitt on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmQuickTImes.h"
#import "AlarmView.h"
#import "Note.h"

@implementation AlarmQuickTimes

@synthesize view=picker,wasSet;

-(id)initWithAlarmView:(AlarmView*)view {
	self = [ super init ];
	alarmView = view;
	picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, 320, 270)];
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
	picker.dataSource = self;
	
	NSString *plist = [ [[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"alarm_times.plist"];
	choicesTimes = [ [ NSMutableDictionary alloc] initWithContentsOfFile: plist ];
	[ choicesTimes retain ];
	quickChoices = [ choicesTimes keysSortedByValueUsingSelector:@selector(compare:)];
	[ quickChoices retain ];

	return self;
}

-(void)setFromNote:(Note*)note{
	if ( note.alarmName ){
		[ picker selectRow:[ quickChoices indexOfObject: note.alarmName	] inComponent:0 animated:NO ];
	}
}

-(void)saveToNote:(Note*)note{
	NSString *name = [ quickChoices objectAtIndex:[ picker selectedRowInComponent:0 ] ];
	[ note setFireName:name minutes: [ choicesTimes objectForKey:name ] ];
}

-(NSDate*)date{
	NSNumber *minutes = [ choicesTimes valueForKey: [ quickChoices objectAtIndex: [ picker selectedRowInComponent:0 ] ] ];
	if ( [ minutes boolValue ] ){
		return NULL;
	} else {
		return [ NSDate dateWithTimeIntervalSinceNow: [ minutes intValue ] * 60 ];
	}
}

- (void)dealloc {
	[ picker release ];
	[ super dealloc  ];
}

#pragma mark PickerViewController delegate methods


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	wasSet = YES;
	[ alarmView quickSelectionMade ];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
        return 1;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
        return [ quickChoices count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	id val = [ quickChoices objectAtIndex:row ];
	return val;
}


@end