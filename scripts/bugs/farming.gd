extends BugChoice

func apply_bug():
	Modifiers.content_explode_multiplier += 0.5
	Modifiers.content_spawning_multiplier -= 0.5
