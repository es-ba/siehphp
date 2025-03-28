<?php
//UTF-8:SÍ
require_once "tablas.php";

class Tabla_matrices extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('mat');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('mat_ope',array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('mat_for',array('hereda'=>'formularios','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('mat_mat',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'def'=>'','validart'=>'codigo'));
        $this->definir_campo('mat_texto',array('tipo'=>'texto','largo'=>3000,'validart'=>'castellano'));
        $this->definir_campo('mat_ua',array('hereda'=>'ua','modo'=>'fk_obligatoria','validart'=>'codigo'));
        $this->definir_campo('mat_ultimo_campo_pk',array('tipo'=>'texto','largo'=>20,'validart'=>'codigo'));
        $this->definir_campo('mat_orden',array('tipo'=>'entero'));
        $this->definir_campo('mat_blanquear_clave_al_retroceder',array('tipo'=>'texto','largo'=>200,'validart'=>'extendido'));
        $this->definir_tablas_hijas(array(
            'bloques'=>false,
            'preguntas'=>false,
            'variables'=>false,
            'claves'=>false,
            'respuestas'=>false,
            'filtros'=>false,
            'con_var'=>true,
        ));
        $this->definir_campos_orden('mat_orden');
    }
    function desplegar_encabezado(){
        global $leyendas_claves;
        $this->contexto->salida->abrir_grupo_interno("cabezal_matriz",array('id'=>'cabezal_matriz'));
            $this->contexto->salida->abrir_grupo_interno("cabezal_matriz",array('tipo'=>'table'));
                $this->contexto->salida->abrir_grupo_interno("",array('tipo'=>'tr'));
                    foreach(nombres_campos_claves('','N') as $campo){
                        $this->contexto->salida->abrir_grupo_interno("cabezal_matriz",array('tipo'=>'td'));
                            $this->contexto->salida->enviar("{$leyendas_claves[$campo]} ",'',array('tipo'=>'span'));
                            $this->contexto->salida->enviar("",'',array('tipo'=>'span','id'=>"mostrar_{$campo}"));
                        $this->contexto->salida->cerrar_grupo_interno();
                    }
                    $this->contexto->salida->enviar("Formulario ".$this->datos->mat_for,'cabezal_matriz',array('tipo'=>'td','width'=>'180px'));
                    if($this->datos->mat_mat){
                        $this->contexto->salida->enviar("Matriz ".$this->datos->mat_mat,'cabezal_matriz',array('tipo'=>'td'));
                    }
                $this->contexto->salida->cerrar_grupo_interno();
            $this->contexto->salida->cerrar_grupo_interno();
        $this->contexto->salida->cerrar_grupo_interno();
        /*
        $this->contexto->salida->abrir_grupo_interno("cabezal_matriz");
            $this->contexto->salida->enviar("Encuesta ",'',array('tipo'=>'span'));
            $this->contexto->salida->enviar("",'',array('tipo'=>'span','id'=>'mostrar_enc'));
            $this->contexto->salida->enviar("Hogar ",'',array('tipo'=>'span'));
            $this->contexto->salida->enviar("",'',array('tipo'=>'span','id'=>'mostrar_hog'));
            $this->contexto->salida->enviar("Formulario ".$this->datos->mat_for,'',array('tipo'=>'span'));
            if($this->datos->mat_mat){
                $this->contexto->salida->enviar("Matriz ".$this->datos->mat_mat,'',array('tipo'=>'span'));
            }
        $this->contexto->salida->cerrar_grupo_interno();
        */
    }
    function desplegar(){
        if(!isset($this->despliegue)){
            $this->despliegue=new StdClass();
        }
        if($this->datos->mat_for=='S1' and !$this->datos->mat_mat ){
             $this->contexto->salida->abrir_grupo_interno('confidencial_ley',array('id'=>'ley'));                
                $this->contexto->salida->enviar('(CARÁCTER ESTRICTAMENTE CONFIDENCIAL - Ley N° 6.724 -CABA-)','',array('tipo'=>'div','id'=>'titulo_ley'));                
                $this->contexto->salida->enviar('La información que usted suministra tiene carácter estrictamente confidencial Todas las estadísticas producidas y publicadas son anónimas. Los datos relevados están protegidos por el Secreto Estadístico, cuyo marco normativo se encuentra contemplado en la Ley N° 6.724 –CABA– (Capítulo VI - Arts. 31 a 36). “Las personas humanas o jurídicas que desarrollen cualquier tipo de actividad en la Ciudad, están obligadas a suministrar a los integrantes del Sistema Estadístico de la Ciudad, los datos e información que se les solicite”. Ley N° 6.724 –CABA– (Capítulo II - Art. 4 inciso d).','',array('tipo'=>'div','id'=>'articulo_ley'));                
             $this->contexto->salida->cerrar_grupo_interno();
        }
        $this->desplegar_encabezado();
        $this->contexto->salida->enviar_boton('Volver',null,array('onclick'=>'grabar_y_salir(this);'));
        $this->contexto->salida->enviar_boton('Ir al primer campo disponible',null,array('onclick'=>'ir_a_primer_blanco();'));
        $this->contexto->salida->abrir_grupo_interno("tabla_contenido_formulario",array('tipo'=>'table'));
            $this->desplegar_subtablas();
        $this->contexto->salida->cerrar_grupo_interno();
        $tabla_formularios=$this->despliegue->tabla_formularios=$this->traer_tabla_con_datos('formularios');
        if($tabla_formularios->datos->for_es_principal){
            $otra_matriz=$tabla_formularios->definicion_tabla('matrices');
            $otra_matriz->leer_varios(array(
                'mat_ope'=>$this->datos->mat_ope,
                'mat_for'=>$this->datos->mat_for,
                'mat_mat'=>'',
                'mat_ultimo_campo_pk'=>$this->datos->mat_ultimo_campo_pk
            ));
            $ope_jsoneado=json_encode($this->datos->mat_ope);
            while($otra_matriz->obtener_leido()){
                if($otra_matriz->datos->mat_for!=$this->datos->mat_for){
                    $for_jsoneado=json_encode($otra_matriz->datos->mat_for);
                    $this->contexto->salida->enviar_script(<<<JS
                        document.write(boton_abre_formulario({tra_ope:$ope_jsoneado,tra_for:$for_jsoneado,tra_mat:''}));

JS
                    );
                }
            }
        }
        $this->contexto->salida->enviar_boton('Volver',null,array('onclick'=>'grabar_y_salir(this);','id'=>'boton_fin'));
        $this->contexto->salida->enviar_script(<<<JS
    window.addEventListener('load',function(){
        mostrar_advertencia_descargado();
        DesplegarVariableFormulario({tra_for:"{$this->datos->mat_for}", tra_mat:"{$this->datos->mat_mat}" {$this->datos->mat_blanquear_clave_al_retroceder}});
    });
    function guardar_o_avisar(){
        if(soy_un_ipad){
            GuardarElFormulario();
        }else if(modificado_db){
            return "El formulario tiene modificaciones. Se perderan al cerrar. ¿Desea cerrar?";
        }
        return null;
    }
    window.addEventListener('unload',function(){ 
        return guardar_o_avisar();
    });
    window.addEventListener('beforeunload',function(){ 
        return guardar_o_avisar();
    });

JS
        );
    }
    function desplegar_subtablas(){
        $tabla_bloques=$this->definicion_tabla('bloques');
        $tabla_bloques->leer_varios(array(
            'blo_ope'=>$this->datos->mat_ope,
            'blo_for'=>$this->datos->mat_for,
            'blo_mat'=>$this->datos->mat_mat,
        ));
        while($tabla_bloques->obtener_leido()){
            $tabla_bloques->desplegar();
        }
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE matrices
  ADD CONSTRAINT "texto invalido en mat_blanquear_clave_al_retroceder de tabla ma" CHECK (comun.cadena_valida(mat_blanquear_clave_al_retroceder::text, 'extendido'::text));
/*OTRA*/
ALTER TABLE matrices
  ADD CONSTRAINT "texto invalido en mat_for de tabla matrices" CHECK (comun.cadena_valida(mat_for::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE matrices
  ADD CONSTRAINT "texto invalido en mat_mat de tabla matrices" CHECK (comun.cadena_valida(mat_mat::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE matrices
  ADD CONSTRAINT "texto invalido en mat_ope de tabla matrices" CHECK (comun.cadena_valida(mat_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE matrices
  ADD CONSTRAINT "texto invalido en mat_texto de tabla matrices" CHECK (comun.cadena_valida(mat_texto::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE matrices
  ADD CONSTRAINT "texto invalido en mat_ua de tabla matrices" CHECK (comun.cadena_valida(mat_ua::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE matrices
  ADD CONSTRAINT "texto invalido en mat_ultimo_campo_pk de tabla matrices" CHECK (comun.cadena_valida(mat_ultimo_campo_pk::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>