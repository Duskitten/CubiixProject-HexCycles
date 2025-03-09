extends Node
@onready var Core = get_node("/root/Main_Scene/CoreLoader")
var Character
var Hub
var accumulated_gravity = Vector3.ZERO
var accumulated_velocity = Vector3.ZERO
var Direction = 0
var CheckPoints:Array[Vector3]
var LineObjects:Array[MeshInstance3D]
var Point = 0
const gravity = -0.98 * .5
var Accel = 0
var NewAccel = 0
var TiltAngle = 0
var GlowMat = load("res://addons/Cubiix_Assets/Mods/HexCycleAssets/Assets/Materials/GlowMat.tres").duplicate(true)
var distvelocity = Vector2.ZERO
func _ready() -> void:
	Character = get_parent()
	Hub = Character.get_node("Hub")
	CheckPoints.append(self.global_position)
	LineObjects.append(new_meshinstance())
	
func _process(delta: float) -> void:
	match Direction:
		0:
			Hub.rotation.y = lerp_angle(Hub.rotation.y,deg_to_rad(0),0.25)
		1:
			Hub.rotation.y = lerp_angle(Hub.rotation.y,deg_to_rad(90),0.25)
		2:
			Hub.rotation.y = lerp_angle(Hub.rotation.y,deg_to_rad(180),0.25)
		3:
			Hub.rotation.y = lerp_angle(Hub.rotation.y,deg_to_rad(-90),0.25)
			
	if TiltAngle == -1 || TiltAngle == 1:
		Hub.rotation.z = lerp_angle(Hub.rotation.z,deg_to_rad(25 * TiltAngle),0.25)
		if  abs(deg_to_rad(25 * TiltAngle) - Hub.rotation.z) < 0.01:
			TiltAngle = 0
	else:
		Hub.rotation.z = lerp_angle(Hub.rotation.z,deg_to_rad(0),0.25)
		
	Hub.get_node("Plane_002").rotation.x += accumulated_velocity.length()
	LineObjects[Point].position = new_midpoint(CheckPoints[Point],self.global_position-distvelocity*1.2)
	LineObjects[Point].look_at(self.global_position)
	LineObjects[Point].mesh.size.z = CheckPoints[Point].distance_to(self.global_position-distvelocity*1.2)

func _physics_process(delta: float) -> void:
	if !Character.is_on_floor():
		accumulated_gravity += Character.global_transform.basis.y * gravity
	else:
		accumulated_gravity = Vector3.ZERO
		
	if Input.is_action_just_pressed("ui_left"):
		TiltAngle = -1
		Accel -= 0.5
		Direction += 1
		if Direction > 3:
			Direction = 0
	if Input.is_action_just_pressed("ui_right"):
		TiltAngle = 1
		Accel -= 0.5
		Direction -= 1
		if Direction < 0:
			Direction = 3
	
	if Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_right"):
		Accel -= 10
		
		LineObjects[Point].position = new_midpoint(CheckPoints[Point],self.global_position)
		LineObjects[Point].look_at(self.global_position)
		LineObjects[Point].mesh.size.z = CheckPoints[Point].distance_to(self.global_position)
		
		CheckPoints.append(self.global_position)
		LineObjects.append(new_meshinstance())
		Point += 1
	else:
		Accel += 0.2
	Accel = clampf(Accel,2,50)
	NewAccel = lerpf(NewAccel, Accel, 0.5)
	
	match Direction:
		0:
			accumulated_velocity = Character.transform.basis.z * (5.0 + NewAccel)
			distvelocity = Character.transform.basis.z
		1:
			accumulated_velocity = Character.transform.basis.x * (5.0 + NewAccel)
			distvelocity = Character.transform.basis.x
		2:
			accumulated_velocity = -Character.transform.basis.z * (5.0 + NewAccel)
			distvelocity = -Character.transform.basis.z
		3:
			accumulated_velocity = -Character.transform.basis.x * (5.0 + NewAccel)
			distvelocity = -Character.transform.basis.x
			

		
	Character.velocity = accumulated_gravity + accumulated_velocity
	Character.move_and_slide()

func new_midpoint(OldVec3:Vector3,NewVec3:Vector3) -> Vector3:
	return Vector3((OldVec3.x + NewVec3.x)/2,(OldVec3.y + NewVec3.y)/2,(OldVec3.z + NewVec3.z)/2)
	
func new_meshinstance() -> MeshInstance3D:
	var TemplateObject = MeshInstance3D.new()
	TemplateObject.mesh = BoxMesh.new()
	TemplateObject.material_override = GlowMat
	TemplateObject.mesh.size = Vector3(0.1,1,0.1)
	get_parent().get_parent().add_child(TemplateObject)
	return TemplateObject
