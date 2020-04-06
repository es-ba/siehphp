"use strict";
var respuestas_ok_hasta_T28;
var respuestas_ok_hasta_T31;
var respuestas_ok_hasta_T35;
var respuestas_ok_hasta_T37;
var respuestas_ok_hasta_T45;
var respuestas_ok_hasta_T54b;
var respuestas_ok_hasta_M1;

var casos_yeah=
[ { modulo: pru_hacer_expresion_evaluable
  , casos:
    [ { titulo: "simple transformación de variables"
      , entrada: "t30='1'"
	  , salida: "(rta_ud.var_t30||0) == '1'"
      }
	, { titulo: "expesiones con relaciones lógicas"
      , entrada: "t30='1' and t31=2 or miembro=4"
	  , salida: "(rta_ud.var_t30||0) == '1' && (rta_ud.var_t31||0) == 2 || (rta_ud.var_miembro||0) == 4"
      }
	, { titulo: "desigualdades"
      , entrada: "t30>='1' and t31<=2 or miembro!=4"
	  , salida: "(rta_ud.var_t30||0)>='1' && (rta_ud.var_t31||0)<=2 || (rta_ud.var_miembro||0)!=4"
      }
	, { titulo: "no confundir funciones con variables"
      , entrada: "t30>='1' AND t31<=2 OR miembro(4)"
	  , salida: "(rta_ud.var_t30||0)>='1' && (rta_ud.var_t31||0)<=2 || miembro(4)"
      }
    ]
  }
, { modulo: pru_ingreso_simple
  , casos:
	[ { titulo: "ingreso de un único valor correcto"
	  , entrada: { rta_ud: { var_t1: 1 }}
	  , salida: { estados_rta_ud: { var_t1: estados_rta.ok }}
	  }
	, { titulo: "ingreso de un único valor INcorrecto"
	  , entrada: { rta_ud: { var_t1: 3 }}
	  , salida: { estados_rta_ud: { var_t1: estados_rta.opcion_inexistente }}
	  }
	, { titulo: "ingreso de dos variables correctas"
	  , entrada: { rta_ud: { var_t1: 2, var_t2: 2 }}
	  , salida: { estados_rta_ud: { var_t1: estados_rta.ok, var_t2:estados_rta.ok }}
	  }
	, { titulo: "ingreso de un dato sobre un salto"
	  , entrada: { rta_ud: { var_t1: 1, var_t2: 2 }}
	  , salida: { estados_rta_ud: { var_t1: estados_rta.ok, var_t2:estados_rta.ingreso_sobre_salto }}
	  }
	, { titulo: "ingreso de dos datos en un salto correcto"
	  , entrada: { rta_ud: { var_t1: 1, var_t7: 1 }}
	  , salida: { estados_rta_ud: 
					{ var_t1:estados_rta.ok
					, var_t2:estados_rta.salteada
					, var_t3:estados_rta.salteada
					, var_t4:estados_rta.salteada
					, var_t5:estados_rta.salteada
					, var_t6:estados_rta.salteada 
					, var_t7:estados_rta.ok }}
	  }
	, { titulo: "manejo de nulos, vacíos e indefinidos"
	  , entrada: { rta_ud: { var_t1: 1, var_t2: '', var_t3: null, var_t4:undefined, var_t5:0, var_t6:'    \t  \n  \r ', var_t7:' a   ' }}
	  , salida: 
	    { rta_ud: { var_t1: "1", var_t2: null, var_t3: null, var_t4:null, var_t5:"0", var_t6:null, var_t7:'a' }
		, estados_rta_ud: { var_t1: estados_rta.ok }
		}
	  }
	, { titulo: "en el origen la primera es blanca, el resto todavía no"
	  , entrada: { rta_ud: {}}
	  , salida: { estados_rta_ud: { var_t1: estados_rta.blanco, var_t2:estados_rta.todavia_no }
		}
	  }
	, { titulo: "la variable de abajo de las ingresada está en blanco, el resto todavía no"
	  , entrada: { rta_ud: { var_t1:2 }}
	  , salida: { estados_rta_ud: { var_t2: estados_rta.blanco, var_t3:estados_rta.todavia_no }
		}
	  }
	, { titulo: "el destino de un salto no ingresado está en blanco"
	  , entrada: { rta_ud: { var_t1:1 }}
	  , salida: { estados_rta_ud: { var_t2:estados_rta.salteada, var_t6: estados_rta.salteada, var_t7:estados_rta.blanco, var_t8:estados_rta.todavia_no }
		}
	  }
	, { titulo: "las variables salteadas se señalan"
	  , entrada: { rta_ud: { var_t1:2, var_t3:5 }}
	  , salida: 
	    { estados_rta_ud: { var_t1: estados_rta.ok, var_t2:estados_rta.omitido, var_t3:estados_rta.hay_omitidas, var_t4:estados_rta.hay_omitidas }
	    , estados_intermedios: {variable_omitida:"var_t2"}
		}
	  }
	, { titulo: "las variables sin opciones no deben marcarse como incorrectas por carecer de ellas"
	  , entrada: { rta_ud: ( respuestas_ok_hasta_T28={ var_t1:2, var_t2:2, var_t3:5, var_t4:2, var_t28:"1" })}
	  , salida: 
	    { rta_ud: { var_t28:1}
		, estados_rta_ud: { var_t28: estados_rta.ok }
		}
	  }
	, { titulo: "variable numérica bajo el mínimo"
	  , entrada: { rta_ud: cambiandole(respuestas_ok_hasta_T28,{var_t28:"0"}) }
	  , salida: 
	    { rta_ud: { var_t28:0 }
		, estados_rta_ud: { var_t28: estados_rta.fuera_de_rango_obligatorio }
		}
	  }
	, { titulo: "variable numérica sobre el umbral de advertencia"
	  , entrada: { rta_ud: cambiandole(respuestas_ok_hasta_T28,{var_t28:"6"}) }
	  , salida: 
	    { rta_ud: { var_t28:6 }
		, estados_rta_ud: { var_t28: estados_rta.fuera_de_rango_advertencia }
		}
	  }
	, { titulo: "variable numérica sobre el umbral de advertencia"
	  , entrada: { rta_ud: cambiandole(respuestas_ok_hasta_T28,{var_t28:"el encuestador duda"}) }
	  , salida: 
	    { rta_ud: { var_t28:"el encuestador duda" }
		, estados_rta_ud: { var_t28: estados_rta.error_tipo }
		}
	  }
	, { titulo: "ERROR: estaba poniendo en 0 las variables numéricas salteadas"
	  , entrada: { rta_ud: ( respuestas_ok_hasta_T28 )}
	  , salida: 
	    { rta_ud: { var_t19_anio:null}
		}
	  }
	, { titulo: "Filtro de la T32"
	  , entrada: 
	    { rta_ud: ( respuestas_ok_hasta_T31=
					{ var_t1:1, var_t7:1
					, var_t30:1
					, var_t31_d:0, var_t31_l:7, var_t31_ma:7, var_t31_mi:7, var_t31_j:7, var_t31_v:7, var_t31_s:0
					} 
					)
		}
	  , salida: 
	    { estados_rta_ud: { var_t32_d:estados_rta.salteada, var_t33:estados_rta.blanco }
		}
	  }
	, { titulo: "La múltiple marcar debe estar toda en blanco"
	  , entrada: 
	    { rta_ud: ( respuestas_ok_hasta_T35 
				    =cambiandole(respuestas_ok_hasta_T31
								, { var_t33:2, var_t35:1 }
								)
    				)
		}
	  , salida: 
	    { estados_rta_ud: { var_t36_1:estados_rta.blanco, var_t36_2:estados_rta.blanco, var_t36_8:estados_rta.blanco }
		}
	  }
	, { titulo: "Cuando ingreso al menos una múltiple debo tener en blanco el salto al próximo campo"
	   , entrada: 
	 	{ rta_ud: ( cambiandole(respuestas_ok_hasta_T35, { var_t36_1:1 }))
	 	}
	   , salida: 
		 { estados_rta_ud: { var_t36_a:estados_rta.blanco }
		 } 
	   }
    , { titulo: "Error: Cuando salteaba una posterior a una múltiple marcar, marcaba como faltante la primera en blanco de la múltiple marcar y no la que correspondía"
	   , entrada: 
	 	{ rta_ud: ( cambiandole(respuestas_ok_hasta_T35, { var_t36_1:1, var_t36_a:1, var_t37:null, var_t38:1 }))
	 	}
	   , salida: 
		 { estados_rta_ud: { var_t36_a:estados_rta.ok, var_t37:estados_rta.omitido, var_t38:estados_rta.hay_omitidas }	
		 , estados_intermedios: {variable_omitida:"var_t37"}
		 } 
	   }
    , { titulo: "Error: Cuando salteaba dos posteriores a una múltiple marcar, marcaba como faltante la primera en blanco de la múltiple marcar y no la que correspondía"
	   , entrada: 
	 	{ rta_ud: ( cambiandole(respuestas_ok_hasta_T35, { var_t36_1:1, var_t36_a:1, var_t37:null, var_t39:1 }))
	 	}
	   , salida: 
		 { estados_rta_ud: { var_t36_a:estados_rta.ok, var_t37:estados_rta.omitido, var_t38:estados_rta.hay_omitidas, var_t39:estados_rta.hay_omitidas }	
		 , estados_intermedios: {variable_omitida:"var_t37"}
		 } 
	   }
	, { titulo: "El sin dato se escribe '--' y se almacena -1 "
	  , entrada:
	    { rta_ud: respuestas_ok_hasta_T35
		, llenar_a_traves_de_elementos: { var_t35:"--" }
	    }
	  , salida:
	    { rta_ud: { var_t35:"-1" }
		, ver_contenido_elementos: { var_t35:"--" }
		} 
	  }
	, { titulo: "Las múltiples marcar muestran la opción pero almacenan 1"
	  , entrada:
	    { rta_ud: respuestas_ok_hasta_T35
		, llenar_a_traves_de_elementos: { var_t36_4:4 }
	    }
	  , salida:
	    { rta_ud: { var_t36_1:null, var_t36_4:1 }
		, ver_contenido_elementos: { var_t36_4:"4" }
		} 
	  }
	, { titulo: "Las múltiples marcar tienen 1 y muestrán el número de la opción"
	  , entrada:
	    { rta_ud: ( cambiandole(respuestas_ok_hasta_T35, { var_t36_3:1, var_t36_6:1 }))
	    }
	  , salida:
	    { rta_ud: { var_t36_1:null, var_t36_3:1, var_t36_6:1 }
		, ver_contenido_elementos: { var_t36_1:"", var_t36_3:"3", var_t36_6:"6"  }
	    }
	  }
	, { titulo: "Error: Cuando lleno un texto libre "
	   , entrada: 
	 	{ rta_ud: ( respuestas_ok_hasta_T37= cambiandole(respuestas_ok_hasta_T35, { var_t36_1:1, var_t36_a:1,var_t37:"Texto_T37" }))
	 	}
	   , salida: 
		 { estados_rta_ud: { var_t37:estados_rta.ok}	
		 } 
	   }
	, { titulo: "Error: Probando las variables heterogeneas (inicializo)"
	   , entrada: 
	 	{ rta_ud: ( respuestas_ok_hasta_T45= cambiandole(respuestas_ok_hasta_T37, { var_t38:1, var_t39:5, var_t40:1, var_t41:"Texto_T41", var_t42:"Texto_T42", var_t43:"Texto_T43", var_t44:2, var_t45:3}))
	 	}
	   , salida: 
		 { estados_rta_ud: { var_t45:estados_rta.ok}	
		 } 
	   }
	, { titulo: "Error: Probando las variables heterogeneas (prueba1)"
	   , entrada: 
	 	{ rta_ud: ( cambiandole(respuestas_ok_hasta_T45, { 	var_t53_ing:1500          , var_t53_nopago:null 			     ,  var_t53c_anios:0            , var_t53c_meses:11            ,var_t53c_98:98 			                       ,var_t54:1				                }))
	 	}
	   , salida: 
		 { estados_rta_ud: { 								var_t53_ing:estados_rta.ok, var_t53_nopago: estados_rta.salteada , var_t53c_anios:estados_rta.ok, var_t53c_meses:estados_rta.ok,var_t53c_98:estados_rta.ingreso_sobre_salto    ,var_t54:estados_rta.ok }	
		 } 
	   }
	, { titulo: "Error: Probando las variables heterogeneas (prueba2)"
	   , entrada: 
	 	{ rta_ud: ( cambiandole(respuestas_ok_hasta_T45, { 	var_t53_ing:0             , var_t53_nopago:1     			,  var_t53c_anios:0            , var_t53c_meses:0             ,var_t53c_98:null		           ,var_t54:1				}))
	 	}
	   , salida: 
		 { estados_rta_ud: { 								var_t53_ing:estados_rta.ok, var_t53_nopago: estados_rta.ok  , var_t53c_anios:estados_rta.ok, var_t53c_meses:estados_rta.ok,var_t53c_98:estados_rta.omitido ,var_t54:estados_rta.hay_omitidas }	
		 } 
	   }
	, { titulo: "Saltos de las variables de otros especificar"
	   , entrada: {rta_ud: respuestas_ok_hasta_T45}
	   , salida: 
		 { preguntas_ud: 
			{ var_t39: 
			  { opciones: 
				{ "1": { salta: "var_t39_bis" }
				, "2": { salta: undefined }
				, "3": { salta: "var_t40" }
				, "4": { salta: undefined }
				, "5": { salta: "var_t40" }
				}
			  }
			, var_t39_barrio:
			  { salta: "var_t40"
			  }
			, var_t39_otro:
			  { salta: "var_t40"
			  }
			, var_t39_bis: 
			  { opciones: 
				{ "1": { salta: undefined }
				, "2": { salta: "var_t40" }
				}
			  }
			, var_t39_bis_cuantos:
			  { salta: undefined // o salta: "var_t39_bis1" lo que sea más fácil
			  }
			}
		  } 
	   }
	, { titulo: "Saltos de las variables de otros especificar múltiples. #85"
	   , entrada: {rta_ud: respuestas_ok_hasta_T45}
	   , salida: 
		 { preguntas_ud: 
			{ var_t36_7: 
			  { opciones: 
				{ "7": { salta: undefined }
				}
			  }
			, var_t36_8: 
			  { opciones: 
				{ "8": { salta: undefined }
				}
			  }
			, var_t36_7_otro:
			  { salta: undefined
			  }
			, var_t36_8_otro:
			  { salta: undefined
			  }			
			}
		  } 
	   }
	, { titulo: "Implementación de las preguntas con salto obligatorio"
	   , entrada: 
	 	{ rta_ud:  { var_t1:2, var_t2:2, var_t3:5, var_t4:4, var_t5:2, var_t9:2, var_t10:2, var_t11:4, var_t11_otro:"algo" }
	 	}
	   , salida: 
		 { estados_rta_ud: { var_t12:estados_rta.salteada, var_t13:estados_rta.blanco }	
		 } 
	   }
	, { titulo: "Error: Probando las variables especifique reordenadas. Salta mal: desde la T39_barrio salta a T39_otro en vez de T40"
	   , entrada: 
	 	{ rta_ud: ( cambiandole(respuestas_ok_hasta_T37, { var_t38:1, var_t39:2, var_t39_barrio:"Algo"}))
	 	}
	   , salida: 
		 { estados_rta_ud: { var_t39_barrio:estados_rta.ok, var_t39_otro:estados_rta.salteada, var_t40:estados_rta.blanco}	
		 } 
	   }
	, { titulo: "Error: Probando las variables especifique reordenadas. Salta mal: desde la T39_otro salta a T39_bis en vez de T40"
	   , entrada: 
	 	{ rta_ud: ( cambiandole(respuestas_ok_hasta_T37, { var_t38:1, var_t39:4, var_t39_otro:"Algo"}))
	 	}
	   , salida: 
		 { estados_rta_ud: { var_t39_otro:estados_rta.ok, var_t39_bis:estados_rta.salteada, var_t40:estados_rta.blanco}	
		 } 
	   }
	, { titulo: "Saltos de las variables de múltiples marcar con mejor. #88"
	   , entrada: {rta_ud: respuestas_ok_hasta_T45} 
	   , salida: 
		 { preguntas_ud: 
			{ var_e11_1: 
			  { opciones: 
				{ "1": { salta: undefined }
				}
			  , salta: undefined
			  }
			, var_e11_14: 
			  { opciones: 
				{ "14": { salta: undefined }
				}
			  , salta: undefined
			  }
			, var_e11_15: 
			  { opciones: 
				{ "15": { salta: undefined }
				}
			  , salta: undefined
			  }
			, var_e11a: 
			  { salta: "var_m1"
			  }
			}
		 } 
	  }
	, { titulo: "el enter salta al siguiente campo"
	  , entrada: { rta_ud: { var_t1: 1 }, variable_actual:"var_t1" }
	  , salida: { proxima_variable:"var_t7" } 
	  }
	, { titulo: "el enter no va al filtro"
	   , entrada: 
	 	{ rta_ud: cambiandole(respuestas_ok_hasta_T45, { var_t53_ing:0 }), variable_actual:"var_t53_ing"
	 	}
	   , salida: { proxima_variable:"var_t53_nopago"}	
	  }
	, { titulo: "Que considere las variables multiples como multiples marcar para dejarlas en blanco"
	   , entrada: 
	 	{ rta_ud: respuestas_ok_hasta_T54b=cambiandole(respuestas_ok_hasta_T45, { var_t53_ing:1, var_t53c_anios:1, var_t53c_meses:1, var_t54:1, var_t54b:18, var_i1:2})
	 	}
	   , salida: 
		{ estados_rta_ud: { var_i3_1:estados_rta.blanco, var_i3_4:estados_rta.blanco, var_i3_7:estados_rta.blanco, var_i3_11:estados_rta.blanco}
		}
	  }
	, { titulo: "Saltos con doble opción"
	   , entrada: 
	 	{ rta_ud: cambiandole(respuestas_ok_hasta_T45, { var_t53_ing:1, var_t53c_anios:1, var_t53c_meses:0})
	 	}
	   , salida: 
		{ estados_rta_ud: { var_t53c_98:estados_rta.salteada, var_t54:estados_rta.blanco}
		}
	  }
	, { titulo: "Error: pide ingresar la opción especificar con otras opciones simples (revisando la SN4)"
	  , entrada: { rta_ud: { var_t1:1, var_t7:2, var_t8:1 }}
	  , salida: { estados_rta_ud: { var_t8:estados_rta.ok, var_t8_otro: estados_rta.salteada, var_t30:estados_rta.blanco, var_t9:estados_rta.salteada }
		}
	  }
	  , { titulo: "Prueba salto a la M1"
	   , entrada: 
	 	{ rta_ud: respuestas_ok_hasta_M1=cambiandole(respuestas_ok_hasta_T54b, { var_i1:2, var_i3_1:1, var_e1:2, var_e2:2, var_e9_edad:18, var_e9_anio:null, var_e10:1, var_e12:2, var_e11_1:1, var_e11a:1})
	 	}
	   , salida: 
		{ estados_rta_ud: { var_m1:estados_rta.blanco}
		}
	  }
	  , { titulo: "No da error no poner dato en especificar" // corregir, múltiples
	   , entrada: 
	 	{ rta_ud: cambiandole(respuestas_ok_hasta_T54b, { var_i1:2, var_i3_1:1, var_e1:2, var_e2:2, var_e9_edad:18, var_e9_anio:null, var_e10:1, var_e12:2, var_e11_15:1, var_e11a:1})
	 	}
	   , salida: 
		{ estados_rta_ud: { var_e11_15_otro:estados_rta.omitido}
		}
	  }
	  , { titulo: "Cuando el especifique está omitido debe saltearse con el enter"
	   , entrada: 
	 	{ rta_ud: cambiandole(respuestas_ok_hasta_T54b, { var_i1:2, var_i3_1:1, var_e1:2, var_e2:2, var_e9_edad:18, var_e9_anio:null, var_e10:1, var_e12:2, var_e11_11:1})
		, variable_actual: "var_e11_15"
	 	}
	   , salida: 
		{ proxima_variable: "var_e11a"
		}
	  }
	  , { titulo: "Error: var_e11_15 no tiene su siguiente"
	   , entrada: 
	 	{ rta_ud: {}
	 	}
	   , salida: 
		{ preguntas_ud: { var_e11_15: {siguiente: "var_e11_15_otro" } } 
		}
	  }
	  , { titulo: "Variable M1 con dos especificar, probando el primero"
	   , entrada: 
	 	{ rta_ud: cambiandole(respuestas_ok_hasta_M1, {var_m1:4})
		, variable_actual: "var_m1"
	 	}
	   , salida: 
		{ estados_rta_ud: { var_m1:estados_rta.ok, var_m1_esp4:estados_rta.blanco}
		, proxima_variable: "var_m1_esp4"
		}
	  }
	  , { titulo: "Variable M1 con dos especificar, probando el segundo"
	   , entrada: 
	 	{ rta_ud: cambiandole(respuestas_ok_hasta_M1, {var_m1:4, var_m1_esp4:"un dato" })
		, variable_actual: "var_m1_esp4"
	 	}
	   , salida: 
		{ estados_rta_ud: { var_m1:estados_rta.ok, var_m1_esp4:estados_rta.ok, var_m1_anio:estados_rta.blanco}
		, proxima_variable: "var_m1_anio"
		}
	  }
	  , { titulo: "Pantalla en blanco"
		, entrada: 
			{ rta_ud: respuestas_ok_hasta_M1
			}
	   , salida: { 	}
	  }
	  , { titulo: "Pantalla en blanco"
	   , entrada: 
			{ rta_ud: respuestas_ok_hasta_T54b
			}
	   , salida: { 	}
	  }
	, { titulo: "Ingreso inteligente en las múltiples, ingresa un 4 sobre el 1"
	   , entrada: { rta_ud: ( cambiandole(respuestas_ok_hasta_T35, { var_t36_1:4 })) }
	   , salida:  { rta_ud: { var_t36_1:null, var_t36_4:1 }, proxima_variable:"var_t36_5" } 
	  }
	, { titulo: "Ingreso inteligente en las múltiples, ingresa un 7 sobre el 5"
	  , entrada: 
	    { rta_ud: respuestas_ok_hasta_T35 
		, variable_actual: "var_t36_5"
		, llenar_a_traves_de_elementos: { var_t36_4:4, var_t36_5:7 }
	    }
	  , salida:  
	    { rta_ud: { var_t36_1:null, var_t36_4:1, var_t36_5:null, var_t36_7:1 }, proxima_variable:"var_t36_7_otro" 
		, ver_contenido_elementos: { var_t36_4:"4", var_t36_7:"7" }
		} 
	  }
	, { titulo: "Ingreso inteligente en las múltiples, ingresa un 8 sobre el 5, pasa a la siguiente"
	  , entrada: 
	    { rta_ud: respuestas_ok_hasta_T35 
		, llenar_a_traves_de_elementos: { var_t36_4:4, var_t36_5:8 } 
		}
	  , salida: 
	    { rta_ud: { var_t36_1:null, var_t36_4:1, var_t36_5:null, var_t36_8:1 }
		, proxima_variable:"var_t36_8_otro" } 
	  }
	, { titulo: "Ingreso inteligente en las múltiples, ingresando la última opción que no tiene especifique"
	   , entrada: 
	   { rta_ud: ( cambiandole(respuestas_ok_hasta_M1, { var_m1:1, var_m1a:1, var_m3:1, var_sn1_1:6 })) 
       , llenar_a_traves_de_elementos: { var_sn1_1:6 } 
	   }
	   , salida:  { rta_ud: { var_sn1_1:null, var_sn1_6:1 }, proxima_variable:"var_sn2" } 
	  }
	, { titulo: "Filtro para un menor de 10 años"
	   , entrada: { copia_ud: { copia_edad:9 }, rta_ud:{ var_e1:1 } }
	   , salida:  { estados_rta_ud: {  var_t1:estados_rta.salteada, var_e1:estados_rta.ok, var_e2:estados_rta.blanco } /* ojo: , proxima_variable:"var_e2" */ } 
	  }
	  
	  
	  // */ 
	  /////// Por ahora no:
	  /* Cuando querramos que el enter para sobre las "sosa"
	  , { titulo: "Cuando el especifique tenga dato y no está marcado que salte a la variable para arreglar el error"
	   , entrada: 
	 	{ rta_ud: respuestas_ok_hasta_M1=cambiandole(respuestas_ok_hasta_T54b, { var_i1:2, var_i3_1:1, var_e1:2, var_e2:2, var_e9_edad:18, var_e9_anio:null, var_e10:1, var_e12:2, var_e11_15_otro:'algo'})
		, variable_actual: "var_e11_15"
	 	}
	   , salida: 
		{ proxima_variable: "var_e11_15_otro"
		}
	  }
	  , { titulo: "Cuando el una variable que debería estar salteada tiene valor, el enter debe detenerse ahí"
	   , entrada: 
	 	{ rta_ud: { var_t1:1, var_t3:1}
		, variable_actual: "var_t1"
	 	}
	   , salida: 
		{ proxima_variable: "var_t3"
		}
	  }
	  */
	]
  }
, { modulo: pru_ingreso_con_estructura_modificada
  , casos:
	[ { titulo: "cuando se para en un valor optativo el siguiente también está en blanco"
	  , entrada: 
		{ preguntas_ud: { var_t37: {optativa:true } } 
		, rta_ud: cambiandole(respuestas_ok_hasta_T35, { var_t36_1:1, var_t36_a:1, var_t37:null, var_t38:null } )
		}
	  , salida: { estados_rta_ud: { var_t37: estados_rta.blanco, var_t38: estados_rta.blanco }}
	  }
	, { titulo: "ingreso de un valor optativo salteado correctamente"
	  , entrada: 
		{ preguntas_ud: { var_t37: {optativa:true } } 
		, rta_ud: cambiandole(respuestas_ok_hasta_T35, { var_t36_1:1, var_t36_a:1, var_t37:null, var_t38:1 } )
		}
	  , salida: { estados_rta_ud: { var_t37: estados_rta.blanco, var_t38: estados_rta.ok }}
	  }
	]
  }
];

