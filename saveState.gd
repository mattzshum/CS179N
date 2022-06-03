extends Node2D

const SAVE_DIR = "res://saveStates/"

var save_path = 'res://saveStates/save.dat'

func _on_SaveButton_pressed():
	var data = {
		'name': 'Player Name',
		'health': 100,
		'score':100,
	}
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()
	console_write('data saved')
	
func _on_LoadButton_pressed():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			var player_data = file.get_var()
			file.close()
	console_write('data loaded') #here is where we do that data implementation
	
func console_write(value):
	print(value)
