package ru.mobilap.flurry;

import android.app.Activity;
import android.content.res.Resources;
import android.graphics.Color;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.FrameLayout;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.List;
import java.util.HashMap;
import java.util.Locale;

import org.godotengine.godot.Dictionary;
import org.godotengine.godot.Godot;
import org.godotengine.godot.GodotLib;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.SignalInfo;

import com.flurry.android.Constants;
import com.flurry.android.FlurryAgent;
import com.flurry.android.FlurryPerformance;

public class Flurry extends GodotPlugin
{
    private final String TAG = Flurry.class.getName();

    private boolean ProductionMode = true; // Store if is real or not

    /* Init
     * ********************************************************************** */

    /**
     * Prepare for work with ApplovinMax
     * @param boolean ProductionMode Tell if the enviroment is for real or test
     * @param int gdscript instance id
     */
    public void init(final String sdkKey, boolean ProductionMode) {

        this.ProductionMode = ProductionMode;

        FlurryAgent.Builder builder = new FlurryAgent.Builder();
        builder.withDataSaleOptOut(false); //CCPA - the default value is false
        builder.withCaptureUncaughtExceptions(true);
        builder.withIncludeBackgroundSessionsInMetrics(true);
        if(ProductionMode) {
            builder.withLogLevel(Log.ERROR);
        } else {
            builder.withLogLevel(Log.VERBOSE);
        }
        builder.withPerformanceMetrics(FlurryPerformance.ALL);
        builder.build(getActivity(), sdkKey);
    }

    public void logEvent(final String event, final Dictionary params, boolean timed) {
        FlurryAgent.logEvent(event, dictionaryToMap(params), timed);
    }

    public void endTimedEvent(final String event, final Dictionary params) {
        FlurryAgent.endTimedEvent(event, dictionaryToMap(params));
    }

    public void logPurchase(final String sku, final String productName, int quantity, float price, final String currency, final String transactionId) {
        HashMap params = new HashMap<>();
        FlurryAgent.logPayment(productName, sku, quantity, price, currency, transactionId, params);
    }

    public void logError(final String error, final String message) {
        FlurryAgent.onError(error, message, "");
    }

    public void setUserId(final String uid) {
        FlurryAgent.setUserId(uid);
    }

    public void setAge(int age) {
        FlurryAgent.setAge(age);
    }

    public void setGender(final String gender) {
        if(gender.equals("m"))
            FlurryAgent.setGender(Constants.MALE);
        else
            FlurryAgent.setGender(Constants.FEMALE);
    }

    /* Utils
     * ********************************************************************** */

    private HashMap<String, String> dictionaryToMap(Dictionary params) {
        HashMap<String, String> result = new HashMap<>();
        for(String key: params.get_keys()) {
            result.put(key, params.get(key).toString());
        }
        return result;
    }
    
    /* Definitions
     * ********************************************************************** */
    public Flurry(Godot godot) 
    {
        super(godot);
    }

    @Override
    public String getPluginName() {
        return "Flurry";
    }

    @Override
    public List<String> getPluginMethods() {
        return Arrays.asList(
            "init", "logEvent", "endTimedEvent", "logPurchase", "logError", "setUserId", "setAge", "setGender"
        );
    }

    /*
    @Override
    public Set<SignalInfo> getPluginSignals() {
        return Collections.singleton(loggedInSignal);
    }
    */

    @Override
    public View onMainCreate(Activity activity) {
        return null;
    }
}
