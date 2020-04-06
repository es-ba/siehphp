"use strict";

module.exports = function(context){
    var puedeEditar = context.user.usu_rol ==='ingresador'  || context.user.usu_rol ==='admin'  || context.user.usu_rol ==='programador' // */;
    return context.be.tableDefAdapt({
        name:'req_nov',
        editable:puedeEditar,
        fields:[
            {name:'reqnov_proy'           , typeName:'text'        , nullable:false},
            {name:'reqnov_req'            , typeName:'text'        , nullable:false},
            {name:'reqnov_reqnov'         , typeName:'number'      , nullable:false},
            {name:'reqnov_comentario'     , typeName:'text'        , nullable:false},
            {name:'reqnov_reqest'         , typeName:'text'        , nullable:false},
            {name:'reqnov_campo'          , typeName:'text'        , nullable:false},
            {name:'reqnov_anterior'       , typeName:'text'        , nullable:false},
            {name:'reqnov_actual'         , typeName:'text'        , nullable:false},
        ],
        primaryKey:['reqnov_proy','reqnov_req','reqnov_reqnov'],
    });
}
