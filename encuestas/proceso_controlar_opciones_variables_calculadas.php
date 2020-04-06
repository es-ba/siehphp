<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_controlar_opciones_variables_calculadas extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Controlar opciones de variables calculadas',
            'permisos'=>array('grupo1'=>'procesamiento','grupo2'=>'coor_campo'),
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_varcal'=>array('tipo'=>'texto','label'=>'Variable calculada','def'=>'#todo'),
            ),
//            'bitacora'=>true,
            'boton'=>array('id'=>'boton_controlar','value'=>'Controlar'),
        ));
    }
    function responder(){
        if($this->argumentos->tra_ope!=$GLOBALS['NOMBRE_APP']){
            return new Respuesta_Negativa("El operativo ".$GLOBALS['NOMBRE_APP']." no corresponde, no es el actual");
        }    
        $para_filtro_para_varcal=array(
                'varcal_ope'=>$GLOBALS['NOMBRE_APP'],
                'varcal_varcal'=>$this->argumentos->tra_varcal,
                'varcal_activa'=>true,
                'varcal_valida'=>true,
                'varcal_tipo'=>'normal',
            );
        $this->filtro=$this->nuevo_objeto("Filtro_Normal",$para_filtro_para_varcal);
        $this->salida=new Armador_de_salida(true); 
        $total_ok=0;
        $total_incorrectas=0;
        $expresion_sql = <<<SQL
            select varcal_varcal, varcal_destino, varcal_opciones_excluyentes, varcal_filtro, encu.evaluar_varcal_opciones_excluyentes(varcal_varcal,varcal_destino, varcal_opciones_excluyentes, varcal_filtro)      
                from encu.varcal
                where {$this->filtro->where}  
                order by varcal_destino, varcal_orden, varcal_varcal
SQL;
        Loguear('2017-03-30','********************* expre: '.$expresion_sql);
        try{
            $cursor_control = $this->db->ejecutar_sql(new Sql($expresion_sql,
                    $this->filtro->parametros));
            //Loguear('2014-11-04','*********** param: '.json_encode($this->filtro->parametros));
            $total_ok=0;
            $total_incorrectas=0;
            $this->salida->abrir_grupo_interno('editor_tabla',array('tipo'=>'table','border'=>'single', 'style'=>'bold'));
            $this->salida->abrir_grupo_interno('tabla_titulos',array('tipo'=>'tr'));
                $this->salida->enviar('VarCal','celda_comun desp_encabezado',array('tipo'=>'td'));
                $this->salida->enviar('Destino','celda_comun desp_encabezado',array('tipo'=>'td'));
                $this->salida->enviar('Opciones excl','celda_comun desp_encabezado',array('tipo'=>'td'));
                $this->salida->enviar('Filtro','celda_comun desp_encabezado',array('tipo'=>'td'));
                $this->salida->enviar('Total casos erroneos','celda_comun desp_encabezado',array('tipo'=>'td'));
                $this->salida->enviar('Caso clasificacion multiple','celda_comun desp_encabezado',array('tipo'=>'td'));
                $this->salida->enviar('Caso no clasificado','celda_comun desp_encabezado',array('tipo'=>'td'));
                $this->salida->enviar('Otros','celda_comun desp_encabezado',array('tipo'=>'td'));
                
            $this->salida->cerrar_grupo_interno();    
            while($fila=$cursor_control->fetchObject()){
                //Loguear('2014-11-04','*********** fila: '.json_encode($fila));
                if($fila->evaluar_varcal_opciones_excluyentes=='OK'){
                    $total_ok=$total_ok+1;
                }else{
                    $total_incorrectas=$total_incorrectas+1;
                }
                $this->salida->abrir_grupo_interno('tr_varcal_opciones',array('tipo'=>'tr'));
                    $this->salida->enviar($fila->varcal_varcal,'celda_comun',array('tipo'=>'td'));
                    $this->salida->enviar($fila->varcal_destino,'celda_comun',array('tipo'=>'td'));
                    $this->salida->enviar(($fila->varcal_opciones_excluyentes)?'Si':'No','celda_comun',array('tipo'=>'td','style'=>'width:55px'));
                    $this->salida->enviar($fila->varcal_filtro,'celda_comun',array('tipo'=>'td'));
                    $salida_var=array();
                    $resultado=$fila->evaluar_varcal_opciones_excluyentes;
                    $res_casos='0';
                    $res_nocla='';
                    $res_noexc='';
                    $res_otro='';
                    if ($resultado!='OK'){
                        $salida_var=explode('|',$resultado);
                        $res_casos=$salida_var[0];
                        if (isset($salida_var[1] )){
                            if(strpos($salida_var[1],'NoEx')!==false ){
                                $res_noexc=$salida_var[1];
                            }elseif(strpos($salida_var[1],'NoCl')!==false){
                                $res_nocla=$salida_var[1]; 
                            }else{
                                $res_otro=$salida_var[1]; 
                          }
                        }
                        if (isset($salida_var[2] )){
                            $res_nocla=$salida_var[2];
                        }
                    }
                    $this->salida->enviar($res_casos,'celda_comun',array('tipo'=>'td','style'=>'width:70px;text-align:right'));
                    $this->salida->enviar(str_replace('NoEx:','',$res_noexc),'celda_comun',array('tipo'=>'td'));    
                    $this->salida->enviar(str_replace('NoCl:','',$res_nocla),'celda_comun',array('tipo'=>'td'));    
                    $this->salida->enviar(str_replace('otro:','',$res_otro),'celda_comun',array('tipo'=>'td'));    
                $this->salida->cerrar_grupo_interno();    
                //$this->salida->enviar(json_encode($fila));
            }
            $this->salida->cerrar_grupo_interno();    
            if ($this->argumentos->tra_varcal=='#todo'){             
                $this->salida->enviar('Total de Variables con Opciones OK:'.$total_ok);
                $this->salida->enviar('Total de Variables con Opciones Incorrectas:'.$total_incorrectas);
            }
        }catch(Exception $e){
            return new Respuesta_Negativa($e->getMessage());
        }
    return $this->salida->obtener_una_respuesta_HTML();       
    }
}
?>