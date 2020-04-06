<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_cargar_dispositivo extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Cargar dispositivo (v 2.43)',
            'submenu'=>PROCESO_INTERNO,
            'permisos'=>array('grupo'=>'recepcionista'),
            'para_produccion'=>false,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_rol'=>array(
                    'tipo'=>'entero',
                    'label'=>'Rol',
                    'def'=>'1',
                    'opciones'=>array(
                        '1'=>array('1','encuestador'),
                        '2'=>array('2','recuperador'),
                        '3'=>array('3','supervisor'),
                    ),
                    'style'=>'width:60px'
                ),
                'tra_cod_per'=>array('tipo'=>'entero','label'=>'Número de la persona','style'=>'width:60px'),
                'tra_fecha_hora'=>array('invisible'=>true,'tipo'=>'fecha','def'=>date_format(new DateTime(), "Y-m-d H:i:s")),
            ),
            'bitacora'=>true,
            'botones'=>array(
                array('id'=>'boton_cargar_dispositivo','value'=>'cargar','onclick'=>'cargar_dispositivo(true)'),
                array('id'=>'boton_descargar_dispositivo','value'=>'descargar','style'=>'background-color:yellow','onclick'=>'descargar_dispositivo(false,true)'),
                array('id'=>'boton_descargar_dispositivo_resto','value'=>'descargar el resto','style'=>'background-color:yellow; visibility:hidden','onclick'=>'descargar_dispositivo(true,true)'),
                array('id'=>'boton_descargar_dispositivo_completo','value'=>'descarga rápida','style'=>'background-color:yellow','onclick'=>'descargar_dispositivo(false,true,true)'),
            ),
            'cuando_un_paso'=>'pasar_uds_leidas_a_localStorage_y_sacarlas_del_voy_por',
            'script_arranque'=><<<JS
                document.getElementById('tra_rol').value=buscar_rol();
                document.getElementById('tra_rol').disabled=buscar_rol()==3;
