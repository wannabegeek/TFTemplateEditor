//
//  TFCodeTextView.m
//  TFTemplateEditor
//
//  Created by Tom Fewster on 06/11/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import "TFCodeTextView.h"
#import "TFLineNumberView.h"
#import "NSMutableAttributedString+SyntaxHighlight.h"
#import "NSDictionary+SyntaxDefinition.h"

@interface TFCodeTextView ()
@property (strong) TFLineNumberView *lineNumberView;
@property (strong) NSDictionary *syntaxDefinition;
@end

@implementation TFCodeTextView

@synthesize syntaxDefinition = _syntaxDefinition;
@synthesize lineNumberView = _lineNumberView;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setSyntaxDefinitionType:(SyntaxDefinitionType)syntaxType {
	NSString *type = nil;
	switch (syntaxType) {
		case HTML:
			type = @"html";
			break;
		case CSS:
			type = @"css";
			break;

		default:
			break;
	}

	if (type) {
		Class c = [TFCodeTextView class];
		_syntaxDefinition = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle bundleForClass:c] URLForResource:type withExtension:@"plist"]];
	} else {
		_syntaxDefinition = nil;
	}

	[self.textStorage applySyntaxHighlight:_syntaxDefinition inRange:NSMakeRange(0, self.textStorage.length)];
}

- (void)awakeFromNib {
	self.font = [NSFont fontWithName:@"Menlo Regular" size:11.0f];

	_lineNumberView = [[TFLineNumberView alloc] initWithScrollView:self.enclosingScrollView];
	[self.enclosingScrollView setVerticalRulerView:_lineNumberView];
    [self.enclosingScrollView setHasHorizontalRuler:NO];
    [self.enclosingScrollView setHasVerticalRuler:YES];
    [self.enclosingScrollView setRulersVisible:YES];

	[[NSNotificationCenter defaultCenter] addObserverForName:NSTextStorageDidProcessEditingNotification object:self.textStorage queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
		NSTextStorage *textStorage = [note object];

		if (textStorage.changeInLength != 0) {
			NSRange range = textStorage.editedRange;

			if (_syntaxDefinition.commandStart && _syntaxDefinition.commandEnd) {
				NSRange found = [textStorage.string rangeOfString:_syntaxDefinition.commandStart options:NSCaseInsensitiveSearch|NSBackwardsSearch range:NSMakeRange(0, range.location + range.length)];
				NSRange found2 = [textStorage.string rangeOfString:_syntaxDefinition.commandEnd options:NSCaseInsensitiveSearch range:NSMakeRange(range.location, textStorage.string.length - range.location)];
				if (found.location == NSNotFound || found2.location == NSNotFound || found.location > found2.location) {
					[self.textStorage applySyntaxHighlight:_syntaxDefinition inRange:range];
				} else {
					NSLog(@"%ld [%ld]", found.location, found2.location - found.location + found2.length);
					[self.textStorage applySyntaxHighlight:_syntaxDefinition inRange:NSMakeRange(found.location, found2.location - found.location + found2.length)];
				}
			} else {
				[self.textStorage applySyntaxHighlight:_syntaxDefinition inRange:range];
			}
		}
	}];
}

@end
