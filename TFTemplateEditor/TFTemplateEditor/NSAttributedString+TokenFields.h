//
//  NSAttributedString+TokenFields.h
//  TFTemplateEditor
//
//  Created by Tom Fewster on 07/11/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (TokenFields)

@property (readonly, strong) NSMutableAttributedString *stringWithoutTokens;

@end
