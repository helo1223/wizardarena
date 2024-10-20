# FireballProjectile.gd
extends Area2D
class_name FireballProjectile

const EXPLOSION = preload("res://scenes/spells/Explosion.tscn")

# Fireball properties
var speed: float = 500.0
var damage: int = 50
var lifetime: float = 5.0  # How long the fireball exists before disappearing
var explosion_effect: PackedScene = EXPLOSION  # Optional: You can preload an explosion effect
var caster : Node
var direction: Vector2 = Vector2.ZERO  # The direction the fireball travels in

@onready var lifetime_timer : Timer = $Lifetime

# Signals
signal hit_target(target)

# Called when the node is added to the scene
func _ready():
    lifetime_timer.wait_time = lifetime
    lifetime_timer.start()

# Update the fireball's position every frame (Physics process for constant movement)
func _physics_process(delta: float):
    global_position += direction * speed * delta  # Move the fireball in the direction at the defined speed

# Function to set the fireball's direction and calculate velocity
func set_direction(start_position: Vector2, target_position: Vector2):
    global_position = start_position
    direction = (target_position - start_position).normalized()  # Calculate direction towards the target

# Handle collision with another body
func _on_body_entered(body):
    if body != caster and body.get_parent() != caster:
        # Apply damage to the player or enemy hit
        body.take_damage(damage)
        emit_signal("hit_target", body)
    
        # Trigger explosion effect or destroy the projectile
        explode()
        queue_free()
        
func _on_area_entered(area):
    if area != caster and area.get_parent() != caster:
        if area.has_method("take_damage"):
            area.take_damage(damage)
        queue_free()   

# Optional: Trigger an explosion effect (visual feedback)
func explode():
    if explosion_effect:
        var explosion_instance = explosion_effect.instantiate()
        explosion_instance.global_position = global_position
        var current_level_projectiles = GameManager.current_level_node.get_node("Projectiles")
        current_level_projectiles.add_child(explosion_instance)


func _on_lifetime_timeout() -> void:
    queue_free()
