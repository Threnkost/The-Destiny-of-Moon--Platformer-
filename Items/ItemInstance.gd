extends Object

class_name ItemInstance

var item_name := "Invalid"
var item_description := "N/A"
var item_texture : Texture = null

onready var data:Dictionary

func _init(name, json_file):
	var file_path = "res://Items/JSON/" + json_file.replace(".json", "")
	var json_dict = _load_from_json(file_path + ".json")

	for i in json_dict:
		if json_dict[i]["Name"] == name:
			data = json_dict[i]
			break

	item_name = data["Name"]
	item_description = data ["Description"]
	item_texture = load(data["Texture"])

func debug() -> void:
	print()
	print("Data : ", data)
	print("Name : ", item_name)
	print("Description : ", item_description)
	print("Texture : ", item_texture)

func _load_from_json(file_name) -> Dictionary:
	var file = File.new()
	file.open(file_name, File.READ)
	var dict = parse_json(file.get_as_text())
	file.close()
	return dict
