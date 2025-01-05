extends Area2D

var slime_speed:float=-50
var alive=true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if alive:
		position+=Vector2(-50,0) * delta
	if position.x<=-135:
		queue_free()
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and !body.is_rolling and alive:
		body.game_over()
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		$death.visible=true
		$death.play("slime_death")
		$alive.visible=false
		alive=false
		$dead_sound.play()
		get_tree().current_scene.kills+=1
		area.queue_free()
		#等待动画播放完后在删除节点
		await get_tree().create_timer(0.4).timeout
		queue_free()
		
	#
	#
	
