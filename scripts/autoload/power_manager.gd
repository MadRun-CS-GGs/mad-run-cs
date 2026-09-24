extends Node

enum PowerType {
	NONE,
	SOPA_FIEC,
	BACHE_VIA_COSTA,
	GRANIZO_GUAYACO,
	GUARDIA_ESPOL,
	CANGREJO_ALBORADA
}


func get_random_power() -> PowerType:
	return randi_range(
		PowerType.SOPA_FIEC,
		PowerType.CANGREJO_ALBORADA
	) as PowerType


func get_power_name(power: PowerType) -> String:
	match power:
		PowerType.SOPA_FIEC:
			return "Sopa de la FIEC"

		PowerType.BACHE_VIA_COSTA:
			return "Bache de la Vía a la Costa"

		PowerType.GRANIZO_GUAYACO:
			return "Granizo Guayaco"

		PowerType.GUARDIA_ESPOL:
			return "Guardia de ESPOL"

		PowerType.CANGREJO_ALBORADA:
			return "Cangrejo de Alborada"

		_:
			return "Sin poder"
