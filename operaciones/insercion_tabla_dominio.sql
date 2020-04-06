INSERT INTO dominio (dom_dom, dom_descripcion, dom_marco, dom_dias_para_fin_campo, dom_dias_para_fin_norea, dom_tlg) 
select dom_dom, dom_descripcion, dom_marco, dom_dias_para_fin_campo, dom_dias_para_fin_norea, /*CAMPOS_AUDITORIA*/ from encu_anterior.dominio;

