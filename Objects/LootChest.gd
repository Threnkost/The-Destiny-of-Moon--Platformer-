extends Area2D

const LOOT_INTRO = preload("res://UI/ChestOpeningScene.tscn")

#DATA
export (String, FILE, "*.json") var json_file
export (String) var id

var items = [] #For ex: [[item, amount]]
var gold_amount := 0

#MECHANICS
export (bool) var available  = true
var player_in := false


func _ready():
	if available:
		assert(id, "Invalid loot chest id!")
		
		var file = File.new()
		file.open(json_file, File.READ)
		var data = parse_json(file.get_as_text())
		data = data[id]
		file.close()
		
		randomize()
		gold_amount = rand_range(data["min_gold_value"], data["max_gold_value"])

		for i in data["items"]:
			var chance = rand_range(0.0, 1.0)
			if chance <= data["items"][i]["percentage"]:
				var item   = load("res://Items/Resources/" + i + ".tres")
				var amount = data["items"][i]["amount"]
				items.append([item, amount])


func _input(event):
	if available and player_in and event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("UseDoor"):
			Global.player.wallet.currencies["Gold"].value += gold_amount
			var intro = LOOT_INTRO.instance()
			intro.initialize(items)
			yield(intro,"completed")
			queue_free()


func _on_LootChest_body_entered(body):
	player_in = true
	$KeyboardKey.show()


func _on_LootChest_body_exited(body):
	player_in = false
	$KeyboardKey.hide()
