<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";
global $tipo_de_la_base;
global $tipo_de_la_base_varcal;
$tipo_de_la_base=array(
            'anio'=>'entero',
            'anios'=>'entero',
            'edad'=>'entero',
            'horas'=>'entero',
            'info_numero'=>'entero', // creo que hay que sacarlo cuando se saque ex_miembro
            'marcar'=>'entero',
            'marcar_nulidad'=>'entero',
            'mes'=>'entero',
            'meses'=>'entero',
            'monetaria'=>'entero',
            'multiple_marcar'=>'entero',
            'numeros'=>'entero',
            'observaciones'=>'texto',
            'fecha'=>'texto',
            'fecha_corta'=>'texto',
            'telefono'=>'texto',
            'texto'=>'texto',
            'texto_especificar'=>'texto',
            'texto_libre'=>'texto',
            'multiple_nsnc'=>'entero',
            'opciones'=>'entero',
            'si_no'=>'entero',
            'solo12no_tiene'=>'entero',
            'si_no_nosabe3'=>'entero',
            'timestamp'=>'timestamp',
        );
$tipo_de_la_base_varcal=array(
            'decimal'=>'decimal',
            'entero'=>'entero',
            'texto'=>'texto',
        );               
global $que_teclado_mostrar;
$que_teclado_mostrar=$tipo_de_la_base;
$que_teclado_mostrar['telefono']='entero';
$que_teclado_mostrar['fecha_corta']='entero';
$que_teclado_mostrar['fecha']='entero';
        
class Tabla_planas extends Tabla{
    //PENDIENTE:ESTA!
    function definicion_estructura(){
        $this->nombre_esquema=$GLOBALS['esquema_principal'];
        $this->definir_prefijo('pla');
        $this->leer_estructura_del_json();
    }
    static function crear_jsones($contexto,$tra_for,$tra_mat){
        global $tipo_de_la_base; 
        global $tipo_de_la_base_varcal;
        $nombre_archivo="Tabla_plana_{$tra_for}_{$tra_mat}.estructura.json";
        $tabla_variables=$contexto->nuevo_objeto('Tabla_variables');
        $tabla_variables->definir_orden_por_otra('blo');
        $tabla_variables->leer_varios(array('var_ope'=>$GLOBALS['NOMBRE_APP'],'var_for'=>$tra_for,'var_mat'=>$tra_mat));
        $estructura=(object)array('definir_campo'=>array());
        foreach(nombres_campos_claves('pla_','N') as $campo){
            $definicion_campo_pk=array('es_pk'=>true,'tipo'=>'entero');
            if($tra_for=='TEM' && $tra_mat==''){
                $definicion_campo_pk['def']=0;
            }
            $estructura->definir_campo[$campo]=$definicion_campo_pk;
        }
        if($tra_for=='TEM' && $tra_mat==''){
            $nombre_clase='tem__'.$GLOBALS['nombre_app'];
            $clase='tabla_'.$nombre_clase;
            if(!class_exists($clase)){
                $nombre_clase='tem';
            }
            $tabla_tem=$tabla_variables->definicion_tabla($nombre_clase);
            foreach($tabla_tem->definiciones_campo_originales as $campo=>$definicion){
                if(!@$definicion['es_pk']){
                    $estructura->definir_campo[cambiar_prefijo($campo,'tem_','pla_')]=$definicion;
                }
            }
        }
        while($tabla_variables->obtener_leido()){
            if($tabla_variables->datos->var_conopc){
                $tipo='entero';
            }else{
                if(!isset($tipo_de_la_base[$tabla_variables->datos->var_tipovar])){
                    throw new Exception_Tedede("No se encuentra el tipo del tipo ".$tabla_variables->datos->var_tipovar);
                }
                $tipo=$tipo_de_la_base[$tabla_variables->datos->var_tipovar];
            }
            $estructura->definir_campo[strtolower('pla_'.$tabla_variables->datos->var_var)]=array('tipo'=>$tipo);
        }
        foreach(array('mie'=>array('for'=>'I1', 'mat'=>''), 'hog'=>array('for'=>'S1', 'mat'=>''),
            'gh'=>array('for'=>'GH', 'mat'=>''),  'a1'=>array('for'=>'A1', 'mat'=>''), 'exm'=>array('for'=>'A1', 'mat'=>'X'),
            'sup'=>array('for'=>'SUP', 'mat'=>''),'per'=>array('for'=>'S1', 'mat'=>'P')) as $cual_destino=>$cual_formumatriz){
            if($tra_for==$cual_formumatriz['for'] && $tra_mat==$cual_formumatriz['mat']){
                $tabla_varcal=$contexto->nuevo_objeto('Tabla_varcal');
                $tabla_varcal->definir_orden_por_otra('varcal_orden');
                $tabla_varcal->leer_varios(array('varcal_ope'=>$GLOBALS['NOMBRE_APP'],'varcal_destino'=>$cual_destino,'varcal_activa'=>'true','varcal_valida'=>'true'));
                while($tabla_varcal->obtener_leido()){
                    if($tabla_varcal->datos->varcal_tipo=='normal'){
                        $tabla_varcalopc=$contexto->nuevo_objeto('Tabla_varcalopc');
                        $cuantas_opciones=$tabla_varcalopc->contar_cuantos(array('varcalopc_ope'=>$GLOBALS['NOMBRE_APP'],'varcalopc_varcal'=>$tabla_varcal->datos->varcal_varcal));
                    }
                    if(($tabla_varcal->datos->varcal_tipo=='normal' && $cuantas_opciones>0) || ( $tabla_varcal->datos->varcal_tipo=='externo' && !( substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015 && $tra_for=='S1')) || $tabla_varcal->datos->varcal_tipo=='especial'){
                        if(!isset($tipo_de_la_base_varcal[$tabla_varcal->datos->varcal_tipodedato])){
                            throw new Exception_Tedede("No se encuentra el tipo del tipo ".$tabla_varcal->datos->varcal_tipodedato);
                        }
                        $tipo=$tipo_de_la_base_varcal[$tabla_varcal->datos->varcal_tipodedato];                       
                        $estructura->definir_campo['pla_'.$tabla_varcal->datos->varcal_varcal]=array('tipo'=>$tipo);
                    }
                }
            }
        }
        file_put_contents($nombre_archivo,json_encode($estructura));
    }
    function armar_clave_para($prefijo, $tra_ope, $tra_for, $tra_mat){
        $rta=claves_respuesta_vacia($prefijo);
        $rta[$prefijo."ope"]=$tra_ope;
        $rta[$prefijo."for"]=$tra_for;
        $rta[$prefijo."mat"]=$tra_mat;
        foreach($rta as $clave=>$tipo){
            if($tipo=='N'){
                $rta[$clave]=$this->datos->{cambiar_prefijo($clave,$prefijo,'pla_')};
            }
        }
        return $rta;
    }
}



?>