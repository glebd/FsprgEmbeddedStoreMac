//
//  FstSpgStoreParameters.m
//  FstSpgEmbeddedStore
//
//  Created by Lars Steiger on 2/19/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import "FstSpgStoreParameters.h"

NSString * const kFstSpgOrderProcessDetail = @"detail";
NSString * const kFstSpgOrderProcessInstant = @"instant";

NSString * const kFstSpgModeActive = @"active";
NSString * const kFstSpgModeActiveTest = @"active.test";
NSString * const kFstSpgModeTest = @"test";

static NSString * const kOrderProcessType = @"orderProcessType";
static NSString * const kStoreId = @"storeId";
static NSString * const kProductId = @"productId";
static NSString * const kMode = @"mode";
static NSString * const kCampaign = @"campaign";
static NSString * const kOption = @"option";
static NSString * const kReferrer = @"referrer";
static NSString * const kSource = @"source";
static NSString * const kContactFname = @"contact_fname";
static NSString * const kContactLname = @"contact_lname";
static NSString * const kContactEmail = @"contact_email";
static NSString * const kContactCompany = @"contact_company";
static NSString * const kContactPhone = @"contact_phone";

static NSMutableDictionary *keyPathsForValuesAffecting; 

@implementation FstSpgStoreParameters

+ (void)initialize
{
	keyPathsForValuesAffecting = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
	
	NSSet *toURLSet = [NSSet setWithObjects:NSStringFromSelector(@selector(orderProcessType)), 
											NSStringFromSelector(@selector(storeId)),
											NSStringFromSelector(@selector(productId)),
											NSStringFromSelector(@selector(mode)),
											NSStringFromSelector(@selector(campaign)),
											NSStringFromSelector(@selector(option)),
											NSStringFromSelector(@selector(referrer)),
											NSStringFromSelector(@selector(source)),
											NSStringFromSelector(@selector(contactFname)),
											NSStringFromSelector(@selector(contactLname)),
											NSStringFromSelector(@selector(contactEmail)),
											NSStringFromSelector(@selector(contactCompany)),
											NSStringFromSelector(@selector(contactPhone)),
											nil];
	[keyPathsForValuesAffecting setObject:toURLSet forKey:NSStringFromSelector(@selector(toURL))];
}

+ (FstSpgStoreParameters *)parameters
{
	return [[[FstSpgStoreParameters alloc] init] autorelease];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	NSSet *keyPaths = [keyPathsForValuesAffecting valueForKey:key];
	if(keyPaths == nil) {
		return [NSSet set];
	} else {
		return keyPaths;
	}
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setRaw:[NSMutableDictionary dictionaryWithCapacity:15]];
		[self setOrderProcessType:kFstSpgOrderProcessDetail];
	}
	return self;
}

- (NSMutableDictionary *)raw
{
    return [[raw retain] autorelease]; 
}

- (void)setRaw:(NSMutableDictionary *)aRaw
{
    if (raw != aRaw) {
        [raw release];
        raw = [aRaw retain];
    }
}

- (NSURLRequest *)toURLRequest
{
	return [NSMutableURLRequest requestWithURL:[self toURL]];
}

