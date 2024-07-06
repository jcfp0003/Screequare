extends Window

signal MOUSE_LOCAL_INSIDE;

var startup_check_done := false;

func _check_mouse_inside():
	var mouse_rel_pos = get_viewport().get_mouse_position();
	return mouse_rel_pos.x >= 0 and mouse_rel_pos.x <= self.size.x and mouse_rel_pos.y >= 0 and mouse_rel_pos.y <= self.size.y;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if startup_check_done and _check_mouse_inside():
		MOUSE_LOCAL_INSIDE.emit();
