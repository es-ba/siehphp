"use strict";

module.exports = function(context){
    var puedeEditar = context.user.usu_rol ==='ingresador'  || context.user.usu_rol ==='admin'  || context.user.usu_rol ==='programador' // */;
    return context.be.tableDefAdapt({
        name:'requerimientos',
        editable:puedeEditar,
        fields:[
            {name:'req_proy'           , typeName:'text'      , nullable:false},
            {name:'req_req'            , typeName:'text'      , nullable:false},
            {name:'req_titulo'         , typeName:'text'      , nullable:false},
            {name:'req_tiporeq'        , typeName:'text'      , nullable:false},
            {name:'req_detalles'       , typeName:'text'      , nullable:false},
            {name:'req_grupo'          , typeName:'text'                      },
            {name:'req_componente'     , typeName:'text'                      },
            {name:'req_prioridad'      , typeName:'number'                    },
            {name:'req_costo'          , typeName:'number'                    },
            {name:'req_plazo'          , typeName:'date'                      },
            {name:'req_desarrollo'     , typeName:'text'                      },
        ],
        primaryKey:['req_proy','req_req'],
    });
}
