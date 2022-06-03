extends Node

var save_nodes = get_tree().get_nodes_in_group("Persist")
	
func save():
	#these variables are loaded once we group all onbjects to persist
	var save_dict = {
		'filename':get_filename(),
		'parent': get_parent().get_path(),
	}
	return save_dict


func save_game():
	#location of all global variables in save state
	var save_game = File.new()
	save_game.open('user://savegame.save', File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.filename.empty():
			continue
		if !node.has_method('save'):
			continue
		var node_data = node.call('save')
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists('user://savegame/save'):
		#throw error because we are pulling from DNE
		return
		
	var save_nodes = get_tree().get_nodes_in_group('Persist')
	for nodes in save_nodes:
		nodes.queue_free()
	
	save_game.open('user://savegame/save', File.READ)
	while(save_game.get_position() < save_game.get_len() ):
		var node_data = parse_json(save_game.get_line())
		var new_object = load(node_data['filename'].instance())
