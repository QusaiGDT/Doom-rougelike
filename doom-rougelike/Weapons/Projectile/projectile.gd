extends Area3D

@export var speed: float = 30.0
@export var damage_amount: float = 25.0
@export var lifetime: float = 3.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	global_transform.origin -= global_transform.basis.z * speed * delta


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("damagable"):
		body.damage(damage_amount)
	queue_free()
