<?php
//UTF-8:SÍ

require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_exportacion_tu_inflacion extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
   }
    function post_constructor(){
        parent::post_constructor();
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT Max(periodo) as ultimo FROM cvp.calculos  
                                          WHERE abierto='N' and calculo=0
SQL
        ));
        $fila=$cursor->fetchObject();
        $def_periodo=$fila->ultimo;
        $this->definir_parametros(array(
            'titulo'=>'Exportación a tu inflación',
            'permisos'=>array('grupo'=>'coordinador'),
            'submenu'=>'Administración',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_periodo'=>array('tipo'=>'texto','label'=>'Período','def'=>$def_periodo),
                'tra_en_prueba'=>array('label'=>false,'type'=>'checkbox', 'label-derecho'=>'Exportar a base MySql de prueba','def'=>false),
                ),
            'bitacora'=>true,
            'boton'=>array('id'=>'exportar'),
        ));
    }
    function compara_tabla_tuinflacion($dboMysql, $strSelect,$nombretabla, $arr_errores) {    
                $sql_res = $dboMysql->prepare($strSelect);
                $sql_res->execute();
                $resultado = $sql_res->fetchAll(PDO::FETCH_ASSOC);
                $orig_str=str_replace( 'tuinflacion', 'expo',$strSelect);
                $c_tabla=$this->db->ejecutar_sql(new Sql(<<<SQL
                    $orig_str
SQL
                ));
                $arr_tabla=$c_tabla->fetchAll(PDO::FETCH_ASSOC);                
                $n_res=count($resultado);
                $n_a=count($arr_tabla);
                if( $n_res!==$n_a){
                      $arr_errores[]='Tabla '. $nombretabla .' No coincide cantidad de filas '. $n_a . ' vs ' .$n_res;
                }
                $resultado_json = json_encode($resultado);
                $arr_tabla_json = json_encode($arr_tabla);
                if($resultado_json !== $arr_tabla_json ){
                      $arr_errores[]='Tabla '.$nombretabla.' No coincide en valor y/o tipo de datos';        
                    //Loguear("2014-01-29",'******** ELLOS:'.var_export($resultado_json,true));
                    //Loguear("2014-01-29",'******** NOSTR:'.var_export($arr_tabla_json,true));
                }
                return $arr_errores; 
    }
    function responder(){
        //echo( phpinfo());
        $pperiodo= $this->argumentos->tra_periodo;
        $c_v_per= $this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT c.abierto
              FROM cvp.calculos c 
              WHERE c.calculo=0 and c.periodo=:p_periodo
SQL
            , array(':p_periodo'=>$pperiodo)
        )); 
        $fila=$c_v_per->fetchObject();        
        if (!$fila){
           return new Respuesta_Negativa('Periodo ' .$pperiodo . ' inexistente en tabla calculos');        
        }
        if(($fila->abierto)!=='N') {
           return new Respuesta_Negativa('Periodo ' .$pperiodo . ' no está cerrado');        
        }
        $ahora=date_format(new DateTime(), "Y-m-d H:i:s");
        $this->db->beginTransaction();
        $this->db->ejecutar_sql(new Sql(<<<SQL
                    SELECT expo.actualizar_esquema_expo(:p_periodo);
SQL
                    , array(':p_periodo'=>$pperiodo)
                ));
        $this->db->commit();
        $c_periodos=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT periodo, anio, mes
              FROM expo.tb_imp_periodos
              ORDER BY periodo
