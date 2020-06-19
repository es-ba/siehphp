<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tabla_operativos.php";
require_once "nuestro_mini_yaml_parse.php";
require_once "insertador_multiple.php";

class Metadatos_etoi203 extends Objeto_de_la_base{ 
    private $metadatos_ajus;
    function __construct(){
        parent::__construct();
        $this->definir_esquema($GLOBALS['esquema_principal']);
    }
    function ejecutar_instalacion($con_dependientes=true){
        $via_json=true;
        // $via_json=false;
        if($via_json){
            $separador=";/*FIN*/\n";
            $json=json_decode(json_arreglar(file_get_contents('..\operaciones_etoi203\etoi203_dump.json')),true);
            if(!$json){
                throw new Exception_Tedede("Error al parsear el json etoi203_dump.json. Error ".json_str_error());
            }
            $sentencias="";
            foreach($json['tablas'] as $tabla=>$contenido){
                $this->contexto->salida->enviar('Levantando el json para las tablas dependientes de '.$tabla);
                $sentencias.=json_generar_insert($GLOBALS['esquema_principal'],$tabla,$contenido,$separador,$json['jerarquia'], array('tlg'=>1));
            }
            // Loguear('2014-06-14',"**********\n".$sentencias,null,null,true);
        }else{
            $separador=";\n";
            $sentencias=file_get_contents('..\operaciones_etoi203\migraciones\metadatos.sql');
        }
        foreach(explode($separador,$sentencias) as $sentencia){
            if($sentencia){
                $this->contexto->db->ejecutar_sql(new Sql($sentencia));
            }
        }
    }
    function instalar_tem_de_prueba(){
        $tabla_tem=$this->contexto->nuevo_objeto("Tabla_TEM");
        if($cuantos=$tabla_tem->contar_cuantos(array())){ // CORRECTO UN = DE ASIGNACIÓN
            throw new Exception_Tedede("No se pueden agregar registros de capacitacion a la TEM porque ya tiene $cuantos");
        }else{
            for ($conjunto = 1; $conjunto <= 1; $conjunto++) {
                for ($recepcionista = 1; $recepcionista <= 17; $recepcionista++) {
                    if($recepcionista<=15){
                        $replica=$conjunto%6+1;
                        $comuna=$recepcionista;
                        $dominio=3;
                    }else{
                        $comuna=$conjunto;
                        if($recepcionista==16){
                            $dominio=4;
                            $replica=8;
                        }else if($recepcionista==17){
                            $dominio=5;
                            $replica=7;
                        }else{
                            $dominio=3;
                            $replica=$conjunto%6+1;
                        }
                        $comuna=$conjunto;
                    }
                    foreach(array(
                        array('RIOBAMBA'                   ,23,''   ,'' ,1),
                        array('RIOBAMBA'                   ,27,''   ,'' ,1),
                        array('RIOBAMBA'                   ,26,''   ,'' ,1),
                        array('ENTRE RÍOS'                 ,99,'4'  ,'A',2),
                        array('ENTRE RÍOS'                 ,99,'8'  ,'B',2),
                        array('ENTRE RÍOS'                 ,99,'18' ,'A',2),
                        array('ENTRE RÍOS'                 ,99,'19' ,'C',2),
                        array('AVENIDA DEL BARCO CENTENERA',44,''   ,'' ,3),
                        array('BOLIVAR'                    ,21,''   ,'' ,4),
                        array('NUÑEZ'                      ,38,''   ,'' ,4),
                    ) as $renglon=>$direccion
                    ){
                        $tabla_tem->valores_para_insert=array(
                            'tem_enc'=>$replica*100000+$comuna*1000+$conjunto*10+$renglon,
                            'tem_comuna'=>$comuna,
                            'tem_replica'=>$replica,
                            'tem_lote'=>$conjunto+$comuna*100,
                            'tem_up'=>$conjunto,
                            'tem_clado'=>$direccion[4],
                            'tem_cnombre'=>$direccion[0],
                            'tem_hn'=>$direccion[1],
                            'tem_hp'=>$direccion[2],
                            'tem_hd'=>$direccion[3],
                            'tem_dominio'=>$dominio,
                        );
                        $tabla_tem->ejecutar_insercion();
                    }
                }
            }
            $this->contexto->db->ejecutar_sql(new Sql("update tem set tem_dominio=case tem_replica when 8 then 4 when 7 then 5 else 3 end; "));
            if($GLOBALS['NOMBRE_APP']=='etoi203'){
                $this->contexto->db->ejecutar_sql(new Sql("update tem set tem_participacion=case tem_replica when 1 then 3 when 2 then 3 when 3 then 2 when 4 then 2 else 1 end; "));
            }else{
                throw new Exception_Tedede("hay que definir la conversion de replicas en participacion para {$GLOBALS['NOMBRE_APP']}");
            }
            $this->contexto->db->ejecutar_sql(new Sql("INSERT INTO claves (cla_ope, cla_for, cla_mat, cla_enc, cla_tlg)   SELECT 'etoi203','TEM','',tem_enc,tem_tlg     FROM tem; "));
        }
    }
    function instalar_personal_para_capacitacion(){
        $tabla_per=$this->contexto->nuevo_objeto("Tabla_personal");
        $tabla_usuarios=$this->contexto->nuevo_objeto("Tabla_usuarios");
        $tabla_per->agregar_columna_si_no_existe('per_dominio');
        $tabla_per->agregar_columna_si_no_existe('per_comuna');
        $tabla_per->agregar_columna_si_no_existe('per_usu');
        if($cuantos=$tabla_per->contar_cuantos(array('per_ope'=>$GLOBALS['NOMBRE_APP']))){ // CORRECTO UN = DE ASIGNACIÓN
            throw new Exception_Tedede("No se pueden agregar registros de capacitacion a la tabla de personal porque ya tiene $cuantos");
        }else{
            for ($recepcionista = 1; $recepcionista <= 17; $recepcionista++) {
                for ($conjunto = 1; $conjunto <= 5; $conjunto++) {
                    if($recepcionista<=15){
                        $replica=$conjunto%6+1;
                        $comuna=$recepcionista;
                        $dominio=3;
                    }else{
                        $comuna=NULL;
                        if($recepcionista<=16){
                            $dominio=4;
                            $replica=8;
                        }else{
                            $dominio=5;
                            $replica=7;
                        }
                        $comuna=$conjunto;
                    }
                    $tabla_per->valores_para_insert=array(
                        'per_ope'=>$GLOBALS['NOMBRE_APP'],
                        'per_nombre'=>'ENCUESTADOR '.$conjunto,
                        'per_apellido'=>'DEL RECEP'.$recepcionista,
                        'per_comuna'=>$comuna,
                        'per_dominio'=>$dominio,
                        'per_per'=>$recepcionista*10+$conjunto,
                        'per_rol'=>'encuestador'
                    );
                    $tabla_per->ejecutar_insercion();
                }
                $nombre_usuario='recep'.$recepcionista;
                $tabla_per->valores_para_insert=array(
                    'per_ope'=>$GLOBALS['NOMBRE_APP'],
                    'per_nombre'=>'RECEPCIONISTA '.$recepcionista,
                    'per_apellido'=>'DE CAMPO',
                    'per_comuna'=>$comuna,
                    'per_dominio'=>$dominio,
                    'per_per'=>200+$recepcionista,
                    'per_rol'=>'recepcionista',
                    'per_usu'=>$nombre_usuario,
                );
                $tabla_usuarios->valores_para_insert=array(
                    'usu_usu'=>$nombre_usuario,
                    'usu_rol'=>'recepcionista',
                    'usu_clave'=>md5('clave'.$recepcionista.$nombre_usuario),
                    'usu_activo'=>true,
                    'usu_nombre'=>$tabla_per->valores_para_insert['per_nombre'],
                    'usu_apellido'=>$tabla_per->valores_para_insert['per_apellido'],
                    'usu_interno'=>'PARA CAPACITACIÓN',
                );
                $tabla_usuarios->ejecutar_insercion();
                $tabla_per->ejecutar_insercion();
                $nombre_usuario='recup'.$recepcionista;
                $tabla_per->valores_para_insert=array(
                    'per_ope'=>$GLOBALS['NOMBRE_APP'],
                    'per_nombre'=>'RECUPERADOR '.$recepcionista,
                    'per_apellido'=>'DE CAMPO',
                    'per_comuna'=>$comuna,
                    'per_dominio'=>$dominio,
                    'per_per'=>300+$recepcionista,
                    'per_rol'=>'recuperador',
                    'per_usu'=>$nombre_usuario,
                );
                $tabla_per->ejecutar_insercion();
                $nombre_usuario='superv'.$recepcionista;
                $tabla_per->valores_para_insert=array(
                    'per_ope'=>$GLOBALS['NOMBRE_APP'],
                    'per_nombre'=>'SUPERVISOR '.$recepcionista,
                    'per_apellido'=>'DE CAMPO',
                    'per_comuna'=>$comuna,
                    'per_dominio'=>$dominio,
                    'per_per'=>400+$recepcionista,
                    'per_rol'=>'supervisor',
                    'per_usu'=>$nombre_usuario,
                );
                $tabla_per->ejecutar_insercion();
            }
        }
    }
}

