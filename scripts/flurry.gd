extends Node

var _f = null

func _ready():
    pause_mode = Node.PAUSE_MODE_PROCESS
    if Engine.has_singleton("Flurry"):
        _f = Engine.get_singleton("Flurry")
    elif OS.get_name() == 'iOS':
        _f = preload("res://addons/flurry-ios/flurry.gdns").new()
    else:
        push_warning('Flurry native module not found!')
        return
    if ProjectSettings.has_setting('Flurry/API_KEY'):
        var app_key = ProjectSettings.get_setting('Flurry/API_KEY')
        init(app_key, not OS.is_debug_build())
        print('Flurry plugin inited')
    else:
        push_error('You need to init Flurry with api_key before using it')

func init(key: String, production: bool) -> void:
    if _f != null:
        _f.init(key, production)

func logEvent(event: String, params:= {}, timed:= false) -> void:
    if params == null:
        params = {}
    if _f != null:
        _f.logEvent(event, params)
    
func endTimedEvent(event: String, params:= {}) -> void:
    if params == null:
        params = {}
    if f != null:
        _f.endTimedEvent(event, params)

func logPurchase(productId: String productName: String, quantity: int, price: float, currency: String, transactionId: String) -> void:
    if _f != null:
        _f.logPurchase(productId, productName, quantity, price, currency, transactionId)

func logError(error: String, message: String) -> void:
    if _f != null:
        _f.logError(error, message)

func setUserId(userId: String) -> void:
    if _f != null:
        _f.setUserId(userId)

func setAge(age: int) -> void:
    if _f != null:
        _f.setAge(age)

func setGender(gender: String) -> void:
    # use 'm' for Male, 'f' for Female
    if _f != null:
        _f.setGender(gender)
