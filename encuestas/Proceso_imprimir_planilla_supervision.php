<?php
//UTF-8:SÍ

//recorre tem
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_imprimir_planilla_supervision extends Proceso_Formulario{
    function los_csss(){
        return array('planilla_supervision.css');
    }
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->tabla_personal=$this->nuevo_objeto("Tabla_personal");
        
        $tabla_personal=$this->tabla_personal;        
        $this->definir_parametros(array(
            'titulo'=>'Imprimir planilla de supervision',
            'submenu'=>'campo',
            'permisos'=>array('grupo'=>'subcoor_campo'),
            'para_produccion'=>true,            
            'parametros'=>array(
                'tra_cod_per' =>array('tipo'=>'entero','label'=>'Supervisor','opciones'=>$tabla_personal->lista_opciones(array('per_ope'=>$GLOBALS['NOMBRE_APP'], 'per_rol'=>'#=supervisor|=recepcionista', 'per_activo'=>'true'))),  
                'tra_fecha_carga' => array('type'=>'date'),
            ),
            'boton'=>array('id'=>'imprimir'),
        ));
    }
    function imprimir(){
        global $hoy;
        if(!$this->argumentos->tra_cod_per){
            return new Respuesta_Negativa('Debe especificar supervisor');
        }
        $this->inforol=new Info_Rol_Sup_Campo();
        $titulo_planilla="PLANILLA DE SUPERVISIÓN";
        $tabla_personal=$this->tabla_personal;
        $tabla_personal->leer_unico(array(
            'per_ope'=>$GLOBALS['NOMBRE_APP'],
            'per_per'=>$this->argumentos->tra_cod_per,
        ));
        $per=$tabla_personal->datos;   
        if ($this->argumentos->tra_fecha_carga==null){
            $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
                  SELECT max(pla_fecha_primcarga_sup) as ultimo
                  FROM encu.plana_tem_  
                  WHERE pla_cod_sup={$this->argumentos->tra_cod_per};
SQL
            ));
            $fila=$cursor->fetchObject();
            $verificado_sup=null;
            $fecha_prim_carga=$fila->ultimo;
        } else {
            $fecha_prim_carga=$this->argumentos->tra_fecha_carga;
            $verificado_sup='#!null';
        }
        $tabla_tem=$this->nuevo_objeto('Tabla_plana_TEM_');
        $filtro_para_tem=new Filtro_OR(array(
                array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>42,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>43,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>44,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>45,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>52,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>53,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>54,              
                ),array(
                    'pla_per'=>$this->argumentos->tra_cod_per,
                    'pla_estado'=>55,              
                )
        )); 
        if ($verificado_sup==null){
            $filtro_para_tem_especifico=array(
                "pla_cod_sup"=>$this->argumentos->tra_cod_per,
                "pla_fecha_primcarga_sup"=>'#fecha '.$fecha_prim_carga,
                "pla_verificado_sup"=>$verificado_sup,
            );
        } else {
            $filtro_para_tem_especifico=array(
                "pla_cod_sup"=>$this->argumentos->tra_cod_per,
                "pla_fecha_primcarga_sup"=>'#fecha '.$fecha_prim_carga,         
            );        
        }        
        $filtro_para_tem = new Filtro_AND(array($filtro_para_tem,$filtro_para_tem_especifico));
        $tabla_tem->leer_varios($filtro_para_tem);                
        while($tabla_tem->obtener_leido()){
            $tabla_S1_p=$this->nuevo_objeto('Tabla_plana_S1_p');
            $tem=$tabla_tem->datos;            
            if ($tem->pla_sup_dirigida> 0){
                $dirigida_aleatoria=1;
                $presencial_telefonica=$tem->pla_sup_dirigida;
            } elseif ($tem->pla_sup_aleat > 0) {
                $dirigida_aleatoria=2;
                $presencial_telefonica=$tem->pla_sup_aleat;
            } else {
                $dirigida_aleatoria=3;
                $presencial_telefonica='';
            }
            $tabla_S1=$this->nuevo_objeto('Tabla_plana_S1_');
            $tabla_S1->leer_varios(array(
                'pla_enc'=>$tem->pla_enc,
            ));
            $cod_enc_o_recu=$tem->pla_cod_enc.($tem->pla_cod_recu?'/'.$tem->pla_cod_recu:'');
            $rea_enc_o_recu=$tem->pla_rea;
            $cod_sup=$tem->pla_cod_sup;
            $fecha_carga_sup=$tem->pla_fecha_carga_sup;
            $tabla_anoenc=$this->nuevo_objeto('Tabla_anoenc');
            $tabla_anoenc->leer_varios(array(
                'anoenc_ope'=>$GLOBALS['NOMBRE_APP'],
                'anoenc_enc'=>$tem->pla_enc,
            ));
            $datos_visitas='';
            while($tabla_anoenc->obtener_leido()){                
                $visita=$tabla_anoenc->datos;
                if($visita->anoenc_fecha){
                    $datos_visitas=$datos_visitas.'<b>'.$visita->anoenc_anoenc.') </b>'.$visita->anoenc_fecha.'  '.$visita->anoenc_hora.' - '.$visita->anoenc_anotacion.'    ';
                }
            }                
            while($tabla_S1->obtener_leido()){
                $S1=$tabla_S1->datos;
                $tabla_S1_p->leer_uno_si_hay(array(
                    'pla_enc'=>$S1->pla_enc,
                    'pla_mie'=>$S1->pla_respond,
                ));
                $tabla_S1_p->obtener_leido();
                $S1_p=$tabla_S1_p->datos?:(object)array('pla_nombre'=>'-','pla_edad'=>'-');
                $nombre_respond=$S1->pla_nombrer ?: $S1_p->pla_nombre;
                $r1=$S1->pla_razon1;
                if (isset($S1->{"pla_razon2_{$r1}"})){
                    $r2=$S1->{"pla_razon2_{$r1}"};
                    $norea=$r1.$r2;
                }else{
                    $norea="";
                }
                $visita_telefonos='';
                if ($S1->pla_telefono){
                    $visita_telefonos=$visita_telefonos.' <b>Tel: </b>'.$S1->pla_telefono;
                }
                if ($S1->pla_movil){
                    $visita_telefonos=$visita_telefonos.'<b> Movil: </b>'.$S1->pla_movil;
                }
                $datos_visitas=$datos_visitas.' '.$visita_telefonos.'  ';
                include "planilla_supervision.html";
                
                //$rol_texto.=' '.$this->argumentos->tra_cod_per;
                $this->argumentos->tra_ope=$GLOBALS['NOMBRE_APP'];//OJO: Generalizar
                $this->salida->sacar_html_directo($html);
                $str=<<<JS
                    var cssPagedMedia = (function () {
                        var style = document.createElement('style');
                        document.head.appendChild(style);
                        return function (rule) {
                            style.innerHTML = rule;
                        };
                    }());
                cssPagedMedia.size = function (size) {
                    cssPagedMedia('@page {size: ' + size + '}');
                };
                cssPagedMedia.size('landscape');
                document.body.style.backgroundColor='';
                window.print();                
JS;
                $this->salida->enviar_script($str); 
            }
        }        
    }
}
?>