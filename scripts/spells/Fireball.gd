# Fireball.gd
extends Spell
class_name Fireball
# Preload the FireballProjectile scene
var fireball_projectile_scene: PackedScene = preload("res://scenes/spells/FireballProjectile.tscn")

func _init():
    cooldown = 1.0
    damage = 50
    area_of_effect = 30.0
    spell_name = "Fireball"
    cast_time = 0.0
    
# Override cast function
func cast(caster: Node, target_position: Vector2):
    print(spell_name + " fired at " + str(target_position))
    
    # Create a new fireball projectile instance
    var fireball_projectile = fireball_projectile_scene.instantiate()
    fireball_projectile.caster = caster
    # Set the fireball's initial position and target
    fireball_projectile.set_direction(caster.global_position, target_position)  # Set the start and target positions
    fireball_projectile.damage = damage  # Set the damage based on the spell's power
    
    # Add the fireball to the scene
    caster.get_projectiles().add_child(fireball_projectile)
