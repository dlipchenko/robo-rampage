extends Node

var ammoType = AmmunitionType2.new()

var AmmunitionTypes =  {
	#cal, ap, damage, weight, price, kickback mult
		"9x19FMJ": ammoType.create_new(Enums.Calibers.NineByNineteen,18,15,12,0.5),
		"7.62x51FMJ": ammoType.create_new(Enums.Calibers.SevenSixTwoByFiftyOne, 38, 60, 25, 2.0)
	}
