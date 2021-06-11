<?php
//UTF-8:SÍ
require_once "tablas.php";

class Tabla_tem extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('tem');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('tem_enc',array('es_pk'=>true,'tipo'=>'entero', 'title'=>'ENCUESTA'));
        $this->definir_campo('tem_id_marco',array('tipo'=>'bentero'));
        $this->definir_campo('tem_comuna',array('tipo'=>'entero', 'title' => 'COMUNA'));
        $this->definir_campo('tem_replica',array('tipo'=>'entero', 'title' => 'REPLICA', 'not_null'=>true, 'def'=>1));
        $this->definir_campo('tem_up',array('tipo'=>'entero', 'title' => 'UP'));
        $this->definir_campo('tem_lote',array('tipo'=>'entero', 'title' => 'LOTE'));
        $this->definir_campo('tem_clado',array('tipo'=>'entero'));
        $this->definir_campo('tem_ccodigo',array('tipo'=>'entero'));
        $this->definir_campo('tem_cnombre',array('tipo'=>'texto','largo'=>255, 'title' => 'CALLE'));
        $this->definir_campo('tem_hn',array('tipo'=>'texto', 'title' => 'Nº DE PUERTA'));
        $this->definir_campo('tem_hp',array('tipo'=>'texto','largo'=>255, 'title' => 'PISO'));
        $this->definir_campo('tem_hd',array('tipo'=>'texto','largo'=>255, 'title' => 'DEPTO'));
        $this->definir_campo('tem_hab',array('tipo'=>'texto','largo'=>255, 'title' => 'HABITACION'));
        $this->definir_campo('tem_h4',array('tipo'=>'entero', 'title' => 'TIPO DE VIVIENDA'));
        $this->definir_campo('tem_usp',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_barrio',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_ident_edif',array('tipo'=>'texto','largo'=>255, 'title' => 'TORRE O CUERPO'));
        $this->definir_campo('tem_obs',array('tipo'=>'texto','largo'=>255, 'title' => 'OBSERVACIONES'));
        $this->definir_campo('tem_frac_comun',array('tipo'=>'entero'));
        $this->definir_campo('tem_radio_comu',array('tipo'=>'entero'));
        $this->definir_campo('tem_mza_comuna',array('tipo'=>'entero'));
        $this->definir_campo('tem_dominio',array('tipo'=>'entero', 'not_null'=>true));
        $this->definir_campo('tem_marco',array('tipo'=>'entero'));
        $this->definir_campo('tem_titular',array('tipo'=>'entero'));
        $this->definir_campo('tem_zona',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_lote2011',array('tipo'=>'texto','largo'=>255));
        $this->definir_campo('tem_para_asignar',array('tipo'=>'texto','largo'=>255));        
        $this->definir_campo('tem_participacion',array('tipo'=>'entero', 'not_null'=>true, 'def'=>1)); 
        $this->definir_campo('tem_codpos',array('tipo'=>'texto','largo'=>12));     
        $this->definir_campo('tem_etiquetas',array('tipo'=>'entero'));     
        $this->definir_campo('tem_tipounidad',array('tipo'=>'texto','largo'=>255));     
        $this->definir_campo('tem_tot_hab',array('tipo'=>'entero'));     
        $this->definir_campo('tem_estrato',array('tipo'=>'texto','largo'=>12));  
        if (!(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015 )){      
            $this->definir_campo('tem_fexp',array('tipo'=>'entero'));
        };
        // a partir de acà los campos agregados en etoi143
        $this->definir_campo('tem_areaup',array('tipo'=>'entero')); 
        $this->definir_campo('tem_trimestre',array('tipo'=>'entero'));
        $this->definir_campo('tem_semana',array('tipo'=>'entero'));
        $this->definir_campo('tem_rotaci_n_etoi',array('tipo'=>'entero'));
        $this->definir_campo('tem_rotaci_n_eah',array('tipo'=>'entero'));
        $this->definir_campo('tem_idtipounidad',array('tipo'=>'entero'));        
        $this->definir_campo('tem_h1_mues',array('tipo'=>'entero'));
        $this->definir_campo('tem_idcuerpo',array('tipo'=>'entero'));        
        $this->definir_campo('tem_estrato',array('tipo'=>'entero'));
        $this->definir_campo('tem_cuerpo',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('tem_cuit',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('tem_rama_act',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('tem_nomb_inst',array('tipo'=>'texto','largo'=>200));
        $this->definir_campo('tem_pzas',array('tipo'=>'entero'));
        $this->definir_campo('tem_te',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('tem_idprocedencia',array('tipo'=>'entero'));
        $this->definir_campo('tem_procedencia',array('tipo'=>'texto','largo'=>200));
        $this->definir_campo('tem_yearfuente',array('tipo'=>'entero'));
        $this->definir_campo('tem_anio_list',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('tem_marco_anio',array('tipo'=>'entero'));
        $this->definir_campo('tem_nro_orden',array('tipo'=>'entero'));
        $this->definir_campo('tem_operacion',array('tipo'=>'texto','largo'=>10));
        // a partir de acà los campos agregados en etoi143 segunda tanda        
        $this->definir_campo('tem_area',array('tipo'=>'entero'));
        $this->definir_campo('tem_reserva',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('tem_up_comuna',array('tipo'=>'entero'));
        $this->definir_campo('tem_h4_mues',array('tipo'=>'entero'));
        $this->definir_campo('tem_ups',array('tipo'=>'entero'));
        $this->definir_campo('tem_sel_etoi14_villa',array('tipo'=>'entero'));
        $this->definir_campo('tem_obs_campo',array('tipo'=>'texto','largo'=>255));        
        $this->definir_campo('tem_inq_tot_hab',array('tipo'=>'entero'));        
        $this->definir_campo('tem_inq_ocu_flia',array('tipo'=>'entero'));        
        $this->definir_campo('tem_obs_historico',array('tipo'=>'texto','largo'=>255));  
        //a partir de aca campo agregado en ut2015     
        $this->definir_campo('tem_version_cuest',array('tipo'=>'entero', 'not_null'=>true, 'def'=>1)); 
        // a partir de etoi173
        //$this->definir_campo('tem_periodicidad',array('tipo'=>'texto', 'largo'=>1));
        //a partir de eah2017  
        if ((substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2017 ) ||
            (substr($GLOBALS['NOMBRE_APP'],0,4)=='etoi'&& $GLOBALS['anio_operativo']>=2018 )){      
            $this->definir_campo('tem_cant_participaciones',array('tipo'=>'entero'));
        };
        if ($GLOBALS['NOMBRE_APP']==='empa171') {
            $this->definir_campo('tem_sectorb', array('tipo'=>'texto'));
            $this->definir_campo('tem_manzanab',array('tipo'=>'texto'));
            $this->definir_campo('tem_ladob',array('tipo'=>'texto'));
            $this->definir_campo('tem_relevb',array('tipo'=>'texto'));
            $this->definir_campo('tem_hojab',array('tipo'=>'entero'));
            $this->definir_campo('tem_filab',array('tipo'=>'entero'));
        };
        //a partir de etoi201
         if ( $GLOBALS['anio_operativo']>=2020 && 
              ( substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'||substr($GLOBALS['NOMBRE_APP'],0,4)=='etoi' )){ 
              $this->definir_campo('tem_codviviendaparticular',array('tipo'=>'texto','largo'=>1));               
              $this->definir_campo('tem_sector',array('tipo'=>'texto', 'largo'=>10));
              $this->definir_campo('tem_edificio',array('tipo'=>'texto','largo'=>30));
              $this->definir_campo('tem_entrada',array('tipo'=>'texto','largo'=>24));  
              $this->definir_campo('tem_usodomicilio',array('tipo'=>'entero'));               
        };
        
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE tem
  ADD CONSTRAINT "LOTE DEBE SER IGUAL A AREA (set lote=area)" CHECK (tem_lote::integer is not distinct from tem_area::integer);
/*OTRA*/
ALTER TABLE tem
  ADD CONSTRAINT "SEMANA DEBE SER IGUAL A REPLICA (set replica=semana)" CHECK (tem_replica is not distinct from tem_semana);
/*OTRA*/  
/*
--ALTER TABLE tem
--ADD CONSTRAINT "VALORES DE SEMANA DEBEN ESTAR ENTRE 1 Y 12" CHECK (((tem_dominio in (3,4) AND tem_semana >= 1 AND tem_semana <= 12 )) 
--                                                                      or (tem_semana >= 0 AND tem_semana <= 12 AND tem_dominio=5));
--OTRA
*/
/*
--ALTER TABLE tem
-- ADD CONSTRAINT "COD. POSTAL DEBE TENER VALOR PARA DOMINIO 3" CHECK (tem_dominio in (4,5) or tem_codpos is not null);  
--OTRA
*/
ALTER TABLE tem
  ADD CONSTRAINT "CLADO DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (tem_dominio =5 or tem_clado is not null);
/*OTRA*/
ALTER TABLE tem
  ADD CONSTRAINT "HN DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (tem_dominio =5 or tem_hn is not null);
/*OTRA*/
ALTER TABLE tem
  ADD CONSTRAINT "MZA_COMUNA DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (tem_dominio =5 or tem_mza_comuna is not null);  
/*OTRA*/
ALTER TABLE tem
  ADD CONSTRAINT "ESTRATO DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (tem_dominio =5 or tem_estrato is not null);  
/*OTRA*/
ALTER TABLE tem
  ADD CONSTRAINT "AREAUP DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (tem_dominio =5 or tem_areaup is not null);
/*OTRA*/

ALTER TABLE tem
  ADD CONSTRAINT "CCODIGO DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (tem_dominio =5 or tem_ccodigo is not null);
/*OTRA*/
/*
// h4_mues ahora viene vacio fue reemplazado por otro campo por departamento muestreo
ALTER TABLE tem
  ADD CONSTRAINT "H4_MUES DEBE TENER VALOR PARA DOMINIOS 3,4" CHECK (tem_dominio = 5 OR tem_h4_mues IS NOT NULL);
OTRA
 ALTER TABLE tem   h4_mues ahora viene vacio fue reemplazado por otro campo por departamento muestreo
  ADD CONSTRAINT "h4_mues no puede tener valor 50 para dominio 3" CHECK (tem_dominio in (4,5) OR tem_h4_mues is distinct from 50);
*/  

ALTER TABLE tem
  ADD CONSTRAINT "h4 no puede tener valor 50 para dominio 3" CHECK (tem_dominio in (4,5) OR tem_h4 is distinct from 50);
/*OTRA*/
ALTER TABLE encu.tem
  ADD CONSTRAINT "hab sólo tiene valor si h4_mues=5 ó 6 y no puede ser cero"   CHECK ((tem_hab is null  and tem_h4_mues not in (5,6)) OR  (tem_h4_mues in (5,6) and tem_hab is not null and tem_hab is distinct from '0' ));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }    
}

?>