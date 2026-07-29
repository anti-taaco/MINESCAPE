extends UpgradeChoice

var id : int = Global.p_class.ability_id

func change_stats():
	if id == 1:
		description = "+1 Ability use every 35 tiles clicked"

func apply_upgrade():
	if id == 1:
		Modifiers.ability_upgraded = true
