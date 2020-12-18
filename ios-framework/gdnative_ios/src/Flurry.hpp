#ifndef GODOT_FLURRY_H
#define GODOT_FLURRY_H

#include <Godot.hpp>
#include <Reference.hpp>

class FlurryPlugin : public godot::Reference {
    GODOT_CLASS(FlurryPlugin, godot::Reference);

    bool productionMode;

protected:

public:
    static void _register_methods();
    void _init();

    void init(const godot::String& sdk_key, bool ProductionMode);
    void logEvent(const godot::String& event, const godot::Dictionary& params, bool timed);
    void endTimedEvent(const godot::String& event, const godot::Dictionary& params);
    void logPurchase(const godot::String& sku, const godot::String& product, int quantity, double price, const godot::String& currency, const godot::String& transactionId);
    void logError(const godot::String& error, const godot::String& message);
    void setUserId(const godot::String& uid);
    void setAge(int age);
    void setGender(const godot::String& gender);

    FlurryPlugin();
    ~FlurryPlugin();
};

#endif
