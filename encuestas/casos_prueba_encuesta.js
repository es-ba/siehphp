//UTF-8:SÍ
"use strict";

var casos_encuestas=
[ { modulo: pru_eval
  , casos:
    [ { titulo: "este texto no es fecha"
      , entrada: "dbo.es_fecha('este')"
      , salida: null  // cambiar por 01 para ver un error en pantalla
      }
    , { titulo: "sin año es fecha"
      , entrada: "dbo.es_fecha('3/4')"
      , salida: true
      }
    , { titulo: "este es un texto informado"
      , entrada: "dbo.textoinformado('este')"
      , salida: 1
      }
    , { titulo: "'' no es texto informado"
      , entrada: "dbo.textoinformado('')"
      , salida: 0
      }
    , { titulo: "null no es texto informado"
      , entrada: "dbo.textoinformado(null)"
      , salida: 0
      }
    , { titulo: "fecha completa con año a 4 dígitos"
      , entrada: "dbo.texto_a_fecha('3/12/2013')"
      , salida: ['3','12','2013'] // creo que sería mejor que devolviese un array de integers...
      }
    , { titulo: "fecha completa con año a 2 dígitos"
      , entrada: "dbo.texto_a_fecha('3/12/12')"
      , salida: ['3','12','2012'] 
      }
    , { titulo: "fecha completa con año a 2 dígitos del 7/7/7"
      , entrada: "dbo.texto_a_fecha('7/7/7')"
      , salida: ['7','7','2007'] 
      }
    , { titulo: "edad a la fecha, cálculo completo"
      , entrada: "dbo.edad_a_la_fecha('6/5/1969','7/7/2012')"
      , salida: 43
      }
    , { titulo: "edad a la fecha, cálculo con 2 dígitos en fecha actual"
      , entrada: "dbo.edad_a_la_fecha('6/5/1969','7/7/12')"
      , salida: 43
      }
    , { titulo: "edad a la fecha, cálculo con 2 dígitos en fecha actual"
      , entrada: "dbo.edad_a_la_fecha('6/11/1969','7/7/12')"
      , salida: 42
      }
    , { titulo: "edad a la fecha, cálculo con sin año actual"
      , entrada: "dbo.edad_a_la_fecha('6/11/1969','7/7')"
      , salida: dbo.anio()-1970
      }
    , { titulo: "edad a la fecha, cálculo con sin año actual"
      , entrada: "dbo.edad_a_la_fecha('6/11/69','7/7')"
      , salida: dbo.anio()-1970
      }
    , { titulo: "fecha válida"
      , entrada: "fechadma(2,3,1990)"
      , salida: '02/03/1990'
      }
    , { titulo: "fecha válida"
      , entrada: "fechadma(null,3,1990)"
      , salida: ''
      }
    , { titulo: "fecha válida"
      , entrada: "fechadma(30,2,1990)"
      , salida: ''
      }
    , { titulo: "fecha válida"
      , entrada: "fechadma(30,2,90)"
      , salida: ''
      }
    , { titulo: "fecha válida"
      , entrada: "fechadma(2,4,1990)"
      , salida: '02/04/1990'
      }
    , { titulo: "fecha válida"
      , entrada: "fechadma(111,4,1990)"
      , salida: ''
      }
    , { titulo: "fecha válida"
      , entrada: "fechadma('perro',4,1990)"
      , salida: ''
      }
    , { titulo: "fecha válida"
      , entrada: "fechadma(2,4,74)"
      , salida: ''
      }
    , { titulo: "fecha válida"
      , entrada: "fechadma(-9,4,1990)"
      , salida: ''
      }
    , { titulo: "fecha válida"
      , entrada: "fechadma(9,'mono',1990)"
      , salida: ''
      }
    ]
  }
];

pru_casos=pru_casos.concat(casos_encuestas);
