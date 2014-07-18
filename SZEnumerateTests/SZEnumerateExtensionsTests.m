//
//  SZEnumerateExtensionsTests.m
//  SZEnumerate
//
//  Created by Thomas Sherwood on 18/07/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMockito/OCMockito.h>
#import "SZEnumerateExtensions.h"

@interface SZEnumerateExtensionsTests : XCTestCase
@end

@interface SZSelectorTargetMock : NSObject

@property (nonatomic, strong, readonly) id enumeratedObject;
- (void)didEnumerateObject:(id)obj;

@end

@implementation SZSelectorTargetMock

- (void)didEnumerateObject:(id)obj
{
	_enumeratedObject = obj;
}

@end

@implementation SZEnumerateExtensionsTests

#pragma mark - sz_any

- (void)testAnyWithEmptyArray
{
	NSArray *arr = @[];
	XCTAssertFalse([arr sz_any], @"");
}

- (void)testAnyWithArrayContainingOneObject
{
	NSArray *arr = @[@"Obj"];
	XCTAssertTrue([arr sz_any], @"");
}


#pragma mark - sz_any:

- (void)testAnyWithNilPredicateAndEmptyArray
{
	NSArray *arr = @[];
	SZEnumerationPredicate predicate = nil;
	XCTAssertFalse([arr sz_any:predicate], @"");
}

- (void)testAnyWithNilPredicateAndArrayContainingOneObject
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationPredicate predicate = nil;
	XCTAssertFalse([arr sz_any:predicate], @"");
}

- (void)testAnyWithPredicateAndEmptyArray
{
	NSArray *arr = @[];
	SZEnumerationPredicate predicate = ^BOOL(id arg){
		return arg != nil;
	};
	
	XCTAssertFalse([arr sz_any:predicate], @"");
}

- (void)testAnyWithPredicateAndArrayContainingOneObjectMatchingPredicate
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationPredicate predicate = ^BOOL(id arg){
		return arg != nil;
	};
	
	XCTAssertTrue([arr sz_any:predicate], @"");
}

- (void)testAnyWithPredicateAndArrayContainingOneObjectFailingPredicate
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationPredicate predicate = ^BOOL(id arg){
		return arg == nil;
	};
	
	XCTAssertFalse([arr sz_any:predicate], @"");
}


#pragma mark - sz_all:

- (void)testAllWithNilPredicateAndEmptyArray
{
	NSArray *arr = @[];
	SZEnumerationPredicate predicate = nil;
	XCTAssertFalse([arr sz_all:predicate], @"");
}

- (void)testAllWithPredicateAndEmptyArray
{
	NSArray *arr = @[];
	SZEnumerationPredicate predicate = ^BOOL(id arg) {
		return arg != nil;
	};
	
	XCTAssertTrue([arr sz_all:predicate], @"");
}

- (void)testAllWithPredicateAndArrayContainingOneObjectMatchingPredicate
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationPredicate predicate = ^BOOL(id arg) {
		return arg != nil;
	};
	
	XCTAssertTrue([arr sz_all:predicate], @"");
}

- (void)testAllWithPredicateAndArrayContainingOneObjectFailingPredicate
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationPredicate predicate = ^BOOL(id arg) {
		return arg == nil;
	};
	
	XCTAssertFalse([arr sz_all:predicate], @"");
}


#pragma mark - sz_countWhere:

- (void)testCountWhereWithNilPredicateAndEmptyArray
{
	NSArray *arr = @[];
	SZEnumerationPredicate predicate = nil;
	XCTAssertEqual(0, [arr sz_countWhere:predicate], @"");
}

- (void)testCountWhereWithNilPredicateAndArrayContainingOneObject
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationPredicate predicate = nil;
	XCTAssertEqual(0, [arr sz_countWhere:predicate], @"");
}

- (void)testCountWhereWithPredicateAndEmptyArray
{
	NSArray *arr = @[];
	SZEnumerationPredicate predicate = ^BOOL(id arg) {
		return arg != nil;
	};
	
	XCTAssertEqual(0, [arr sz_countWhere:predicate], @"");
}

- (void)testCountWhereWithPredicateAndArrayContainingOneObjectMatchingPredicate
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationPredicate predicate = ^BOOL(id arg) {
		return arg != nil;
	};
	
	XCTAssertEqual(1, [arr sz_countWhere:predicate], @"");
}

- (void)testCountWhereWithPredicateAndArrayContainingOneObjectFailingPredicate
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationPredicate predicate = ^BOOL(id arg) {
		return arg == nil;
	};
	
	XCTAssertEqual(0, [arr sz_countWhere:predicate], @"");
}


#pragma mark - sz_enumerateKindsOfClass:usingBlock:

- (void)testEnumerateKindsOfClassWithNilClassAndEmptyArray
{
	NSArray *arr = @[];
	Class class = nil;
	__block BOOL didEnumerate = NO;
	SZEnumerationAction action = ^(id arg) {
		didEnumerate = YES;
	};
	
	[arr sz_enumerateKindsOfClass:class usingBlock:action];
	XCTAssertFalse(didEnumerate, @"");
}

