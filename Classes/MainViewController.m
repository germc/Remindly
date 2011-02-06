/*  This file is part of Remindly.

    Remindly is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Remindly is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Remindly.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "MainViewController.h"
#import "AlarmViewController.h"
#import "ColorButton.h"
#import "DrawingViewController.h"
#import "NotesManager.h"
#import "StoreView.h"
#import "NoteSelectorController.h"


@implementation MainViewController

@synthesize drawing,selector,alarm;

- (id)init {
    self = [super init ];


	selector = [[ NoteSelectorController alloc ] initWithMainView:self ];

	drawing = [[ DrawingViewController alloc ] initWithMainView:self ];
	drawing.view.frame = CGRectMake(0, 0, 320, 420 );
	drawing.note = [ NotesManager noteAtIndex: 0 ]; 

	alarm = [[ AlarmViewController alloc ] init ];

	toolbar = [[MainToolBar alloc] initWithController:self];
	[ drawing.alarmTitle  addTarget:toolbar action:@selector(setAlarmPressed:) forControlEvents:UIControlEventTouchUpInside ];


	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDisplayNote:) name:@"DisplayNote" object:nil];

	self.view.backgroundColor = [ UIColor grayColor ];

    return self;
}


-(void)loadView {
    self.view = [ [ UIView alloc ] initWithFrame:CGRectMake(0, 0, 320, 480) ];
	[ self.view addSubview: drawing.view ];
	[ self.view addSubview: toolbar ];
	[ self.view addSubview: alarm ];
}

-(void) setDrawingMode:(BOOL)v {
	if ( v ){
		drawing.note = [ NotesManager noteAtIndex: [ selector currentIndex ] ];
        
        if ( [ selector isViewLoaded ] ){
            [ selector.view removeFromSuperview ];
        }
        drawing.view.hidden = NO;
	} else {
		Note *note = drawing.note;

        [ self.view addSubview: selector.view ];
		drawing.view.hidden  = YES;
		[selector selectNoteIndex: note.index ];

		[selector reload: note ];
	}
	[ toolbar setDrawingMode:v ];

}


-(BOOL) drawingMode {
	return ( nil != drawing.view.superview );
}


-(void) toggleDrawingMode {
	self.drawingMode = ! self.drawingMode;
}


-(void) selectNote:(Note*)note{
	drawing.note = note;
	[ selector selectNoteIndex: note.index ];
	[ self setDrawingMode:YES ];
	
}

-(void)onDisplayNote:(NSNotification*)notif{
	[ self selectNote:(Note*)notif.object ];
}


-(void)viewWillAppear:(BOOL)animated{
	[ super viewWillAppear:animated ];
	[ drawing viewWillAppear:animated ];
	[ self setDrawingMode: YES ];
}


-(void)viewWillDisappear:(BOOL)animated{
	[ super viewWillDisappear:animated ];
	[ drawing.note save ];
}


- (void)dealloc {
	[ toolbar release ];
	[ selector release ];
	[ drawing release ];
    [super dealloc];
}


@end
