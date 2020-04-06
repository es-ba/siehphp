drop table if exists encu.import_info;

create table encu.import_info   (
  operativo text,
  agrupacion text,
  grupo text,
  var_var text,
  var_promedio text,
  primary key (operativo, agrupacion, grupo)
);

ALTER TABLE encu.import_info
  OWNER TO tedede_php;


insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D11',  'ca_p'            , 'ca_p_t'              );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D211', 'alquiler_p'      , 'alquiler_p_t'        );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D221', 'gastoexpensas_p' , 'gastoexpensas_p_t'   );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D231', 'gas_p'           , 'gas_p_t'             );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D241', 'electricidad_p'  , 'electricidad_p_t'    );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D251', 'agua_p'          , 'agua_p_t'            );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D311', 'jardin_p'        , 'jardin_p_t'          );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D312', 'preescyprim_p'   , 'preescyprim_p_t'     );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D313', 'secundaria_p'    , 'secundaria_p_t'      );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D321', 'artytextos_p'    , 'artytextos_p_t'      );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D33',  'transpu_p'       , 'transpu_p_t'         );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D34',  'comunicaciones_p', 'comunicaciones_p_t'  );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D411', 'limpieza_p'      , 'limpieza_p_t'        );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D421', 'esparcimiento_p' , 'esparcimiento_p_t'   );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D431', 'bieneserv_p'     , 'bieneserv_p_t'       );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D511', 'indadultos_p'    , 'indadultos_p_t'      );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D512', 'indninios_p'     , 'indninios_p_t'       );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D52',  'salud_p'         , 'salud_p_t'           );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'D', 'D53',  'equipamiento_p'  , 'equipamiento_p_t'    );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A11',  'ca_c'            , 'ca_c_t'              );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A211', 'alquiler_c'      , 'alquiler_c_t'        );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A221', 'gastoexpensas_c' , 'gastoexpensas_c_t'   );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A231', 'gas_c'           , 'gas_c_t'             );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A241', 'electricidad_c'  , 'electricidad_c_t'    );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A251', 'agua_c'          , 'agua_c_t'            );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A311', 'jardin_c'        , 'jardin_c_t'          );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A312', 'preescyprim_c'   , 'preescyprim_c_t'     );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A313', 'secundaria_c'    , 'secundaria_c_t'      );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A321', 'artytextos_c'    , 'artytextos_c_t'      );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A33',  'transpu_c'       , 'transpu_c_t'         );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A34',  'comunicaciones_c', 'comunicaciones_c_t'  );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A411', 'limpieza_c'      , 'limpieza_c_t'        );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A421', 'esparcimiento_c' , 'esparcimiento_c_t'   );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A431', 'bieneserv_c'     , 'bieneserv_c_t'       );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A511', 'indadultos_c'    , 'indadultos_c_t'      );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A512', 'indninios_c'     , 'indninios_c_t'       );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A513', 'axesorios_c'     , 'axesorios_c_t'       );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A514', 'servind_c'       , 'servind_c_t'         );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A52',  'salud_c'         , 'salud_c_t'           );
insert into encu.import_info(operativo, agrupacion, grupo,var_var,var_promedio) values ('val_can', 'A', 'A53',  'equipamiento_c'  , 'equipamiento_c_t'    );
