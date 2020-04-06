"use strict";

module.exports = function(context){
    var puedeEditar = context.user.usu_rol === 'ingresador'  || context.user.usu_rol ==='admin'  || context.user.usu_rol ==='programador';
    return context.be.tableDefAdapt({
        name:'proyectos',
        editable: puedeEditar,
        fields: [
            {name: 'proy_proy'        ,typeName:'text'          ,nullable:false},
            {name: 'proy_nombre'      ,typeName:'text'          ,nullable:false},
            {name: 'proy_tlg'         ,typeName:'number'        ,nullable:false}
        ],
        primaryKey:['proy_proy'],
    });
}