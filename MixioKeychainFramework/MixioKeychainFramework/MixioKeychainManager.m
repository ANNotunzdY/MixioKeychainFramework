//
//  MixioKeychainManager.m
//  MixioKeychainFramework
//
//  Created by あんのたん on 11/05/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MixioKeychainManager.h"


@implementation MixioKeychainManager

+ (MixioKeychainManager *)defaultManager {
	return [self instance];
}

- (BOOL)addItemWithAccountName:(NSString *)accountName password:(NSString *)password forKey:(NSString *)key options:(NSDictionary *)options {
	NSMutableDictionary* keychainItemDictionary = [NSMutableDictionary dictionary];
	[keychainItemDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[keychainItemDictionary setObject:key forKey:(id)kSecAttrGeneric];
	
	if (options) {
		[keychainItemDictionary addEntriesFromDictionary:options];
	}

	NSMutableDictionary* query = [NSMutableDictionary dictionaryWithDictionary:keychainItemDictionary];
	
	[query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
	[keychainItemDictionary setObject:accountName forKey:(id)kSecAttrAccount];
	[keychainItemDictionary setObject:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
	
    OSStatus keychainError = noErr;
	NSDictionary *passwordData = NULL;
    keychainError = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&passwordData);
	
	if (keychainError == noErr) {
		keychainError = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)keychainItemDictionary);
		if (keychainError == noErr) {
			return YES;
		}
	} else {
		keychainError = SecItemAdd((CFDictionaryRef)keychainItemDictionary, NULL);
		if (keychainError == noErr) {
			return YES;
		}
	}
	return NO;
}

- (NSDictionary *)itemForKey:(NSString *)key {
	NSMutableDictionary* keychainItemDictionary = [NSMutableDictionary dictionary];
	[keychainItemDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[keychainItemDictionary setObject:key forKey:(id)kSecAttrGeneric];
	NSDictionary *passwordData = NULL;
    OSStatus keychainError = noErr;
    keychainError = SecItemCopyMatching((CFDictionaryRef)keychainItemDictionary,
										(CFTypeRef *)&passwordData);
	if (keychainError == noErr) {
		return passwordData;
	}
	return nil;
}

- (BOOL)removeItemForKey:(NSString *)key {
	NSMutableDictionary* keychainItemDictionary = [NSMutableDictionary dictionary];
	[keychainItemDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[keychainItemDictionary setObject:key forKey:(id)kSecAttrGeneric];
    OSStatus keychainError = noErr;
    keychainError = SecItemDelete((CFDictionaryRef)keychainItemDictionary);
	if (keychainError == noErr) {
		return YES;
	}
	return NO;
}

@end
