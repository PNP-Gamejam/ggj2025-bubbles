extends Node2D

const SENTRY_COST := 50
const SENTRY_SPRITE = preload("res://assets/Sentries-AT1.png")
const SENTRY = preload("res://scenes/sentries/sentry.tscn")
const SENTRY_OFFSET = Vector2(30, 0)

const TRIPLE_SENTRY_COST := 75
const TRIPLE_SENTRY_SPRITE = preload("res://assets/Triple sentries Act1.png")
const TRIPLE_SENTRY = preload("res://scenes/sentries/triple_sentry.tscn")
const TRIPLE_SENTRY_OFFSET = Vector2(30, 0)

const HEAVY_SENTRY_COST := 125
const HEAVY_SENTRY_SPRITE = preload("res://assets/Heavy sentry 1.png")
const HEAVY_SENTRY = preload("res://scenes/sentries/heavy_sentry.tscn")
const HEAVY_SENTRY_OFFSET = Vector2(30, 0)

var money := 50

@onready var base: Base = $Base 
@onready var placeholder: Sprite2D = %Placeholder

@onready var sentry_button: TextureButton = %SentryButton
@onready var triple_sentry_button: TextureButton = %TripleSentryButton
@onready var heavy_sentry_button: TextureButton = %HeavySentryButton

@onready var money_label: Label = %MoneyLabel
@onready var game_over_panel: Control = %GameOverPanel
@onready var retry_button: Button = %RetryButton
@onready var main_menu_button: Button = %MainMenuButton

var on_click := func(): pass
	
func _ready() -> void:
	GlobalBus.money_dropped.connect(func(amount:float): money += amount)
	sentry_button.pressed.connect(_select_sentry.bind("SENTRY"))
	triple_sentry_button.pressed.connect(_select_sentry.bind("TRIPLE_SENTRY"))
	heavy_sentry_button.pressed.connect(_select_sentry.bind("HEAVY_SENTRY"))
	
	base.died.connect(func(): 
		GlobalBus.game_over.emit()
		game_over_panel.show()
	)
	main_menu_button.pressed.connect(func(): get_tree().change_scene_to_file("res://main_menu/main.tscn"))
	retry_button.pressed.connect(func(): get_tree().reload_current_scene())
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select_sentry"):
		_select_sentry("SENTRY")
	if event.is_action_pressed("select_triple_sentry"):
		_select_sentry("TRIPLE_SENTRY")
	if event.is_action_pressed("select_heavy_sentry"):
		_select_sentry("HEAVY_SENTRY")
	if event is InputEventMouseButton:
		if !event.pressed: return
		if !Constants.has_sentry_nearby(get_global_mouse_position()):
			on_click.call()
			on_click = func(): pass
			placeholder.texture = null


func _process(delta: float) -> void:
	money_label.text = "Money: %d" % money
	if !Constants.has_sentry_nearby(get_global_mouse_position()):
		placeholder.self_modulate = Color.WHITE
	else:
		placeholder.self_modulate = Color.RED


func _select_sentry(sentry_type: String):
	var cost = get("%s_COST" % sentry_type)
	var sprite = get("%s_SPRITE" % sentry_type)
	var offset = get("%s_OFFSET" % sentry_type)
	var SCENE = get("%s" % sentry_type)
	if money >= cost:
		placeholder.texture = sprite
		placeholder.scale = Vector2.ONE * 0.2
		placeholder.offset = offset
		on_click = func():
			money -= cost
			var sentry = SCENE.instantiate()
			sentry.global_position = get_global_mouse_position()
			get_tree().current_scene.add_child(sentry)
