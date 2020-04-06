<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class Vista_caldiv_vw extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                  ,array('tipo'=>'texto'  ,  'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('calculo'                  ,array('tipo'=>'entero' , 'es_pk'=>true, 'origen'=>'calculo'));
        $this->definir_campo('producto'                 ,array('tipo'=>'texto' , 'es_pk'=>true, 'origen'=>'producto' ));
        $this->definir_campo('nombreproducto'           ,array('tipo'=>'texto' , 'origen'=>'nombreproducto' ));
        $this->definir_campo('division'                 ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'division'));
        $this->definir_campo('prompriimpact'            ,array('tipo'=>'decimal', 'origen'=>'prompriimpact'));
        $this->definir_campo('prompriimpant'            ,array('tipo'=>'decimal', 'origen'=>'prompriimpant'));
        $this->definir_campo('varpriimp'                ,array('tipo'=>'decimal', 'origen'=>'varpriimp'));
        $this->definir_campo('cantpriimp'               ,array('tipo'=>'entero', 'origen'=>'cantpriimp'));
        $this->definir_campo('promprel'                 ,array('tipo'=>'decimal', 'origen'=>'promprel'));
        $this->definir_campo('promdiv'                  ,array('tipo'=>'decimal', 'origen'=>'promdiv'));
        $this->definir_campo('promdivant'               ,array('tipo'=>'decimal', 'origen'=>'promdivant'));
        $this->definir_campo('promedioredondeado'       ,array('tipo'=>'decimal', 'origen'=>'promedioredondeado'));
        $this->definir_campo('impdiv'                   ,array('tipo'=>'texto', 'origen'=>'impdiv'));
        $this->definir_campo('cantincluidos'            ,array('tipo'=>'entero', 'origen'=>'cantincluidos'));
        $this->definir_campo('cantrealesincluidos'      ,array('tipo'=>'entero', 'origen'=>'cantrealesincluidos'));
        $this->definir_campo('cantconprecioparacalestac',array('tipo'=>'entero', 'origen'=>'cantconprecioparacalestac'));
        $this->definir_campo('cantrealesexcluidos'      ,array('tipo'=>'entero', 'origen'=>'cantrealesexcluidos'));
        $this->definir_campo('promvar'                  ,array('tipo'=>'decimal', 'origen'=>'promvar'));
        $this->definir_campo('cantaltas'                ,array('tipo'=>'entero', 'origen'=>'cantaltas'));
        $this->definir_campo('promaltas'                ,array('tipo'=>'decimal', 'origen'=>'promaltas'));
        $this->definir_campo('cantbajas'                ,array('tipo'=>'entero', 'origen'=>'cantbajas'));
        $this->definir_campo('prombajas'                ,array('tipo'=>'decimal', 'origen'=>'prombajas'));
        $this->definir_campo('cantimputados'            ,array('tipo'=>'entero', 'origen'=>'cantimputados'));
        $this->definir_campo('ponderadordiv'            ,array('tipo'=>'decimal', 'origen'=>'ponderadordiv'));
        $this->definir_campo('umbralpriimp'             ,array('tipo'=>'entero', 'origen'=>'umbralpriimp'));
        $this->definir_campo('umbraldescarte'           ,array('tipo'=>'entero', 'origen'=>'umbraldescarte'));
        $this->definir_campo('umbralbajaauto'           ,array('tipo'=>'entero', 'origen'=>'umbralbajaauto'));
        $this->definir_campo('cantidadconprecio'        ,array('tipo'=>'entero', 'origen'=>'cantidadconprecio'));
        $this->definir_campo('profundidad'              ,array('tipo'=>'entero', 'origen'=>'profundidad'));
        $this->definir_campo('divisionpadre'            ,array('tipo'=>'texto', 'origen'=>'divisionpadre'));
        $this->definir_campo('tipo_promedio'            ,array('tipo'=>'texto', 'origen'=>'tipo_promedio'));
        $this->definir_campo('raiz'                     ,array('tipo'=>'logico', 'origen'=>'raiz'));
        $this->definir_campo('variacion'                ,array('tipo'=>'decimal', 'origen'=>'variacion'));
        $this->definir_campo('promsinimpext'            ,array('tipo'=>'decimal', 'origen'=>'promsinimpext'));
        $this->definir_campo('varsinimpext'             ,array('tipo'=>'decimal', 'origen'=>'varsinimpext'));
        $this->definir_campo('varsincambio'             ,array('tipo'=>'decimal', 'origen'=>'varsincambio'));
        $this->definir_campo('varsinaltasbajas'         ,array('tipo'=>'decimal', 'origen'=>'varsinaltasbajas'));
        $this->definir_campo('promrealesexcluidos'      ,array('tipo'=>'decimal', 'origen'=>'promrealesexcluidos'));
        $this->definir_campo('publicado'                ,array('tipo'=>'logico', 'origen'=>'publicado'));
        /*
        $this->definir_campo('cantexcluidos'        ,array('tipo'=>'entero', 'origen'=>'cantexcluidos'));
        $this->definir_campo('promexcluidos'        ,array('tipo'=>'decimal', 'origen'=>'promexcluidos'));
        $this->definir_campo('promimputados'        ,array('tipo'=>'decimal', 'origen'=>'promimputados'));
        $this->definir_campo('promrealesincluidos'  ,array('tipo'=>'decimal', 'origen'=>'promrealesincluidos'));
        $this->definir_campo('promedioredondeado'   ,array('tipo'=>'decimal', 'origen'=>'promedioredondeado'));
        $this->definir_campo('cantrealesdescartados',array('tipo'=>'entero', 'origen'=>'cantrealesdescartados'));
        */
        $this->definir_campos_orden(array('producto','division'));
      
    }
     function clausula_from(){
        return "caldiv_vw";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
        'periodo',
        'calculo',
        'producto',
        'nombreproducto',
        'division',
        'prompriimpact',
        'prompriimpant',
        'varpriimp',
        'cantpriimp',
        'promprel',
        'promdiv',
        'promdivant',
        'promedioredondeado',
        'impdiv',
        'cantincluidos',
        'cantrealesincluidos',
        'cantrealesexcluidos',
        'promvar',
        'cantaltas',
        'promaltas',
        'cantbajas',
        'prombajas',
        'cantimputados',
        'ponderadordiv',
        'umbralpriimp',
        'umbraldescarte',
        'umbralbajaauto',
        'cantidadconprecio',
        'profundidad',
        'divisionpadre',
        'tipo_promedio',
        'raiz',
        'variacion',
        'promsinimpext',
        'varsinimpext',
        'cantconprecioparacalestac',
        'varsincambio',
        'varsinaltasbajas',
        'promrealesexcluidos',
        'publicado'
        );
        return $campos_solo_lectura;
    }
}
?>