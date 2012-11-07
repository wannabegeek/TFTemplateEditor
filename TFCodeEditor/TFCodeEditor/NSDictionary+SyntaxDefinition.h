//
//  NSDictionary+SyntaxDefinition.h
//  TFTemplateEditor
//
//  Created by Tom Fewster on 02/11/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *TFMultilineComment;
extern NSString *TFSingleLineComment;
extern NSString *TFString1Charactor;
extern NSString *TFString2Charactor;
extern NSString *TFCommandStart;
extern NSString *TFCommandEnd;

@interface NSDictionary (SyntaxDefinition)

@property (readonly) NSString *commandStart;
@property (readonly) NSString *commandEnd;
@property (readonly) NSString *multilineComment;
@property (readonly) NSString *singleLineComment;
@property (readonly) NSString *string1Charactor;
@property (readonly) NSString *string2Charactor;

@property (readonly) NSRegularExpression *stringMatch;
@property (readonly) NSRegularExpression *multilineCommentMatch;
@property (readonly) NSRegularExpression *singlelineCommentMatch;
@property (readonly) NSRegularExpression *keywordMatch;
@property (readonly) NSRegularExpression *commandMatch;
@end
