class_name InvokableData

var name = ""
var weight = 0
var freeInvokeCount = 0

func _init(_name: String,_weight: int,_freeInvokeCount: int) -> void:
    if _name != null: name = _name
    if _weight != null: weight = _weight
    if _freeInvokeCount != null: freeInvokeCount = _freeInvokeCount

func invoke() -> String:

    countdown(1)

    if(weight >= 0):
        return ("+" + str(weight))
    else:
        return ("-" + str(weight))

func countdown(_amount):
    freeInvokeCount -= _amount

func getName() -> String: return name
func setName(_name: String): name = _name

func getWeight() -> int: return weight
func setWeight(_weight: int): weight = _weight

func getFreeInvokeCount() -> int: return freeInvokeCount
func setFreeInvokeCount(_amount: int): freeInvokeCount = _amount

func copyOtherInvoke(_other: InvokableData) -> bool:
    name = _other.name
    weight = _other.weight
    freeInvokeCount = _other.freeInvokeCount
    return true