- (NSURL *)toURL
{
	NSString *storeIdEncoded = [[self storeId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	if(storeIdEncoded == nil) {
		storeIdEncoded = @"";
	}
	NSString *productIdEncoded = [[self productId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	if(productIdEncoded == nil) {
		productIdEncoded = @"";
	}

	NSString *urlAsStr;
	if([kFstSpgOrderProcessDetail isEqualTo:[self orderProcessType]]) {
		NSString *protocol = @"http";
		if([self hasContactDefaults]) {
			protocol = @"https";
		}
		urlAsStr = [NSString stringWithFormat:@"%@://sites.fastspring.com/%@/product/%@", protocol, storeIdEncoded, productIdEncoded];
	} else if([kFstSpgOrderProcessInstant isEqualTo:[self orderProcessType]]) {
		urlAsStr = [NSString stringWithFormat:@"https://sites.fastspring.com/%@/instant/%@", storeIdEncoded, productIdEncoded];
	} else {
		NSAssert1(FALSE, @"OrderProcessType '%@' unknown.", [self orderProcessType]);
	}

	NSMutableArray *keys = [NSMutableArray arrayWithArray:[[self raw] allKeys]];
	[keys removeObject:kOrderProcessType];
	[keys removeObject:kStoreId];
	[keys removeObject:kProductId];
	[keys sortUsingSelector:@selector(compare:)];
	
	NSString *queryStr = @"";
	NSUInteger i, count = [keys count];
	for (i = 0; i < count; i++) {
		NSString *key = [keys objectAtIndex:i];
		NSString *value = [[self raw] valueForKey:key];
		if(value != nil) {
			queryStr = [queryStr stringByAppendingFormat:@"&%@=%@",
						key,
						[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		}
	}
		
	if([queryStr length] > 0) {
		urlAsStr = [NSString stringWithFormat:@"%@?%@", urlAsStr, [queryStr substringFromIndex:1]];
	}
	
	return [NSURL URLWithString:urlAsStr];
}

- (void)setObject:(NSString *)anObject forKey:(NSString *)aKey
{
	if(anObject == nil) {
		[[self raw] removeObjectForKey:aKey];
	} else {
		[[self raw] setObject:anObject forKey:aKey];
	}
}

- (NSString *)orderProcessType
{
    return [[self raw] objectForKey:kOrderProcessType];
}
- (void)setOrderProcessType:(NSString *)anOrderProcessType
{
    [self setObject:anOrderProcessType forKey:kOrderProcessType];
}

- (void)setStoreId:(NSString *)aStoreId withProductId:(NSString *)aProductId
{
	[self setStoreId:aStoreId];
	[self setProductId:aProductId];
}

- (NSString *)storeId
{
    return [[self raw] objectForKey:kStoreId];
}
- (void)setStoreId:(NSString *)aStoreId
{
    [self setObject:aStoreId forKey:kStoreId];
}

- (NSString *)productId
{
    return [[self raw] objectForKey:kProductId];
}
- (void)setProductId:(NSString *)aProductId
{
    [self setObject:aProductId forKey:kProductId];
}

- (NSString *)mode
{
	return [[self raw] objectForKey:kMode];
}
- (void)setMode:(NSString *)aMode
{
	[self setObject:aMode forKey:kMode];
}

- (NSString *)campaign
{
    return [[self raw] objectForKey:kCampaign];
}
- (void)setCampaign:(NSString *)aCampaign
{
	[self setObject:aCampaign forKey:kCampaign];
}

- (NSString *)option
{
    return [[self raw] objectForKey:kOption];
}
- (void)setOption:(NSString *)anOption
{
	[self setObject:anOption forKey:kOption];
}

- (NSString *)referrer
{
    return [[self raw] objectForKey:kReferrer];
}
- (void)setReferrer:(NSString *)aReferrer
{
	[self setObject:aReferrer forKey:kReferrer];
}

- (NSString *)source
{
    return [[self raw] objectForKey:kSource];
}
- (void)setSource:(NSString *)aSource
{
	[self setObject:aSource forKey:kSource];
}

- (BOOL)hasContactDefaults
{
	return hasContactDefaults;
}
- (void)setHasContactDefaults:(BOOL)flag
{
	hasContactDefaults = flag;
}
		   
- (NSString *)contactFname
{
    return [[self raw] objectForKey:kContactFname];
}
- (void)setContactFname:(NSString *)aContactFname
{
	[self setObject:aContactFname forKey:kContactFname];
	[self setHasContactDefaults:TRUE];
}

- (NSString *)contactLname
{
    return [[self raw] objectForKey:kContactLname];
}
- (void)setContactLname:(NSString *)aContactLname
{
	[self setObject:aContactLname forKey:kContactLname];
	[self setHasContactDefaults:TRUE];
}

- (NSString *)contactEmail
{
    return [[self raw] objectForKey:kContactEmail];
}
- (void)setContactEmail:(NSString *)aContactEmail
{
	[self setObject:aContactEmail forKey:kContactEmail];
	[self setHasContactDefaults:TRUE];
}

- (NSString *)contactCompany
{
    return [[self raw] objectForKey:kContactCompany];
}
- (void)setContactCompany:(NSString *)aContactCompany
{
	[self setObject:aContactCompany forKey:kContactCompany];
	[self setHasContactDefaults:TRUE];
}

- (NSString *)contactPhone
{
    return [[self raw] objectForKey:kContactPhone];
}
- (void)setContactPhone:(NSString *)aContactPhone
{
	[self setObject:aContactPhone forKey:kContactPhone];
	[self setHasContactDefaults:TRUE];
}

- (void)dealloc
{
    [self setRaw:nil];
	
    [super dealloc];
}

@end