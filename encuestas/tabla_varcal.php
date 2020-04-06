<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_varcal extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('varcal');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('varcal_ope',array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('varcal_varcal',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('varcal_destino',array('tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('varcal_orden',array('tipo'=>'entero'));
        $this->definir_campo('varcal_nombre',array('tipo'=>'texto','largo'=>300,'validart'=>'castellano'));
        $this->definir_campo('varcal_comentarios',array('tipo'=>'texto','largo'=>200,'validart'=>'castellano'));
        $this->definir_campo('varcal_activa',array('tipo'=>'logico'));
        $this->definir_campo('varcal_tipo',array('tipo'=>'texto','largo'=>50,'not_null'=>true,'def'=>'normal'));         
        $this->definir_campo('varcal_baseusuario',array('tipo'=>'logico','not_null'=>true,'def'=>false));
        $this->definir_campo('varcal_nombrevar_baseusuario',array('tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('varcal_tipodedato',array('tipo'=>'texto','largo'=>50,'def'=>'entero'));
        $this->definir_campo('varcal_nombre_dr',array('tipo'=>'texto'));
        $this->definir_campo('varcal_nsnc_atipico',array('tipo'=>'entero'));
        $this->definir_campo('varcal_grupo',array('tipo'=>'texto'));
        $this->definir_campo('varcal_tem',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('varcal_valida',array('tipo'=>'logico'));
        $this->definir_campo('varcal_opciones_excluyentes',array('tipo'=>'logico', 'def'=>true));
        $this->definir_campo('varcal_filtro',array('tipo'=>'texto','largo'=>1000));
        $this->definir_campo('varcal_cerrado',array('tipo'=>'logico','def'=>false));
        $this->definir_tablas_hijas(array(
            'varcalopc'=>true,
        ));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE varcal
  ADD CONSTRAINT "texto invalido en varcal_comentarios de tabla varcal" CHECK (comun.cadena_valida(varcal_comentarios::text, 'cualquiera'::text));
/*OTRA*/
ALTER TABLE varcal
  ADD CONSTRAINT "texto invalido en varcal_destino de tabla varcal" CHECK (comun.cadena_valida(varcal_destino::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE varcal
  ADD CONSTRAINT "texto invalido en varcal_nombre de tabla varcal" CHECK (comun.cadena_valida(varcal_nombre::text, 'cualquiera'::text));
/*OTRA*/
ALTER TABLE varcal
  ADD CONSTRAINT "texto invalido en varcal_ope de tabla varcal" CHECK (comun.cadena_valida(varcal_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE varcal
  ADD CONSTRAINT "texto invalido en varcal_varcal de tabla varcal" CHECK (comun.cadena_valida(varcal_varcal::text, 'identificador'::text));
/*OTRA*/
ALTER TABLE varcal
  DROP CONSTRAINT IF EXISTS "tipo de variable calculada inválido (normal,externo,especial)";
/*OTRA*/
ALTER TABLE varcal
  ADD CONSTRAINT "tipo de variable calculada inválido" CHECK (varcal_tipo::text in ('normal','externo','especial','interno'));
/*OTRA*/
ALTER TABLE encu.varcal
 ADD CONSTRAINT "texto invalido en varcal_tipodedato de tabla varcal" CHECK (varcal_tipodedato::text in ('entero','decimal','texto'));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }  
    function definir_orden_por_otra($otra){
        $campos_orden=array();
        $campos_orden[]='varcal_ope';
        $campos_orden[]='varcal_destino';
        $campos_orden[]=$otra;
        $this->definir_campos_orden($campos_orden);
    }
}

class Grilla_varcal extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="varcal";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_varcal");
        $this->tabla->campos_lookup=array(
               "fecha_ultima_modificacion"=>false,               
           ); 
        $this->tabla->tablas_lookup=array( 
            "(select varcalopc_varcal, max(tlg_momento) as fecha_ultima_modificacion from varcalopc vco join tiempo_logico t on t.tlg_tlg=vco.varcalopc_tlg join sesiones s on s.ses_ses=t.tlg_ses where varcalopc_tlg>1 group by varcalopc_varcal) as t"=>'t.varcalopc_varcal=varcal_varcal',
        );
    }    
    function puede_insertar(){
        return tiene_rol('procesamiento');
    }
    function puede_eliminar(){
        return tiene_rol('procesamiento');
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('programador') || tiene_rol('procesamiento')){
            $editables[]='varcal_ope';
            $editables[]='varcal_varcal';
            $editables[]='varcal_destino';
            $editables[]='varcal_orden';
            $editables[]='varcal_nombre';
            $editables[]='varcal_comentarios';
            $editables[]='varcal_activa';
            $editables[]='varcal_tipo';
            $editables[]='varcal_tipodedato';
            $editables[]='varcal_nombre_dr';
            $editables[]='varcal_nsnc_atipico';
            $editables[]='varcal_grupo';
            $editables[]='varcal_tem';
            $editables[]='varcal_opciones_excluyentes';
            $editables[]='varcal_filtro';
            $editables[]='varcal_cerrado';
        }
        return $editables;
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'C',
            'title'=>'Compilar',
            'proceso'=>'compilar_variables_calculadas',
            'campos_parametros'=>array('tra_ope'=>$GLOBALS['nombre_app'], 'tra_varcal'=>null, 'tra_mas_info'=>false, 'tra_mostrar_grilla'=>true),
            'y_luego'=>'compilar'
        );
    }
}

?>