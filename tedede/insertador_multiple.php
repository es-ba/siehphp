<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "probador.php";
require_once "tablas.php";

class Insertador_multiple{
    var $metadatos;
    var $orden = 0;
    function sqls_insercion($metadatos,$tabla,$valores_definidos=array()){
        if(!$tabla){
            throw new Exception_Tedede("Falta la tabla");
        }
        $sqls=new Sqls();
        if($tabla!=NULL){
            $tabla->valores_para_insert=array();
            foreach($tabla->obtener_campos() as $nombre_campo=>$campo){
                $definido=FALSE;
                if(array_key_exists($nombre_campo,$metadatos)){
                    $valor=$metadatos[$nombre_campo];
                    $valores_definidos[$campo->nombre_sin_prefijo]=$valor;
                    $definido=TRUE;
                }else if((isset($tabla->definiciones_campo_originales[$nombre_campo]['hereda']) 
                            or isset($tabla->definiciones_campo_originales[$nombre_campo]['es_pk'])
                         )and array_key_exists($campo->nombre_sin_prefijo,$valores_definidos)){
                    $valor=$valores_definidos[$campo->nombre_sin_prefijo];
                    $definido=TRUE;
                }
                if($definido){
                    $tabla->valores_para_insert[$nombre_campo]=$valor;
                }
            }
            $campo_orden=$tabla->obtener_prefijo().'_orden';
            if($tabla->existe_campo($campo_orden)){
                $tabla->valores_para_insert[$campo_orden] = $this->orden++;
            }
            $sqls->agregar($tabla->sqls_insercion());
        }
        
        foreach($metadatos as $clave=>$datos){
            if(strpos($clave, 'Tabla_')===0){
                $tabla_nueva=$tabla->definicion_tabla(substr($clave,strlen('Tabla_')));
                foreach($datos as $registro){
                    $registros_tabla_incluida=$this->sqls_insercion($registro,$tabla_nueva,$valores_definidos);
                    if($tabla!=NULL and $tabla->depende_de($tabla_nueva->obtener_nombre_de_tabla())){
                        $sqls->poner_antes($registros_tabla_incluida);
                    }else{
                        $sqls->agregar($registros_tabla_incluida);
                    }
                }
            }else if(!$tabla->definicion_campo($clave)){
                throw new Exception_Tedede("no se encuentra el campo $clave en ".$tabla->obtener_nombre_de_tabla());
            }
        }
        return $sqls;
    }
}

class Tabla_de_ejemplo_para_insertador_multiple2 extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('ejeim2');
        $this->con_campos_auditoria=false;
        $this->definir_esquema('de_ejemplo');
        $this->definir_campo('ejeim2_uno',array('es_pk'=>true,'tipo'=>'texto','largo'=>50));
        $this->definir_campo('ejeim2_tres',array('tipo'=>'entero'));
    }
}

class Tabla_de_ejemplo_para_insertador_multiple3 extends Tabla_de_ejemplo_para_insertador_multiple2{
    function definicion_estructura(){
        $this->definir_prefijo('');
        $this->con_campos_auditoria=false;
        parent::definicion_estructura();
    }
}

class Tabla_de_ejemplo_para_insertador_multiple extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('ejeim');
        $this->con_campos_auditoria=false;
        $this->definir_esquema('de_ejemplo');
        $this->definir_campo('ejeim_uno',array('es_pk'=>true,'tipo'=>'texto','largo'=>50));
        $this->definir_campo('ejeim_dos',array('tipo'=>'entero'));
    }
    function depende_de($tabla){
        if($tabla=='de_ejemplo_para_insertador_multiple3'){
            return true;
        }
    }
}


