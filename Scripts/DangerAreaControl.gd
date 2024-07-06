extends Node

signal DANGER_AREA_ENTERED;

const WINDOW_SIZE_VALUES = [100, 200, 300];
const WINDOW_COUNT_RANGE = [1, 4];

@export var GAME_SQUARE_WINDOW : Window;
@export var LIMIT_WINDOW_PREFAB : PackedScene;
var limits_windows_list : Array[Window];

func _clear_windows():
	for w in limits_windows_list:
		w.queue_free();
	limits_windows_list.clear();

func _spawn_new_windows():
	_clear_windows();
	
	for i in randi_range(WINDOW_COUNT_RANGE[0], WINDOW_COUNT_RANGE[1]):
		var new_window = LIMIT_WINDOW_PREFAB.instantiate() as Window;
		add_child(new_window);
		new_window.size = Vector2i(WINDOW_SIZE_VALUES[randi_range(0, WINDOW_SIZE_VALUES.size() - 1)], WINDOW_SIZE_VALUES[randi_range(0, WINDOW_SIZE_VALUES.size() - 1)]);
		new_window.position = GlobalFunctions._move_win_to_rand(new_window.size);
		new_window.connect("MOUSE_LOCAL_INSIDE", _danger_area_entered_callback);
		
		if new_window._check_mouse_inside():
			i -= 1;
			new_window.queue_free();
		else:
			new_window.startup_check_done = true;
			limits_windows_list.append(new_window);
	

#func _input(event):
	#if event.is_action_released("debug_spawn_window"):
		#_spawn_new_windows();
		#pass;

func _danger_area_entered_callback():
	_clear_windows();
	DANGER_AREA_ENTERED.emit();
