<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_cargar_requerimiento extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $tabla_proy_usu=$this->nuevo_objeto("Tabla_proy_usu");    
        $tabla_tiporeq=$this->nuevo_objeto("Tabla_tipo_req");
        $tabla_usuarios=$this->nuevo_objeto("Tabla_usuarios");
        /*
        $mostrar_plazo=true;
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT max(proy_plazovisible::text)::boolean as visible 
              FROM proy_usu u
                LEFT JOIN proyectos p ON u.proyusu_proy=p.proy_proy              
              WHERE proyusu_usu=:usuario
SQL
            ,array(':usuario'=>usuario_actual())
        ));
        $fila=$cursor->fetchObject();
        if($fila){
            $mostrar_plazo=$fila->visible;
        }
        */
        $this->definir_parametros(array(   
            'titulo'=>'Nuevo',
            'submenu'=>'requerimientos',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_proy'=>array('label'=>'proyecto','style'=>'width:100px','opciones'=>$tabla_proy_usu->lista_opciones(array('proyusu_usu'=>usuario_actual())), 'td_colspan'=>3),
                'tra_req'=>array('label'=>'código','style'=>'width:100px', 'aclaracion'=>'dejar en blanco para asignar el próximo número', 'placeholder'=>'auto','td_width'=>110,'tipo'=>'entero'),
                'tra_titulo'=>array('label'=>'título','style'=>'width:600px', 'td_colspan'=>3, 'sobre_aclaracion'=>'Resuma en el título del requerimiento qué necesita y qué diferencia esta necesidad de otras pasadas o futuras (trate de no excederse del renglón)'), 
                'tra_tiporeq'=>array('label'=>'tipo','style'=>'width:100px','opciones'=>$tabla_tiporeq->lista_opciones(array()), 'td_colspan'=>3, 'def'=>'funcional'), 
                'tra_prioridad'=>array('label'=>'prioridad', 'style'=>'width:50px', 'td_colspan'=>1, 'tipo'=>'entero','aclaracion'=>'1=baja prioridad, 5=máxima prioridad'), 
                'tra_grupo'=>array('label'=>'grupo', 'td_colspan'=>1, 'aclaracion'=>'grupo de trabajo que tiene la necesidad'),                
                'tra_componente'=>array('label'=>'componente', 'td_colspan'=>1, 'aclaracion'=>'parte o módulo del sistema sobre el que se pide el requerimiento'), 
                'tra_detalles'=>array('id'=>'tra_detalles','label'=>'detalle','style'=>'width:700px;height:200px;font-size:80%', 'td_colspan'=>3,'type'=>'textarea', 'sobre_aclaracion'=>'Indique los detalles que complementen el pedido, recuerde poner ejemplos de códigos de encuesta, formularios o los parámetros necesarios para verificar lo pedido'),
                //'tra_mostrarplazo'=>array('label'=>'MostrarPlazo', 'td_colspan'=>1, 'aclaracion'=>'Define la visibilidad de la variable plazo','invisible'=>false),                
                'tra_plazo'=>array('label'=>'plazo', 'td_colspan'=>1, 'aclaracion'=>'Fecha de plazo para la finalización del requerimiento' /*,'invisible'=>! $mostrar_plazo*/),                
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_cargar_requerimiento','value'=>'cargar >>'),
        ));
    }
    function correr(){
        $proyecto="";
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT max(proyusu_proy) as proyecto 
              FROM proy_usu 
              WHERE proyusu_usu=:usuario
              HAVING max(proyusu_proy)=min(proyusu_proy)
SQL
            ,array(':usuario'=>usuario_actual())
        ));
        $fila=$cursor->fetchObject();
        if($fila){
            $this->parametros->parametros['tra_proy']['def']=$fila->proyecto;
            $proyecto=$fila->proyecto;
        }
        /*
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT proy_plazovisible as plazovisible 
              FROM proyectos 
              WHERE proy_proy=:proy
SQL
            ,array(':proy'=>$proyecto)
        ));
        $fila=$cursor->fetchObject();
        if($fila){
            $mostrar_plazo=$fila->plazovisible;
            $this->parametros->parametros['tra_mostrarplazo']['def']=$fila->plazovisible;
        }
        */
        parent::correr();
        $this->salida->enviar_script(<<<JS
            function validar_boton_cargar_requerimiento(){
                boton_cargar_requerimiento.disabled=!tra_prioridad.value || tra_prioridad.value>10;
                if(tra_prioridad.value>5){
                    aclaracion_tra_prioridad.style.backgroundColor='#F44';
                }else{
                    aclaracion_tra_prioridad.style.backgroundColor='';
                }
                if(tra_prioridad.value>10 || !tra_prioridad.value && !!tra_titulo.value){
                    tra_prioridad.style.backgroundColor='#F84';
                }else{
                    tra_prioridad.style.backgroundColor='';
                }
            }
            window.addEventListener('load',function(){
                tra_prioridad.onblur=validar_boton_cargar_requerimiento;
                validar_boton_cargar_requerimiento();
            });
JS
        );
        /*
        $this->salida->enviar_script(<<<JS
            function habilitar_y_deshabilitar_plazo(){
               var vproyecto = document.getElementById("tra_proy");
               var vplazo    = document.getElementById("tra_plazo");
               vplazo.disabled =!/IPCBA/.test(vproyecto.value);
            }
            window.addEventListener('load',function(){
                setInterval(habilitar_y_deshabilitar_plazo,1000);
            });
JS
        );
        */
    }
    function responder(){
        global $esta_es_la_base_en_produccion;
        $tabla_requerimientos = new tabla_requerimientos();
        $tabla_requerimientos->contexto=$this;
        if(!$this->argumentos->tra_proy ){
            return new Respuesta_Negativa('Debe especificar proyecto');
        }
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT 1 as usuario_del_proyecto 
              FROM proy_usu 
              WHERE proyusu_usu=:usuario and proyusu_proy=:proy
SQL
            ,array(':usuario'=>usuario_actual(), ':proy'=>$this->argumentos->tra_proy)
        ));
        $fila=$cursor->fetchObject();
        if(!$fila){
            return new Respuesta_Negativa('Usuario no registrado en el proyecto donde quiere cargar el requerimiento');
        }        
        
        if(!$this->argumentos->tra_req){
            //return new Respuesta_Negativa('Debe especificar un código de requerimiento');
            $this->argumentos->tra_req = $tabla_requerimientos->obtener_maximo(array(
                'req_proy'=>$this->argumentos->tra_proy
            ), 'case when es_numero(req_req) then req_req::numeric else 0::numeric end')+1;
        }
        if(!$this->argumentos->tra_titulo){
            return new Respuesta_Negativa('Debe especificar un título de requerimiento');
        }
        if(!$this->argumentos->tra_tiporeq){
            return new Respuesta_Negativa('Debe especificar un tipo de requerimiento');
        }
        if($this->argumentos->tra_prioridad){
            if(!is_numeric($this->argumentos->tra_prioridad)){
                return new Respuesta_Negativa('La prioridad debe ser un número');
            }
        }
        
        if(!$this->argumentos->tra_detalles){
            return new Respuesta_Negativa('Debe especificar el detalle del requerimiento');
        }
        $tabla_requerimientos->leer_uno_si_hay(array(
            'req_proy'=>$this->argumentos->tra_proy,        
            'req_req'=>$this->argumentos->tra_req,
        ));        
        if($tabla_requerimientos->obtener_leido()){
            return new Respuesta_Negativa('Ya existe un requerimiento con ese código');
        }
        $tabla_requerimientos->valores_para_insert=(array(
            'req_proy'       =>$this->argumentos->tra_proy,
            'req_req'        =>$this->argumentos->tra_req,
            'req_titulo'     =>$this->argumentos->tra_titulo,
            'req_tiporeq'    =>$this->argumentos->tra_tiporeq,
            'req_prioridad'  =>$this->argumentos->tra_prioridad,            
            'req_grupo'      =>$this->argumentos->tra_grupo,
            'req_componente' =>$this->argumentos->tra_componente,
            'req_detalles'   =>$this->argumentos->tra_detalles,
            'req_plazo'      =>($this->argumentos->tra_plazo == "" ? null : $this->argumentos->tra_plazo),
            
        ));
        $tabla_requerimientos->ejecutar_insercion();
        $this->salida=new Armador_de_salida(true);
        $this->salida->abrir_grupo_interno('editor_tabla',array('tipo'=>'table','border'=>'single', 'style'=>'width:100%'));             
            $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));    
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td','style'=>'width:15%'));  
                    $this->salida->enviar('','',array());
                $this->salida->cerrar_grupo_interno();
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td','style'=>'width:50%'));  
                    $this->salida->enviar('El requerimiento fue ingresado con éxito - Código de requerimiento: '.$this->argumentos->tra_req);
                $this->salida->cerrar_grupo_interno();
                $this->salida->enviar_script("ir_a_url('siscen.php?hacer=agregar_novedades_req&todo='+encodeURIComponent('{\"tra_proy\":\"".$this->argumentos->tra_proy."\",\"tra_req\":\"".$this->argumentos->tra_req."\"}')+'&y_luego=buscar')");
            $this->salida->cerrar_grupo_interno();
        $this->salida->cerrar_grupo_interno();            
        return $this->salida->obtener_una_respuesta_HTML();
    }
}
?>