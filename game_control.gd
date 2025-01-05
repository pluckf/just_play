extends Node2D

@export var slime:PackedScene 
@export var spawn_timer:Timer
@export var score_label:Label
@export var game_over_label:Label
var kills:int=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer.wait_time-=delta*0.2
	spawn_timer.wait_time=clamp(spawn_timer.wait_time,0.8,3)
	score_label.text="Score: "+str(kills)
	if game_over_label.visible and game_over_label.position.y<=-30:
		game_over_label.position+=Vector2(0,31*delta)

func spwan_enemy() -> void:
	var slime_node=slime.instantiate()
	slime_node.position=Vector2(368,randf_range(48,130))
	get_tree().current_scene.add_child(slime_node)
	
func show_game_over():
	game_over_label.visible=true
