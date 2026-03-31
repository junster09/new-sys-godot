class_name  ConsequenceData extends InvokableData

#var name = ""
#var weight = 0
#var freeInvokeCount = 0


var severity = 0
var deadConsequence = false

func _init(_name: String, _weight: int, _freeInvokeCount: int, _severity: int):
    super(_name,_weight,_freeInvokeCount)
    severity = _severity

    if name == CN.DEAD_SKILL_NAME:
        kill()


func getSeverity() -> int: return severity
func getSeverityString() -> String: return CN.CONSEQUENCE_TYPE_STRING[severity]

func kill() -> void:
    name = CN.DEAD_SKILL_NAME
    weight = 0
    severity = 0
    freeInvokeCount = 0
    deadConsequence = true

func revive() -> void:
    name = ""
    weight = 0
    severity = 0
    freeInvokeCount = 0
    deadConsequence = false

func copyOtherInvoke(_other: InvokableData) -> bool:
    super(_other)
    severity = 0
    deadConsequence = false
    return true

func copyOtherConsequence(_other: ConsequenceData) -> bool:
    super.copyOtherInvoke(_other)
    severity = _other.severity
    deadConsequence = _other.deadConsequence
    return true
