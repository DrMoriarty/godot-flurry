# FlurryAnalytics plugin for Godot Engine

## Installation

1. Install [NativeLib](https://github.com/DrMoriarty/nativelib-cli)
2. Make `nativelib -i flurry-plugin` in your project directory.
3. Add `Flurry/API_KEY` in your Project Settings.
4. Enable **Custom Build** for using in Android.

## Usage

Add wrapper `scripts/flurry.gd` into autoloading list in your project. So you can use it everywhere in your code.

## API

### init(key: String, production: bool)

You should not use this method directly. It will be automatically called when your project is started.

### logEvent(event: String, params: Dictionary = {}, timed: bool = false)

Log analytics events with this method. `params` and `timed` are optional.

### endTimedEvent(event: String, params: Dictionary = {})

Finish timed event. `params` is optional.

### logPurchase(productId: String, productName: String, quantity: int, price: float, currency: String, transactionId: String)

Log in-app purchase event. All parameters are mandatory.

### logError(error: String, message: String)

Track any error events.

### setUserId(userId: String)

Set custom user's ID.

### setAge(age: int)

Set user's age.

### setGender(gender: String)

Set user's gender. Use "m" for male and "f" for female.
