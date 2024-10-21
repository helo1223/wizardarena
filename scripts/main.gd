extends Node2D

@onready var lobby_id: LineEdit = $LobbyID
@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner

func _ready() -> void:
    multiplayer_spawner.spawn_function = spawn_level
    
func spawn_level(data):
    var a = (load(data) as PackedScene).instantiate()
    GameManager.set_current_level(a)
    return a

func _on_host_pressed() -> void:
    Network.create_lobby()
    multiplayer_spawner.spawn("res://scenes/levels/test.tscn")
    GameManager.prepare_next_round()
    $Camera2D.enabled = false
    $Host.hide()
    $Join.hide()
    $LobbyID.hide()
    
func _on_join_pressed() -> void:
    var id : int = int(lobby_id.text)
    Network.join_lobby(id)
    $Camera2D.enabled = false
    $Host.hide()
    $Join.hide()
    $LobbyID.hide()
