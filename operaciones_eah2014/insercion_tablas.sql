INSERT INTO encu.usuarios(
            usu_usu, usu_rol, usu_clave, usu_activo, usu_nombre, usu_apellido, 
            usu_blanquear_clave, usu_interno, usu_mail, usu_mail_alternativo, 
            usu_rol_secundario, usu_tlg)
SELECT  usu_usu, usu_rol, usu_clave, usu_activo, usu_nombre, usu_apellido, 
        usu_blanquear_clave, usu_interno, usu_mail, usu_mail_alternativo, 
        usu_rol_secundario, /*CAMPOS_AUDITORIA*/ usu_tlg
        FROM encu_anterior.usuarios
        WHERE usu_usu<>'instalador';
/*OTRA*/
INSERT INTO encu.tipo_nov(
            tiponov_tiponov, tiponov_tlg)
    select tiponov_tiponov, /*CAMPOS_AUDITORIA*/ from encu_anterior.tipo_nov;
/*OTRA*/
insert into encu.tabulados(tab_tab,tab_titulo,tab_fila1,tab_fila2,tab_columna,tab_cel_exp,tab_cel_tipo,tab_filtro,tab_notas,tab_observaciones,tab_tlg)  
select tab_tab,tab_titulo,tab_fila1,tab_fila2,tab_columna,tab_cel_exp,tab_cel_tipo,tab_filtro,tab_notas,tab_observaciones,/*CAMPOS_AUDITORIA*/ from encu_anterior.tabulados;
/*OTRA*/
insert into encu.tabulados(tab_tab,tab_titulo,tab_fila1,tab_fila2,tab_columna,tab_cel_exp,tab_cel_tipo,tab_filtro,tab_notas,tab_observaciones,tab_tlg)  
select tab_tab,tab_titulo,tab_fila1,tab_fila2,tab_columna,tab_cel_exp,tab_cel_tipo,tab_filtro,tab_notas,tab_observaciones,/*CAMPOS_AUDITORIA*/ from encu_anterior.tabulados;
/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/

/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/
/*OTRA*/