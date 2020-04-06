"use strict";


var pru_casos_tabulados=[
    { modulo: pru_tabulados
    , casos: [
        { titulo: "tabulado simple"
        , metodo: "obtener_matriz"
        , entrada: { 
            datos:{
                ultimo_campo:{arriba:'sexo', izquierda:'zona', centro:'dato'},
                campos:{
                    sexo:{posicion:'arriba'},
                    zona:{posicion:'izquierda'},
                    dato:{posicion:'centro'},
                },
                columnas:[{sexo:1}, {sexo:2}],
                cuerpo:[
                    {sexo:1, zona:'A', dato:11},
                    {sexo:1, zona:'B', dato:12},
                    {sexo:2, zona:'A', dato:21}
                ]
            }
          }
        , salida:{
            matriz:{
                superior:[],
                central:[{lateral:[],medio:[null,null]}],
                numero_columnas_campo_arriba:{},
                fila_de_la_clave_fila:{
                    "{}":{"lateral":[],"medio":[null,null]}
                }
            }
          }
        }
    ]
    }
];

pru_casos=pru_casos.concat(pru_casos_tabulados);

function pru_tabulados(caso){
    var tabulado=new Tabulados();
    for(var propiedad in caso.entrada){
        tabulado[propiedad]=caso.entrada[propiedad];
    }
    pru_probador_modulo(caso,function(){
        tabulado[caso.metodo]();
        return tabulado;
    });
}
