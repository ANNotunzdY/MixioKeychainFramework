//
//  MixioKeychainFrameworkTests.m
//  MixioKeychainFrameworkTests
//
//  Created by あんのたん on 11/05/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MixioKeychainFrameworkTests.h"
#import "MixioKeychainManager.h"
#import "ColorLog.h"

NSString* const kMixioKeychainFrameworkTestsItemKey = @"com.smilemac.MixioKeychainFrameworkTests";

@implementation MixioKeychainFrameworkTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
	printf("%s", [LBCL_YELLOW cStringUsingEncoding:NSASCIIStringEncoding]);
}

- (void)tearDown
{
    // Tear-down code here.
    [[MixioKeychainManager defaultManager] removeItemForKey:kMixioKeychainFrameworkTestsItemKey];
    [super tearDown];
	printf("%s", [LCL_RESET cStringUsingEncoding:NSASCIIStringEncoding]);
}

- (void)testAddItem
{
    STAssertTrue([[MixioKeychainManager defaultManager] addItemWithAccountName:@"YOUR_ACCOUNT_NAME" password:@"YOUR_PASSWORD" forKey:kMixioKeychainFrameworkTestsItemKey options:nil], LCL_RED @"Failed to add keychain item." LCL_RESET);
}

- (void)testUpdateAccountName
{
	[self testAddItem];
	STAssertTrue([[MixioKeychainManager defaultManager] addItemWithAccountName:@"YOUR_REPLACED_ACCOUNT_NAME" password:@"YOUR_PASSWORD" forKey:kMixioKeychainFrameworkTestsItemKey options:nil], LCL_RED @"Failed to update keychain item." LCL_RESET);
	NSDictionary* item = [[MixioKeychainManager defaultManager] itemForKey:kMixioKeychainFrameworkTestsItemKey];
	STAssertNotNil(item,  LCL_RED @"Failed to get keychain item." LCL_RESET);
	STAssertEqualObjects([item objectForKey:(id)kSecAttrAccount], @"YOUR_REPLACED_ACCOUNT_NAME", LCL_RED @"Account name is not match." LCL_RESET);
}


- (void)testUpdatePassword
{
	[self testAddItem];
	STAssertTrue([[MixioKeychainManager defaultManager] addItemWithAccountName:@"YOUR_ACCOUNT_NAME" password:@"YOUR_REPLACED_PASSWORD" forKey:kMixioKeychainFrameworkTestsItemKey options:nil], LCL_RED @"Failed to update keychain item." LCL_RESET);
	NSDictionary* item = [[MixioKeychainManager defaultManager] itemForKey:kMixioKeychainFrameworkTestsItemKey];
	STAssertNotNil(item,  LCL_RED @"Failed to get keychain item." LCL_RESET);
	STAssertEqualObjects([[[NSString alloc] initWithData:[item objectForKey:(id)kSecValueData] encoding:NSUTF8StringEncoding] autorelease], @"YOUR_REPLACED_PASSWORD", LCL_RED @"Password is not match." LCL_RESET);
}

- (void)testUpdateBoth
{
	[self testAddItem];
	STAssertTrue([[MixioKeychainManager defaultManager] addItemWithAccountName:@"YOUR_REPLACED_ACCOUNT_NAME" password:@"YOUR_REPLACED_PASSWORD" forKey:kMixioKeychainFrameworkTestsItemKey options:nil], LCL_RED @"Failed to update keychain item." LCL_RESET);
	NSDictionary* item = [[MixioKeychainManager defaultManager] itemForKey:kMixioKeychainFrameworkTestsItemKey];
	STAssertNotNil(item,  LCL_RED @"Failed to get keychain item." LCL_RESET);
	STAssertEqualObjects([item objectForKey:(id)kSecAttrAccount], @"YOUR_REPLACED_ACCOUNT_NAME", LCL_RED @"Account name is not match." LCL_RESET);
	STAssertEqualObjects([[[NSString alloc] initWithData:[item objectForKey:(id)kSecValueData] encoding:NSUTF8StringEncoding] autorelease], @"YOUR_REPLACED_PASSWORD", LCL_RED @"Password is not match." LCL_RESET);
}

- (void)testGetItem {
	[self testAddItem];
	NSDictionary* item = [[MixioKeychainManager defaultManager] itemForKey:kMixioKeychainFrameworkTestsItemKey];
	STAssertNotNil(item,  LCL_RED @"Failed to get keychain item." LCL_RESET);
	STAssertEqualObjects([item objectForKey:(id)kSecAttrAccount], @"YOUR_ACCOUNT_NAME", LCL_RED @"Account name is not match." LCL_RESET);
	STAssertEqualObjects([[[NSString alloc] initWithData:[item objectForKey:(id)kSecValueData] encoding:NSUTF8StringEncoding] autorelease], @"YOUR_PASSWORD", LCL_RED @"Password is not match." LCL_RESET);
}

- (void)testDeleteItem {
	[self testAddItem];
	STAssertTrue([[MixioKeychainManager defaultManager] removeItemForKey:kMixioKeychainFrameworkTestsItemKey], LCL_RED @"Failed to delete keychain item.\033[0m" LCL_RESET);
}

@end