pru_casos=pru_casos.concat(casos_yeah);

pru_parar_en_el_primero=true;

guardar_en_localStorage("pk_ud_navegacion",JSON.stringify({encuesta: 1, nhogar:1, formulario:'I1', matriz:'', miembro:1}));

function pru_eval(caso){
"use strict";
    var obtenido=eval(caso.entrada);
    pru_comparar(caso.salida,obtenido,caso.titulo);
}

function pru_hacer_expresion_evaluable(caso){
	var obtenido=hacer_expresion_evaluable(caso.entrada);
	pru_comparar(caso.salida,obtenido,caso.titulo);
}

function pru_ingreso_simple(caso){
	rta_ud=caso.entrada.rta_ud;
	copia_ud.copia_edad=30;
	if(caso.entrada.copia_ud){
		copia_ud=caso.entrada.copia_ud;
	};
	var proxima_variable;
	if(caso.entrada.llenar_a_traves_de_elementos){
	  for(var id_variable in caso.entrada.llenar_a_traves_de_elementos){
	    var valor=caso.entrada.llenar_a_traves_de_elementos[id_variable];
		elemento_existente(id_variable).focus();
		elemento_existente(id_variable).value=valor;
		window.event={which:13};
		elemento_existente(id_variable).onkeypress();
		proxima_variable=document.activeElement.id;
	  }
	}else{
	  proxima_variable=Validar_rta_ud(caso.entrada.variable_actual);
	}
	Colorear_rta_ud();
	var contenidos_vistos={};
	if(caso.salida.ver_contenido_elementos){
	  for(var id_variable in caso.salida.ver_contenido_elementos){
	    contenidos_vistos[id_variable]=elemento_existente(id_variable).value;
	  }
	}
	var obtenido=
		{ rta_ud: rta_ud 
		, estados_rta_ud: estados_rta_ud
		, estados_intermedios: estados_intermedios
		, preguntas_ud: preguntas_ud
		, proxima_variable: proxima_variable
		, ver_contenido_elementos: contenidos_vistos
		};
	pru_comparar(caso.salida,obtenido,caso.titulo);
}

function pru_ingreso_con_estructura_modificada(caso){
	preguntas_ud=cambiandole(preguntas_ud, caso.entrada.preguntas_ud);
	pru_ingreso_simple(caso);
}