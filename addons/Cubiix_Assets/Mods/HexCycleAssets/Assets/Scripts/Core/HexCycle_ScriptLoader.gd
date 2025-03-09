extends CharacterBody3D

## We want an external script loader so that we can add custom resources over time, rather than lock it down
@export var Load_Script_ID: Array[String]
@export var Load_Script_Passthrough: Array[Dictionary]

## Direct Path to our Assets/Modloading stuff.
@export var Assets_Path = ""
var Assets

signal MeshFinished
signal Loaded
signal ScriptLoaded

func _ready() -> void:
	Assets = get_node(Assets_Path)
	emit_signal("Loaded")
	if !Load_Script_ID.is_empty():
		for i in Load_Script_ID:
			var NewNode = Node3D.new()
			Assets.find_script(i,NewNode,self)
			call_deferred("add_child",NewNode)

	call_deferred("emit_signal","ScriptLoaded")
