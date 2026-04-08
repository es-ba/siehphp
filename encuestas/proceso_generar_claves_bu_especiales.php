<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_generar_claves_bu_especiales extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Generar mie_bu y enc_bu (claves bu especiales)',
            'permisos'=>array('grupo'=>'procesamiento', 'grupo1'=>'programador'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP'])
                //'tra_confirmar1'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Sé que antes de entrar a esta encuesta tengo que salir del sistema y volver a entrar'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_generar','value'=>'generar'),
        ));
    }
    
    function responder(){
        $cartel='';
        $this->salida=new Armador_de_salida(true);
        $archivo='../encuestas/generar_clave_mie_bu.sql';
        $dias=preg_match("/^eah/",$GLOBALS['NOMBRE_APP'])?12:9;
        if($this->argumentos->tra_ope!=$GLOBALS['NOMBRE_APP']){
            return new Respuesta_Negativa("Solo procesamos registros del operativo ".$GLOBALS['NOMBRE_APP']);
        }
        //deben haber trascurrido al menos 9 dias despues de la ultima fecha de la tabla semanas
        // posiblemente se cambie por el control de una marca en operativos
        $dias_str=$dias. ' days';
        $cursor=$this->db->ejecutar_sql(new Sql(
            "select current_date-date(sem_carga_recu_hasta+interval ".$this->db->quote($dias_str).")>=0 momentohabilitado
               from semanas
                where sem_sem=(select max(sem_sem) from semanas )
            "
          ,array()
        ));
        $dfecha=$cursor->fetchObject();
        if(!$dfecha->momentohabilitado){
            return new Respuesta_Negativa("Proceso no habilitado aún, debe haber cerrado campo y procesamiento");
        }
        // todas las encuestas tienen que tener estado>=77
        $cursor=$this->db->ejecutar_sql(new Sql("
          select count(*) cant_estmenor77 from plana_tem_
             where pla_estado<77
          " ,array()
        ));
        $datos=$cursor->fetchObject();
        if($datos->cant_estmenor77>0){
            return new Respuesta_Negativa("Hay encuestas en estado <77");
        }
        //hay noresidentes
        $cursor1=$this->db->ejecutar_sql(new Sql(<<<SQL
            select count(*) n_noresi
                from plana_s1_p s 
                join plana_tem_ t on t.pla_enc= s.pla_enc
                where pla_r0=2 and pla_estado>=77 
SQL
            ,array()
        ));
        $datos_pre=$cursor1->fetchObject();
        if ($datos_pre->n_noresi>0){
            return new Respuesta_Negativa("Hay NO Residentes, hay que eliminarlos antes de generar las claves bu");
        }

        //empieza la generacion
        $sql_sentencias=explode("/*OTRA*/\r\n",file_get_contents($archivo));
        
        $blanquear_lineaComentario=function ($linea){
            if (preg_match("/^--/", $linea)){
                return '';
            }else{
                return $linea;    
            }
        };

        $this->db->beginTransaction();
                     
        foreach($sql_sentencias as $cada_sentencia) { 

            //dividir en lineas y borrar las que empiezan con --, luego unir             
            $aux1=preg_split("/\r\n/",$cada_sentencia);
            $aux1_sin_comentarios=array_map(
                $blanquear_lineaComentario 
                , $aux1
            );
            $aux3=array_filter($aux1_sin_comentarios, function($elem){
                return !(preg_match("/^\r?\n$/",$elem) ||$elem=='');
            });
            $cada_sentencia_fitrada=implode(
                "\r\n",$aux3
            );    
            $this->db->ejecutar_sql(new Sql($cada_sentencia_fitrada));
            
        }
        $reemplazos[$this->argumentos->tra_ope]=['#campobu#'=>'enc_bu','#sufijovista#'=>'','#otrastablasjoin#'=>''];
        if (preg_match("/^eah/",$this->argumentos->tra_ope)){
            $reemplazos['ETOI']=['#campobu#'=>'enc_etoi_bux',
                '#sufijovista#'=>'_etoix',
                '#otrastablasjoin#'=>"\r\n                 inner join encu.pla_ext_hog t on t.pla_enc= i.pla_enc and t.pla_modo=".$this->db->quote('ETOI','dato').' AND t.pla_hog=1'
            ];
        };  
        
        $sentencias_enc_bu=['alter table encu.tem drop column if exists tem_#campobu# ;'
            , 'alter table encu.tem add column tem_#campobu# integer;'
            , 'alter table encu.plana_tem_ drop column if exists pla_#campobu# ;'
            , 'alter table encu.plana_tem_ add column pla_#campobu# integer;'
            , 'drop table if exists operaciones.para_numerar_base_usuario#sufijovista#;'
            , 'create table operaciones.para_numerar_base_usuario#sufijovista# as 
                select  row_number() over (order by pla_edad, pla_e2, pla_e6, pla_e12, substr(i.pla_enc::text,4,2) desc, i.pla_enc) as serial_number#sufijovista#,
                  pla_edad, pla_e2, pla_e6, pla_e12, substr(i.pla_enc::text,4,2), 
                  i.pla_enc, i.pla_hog, i.pla_mie, pla_mie_bu
               from encu.plana_i1_ i
                 inner join encu.plana_s1_p p on p.pla_mie = i.pla_mie and p.pla_hog = i.pla_hog and   i.pla_enc = p.pla_enc
                 #otrastablasjoin#
               where pla_mie_bu =1 and i.pla_hog = 1;'
            ,'alter table operaciones.para_numerar_base_usuario#sufijovista# add primary key (pla_enc);' 
            ,'alter table operaciones.para_numerar_base_usuario#sufijovista# add unique (serial_number#sufijovista#);' 
            , ' update encu.plana_tem_ t
            set pla_#campobu# = serial_number#sufijovista# 
            from operaciones.para_numerar_base_usuario#sufijovista# x
            where t.pla_enc = x.pla_enc  '
            , ' update encu.tem t
                set tem_#campobu# = serial_number#sufijovista# 
                from operaciones.para_numerar_base_usuario#sufijovista# x
                where t.tem_enc = x.pla_enc;'   
        ];

        try{
            foreach ($reemplazos as $r_ope => $r_val) {
                foreach($sentencias_enc_bu as $sql_parcial){
                    $sql_sent=$sql_parcial;
                    foreach($r_val as $busco=> $reemp){
                        $sql_sent=str_replace($busco, $reemp, $sql_sent);
                    }    
                    if($sql_sent){
                        $cq[]=$this->db->ejecutar_sql(new Sql($sql_sent,array()));
                    }
    
                }
            }    
        }catch(Exception $e){
                $this->db->rollBack();
                return new Respuesta_Negativa($e->getMessage());
        }
        
        $this->db->commit();
        
        $this->salida->enviar('Listo la generacion de variables especiales mie_bu y enc_bu');
        $this->salida->enviar('*Luego activar todas las variables del grupo "claves bu"');
        $this->salida->enviar('*Compilar todas las variables');
        $this->salida->enviar('*Avisar a Desarrollo para que actualice el programa (actualizar_instalacion)');
        
        //return new Respuesta_Positiva($cartel);
        return $this->salida->obtener_una_respuesta_HTML();
    }       
}
?>