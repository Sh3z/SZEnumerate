//
//  NSArray+SZEnumerateArray.m
//  SZEnumerate
//
//  Created by Thomas Sherwood on 18/07/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import "SZEnumerateExtensions.h"

@implementation NSArray (SZEnumerateArray)

- (BOOL)sz_any
{
	return self.count > 0;
}

- (BOOL)sz_any:(SZEnumerationPredicate)predicate
{
	if(!predicate) {
		return NO;
	}
	
	for(id obj in self) {
		if(predicate(obj)) {
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)sz_all:(SZEnumerationPredicate)predicate
{
	if(!predicate) {
		return NO;
	}
	
	for(id obj in self) {
		if(!predicate(obj)) {
			return NO;
		}
	}
	
	return YES;
}

- (NSInteger)sz_countWhere:(SZEnumerationPredicate)predicate
{
	if(!predicate) {
		return 0;
	}
	
	NSInteger count = 0;
	for(id obj in self) {
		if(predicate(obj)) {
			count++;
		}
	}
	
	return count;
}

- (void)sz_enumerateKindsOfClass:(Class)class usingBlock:(SZEnumerationAction)action
{
	[self sz_enumerateWhere:^BOOL(id arg) {
		return [arg isKindOfClass:class];
	} usingBlock:action];
}

- (void)sz_enumerateObjectsConformingToProtocol:(Protocol *)protocol usingBlock:(SZEnumerationAction)action
{
	[self sz_enumerateWhere:^BOOL(id arg) {
		return [arg conformsToProtocol:protocol];
	} usingBlock:action];
}

- (void)sz_enumerateWhere:(SZEnumerationPredicate)predicate usingSelector:(SEL)selector against:(id)reciever
{
	if(predicate && [reciever respondsToSelector:selector]) {
		IMP method = [reciever methodForSelector:selector];
		void (*function)(id, SEL, id) = (void *)method;
		
		for(id obj in self) {
			if(predicate(obj)) {
				function(reciever, selector, obj);
			}
		}
	}
}

- (void)sz_enumerateWhere:(SZEnumerationPredicate)predicate usingBlock:(SZEnumerationAction)action
{
	if(predicate && action) {
		for(id obj in self) {
			if(predicate(obj)) {
				action(obj);
			}
		}
	}
}

- (NSArray *)sz_extractUsingBlock:(SZEnumerationExtraction)extraction
{
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
	
	if(extraction) {
		for(id obj in self) {
			[result addObject:extraction(obj)];
		}
	}
	
	return result;
}

- (NSArray *)sz_extractWhere:(SZEnumerationPredicate)predicate usingBlock:(SZEnumerationExtraction)extraction
{
	NSMutableArray *result = [NSMutableArray new];
	
	if(predicate && extraction) {
		for(id obj in self) {
			if(predicate(obj)) {
				[result addObject:extraction(obj)];
			}
		}
	}
	
	return result;
}

- (BOOL)sz_none
{
	return self.count == 0;
}

- (BOOL)sz_none:(SZEnumerationPredicate)predicate
{
	if(!predicate) {
		return NO;
	}
	
	for(id obj in self) {
		if(predicate(obj)) {
			return NO;
		}
	}
	
	return YES;
}

@end
