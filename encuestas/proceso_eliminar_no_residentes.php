<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_eliminar_no_residentes extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Eliminar NO residentes',
            'permisos'=>array('grupo1'=>'procesamiento'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP'])
                //'tra_confirmar1'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Sé que antes de entrar a esta encuesta tengo que salir del sistema y volver a entrar'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_eliminar','value'=>'eliminar No Residentes'),
        ));
    }
    
    function correr(){
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            select count(*) n_noresi
                from plana_s1_p s 
                join plana_tem_ t on t.pla_enc= s.pla_enc
                where pla_r0=2 and pla_estado>=77 
SQL
        ));
        $datos=$cursor->fetchObject();
        $this->salida->enviar("Se eliminarían ".$datos->n_noresi. ' no residentes en encuestas con estado >=77');
        parent::correr();
    }    
    function responder(){
        $cartel='';
        $dias=preg_match("/^eah/",$GLOBALS['NOMBRE_APP'])?12:9;
        if($this->argumentos->tra_ope!=$GLOBALS['NOMBRE_APP']){
            return new Respuesta_Negativa("Solo se pueden eliminar registros del operativo ".$GLOBALS['NOMBRE_APP']);
        }
        //deben haber trascurrido al menos 9 dias despues de la ultima fecha de la tabla semanas
        // posiblemente se cambie por el control de una marca en operativos
        $dias_str=$dias. ' days';
        $cursor=$this->db->ejecutar_sql(new Sql(
            "select current_date-date(sem_carga_recu_hasta+interval ".$this->db->quote($dias_str).")>=0 momentohabilitado
               from semanas
                where sem_sem=12
            "
          ,array()
        ));
        $dfecha=$cursor->fetchObject();
        if(!$dfecha->momentohabilitado){
            return new Respuesta_Negativa("Proceso no habilitado aún, debe haber cerrado campo y procesamiento");
        }
        // todas las encuestas tienen que tener estado>=77
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
          select count(*) cant_estmenor77 from plana_tem_
             where pla_estado<77
SQL
          ,array()
        ));
        $datos=$cursor->fetchObject();
        if($datos->cant_estmenor77>0){
            return new Respuesta_Negativa("Hay encuestas en estado <77");
        }
        // controlar que fueron eliminados los residentes en otras tablas
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            select ua_pk, mat_for, mat_mat 
                from  matrices m join ua on ua.ua_ope=m.mat_ope and ua.ua_ua=m.mat_ua
                where mat_ope=ope_actual()
                and ua_ua='mie' and mat_mat is distinct from 'P'
