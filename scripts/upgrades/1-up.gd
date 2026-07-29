extends UpgradeChoice

var set_init = true
var initial_cost : float
var multi : float = 1

func change_stats():
	if set_init:
		initial_cost = bit_cost
		set_init = false
	multi = 1
	for i in range(count_amount() ):
		multi += 0.4
	bit_cost = int(initial_cost * multi)

func apply_upgrade():
	Modifiers.extra_lives += 1
