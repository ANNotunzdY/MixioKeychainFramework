//
//  MixioKeychainManager.h
//  MixioKeychainFramework
//
//  Created by あんのたん on 11/05/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface MixioKeychainManager : NSObject {
}

+ (MixioKeychainManager *)defaultManager;
- (BOOL)addItemWithAccountName:(NSString *)accountName password:(NSString *)password forKey:(NSString *)key options:(NSDictionary *)options;
- (NSDictionary *)itemForKey:(NSString *)key;
- (BOOL)removeItemForKey:(NSString *)key;

@end
