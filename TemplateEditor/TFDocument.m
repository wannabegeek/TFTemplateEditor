//
//  TFDocument.m
//  TemplateEditor
//
//  Created by Tom Fewster on 02/10/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import "TFDocument.h"
#import "TFTextElementAttachmentCell.h"

@interface TFDocument ()
@property (strong) IBOutlet NSTextView *textField;
@end

@implementation TFDocument

@synthesize textField = _textField;
@synthesize documentContents = _documentContents;

- (id)init
{
    self = [super init];
    if (self) {
		// Add your subclass-specific initialization here.
    }
    return self;
}

- (void)awakeFromNib {
    [_textField textStorage].delegate = self;
}

- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"TFDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (BOOL)replateTokensInString:(NSMutableAttributedString *)string {
    
    NSError *error = nil;
    
    NSRegularExpression *logicalMatch = [NSRegularExpression regularExpressionWithPattern:@"\\{\%[\\w\\d\\s.-|]*%\\}"
                                                                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                                                    error:&error];
    
	NSString *documentAsString = [string string];
    
	NSArray *matches = [logicalMatch matchesInString:documentAsString options:0 range:NSMakeRange(0, [documentAsString length])];
    
	[matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
		NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithFileWrapper:nil];
		TFTextElementAttachmentCell *cell = [[TFTextElementAttachmentCell alloc] init];
		cell.element = [documentAsString substringWithRange:[obj range]];
		NSLog(@"Found: %@", cell.element);
		cell.font = _textField.font;
		[attachment setAttachmentCell:cell];
		NSAttributedString *element = [NSMutableAttributedString attributedStringWithAttachment:attachment];
        
		[string replaceCharactersInRange:[obj range] withAttributedString:element];
	}];
    
	documentAsString = [string string];
    
	NSRegularExpression *printMatch = [NSRegularExpression regularExpressionWithPattern:@"\\{\\{[\\w\\d\\s.-|:\"']*\\}\\}"
                                                                                options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                                                  error:&error];
    
	matches = [printMatch matchesInString:documentAsString options:0 range:NSMakeRange(0, [documentAsString length])];
    
	[matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
		NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithFileWrapper:nil];
		TFTextElementAttachmentCell *cell = [[TFTextElementAttachmentCell alloc] init];
		cell.element = [documentAsString substringWithRange:[obj range]];
		NSLog(@"Found: %@", cell.element);
		cell.font = _textField.font;
		[attachment setAttachmentCell:cell];
		NSAttributedString *element = [NSMutableAttributedString attributedStringWithAttachment:attachment];
        
		[string replaceCharactersInRange:[obj range] withAttributedString:element];
	}];
    
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	NSMutableAttributedString *s = [self.documentContents mutableCopy];
	[s enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, s.length) options:NSAttributedStringEnumerationReverse|NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
		NSAttributedString *b = [s attributedSubstringFromRange:range];
//		[s replaceCharactersInRange:range withAttributedString:((TFTextElementAttachmentCell *)value)];
//		NSLog(@"%@", [self.documentContents repl]);

	}];
	NSLog(@"%@", [self.documentContents string]);
	// Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
	// You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
//	NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//	@throw exception;
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	NSError *error = nil;
	NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSPlainTextDocumentType};
	NSMutableAttributedString *documentData = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:&error];

    [self replateTokensInString:documentData];

	self.documentContents = documentData;
	return YES;
}

NSString *TFTemplatMarkupPboardType = @"com.wannabegeek.TemplateMarkup";

- (NSArray *)textView:(NSTextView *)aTextView writablePasteboardTypesForCell:(id <NSTextAttachmentCell>)cell atIndex:(NSUInteger)charIndex {
    return [NSArray arrayWithObject:TFTemplatMarkupPboardType];
}

- (BOOL)textView:(NSTextView *)aTextView writeCell:(id <NSTextAttachmentCell>)cell atIndex:(NSUInteger)charIndex toPasteboard:(NSPasteboard *)pboard type:(NSString *)type {
    if (type == TFTemplatMarkupPboardType) {
        [pboard writeObjects:[NSArray arrayWithObject:((TFTextElementAttachmentCell *)cell).element]];
    }
    
    return YES;
}

- (void)textStorageWillProcessEditing:(NSNotification *)note {
//    NSTextStorage *text = note.object;
//	Syntax Highlighting goes here
//    [self replateTokensInString:text];
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRanges:(NSArray *)affectedRanges replacementStrings:(NSArray *)replacementStrings {
	NSMutableArray *r = [NSMutableArray array];
	for (NSValue *rangeValue in affectedRanges) {
		NSRange range = [rangeValue rangeValue];
		NSMutableAttributedString *s = [[_documentContents attributedSubstringFromRange:range] mutableCopy];
		NSLog(@"Affected String '%@' {%ld, %ld}", s, range.location, range.length);
		[self replateTokensInString:s];
		[r addObject:s];
	}

	replacementStrings = [r copy];
	NSLog(@"Text changing");
	return YES;
}

@end