SQL
        ));
        $c_columnas=$this->db->ejecutar_sql(new Sql(<<<SQL
            select periodo, columna, periodo_denominador, texto_columna
                from expo.tb_imp_columnas
                order by periodo, columna
SQL
        ));
        $c_rubros=$this->db->ejecutar_sql(new Sql(<<<SQL
                  select rubro,
                         nombre_rubro,
                         explicacion_rubro,nivel,
                         rubro_padre, aparece_en_resultados
                      from expo.tb_imp_rubros
                      order by nivel, rubro
SQL
        ));
        $c_indices=$this->db->ejecutar_sql(new Sql(<<<SQL
                select periodo, rubro, indice
                    from expo.tb_imp_indices
                    order by periodo, rubro 
SQL
        ));
        $c_param=$this->db->ejecutar_sql(new Sql(<<<SQL
                select *
                    from expo.tb_imp_parametros
                    order by codigo
SQL
        ));
        try {
            $host=$this->argumentos->tra_en_prueba?'10.32.3.145':'10.32.3.45';
            $usu=$this->argumentos->tra_en_prueba?'ipc_peron':'desadmin';
            $pass=$this->argumentos->tra_en_prueba?'laclave':'laclave';
            $dboMysql = new PDO('mysql:host='. $host .';port=3306;dbname=tuinflacion', $usu, $pass,
                                 array( PDO::ATTR_PERSISTENT => true,
                                        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                                        PDO::ATTR_EMULATE_PREPARES => false,
                                        PDO::ATTR_TIMEOUT => 200 ));
            $dboMysql->setAttribute(PDO::ATTR_STRINGIFY_FETCHES, false);
        } catch (PDOException $e) {
            return new Respuesta_Negativa('Error al intentar conexion a MySql' . $e->getMessage());        
        }
        try {
            $dboMysql->beginTransaction();
                $elim_i  = $dboMysql->exec('DELETE FROM tuinflacion.tb_imp_indices ');
                $elim_r2 = $dboMysql->exec('DELETE FROM tuinflacion.tb_imp_rubros ORDER BY nivel DESC');
                $elim_c  = $dboMysql->exec('DELETE FROM tuinflacion.tb_imp_columnas');
                $elim_p  = $dboMysql->exec('DELETE FROM tuinflacion.tb_imp_periodos');
                $elim_par= $dboMysql->exec('DELETE FROM tuinflacion.tb_imp_parametros');
                $dboMysql->exec("set names utf8");
                while($fila=$c_periodos->fetchObject()){
                    $sql_m = $dboMysql->prepare('insert into tuinflacion.tb_imp_periodos(periodo,anio,mes) values (:p_periodo, :p_anio, :p_mes)');
                    $sql_m->bindValue( ":p_periodo", $fila->periodo, PDO::PARAM_STR );
                    $sql_m->bindValue( ":p_anio", $fila->anio, PDO::PARAM_INT );
                    $sql_m->bindValue( ":p_mes", $fila->mes, PDO::PARAM_INT );
                    $sql_m->execute();
                }
                while($fila=$c_columnas->fetchObject()){
                    $sql_m = $dboMysql->prepare('INSERT INTO tuinflacion.tb_imp_columnas(periodo, columna, periodo_denominador, texto_columna) values (:p_per, :p_col, :p_per_den, CONVERT(:p_tex_col USING utf8))');
                    $sql_m->bindValue( ":p_per", $fila->periodo, PDO::PARAM_STR );
                    $sql_m->bindValue( ":p_col", $fila->columna, PDO::PARAM_INT );
                    $sql_m->bindValue( ":p_per_den", $fila->periodo_denominador, PDO::PARAM_STR );
                    $sql_m->bindValue( ":p_tex_col", $fila->texto_columna, PDO::PARAM_STR );
                    $sql_m->execute();
                } 
                while($fila=$c_rubros->fetchObject()){
                    $sql_m = $dboMysql->prepare('INSERT INTO tuinflacion.tb_imp_rubros(rubro, nombre_rubro,explicacion_rubro,nivel,rubro_padre,aparece_en_resultados) values (:p_rubro, CONVERT(:p_nom_rub USING utf8), convert(:p_exp_rub USING utf8), :p_niv, :p_rub_pad, :p_apa_res)');
                    $sql_m->bindValue( ":p_rubro", $fila->rubro, PDO::PARAM_STR );
                    $sql_m->bindValue( ":p_nom_rub", $fila->nombre_rubro, PDO::PARAM_STR );
                    $sql_m->bindValue( ":p_exp_rub", $fila->explicacion_rubro, PDO::PARAM_STR );
                    $sql_m->bindValue( ":p_niv", $fila->nivel, PDO::PARAM_INT );
                    $sql_m->bindValue( ":p_rub_pad", $fila->rubro_padre, PDO::PARAM_STR );
                    $sql_m->bindValue( ":p_apa_res", $fila->aparece_en_resultados, PDO::PARAM_INT );
                    $sql_m->execute();
                }
                while($fila=$c_indices->fetchObject()){
                    $sql_m = $dboMysql->prepare('INSERT INTO tuinflacion.tb_imp_indices(periodo,rubro,indice) values (:p_per, :p_rub, :p_ind )');
                    $sql_m->bindValue( ":p_per", $fila->periodo, PDO::PARAM_STR );
                    $sql_m->bindValue( ":p_rub", $fila->rubro, PDO::PARAM_STR );
                    $sql_m->bindValue( ":p_ind", $fila->indice, PDO::PARAM_STR );
                    $sql_m->execute();
                }    
                //parametros
                while($fila=$c_param->fetchObject()){
                    $sql_m = $dboMysql->prepare('insert into tuinflacion.tb_imp_parametros(codigo,descripcion,valor) values (:p_cod, :p_desc, :p_val)');
                    $sql_m->bindValue( ":p_cod", $fila->codigo, PDO::PARAM_STR );
                    $sql_m->bindValue( ":p_desc", $fila->descripcion, PDO::PARAM_STR );
                    $sql_m->bindValue( ":p_val", $fila->valor, PDO::PARAM_STR );
                    $sql_m->execute();
                }
                // comparar lo que quedó en mysql con lo leido de postgres
                $errores=array();
                // /*
                $errores=$this->compara_tabla_tuinflacion($dboMysql, 
                                         'SELECT periodo, anio, mes FROM tuinflacion.tb_imp_periodos ORDER BY periodo',
                                         'tb_imp_periodos', $errores);
                                         
                $errores=$this->compara_tabla_tuinflacion($dboMysql, 
                                         'select periodo, columna, periodo_denominador, texto_columna FROM tuinflacion.tb_imp_columnas ORDER BY periodo, columna',
                                         'tb_imp_columnas', $errores);
                $errores=$this->compara_tabla_tuinflacion($dboMysql, 
                                         'select rubro,nombre_rubro,explicacion_rubro,nivel,rubro_padre, aparece_en_resultados'.
                                         ' from tuinflacion.tb_imp_rubros'.
                                         ' order by nivel, rubro',
                                    'tb_imp_rubros' , $errores);
                $errores=$this->compara_tabla_tuinflacion($dboMysql, 
                                        'select periodo, rubro, indice'.
                                        '    from tuinflacion.tb_imp_indices'. 
                                        '    order by periodo, rubro', 
                                    'tb_imp_indices', $errores);
                $errores=$this->compara_tabla_tuinflacion($dboMysql, 
                                        'select * from tuinflacion.tb_imp_parametros order by codigo', 
                                        'tb_imp_parametros' , $errores);
                // */                       
                if ($errores){
                  $dboMysql->Rollback(); 
                  return new Respuesta_Negativa('Error en la Importacion, no hay coincidencia en valores y/o tipos: '.json_encode($errores));
                }                
            $dboMysql->Commit();
  
            $this->salida=new Armador_de_salida(true);
            $this->salida->enviar('','',array('id'=>'g_periodos'));
            enviar_grilla($this->salida,'tb_imp_periodos',array(),'g_periodos',array('simple'=>'true'));
            $this->salida->enviar('','',array('id'=>'g_columnas'));
            enviar_grilla($this->salida,'tb_imp_columnas',array(),'g_columnas',array('simple'=>'true'));
            $this->salida->enviar('','',array('id'=>'g_rubros'));
            enviar_grilla($this->salida,'tb_imp_rubros',array(),'g_rubros',array('simple'=>'true'));
            $this->salida->enviar('','',array('id'=>'g_indices'));
            enviar_grilla($this->salida,'tb_imp_indices',array(),'g_indices',array('simple'=>'true'));
            $this->salida->enviar('','',array('id'=>'g_parametros'));
            enviar_grilla($this->salida,'tb_imp_parametros',array(),'g_parametros',array('simple'=>'true'));
            return $this->salida->obtener_una_respuesta_HTML();

        } catch (PDOException $e) {
            //mostrar $dboMysql->PDO::errorInfo()
            $dboMysql->RollBack();
            return new Respuesta_Negativa('Error en la Importacion' . $e->getMessage(). $dboMysql->errorInfo());        
        }
    }
}
?>