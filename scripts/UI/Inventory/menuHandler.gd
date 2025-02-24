extends Node

@export var deathMenu : Control
@export var pauseMenu : Control

@onready var PlayerCharacter = get_node("/root/Main/Player")

@export var equipScene     : Control
@export var itemsScene     : Control
@export var keyItemsScene  : String
@export var statusScene    : String
@export var settingsScene  : String

enum Menu_Types {
	ROOT,
	EQUIP,
	ITEMS,
	KEY,
	STATUS,
	SETTINGS
}
var notPaused : bool = true
var isPlaying : bool = true
var isAtRoot  : bool = true
var Current_Menu = Menu_Types.ROOT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_mode = PROCESS_MODE_ALWAYS

	if Input.is_action_just_pressed("pause") and isPlaying:
		match Current_Menu:
			Menu_Types.ROOT:
				PauseMenuFlopper()
				
			Menu_Types.EQUIP:
				EquipMenuFlopper()
				
			Menu_Types.ITEMS:
				ItemsMenuFlopper()
				
	#death screen
	if PlayerCharacter.player_health <= 0:
		DeathMenuFlopper()
		
func PauseMenuFlopper():
	# Toggle mouse mode
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pauseMenu.visible = !pauseMenu.visible
	get_tree().paused = !get_tree().paused
	
func EquipMenuFlopper():
	pauseMenu.visible = !pauseMenu.visible
	equipScene.visible = !equipScene.visible
	if !isAtRoot:
		Current_Menu = Menu_Types.ROOT
		isAtRoot = true
	else:
		isAtRoot = false
		Current_Menu = Menu_Types.EQUIP
		
func ItemsMenuFlopper():
	pauseMenu.visible = !pauseMenu.visible
	itemsScene.visible = !itemsScene.visible
	if !isAtRoot:
		Current_Menu = Menu_Types.ROOT
		isAtRoot = true
	else:
		isAtRoot = false
		Current_Menu = Menu_Types.ITEMS
	
func DeathMenuFlopper():
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#isPlaying = false
	##dMenu.visible = true
	#deathMenu.visible = !deathMenu.visible
	#get_tree().paused = !get_tree().paused

###-------------- buttons --------------###

func _on_reset_btn_pressed():
	get_tree().reload_current_scene()
	
func _on_ext_gm_btn_pressed():
	get_tree().quit()

func _on_ext_gm_btn_2_pressed():
	get_tree().quit()

func _on_resume_btn_pressed():
	PauseMenuFlopper()

func _on_equipment_btn_pressed():
	EquipMenuFlopper()

func _on_inventory_btn_pressed():
	ItemsMenuFlopper()

func _on_key_items_btn_pressed():
	pass # Replace with function body.

func _on_status_btn_pressed():
	pass # Replace with function body.

func _on_settings_btn_pressed():
	pass # Replace with function body.
