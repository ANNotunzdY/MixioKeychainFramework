//
//  MixioKeychainManager.m
//  MixioKeychainFramework
//
//  Created by あんのたん on 11/05/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MixioKeychainManager.h"


@implementation MixioKeychainManager

//Begin Singleton components
static MixioKeychainManager *sharedInstance = nil;

+ (MixioKeychainManager *)defaultManager
{
    if (sharedInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[super allocWithZone:NULL] init];
        });
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
//End Singleton components

- (BOOL)addItemWithAccountName:(NSString *)accountName password:(NSString *)password forKey:(NSString *)key options:(NSDictionary *)options {
	NSMutableDictionary* keychainItemDictionary = [NSMutableDictionary dictionary];
	[keychainItemDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[keychainItemDictionary setObject:key forKey:(__bridge id)kSecAttrGeneric];
    
	if (options) {
		[keychainItemDictionary addEntriesFromDictionary:options];
	}
    
	NSMutableDictionary* query = [NSMutableDictionary dictionaryWithDictionary:keychainItemDictionary];
    
	[query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
	[query removeObjectForKey:(__bridge id)kSecReturnAttributes];
    
	[keychainItemDictionary setObject:accountName forKey:(__bridge id)kSecAttrAccount];
	[keychainItemDictionary setObject:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
    
    OSStatus keychainError = noErr;
	CFDictionaryRef passwordData = nil;
    keychainError = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&passwordData);
    
	if (keychainError == noErr) {
		NSMutableDictionary* updateDictionary = [NSMutableDictionary dictionary];
		[updateDictionary setObject:accountName forKey:(__bridge id)kSecAttrAccount];
		[updateDictionary setObject:[keychainItemDictionary objectForKey:(__bridge id)kSecValueData] forKey:(__bridge id)kSecValueData];
        
		keychainError = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)updateDictionary);
		if (keychainError == noErr) {
			return YES;
		}
	} else {
		keychainError = SecItemAdd((__bridge CFDictionaryRef)keychainItemDictionary, NULL);
		if (keychainError == noErr) {
			return YES;
		}
	}
	return NO;
}

- (NSDictionary *)itemForKey:(NSString *)key {
	NSMutableDictionary* keychainItemDictionary = [NSMutableDictionary dictionary];
	[keychainItemDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[keychainItemDictionary setObject:key forKey:(__bridge id)kSecAttrGeneric];
	[keychainItemDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
	[keychainItemDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
	CFDictionaryRef passwordData = NULL;
    OSStatus keychainError = noErr;
    keychainError = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItemDictionary,
										(CFTypeRef *)&passwordData);
	if (keychainError == noErr) {
		return (__bridge_transfer NSDictionary *)passwordData;
	}
	return nil;
}

- (BOOL)removeItemForKey:(NSString *)key {
	NSMutableDictionary* keychainItemDictionary = [NSMutableDictionary dictionary];
	[keychainItemDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[keychainItemDictionary setObject:key forKey:(__bridge id)kSecAttrGeneric];
    OSStatus keychainError = noErr;
    keychainError = SecItemDelete((__bridge CFDictionaryRef)keychainItemDictionary);
	if (keychainError == noErr) {
		return YES;
	}
	return NO;
}

@end
