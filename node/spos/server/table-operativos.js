"use strict";

module.exports = function(context){
    return context.be.tableDefAdapt({
        name:'operativos',
        editable:context.user.rol==='admin',
        fields:[
            {name:'operativo'       , typeName:'text'   , nullable:false},
            // {name:'md5pass'         , typeName:'text'                   },
            {name:'anio_op'         , typeName:'integer', nullable:false},
            {name:'tipo_op'         , typeName:'integer'                },
            {name:'continuo'        , typeName:'boolean'                },
            {name:'persona_dni'     , typeName:'integer', nullable:false},
            {name:'aprob_do'        , typeName:'boolean'                },
            {name:'aprob_subd'      , typeName:'boolean'                },
            {name:'fecha'    , typeName:'text',    nullable:false},
            {name:'puesto_of'    , typeName:'text',    nullable:false},
            {name:'respuesta'    , typeName:'text',    nullable:false},
            {name:'comentarios_ll'    , typeName:'text',    nullable:false},
            {name:'capacitacion'    , typeName:'text',    nullable:false},
            {name:'campo2'    , typeName:'text',    nullable:false},
            {name:'campo1'    , typeName:'text',    nullable:false},
            {name:'alta_periodo'    , typeName:'text',    nullable:false},
            {name:'baja_periodo'    , typeName:'text',    nullable:false},
            {name:'puesto_final'    , typeName:'text',    nullable:false},
            {name:'novedades'    , typeName:'text',    nullable:false},
            {name:'fecha_nov'    , typeName:'text',    nullable:false},
            {name:'motivo'    , typeName:'text',    nullable:false},
            {name:'nota_capacitacion'    , typeName:'text',    nullable:false},
            {name:'evaluacion_a'    , typeName:'text',    nullable:false},
            {name:'evaluacion_b'    , typeName:'text',    nullable:false},
            {name:'evaluacion_c'    , typeName:'text',    nullable:false},
            {name:'evaluacion_d'    , typeName:'text',    nullable:false},
            {name:'evaluacion_e'    , typeName:'text',    nullable:false},
            {name:'puesto_ig'    , typeName:'text',    nullable:false},
            {name:'puesto_mas'    , typeName:'text',    nullable:false},
            {name:'puesto_menos'    , typeName:'text',    nullable:false},
            {name:'puesto_sugerido'    , typeName:'text',    nullable:false},
            {name:'ev_abril'    , typeName:'text',    nullable:false},
            {name:'ev_junio'    , typeName:'text',    nullable:false},
            {name:'ev_diciem'    , typeName:'text',    nullable:false},
            {name:'coment_evaluac'    , typeName:'text',    nullable:false},
            {name:'coment_evaluado'    , typeName:'text',    nullable:false},
            {name:'evaluado_por'    , typeName:'text',    nullable:false},
            {name:'tipo_de_contrato'    , typeName:'text',    nullable:false}
        ],
        primaryKey:['operativo', 'anio_op', 'persona_dni', 'puesto_final'],
    });
}