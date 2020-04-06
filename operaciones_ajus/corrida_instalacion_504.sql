INSERT INTO encu.consistencias(
            con_ope, con_con, con_activa, con_descripcion, con_valida,con_tlg)
    VALUES 
    ('AJUS', 'opc_homi'                   , FALSE, 'hay variables anteriores omitidas, estas todavía no están ingresadas ni tienen nada abajo ingresado', FALSE,1),
    ('AJUS', 'opc_inconsistente'          , FALSE, 'pertenece a alguna inconsistencia', FALSE,1),
    ('AJUS', 'opc_inex'                   , FALSE, 'un valor que no existe entre las opciones', FALSE,1),
    ('AJUS', 'opc_nsnc'                   , FALSE, 'no sabe - no contesta', FALSE,1),
    ('AJUS', 'opc_omit'                   , FALSE, 'esta variable se omitió el ingreso y era obligatoria', FALSE,1),
    ('AJUS', 'opc_rana'                   , FALSE, 'fuera_de_rango_advertencia', FALSE,1),
    ('AJUS', 'opc_rano'                   , FALSE, 'fuera_de_rango_obligatorio', FALSE,1),
    ('AJUS', 'opc_sinesp'                 , FALSE, 'sin especificar', FALSE,1),
    ('AJUS', 'opc_sosa'                   , FALSE, 'una opción sobre una variable que debía ser salteada', FALSE,1),
    ('AJUS', 'opc_tipo'                   , FALSE, 'error de tipo', FALSE,1),
    ('AJUS', 'opc_tono'                   , FALSE, 'esta variable todavía no debe ingresarse porque hay una variable en blanco más arriba', FALSE,1);
