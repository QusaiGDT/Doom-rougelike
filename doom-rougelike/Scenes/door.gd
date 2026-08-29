extends CSGBox3D

func interact():
	if get_parent().end_of_round == true:
		get_parent().get_parent().get_parent().change_maps()
