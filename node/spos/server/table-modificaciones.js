"use strict";

module.exports = function(context){
    return context.be.tableDefAdapt({
        name:'modificaciones',
        editable:context.user.rol==='admin',
        prefix: 'mdf',
        fields:[
          {name:'mdf_mdf'       , typeName:'integer' },
          {name:'mdf_tabla'     , typeName:'text',   },
          {name:'mdf_operacion' , typeName:'text',   },
          {name:'mdf_pk'        , typeName:'text',   },
          {name:'mdf_campo'     , typeName:'text'    },
          {name:'mdf_actual'    , typeName:'text',   },
          {name:'mdf_anterior'  , typeName:'text',   },
          {name:'mdf_tlg'       , typeName:'text',},
        ],
        primaryKey:['mdf_mdf'],
    });
}