- (void)testEnumerateKindsOfClassWithClassAndEmptyArray
{
	NSArray *arr = @[];
	Class class = [NSObject class];
	__block BOOL didEnumerate = NO;
	SZEnumerationAction action = ^(id arg) {
		didEnumerate = YES;
	};
	
	[arr sz_enumerateKindsOfClass:class usingBlock:action];
	XCTAssertFalse(didEnumerate, @"");
}

- (void)testEnumerateKindsOfClassWithClassAndArrayWithOneObjectOfGivenClass
{
	NSArray *arr = @[[NSObject new]];
	Class class = [NSObject class];
	__block BOOL didEnumerate = NO;
	SZEnumerationAction action = ^(id arg) {
		didEnumerate = YES;
	};
	
	[arr sz_enumerateKindsOfClass:class usingBlock:action];
	XCTAssertTrue(didEnumerate, @"");
}

- (void)testEnumerateKindsOfClassWithClassAndArrayWithOneObjectNotOfGivenClass
{
	NSArray *arr = @[[NSObject new]];
	Class class = [NSString class];
	__block BOOL didEnumerate = NO;
	SZEnumerationAction action = ^(id arg) {
		didEnumerate = YES;
	};
	
	[arr sz_enumerateKindsOfClass:class usingBlock:action];
	XCTAssertFalse(didEnumerate, @"");
}


#pragma mark - sz_enumerateObjectsConformingToProtocol:usingBlock:

- (void)testEnumerateObjectsConformingToProtocolWithNilProtocolAndEmptyArray
{
	NSArray *arr = @[];
	Protocol *protocol = nil;
	__block BOOL didEnumerate = NO;
	SZEnumerationAction action = ^(id arg) {
		didEnumerate = YES;
	};
	
	[arr sz_enumerateObjectsConformingToProtocol:protocol usingBlock:action];
	XCTAssertFalse(didEnumerate, @"");
}

- (void)testEnumerateObjectsConformingToProtocolWithArrayContainingOneObjectConformingToProtocol
{
	Protocol *protocol = @protocol(NSObject);
	id<NSObject> protocolImpl = MKTMockProtocol(protocol);
	NSArray *arr = @[protocolImpl];
	__block BOOL didEnumerate = NO;
	SZEnumerationAction action = ^(id arg) {
		didEnumerate = YES;
	};
	
	[arr sz_enumerateObjectsConformingToProtocol:protocol usingBlock:action];
	XCTAssertTrue(didEnumerate, @"");
}

- (void)testEnumerateObjectsConformingToProtocolWithArrayContainingOneObjectNotConformingToProtocol
{
	Protocol *protocol = @protocol(NSCopying);
	id<NSObject> protocolImpl = MKTMockProtocol(@protocol(NSObject));
	NSArray *arr = @[protocolImpl];
	__block BOOL didEnumerate = NO;
	SZEnumerationAction action = ^(id arg) {
		didEnumerate = YES;
	};
	
	[arr sz_enumerateObjectsConformingToProtocol:protocol usingBlock:action];
	XCTAssertFalse(didEnumerate, @"");
}


#pragma mark - sz_enumerateWhere:usingSelector:against:

- (void)testEnumerateWhereWithSelectorTargetWithoutPredicate
{
	NSArray *arr = @[@"Obj"];
	SZSelectorTargetMock *mock = [SZSelectorTargetMock new];
	SEL selector = @selector(didEnumerateObject:);
	SZEnumerationPredicate predicate = nil;
	
	[arr sz_enumerateWhere:predicate usingSelector:selector against:mock];
	XCTAssertNil(mock.enumeratedObject, @"");
}

- (void)testEnumerateWhereWithSelectorTargetWithPredicateReturnsNo
{
	NSString *obj = @"Obj";
	NSArray *arr = @[obj];
	SZSelectorTargetMock *mock = [SZSelectorTargetMock new];
	SEL selector = @selector(didEnumerateObject:);
	SZEnumerationPredicate predicate = ^(id arg) {
		return NO;
	};
	
	[arr sz_enumerateWhere:predicate usingSelector:selector against:mock];
	XCTAssertNil(mock.enumeratedObject, @"");
}

- (void)testEnumerateWhereWithSelectorTargetWithPredicateReturnsYes
{
	NSString *obj = @"Obj";
	NSArray *arr = @[obj];
	SZSelectorTargetMock *mock = [SZSelectorTargetMock new];
	SEL selector = @selector(didEnumerateObject:);
	SZEnumerationPredicate predicate = ^(id arg) {
		return YES;
	};
	
	[arr sz_enumerateWhere:predicate usingSelector:selector against:mock];
	XCTAssertEqual(obj, mock.enumeratedObject, @"");
}

