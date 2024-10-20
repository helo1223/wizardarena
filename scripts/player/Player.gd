extends CharacterBody2D
class_name Player


# Player properties
var health: int = 100
var shield: int = 0
var max_health: int = 100
var movement_speed: float = 500.0
var active_spells: Array[Spell] = [Fireball.new(), Shield.new()] # Array of active spell instances
var upgrades: Array[Upgrade] = []    # Array of upgrade instances

# Cooldowns tracking
var spell_cooldowns: Dictionary = {}

# Spellcasting properties
var casting: bool = false
@onready var casting_timer: Timer = $CastingTimer
@onready var projectiles : Node = $Projectiles
var current_cast_time: float = 0.0
var casting_time: float = 0.0

@onready var casting_bar: ProgressBar = $CastingBar

@onready var camera: Camera2D = $Camera2D

var player_name : String
@onready var name_label: Label = $NameLabel

# Signals
signal health_changed(new_health)

func get_projectiles() -> Node:
    return $Projectiles

func _ready() -> void:
    camera.enabled = is_multiplayer_authority()
    name_label.text = player_name
    #init_default_spells()  # Assign initial spells here if needed

func _physics_process(delta: float) -> void:
    if !is_multiplayer_authority():
        return
    handle_movement(delta)
    handle_camera_zoom()
    handle_spellcasting(delta)
    update_spell_cooldowns(delta)
    update_shield_value()
    
func update_shield_value():
    shield = 0
    for spell in get_children():
        if is_instance_of(spell, ShieldEntity):
            shield += spell.health
 
func handle_camera_zoom() -> void:
    if Input.is_action_just_pressed("zoom_in"):
        camera.zoom += Vector2(0.1,0.1)
    elif Input.is_action_just_pressed("zoom_out"):
        camera.zoom -= Vector2(0.1,0.1)


func handle_movement(delta: float) -> void:
    # Get the input direction using get_vector for up, down, left, right actions
    var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    # Apply movement based on input direction and speed
    velocity = input_direction * movement_speed
    # Move the character
    move_and_slide()

func handle_spellcasting(delta: float) -> void:
    if casting:
        # Update the casting progress
        current_cast_time += delta
        var progress = (current_cast_time / casting_time) * 100.0
        casting_bar.value = progress
        
        # Ensure casting bar reaches 100% at the end of casting
        if current_cast_time >= casting_time:
            casting_bar.value = 100
        return  # Don't allow casting while already casting a spell
    
    if Input.is_action_just_pressed("cast_spell_1"):
        cast_spell(0)  # Cast first spell in the active_spells array (e.g., Q key)
    elif Input.is_action_just_pressed("cast_spell_2"):
        cast_spell(1)  # Cast second spell (e.g., E key)

# Method to handle receiving damage
func take_damage(amount: int):
    health -= amount
    emit_signal("health_changed", health)
    if health <= 0:
        die()
        
func die():
    queue_free()  # Replace with death logic
    
# Spell casting
func cast_spell(spell_index: int):
    if spell_index < active_spells.size():
        var spell = active_spells[spell_index]
        
        # Check cooldown
        if is_spell_on_cooldown(spell):
            print(spell.spell_name + " is on cooldown.")
            return
                
        # Start casting
        print("Casting " + spell.spell_name)
        casting = true
        current_cast_time = 0.0  # Reset the casting progress
    
        # If instant cast, don't start timer
        if spell.cast_time <= 0.0:
            _on_casting_complete(spell_index)
            return

        # Check if the signal is already connected, and disconnect it
        if casting_timer.timeout.is_connected(_on_casting_complete):
            casting_timer.timeout.disconnect(_on_casting_complete)
        
        # After casting time, launch the spell (connect to the timer's timeout signal)
        casting_timer.connect("timeout", Callable(self, "_on_casting_complete").bind(spell_index))

        casting_time = spell.cast_time
        casting_timer.start(casting_time)

        # Show the casting bar and reset its value
        casting_bar.visible = true
        casting_bar.value = 0                                                               
    else:
        print("No spell in slot " + str(spell_index))

# After casting completes
func _on_casting_complete(spell_index: int):
    var spell = active_spells[spell_index]

    # Cast the spell at the target
    spell.cast(self, get_global_mouse_position())

    # Start cooldown for the spell
    spell_cooldowns[spell] = spell.cooldown
    casting = false
    casting_bar.visible = false

# Check if a spell is on cooldown
func is_spell_on_cooldown(spell: Spell) -> bool:
    if spell in spell_cooldowns and spell_cooldowns[spell] > 0:
        return true
    return false
    
# Decrease cooldown timers for spells
func update_spell_cooldowns(delta: float):
    for spell in spell_cooldowns:
        spell_cooldowns[spell] -= delta
        if spell_cooldowns[spell] <= 0:
            spell_cooldowns[spell] = 0  
    
# Apply upgrades, affecting player stats
func apply_upgrade(upgrade: Upgrade):
    upgrades.append(upgrade)
    upgrade.apply(self)  # Pass the player to modify stats

# Method to initialize or add spells
func init_default_spells():
    for spell in ShopManager.offer_random_spells():
        print("Init spell: ", spell.spell_name)
        active_spells.append(spell)
