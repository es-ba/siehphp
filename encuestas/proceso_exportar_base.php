<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_exportar_base extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->tabla_baspro=$this->nuevo_objeto("Tabla_baspro");
        $tabla_baspro=$this->tabla_baspro;        
        $this->definir_parametros(array('titulo'=>(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015)?'Bases producidas exportar - Modo '. $_SESSION['modo_encuesta']:'Bases producidas exportar',
            'submenu'=>'procesamiento',
            'permisos'=>array('grupo'=>'procesamiento'),
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_baspro'=>array('label'=>'base','def'=>'base_cv','opciones'=>$tabla_baspro->lista_opciones(array('baspro_ope'=>$GLOBALS['NOMBRE_APP']))),
                'tra_estado_desde'=>array('label'=>'estado desde','def'=>'77','style'=>'width:40px'),
                'tra_estado_hasta'=>array('label'=>'estado hasta','def'=>'79','style'=>'width:40px'),
                'tra_filtro_sector'=>array('label'=>'sector_b_s','style'=>'width:40px', 'invisible'=>substr($GLOBALS['NOMBRE_APP'],0,4)=='empa'?false:true),
                'tra_filtro_ue'=>array('label'=>'ue','def'=>'2','style'=>'width:40px', 'invisible'=>substr($GLOBALS['NOMBRE_APP'],0,4)=='empa'?false:true),
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
        $val_filtro_sector='';
        $val_filtro_ue='';
        if(substr($GLOBALS['NOMBRE_APP'],0,4)=='empa'){
            $val_filtro_sector='s'.$this->argumentos->tra_filtro_sector;     
            $val_filtro_ue='u'.$this->argumentos->tra_filtro_ue;
        }
        if(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015){
            $vtitulo_modo='_'.$_SESSION['modo_encuesta'];
            $val_modo= ($_SESSION['modo_encuesta']=='ETOI')?$_SESSION['modo_encuesta']:$GLOBALS['NOMBRE_APP'];
        }    
        $nombre_base=sanitizar_sql($this->argumentos->tra_baspro);
        $prefijo_nombres=$GLOBALS['nombre_app'].'_'.$nombre_base;
        $zip = new ZipArchive();
        $filename = "../export/$prefijo_nombres".
            ($this->argumentos->tra_estado_desde!=79||$this->argumentos->tra_estado_hasta!=79?'_estados_'.($this->argumentos->tra_estado_desde+0).'a'.($this->argumentos->tra_estado_hasta+0):'').
            $vtitulo_modo.$val_filtro_sector.$val_filtro_ue.".zip";
        if(file_exists($filename)){
            unlink($filename);
        }
        if ($zip->open($filename, ZipArchive::CREATE)!==TRUE) {
            return new Respuesta_negativa("no se puede crear el zip <$filename>\n");
        }
        $bases_existentes=array();
        foreach(array('hogar','personas','exm','exm_men') as $destino){
            list($sufijo,$destino2,$no_exportar,$exportar_en)=caracterizar_destino($destino);
            $app=$GLOBALS['nombre_app'];
            $clausula_where_var="basprovar_baspro = '$nombre_base' and basprovar_ope = '$app' and (encu.destino_variable(basprovar_var,basprovar_baspro) in $destino2 or basprovar_exportar_en in $exportar_en) and (basprovar_exportar_en is null or basprovar_exportar_en not in $no_exportar)";
            $cursor=$this->db->ejecutar_sql(new Sql(
                "SELECT count(*) as cant FROM baspro_var WHERE {$clausula_where_var} and basprovar_exportar_en is distinct from 'ambas'"
            ));
            $cantidad_columnas_no_ambiguas_arr=$cursor->fetch(PDO::FETCH_ASSOC);
            $cantidad_columnas_no_ambiguas=$cantidad_columnas_no_ambiguas_arr['cant'];
            Loguear('2014-12-02','************************ YA ESTAMOS EN DICIEMBRE {$v}: '.$cantidad_columnas_no_ambiguas);
            if($cantidad_columnas_no_ambiguas){
              $curs=$this->db->ejecutar_sql(new Sql(<<<SQL
                 select variables_base_producida(:base,:nombre,:desde,:hasta,:modoenc,:filtro_sector,:filtro_ue)
SQL
                  ,array(
                    ':base'=>"base$destino",
                    ':nombre'=>$nombre_base,
                    ':desde'=>$this->argumentos->tra_estado_desde,
                    ':hasta'=>$this->argumentos->tra_estado_hasta,
                    ':modoenc'=>$val_modo,
                    ':filtro_sector'=>$this->argumentos->tra_filtro_sector==''?0:$this->argumentos->tra_filtro_sector, //"$val_filtro_sector", si toman la variable tipo texto
                    ':filtro_ue'=>$this->argumentos->tra_filtro_ue==''?0:$this->argumentos->tra_filtro_ue,
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
                  select distinct table_name from information_schema.columns where table_schema = 'encu' and table_name = '$nombre'
SQL
              ));
              while($vista=$curs_vista->fetch(PDO::FETCH_ASSOC)){
                $bases_existentes[] = $destino;
              }
            }
        }
        $tablas_exportadas=array();
        foreach($bases_existentes as $v){
            list($sufijo,$destino,$no_exportar,$exportar_en)=caracterizar_destino($v);
            $clausula_where_var="basprovar_baspro = '$nombre_base' and basprovar_ope = '$app' and (encu.destino_variable(basprovar_var,basprovar_baspro) in $destino or basprovar_exportar_en in $exportar_en) and (basprovar_exportar_en is null or basprovar_exportar_en not in $no_exportar)";
            foreach(array(
                'datos'=>  array('tabla'=>$prefijo_nombres.'_'.$v,
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
                'disenio'=>array('tabla'=>'baspro_var',
                                 'campos'=>'coalesce(basprovar_alias,basprovar_var) as columna, encu.nombre_largo_para_documentacion(basprovar_var,basprovar_baspro) as descripcion',
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
                'sintaxis'=>array('tabla'=>'baspro_var',
                                 'campos'=>'coalesce(basprovar_alias,basprovar_var) as columna, encu.formato_variable(basprovar_var,basprovar_baspro) as formato',
                                 'clausula_where'=>$clausula_where_var,
                                 'order_by'=>'basprovar_orden',
                                 'agrego_sufijo'=>$sufijo.'_sintaxis',
                                 'texto_previo'=>'SET UNICODE = ON.'."\r\n".'SET OLANG=SPANISH. '."\r\n"."SET LOCALE='English'."."\r\n".'GET DATA '."\r\n".'/TYPE=TXT '."\r\n"."/FILE=\"{$prefijo_nombres}_{$sufijo}{$vtitulo_modo}{$val_filtro_sector}{$val_filtro_ue}.txt\"  /*ATENCION: Agregar antes del nombre de archivo, el path de su ubicación*/ "."\r\n".'/DELCASE=LINE '."\r\n".'/DELIMITERS=";" '."\r\n".'/ARRANGEMENT=DELIMITED '."\r\n".'/FIRSTCASE=2 '."\r\n".'/IMPORTCASE=ALL '."\r\n".'/VARIABLES='."\r",
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
                loguear('2017-04-01', $script);
                $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
                $script 
SQL
                ));
                $tiene_datos=false;
                $nombre_archivo=$prefijo_nombres.'_'.$definicion['agrego_sufijo'].$vtitulo_modo.$val_filtro_sector.$val_filtro_ue.$definicion['extension'];
                $path_archivo='../export/'.$nombre_archivo;
                $f=fopen($path_archivo,'w');
                while($fila=$cursor->fetch(PDO::FETCH_ASSOC)){
                    if(!$tiene_datos){ // es primera fila
                        if($definicion['texto_previo']!=''){
                            fwrite($f,$definicion['texto_previo']);
                        }else{
                            fwrite($f,implode(';',array_keys($fila))."\r\n");
                        }
                        if(!$sin_pk){
                            fwrite($f,$definicion['texto_previo_pk']);
                            if($sufijo=='ind'){
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
            $tablas_exportadas[]=$v;
        }
        $zip->close();
        foreach(array('hogar','personas','exm','exm_men') as $destino){
            $nombre = $prefijo_nombres.'_'.$destino;
            $this->db->ejecutar_sql(new Sql("DROP VIEW IF EXISTS encu.$nombre"));
        }
        return new Respuesta_Positiva(array(
            'html'=>"<h4>descargar <A href='$filename'>".preg_replace("#^((.*)/)*#","",$filename)."</A><br>con las siguientes bases generadas: ".implode(', ',$tablas_exportadas)." </h4>",
            'tipo'=>'html'
        ));
    }
}

function caracterizar_destino($v){
    if($v=='hogar'){
        $sufijo='hog';
        $destino="('hog')";
        $no_exportar="('mie','exm')";
        $exportar_en="('ambas')";
    }else if($v=='exm'){
        $sufijo='exm';
        $destino="('exm')";
        $no_exportar="('hog','mie')";
        $exportar_en="('ambas','exm')";
    }else if($v=='exm_men'){
        $sufijo='exm';
        $destino="('exm_menu')";
        $no_exportar="('hog','mie')";
        $exportar_en="('ambas','exm_men')";
    }else{
        $sufijo='ind';
        $destino="('mie')";
        $no_exportar="('hog','exm')";
        $exportar_en="('ambas','mie')";
    }
    return array(
        $sufijo,
        $destino,
        $no_exportar,
        $exportar_en
    );
}
?>