<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class Vista_calgru_vw extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'              ,array('tipo'=>'texto'  ,  'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('calculo'              ,array('tipo'=>'entero' , 'es_pk'=>true, 'origen'=>'calculo'));
        $this->definir_campo('agrupacion'           ,array('tipo'=>'texto' , 'es_pk'=>true, 'origen'=>'agrupacion' ));
        $this->definir_campo('grupo'                ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'grupo'));
        $this->definir_campo('nombre'               ,array('tipo'=>'texto', 'origen'=>'nombre'));
        $this->definir_campo('variacion'            ,array('tipo'=>'decimal', 'origen'=>'variacion'));
        $this->definir_campo('impgru'               ,array('tipo'=>'texto', 'origen'=>'impgru'));
        $this->definir_campo('grupopadre'           ,array('tipo'=>'texto', 'origen'=>'grupopadre'));
        $this->definir_campo('nivel'                ,array('tipo'=>'entero', 'origen'=>'nivel'));
        $this->definir_campo('esproducto'           ,array('tipo'=>'texto', 'origen'=>'esproducto'));
        $this->definir_campo('ponderador'           ,array('tipo'=>'decimal', 'origen'=>'ponderador'));
        $this->definir_campo('indice'               ,array('tipo'=>'decimal', 'origen'=>'indice'));
        $this->definir_campo('indiceprel'           ,array('tipo'=>'decimal', 'origen'=>'indiceprel'));
        $this->definir_campo('incidencia'           ,array('tipo'=>'decimal', 'origen'=>'incidencia'));
        $this->definir_campo('indiceredondeado'     ,array('tipo'=>'decimal', 'origen'=>'indiceredondeado'));
        $this->definir_campo('incidenciaredondeada' ,array('tipo'=>'decimal', 'origen'=>'incidenciaredondeada'));
        $this->definir_campo('incidenciainteranual' ,array('tipo'=>'decimal', 'origen'=>'incidenciainteranual'));
        $this->definir_campo('incidenciainteranualredondeada'    ,array('tipo'=>'decimal', 'origen'=>'incidenciainteranualredondeada'));
        $this->definir_campo('incidenciaacumuladaanual'          ,array('tipo'=>'decimal', 'origen'=>'incidenciaacumuladaanual'));
        $this->definir_campo('incidenciaacumuladaanualredondeada',array('tipo'=>'decimal', 'origen'=>'incidenciaacumuladaanualredondeada'));
        $this->definir_campo('variacioninteranual'               ,array('tipo'=>'decimal', 'origen'=>'variacioninteranual'));
        $this->definir_campo('variacioninteranualredondeada'     ,array('tipo'=>'decimal', 'origen'=>'variacioninteranualredondeada'));
        $this->definir_campo('variaciontrimestral'               ,array('tipo'=>'decimal', 'origen'=>'variaciontrimestral'));
        $this->definir_campo('variacionacumuladaanual'           ,array('tipo'=>'decimal', 'origen'=>'variacionacumuladaanual'));
        $this->definir_campo('variacionacumuladaanualredondeada' ,array('tipo'=>'decimal', 'origen'=>'variacionacumuladaanualredondeada'));
        $this->definir_campo('ponderadorimplicito'               ,array('tipo'=>'decimal', 'origen'=>'ponderadorimplicito'));
        $this->definir_campo('ordenpor'                          ,array('tipo'=>'texto', 'origen'=>'ordenpor'));
        $this->definir_campo('publicado'                         ,array('tipo'=>'logico', 'origen'=>'publicado'));
        $this->definir_campos_orden('ordenpor');
      
    }
     function clausula_from(){
        return "calgru_vw";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo'    ,
            'calculo'    ,
            'agrupacion' ,
            'grupo'      ,
            'nombre'     ,
            'variacion'  ,
            'impgru'     ,
            'grupopadre' ,
            'nivel'      ,
            'esproducto' ,
            'ponderador' ,
            'indice'     ,
            'indiceprel' ,
            'incidencia' ,
            'indiceredondeado' ,    
            'incidenciaredondeada', 
            'incidenciainteranual' ,
            'incidenciainteranualredondeada',
            'incidenciaacumuladaanual',
            'incidenciaacumuladaanualredondeada',            
            'variacioninteranual',
            'variacioninteranualredondeda',
            'variaciontrimestral',
            'variacionacumuladaanual',
            'variacionacumuladaanualredondeada',
            'ponderadorimplicito',
            'publicado'
             );
        return $campos_solo_lectura;
    }
    
/*     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'agrupacion'  
                                                    ,'nivel'       
                                                    ,'grupo'
                                                     ));
    }*/
}
?>