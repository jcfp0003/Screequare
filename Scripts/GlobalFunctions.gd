extends Node

func _move_win_to_rand(windowSize : Vector2i) -> Vector2i:
	var target_display = randi_range(0, DisplayServer.get_screen_count() - 1);
	var display_pos = DisplayServer.screen_get_position(target_display);
	var display_siz = DisplayServer.screen_get_size(target_display);
	# Pick random position in screen, limited by window size, and add position offset (for multiscreen layouts)
	var target_position : Vector2i;
	target_position.x = randi_range(0, display_siz.x - windowSize.x) + display_pos.x;
	target_position.y = randi_range(0, display_siz.y - windowSize.y) + display_pos.y;
	return target_position;
