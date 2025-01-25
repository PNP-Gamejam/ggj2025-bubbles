extends Node2D

const SENTRY_COST := 50
const SENTRY_SPRITE = preload("res://assets/Sentries-AT1.png")
const SENTRY = preload("res://sentry.tscn")

var money := 100

@onready var base: Base = $Base 
@onready var placeholder: Sprite2D = %Placeholder

@onready var sentry_button: TextureButton = %SentryButton
@onready var money_label: Label = %MoneyLabel
@onready var game_over_panel: Panel = %GameOverPanel
@onready var retry_button: Button = %RetryButton
@onready var main_menu_button: Button = %MainMenuButton

var on_click := func(): pass
	
func _ready() -> void:
	GlobalBus.money_dropped.connect(func(amount:float): money += amount)
	sentry_button.pressed.connect(func():
		if money >= 50:
			placeholder.texture = SENTRY_SPRITE
			placeholder.scale = Vector2.ONE * 0.4
			placeholder.offset = Vector2(30, 0)
			on_click = buy_and_place_sentry
	)
	base.died.connect(func(): 
		GlobalBus.game_over.emit()
		game_over_panel.show()
	)
	main_menu_button.pressed.connect(func(): get_tree().change_scene_to_file("res://main_menu/main.tscn"))
	retry_button.pressed.connect(func(): get_tree().reload_current_scene())
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place_sentry"):
		on_click.call()
		on_click = func(): pass
		placeholder.texture = null


func _process(delta: float) -> void:
	money_label.text = "Money: %d" % money

	
func buy_and_place_sentry():
	money -= SENTRY_COST
	var sentry = SENTRY.instantiate()
	sentry.global_position = get_global_mouse_position()
	get_tree().current_scene.add_child(sentry)
	
