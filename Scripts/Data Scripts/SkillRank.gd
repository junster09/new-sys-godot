class_name SkillRank

var name: String = ""
var color: Color = Color.BLACK
var maxLevel: int = 9999

func _init(_name: String, _color: String, _maxLevel: int)-> void:
    self.name = _name
    color = Color(_color)
    maxLevel = _maxLevel
