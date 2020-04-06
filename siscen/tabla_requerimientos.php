<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_requerimientos extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('req');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('req_proy',array('hereda'=>'proyectos','modo'=>'pk'));
        $this->definir_campo('req_req' ,array('es_pk'=>true,'tipo'=>'texto','largo'=>10));
        $this->definir_campo('req_titulo',array('tipo'=>'texto','largo'=>100,'mostrar_al_elegir'=>true));
        $this->definir_campo('req_tiporeq',array('hereda'=>'tipo_req','modo'=>'fk_obligatoria'));
        $this->definir_campo('req_detalles',array('tipo'=>'texto'));
        $this->definir_campo('req_grupo',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('req_componente',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('req_prioridad',array('tipo'=>'entero'));
        $this->definir_campo('req_costo',array('tipo'=>'entero'));
        $this->definir_campo('req_plazo',array('tipo'=>'timestamp'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
        
        CREATE OR REPLACE FUNCTION req_ins_trg()
        RETURNS trigger AS
        $BODY$
        BEGIN
        INSERT INTO siscen.req_nov(
            reqnov_proy, reqnov_req, reqnov_reqnov, reqnov_reqest, 
            reqnov_tlg)
        VALUES (new.req_proy, new.req_req, '1', 'borrador', new.req_tlg);
        RETURN new;
END
$BODY$
        LANGUAGE plpgsql VOLATILE
        COST 100;
/*OTRA*/
        ALTER FUNCTION req_ins_trg() OWNER TO siscen_php;
/*OTRA*/
      CREATE TRIGGER req_ins_trg
      AFTER INSERT
      ON requerimientos
      FOR EACH ROW
      EXECUTE PROCEDURE req_ins_trg();

SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}            
?>