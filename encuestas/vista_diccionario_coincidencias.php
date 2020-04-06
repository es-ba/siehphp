<?php
//UTF-8:SÍ
class Vista_diccionario_coincidencias extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('vis_dic'                    ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'dicvar_dic'));
        $this->definir_campo('vis_var'                    ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'dicvar_var'));
        $this->definir_campo('vis_for'                    ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'var_for'));
        $this->definir_campo('vis_ori'                    ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'dictra_ori'));
        $this->definir_campo('vis_des'                    ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'dictra_des'));
        $this->definir_campo('vis_coincidencias'          ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'base.coincidencias'));
        $this->definir_campos_orden(array('dicvar_dic','dicvar_var','dictra_ori'));
    }
    function clausula_from(){
      return " (select dicvar_dic, dicvar_var, var_for, var_ope, dictra_ori, dictra_des, count(res_valor) as coincidencias
        from encu.dicvar 
        inner join encu.diccionario on dicvar_dic=dic_dic 
        inner join encu.dictra on dicvar_dic=dictra_dic 
        inner join encu.variables on dicvar_var = var_var
        left join encu.respuestas on res_var = dicvar_var and res_for = var_for  and res_ope = var_ope  and ( dic_completo and dbo.cadena_normalizar(res_valor) = dictra_ori)
        group by dicvar_dic, dicvar_var, var_for, var_ope, dictra_ori, dictra_des 
               ) as base";  

          /*return " (select dic_dic, dicvar_var, var_for, var_ope, dictra_ori, dictra_des, count(*) as coincidencias
from encu.diccionario inner join encu.dicvar on dic_dic=dicvar_dic inner join encu.dictra on dicvar_dic=dictra_dic inner join encu.variables on dicvar_var = var_var 
left join encu.respuestas on res_var = dicvar_var and res_for = var_for and res_ope = var_ope
where ((dic_completo is true and dbo.cadena_normalizar(res_valor) = dictra_ori) or ( dic_completo is not true and  upper(res_valor) like '%'||upper(dictra_ori)||'%' ))
group by dic_dic, dicvar_var, var_for, var_ope, dictra_ori, dictra_des   
       ) as base";*/           
    }    
    function clausula_where_agregada(){
        return " and var_ope='{$GLOBALS['NOMBRE_APP']}' ";
    }
}
?>