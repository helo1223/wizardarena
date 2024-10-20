# Fireball.gd
extends Spell
class_name Shield
# Preload the FireballProjectile scene
var shield_scene: PackedScene = preload("res://scenes/spells/Shield.tscn")

var shield_health: float = 100.0
var lifetime: float = 5.0

func _init():
    cooldown = lifetime + 5.0
    spell_name = "Shield"
    cast_time = 0.0
    
# Override cast function
func cast(caster: Node, target_position: Vector2):
    print(spell_name + " fired at " + str(target_position))
    
    # Create a new fireball projectile instance
    var shield = shield_scene.instantiate()
    shield.health = shield_health
    shield.lifetime = lifetime
    # Add the fireball to the scene
    caster.add_child(shield)
