<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_copiar_encuesta extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Copiar encuesta',
            'permisos'=>array('grupo1'=>'procesamiento','grupo2'=>'coor_campo'),
            'submenu'=>'consistencias',
            'para_produccion'=>!$GLOBALS['esta_es_la_base_en_produccion'],
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('tipo'=>'entero','label'=>'Número de encuesta','def'=>130001),
                'tra_enc2'=>array('tipo'=>'entero','label'=>'Nuevo número de encuesta','def'=>139999),
            ),
//            'bitacora'=>true,
            'boton'=>array('id'=>'boton_copiar_encuesta','value'=>'copiar encuesta'),
        ));
    }
    function responder(){
    
        if($this->argumentos->tra_ope!=$GLOBALS['NOMBRE_APP']){
            return new Respuesta_Negativa("El operativo ".$GLOBALS['NOMBRE_APP']." no es el actual");
        }
        $tabla_plana_tem=$this->nuevo_objeto("Tabla_plana_TEM_");
        $filtro_planas=array('pla_enc'=>$this->argumentos->tra_enc,
                             'pla_hog'=>0,
                             'pla_mie'=>0,
                             'pla_exm'=>0,);
        $tabla_plana_tem->leer_uno_si_hay($filtro_planas);
        if(!$tabla_plana_tem->obtener_leido()){
            return new Respuesta_Negativa("La encuesta ".$this->argumentos->tra_enc." no existe");
        }
        $filtro=array('pla_enc'=>$this->argumentos->tra_enc2,
                      'pla_hog'=>0,
                      'pla_mie'=>0,
                      'pla_exm'=>0,
        );
        $tabla_plana_tem->leer_uno_si_hay($filtro);
        if($tabla_plana_tem->obtener_leido()){
            return new Respuesta_Negativa("La encuesta ".$this->argumentos->tra_enc2." ya existe");
        }
        $tabla_tem=$this->nuevo_objeto('Tabla_tem');
        // copio en tem
        $tabla_tem->leer_unico(array('tem_enc'=>$this->argumentos->tra_enc));
        $tabla_tem->datos=(array)$tabla_tem->datos;
        foreach($tabla_tem->campos as $campo=>$definicion){
            $tabla_tem->valores_para_insert[$campo]=$tabla_tem->datos[$campo];        
        }
        $tabla_tem->valores_para_insert['tem_enc']=$this->argumentos->tra_enc2;
        $this->db->beginTransaction();
        try{
            $tabla_tem->ejecutar_insercion();
            // copio en claves
            $tabla_claves=$this->nuevo_objeto('Tabla_claves');            
            $filtro_claves=array(
                'cla_ope'=>$this->argumentos->tra_ope,
                'cla_enc'=>$this->argumentos->tra_enc,
            );
            $tabla_claves->leer_varios($filtro_claves);
            while($tabla_claves->obtener_leido()){
                $tabla_claves->datos=(array)$tabla_claves->datos;
                foreach($tabla_claves->campos as $campo=>$definicion){
                    $tabla_claves->valores_para_insert[$campo]=$tabla_claves->datos[$campo];
                }
                $tabla_claves->valores_para_insert['cla_enc']=$this->argumentos->tra_enc2;            
                $tabla_claves->ejecutar_insercion();            
            }
            // actualizo respuestas primero cambio estado para que sea editable
            $this->db->ejecutar_sql(new Sql('alter table encu.respuestas disable trigger respuestas_control_editable_trg'));
            $tabla_respuestas=$this->nuevo_objeto('Tabla_respuestas');
            $filtro_nueva=array('res_ope'=>$this->argumentos->tra_ope);
            $tabla_respuestas->leer_varios(array('res_ope'=>$this->argumentos->tra_ope,
                                                 'res_enc'=>$this->argumentos->tra_enc));
            while($tabla_respuestas->obtener_leido()){ 
                $tabla_respuestas->datos=(array)$tabla_respuestas->datos;
                $tabla_respuestas->valores_para_update=array(
                                                            'res_valor'=>$tabla_respuestas->datos['res_valor'],
                                                            'res_valesp'=>$tabla_respuestas->datos['res_valesp'],
                                                            'res_valor_con_error'=>$tabla_respuestas->datos['res_valor_con_error'],
                                                            'res_estado'=>$tabla_respuestas->datos['res_estado'],
                                                            'res_anotaciones_marginales'=>$tabla_respuestas->datos['res_anotaciones_marginales'],
                                                            'res_tlg'=>$tabla_respuestas->datos['res_tlg'],
                );
                $filtro_nueva['res_var']=$tabla_respuestas->datos['res_var'];
                $filtro_nueva['res_for']=$tabla_respuestas->datos['res_for'];
                $filtro_nueva['res_mat']=$tabla_respuestas->datos['res_mat'];
                $filtro_nueva['res_enc']=$this->argumentos->tra_enc2;
                $filtro_nueva['res_hog']=$tabla_respuestas->datos['res_hog'];
                $filtro_nueva['res_mie']=$tabla_respuestas->datos['res_mie'];
                $filtro_nueva['res_exm']=$tabla_respuestas->datos['res_exm'];
                $tabla_respuestas->ejecutar_update_unico($filtro_nueva); 
            }
            $this->db->ejecutar_sql(new Sql('alter table encu.respuestas enable trigger respuestas_control_editable_trg'));
            $this->db->commit();
        }catch(Exception $err){
            $this->db->rollBack();
            throw $err;
        }            
        return new Respuesta_Positiva("Encuesta copiada");
    }
}
?>