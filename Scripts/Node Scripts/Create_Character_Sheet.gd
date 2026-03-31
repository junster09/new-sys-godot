extends MarginContainer


var skillCreatePanel = preload(UD.PANELS.SKILL_CREATE_PANEL)

@export var nameField: LineEdit
@export var skillInputContainer: Container
@export var skillInputList: Array[Panel]
@export var submitCharButton:Button

func _ready() -> void:
		for i in range(CN.CHAR_DEFAULT_SKILL_LIMIT):
				var panel = skillCreatePanel.instantiate()
				panel.name = "Skill Create Panel " + str(i)
				skillInputList.append(panel)
				skillInputContainer.add_child(panel)

				var divider = VSeparator.new()
				divider.size_flags_horizontal = 3
				divider.size_flags_vertical = 3
				divider.size_flags_stretch_ratio = 0.5
				skillInputContainer.add_child(divider)
