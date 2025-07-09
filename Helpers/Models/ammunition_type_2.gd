extends Node

class_name AmmunitionType2


var caliber := Enums.Calibers.NineByNineteen
var ap := 18
var damage := 15
var weight := 12
var price := 0.50
var kick_multiplier := 1.0

func create_new(p_caliber: Enums.Calibers, p_ap: int, p_damage: int, p_weight: int, p_price: float, p_kick_multiplier: float = 1.0) -> AmmunitionType2:
	var res: AmmunitionType2 = AmmunitionType2.new()
	res.caliber = p_caliber
	res.ap = p_ap
	res.damage = p_damage
	res.weight = p_weight
	res.price = p_price
	return res
