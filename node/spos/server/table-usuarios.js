"use strict";

module.exports = function(context){
    var admin = context.user.usu_rol ==='suprrhh'  || context.user.usu_rol ==='programador' // */;
    return context.be.tableDefAdapt({
        name:'usuarios',
        title:'usuarios',
        editable:admin,
        prefix:'usu',
        fields:[
            {name:'usu_usu'         , typeName:'text'   , nullable:false},
            // {name:'md5pass'         , typeName:'text'                   },
            {name:'usu_activo'      , typeName:'boolean'                },
            {name:'usu_rol'         , typeName:'text'   , allow:{select:admin}  },
            {name:'usu_nombre'      , typeName:'text'                   },
            {name:'usu_apellido'    , typeName:'text'                   },
        ],
        sql:{
            where: admin?'true':"usu_usu = "+context.be.db.quoteText(context.user.usu_usu)
        },
        primaryKey:['usu_usu'],
    });
}