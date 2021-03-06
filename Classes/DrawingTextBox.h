


#import "HPGrowingTextView.h"
#import "Note.h"

@class DrawingViewController;

@interface DrawingTextBox : HPGrowingTextView {
	UIImage *placardImage;
	NSString *currentDisplayString;
	CGFloat fontSize;
	CGSize textSize;
    DrawingViewController *dvc;
//	RoundedTextView *textView;
	NSArray *displayStrings;
	NSUInteger displayStringsIndex;
	CGPoint displacedFrom;
	NoteTextBlob *ntb;
	UIButton *deleteBtn;
}

@property (nonatomic) BOOL isEditing;

// Initializer for this object
- (id)initWithTextBlob:(NoteTextBlob*)ntb Controller:(DrawingViewController*)dcm;

- (void)liftUp;
- (void)moveTo:(CGPoint)point;
- (void)moveToAndDrop:(CGPoint)point;
@end
