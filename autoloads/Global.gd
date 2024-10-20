extends Node

var steam_id : int = 0
var steam_username : String = ""

func _init() -> void:
    OS.set_environment("SteamAppID", str(480))
    OS.set_environment("SteamGameID", str(480))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Steam.steamInit()
    
    steam_id = Steam.getSteamID()
    steam_username = Steam.getPersonaName()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    Steam.run_callbacks()
