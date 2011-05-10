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
    STAssertTrue([[MixioKeychainManager defaultManager] addItemWithAccountName:@"NULLPO" password:@"GA" forKey:kMixioKeychainFrameworkTestsItemKey options:nil], LCL_RED @"Failed to add keychain item." LCL_RESET);
}

- (void)testUpdateItem
{
	[[MixioKeychainManager defaultManager] addItemWithAccountName:@"NULLPO" password:@"GA" forKey:kMixioKeychainFrameworkTestsItemKey options:nil];
	STAssertTrue([[MixioKeychainManager defaultManager] addItemWithAccountName:@"NULLPO" password:@"GA" forKey:kMixioKeychainFrameworkTestsItemKey options:nil], LCL_RED @"Failed to update keychain item." LCL_RESET);
}

- (void)testGetItem {
	[[MixioKeychainManager defaultManager] addItemWithAccountName:@"NULLPO" password:@"GA" forKey:kMixioKeychainFrameworkTestsItemKey options:nil];
	NSDictionary* item = [[MixioKeychainManager defaultManager] itemForKey:kMixioKeychainFrameworkTestsItemKey];
	STAssertNotNil(item,  LCL_RED @"Failed to get keychain item." LCL_RESET);
	STAssertEquals([item objectForKey:(id)kSecAttrAccount], @"NULLPO", LCL_RED @"Account name is not match." LCL_RESET);
	STAssertEquals([[[NSString alloc] initWithData:[item objectForKey:(id)kSecValueData] encoding:NSUTF8StringEncoding] autorelease], @"GA", LCL_RED @"Password is not match." LCL_RESET);
}

- (void)testDeleteItem {
	[[MixioKeychainManager defaultManager] addItemWithAccountName:@"Hello" password:@"World" forKey:kMixioKeychainFrameworkTestsItemKey options:nil];
	STAssertTrue([[MixioKeychainManager defaultManager] removeItemForKey:kMixioKeychainFrameworkTestsItemKey], LCL_RED @"Failed to delete keychain item.\033[0m" LCL_RESET);
}

@end