class Tablas_planas extends Objeto_de_la_base{ 
    function __construct(){
        parent::__construct();
        $this->definir_esquema($GLOBALS['esquema_principal']);
    }
    function ejecutar_instalacion($con_dependientes=true){
        $tabla_matrices=$this->contexto->nuevo_objeto('Tabla_matrices');
        $tabla_matrices->leer_varios(array('mat_ope'=>$GLOBALS['NOMBRE_APP']));
        while($tabla_matrices->obtener_leido()){
          if ($tabla_matrices->datos->mat_for!='TEM'){
        // if ($tabla_matrices->datos->mat_for=='A1'){    
                $tra_for=$tabla_matrices->datos->mat_for;
                $tra_mat=$tabla_matrices->datos->mat_mat;
                Tabla_planas::crear_jsones($this->contexto,$tra_for,$tra_mat);
                $tabla_plana=$this->contexto->nuevo_objeto("Tabla_plana_{$tra_for}_{$tra_mat}");
                $tabla_plana->ejecutar_instalacion($con_dependientes);
        // } 
         } 
       }
    }
    function crear_jsones(){
        $tabla_matrices=$this->contexto->nuevo_objeto('Tabla_matrices');
        $tabla_matrices->leer_varios(array('mat_ope'=>$GLOBALS['NOMBRE_APP']));
        while($tabla_matrices->obtener_leido()){
            $tra_for=$tabla_matrices->datos->mat_for;
            $tra_mat=$tabla_matrices->datos->mat_mat;
            Tabla_planas::crear_jsones($this->contexto,$tra_for,$tra_mat);
        }
    }
}

?>