//
//  Note.m
//  IoGee
//
//  Created by Nathan Stitt on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Note.h"
#import "NSDate+HumanInterval.h"

@interface Note()
//@property (nonatomic,retain) NSString *dir;
@end


@implementation Note

@synthesize directory,image, notification;

-(id)initWithDirectoryName:(NSString*)d{
    self = [super init ];
	self.directory = d;
	NSLog(@"path=%@",[ directory stringByAppendingPathComponent:@"info.plist" ] );
	
	plist = [ [ NSMutableDictionary alloc] initWithContentsOfFile: [ directory stringByAppendingPathComponent:@"info.plist" ] ];
	if ( ! [ plist valueForKey:@"dateCreated" ] ){
		[ plist setObject:[NSDate date] forKey:@"dateCreated" ];
	}
	image = [ UIImage imageWithContentsOfFile: [ directory stringByAppendingPathComponent:@"image.png" ] ];
	
	[ image retain ];
	
	return self;
}

-(NSString*)alarmDescription{
	NSString *alarm = self.alarmName;
	NSDate *fire = [ notification fireDate ];
	if ( alarm && fire ){
		return [NSString stringWithFormat:@"%@ timer\n%@ left",
					alarm,
					[ fire humanIntervalSinceNow] 
				];
	} else if ( fire ){
		return [ fire humanIntervalSinceNow];
	} else { 
		return @"alarm not set";
	}
}

-(void)setFireName:(NSString*)name minutes:(NSNumber*)minutes{
	[plist setObject:name forKey:@"alarmName"];
	[plist setObject:minutes forKey:@"alarmMinutes"];
	if ( [ minutes boolValue ] ){
		[ plist setObject: [ NSDate dateWithTimeIntervalSinceNow: [ minutes intValue ] * 60 ] forKey:@"fireDate" ];
	}
}

-(void)deleteFromDisk {
	NSFileManager *fm = [NSFileManager defaultManager];
	[ fm removeItemAtPath: directory error:NULL ];
}

-(NSString *) alarmName {
	return [ plist valueForKey:@"alarmName" ];
}

- (NSNumber *) alarmMinutes {
	return [ plist valueForKey:@"alarmMinutes" ];
}

-(BOOL)hasNotification{
	return NULL != notification;
}

-(NSDate*)lastSave {
	return [ plist valueForKey: @"lastSave" ];
}

-(NSDate*)dateCreated {
	return [ plist valueForKey: @"dateCreated" ];
}

-(void)save {
	[ plist setObject:[NSDate date] forKey:@"lastSave" ];
	[ plist writeToFile:[ directory stringByAppendingPathComponent:@"info.plist" ] atomically: YES ];
	[ UIImagePNGRepresentation(image) writeToFile:[ directory stringByAppendingPathComponent:@"image.png" ] atomically:YES];
}


-(void)scedule {
	UIApplication *app = [UIApplication sharedApplication];
	if ( ! notification ){
		notification = [[UILocalNotification alloc] init];
	} else {
		[ app cancelLocalNotification: notification ];
	}
	notification.fireDate = [ plist valueForKey: @"fireDate" ];
	notification.timeZone = [NSTimeZone defaultTimeZone];
	notification.alertBody = self.alarmName ? self.alarmName : @"IoGee Alarm";
	notification.alertLaunchImage = [ directory stringByAppendingPathComponent:@"image.png" ];
	notification.alertAction = @"View Note";
	notification.soundName = UILocalNotificationDefaultSoundName;
	notification.applicationIconBadgeNumber = 1;
		
	NSDictionary *infoDict = [NSDictionary dictionaryWithObject: directory forKey:@"directory"];
	notification.userInfo = infoDict;
	[ app scheduleLocalNotification:notification ];
}


-(void)setImage:(UIImage*)img{
	if ( image != img ){
		[ image release ];
		[ img retain ];
		image = img;
		[UIImagePNGRepresentation(image) writeToFile:[ directory stringByAppendingPathComponent:@"image.png" ] atomically:YES];
	}
}

- (void)dealloc {
	[ notification release];
	[ directory    release ];
	[ image release ];
	[ plist release ];
    [ super dealloc ];
}
@end