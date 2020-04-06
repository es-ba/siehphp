<?php
//UTF-8:SÍ 
require_once "lo_imprescindible.php";
// require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_usuarios extends Grilla_tabla{
    function responder_grabar_campo(){
        $rta=parent::responder_grabar_campo();
        if($rta instanceof Respuesta_Positiva && $this->argumentos->campo=='usu_blanquear_clave' && $this->argumentos->nuevo_valor){
            $clave=clave_aleatoria();
            $this->tabla->valores_para_update=array(
                'usu_clave'=>md5($clave.strtolower(trim($this->filtro_solo_pk['usu_usu'])))
            );
            $this->tabla->ejecutar_update_unico($this->filtro_solo_pk);
            $rta->respuestas['mensaje']['atributos_fila'][$this->tabla->id_registro()]['usu_blanquear_clave']=array(
                'title'=>"Nueva clave: $clave",
                'clase'=>'clave_blanqueada'
            );
        }
        return $rta;
    }
}
?>