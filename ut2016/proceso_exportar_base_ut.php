<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_exportar_base_ut extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->tabla_baspro=$this->nuevo_objeto("Tabla_baspro");
        $tabla_baspro=$this->tabla_baspro;        
        $this->definir_parametros(array('titulo'=>(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015)?'Bases producidas UT exportar - Modo '. $_SESSION['modo_encuesta']:'Bases producidas UT exportar',
            'submenu'=>'procesamiento',
            'permisos'=>array('grupo'=>'procesamiento'),
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_baspro'=>array('label'=>'base','def'=>'para_fexp','opciones'=>$tabla_baspro->lista_opciones(array('baspro_ope'=>$GLOBALS['NOMBRE_APP']))),
                'tra_estado_desde'=>array('label'=>'estado desde','def'=>'77','style'=>'width:40px'),
                'tra_estado_hasta'=>array('label'=>'estado hasta','def'=>'79','style'=>'width:40px'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'generar'),
        ));
        $this->sin_interrumpir=true;
    }
    function responder(){
        // GENERAR
        $vtitulo_modo='';
        $val_modo='';
        if(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015){
            $vtitulo_modo='_'.$_SESSION['modo_encuesta'];
            $val_modo= ($_SESSION['modo_encuesta']=='ETOI')?$_SESSION['modo_encuesta']:$GLOBALS['NOMBRE_APP'];
        }    
        $nombre_base=sanitizar_sql($this->argumentos->tra_baspro);
        $prefijo_nombres=$GLOBALS['nombre_app'].'_'.$nombre_base;
        $zip = new ZipArchive();
        $filename = "../export/$prefijo_nombres".
            ($this->argumentos->tra_estado_desde!=79||$this->argumentos->tra_estado_hasta!=79?'_estados_'.($this->argumentos->tra_estado_desde+0).'a'.($this->argumentos->tra_estado_hasta+0):'').
            $vtitulo_modo.".zip";
        if(file_exists($filename)){
            unlink($filename);
        }
        if ($zip->open($filename, ZipArchive::CREATE)!==TRUE) {
            return new Respuesta_negativa("no se puede crear el zip <$filename>\n");
        }
        $bases_existentes=array();
        $cur_salida=$this->db->ejecutar_sql(new Sql(
                "SELECT * FROM baspro_salidas  ORDER BY basprosal_sal"
        ));
        while($rdestino=$cur_salida->fetchObject()){
            $destino=$rdestino->basprosal_sal;
            $sufijo =$rdestino->basprosal_texto;
            //Loguear('2017-08-31',"************************ luego de consultar salidas rd $destino $sufijo $filename");
            $app=$GLOBALS['nombre_app'];
            $clausula_where_var="basprovar_baspro = '$nombre_base' and basprovar_ope = '$app' and basprovar_salida= '$destino' ";
            $str_sql="SELECT count(*) as cant FROM baspro_var_ut WHERE {$clausula_where_var} ";
            $cursor=$this->db->ejecutar_sql(new Sql(
                "SELECT count(*) as cant FROM baspro_var_ut WHERE {$clausula_where_var} "
            ));
            $cant_var=$cursor->fetchObject();
            if ($cant_var and @$cant_var->cant>0 ){
                $curs=$this->db->ejecutar_sql(new Sql(<<<SQL
                    select vista_base_producida_ut(:base,:nombre,:desde,:hasta,:modoenc)
SQL
                    ,array(
                        ':base'=>"$destino",
                        ':nombre'=>$nombre_base,
                        ':desde'=>$this->argumentos->tra_estado_desde,
                        ':hasta'=>$this->argumentos->tra_estado_hasta,
                        ':modoenc'=>$val_modo
                    )
                ));
                $sin_pk=$this->db->preguntar(new Sql(<<<SQL
                  select baspro_sin_pk
                    from baspro
                    where baspro_baspro = :nombre
SQL
                  ,array(':nombre'=>$nombre_base)
                ));
                $nombre = $prefijo_nombres.'_'.$destino;
                $curs_vista=$this->db->ejecutar_sql(new Sql(<<<SQL
                  select distinct table_name from information_schema.columns where table_schema = 'encu' and table_name = '$nombre' limit 1
SQL
                ));
                while($vista=$curs_vista->fetch(PDO::FETCH_ASSOC)){
                    $bases_existentes[] = $rdestino;
                }
            }
        }
        $tablas_exportadas=array();
        foreach($bases_existentes as $v){
            $destino=$v->basprosal_sal;
            $sufijo =$v->basprosal_texto;
            $clausula_where_var="basprovar_baspro = '$nombre_base' and basprovar_ope = '$app' and basprovar_salida = '$destino'";
            foreach(array(
                'datos'=>  array('tabla'=>$prefijo_nombres.'_'.$destino,
                                 'campos'=>'*',
                                 'clausula_where'=>'',
                                 'order_by'=>'',
                                 'agrego_sufijo'=>$sufijo,
                                 'texto_previo'=>'',
                                 'texto_previo_pk'=>"",
                                 'texto_previo_pk_mie'=>"",
                                 'texto_previo_pk_exm'=>"",
                                 'texto_previo_pk_exm_men'=>"",
                                 'texto_final'=>'',
                                 'extension'=>'.txt',
                                 'separador'=>';'
                                 ),
                'disenio'=>array('tabla'=>'baspro_var_ut',
                                 'campos'=>'coalesce(basprovar_alias,basprovar_var) as columna, encu.nombre_largo_para_documentacion_ut(basprovar_var,basprovar_baspro) as descripcion',
                                 'clausula_where'=>$clausula_where_var,
                                 'order_by'=>'basprovar_orden',
                                 'agrego_sufijo'=>$sufijo.'_dis_reg',
                                 'texto_previo'=>'',
                                 'texto_previo_pk'=>"enc;número interno de encuesta\r\nhog;número interno de hogar\r\n",
                                 'texto_previo_pk_mie'=>"mie;número interno de miembro\r\n",
                                 'texto_previo_pk_exm'=>"exm;número de migrante\r\n",
                                 'texto_previo_pk_exm_men'=>"exm;número de migrante\r\n",
                                 'texto_final'=>'',
                                 'extension'=>'.txt',
                                 'separador'=>';'
                                 ),
                'sintaxis'=>array('tabla'=>'baspro_var_ut',
                                 'campos'=>'coalesce(basprovar_alias,basprovar_var) as columna, encu.formato_variable(basprovar_var,basprovar_baspro) as formato',
                                 'clausula_where'=>$clausula_where_var,
                                 'order_by'=>'basprovar_orden',
                                 'agrego_sufijo'=>$sufijo.'_sintaxis',
                                 'texto_previo'=>'SET UNICODE = ON.'."\r\n".'SET OLANG=SPANISH. '."\r\n"."SET LOCALE='English'."."\r\n".'GET DATA '."\r\n".'/TYPE=TXT '."\r\n"."/FILE=\"{$prefijo_nombres}_{$sufijo}{$vtitulo_modo}.txt\"  /*ATENCION: Agregar antes del nombre de archivo, el path de su ubicación*/ "."\r\n".'/DELCASE=LINE '."\r\n".'/DELIMITERS=";" '."\r\n".'/ARRANGEMENT=DELIMITED '."\r\n".'/FIRSTCASE=2 '."\r\n".'/IMPORTCASE=ALL '."\r\n".'/VARIABLES='."\r",
                                 'texto_previo_pk'=>"enc F6.0\r\nhog F6.0\r\n",
                                 'texto_previo_pk_mie'=>"mie F6.0\r\n",
                                 'texto_previo_pk_exm'=>"exm F6.0\r\n",
                                 'texto_previo_pk_exm_men'=>"exm F6.0\r\n",
                                 'texto_final'=>".\r\n",
                                 'extension'=>'.sps',
                                 'separador'=>' '
                                 )
            ) as $archivo => $definicion)
            {    
                $script='select '.$definicion['campos']. ' from encu.'.$definicion['tabla'];
                if($definicion['clausula_where']!=''){
                    $script.=' where '.$definicion['clausula_where'];
                }
                if($definicion['order_by']!=''){
                    $script.=' order by '.$definicion['order_by'];
                }
                $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
                $script 
SQL
                ));
                $tiene_datos=false;
                $nombre_archivo=$prefijo_nombres.'_'.$definicion['agrego_sufijo'].$vtitulo_modo.$definicion['extension'];
                $path_archivo='../export/'.$nombre_archivo;
                $f=fopen($path_archivo,'w');
                $con_mie=strpos($v->basprosal_claves, 'mie')!==false;
                //Loguear('2017-08-31',"************************ con_mie $con_mie");
                while($fila=$cursor->fetch(PDO::FETCH_ASSOC)){
                    if(!$tiene_datos){ // es primera fila
                        if($definicion['texto_previo']!=''){
                            fwrite($f,$definicion['texto_previo']);
                        }else{
                            fwrite($f,implode(';',array_keys($fila))."\r\n");
                        }
                        if(!$sin_pk){
                            fwrite($f,$definicion['texto_previo_pk']);
                            if($con_mie){
                                fwrite($f,$definicion['texto_previo_pk_mie']);
                            }
                        }
                        $tiene_datos=true;
                    }
                    $sepa="";
                    $txt="";
                    foreach($fila as $campo){
                        $txt.=$sepa.preg_replace('/[;\n\r\t]+/',',',$campo);
                        $sepa=$definicion['separador'];
                    }
                    fwrite($f,$txt."\r\n");
                }
                fwrite($f,$definicion['texto_final']);
                fclose($f);
                if($tiene_datos){
                    $zip->addFile($path_archivo,$nombre_archivo);
                }
            }
            $tablas_exportadas[]=$sufijo;
        }
        $zip->close();
        foreach($tablas_exportadas as $rdestino){
            $nombre = $prefijo_nombres.'_'.$rdestino;
            Loguear('2017-08-31', $prefijo_nombres);
            $this->db->ejecutar_sql(new Sql("DROP VIEW IF EXISTS encu.$nombre"));
        }
        return new Respuesta_Positiva(array(
            'html'=>"<h4>descargar <A href='$filename'>".preg_replace("#^((.*)/)*#","",$filename)."</A><br>con las siguientes bases generadas: ".implode(', ',$tablas_exportadas)." </h4>",
            'tipo'=>'html'
        ));
    }
}
?>