INSERT INTO encu.roles(
            rol_rol, rol_descripcion, rol_tlg)
SELECT rol_rol, rol_descripcion, /*CAMPOS_AUDITORIA*/ rol_tlg
  FROM encu_anterior.roles;
/*OTRA*/
update encu.roles set rol_ver_con_hasta_nivel = 40 where rol_rol = 'procesamiento';
/*OTRA*/
update encu.roles set rol_ver_con_hasta_nivel = 20 where rol_rol = 'encuestador';
/*OTRA*/
update encu.roles set rol_ver_con_hasta_nivel = 20 where rol_rol = 'ingresador';
/*OTRA*/
update encu.roles set rol_ver_con_hasta_nivel = 30 where rol_rol = 'recepcionista';
/*OTRA*/
update encu.roles set rol_ver_con_hasta_nivel = 30 where rol_rol = 'subcoor_campo';
/*OTRA*/
update encu.roles set rol_ver_con_hasta_nivel = 90 where rol_rol = 'programador';
/*OTRA*/
update encu.roles set rol_ver_con_hasta_nivel = 30 where rol_rol = 'coor_campo';
/*OTRA*/
update encu.roles set rol_ver_con_hasta_nivel = 30 where rol_rol = 'ana_campo';
/*OTRA*/
update encu.roles set rol_ver_con_hasta_nivel = 30 where rol_rol = 'sup_ing';
/*OTRA*/
update encu.roles set rol_ver_con_hasta_nivel = 30 where rol_rol = 'aux_info_campo';