SQL
            ,array()
        ));
        function addPrefix($v){
            return ('pla_'.$v);
        }
        while($dtabla=$cursor->fetchObject()){
            $tabla='plana_'."{$dtabla->mat_for}_{$dtabla->mat_mat}";
            $using=json_decode($dtabla->ua_pk,true);
            $using1= implode(',',array_map("addPrefix", $using));
            $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
              select count(*) cant
                from {$tabla} join plana_s1_p using ({$using1})
                where pla_r0=2
SQL
            ,array()
            ));
            $datos=$cursor->fetchObject();
            if($datos->cant>0){
               return new Respuesta_Negativa("Hay No Residentes en {$tabla}, deberá eliminarlos con la opcion correspondiente");
            }   
        }
        $cursor1=$this->db->ejecutar_sql(new Sql(<<<SQL
            with no_residentes as (
            select s.pla_enc, s.pla_hog, s.pla_mie, t.pla_estado
                from plana_s1_p s 
                join plana_tem_ t on t.pla_enc= s.pla_enc
                where pla_r0=2 and pla_estado>=77 
            ), res_noresi as ( 
            select count(*) n_res_noresi
            from respuestas r join no_residentes nr on 
                res_ope= dbo.ope_actual()
                and res_for not in ('TEM', 'SUP')
                and res_mat ='P'
                and res_enc=nr.pla_enc 
                and res_hog=nr.pla_hog
                and res_mie=nr.pla_mie
            ), cla_noresi as (
            select count(*) n_cla_noresi
            from claves c join no_residentes nr on 
                cla_ope= dbo.ope_actual()
                and cla_for not in ('TEM', 'SUP')
                and cla_mat ='P'
                and cla_enc=nr.pla_enc 
                and cla_hog=nr.pla_hog
                and cla_mie=nr.pla_mie
            ), s1p_noresi  as (
            select count(*)n_s1p_noresi from plana_s1_p p join no_residentes nr on  
                p.pla_enc=nr.pla_enc 
                and p.pla_hog=nr.pla_hog
                and p.pla_mie=nr.pla_mie   
            )
            select *
                from res_noresi, cla_noresi, s1p_noresi
SQL
            ,array()
        ));
        $datos_pre=$cursor1->fetchObject();
        if ($datos_pre->n_s1p_noresi>0){
            $cq=[];
            $sentencias_arr=array(
                //creacion de tablas para no residentes
                // No agrego drop para que salte error si ya estaban 
                 "CREATE TABLE encu.respuestas_noresidentes (LIKE respuestas INCLUDING ALL);"
                ,"CREATE TABLE encu.claves_noresidentes (LIKE claves INCLUDING ALl);"
                ,"CREATE TABLE encu.plana_s1_p_noresidentes (LIKE plana_s1_p INCLUDING ALl);"

                //bkp_previo_sacar_noresi
                ,"CREATE SCHEMA IF NOT EXISTS operaciones_noresidentes AUTHORIZATION tedede_php;"
                ,"select * into operaciones_noresidentes.respuestas
                from respuestas
                order by res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, res_var;"
                ,"select * into operaciones_noresidentes.claves
                from claves
                order by cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm;"
                ,"select * into operaciones_noresidentes.plana_s1_p_
                from plana_s1_p 
                order by pla_enc, pla_hog, pla_mie, pla_exm	;"

                //sacando no residentes
                ,"with no_residentes as (
                select s.pla_enc, s.pla_hog, s.pla_mie, t.pla_estado
                    from plana_s1_p s 
                    join plana_tem_ t on t.pla_enc= s.pla_enc
                    where pla_r0=2 and pla_estado>=77
                ), res_noresi as ( 
                    delete 
                        from respuestas r 
                        using no_residentes nr 
                        where 
                            res_ope= dbo.ope_actual()
                            and res_for not in ('TEM', 'SUP')
                            and res_mat ='P'
                            and res_enc=nr.pla_enc 
                            and res_hog=nr.pla_hog
                            and res_mie=nr.pla_mie
                        returning r.*
                ), bkp_resp as (
                    insert into respuestas_noresidentes
                        select * from res_noresi
                ), cla_noresi as (
                    delete 
                        from claves c 
                        using  no_residentes nr
                        where
                            cla_ope= dbo.ope_actual()
                            and cla_for not in ('TEM', 'SUP')
                            and cla_mat ='P'
                            and cla_enc=nr.pla_enc 
                            and cla_hog=nr.pla_hog
                            and cla_mie=nr.pla_mie
                        returning c.*
                ), bkp_cla as (
                    insert into claves_noresidentes
                        select * from cla_noresi
                ), s1p_noresi  as (
                    delete from plana_s1_p p 
                        using  no_residentes nr 
                        where 
                            p.pla_enc=nr.pla_enc 
                            and p.pla_hog=nr.pla_hog
                            and p.pla_mie=nr.pla_mie   
                        returning p.*
                ), bkp_s1p as (
                    insert into plana_s1_p_noresidentes
                        select * from s1p_noresi
                )
                select  'eliminados' etapa, (select count(*) from res_noresi) n_res_elim,
                    (select  count(*) from cla_noresi) n_cla_elim,
                    (select  count(*) from s1p_noresi) n_s1p_elim 
                ;"
                ," grant select on plana_s1_p_noresidentes to ".$GLOBALS['NOMBRE_APP']."_ro;"
            );
            $key_cantelim=count($sentencias_arr)-2;
            $this->db->beginTransaction();
            try{
                foreach($sentencias_arr as $sql_parcial){
                        if($sql_parcial){
                            $cq[]=$this->db->ejecutar_sql(new Sql($sql_parcial,array()));
                        }

                }
            }catch(Exception $e){
                    $this->db->rollBack();
                    return new Respuesta_Negativa($e->getMessage());
            }
            $datos_post=$cq[$key_cantelim]->fetchObject();
            if ($datos_pre->n_s1p_noresi!=$datos_post->n_s1p_elim
                ||$datos_pre->n_cla_noresi!=$datos_post->n_cla_elim
                ||$datos_pre->n_res_noresi!=$datos_post->n_res_elim){
                return new Respuesta_Negativa('No coinciden la cantidad de registros a eliminar  s1p:('.$datos_pre->n_s1p_noresi.",".$datos_post->n_s1p_elim ."), claves(".$datos_pre->n_cla_noresi.",". $datos_post->n_cla_elim . "), respuestas(".$datos_pre->n_res_noresi.",".$datos_post->n_res_elim.")");  
            }
            $cartel= 'No residentes eliminados: '.$datos_post->n_s1p_elim ;
            $this->db->commit();
        }else{
            $cartel='No hay No Residentes a eliminar';
        }       
        return new Respuesta_Positiva($cartel);
    }       
}
?>