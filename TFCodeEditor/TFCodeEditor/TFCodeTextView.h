//
//  TFCodeTextView.h
//  TFTemplateEditor
//
//  Created by Tom Fewster on 06/11/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	UNKNOWN = 0,
	HTML = 1,
	CSS = 2
} SyntaxDefinitionType;

@interface TFCodeTextView : NSTextView

- (void)setSyntaxDefinitionType:(SyntaxDefinitionType)syntaxType;

@end
