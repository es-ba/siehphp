
var tipico={var_T1:2, var_T2:2, var_T3:6};

var pruebas=[
	{ titulo: "si ingreso sobre una salteada se pone rojo"
	, entrada: {var_T1:1, var_T2:2}
	, salida: {var_T2:{ color: "Red"}}
	}
	,
	{ titulo: "si ingreso sobre una correcta queda verde"
	, entrada: {var_T1:2, var_T2:2}
	, salida: {var_T2:{ color: "green"}}
	}
	,
	{ titulo: "si ingreso sobre una correcta queda verde"
	, entrada: {var_T1:2, var_T2:2, var_T3:6} // o algo como: tipico.concat(var_T4:5)
	, salida: {var_T2:{ color: "green"}}
	}
];

function pru_procesar_entradas(entrada){
	for(var variable in entrada){
		elemento_existente(variable).value=entrada[variable];
	}
}

function pru_verificar_salida(salida){
	for(var variable in salida){
		elemento=elemento_existente(variable);
		if(elemento.style.backgroundColor!=salida[variable].color){
			alert('color no coincide de '+variable+' esperaba '+salida[variable].color+' obtuve '+elemento.style.backgroundColor);
		}
	}
}

function probar_todo(){
	for(var i in pruebas){
		var caso=pruebas[i];
		pru_procesar_entradas(caso.entrada);
		ValidarOpcion('var_T1');
		pru_verificar_salida(caso.salida);
	}
}