JS
        ));
        $this->sin_interrumpir=true;   
    }
    function correr(){
        global $auto_capa;
        $tra_cod_per_def='';
        $or_capacitando_1='';
        if(@$auto_capa=='EVALUACION'){
            if(!isset($_SESSION['capaeah2015_encuestador'])){
                $cursor=$this->db->ejecutar_sql(new Sql("
                    update operaciones.capacitaciones 
                      set valor=(
                        select min(pla_cod_enc) 
                          from encu.plana_tem_
                          where pla_estado=22
                            and pla_cod_enc>valor::integer)
                      where variable='prox_encuestador'
                      returning valor"
                ));
                $fila=$cursor->fetchObject();
                $_SESSION['capaeah2015_encuestador']=$fila->valor;
            }
            $tra_cod_per_def=$this->parametros->parametros['tra_cod_per']['def']=$_SESSION['capaeah2015_encuestador'];
            $or_capacitando_1=' || hoja_de_ruta.per==1';
        }
        parent::correr();
        $ahora=date_format(new DateTime(), "Y-m-d H:i:s");
        $this->salida->enviar_script(<<<JS
var hoja_de_ruta;
        
function controlar_hoja_de_ruta_es_seguro(cargar_o_descargar){
"use strict";
    var rta={};
    var ok=false;
    var encuestas;
    var razon;
    var vfecha_hora=fecha_amd_hora_hms() ; 
    var json_hoja_de_ruta=localStorage.getItem('hoja_de_ruta');
    if(!json_hoja_de_ruta){
        encuestas=[];
    }else{
        hoja_de_ruta=JSON.parse(json_hoja_de_ruta);
        encuestas=array_keys(hoja_de_ruta.encuestas);
    }
    if(!encuestas.length){
        ok=cargar_o_descargar=='cargar';
        if(!ok){
            razon='No hay encuestas almacenadas en este dispositivo';
        }
    }else if(cargar_o_descargar=='descargar'){
        enviar_paquete({
            proceso:'controlar_estado_carga',
            paquete:{
                tra_lista_enc:JSON.stringify(encuestas),
                tra_ope:'{$GLOBALS['nombre_app']}',
                tra_para_que:cargar_o_descargar,
                tra_rol:hoja_de_ruta.sufijo_rol,
                tra_fecha_hora:vfecha_hora,
            },
            cuando_ok:function(mensaje){
                rta=mensaje;
                ok=mensaje.ok;
            },
            asincronico:false
        });
        razon=rta.atencion;
    }else if(cargar_o_descargar=='cargar'){
        ok=localStorage.getItem('estado_carga')=='descargado' {$or_capacitando_1};
        var rta = prompt('No hay registro de que se hayan terminado de descargar las encuestas. Verifique en la TEM que esten descargadas!!. Anote SEGURO si está seguro de cargar las encuestas (se procedera a borrar la carga actual del dispositivo.')
        if(rta.trim()=='SEGURO'){
            ok=true;
        }else{
            razon='No hay registro de que las encuestas cargadas hayan sido descargadas';
        }
    }
    if(!ok){
        alert('No se procederá a '+cargar_o_descargar+' este dispositivo. '+razon);
    }
    return ok;
}
    
function habililtar_salida_de_emergencia(inicio){
    elemento_existente('logo_principal').src=inicio?'logo_esperar.png':'logo_app.png';
}

function cargar_dispositivo(avisar){
"use strict";
    if(avisar){
        habililtar_salida_de_emergencia(true);
        setTimeout(function(){ cargar_dispositivo(); },200);
        return;
    }
    elemento_existente('proceso_encuesta_respuesta').textContent="";
    elemento_existente('boton_cargar_dispositivo').disabled=true;
    elemento_existente('boton_descargar_dispositivo').disabled=true;
    (document.getElementById('boton_descargar_dispositivo_resto')||{}).disabled=true;
    if(controlar_hoja_de_ruta_es_seguro('cargar')){
        borrar_localStorage(true);
        proceso_formulario_boton_ejecutar(
            'cargar_dispositivo', 
            'boton_cargar_dispositivo', 
            ["tra_ope","tra_rol","tra_cod_per","tra_fecha_hora"], 
            function(mensaje){
                guardar_en_localStorage("estado_carga","cargado"); 
                elemento_existente('proceso_formulario_respuesta').innerHTML=mensaje.html;
                habililtar_salida_de_emergencia(false);
            }, 
            null, 
            false, 
            pasar_uds_leidas_a_localStorage_y_sacarlas_del_voy_por
        );
    }
}
        
function fin_descargar_dispositivo(){
"use strict";
var vfecha_hora=fecha_amd_hora_hms();
    if(controlar_hoja_de_ruta_es_seguro('descargar')){
        var tra_cod_per=hoja_de_ruta.per;
        enviar_paquete({
            proceso:'fin_descargar_dispositivo_'+hoja_de_ruta.sufijo_rol,
            paquete:{tra_cod_per:tra_cod_per, tra_fecha_hora: vfecha_hora},
            cuando_ok:function(mensaje){
                elemento_existente('proceso_formulario_respuesta').textContent=mensaje;
            },
            asincronico:true,
            usar_fondo_de:elemento_existente('boton_descargar_dispositivo'),
            mostrar_tilde_confirmacion:true
        });
    }
}

function descargar_poner_mensaje(mensaje){
    var contenedor=elemento_existente('proceso_encuesta_respuesta');
    var texto=document.createElement('div');
    texto.textContent=mensaje;
    contenedor.appendChild(texto);
}

var lista_de_encuestas_sin_descargar=[];

function descargar_encuestas_completo(lista_encuestas){
    var haciendo;
    var ok_esta=true;
    var tra_cod_per=hoja_de_ruta.per;
    var vfecha_hora=fecha_amd_hora_hms() ; 
    guardar_en_localStorage("lista_de_encuestas_sin_descargar", JSON.stringify(lista_encuestas));
    descargar_poner_mensaje('empaquetando '+lista_encuestas.length+' encuestas');
    var paquete_a_enviar = [];
    lista_encuestas.forEach(function(encuesta){
        var json_claves=localStorage.getItem('claves_de_'+encuesta);
        if(!json_claves){
            descargar_poner_mensaje('Faltan las claves de '+encuesta);
        }else{
            try{
                haciendo='obteniendo las claves de';
                var claves=JSON.parse(json_claves);
                haciendo='recorriendo las claves de';
                if(encuesta==205437 || encuesta==11200010 || encuesta==205004){
                    // throw 'error nuestro';
                }
                if(hoja_de_ruta.rol!=3 && hoja_de_ruta.rol!=4){
                    paquete_a_enviar.push({
                        proceso:'grabar_fecha_comenzo_descarga',
                        paquete:{tra_ope:'{$GLOBALS['nombre_app']}', tra_enc:encuesta, tra_fecha_hora: vfecha_hora},
                    });
                    for(var json_clave in claves) if(iterable(json_clave,claves)){
                        var clave=JSON.parse(json_clave);
                        if(clave.tra_ope=='{$GLOBALS['nombre_app']}' && clave.tra_for=='TEM'){ 
                            haciendo='enviando paquete de';
                        }
                        if(clave.tra_ope=='{$GLOBALS['nombre_app']}' && clave.tra_for!='TEM'){
                            var esta_rta_ud_json=localStorage.getItem('ud_'+json_clave);
                            if(esta_rta_ud_json!==null){
                                haciendo='obteniendo respuestas de';
                                var esta_rta_ud=JSON.parse(esta_rta_ud_json);
                                haciendo='enviando paquete de';
                                paquete_a_enviar.push({
                                    proceso:'grabar_ud',
                                    paquete:{pk_ud:clave, rta_ud:esta_rta_ud, estados_rta_ud:null},
                                });
                            }    
                        }
                    }
                }
                if(ok_esta){
                    haciendo='enviando el fin de descarga de';
                    paquete_a_enviar.push({
                        proceso:'fin_descargar_dispositivo_'+hoja_de_ruta.sufijo_rol,
                        paquete:{tra_cod_per:tra_cod_per, tra_enc:encuesta, tra_visitas:hoja_de_ruta.encuestas[encuesta].visitas,tra_fecha_hora:vfecha_hora},
                    });
                }
            }catch(err){
                ok_esta=false;
                descargar_poner_mensaje('error '+haciendo+' '+encuesta+': '+descripciones_de_error(err));
            }
        }
    });
    descargar_poner_mensaje('comienza la descarga del paquete completo ');
    enviar_paquete({
        proceso:'recibir_paquete_descarga',
        paquete:{tra_fecha_hora: vfecha_hora, tra_paquetes:paquete_a_enviar},
        cuando_ok:function(){
            ok_esta=ok_esta;
        },
        cuando_error:function(mensaje){
            ok_esta=false;
            descargar_poner_mensaje('error transmitiendo el paquete completo: '+mensaje);
        },
        asincronico:false
    });
    if(ok_esta){
        guardar_en_localStorage("estado_carga","descargado"); 
        descargar_poner_mensaje('Listo');
        habililtar_salida_de_emergencia(false);
    }
}

function descargar_encuestas(lista_encuestas){
    var haciendo;
    var ok_esta=true;
    var tra_cod_per=hoja_de_ruta.per;
    var vfecha_hora=fecha_amd_hora_hms() ; 
    
    guardar_en_localStorage("lista_de_encuestas_sin_descargar", JSON.stringify(lista_encuestas));
    if(lista_encuestas.length){
        guardar_en_localStorage("estado_carga","descarga_parcial"); 
        var encuesta=lista_encuestas.shift();
        var json_claves=localStorage.getItem('claves_de_'+encuesta);
        if(!json_claves){
            descargar_poner_mensaje('Faltan las claves de '+encuesta);
        }else{
            try{
                haciendo='obteniendo las claves de';
                var claves=JSON.parse(json_claves);
                haciendo='recorriendo las claves de';
                if(encuesta==205437 || encuesta==11200010 || encuesta==205004){
                    // throw 'error nuestro';
                }
                if(hoja_de_ruta.rol!=3 && hoja_de_ruta.rol!=4){
                    enviar_paquete({
                        proceso:'grabar_fecha_comenzo_descarga',
                        paquete:{tra_ope:'{$GLOBALS['nombre_app']}', tra_enc:encuesta, tra_fecha_hora: vfecha_hora},
                        cuando_ok:function(){
                            ok_esta=ok_esta;
                        },
                        cuando_error:function(mensaje){
                            ok_esta=false;
                            descargar_poner_mensaje('error grabando fecha_comenzo_descarga de '+encuesta+' '+mensaje);
                        },
                        asincronico:false
                    });
                    if(ok_esta){
                        for(var json_clave in claves) if(iterable(json_clave,claves)){
                            var clave=JSON.parse(json_clave);
                            if(clave.tra_ope=='{$GLOBALS['nombre_app']}' && clave.tra_for=='TEM'){ 
                                haciendo='enviando paquete de';
                            }
                            if(clave.tra_ope=='{$GLOBALS['nombre_app']}' && clave.tra_for!='TEM'){
                                var esta_rta_ud_json=localStorage.getItem('ud_'+json_clave);
                                if(esta_rta_ud_json!==null){
                                    haciendo='obteniendo respuestas de';
                                    var esta_rta_ud=JSON.parse(esta_rta_ud_json);
                                    haciendo='enviando paquete de';
                                    enviar_paquete({
                                        proceso:'grabar_ud',
                                        paquete:{pk_ud:clave, rta_ud:esta_rta_ud, estados_rta_ud:null},
                                        cuando_ok:function(){
                                            ok_esta=ok_esta;
                                        },
                                        cuando_error:function(mensaje){
                                            ok_esta=false;
                                            descargar_poner_mensaje('error grabando '+json_clave+' '+mensaje);
                                        },
                                        asincronico:false
                                    });
                                }    
                            }
                        }
                    }
                }
                if(ok_esta){
                    haciendo='enviando el fin de descarga de';
                    enviar_paquete({
                        proceso:'fin_descargar_dispositivo_'+hoja_de_ruta.sufijo_rol,
                        paquete:{tra_cod_per:tra_cod_per, tra_enc:encuesta, tra_visitas:hoja_de_ruta.encuestas[encuesta].visitas,tra_fecha_hora:vfecha_hora},
                        cuando_ok:function(mensaje){
                            elemento_existente('proceso_formulario_respuesta').textContent=mensaje;
                        },
                        cuando_error:function(mensaje){
                            ok_esta=false;
                            descargar_poner_mensaje('error finalizando descarga de '+encuesta+' '+mensaje);
                        },
                        asincronico:false
                    });
                }
            }catch(err){
                ok_esta=false;
                descargar_poner_mensaje('error '+haciendo+' '+encuesta+': '+descripciones_de_error(err));
            }
        }
        if(ok_esta || "en produccion"){
            if(ok_esta){
                if(hoja_de_ruta.rol!=3 && hoja_de_ruta.rol!=4){
                    descargar_poner_mensaje('encuesta '+encuesta+' transmitida');
                }else{
                    descargar_poner_mensaje('encuesta '+encuesta+' marcada (supervisión)');
                }
                setTimeout(function(){
                    descargar_encuestas(lista_encuestas);
                },100);
            }
        }
    }else{
        guardar_en_localStorage("estado_carga","descargado"); 
        descargar_poner_mensaje('Listo');
        habililtar_salida_de_emergencia(false);
    }
}

function descargar_dispositivo(hacer_parcial,avisar,completo){
"use strict";
    if(avisar){
        habililtar_salida_de_emergencia(true);
        setTimeout(function(){ 
            descargar_dispositivo(hacer_parcial,false,completo); 
        },200);
        return;
    }
    elemento_existente('proceso_encuesta_respuesta').textContent="";
    elemento_existente('boton_cargar_dispositivo').disabled=true;
    elemento_existente('boton_descargar_dispositivo').disabled=true;
    (document.getElementById('boton_descargar_dispositivo_resto')||{}).disabled=true;
    if(hacer_parcial || controlar_hoja_de_ruta_es_seguro('descargar')){
        if(!hacer_parcial){
            guardar_en_localStorage("lista_de_encuestas_sin_descargar", JSON.stringify(array_keys(hoja_de_ruta.encuestas)));
        }
        var lista_de_encuestas;
        try{
            lista_de_encuestas=JSON.parse(localStorage.getItem("lista_de_encuestas_sin_descargar"));
        }catch(e){
            lista_de_encuestas=array_keys(hoja_de_ruta.encuestas);
        }
        if(completo){
            descargar_encuestas_completo(lista_de_encuestas);
        }else{
            descargar_encuestas(lista_de_encuestas);
        }
    }
}

function deshacer_cargar_dispositivo(){
    var ok=false;
    var razon="hubo un problema interno";
    var haciendo;
    alert("Opcion pendiente de programacion");
}

if(localStorage.getItem('estado_carga')=="descarga_parcial"){
    boton_descargar_dispositivo_resto.style.visibility='visible';
}

hoja_de_ruta=JSON.parse(localStorage.getItem('hoja_de_ruta'));
tra_cod_per.value='{$tra_cod_per_def}'||(hoja_de_ruta||{}).per||'';

JS
        );
    }
    function responder_campos_voy_por(){
        return array('pla_lote','pla_cnombre','pla_hn','pla_hp','pla_hd','pla_hab');
    }
    function responder_iniciar_estado(){
        // agrega un registro en la tabla cargas
        // obtiene el número de carga
        // updatea los registros de la TEM con el número de carga
        $this->inforol=Info_Rol::a_partir_de_numrol($this->argumentos->tra_rol);
        $ROL=$this->inforol->sufijo_rol();
        $rol_persona=$this->inforol->rol_persona();
        $this->estado->hoja_de_ruta=(object)array();
        $this->estado->hoja_de_ruta->per=$this->argumentos->tra_cod_per;
        $this->estado->hoja_de_ruta->rol=$rol_persona;
        $this->estado->hoja_de_ruta->sufijo_rol=$ROL;
        $this->estado->hoja_de_ruta->encuestas=(object)array();
        // generalizar!
        //
        $this->estado->cargadas=0;
        //$this->estado->numero_de_carga=null;
        $this->estado->uds_enc=array();
        $this->estado->carga_normal=0;
        $this->estado->{"fecha_carga_{$ROL}"}=null;
    }
    function responder_iniciar_iteraciones(){
        $ROL=$this->inforol->sufijo_rol();
        $ESTADO_SET='('.implode(',',$this->inforol->estados_asignado()).')';
        $this->max_pasos=2;
        $filtro=(object)array("pla_cod_{$ROL}"=>$this->argumentos->tra_cod_per);
        $this->tabla_plana_tem_=$this->nuevo_objeto('Tabla_plana_TEM_');
        $f=$this->nuevo_objeto("Filtro_Normal",$filtro,$this->tabla_plana_tem_);
        if(isset($this->voy_por)){
            $f=new Filtro_AND(array($f,new Filtro_Voy_Por($this->voy_por)),$this->tabla_plana_tem_);
        }
        $this->cursor=$this->db->ejecutar_sql(new Sql($mostrar=<<<SQL
            SELECT pla_enc, 
                   coalesce(pla_cnombre||' ','')
                   ||coalesce(pla_hn||' ','')
                   ||coalesce('piso '||pla_hp||' ','')
                   ||coalesce('dto '||pla_hd||' ','')
                   --||coalesce('hab '||pla_hab||' ','')
                   --||coalesce('barrio '||pla_barrio||' ','')
                   as pla_domicilio,
                   pla_fecha_primcarga_{$ROL},
                   pla_cod_{$ROL},
                   pla_fecha_carga_{$ROL},
                   --pla_obs_campo,
                   pla_tlg
                FROM plana_tem_ 
                WHERE pla_estado in {$ESTADO_SET} and {$f->where} and pla_dispositivo_{$ROL}=1
                ORDER BY 
SQL
                .implode(', ',$this->responder_campos_voy_por()),
            $f->parametros
        ));
        Loguear('2018-11-10',$mostrar);
    }
    function responder_hay_mas(){
        $this->voy_por=$this->cursor->fetchObject();
        return !!$this->voy_por;
    }
    function responder_un_paso(){
        global $campos_visitas,$CARGA_CAPACITACION;
        $ROL=$this->inforol->sufijo_rol();
        $tabla_personal=$this->nuevo_objeto("Tabla_personal");
        $filtro_personal=array(
            'per_ope'=>$GLOBALS['NOMBRE_APP'],
            'per_per'=>$this->argumentos->tra_cod_per,
        );
        $tabla_personal->leer_unico($filtro_personal);
        //$this->estado->hoja_de_ruta->rol=$tabla_personal->datos->per_rol;
        if(!$this->estado->{"fecha_carga_{$ROL}"}){ 
            $this->estado->hoja_de_ruta->{"fecha_carga_{$ROL}"}=date_format(new DateTime(), "Y-m-d");
            $this->estado->{"fecha_carga_{$ROL}"}=$this->estado->hoja_de_ruta->{"fecha_carga_{$ROL}"};
        }
        $encuesta=$this->voy_por->pla_enc;
        $this->estado->uds_enc=array_merge(
            $this->estado->uds_enc,
            Proceso_leer_encuesta_a_localStorage::parte_proceso_leer_a_ls_encuesta(
                $this
                ,array(
                    'tra_ope'=>$GLOBALS['NOMBRE_APP'],
                    'tra_enc'=>$encuesta,
                    'tra_numero_control'=>-951,
                )
            )
        );
        $this->estado->hoja_de_ruta->encuestas->{$encuesta}=array(
            'encuesta'=>$encuesta,
            'domicilio'=>$this->voy_por->pla_domicilio
        );
        $tabla_anoenc=$this->nuevo_objeto("tabla_anoenc");
        $filtro_buscar_visitas = new Filtro_Normal(array(
            'anoenc_ope'=>$GLOBALS['NOMBRE_APP'],
            'anoenc_enc'=>$encuesta,
        ));
        $tabla_anoenc->leer_varios($filtro_buscar_visitas);
        $this->estado->hoja_de_ruta->encuestas->{$encuesta}['visitas']=array();
        $visitas_cargadas = false;
        $visitas=array();
        $num_renglon=0;
        while($tabla_anoenc->obtener_leido()){
            foreach($campos_visitas as $campo){
                $visitas[$tabla_anoenc->datos->anoenc_anoenc][$campo]=$tabla_anoenc->datos->{'anoenc_'.$campo};
            }
            $num_renglon=$tabla_anoenc->datos->anoenc_anoenc;
        }
        $num_renglon++;
        foreach($campos_visitas as $campo){
            $visitas[$num_renglon][$campo]='';
        }
        $visitas[$num_renglon]['ope']= $GLOBALS['NOMBRE_APP']; //$this->argumentos->tra_ope;
        $visitas[$num_renglon]['per']=$this->argumentos->tra_cod_per;
        $visitas[$num_renglon]['rol']=$this->estado->hoja_de_ruta->rol;
        $visitas[$num_renglon]['enc']=$encuesta;
        $visitas[$num_renglon]['anoenc']=$num_renglon;
        $num_renglon++;
        $this->estado->hoja_de_ruta->encuestas->{$encuesta}['visitas']=$visitas;
        $this->estado->carga_normal=1;
        if($this->voy_por->{"pla_cod_{$ROL}"}==1 && $CARGA_CAPACITACION){ // se usa codigo de encuestador = 1 para replicar la carga del encuestador 1 en varios ipad y no setear variables como por ej. fecha_carga_sup
            $this->estado->carga_normal=2;
        }
        $campos_valores_update = array(
                "verificado_{$ROL}"=>null, 
                "fecha_carga_{$ROL}"=>$this->estado->{"fecha_carga_{$ROL}"},                
            );
        if ($this->voy_por->{"pla_fecha_primcarga_{$ROL}"} == null) {
            $campos_valores_update = array_merge($campos_valores_update, array("fecha_primcarga_{$ROL}"=>$this->estado->{"fecha_carga_{$ROL}"},));
        }        
        if($this->estado->carga_normal==1){
            $this->tabla_plana_tem_->update_TEM($encuesta,$campos_valores_update); 
        }    
        $this->estado->cargadas++;
    }
    function responder_finalizar(){
        Loguear('05-12-2012','ddddddddddddddddddddddddddddddddddddd'.json_encode($this->estado));
        $agregar_al_mensaje=$this->estado->carga_normal==2?' ATENCIÓN NO SE MARCARON LAS ENCUESTAS COMO CARGADA PARA PODER CAPACITAR REPITIENDO LA CARGA':'';
        return new Respuesta_Positiva(array(
            "estado"=>array('uds_enc'=>$this->estado->uds_enc),
            "hoja_de_ruta"=>$this->estado->hoja_de_ruta,
            "html"=>"Cargadas {$this->estado->cargadas} encuestas $agregar_al_mensaje",
            "tipo"=>"html",
        ));
    }    
}

?>