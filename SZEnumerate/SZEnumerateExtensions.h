//
//  NSArray+SZEnumerateArray.h
//  SZEnumerate
//
//  Created by Thomas Sherwood on 18/07/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^SZEnumerationPredicate)(id);
typedef void(^SZEnumerationAction)(id);
typedef id(^SZEnumerationExtraction)(id);

@interface NSArray (SZEnumerateArray)

- (BOOL)sz_any;
- (BOOL)sz_any:(SZEnumerationPredicate)predicate;
- (BOOL)sz_all:(SZEnumerationPredicate)predicate;
- (NSInteger)sz_countWhere:(SZEnumerationPredicate)predicate;
- (void)sz_enumerateKindsOfClass:(Class)class usingBlock:(SZEnumerationAction)action;
- (void)sz_enumerateObjectsConformingToProtocol:(Protocol *)protocol usingBlock:(SZEnumerationAction)action;
- (void)sz_enumerateWhere:(SZEnumerationPredicate)predicate usingSelector:(SEL)selector against:(id)reciever;
- (void)sz_enumerateWhere:(SZEnumerationPredicate)predicate usingBlock:(SZEnumerationAction)action;
- (NSArray *)sz_extractUsingBlock:(SZEnumerationExtraction)extraction;
- (NSArray *)sz_extractWhere:(SZEnumerationPredicate)predicate usingBlock:(SZEnumerationExtraction)extraction;
- (BOOL)sz_none;
- (BOOL)sz_none:(SZEnumerationPredicate)predicate;

@end
