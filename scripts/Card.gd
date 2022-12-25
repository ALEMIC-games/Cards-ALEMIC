extends Button


export var object = 'owner'
export var subject = 'owner'
export var triggers_actions = {
	'raffle_started' : 'teleport'
}

func _ready():
	#connecting actions to triggers
	for key in triggers_actions.keys():
		match key:
			'raffle_started':
				connect("toggled", self, triggers_actions[key], [object, subject])

func teleport(obj, _subj):
	match obj:
		'owner':
			get_parent().position = get_parent().position + Vector2.ONE*100
# TRIGGERED
#func battle():
#	pass
#func battle_started():
#	pass
#func battle_finished():
#	pass
#func raffle():
#	pass
#func raffle_started():
#	pass
#func raffle_finished():
#	pass
