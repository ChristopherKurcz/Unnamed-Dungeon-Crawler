extends Area

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector3.ZERO
	if is_colliding():
		var area = areas[0]
		push_vector = area.global_transform.origin.direction_to(self.global_transform.origin)
		push_vector = push_vector.normalized()
	return push_vector