- (void)testEnumerateWhereWithSelectorTargetThatDoesNotRespondToSelector
{
	NSString *obj = @"Obj";
	NSArray *arr = @[obj];
	SZSelectorTargetMock *mock = [SZSelectorTargetMock new];
	
	// Some random selector the class does no respond to
	SEL selector = @selector(setAllowsNonnumericFormatting:);
	SZEnumerationPredicate predicate = ^(id arg) {
		return YES;
	};
	
	[arr sz_enumerateWhere:predicate usingSelector:selector against:mock];
	XCTAssertNil(mock.enumeratedObject, @"");
}


#pragma mark - sz_enumerateWhere:usingBlock:

- (void)testEnumerateWherePredicateReturnsNo
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationPredicate predicate = ^BOOL(id arg) {
		return NO;
	};
	
	__block BOOL didInvokeAction = NO;
	SZEnumerationAction action = ^(id arg){
		didInvokeAction = YES;
	};
	
	[arr sz_enumerateWhere:predicate usingBlock:action];
	XCTAssertFalse(didInvokeAction, @"");
}

- (void)testEnumerateWherePredicateReturnsYes
{
	NSString *obj = @"Obj";
	NSArray *arr = @[obj];
	SZEnumerationPredicate predicate = ^BOOL(id arg) {
		return YES;
	};
	
	__block BOOL didInvokeAction = NO;
	__block id enumeratedObject = nil;
	SZEnumerationAction action = ^(id arg){
		didInvokeAction = YES;
		enumeratedObject = arg;
	};
	
	[arr sz_enumerateWhere:predicate usingBlock:action];
	XCTAssertTrue(didInvokeAction, @"");
	XCTAssertEqual(enumeratedObject, obj, @"");
}


#pragma mark - sz_extractUsingBlock:

- (void)testExtractUsingNilBlock
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationExtraction extractor = nil;
	
	NSArray *extracted = [arr sz_extractUsingBlock:extractor];
	XCTAssertEqual(0, extracted.count, @"");
}

- (void)testExtractUsingBlock
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationExtraction extractor = ^id(id arg) {
		return [((NSString *)arg) substringWithRange:NSMakeRange(0, 1)];	// "O"
	};
	
	NSArray *extracted = [arr sz_extractUsingBlock:extractor];
	XCTAssertEqual(1, extracted.count, @"");
	XCTAssertTrue([@"O" isEqualToString:extracted[0]], @"");
}


#pragma mark sz_extractWhere:usingBlock:

- (void)testExtractWherePredicateBlockReturnsNo
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationPredicate predicate = ^BOOL(id arg) {
		return NO;
	};
	
	SZEnumerationExtraction extractor = ^id(id arg) {
		return [((NSString *)arg) substringWithRange:NSMakeRange(0, 1)];	// "O"
	};
	
	NSArray *extracted = [arr sz_extractWhere:predicate usingBlock:extractor];
	XCTAssertEqual(0, extracted.count, @"");
}

- (void)testExtractWherePredicateBlockReturnsYesOnCondition
{
	NSNumber *expected = @42;
	NSArray *arr = @[@"Obj", expected];
	SZEnumerationPredicate predicate = ^BOOL(id arg) {
		return [arg isKindOfClass:[NSNumber class]];
	};
	
	SZEnumerationExtraction extractor = ^id(id arg) {
		return arg;
	};
	
	NSArray *extracted = [arr sz_extractWhere:predicate usingBlock:extractor];
	XCTAssertEqual(1, extracted.count, @"");
	XCTAssertTrue([expected isEqualToNumber:extracted[0]], @"");
}


#pragma mark - sz_none

- (void)testNoneWithEmptyArray
{
	NSArray *arr = @[];
	XCTAssertTrue([arr sz_none], @"");
}

- (void)testNoneWithArrayContainingOneObject
{
	NSArray *arr = @[@"Obj"];
	XCTAssertFalse([arr sz_none], @"");
}


#pragma mark - sz_none:

- (void)testNoneWithNilPredicate
{
	NSArray *arr = @[];
	SZEnumerationPredicate predicate = nil;
	XCTAssertFalse([arr sz_none:predicate], @"");
}

- (void)testNoneWherePredicateReturnsNoWithNoObjects
{
	NSArray *arr = @[];
	SZEnumerationPredicate predicate = ^BOOL(id arg) {
		return NO;
	};
	
	XCTAssertTrue([arr sz_none:predicate], @"");
}

- (void)testNoneWherePredicateReturnsNoWithOneObject
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationPredicate predicate = ^BOOL(id arg) {
		return NO;
	};
	
	XCTAssertTrue([arr sz_none:predicate], @"");
}

- (void)testNoneWherePredicateReturnsYesWithOneObject
{
	NSArray *arr = @[@"Obj"];
	SZEnumerationPredicate predicate = ^BOOL(id arg) {
		return YES;
	};
	
	XCTAssertFalse([arr sz_none:predicate], @"");
}

@end
