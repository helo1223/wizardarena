extends Node

# Game States
enum GameState {
    ROUND_PREPARE,
    ROUND_ACTIVE,
    ROUND_END,
    SHOP_BREAK
}

# Reference to the players
var players = {}
var teams = [[],[]]
var team_size = 2
# Timer for handling transitions between states
var state_timer: Timer

# Variables for tracking the game state
var current_state: GameState = GameState.ROUND_PREPARE
var current_round: int = 1
var max_rounds: int = 5

var current_level_node : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    state_timer = Timer.new()
    add_child(state_timer)

# Called at the start of each round to reset player stats and arena
func prepare_next_round():
    if state_timer.is_connected("timeout", prepare_next_round):
        state_timer.disconnect("timeout", prepare_next_round)        
    print("Preparing next round")
    current_state = GameState.ROUND_PREPARE
    reset_players()  # Resets health, positions, etc.
    reset_arena()
    create_teams()
    state_timer.start(5)  # Give 5 seconds for prep before the round starts
    state_timer.connect("timeout", _start_round)

func create_teams():
    var team_index = 0
    for player in players.values():
        if not player.is_player():
            continue
        if teams[team_index].size() == team_size:
            team_index+=1
        else:
            teams[team_index].append(player)
    print("create ", teams)

# Resets players before the round starts (reset health, positions, etc.)
func reset_players():
    teams = [[],[]]
    for player in players.values():
        player.reset_for_round()
        
    print("reset ", teams)

# Resets the arena (spawns objects, handles environmental changes, etc.)
func reset_arena():
    # Logic for resetting the environment for a new round
    pass

# Start the round and change the game state
func _start_round():
    if state_timer.is_connected("timeout", _start_round):
        state_timer.disconnect("timeout", _start_round)
    print(teams)
    print("Round start")
    current_state = GameState.ROUND_ACTIVE
    # Logic to start the round, like enabling player input, showing UI, etc.
    for player in players.values():
        player.start_fighting()  # Enable players to start fighting
    state_timer.stop()  # Stop the timer as the round has now started

# This function is called when a round ends (i.e., one team wins)
func end_round(winning_team: int):
    print("Round ended")
    current_state = GameState.ROUND_END
    # Logic to handle end of the round, like stopping player input, displaying winner
    for player in players.values():
        player.stop_fighting()  # Disable input for all players
    
    # Give rewards based on the winning team
    var winner_index = winning_team - 1
    give_team_rewards(teams[winner_index])

    # Start the shop break or next round
    if current_round < max_rounds:
        state_timer.start(10)  # 10 second break before shop
        state_timer.connect("timeout", _start_shop_break)
    else:
        declare_game_winner()

# Start the shop break where players can buy upgrades
func _start_shop_break():
    if state_timer.is_connected("timeout", _start_shop_break):
        state_timer.disconnect("timeout", _start_shop_break)
    print("Starting shop break")
    current_state = GameState.SHOP_BREAK
    # Enable shop UI for all players
    enable_shop_ui_for_players()
    state_timer.stop()  # Stop any previous timers
    # After the shop break, transition to the next round
    state_timer.start(15)  # 15 seconds for the shop break
    state_timer.connect("timeout", prepare_next_round)

# Give rewards to players after winning a round
func give_team_rewards(team):
    print("Rewarding players")
    for player in team:
        player.add_rewards()

# Function to declare the overall game winner after the final round
func declare_game_winner():
    # Show the final winner, end the match
    print("Game Over! Winner declared.")

func enable_shop_ui_for_players():
    print("Enabling shop ui for players")
    for player in players.values():
        pass#player.open_shop()

func set_current_level(node : Node):
    print("Setting current level node to ", node.name)
    current_level_node = node

func check_round_end():
    if is_team_defeated(teams[0]):
        end_round(2)  # Team 2 wins
    elif is_team_defeated(teams[1]):
        end_round(1)  # Team 1 wins

func is_team_defeated(team) -> bool:
    var result = true
    for player in team:
        if not player.dead:
            result = false
    return result

func _process(delta: float) -> void:
    if current_state == GameState.ROUND_ACTIVE:
        check_round_end()
