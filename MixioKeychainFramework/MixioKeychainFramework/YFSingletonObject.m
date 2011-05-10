//
//  YFSingletonObject.m
//  継承して使えるSingletonクラス
//
//  Created by ゆどうふろぐ
//  http://d.hatena.ne.jp/Yudoufu/20090318/1237385821
//

#import "YFSingletonObject.h"


@implementation YFSingletonObject

static NSMutableDictionary *_instances;

+ (id)instance {
	@synchronized(self) {
		if ([_instances objectForKey:NSStringFromClass(self)] == nil) {
			[[self alloc] init];
		}
	}
	return [_instances objectForKey:NSStringFromClass(self)];
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if ([_instances objectForKey:NSStringFromClass(self)] == nil) {
			id instance = [super allocWithZone:zone];
			if ([_instances count] == 0) {
				_instances = [[NSMutableDictionary alloc] initWithCapacity:0];
			}
			[_instances setObject:instance forKey:NSStringFromClass(self)];
			return instance;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  // 解放できないオブジェクトであることを示す
}

- (void)release
{
    // 何もしない
}

- (id)autorelease
{
    return self;
}

@end
