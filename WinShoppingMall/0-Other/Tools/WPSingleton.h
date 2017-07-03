//
//  Singleton.h
//  01-掌握-单例模式(ARC)
//
//  Created by 易购付 on 15/10/15.
//  Copyright © 2015年 lpz. All rights reserved.
//

#define Single_Interface(name) +(instancetype)shared##name;
#if __has_feature(objc_arc)
//当前环境是ARC
#define Single_Implementation(name) static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance =  [super allocWithZone:zone];\
    });\
    return _instance;\
}\
\
+(instancetype)shared##name\
{\
    return [[self alloc]init];\
}\
\
-(id)copyWithZone:(NSZone *)zone\
{\
    return _instance;\
}\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
    return _instance;\
}

#else

//当前环境是MRC

#define Single_Implementation(name) static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance =  [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(instancetype)shared##name\
{\
return [[self alloc]init];\
}\
\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
-(oneway void)release\
{\
}\
-(instancetype)retain\
{\
    return _instance;\
}\
\
-(NSUInteger)retainCount\
{\
    return MAXFLOAT;\
}
#endif
