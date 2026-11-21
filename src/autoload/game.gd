extends Node
## Autoload "Game": owns the services and the profile for the whole app (spec 8.3).
## Everything here uses the MOCK providers until the Android/iOS implementations exist (phase 3).
## Tests can call Game.boot(<temp save path>) to get a clean, isolated instance.

signal booted

var save: SaveService
var economy: Economy
var ads: AdService
var billing: BillingService
var analytics: AnalyticsService
var audio: AudioService
var nav: Navigator
var last_sim: BattleSim            # the battle that just ended (Second Wind resumes it)
var _ad_timer := 0.0
var _mock_ads: MockAdProvider
var _mock_billing: MockBillingProvider
var booted_ok := false


func _ready() -> void:
	boot()


func boot(save_path := "user://save.json") -> void:
	DataDB.ensure_loaded()
	Localization.ensure_loaded()
	save = SaveService.new(save_path)
	save.load_profile()
	economy = Economy.new(DataDB.balance(), save)
	analytics = AnalyticsService.new(MockAnalyticsProvider.new())
	_mock_ads = MockAdProvider.new()
	var placements := {}
	for p in DataDB.ads_config().get("placements", []):
		placements[str(p["id"])] = {"enabled": bool(p.get("enabled", true))}
	ads = AdService.new(_mock_ads, save, placements, DataDB.bal_i("ads.first_ad_after_stage_cleared", 3), analytics)
	_mock_billing = MockBillingProvider.new()
	var products := {}
	for pr in DataDB.shop().get("products", []):
		products[str(pr["id"])] = {"type": str(pr["type"]), "grants": pr.get("contents", {})}
	billing = BillingService.new(_mock_billing, save, products, analytics)
	if audio == null:
		audio = AudioService.new()
		add_child(audio)
	audio.apply_settings(save.profile["settings"])
	var lang: String = str(save.profile["settings"].get("language", ""))
	Localization.set_language(lang if lang in ["en", "es"] else Localization.detect_device_language())
	nav = Navigator.new()
	booted_ok = true
	booted.emit()


func start_services() -> void:
	## Called by Main once consent state is known (mock: immediately).
	ads.start(true)
	billing.start()


func _process(delta: float) -> void:
	if ads == null:
		return
	_ad_timer += delta
	if _ad_timer >= 1.0:
		_ad_timer = 0.0
		ads.update()


## Shorthand used by every screen: translated text for a key.
func t(key: String, args: Array = []) -> String:
	return Localization.tr_key(key, args)


func set_language(lang: String) -> void:
	Localization.set_language(lang)
	save.profile["settings"]["language"] = lang
	save.save()
