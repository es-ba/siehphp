<?php
//UTF-8:SÍ 
require_once "tablas.php";
class Grilla_relvis_ing extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="relvis_ing";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_relvis");
        $this->tabla->campos_lookup=array(
               "nombreformulario"=>false,
               "nombreinformante"=>false,
        ); 
        $this->tabla->tablas_lookup=array(            
              "(select formulario as ffor, nombreformulario
                 from cvp.formularios 
               ) ff"=>'ffor=formulario ',
              "(select informante as inf,nombreinformante, ordenhdr,direccion
                 from cvp.informantes 
               ) ii"=>'inf= informante ',
               
        );
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_editables($filtro_para_lectura){
        if(tiene_rol('recepcionista')||tiene_rol('analista')||tiene_rol('jefe_campo')){
          return array('verificado_rec');
        }
        return array();
        ;
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_excluir($filtro_para_lectura){
        return array('fechageneracion'      ,
                    'ultimavisita'          ,
                    'informantereemplazante',
                    'ultima_visita'         ,
        );  
    }    
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array(
            'periodo'      ,        
            'informante'   ,        
            'formulario'   ,        
            'visita'       ,        
            'panel'        ,        
            'tarea'        ,        
            'fechasalida'  ,        
            'fechaingreso' ,        
            'ingresador'   ,        
            'razon'        ,        
            'nombreformulario',       
            'nombreinformante',        
        ));
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'ver',
            'title'=>'Verificar Recepción',
            'proceso'=>'ficha_verificar_recepcion',
            'campos_parametros'=>array('tra_periodo'=>null,'tra_informante'=>null,'tra_formulario'=>null,'tra_visita'=>null),
            'y_luego'=>'ver'
        );
    }
    
}
?>