<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_tabulados extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('tab');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('tab_tab', array('es_pk'=>true, 'tipo' => 'texto' , 'largo'=>30));
        $this->definir_campo('tab_titulo', array('tipo' => 'texto' , 'largo'=>1000, 'mostrar_al_elegir'=>true));
        $this->definir_campo('tab_fila1', array('tipo' => 'texto', 'largo'=>50 ));
        $this->definir_campo('tab_fila2', array('tipo' => 'texto', 'largo'=>50 ));
        $this->definir_campo('tab_columna', array('tipo' => 'texto', 'largo'=>50 ));
        $this->definir_campo('tab_cel_exp', array('tipo' => 'texto', 'largo'=>100 ));
        $this->definir_campo('tab_cel_tipo', array('tipo' => 'texto', 'largo'=>30 ));
        $this->definir_campo('tab_filtro', array('tipo' => 'texto' ));
        $this->definir_campo('tab_notas', array('tipo' => 'texto' ));
        $this->definir_campo('tab_observaciones', array('tipo' => 'texto' ));
        $this->definir_campo('tab_decimales', array('tipo' => 'entero' ));
        $this->definir_campo('tab_cerrado', array('tipo' => 'logico', 'def'=>false ));
        $this->definir_campo('tab_grupo', array('tipo' => 'texto', 'largo'=>200 ));
        $this->definir_campos_orden(array('para_ordenar_numeros(tab_tab)'));
    }    
}
class Grilla_tabulados extends Grilla_tabla{
    function puede_insertar(){
        return tiene_rol('procesamiento');
    }
    function puede_eliminar(){
        return tiene_rol('procesamiento');
    }
}
?>