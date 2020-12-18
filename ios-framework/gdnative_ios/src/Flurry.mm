#import <Foundation/Foundation.h>
#include "Flurry.hpp"
#import "FlurrySessionBuilder.h"
#import "Flurry.h"

using namespace godot;

NSDictionary *convertFromDictionary(const Dictionary& dict)
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    for(int i=0; i<dict.keys().size(); i++) {
        Variant key = dict.keys()[i];
        Variant val = dict[key];
        if(key.get_type() == Variant::STRING) {
            String skey = key;
            NSString *strKey = [NSString stringWithUTF8String:skey.utf8().get_data()];
            if(val.get_type() == Variant::INT) {
                int i = (int)val;
                result[strKey] = @(i);
            } else if(val.get_type() == Variant::REAL) {
                double d = (double)val;
                result[strKey] = @(d);
            } else if(val.get_type() == Variant::STRING) {
                String sval = val;
                NSString *s = [NSString stringWithUTF8String:sval.utf8().get_data()];
                result[strKey] = s;
            } else if(val.get_type() == Variant::BOOL) {
                BOOL b = (bool)val;
                result[strKey] = @(b);
            } else if(val.get_type() == Variant::DICTIONARY) {
                NSDictionary *d = convertFromDictionary((Dictionary)val);
                result[strKey] = d;
            } else {
                ERR_PRINT("Unexpected type as dictionary value");
            }
        } else {
            ERR_PRINT("Non string key in Dictionary");
        }
    }
    return result;
}

FlurryPlugin::FlurryPlugin() {
}

FlurryPlugin::~FlurryPlugin() {
}

void FlurryPlugin::_init() {
}

void FlurryPlugin::init(const String& sdk_key, bool ProductionMode) {
    NSString *key = [NSString stringWithCString:sdk_key.utf8().get_data() encoding: NSUTF8StringEncoding];
    productionMode = ProductionMode;

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    FlurrySessionBuilder* builder = [FlurrySessionBuilder new];
    if(productionMode) {
        [builder withLogLevel:FlurryLogLevelCriticalOnly];
    } else {
        [builder withLogLevel:FlurryLogLevelAll];
        [builder withShowErrorInLog:YES];
    }
    [builder withCrashReporting:YES];
    [builder withSessionContinueSeconds:10];
    [builder withAppVersion:version];

    [Flurry startSession:key withSessionBuilder:builder];
}

void FlurryPlugin::logEvent(const String& event, const Dictionary& params, bool timed) {
    NSString *eventName = [NSString stringWithUTF8String:event.utf8().get_data()];
    if(params.size() > 0) {
        NSDictionary *dict = convertFromDictionary(params);
        [Flurry logEvent:eventName withParameters:dict timed:timed];
    } else {
        [Flurry logEvent:eventName timed:timed];
    }
}

void FlurryPlugin::endTimedEvent(const String& event, const Dictionary& params) {
    NSString *eventName = [NSString stringWithUTF8String:event.utf8().get_data()];
    if(params.size() > 0) {
        NSDictionary *dict = convertFromDictionary(params);
        [Flurry endTimedEvent:eventName withParameters:dict];
    } else {
        [Flurry endTimedEvent:eventName withParameters:nil];
    }
}

void FlurryPlugin::logPurchase(const String& sku, const String& product, int quantity, double price, const String& currency, const String& transactionId) {
    NSString *_sku = [NSString stringWithUTF8String:sku.utf8().get_data()];
    NSString *productName = [NSString stringWithUTF8String:product.utf8().get_data()];
    NSString *_currency = [NSString stringWithUTF8String:currency.utf8().get_data()];
    NSString *_transactionId = [NSString stringWithUTF8String:transactionId.utf8().get_data()];
    NSUInteger q = quantity;
    
    [Flurry logFlurryPaymentTransactionParamsWithTransactionId:_transactionId productId:_sku quantity:&q price:[[NSDecimalNumber alloc] initWithDouble:price] currency:_currency productName:productName transactionState:FlurryPaymentTransactionStateSuccess userDefinedParams:nil statusCallback:^(FlurryTransactionRecordStatus) {
        // nothing to do
    }];
}

void FlurryPlugin::logError(const String& error, const String& message) {
    NSString *_error = [NSString stringWithUTF8String:error.utf8().get_data()];
    NSString *_message = [NSString stringWithUTF8String:message.utf8().get_data()];
    [Flurry logError:_error message:_message error:nil];
}

void FlurryPlugin::setUserId(const String& uid) {
    NSString *_uid = [NSString stringWithUTF8String:uid.utf8().get_data()];
    [Flurry setUserID:_uid];
}

void FlurryPlugin::setAge(int age) {
    [Flurry setAge:age];
}

void FlurryPlugin::setGender(const String& gender) {
    NSString *_gender = [NSString stringWithUTF8String:gender.utf8().get_data()];
    [Flurry setGender:_gender];
}

void FlurryPlugin::_register_methods() {
    register_method("_init",&FlurryPlugin::_init);
    register_method("init",&FlurryPlugin::init);
    register_method("logEvent",&FlurryPlugin::logEvent);
    register_method("endTimedEvent",&FlurryPlugin::endTimedEvent);
    register_method("logPurchase",&FlurryPlugin::logPurchase);
    register_method("logError",&FlurryPlugin::logError);
    register_method("setUserId",&FlurryPlugin::setUserId);
    register_method("setAge",&FlurryPlugin::setAge);
    register_method("setGender",&FlurryPlugin::setGender);
}
