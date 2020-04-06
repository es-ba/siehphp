<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_impresion_etiquetas extends Proceso_Formulario{
    function los_csss(){
        return array('../encuestas/etiquetas.css');
    }
    function ignorar_csss_de_la_aplicacion_en_modo($modo_hacer){
        return $modo_hacer=='imprimir';
    }
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Impresión de etiquetas',
            'submenu'=>'coordinación de campo',
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'coor_campo','grupo2'=>'procesamiento'),
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_dominio'=>array('label'=>'dominio','def'=>'3','aclaracion'=>'indique #todo para todos los dominios'),
                'tra_replica'=>array('label'=>'semana','def'=>'#todo','aclaracion'=>'indique #>=3&<=6 para las semanas numeradas del 3 al 6'),
                'tra_comuna'=>array('label'=>'comuna','def'=>'#todo','aclaracion'=>'para excluir una use por ejemplo #!=14'),
                'tra_up'=>array('label'=>'UP','def'=>'#todo','aclaracion'=>'para rango use por ejemplo #>=100&<=139'),
                'tra_area'=>array('label'=>'area','def'=>'#todo','aclaracion'=>'para exlcuir una use por ejemplo #!=1004'),
                'tra_rotaci_n_etoi'=>array('label'=>'Rotación ETOI','def'=>'#todo','aclaracion'=>'para dos casos use por ejemplo #=1|=2'),
                'tra_rotaci_n_eah'=>array('label'=>'Rotación EAH','def'=>'#todo'),
                'tra_participacion'=>array('label'=>'Participación','def'=>'#todo'),
                'tra_estado'=>array('label'=>'estado','def'=>'#todo','aclaracion'=>'indique 79 para REA'),
                'tra_etiquetas'=>array('label'=>'Marca etiqueta','def'=>'#todo','aclaracion'=>'si pone 1 solo se imprimirán las etiquetas marcadas con 1'),
                'tra_solo_con_codpos'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Imprimir solo las etiquetas que tengan código postal'),
                'tra_repeticiones'=>array('label'=>'repeticiones','def'=>'1'),
            ),
            'bitacora'=>true,
            'botones'=>array(
                array('id'=>'contar'),
                array('id'=>'imprimir')
            )
        ));
    }
    function preparar_filtro(){
        $campos_filtro=cambiar_prefijo($this->argumentos,'tra_','pla_');
        $this->solo_con_codpos=$this->argumentos->tra_solo_con_codpos;
        unset($campos_filtro->pla_ope);
        unset($campos_filtro->pla_solo_con_codpos);
        unset($campos_filtro->pla_repeticiones);
        // $campos_filtro->pla_etiquetas='1';
        if($this->solo_con_codpos){
            $campos_filtro->pla_codpos='#!vacio';
        }
        $this->filtro=$this->nuevo_objeto("Filtro_Normal",$campos_filtro);
    }
    function responder(){
        $this->preparar_filtro();
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
select count(*) as totales, count(nullif(trim(pla_codpos),'')) as con_codpos
  from plana_tem_ x
  where {$this->filtro->where}  
SQL
        ,$this->filtro->parametros));
        $fila=$cursor->fetchObject();
        $respuesta=$this->solo_con_codpos?"Cantidad de registros a imprimir CON CÓDIGO POSTAL {$fila->totales}":"Cantidad de registros a imprimir totales {$fila->totales} (solo tienen código postal {$fila->con_codpos} registros).";
        return new Respuesta_Positiva($respuesta);
    }
    function imprimir(){
        $this->preparar_filtro();
        if($this->argumentos->tra_ope=='enapross'){
            $videntificacion='pla_cod_muestra';
        }else{
            $videntificacion='pla_enc';
        }
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
select coalesce(pla_cnombre||' ','')
     ||coalesce(pla_hn||' ','')
     ||coalesce('piso: '||nullif(pla_hp,'0')||' ','')
     ||coalesce('dto: '||nullif(pla_hd,'0')||' ','')
     ||coalesce('hab: '||nullif(pla_hab,'0')||' ','') as domicilio, 
     pla_ident_edif,
     'P'||pla_participacion as participacion_ref,
     case when dbo.ope_actual()='enapross' then  pla_comuna||' '||$videntificacion 
          else pla_semana||' '||pla_comuna||' '||$videntificacion
     end as referencia,*
  from plana_tem_ x
  where {$this->filtro->where} 
  order by pla_semana,pla_codpos,pla_comuna, pla_cnombre, comun.para_ordenar_numeros(pla_hn),comun.para_ordenar_numeros(pla_hp), comun.para_ordenar_numeros(pla_hd)   
SQL
        ,$this->filtro->parametros));
        $filas_por_pagina=7;
        $pagina=0;
        $filapag=0;
        $etiquetas_por_fila=2;
        $columna=0;
        while($fila=$cursor->fetchObject()){
            for($repeticion=0; $repeticion<$this->argumentos->tra_repeticiones; $repeticion++){

                if($columna==0){
                    if($filapag==0){
                        if($pagina){
                            $this->salida->enviar(' ','div_salta_pagina');
                        }
                        $pagina++;
                        $this->salida->abrir_grupo_interno('etiqueta_table',array('tipo'=>'table'));
                        
                    }
                    $this->salida->abrir_grupo_interno('etiqueta_tr',array('tipo'=>'tr'));
                }
                if ($filapag==0 && $columna==0){
                        // etiqueta de control
                        $this->salida->abrir_grupo_interno('etiqueta_td',array('tipo'=>'td'));
                            $operativo_fecha=strtoupper($this->argumentos->tra_ope). '   '. date("d-m-Y H:i:s");
                            $pagina_impre= 'Pagina '. $pagina ;
                            $solo_codpos_impre= $this->solo_con_codpos?'S':'N';
                            $param1='Dom:'.$this->argumentos->tra_dominio 
                                    .' Rep:'.$this->argumentos->tra_replica
                                    .' Com:'.$this->argumentos->tra_comuna 
                                    .' Up:' .$this->argumentos->tra_up
                                    .' Area:' .$this->argumentos->tra_area
                                    .' Estado:' .$this->argumentos->tra_estado
                                    .' R:' .$this->argumentos->tra_rotaci_n_etoi.','.$this->argumentos->tra_rotaci_n_eah;
                            $param2='s_CP:'. $solo_codpos_impre . ' rep:'. $this->argumentos->tra_repeticiones;
                            $this->salida->enviar($operativo_fecha,'etiqueta_ope_fecha');
                            $this->salida->enviar($param1,'etiqueta_param1');
                            $this->salida->enviar($param2,'etiqueta_param2');
                            $this->salida->enviar($pagina_impre,'etiqueta_pagina', array('tipo'=>'span'));
                        $this->salida->cerrar_grupo_interno();
                        $columna++;
                }
                if($columna<=$etiquetas_por_fila-1 and $columna>0){
                    $this->salida->abrir_grupo_interno('etiqueta_td_sepa_v',array('tipo'=>'td'));
                        $this->salida->enviar(' ','div_sepa_v');
                    $this->salida->cerrar_grupo_interno();
                }
                $this->salida->abrir_grupo_interno('etiqueta_td',array('tipo'=>'td'));
                    $this->salida->enviar('Sr./Sra.','etiqueta_nombre');
                    $this->salida->enviar($fila->domicilio,'etiqueta_domicilio');
                    if(!!$fila->pla_ident_edif){
                        $this->salida->enviar('Edif:'.$fila->pla_ident_edif,'etiqueta_domicilio');
                    }    
                    $this->salida->enviar($fila->pla_codpos,'etiqueta_codpos');
                    $this->salida->enviar('Ciudad Autónoma de Buenos Aires','etiqueta_localidad',array('tipo'=>'span'));
                    $this->salida->abrir_grupo_interno('etiqueta_ultima_linea');
                        $this->salida->enviar('GCBA-DGEyC','etiqueta_organismo',array('tipo'=>'span'));
                        $this->salida->enviar($fila->participacion_ref,'etiqueta_participacion_ref',array('tipo'=>'span'));
                        $this->salida->enviar($fila->referencia,'etiqueta_referencia',array('tipo'=>'span'));
                    $this->salida->cerrar_grupo_interno();
                $this->salida->cerrar_grupo_interno();
                $columna++;
                if($columna==$etiquetas_por_fila){
                    $this->salida->cerrar_grupo_interno();
                    $filapag++;
                    if ($filapag==$filas_por_pagina){
                        $this->salida->cerrar_grupo_interno();
                        $filapag=0;  
                    }else{
                        $this->salida->abrir_grupo_interno('etiqueta_tr_sepa_h',array('tipo'=>'tr'));
                            $this->salida->abrir_grupo_interno('etiqueta_td_sepa_h',array('tipo'=>'td'));
                                $this->salida->enviar(' ','div_sepa_h');
                            $this->salida->cerrar_grupo_interno();
                        $this->salida->cerrar_grupo_interno();
                    }
                    $columna=0;
                }
            }
        }
        if($columna!=0){
            // cerrar fila
            $this->salida->cerrar_grupo_interno();
        }
        if($filapag!=0){
            $this->salida->cerrar_grupo_interno();
        }
    }
}


?>