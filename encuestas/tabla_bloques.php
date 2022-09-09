<?php
//UTF-8:SÍ
require_once "tablas.php";
// require_once "tabla_preguntas.php";

class Tabla_bloques extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('blo');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('blo_ope',array('hereda'=>'operativos','modo'=>'pk','validat'=>'codigo'));
        $this->definir_campo('blo_for',array('hereda'=>'formularios','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('blo_blo',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'validart'=>'extendido'));
        $this->definir_campo('blo_mat',array('hereda'=>'matrices','modo'=>'fk_obligatoria','forzar_null_a_vacio'=>true,'validart'=>'codigo'));
        $this->definir_campo('blo_texto',array('tipo'=>'texto','largo'=>3000,'not_null'=>true, 'validart'=>'castellano'));
        $this->definir_campo('blo_incluir_mat',array('tipo'=>'texto','largo'=>50,'not_null'=>false, 'validart'=>'codigo'));
        $this->definir_campo('blo_orden',array('tipo'=>'entero'));
        $this->definir_campo('blo_aclaracion',array('tipo'=>'texto','largo'=>500, 'validart'=>'castellano'));
        $this->definir_tablas_hijas(array(
            'bloques'=>false,
            'preguntas'=>false,
            'filtros'=>false));
        $this->definir_campos_orden(array('blo_for','blo_orden'));
    }
    function desplegar_subtablas(){
        $this->despliegue->tabla_preguntas=$tabla_preguntas=$this->definicion_tabla('preguntas');
        $this->despliegue->tabla_variables=$tabla_variables=$this->definicion_tabla('variables');
        $tabla_preguntas->leer_varios($this);
        $this->despliegue->tabla_filtros=$tabla_filtros=$this->definicion_tabla('filtros');
        $tabla_filtros->leer_varios($this);
        $tabla_filtros->obtener_leido();
        $tabla_preguntas->obtener_leido();
        while($tabla_preguntas->datos || $tabla_filtros->datos){
            //Loguear('2012-03-16',"-------------- ESTE ES EL FILTRO:".($tabla_filtros->datos?"true":"false")." &&// {$tabla_preguntas->datos->pre_orden}>".($tabla_filtros->datos?$tabla_filtros->datos->fil_orden:"")."}");
            if($tabla_filtros->datos && (!$tabla_preguntas->datos || $tabla_preguntas->datos->pre_orden>$tabla_filtros->datos->fil_orden)){
                $tabla_filtros->desplegar();
                $tabla_filtros->obtener_leido();
            } elseif ($tabla_preguntas->datos){
                $tabla_preguntas->desplegar();
                $tabla_preguntas->obtener_leido();
            }
        }
        if($this->datos->blo_incluir_mat){ // despliegue matriz de familiar
          $tabla_preguntas->leer_varios(array(
            'pre_ope'=>$this->datos->blo_ope,
            'pre_for'=>$this->datos->blo_for,
            'pre_mat'=>$this->datos->blo_incluir_mat
          ));
          $tabla_filtros->leer_varios(array(
            'fil_ope'=>$this->datos->blo_ope,
            'fil_for'=>$this->datos->blo_for,
            'fil_mat'=>$this->datos->blo_incluir_mat
          ));
          $tabla_filtros->obtener_leido();
          $tabla_preguntas->obtener_leido();
          $matriz=$this->datos->blo_incluir_mat;
          $this->contexto->salida->abrir_grupo_interno("encabezado_matriz_".$matriz,array('tipo'=>'TD','colspan'=>2));
            $this->contexto->salida->abrir_grupo_interno("matriz_horizontal",array('tipo'=>'TABLE'));
              $this->contexto->salida->abrir_grupo_interno("unica_fila_preguntas_matriz",array('tipo'=>'TR','id'=>'titulos_matriz_'.$matriz));
              $this->contexto->salida->enviar('N°',"celda_matriz_formulario hori_pre_pre",array('tipo'=>'TD','id'=>'num_renglon'));
              while($tabla_preguntas->datos){
                if(!empieza_con($tabla_preguntas->datos->pre_pre,'fin')){
                  $tabla_variables->leer_varios($tabla_preguntas);
                  $cant_variables_en_pregunta=0;
                  while($tabla_variables->obtener_leido() && !termina_con($tabla_variables->datos->var_var,'_esp')){
                      $cant_variables_en_pregunta++;
                  }
                  $this->contexto->salida->abrir_grupo_interno("celda_matriz_formulario",array('tipo'=>'TD','colspan'=>$cant_variables_en_pregunta));
                    $this->contexto->salida->abrir_grupo_interno("hori_pre_pre",array('tipo'=>'span'));
                      $this->contexto->salida->enviar($tabla_preguntas->datos->pre_pre);
                    $this->contexto->salida->cerrar_grupo_interno();
                    $this->contexto->salida->abrir_grupo_interno("hori_pre_texto",array('tipo'=>'span'));
                      if($tabla_preguntas->datos->pre_abreviado){
                        $this->contexto->salida->enviar($tabla_preguntas->datos->pre_abreviado);
                      } else {
                        $this->contexto->salida->enviar($tabla_preguntas->datos->pre_texto, "meta_reem");
                      }
                    $this->contexto->salida->cerrar_grupo_interno();
                  $this->contexto->salida->cerrar_grupo_interno();
                }
                $tabla_preguntas->obtener_leido();
              }
              $this->contexto->salida->enviar('',"celda_matriz_formulario hori_pre_pre",array('tipo'=>'TD','id'=>'boton_general_A1','style'=>'text-align:right'));
              if((substr($GLOBALS['nombre_app'],0,4)=='etoi' && (int)(substr($GLOBALS['nombre_app'],4))>=162 && (int)(substr($GLOBALS['nombre_app'],4))<=172 ) || (substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']==2016) ){
                $this->contexto->salida->enviar('',"celda_matriz_formulario hori_pre_pre",array('tipo'=>'TD','id'=>'boton_general_GH','style'=>'text-align:right'));
              }
              if($GLOBALS['nombre_app']=='eah2019'|| $GLOBALS['nombre_app']=='eah2021'){
                $this->contexto->salida->enviar('',"celda_matriz_formulario hori_pre_pre",array('tipo'=>'TD','id'=>'boton_general_PMD','style'=>'text-align:right'));
              }              
              $this->contexto->salida->cerrar_grupo_interno();
              $tabla_preguntas->leer_varios(array(
                'pre_ope'=>$this->datos->blo_ope,
                'pre_for'=>$this->datos->blo_for,
                'pre_mat'=>$this->datos->blo_incluir_mat
              ));
              $tabla_preguntas->obtener_leido();
              $this->contexto->salida->abrir_grupo_interno("fila_matriz",array('tipo'=>'TR','id'=>'fila_matriz_'.$matriz));
              $this->contexto->salida->enviar('',"celda_matriz_formulario",array('tipo'=>'TD','id'=>'num_renglon'));
              while($tabla_preguntas->datos){
                  if(!empieza_con($tabla_preguntas->datos->pre_pre,'fin')){
                      $tabla_variables->leer_varios($tabla_preguntas);
                      while($tabla_variables->obtener_leido() && !termina_con($tabla_variables->datos->var_var,'_esp')){
                          $this->contexto->salida->enviar('',"celda_matriz_formulario",array('tipo'=>'TD','id'=>'var_'.$tabla_variables->datos->var_var));
                      }
                  }
                  $tabla_preguntas->obtener_leido();
              }
              $this->contexto->salida->cerrar_grupo_interno();
            $this->contexto->salida->cerrar_grupo_interno();
              if($GLOBALS['nombre_app']=='eah2014'||$GLOBALS['nombre_app']=='eah2018'||$GLOBALS['nombre_app']=='eah2022'){
                  $this->contexto->salida->enviar('',"celda_matriz_formulario hori_pre_pre",array('tipo'=>'DIV','id'=>'boton_general_PG1','style'=>'text-align:right'));
              }
          $this->contexto->salida->cerrar_grupo_interno();
        }
    }
    function desplegar(){
        $this->contexto->salida->abrir_grupo_interno("encabezado_bloque",array('tipo'=>'TR'));
            $this->contexto->salida->abrir_grupo_interno("encabezado_bloque",array('tipo'=>'TD','colspan'=>3));
                // $this->contexto->salida->enviar($this->datos->blo_blo,"blo_blo");
                $this->contexto->salida->enviar($this->datos->blo_texto,"blo_texto meta_reem");
                $this->contexto->salida->enviar($this->datos->blo_aclaracion,"blo_aclaracion");
            $this->contexto->salida->cerrar_grupo_interno();
        $this->contexto->salida->cerrar_grupo_interno();
        $this->desplegar_subtablas();
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE bloques
  ADD CONSTRAINT "texto invalido en blo_aclaracion de tabla bloques" CHECK (comun.cadena_valida(blo_aclaracion::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE bloques
  ADD CONSTRAINT "texto invalido en blo_blo de tabla bloques" CHECK (comun.cadena_valida(blo_blo::text, 'extendido'::text));
/*OTRA*/
ALTER TABLE bloques
  ADD CONSTRAINT "texto invalido en blo_for de tabla bloques" CHECK (comun.cadena_valida(blo_for::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE bloques
  ADD CONSTRAINT "texto invalido en blo_incluir_mat de tabla bloques" CHECK (comun.cadena_valida(blo_incluir_mat::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE bloques
  ADD CONSTRAINT "texto invalido en blo_mat de tabla bloques" CHECK (comun.cadena_valida(blo_mat::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE bloques
  ADD CONSTRAINT "texto invalido en blo_ope de tabla bloques" CHECK (comun.cadena_valida(blo_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE bloques
  ADD CONSTRAINT "texto invalido en blo_texto de tabla bloques" CHECK (comun.cadena_valida(blo_texto::text, 'cualquiera'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>