class Prueba_Insertador_multiple extends Pruebas{
    function probar_error_de_un_campo_inexistente(){
        $metadatos=array(
            'Tabla_de_ejemplo_para_insertador_multiple'=>array(
                array(
                    'ejeim_uno'=>'primer texto',
                    'ejeim_tres'=>11
                )
            )
        );
        $insertador=new Insertador_multiple();
        try{
            $insertador->sqls_insercion($metadatos,new Tabla_de_ejemplo_para_insertador_multiple());
            $this->probador->informar_error('debió dar error porque no existe el campo ejeim_tres en la tabla ejeim');
        }catch(Exception_Tedede $e){
        }
    }
    function probar_insercion_simple(){
        $metadatos=array(
            array(
                'ejeim_uno'=>'primer texto',
                'ejeim_dos'=>11
            ), 
            array(
                'ejeim_dos'=>22
            )
        );
        $insertador=new Insertador_multiple();
        $this->probador->verificar_sqls(
            new Sql(
                'insert into de_ejemplo.de_ejemplo_para_insertador_multiple(ejeim_uno, ejeim_dos) values (:ejeim_uno, :ejeim_dos)',
                array(':ejeim_uno'=>'primer texto', ':ejeim_dos'=>11)
            ),
            $insertador->sqls_insercion($metadatos[0],new Tabla_de_ejemplo_para_insertador_multiple())
        );
        $this->probador->verificar_sqls(
            new Sql(
                'insert into de_ejemplo.de_ejemplo_para_insertador_multiple(ejeim_dos) values (:ejeim_dos)',
                array(':ejeim_dos'=>22)
            ),
            $insertador->sqls_insercion($metadatos[1],new Tabla_de_ejemplo_para_insertador_multiple())
        );
    }
    function probar_insercion_encadenada(){
        $metadatos=array(
            'ejeim_uno'=>'primer texto',
            'ejeim_dos'=>11,
            'Tabla_de_ejemplo_para_insertador_multiple2'=>array(
                array('ejeim2_uno'=>'uno',
                      'ejeim2_tres'=>3
                ),
                array('ejeim2_tres'=>33
                )
            )
        );
        $insertador=new Insertador_multiple();
        $this->probador->verificar_sqls(
            array(
                new Sql(
                    'insert into de_ejemplo.de_ejemplo_para_insertador_multiple(ejeim_uno, ejeim_dos) values (:ejeim_uno, :ejeim_dos)',
                    array(':ejeim_uno'=>'primer texto', ':ejeim_dos'=>11)
                ),
                new Sql(
                    'insert into de_ejemplo.de_ejemplo_para_insertador_multiple2(ejeim2_uno, ejeim2_tres) values (:ejeim2_uno, :ejeim2_tres)',
                    array(':ejeim2_uno'=>'uno', ':ejeim2_tres'=>3)
                ),
                new Sql(
                    'insert into de_ejemplo.de_ejemplo_para_insertador_multiple2(ejeim2_uno, ejeim2_tres) values (:ejeim2_uno, :ejeim2_tres)',
                    array(':ejeim2_uno'=>'primer texto', ':ejeim2_tres'=>33)
                )
            ),
            $insertador->sqls_insercion($metadatos,new Tabla_de_ejemplo_para_insertador_multiple())
        );
    }
    function probar_insercion_encadenada_inversa(){
        $metadatos=array(
            'ejeim_uno'=>'primer texto',
            'ejeim_dos'=>11,
            'Tabla_de_ejemplo_para_insertador_multiple3'=>array(
                array('ejeim2_tres'=>33
                )
            )
        );
        $insertador=new Insertador_multiple();
        $this->probador->verificar_sqls(
            array(
                new Sql(
                    'insert into de_ejemplo.de_ejemplo_para_insertador_multiple3(ejeim2_uno, ejeim2_tres) values (:ejeim2_uno, :ejeim2_tres)',
                    array(':ejeim2_uno'=>'primer texto', ':ejeim2_tres'=>33)
                ),
                new Sql(
                    'insert into de_ejemplo.de_ejemplo_para_insertador_multiple(ejeim_uno, ejeim_dos) values (:ejeim_uno, :ejeim_dos)',
                    array(':ejeim_uno'=>'primer texto', ':ejeim_dos'=>11)
                )
            ),
            $insertador->sqls_insercion($metadatos,new Tabla_de_ejemplo_para_insertador_multiple())
        );
    }
    function probar_cosas_que_faltan_programar(){
        $this->probador->pendiente_de_especificar('Debe blanquear ');
        
    }
}

?>