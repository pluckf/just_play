extends CharacterBody2D
var roll_duration = 0.4
var can_shot:bool=true
@export var alive:bool=true
@export var roll_cooldown = 0.4
@export var move_speed:float=125
@export var player:AnimatedSprite2D
@export var reset:Timer
@export var shot_timer:Timer
@export var fire_sound:AudioStreamPlayer
@export var game_over_sound:AudioStreamPlayer
@export var running_sound:AudioStreamPlayer2D
@export var rolling_sound:AudioStreamPlayer2D
var roll_timer = Timer.new()
var cool_timer= Timer.new()

var is_rolling:bool=false
var can_roll:bool=true
var bullet_scene:PackedScene=preload("res://bullet.tscn")

func _ready():
	roll_timer.one_shot=true
	roll_timer.timeout.connect(roll_end)
	roll_timer.wait_time = roll_duration
	add_child(roll_timer)
	cool_timer.one_shot=true
	cool_timer.timeout.connect(reset_cool)
	cool_timer.wait_time = roll_cooldown 
	add_child(cool_timer)

#循环检测移动并播放声音
func _process(delta: float) -> void:
		if is_rolling or velocity==Vector2.ZERO or not alive :
			running_sound.stop()
		elif not running_sound.playing:
			running_sound.play()
		if ! is_rolling:
			rolling_sound.stop()
		elif not rolling_sound.playing:
			rolling_sound.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if alive:
		velocity=Input.get_vector("left","right","up","down")*move_speed
		if Input.is_action_just_pressed("space") and !is_rolling and can_roll:
			start_roll()
		if Input.is_action_just_pressed("shoot") and can_shot:
			fire()
		if velocity.x<0:
			player.flip_h=true
		elif velocity.x>0:
			player.flip_h=false
		if is_rolling:
			player.play("roll")
		elif not is_rolling and velocity==Vector2.ZERO :
			player.play("idle")
		else:
			player.play("run")
		move_and_slide()
		
func start_roll()->void:
	is_rolling = true
	move_speed=210
	roll_timer.start()
	
	
func reset_cool()->void:
	can_roll=true
	
	
func roll_end()->void:
	move_speed=125
	can_roll=false
	is_rolling=false
	cool_timer.start()
	
	
func game_over():
	if alive:
		game_over_sound.play()
		alive=false
		player.play("death")
		get_tree().current_scene.show_game_over()
		reset.start()
		
		
func fire() -> void:
	#播放开火音效
	#player跑动或者翻滚时或者没有存活时不发射子弹
	can_shot=false
	shot_timer.start()
	if velocity!=Vector2.ZERO or is_rolling or not alive:
		return
	fire_sound.play()
	var bullet_node=bullet_scene.instantiate()
	if player.flip_h:
		bullet_node.bullet_speed=-230
		bullet_node.position=position-Vector2(10,-2)
	elif not player.flip_h:
		bullet_node.position=position+Vector2(10,2)
	get_tree().current_scene.add_child(bullet_node)
	
	
func _on_shot_cd_timeout() -> void:
	can_shot=true
	

func reset_scene() -> void:
	get_tree().reload_current_scene()
