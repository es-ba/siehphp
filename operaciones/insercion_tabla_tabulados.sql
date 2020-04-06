insert into encu.tabulados(tab_tab,tab_titulo,tab_fila1,tab_fila2,tab_columna,tab_cel_exp,tab_cel_tipo,tab_filtro,tab_notas,tab_observaciones,tab_decimales,tab_cerrado,tab_grupo,tab_tlg)  
select tab_tab,tab_titulo,tab_fila1,tab_fila2,tab_columna,tab_cel_exp,tab_cel_tipo,tab_filtro,tab_notas,tab_observaciones,tab_decimales,tab_cerrado,tab_grupo,/*CAMPOS_AUDITORIA*/ from encu_anterior.tabulados
where false;
