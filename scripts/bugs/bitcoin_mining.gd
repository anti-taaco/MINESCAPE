extends BugChoice

func apply_bug():
	Modifiers.bit_gain_multiplier += 0.5
	Modifiers.viruses_to_add += 3
	Selection.automatic_selection(Modifiers.viruses_to_add, "virus choices", "virus_list")
