<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "procesos.php";

class Tabla_plana_TEM_ extends Tabla_planas{
    function update_TEM($encuesta,$variables_y_valores_a_cambiar){
        if(!isset($this->tabla_respuestas)){
            $this->tabla_respuestas=$this->contexto->nuevo_objeto("Tabla_respuestas");
        }
        foreach($variables_y_valores_a_cambiar as $variable=>$valor){
            $this->tabla_respuestas->valores_para_update=array('res_valor'=>$valor,'res_tlg'=>obtener_tiempo_logico($this->contexto));
            $this->tabla_respuestas->ejecutar_update_unico(array_merge(
                claves_respuesta_vacia('res_'),
                array(
                    'res_ope'=>$GLOBALS['NOMBRE_APP'],
                    'res_for'=>'TEM',
                    'res_enc'=>$encuesta,
                    'res_var'=>$variable,
                )
            ));
        }
    }
    function restricciones_especificas(){
        $BODY='$BODY';            
        $todas=<<<SQL
            ALTER TABLE IF EXISTS encu.plana_tem_ 
            ADD CONSTRAINT "rea_enc y  norea_enc nulos y verificado_enc distinto a 2" 
              CHECK (pla_verificado_enc=2 or pla_verificado_enc is null or pla_rea_enc is not null or pla_norea_enc is not null);
        /*OTRA*/    
            ALTER TABLE IF EXISTS encu.plana_tem_ 
            ADD CONSTRAINT "rea_recu y norea_recu nulos y verificado_recu distinto a 2" 
              CHECK (pla_verificado_recu=2 or pla_verificado_recu is null or pla_rea_recu is not null or pla_norea_recu is not null);
        /*OTRA*/    
            ALTER TABLE IF EXISTS encu.plana_tem_
            ADD CONSTRAINT "SEMANA DEBE SER IGUAL A REPLICA" 
              CHECK (
                   (NOT pla_semana IS DISTINCT FROM pla_replica or
                      pla_dominio in (4,5) and pla_estado in (null, 18,19) )       
              );
         /*OTRA*/    
            ALTER TABLE IF EXISTS encu.plana_tem_
            ADD CONSTRAINT "VALORES DE SEMANA DEBEN ESTAR ENTRE 1 Y 12" CHECK (((pla_dominio in (3,4) and pla_semana >= 1 AND pla_semana <= 12 )) 
                              or (pla_semana >= 0 AND pla_semana <= 12 and pla_dominio=5));    
         /*OTRA*/       
            ALTER TABLE encu.plana_tem_
            ADD CONSTRAINT "COD. POSTAL DEBE TENER VALOR PARA DOMINIO 3" CHECK (pla_dominio in (4,5) or pla_codpos is not null);
        /*OTRA*/ 
            ALTER TABLE encu.plana_tem_
            ADD CONSTRAINT "CLADO DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (pla_dominio =5 or pla_clado is not null);
        /*OTRA*/ 
            ALTER TABLE encu.plana_tem_
            ADD CONSTRAINT "HN DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (pla_dominio =5 or pla_hn is not null);
        /*OTRA*/ 
            ALTER TABLE encu.plana_tem_
            ADD CONSTRAINT "MZA_COMUNA DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (pla_dominio =5 or pla_mza_comuna is not null);  
        /*OTRA*/ 
            ALTER TABLE encu.plana_tem_
            ADD CONSTRAINT "ESTRATO DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (pla_dominio =5 or pla_estrato is not null);  
        /*OTRA*/ 
            ALTER TABLE encu.plana_tem_
            ADD CONSTRAINT "AREAUP DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (pla_dominio =5 or pla_areaup is not null);
        /*OTRA*/ 
            ALTER TABLE encu.plana_tem_
            ADD CONSTRAINT "CCODIGO DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (pla_dominio =5 or pla_ccodigo is not null);
        /*OTRA*/ 
            ALTER TABLE encu.plana_tem_
            ADD CONSTRAINT "Obs_campo no puede contener símbolo de fin de linea" CHECK ( NOT comun.contiene_findelinea(pla_obs_campo));       
        /*OTRA*/
            ALTER TABLE encu.plana_tem_
            ADD CONSTRAINT "H4_MUES DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (pla_dominio = 5 OR pla_h4_mues IS NOT NULL);             
--en sieh 
       /*OTRA*/
           ALTER TABLE encu.plana_tem_
           ADD CONSTRAINT "h4_mues no puede tener valor 50 para dominio 3" CHECK (pla_dominio in (4,5) OR pla_h4_mues is distinct from 50);
       /*OTRA*/
           ALTER TABLE encu.plana_tem_
           ADD CONSTRAINT "h4 no puede tener valor 50 para dominio 3" CHECK (pla_dominio in (4,5) OR pla_h4 is distinct from 50);
       /*OTRA*/
           ALTER TABLE encu.plana_tem_ 
           ADD CONSTRAINT "hab sólo tiene valor si h4_mues=5 ó 6 y no puede ser cero"  CHECK ((pla_hab is null  and pla_h4_mues not in (5,6)) OR  (pla_h4_mues in (5,6) and pla_hab is not null and pla_hab is distinct from '0' ));                
SQL;
            $sqls=new Sqls();
            foreach(explode('/*OTRA*/',$todas) as $sentencia){
                $sqls->agregar(new Sql($sentencia));
            }
            return $sqls;
    }
}

class Tabla_plana_S1_   extends Tabla_planas{}
class Tabla_plana_S1_P  extends Tabla_planas{}
class Tabla_plana_I1_   extends Tabla_planas{}
class Tabla_plana_A1_   extends Tabla_planas{}
//class Tabla_plana_A1_X extends Tabla_planas{}
class Tabla_plana_PMD_  extends Tabla_planas{}
//class Tabla_plana_MD_   extends Tabla_planas{}
class Tabla_plana_SUP_  extends Tabla_planas{}
//class Tabla_plana_PG1_  extends Tabla_planas{}
//class Tabla_plana_PG1_M extends Tabla_planas{}


?>