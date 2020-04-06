<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_varcalopc extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('varcalopc');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('varcalopc_ope',array('hereda'=>'operativos','modo'=>'pk'));
        $this->definir_campo('varcalopc_varcal',array('hereda'=>'varcal','modo'=>'pk'));
        $this->definir_campo('varcalopc_opcion',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('varcalopc_expresion_condicion',array('tipo'=>'texto','largo'=>1000));
       // $this->definir_campo('varcalopc_expresion',array('tipo'=>'texto','largo'=>500));
        $this->definir_campo('varcalopc_etiqueta',array('tipo'=>'texto','largo'=>802));
        $this->definir_campo('varcalopc_expresion_valor',array('tipo'=>'texto','largo'=>1000));
        $this->definir_campo('varcalopc_origen',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('varcalopc_orden',array('tipo'=>'entero'));
        $this->definir_campo('varcalopc_comentarios',array('tipo'=>'texto','largo'=>200));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE varcalopc
  ADD CONSTRAINT "texto invalido en varcalopc_etiqueta de tabla varcalopc" CHECK (comun.cadena_valida(varcalopc_etiqueta::text, 'cualquiera'::text));
/*OTRA*/
ALTER TABLE varcalopc
  ADD CONSTRAINT "texto invalido en varcalopc_expresion de tabla varcalopc" CHECK (comun.cadena_valida(varcalopc_expresion_condicion::text, 'formula'::text));
/*OTRA*/
ALTER TABLE varcalopc
  ADD CONSTRAINT "texto invalido en varcalopc_ope de tabla varcalopc" CHECK (comun.cadena_valida(varcalopc_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE varcalopc
  ADD CONSTRAINT "texto invalido en varcalopc_varcal de tabla varcalopc" CHECK (comun.cadena_valida(varcalopc_varcal::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

class Grilla_varcalopc extends Grilla_tabla{
    
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="varcalopc";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_varcalopc");
        $this->tabla->campos_lookup=array(
               //"var_for"=>false,
               //"varcal_destino"=>false,
               //"table_name"=>false,
               //"bases"=>false,
               "varcal_tem"=>false,
               "fecha_ultima_modificacion"=>false,               
           ); 
        $this->tabla->tablas_lookup=array( 
            //"varcal va"=>'va.var_var=basprovar_var AND va.var_ope=basprovar_ope',
            "varcal vc"=>'vc.varcal_varcal=varcalopc_varcal AND vc.varcal_ope=varcalopc_ope',
            "(select tlg_tlg, tlg_momento as fecha_ultima_modificacion from tiempo_logico t join sesiones s on s.ses_ses=t.tlg_ses) as t"=>'t.tlg_tlg=varcalopc_tlg and varcalopc_tlg>1',
            //"(SELECT substr(column_name,5) as variableinfo, encu.tabla_variable(substr(column_name,5)) as table_name
            //       FROM information_schema.columns  
            //       WHERE table_name IN ('plana_a1_', 'plana_tem_', 'plana_s1_','plana_s1_p','plana_i1_') AND table_schema='encu' AND substr(column_name,5) NOT IN ('enc','hog','mie','exm','tlg')
            //    ) as c"
            //=>'variableinfo=basprovar_var',
            //"(SELECT basprovar_var as bases_var, string_agg(basprovar_baspro,', ' order by basprovar_baspro) as bases
            //    FROM baspro_var
            //    GROUP BY basprovar_var) bases"=>"bases_var=basprovar_var",
            //"(SELECT basprovar_ope as ope, coalesce(var_var,varcal_varcal) as variable, encu.nombre_largo_para_documentacion(basprovar_var,basprovar_baspro) as nombre_largo_para_documentacion
            //  FROM baspro_var b 
            //    LEFT JOIN variables v ON b.basprovar_ope = v.var_ope AND b.basprovar_var = v.var_var
            //    LEFT JOIN varcal c ON b.basprovar_ope = c.varcal_ope AND b.basprovar_var = c.varcal_varcal
            //    LEFT JOIN preguntas p ON v.var_ope = p.pre_ope AND v.var_pre = p.pre_pre) as dr"
            //=>'dr.variable=basprovar_var AND dr.ope=basprovar_ope',
        );
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('procesamiento')){
          $editables=array('varcalopc_ope','varcalopc_varcal','varcalopc_opcion','varcalopc_expresion_condicion',
                           'varcalopc_etiqueta','varcalopc_expresion_valor','varcalopc_origen','varcalopc_orden',
                           'varcalopc_comentarios');
        }
        return $editables;
    }

    function puede_insertar(){
        return tiene_rol('procesamiento');
    }
    function puede_eliminar(){
        return tiene_rol('procesamiento');
    }
    function campos_a_listar($filtro_para_lectura){
        return array(  'varcalopc_ope',
                       'varcalopc_varcal', 
                       'varcalopc_opcion',
                       'varcalopc_expresion_condicion',
                       'varcalopc_etiqueta',
                       'varcalopc_expresion_valor',                       
                       'varcalopc_origen', 
                       'varcal_tem',
                       'varcalopc_orden',
                       'varcalopc_comentarios',
                       'fecha_ultima_modificacion');
    }

}
?>