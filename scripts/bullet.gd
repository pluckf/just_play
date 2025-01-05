extends Area2D

var bullet_speed=230
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(3).timeout
	queue_free()#3s后摧毁当前节点

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
		position+=Vector2(bullet_speed,0)*delta
