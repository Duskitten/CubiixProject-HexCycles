extends Node
@onready var Core = get_node("/root/Main_Scene/CoreLoader")

var Camera_Core:Node3D
var Camera_Y:Node3D
var Camera_X:Node3D
var Camera_Z:Node3D
var Camera_Node:Camera3D
var Character
var Hub

func _ready() -> void:
	Camera_Core = Core.Persistant_Core.get_node("Core_Follow")
	Camera_Y = Camera_Core.get_node("Cam_Y")
	Camera_X = Camera_Y.get_node("Cam_X")
	Camera_Z = Camera_X.get_node("Cam_Z")
	Camera_Node = Camera_Z.get_node("Camera3D")
	Character = get_parent()
	Hub = Character.get_node("Hub")
	

func _process(delta: float) -> void:
	if Camera_Core != null:
		Camera_Core.global_transform = get_parent().global_transform
		Camera_Y.rotation.y = lerp_angle(Camera_Y.rotation.y, Hub.rotation.y+deg_to_rad(180),0.05)
