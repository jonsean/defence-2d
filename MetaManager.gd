extends Node

var SAVE_PATH := "user://meta_progression.tres"

var data: MetaProgression

func _ready() -> void:
	# set local save path
	SAVE_PATH = get_save_path()
	print("save path:", SAVE_PATH)
	load_game()
	
# --- Exit Handling ---
func _on_close_requested() -> void:
	print("Game closing: Saving final meta-progression...")
	print(SAVE_PATH)
	save_game()
	# Allow the game to safely quit now
	get_tree().quit()
	
func load_game() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		data = ResourceLoader.load(SAVE_PATH) as MetaProgression
	
	# Fallback if no save file exists yet
	if data == null:
		data = MetaProgression.new()
		save_game()

func save_game() -> void:
	ResourceSaver.save(data, SAVE_PATH)
# Gets the folder where the .exe or project is currently running

func get_save_path() -> String:
	var base_dir = OS.get_executable_path().get_base_dir()
	return base_dir.path_join("meta_progression.tres")
# --- Helper Methods for Gameplay ---

func add_currency(amount: int) -> void:
	data.currency += amount
	save_game()

func spend_currency(amount: int) -> bool:
	if data.currency >= amount:
		data.currency -= amount
		save_game()
		return true
	return false

func unlock_structure(structure_id: String) -> void:
	if structure_id not in data.unlocked_structures:
		data.unlocked_structures.append(structure_id)
		save_game()

func is_unlocked(structure_id: String) -> bool:
	return structure_id in data.unlocked_structures
