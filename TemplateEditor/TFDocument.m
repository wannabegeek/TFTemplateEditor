//
//  TFDocument.m
//  TemplateEditor
//
//  Created by Tom Fewster on 02/10/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import "TFDocument.h"
#import <TFTemplateEditor/TFTemplateEditor.h>

@interface TFDocument ()

@property (strong) IBOutlet TFTemplateCodeTextView *textField;
@property (strong) NSString *documentType;
@end

@implementation TFDocument

@synthesize textField = _textField;
@synthesize documentContents = _documentContents;
@synthesize documentType = _documentType;

- (void)awakeFromNib {
	if ([_documentType isEqualToString:@"TFTemplateDocument"]) {
		[_textField setSyntaxDefinitionType:HTML];
	} else if ([_documentType isEqualToString:@"TFTemplateStyleSheet"]) {
		[_textField setSyntaxDefinitionType:CSS];
	} else {
		[_textField setSyntaxDefinitionType:UNKNOWN];
	}
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

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	NSError *error = nil;
	NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSPlainTextDocumentType};
	NSAttributedString *string = [_documentContents stringWithoutTokens];
	NSData *data = [string dataFromRange:NSMakeRange(0, string.length) documentAttributes:options error:&error];
	if (error) {
		NSLog(@"%@", error);
	}
	return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	NSError *error = nil;
	NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSPlainTextDocumentType};
	self.documentContents = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:&error];

	_documentType = typeName;
	if (_textField) {
		if ([_documentType isEqualToString:@"TFTemplateDocument"]) {
			[_textField setSyntaxDefinitionType:HTML];
		} else if ([_documentType isEqualToString:@"TFTemplateStyleSheet"]) {
			[_textField setSyntaxDefinitionType:CSS];
		} else {
			[_textField setSyntaxDefinitionType:UNKNOWN];
		}
	}
	
    [_documentContents replaceTokensInRange:NSMakeRange(0, _documentContents.length)];
	return YES;
}

@end
