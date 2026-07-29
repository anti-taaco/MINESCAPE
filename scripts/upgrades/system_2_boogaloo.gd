extends UpgradeChoice

var p_name : String = Global.p_class.name

func change_stats():
	if p_name.contains("Sweeper"):
		description = "Alt-Ability: -400 Bits to heal 1 Life"

func apply_upgrade():
	if p_name.contains("Sweeper"):
		Modifiers.alt_id = Global.p_class.alt_ability_id
