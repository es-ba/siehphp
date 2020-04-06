<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "esquemas.php";
// require_once "procesos.php";

class Triggers_tem extends Objeto_de_la_base{
    function __construct(){
        $this->definir_esquema($GLOBALS['esquema_principal']);
    }
    function ejecutar_instalacion($con_dependientes=true){
        global $implode_nombres_campos_claves;
        // $tabla_ua=new 
        $sqls=new Sqls();
        $BODY='$BODY';
        $este_archivo_fuente=basename(__FILE__);
        $tabla_ua=$this->contexto->nuevo_objeto('Tabla_ua');
        $tabla_ua->leer_varios(array());
        $tabla_claves=$this->contexto->nuevo_objeto('Tabla_claves');
        $tabla_respuestas=$this->contexto->nuevo_objeto('Tabla_respuestas');
        $tabla_tem=$this->contexto->nuevo_objeto('Tabla_tem');        
        $cantidad=0;
        $inserts_en_tabla_variables='';
        $esquema=$tabla_ua->nombre_esquema;
        $campos_insertar='';
        $campos_new='';
        $campos_sin_prefijo_pk='';
        foreach($tabla_claves->obtener_nombres_campos_pk() as $campo){
            $campos_new.='new.'.$campo.',';
            $campos_sin_prefijo_pk.=$campo.',';
            $campo_sin_prefijo=quitar_prefijo($campo,$tabla_claves->obtener_prefijo());
            $campos_insertar.=$tabla_respuestas->obtener_prefijo().$campo_sin_prefijo.',';
        }        
        foreach($tabla_tem->obtener_nombres_campos() as $campo_tem){
            $campo_tem=quitar_prefijo($campo_tem,$tabla_tem->obtener_prefijo());
            if (!in_array($tabla_claves->obtener_prefijo().$campo_tem,$tabla_claves->obtener_nombres_campos_pk())) {
                $campos_sin_prefijo[]=$campo_tem;
            }
        }
        $campos_tem='tem'.implode(',tem', $campos_sin_prefijo);
        $campos_plana_tem='pla'.implode(',pla', $campos_sin_prefijo);
        $campos_tem=str_replace('tem_tlg', '$2',$campos_tem);        
        $operativo_actual = $GLOBALS['NOMBRE_APP'];
        $sqls->agregar(new Sql(<<<SQL
CREATE OR REPLACE FUNCTION claves_ins_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_sentencia text;
BEGIN
  -- GENERADO POR: $este_archivo_fuente
  INSERT INTO encu.respuestas ({$campos_insertar} res_var, res_tlg)
    SELECT {$campos_new} var_var, new.cla_tlg
      FROM encu.variables 
      WHERE var_ope=new.cla_ope AND var_mat=new.cla_mat AND var_for=new.cla_for;
if new.cla_ope = '$operativo_actual' then
  IF new.cla_for='TEM' and new.cla_mat='' THEN
    v_sentencia:='INSERT INTO encu.plana_tem_ ({$implode_nombres_campos_claves('pla_@,','N')}    {$campos_plana_tem}) (SELECT {$implode_nombres_campos_claves('$#, ','N','',3)} {$campos_tem} FROM encu.tem  WHERE tem_enc=$1)';
    EXECUTE v_sentencia USING new.cla_enc, new.cla_tlg {$implode_nombres_campos_claves(', new.cla_@','N')};
  ELSE
    v_sentencia:='INSERT INTO encu.plana_'||new.cla_for||'_'||new.cla_mat||' (pla_tlg{$implode_nombres_campos_claves(', pla_@','N')}) values ($1 {$implode_nombres_campos_claves(', $#','N','',2)})';
    EXECUTE v_sentencia USING new.cla_tlg {$implode_nombres_campos_claves(', new.cla_@','N')};
  END IF;
end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql;
SQL
));
        $sqls->agregar(new Sql(<<<SQL
DROP TRIGGER IF EXISTS claves_ins_trg
  ON encu.claves
SQL
));
        $sqls->agregar(new Sql(<<<SQL
CREATE TRIGGER claves_ins_trg
  AFTER INSERT
  ON encu.claves
  FOR EACH ROW
  EXECUTE PROCEDURE claves_ins_trg();
SQL
));
        $sqls->agregar(new Sql(<<<SQL
CREATE OR REPLACE FUNCTION variables_ins_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_mat_ua text;
BEGIN
  -- GENERADO POR: $este_archivo_fuente
  INSERT INTO encu.respuestas ({$campos_insertar} res_var, res_tlg)
    SELECT {$campos_sin_prefijo_pk} new.var_var, new.var_tlg
      FROM encu.claves
      WHERE cla_ope=new.var_ope AND cla_for=new.var_for AND cla_mat=new.var_mat;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql;
SQL
));
        $sqls->agregar(new Sql(<<<SQL
DROP TRIGGER IF EXISTS variables_ins_trg
  ON encu.variables
SQL
));
        $sqls->agregar(new Sql(<<<SQL
CREATE TRIGGER variables_ins_trg
  AFTER INSERT
  ON encu.variables
  FOR EACH ROW
  EXECUTE PROCEDURE variables_ins_trg();
SQL
));
        $this->contexto->db->ejecutar_sqls($sqls);
    }
}

?>