<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tabla_operativos.php";
require_once "nuestro_mini_yaml_parse.php";
require_once "insertador_multiple.php";

class Metadatos_ajus extends Objeto_de_la_base{ 
    private $metadatos_ajus;
    function __construct(){
      parent::__construct();
      $this->definir_esquema('encu');
//////////////////////////////////////
Loguear('2012-03-05','por empezar el yaml');        
$this->metadatos_ajus=mini_yaml_parse(<<<YAML
ope_ope:AJUS
ope_nombre:ENCUESTA DE ACCESO A LA JUSTICIA
Tabla_relaciones:
- rel_rel:<=>
  rel_nombre:sí y solo sí
- rel_rel:=>
  rel_nombre:entonces
- rel_rel:X
  rel_nombre:matar
Tabla_ua:
- ua_ua:enc
  ua_prefijo_respuestas:enc
  ua_sufijo_tablas:_encuesta
  ua_pk:["ope","enc"]
- ua_ua:hog
  ua_prefijo_respuestas:hog
  ua_sufijo_tablas:_hogar
  ua_pk:["ope","enc","hog"]
- ua_ua:mie
  ua_prefijo_respuestas:mie
  ua_sufijo_tablas:_miembro
  ua_pk:["ope","enc","hog","mie"]
Tabla_estados_ingreso:
- esting_estado:opc_ok
  esting_descripcion:OK
- esting_estado:opc_salt
  esting_descripcion:esta variable no tiene valor, lo cual es correcto, porque tiene un salto que la pasa por encima
- esting_estado:opc_rano
  esting_descripcion:fuera_de_rango_obligatorio
- esting_estado:opc_omit
  esting_descripcion:esta variable se omitió el ingreso y era obligatoria
- esting_estado:opc_nsnc
  esting_descripcion:no sabe - no contesta
- esting_estado:opc_rana
  esting_descripcion:fuera_de_rango_advertencia
- esting_estado:opc_homi
  esting_descripcion:hay variables anteriores omitidas, estas todavía no están ingresadas ni tienen nada abajo ingresado
- esting_estado:opc_sinesp
  esting_descripcion:sin especificar
- esting_estado:opc_inex
  esting_descripcion:un valor que no existe entre las opciones
- esting_estado:opc_blanco
  esting_descripcion:esta variable está en blanco porque es la que se debe ingresar ahora y no hay errores de saltos
- esting_estado:opc_inconsistente
  esting_descripcion:pertenece a alguna inconsistencia
- esting_estado:opc_sosa
  esting_descripcion:una opción sobre una variable que debía ser salteada
- esting_estado:opc_tono
  esting_descripcion:esta variable todavía no debe ingresarse porque hay una variable en blanco más arriba
- esting_estado:opc_tipo
  esting_descripcion:error de tipo
Tabla_con_opc:
- conopc_conopc:marquesi
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Sí
- conopc_conopc:sino
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Sí
  - opc_opc:2
    opc_texto:No
- conopc_conopc:sinonosabe
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Sí
  - opc_opc:2
    opc_texto:No
  - opc_opc:99
    opc_texto:NS/NC
- conopc_conopc:SiempreAvecesNuncaNsNc
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Siempre
  - opc_opc:2
    opc_texto:A veces
  - opc_opc:3
    opc_texto:Nunca
  - opc_opc:99
    opc_texto:NS/NC
- conopc_conopc:SiSiempreAvecesNuncaNsNc
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Si, siempre
  - opc_opc:2
    opc_texto:Si, algunas veces
  - opc_opc:3
    opc_texto:No, nunca
  - opc_opc:99
    opc_texto:NS/NC
- conopc_conopc:SiseopcupaNoNsNc
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Si, se ocupa
  - opc_opc:2
    opc_texto:No se ocupa
  - opc_opc:99
    opc_texto:NS/NC
- conopc_conopc:TodosMayoriaNinguno4
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Si, todos
  - opc_opc:2
    opc_texto:Si, la mayoría
  - opc_opc:3
    opc_texto:Solo algunos
  - opc_opc:4
    opc_texto:Ninguno
- conopc_conopc:TodosMayoriaNinguno5
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Si, todos
  - opc_opc:2
    opc_texto:Si, la mayoría
  - opc_opc:3
    opc_texto:Solo algunos
  - opc_opc:4
    opc_texto:Ninguno
  - opc_opc:99
    opc_texto:NS/NC
- conopc_conopc:UnaDosymasNotienen
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Solo uno/una
  - opc_opc:2
    opc_texto:Dos y más
  - opc_opc:3
    opc_texto:No tienen
- conopc_conopc:AJ1
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Centro de Gestión y Participación Comunal (CGPC)
  - opc_opc:2
    opc_texto:El Poder Judicial
  - opc_opc:3
    opc_texto:La Defensoría del Pueblo
  - opc_opc:4
    opc_texto:Un abogado particular
  - opc_opc:5
    opc_texto:La comisaría
  - opc_opc:6
    opc_texto:El Periodismo
  - opc_opc:7
    opc_texto:Asociación Vecinal
    opc_proxima_vacia:true
    opc_proxima_opc:8
    opc_proxima_texto:INADI (sólo para Preg. 2.9)
  - opc_opc:9
    opc_texto:No recurriría a ningún lugar
  - opc_opc:10
    opc_texto:Otros (¿cuál?)
  - opc_opc:99
    opc_texto:Ns/Nc
- conopc_conopc:AJ1_completo
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Centro de Gestión y Participación Comunal (CGPC)
  - opc_opc:2
    opc_texto:El Poder Judicial
  - opc_opc:3
    opc_texto:La Defensoría del Pueblo
  - opc_opc:4
    opc_texto:Un abogado particular
  - opc_opc:5
    opc_texto:La comisaría
  - opc_opc:6
    opc_texto:El Periodismo
  - opc_opc:7
    opc_texto:Asociación Vecinal
  - opc_opc:8
    opc_texto:INADI (sólo para Preg. 2.9)
  - opc_opc:9
    opc_texto:No recurriría a ningún lugar
  - opc_opc:10
    opc_texto:Otros (¿cuál?)
  - opc_opc:99
    opc_texto:Ns/Nc
- conopc_conopc:SiempreSegunNuncaNs
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Siempre
  - opc_opc:2
    opc_texto:Según el resultado perseguido
  - opc_opc:3
    opc_texto:Nunca
  - opc_opc:99
    opc_texto:Ns/Nc
- conopc_conopc:FijoCelularAmbos
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Fijo
  - opc_opc:2
    opc_texto:Celular
  - opc_opc:3
    opc_texto:Ambos
- conopc_conopc:AJ26
  Tabla_opciones:
  - opc_opc:1
    opc_texto:Por teléfono
  - opc_opc:2
    opc_texto:Por Internet
  - opc_opc:3
    opc_texto:Personalmente en un Centro de Recepción de denuncias  
- conopc_conopc:AJ33
  Tabla_opciones:
  - opc_opc:1
    opc_texto:POR REFERENCIA DE ALGÚN VECINO O FAMILIAR
  - opc_opc:2
    opc_texto:PORQUE ME INFORMÓ LA POLICIA
  - opc_opc:3
    opc_texto:PORQUE EN MI BARRIO HAY UNA DEPENDENCIA JUDICIAL DE LA CIUDAD
  - opc_opc:4
    opc_texto:A TRAVÉS DE LOS MEDIOS PERIODÍSTICOS
  - opc_opc:5
    opc_texto:POR LA PUBLICIDAD DEL MINISTERIO PÚBLICO FISCAL DE LA CIUDAD
  - opc_opc:6
    opc_texto:POR LA PUBLICIDAD DEL MINISTERIO PÚBLICO DE LA DEFENSA DE LA CIUDAD
  - opc_opc:7
    opc_texto:PORQUE ME LO INFORMARON EL CGPC U OTRO ORGANISMO DEL GOBIERNO DE LA CIUDAD
  - opc_opc:8
    opc_texto:PORQUE ESTUVE INVOLUCRADO EN UN PROCESO JUDICIAL
  - opc_opc:9
    opc_texto:PORQUE ME INFORMÓ UN ABOGADO PRIVADO
  - opc_opc:10
    opc_texto:PORQUE ME INFORMÓ UNA ONG
  - opc_opc:11
    opc_texto:POR INTERNET/RED SOCIAL
  - opc_opc:12
    opc_texto:PORQUE PARTICIPO EN UNA AGRUPACION VECINAL Y/O SOCIAL
  - opc_opc:13
    opc_texto:POR LA ESCUELA
  - opc_opc:14
    opc_texto:NO RECUERDA
- conopc_conopc:tem_no_rea
  Tabla_opciones:
  - opc_opc:10
    opc_texto:Encuesta pendiente
  - opc_opc:11
    opc_texto:Deshabitada - Venta o alquiler
  - opc_opc:12
    opc_texto:Deshabitada - Sucesión o remate
  - opc_opc:13
    opc_texto:Deshabitada - Construccion reciente
  - opc_opc:14
    opc_texto:Deshabitada - Sin causa conocida
  - opc_opc:21
    opc_texto:Demolida - Fue demolida
  - opc_opc:22
    opc_texto:Demolida - En demolición
  - opc_opc:23
    opc_texto:Demolida - Levantada
  - opc_opc:24
    opc_texto:Demolida - Tapiada
  - opc_opc:31
    opc_texto:Fin de semana - de la semana
  - opc_opc:32
    opc_texto:Fin de semana - del mes
  - opc_opc:33
    opc_texto:Fin de semana - del año
  - opc_opc:41
    opc_texto:Construcción - Se está construyendo
  - opc_opc:42
    opc_texto:Construcción - Construccion paralizada
  - opc_opc:43
    opc_texto:Construcción - Refacción
  - opc_opc:51
    opc_texto:Vivienda usada como establecimiento - Conserva comodidad de vivienda
  - opc_opc:61
    opc_texto:Variaciones en el listado - No existe lugar físico
  - opc_opc:62
    opc_texto:Variaciones en el listado - No es vivienda
  - opc_opc:63
    opc_texto:Variaciones en el listado - Existen otras viviendas
  - opc_opc:64
    opc_texto:Variaciones en el listado - Otros especificar
  - opc_opc:71
    opc_texto:Ausencia - No se pudo contactar en 3 visitas
  - opc_opc:72
    opc_texto:Ausencia - Por causas circunstanciales
  - opc_opc:73
    opc_texto:Ausencia - Viaje
  - opc_opc:74
    opc_texto:Ausencia - Vacaciones
  - opc_opc:81
    opc_texto:Rechazo - Negativa rotunda
  - opc_opc:82
    opc_texto:Rechazo - Rechazo por portero eléctrico
  - opc_opc:83
    opc_texto:Rechazo - Se acordaron entrevistas que no se concretaron
  - opc_opc:91
    opc_texto:Otras Causas - Inquilinato, pención, hotel, usurpado, conventillo
  - opc_opc:92
    opc_texto:Otras Causas - Duelo, alcoholismo, discapacidad, idioma extranjero
  - opc_opc:93
    opc_texto:Otras Causas - Problemas de seguridad
  - opc_opc:94
    opc_texto:Otras Causas - Inaccesible (Problemas climáticos u otros)
Tabla_formularios:
- for_for:AJI1
  for_nombre:Cuestionario individual
  Tabla_matrices:
  - mat_mat:''
    mat_texto:Principal
    mat_ua:hog
    mat_ultimo_campo_pk:hog
    mat_blanquear_clave_al_retroceder:,tra_mie:0
  Tabla_bloques:
  - blo_blo:0
    blo_texto:Identificación del cuestionario individual
    Tabla_preguntas:
    - pre_pre:pr
      pre_texto:A ser respondido por la persona seleccionada en el hogar
      Tabla_variables:
      - var_var:pr1
        var_texto:Miembro N°
        var_tipovar:numeros
      - var_var:pr2
        var_texto:Nombre
  - blo_blo:1
    blo_texto:Situación laboral del miembro seleccionado
    Tabla_preguntas:
    - pre_pre:t1
      Tabla_variables:
      - var_var:t1
        var_texto:¿La semana pasada trabajo por lo menos una hora?
        var_conopc:sino 
        Tabla_saltos:
        - sal_opc:1
          sal_destino:T44
    - pre_pre:t2
      Tabla_variables:
      - var_var:t2
        var_texto:¿En esa semana hizo alguna changa, fabricó algo para vender, ayudo a un familiar / amigo en su negocio?
        var_conopc:sino
        Tabla_saltos:
        - sal_opc:1
          sal_destino:T44
    - pre_pre:t3
      Tabla_variables:
      - var_var:t3
        var_texto:¿La semana pasada....
        var_aclaracion:(G-S)
        var_conopc:t3
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:no deseaba / no quería / no podía trabajar?
            Tabla_saltos:
            - sal_destino:eje1
          - opc_opc:2
            opc_texto:no tenía / no conseguía trabajo?
            Tabla_saltos:
            - sal_destino:T9
          - opc_opc:3
            opc_texto:no tuvo pedidos/clientes?
            Tabla_saltos:
            - sal_destino:T9
          - opc_opc:4
            opc_texto:tenía un trabajo/negocio al que no concurrió?
    - pre_pre:T4
      Tabla_variables:
      - var_var:T4
        var_texto:¿No concurrió por....
        var_conopc:T4
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:vacaciones, licencia? (enfermedad, matrimonio, embarazo, etc.)
            Tabla_saltos:
            - sal_destino:T44
          - opc_opc:2
            opc_texto:causas personales? (viajes, trámites, etc.)?
            Tabla_saltos:
            - sal_destino:T44
          - opc_opc:3
            opc_texto:huelga o conflicto laboral?
            Tabla_saltos:
            - sal_destino:T44
          - opc_opc:4
            opc_texto:suspención con pago
            Tabla_saltos:  
            - sal_destino:T44
          - opc_opc:5
            opc_texto:suspención sin pago
            Tabla_saltos:  
            - sal_destino:T9
          - opc_opc:6
            opc_texto:otras causas laborales y volverá a lo sumo en un mes?
            Tabla_saltos:  
            - sal_destino:T44
          - opc_opc:7
            opc_texto:otras causas laborales y volverá en mas de un mes?
            Tabla_saltos:  
            - sal_destino:T9
    - pre_pre:T9
      Tabla_variables:
      - var_var:T9
        var_texto:En los últimos 30 días, ¿estuvo buscando trabajo de alguna manera?
        var_conopc:sino 
        Tabla_saltos:
        - sal_opc:1
          sal_destino:eje1
    - pre_pre:T10
      Tabla_variables:
      - var_var:T10
        var_texto:¿Durante esos 30 días consultó amigos/parientes, puso carteles, hizo algo para ponerse por su cuenta?
        var_conopc:sino 
        Tabla_saltos:
        - sal_opc:1
          sal_destino:eje1
    - pre_pre:T11
      Tabla_variables:
      - var_var:T11
        var_texto:¿Durante esos 30 días, no buscó trabajo porque....
        var_conopc:T11
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:está suspendido
          - opc_opc:2
            opc_texto:ya tiene trabajo asegurado?
          - opc_opc:3
            opc_texto:se cansó de buscar trabajo?
          - opc_opc:4
            opc_texto:hay poco trabajo en esta época del año?
          - opc_opc:5
            opc_texto:por otras razones
            opc_aclaracion:(Especificar)
        Tabla_saltos:
        - sal_opc:1
          sal_destino:eje1
        - sal_opc:2
          sal_destino:eje1
        - sal_opc:3
          sal_destino:eje1
        - sal_opc:4
          sal_destino:eje1
      - var_var:T11_esp
        var_tipovar:texto_largo
        var_destino:eje1
        var_subordinada_var:T11
        var_subordinada_opcion:5
        var_expresion_habilitar:t11=5
    - pre_pre:T44
      Tabla_variables:
      - var_var:T44
        var_texto:¿En la ocupación principal (si tiene más de una aquella que habitualmente le lleva más horas), trabaja...
        var_conopc:T44
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:para su propio negocio/empresa/actividad?
            Tabla_saltos:
            - sal_destino:T46
          - opc_opc:2
            opc_texto:como obrero o empleado para un patrón/empresa/institución (incluye agencia de empleo)?
          - opc_opc:3
            opc_texto:como servicio doméstico?
          - opc_opc:4
            opc_texto:como trabajador familiar sin pago?
    - pre_pre:T51
      pre_destino:eje1
      Tabla_variables:
      - var_var:T51
        var_texto:En ese trabajo
        var_aclaracion:(G-S)
        var_conopc:T51
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:le descuentan para la jubilación?
          - opc_opc:2
            opc_texto:aporta por sí mismo para jubilación?
          - opc_opc:3
            opc_texto:no le decuentan ni aporta?
    - pre_pre:T46
      Tabla_variables:
      - var_var:T46
        var_texto:En ese negocio/empresa/actividad se emplean personas asalariadas
        var_conopc:sino
  - blo_blo:eje1
    blo_texto:CULTURA LEGAL
    Tabla_preguntas:
    - pre_pre:AJ1
      pre_texto:A quién recurriría para resolver las siguientes situaciones...
      pre_aclaracion:(G-S) (Encuestador: Muestre tarjetas según indicación al margen)
      pre_desp_opc:horizontal
      Tabla_variables:
      - var_var:AJ1_1
        var_desp_nombre:1.1
        var_texto:Si le negasen una vacante en los colegios de su barrio
        var_conopc:AJ1
        var_conopc_texto:abreviatura
      - var_var:AJ1_1_cual
        var_tipovar:texto
        var_subordinada_var:AJ1_1
        var_subordinada_opcion:10        
      - var_var:AJ1_2
        var_desp_nombre:1.2
        var_texto:Si no tuviera dónde vivir
        var_conopc:AJ1
        var_conopc_texto:abreviatura
      - var_var:AJ1_2_cual
        var_tipovar:texto
        var_subordinada_var:AJ1_2
        var_subordinada_opcion:10      
      - var_var:AJ1_3
        var_desp_nombre:1.3
        var_texto:Si le negaran atencion en un hospital publico
        var_conopc:AJ1
        var_conopc_texto:abreviatura
      - var_var:AJ1_3_cual
        var_tipovar:texto
        var_subordinada_var:AJ1_3
        var_subordinada_opcion:10 
      - var_var:AJ1_4
        var_desp_nombre:1.4
        var_texto:Si tuviera un conflicto con otro vecino por ruidos molestos
        var_conopc:AJ1
        var_conopc_texto:abreviatura
      - var_var:AJ1_4_cual
        var_tipovar:texto
        var_subordinada_var:AJ1_4
        var_subordinada_opcion:10         
      - var_var:AJ1_5
        var_desp_nombre:1.5
        var_texto:Si tuviera un conflicto por incumplimiento del pago de la cuota de alimentos
        var_conopc:AJ1
        var_conopc_texto:abreviatura
      - var_var:AJ1_5_cual
        var_tipovar:texto
        var_subordinada_var:AJ1_5
        var_subordinada_opcion:10      
      - var_var:AJ1_6
        var_desp_nombre:1.6
        var_texto:Si le pidieran dinero para estacionar su auto
        var_conopc:AJ1
        var_conopc_texto:abreviatura
      - var_var:AJ1_6_cual
        var_tipovar:texto
        var_subordinada_var:AJ1_6
        var_subordinada_opcion:10         
      - var_var:AJ1_7
        var_desp_nombre:1.7
        var_texto:Si su barrio sufriera algún problema ambiental causado por algún vecino o alguna empresa (No leer: ejemplo contaminación con residuos sólidos o líquidos) 
        var_conopc:AJ1
        var_conopc_texto:abreviatura
      - var_var:AJ1_7_cual
        var_tipovar:texto
        var_subordinada_var:AJ1_7
        var_subordinada_opcion:10         
      - var_var:AJ1_8
        var_desp_nombre:1.8
        var_texto:Si en su barrio algunos espacios públicos estuvieran ilegalmente ocupados por vendedores ambulantes o ferias
        var_conopc:AJ1
        var_conopc_texto:abreviatura
      - var_var:AJ1_8_cual
        var_tipovar:texto
        var_subordinada_var:AJ1_8
        var_subordinada_opcion:10         
      - var_var:AJ1_9
        var_desp_nombre:1.9
        var_texto:Si Ud. recibiera amenazas o fuese intimidado con un arma           
        var_conopc:AJ1
        var_conopc_texto:abreviatura
      - var_var:AJ1_9_cual
        var_tipovar:texto
        var_subordinada_var:AJ1_9
        var_subordinada_opcion:10         
      - var_var:AJ1_10
        var_desp_nombre:1.10
        var_texto:Si Ud. fuese discriminado
        var_conopc:AJ1_completo
        var_conopc_texto:abreviatura
      - var_var:AJ1_10_cual
        var_tipovar:texto
        var_subordinada_var:AJ1_10
        var_subordinada_opcion:10
    - pre_pre:AJ2
      pre_texto:¿Considera Ud. que los conflictos deben denunciarse?
      pre_aclaracion:(G-S)
      Tabla_variables:
      - var_var:AJ2
        var_conopc:AJ2
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Todos, sin importar el tipo de hecho
            Tabla_saltos:
            - sal_destino:AJ5
          - opc_opc:2
            opc_texto:Algunos, dependiendo del tipo de hecho
          - opc_opc:3
            opc_texto:Ninguno
          - opc_opc:99
            opc_texto:Ns/Nc
    - pre_pre:AJ3
      pre_desp_opc:horizontal
      Tabla_variables:
      - var_var:AJ3
        var_texto:¿Estaría Ud. dispuesto a denunciar en la Justicia todo tipo de conflictos si pudieran resolverse sin llegar a un juicio?
        var_conopc:sinonosabe
    - pre_pre:AJ4
      pre_texto:¿Por qué considera Ud. que sólo alguno o ningún conflicto debería denunciarse? 
      pre_aclaracion:(G-M) Encuestador: Muestre tarjeta 3
      Tabla_variables:
      - var_var:AJ4_1
        var_desp_nombre:1
        var_texto:PORQUE DESCONFIO DE LA JUSTICIA
        var_tipovar:multiple_marcar
      - var_var:AJ4_2
        var_desp_nombre:2
        var_texto:PORQUE LAS AUTORIDADES NO HACEN NADA
        var_tipovar:multiple_marcar
      - var_var:AJ4_3
        var_desp_nombre:3
        var_texto:POR TEMOR A LAS REPRESALIAS
        var_tipovar:multiple_marcar
      - var_var:AJ4_4
        var_desp_nombre:4
        var_texto:PORQUE NO SE DONDE HACER LA DENUNCIA
        var_tipovar:multiple_marcar
      - var_var:AJ4_5
        var_desp_nombre:5
        var_texto:POR TEMOR A LA POLICIA
        var_tipovar:multiple_marcar
      - var_var:AJ4_6
        var_desp_nombre:6
        var_texto:POR EL COSTO ECONOMICO DE LOS JUICIOS
        var_tipovar:multiple_marcar
      - var_var:AJ4_7
        var_desp_nombre:7
        var_texto:POR LA DURACION DE LOS JUICIOS
        var_tipovar:multiple_marcar
      - var_var:AJ4_8
        var_desp_nombre:8
        var_texto:PORQUE LAS FISCALIAS NO TOMAN LAS DENUNCIAS
        var_tipovar:multiple_marcar
      - var_var:AJ4_9
        var_desp_nombre:9
        var_texto:PORQUE CIERTO TIPO DE HECHOS NO SON GRAVES
        var_tipovar:multiple_marcar
      - var_var:AJ4_10
        var_desp_nombre:10
        var_texto:PORQUE HAY QUE ACOSTUMBRARSE A LOS CONFLICTOS
        var_tipovar:multiple_marcar
      - var_var:AJ4_11
        var_desp_nombre:11
        var_texto:PORQUE SE PIERDE MUCHO TIEMPO
        var_tipovar:multiple_marcar
      - var_var:AJ4_12
        var_desp_nombre:12
        var_texto:PORQUE TRATARIA DE RESOLVERLO POR MIS PROPIOS MEDIOS
        var_tipovar:multiple_marcar
      - var_var:AJ4_99
        var_expresion_habilitar:!al_menos_uno_lleno_con_dato_uno([aj4_1,aj4_2,aj4_3,aj4_4,aj4_5,aj4_6,aj4_7,aj4_8,aj4_9,aj4_10,aj4_11,aj4_12])
        var_desp_nombre:99
        var_texto:Ns/Nc
        var_tipovar:multiple_nsnc
    - pre_pre:AJ4_A
      Tabla_variables:
      - var_var:AJ4_A
        var_desp_nombre:AJ4.A
        var_expresion_habilitar:!aj4_99
        var_texto: Indague por la más importante y registre en este recuadro el código
        var_conopc:AJ4_A
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:PORQUE DESCONFIO DE LA JUSTICIA
          - opc_opc:2
            opc_texto:PORQUE LAS AUTORIDADES NO HACEN NADA
          - opc_opc:3
            opc_texto:POR TEMOR A LAS REPRESALIAS
          - opc_opc:4
            opc_texto:PORQUE NO SE DONDE HACER LA DENUNCIA
          - opc_opc:5
            opc_texto:POR TEMOR A LA POLICIA
          - opc_opc:6
            opc_texto:POR EL COSTO ECONOMICO DE LOS JUICIOS
          - opc_opc:7
            opc_texto:POR LA DURACION DE LOS JUICIOS
          - opc_opc:8
            opc_texto:PORQUE LAS FISCALIAS NO TOMAN LAS DENUNCIAS
          - opc_opc:9
            opc_texto:PORQUE CIERTO TIPO DE HECHOS NO SON GRAVES
          - opc_opc:10
            opc_texto:PORQUE HAY QUE ACOSTUMBRARSE A LOS CONFLIC
          - opc_opc:11
            opc_texto:PORQUE SE PIERDE MUCHO TIEMPO
          - opc_opc:12
            opc_texto:PORQUE TRATARIA DE RESOLVERLO POR MIS PROPIOS MEDIOS      
    - pre_pre:AJ5
      pre_texto:¿Ante cuales situaciones considera que un conflicto es grave como para ser denunciado? 
      pre_aclaracion:(G-M) Encuestador: Muestre tarjeta 4)
      Tabla_variables:
      - var_var:AJ5_1
        var_desp_nombre:1
        var_texto:ANTE LA IMPOSIBILIDAD DE RESOLVER UN CONFLICTO
        var_tipovar:multiple_marcar
      - var_var:AJ5_2
        var_desp_nombre:2
        var_texto:ANTE LAS AGRESIONES VERBALES
        var_tipovar:multiple_marcar
      - var_var:AJ5_3
        var_desp_nombre:3
        var_texto:ANTE LAS AGRESIONES FISICAS
        var_tipovar:multiple_marcar
      - var_var:AJ5_4
        var_desp_nombre:4
        var_texto:ANTE LOS DAÑOS A LA PROPIEDAD Y BIENES PRIVADOS
        var_tipovar:multiple_marcar
      - var_var:AJ5_5
        var_desp_nombre:5
        var_texto:ANTE LOS DAÑOS A LA PROPIEDAD PUBLICA Y BIENES PUBLICOS
        var_tipovar:multiple_marcar
      - var_var:AJ5_6
        var_desp_nombre:6
        var_texto:ANTE LAS AMENAZAS
        var_tipovar:multiple_marcar
      - var_var:AJ5_7
        var_desp_nombre:7
        var_texto:ANTE LA INTIMIDACION CON ARMAS BLANCAS
        var_tipovar:multiple_marcar
      - var_var:AJ5_8
        var_desp_nombre:8
        var_texto:ANTE LA INTIMIDACION CON ARMAS DE FUEGO
        var_tipovar:multiple_marcar
      - var_var:AJ5_9
        var_desp_nombre:9
        var_texto:NINGUNO
        var_expresion_habilitar:!al_menos_uno_lleno_con_dato_uno([aj5_1,aj5_2,aj5_3,aj5_4,aj5_5,aj5_6,aj5_7,aj5_8])
        var_tipovar:multiple_marcar
      - var_var:AJ5_99
        var_desp_nombre:99
        var_expresion_habilitar:!al_menos_uno_lleno_con_dato_uno([aj5_1,aj5_2,aj5_3,aj5_4,aj5_5,aj5_6,aj5_7,aj5_8,aj5_9])
        var_texto:Ns/Nc
        var_tipovar:multiple_nsnc
      - var_var:AJ5_A
        var_desp_nombre:AJ5.A
        var_expresion_habilitar:!aj5_9 and !aj5_99
        var_texto: Indague por la más importante y registre en este recuadro el código
        var_conopc:AJ5_A
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:ANTE LA IMPOSIBILIDAD DE RESOLVER UN CONFLICTO        
          - opc_opc:2
            opc_texto:ANTE LAS AGRESIONES VERBALES
          - opc_opc:3
            opc_texto:ANTE LAS AGRESIONES FISICAS
          - opc_opc:4
            opc_texto:ANTE LOS DAÑOS A LA PROPIEDAD Y BIENES PRIVADOS
          - opc_opc:5
            opc_texto:ANTE LOS DAÑOS A LA PROPIEDAD PUBLICA Y BIENES PUBLICOS
          - opc_opc:6
            opc_texto:ANTE LAS AMENAZAS
          - opc_opc:7
            opc_texto:ANTE LA INTIMIDACION CON ARMAS BLANCAS
          - opc_opc:8
            opc_texto:ANTE LA INTIMIDACION CON ARMAS DE FUEGO      
    - pre_pre:AJ6
      pre_texto:¿Haría Ud. una denuncia si el responsable es...
      pre_aclaracion:(G-M)(Encuestador Muestre: Tarjeta 5)
    - pre_pre:AJ6_1
      pre_texto:un conflicto de convivencia fuese...(Encuestador Ejemplifique: ruidos molestos, medianería)
      pre_desp_nombre:6.1
      Tabla_variables:
      - var_var:AJ6_1_1
        var_desp_nombre:1
        var_texto: Un conocido del barrio?
        var_tipovar:multiple_marcar
      - var_var:AJ6_1_2
        var_desp_nombre:2
        var_texto: Un familiar?
        var_tipovar:multiple_marcar
      - var_var:AJ6_1_3
        var_desp_nombre:3
        var_texto:Un amigo?
        var_tipovar:multiple_marcar
      - var_var:AJ6_1_4
        var_desp_nombre:4
        var_texto:Un vecino con el cual tiene relación?
        var_tipovar:multiple_marcar
      - var_var:AJ6_1_5
        var_desp_nombre:5
        var_texto:Un menor?
        var_tipovar:multiple_marcar
      - var_var:AJ6_1_6
        var_desp_nombre:6
        var_texto:Un indigente?
        var_tipovar:multiple_marcar
      - var_var:AJ6_1_7
        var_desp_nombre:7     
        var_texto:Un policía?
        var_tipovar:multiple_marcar
      - var_var:AJ6_1_8
        var_desp_nombre:8     
        var_texto:Una figura pública?
        var_tipovar:multiple_marcar
      - var_var:AJ6_1_9
        var_desp_nombre:9     
        var_texto:Otros?
        var_tipovar:multiple_marcar
      - var_var:AJ6_1_9_otro
        var_tipovar:texto
        var_subordinada_var:AJ6_1_9
        var_subordinada_opcion:1        
    - pre_pre:AJ6_2
      pre_texto:agresiones verbales fuese...
      pre_desp_nombre:AJ6.2
      Tabla_variables:
      - var_var:AJ6_2_1
        var_desp_nombre:1
        var_texto: Un conocido del barrio?
        var_tipovar:multiple_marcar
      - var_var:AJ6_2_2
        var_desp_nombre:2       
        var_texto: Un familiar?
        var_tipovar:multiple_marcar
      - var_var:AJ6_2_3
        var_desp_nombre:3     
        var_texto:Un amigo?
        var_tipovar:multiple_marcar
      - var_var:AJ6_2_4
        var_desp_nombre:4     
        var_texto:Un vecino con el cual tiene relación?
        var_tipovar:multiple_marcar
      - var_var:AJ6_2_5
        var_desp_nombre:5     
        var_texto:Un menor?
        var_tipovar:multiple_marcar
      - var_var:AJ6_2_6
        var_desp_nombre:6     
        var_texto:Un indigente?
        var_tipovar:multiple_marcar
      - var_var:AJ6_2_7
        var_desp_nombre:7       
        var_texto:Un policía?
        var_tipovar:multiple_marcar
      - var_var:AJ6_2_8
        var_desp_nombre:8       
        var_texto:Una figura pública?
        var_tipovar:multiple_marcar
      - var_var:AJ6_2_9
        var_desp_nombre:9       
        var_texto:Otros?
        var_tipovar:multiple_marcar
      - var_var:AJ6_2_9_otro
        var_tipovar:texto
        var_subordinada_var:AJ6_2_9
        var_subordinada_opcion:1
    - pre_pre:AJ6_3
      pre_texto:agresiones físicas fuese...
      pre_desp_nombre:AJ6.3
      Tabla_variables:
      - var_var:AJ6_3_1
        var_desp_nombre:1
        var_texto: Un conocido del barrio?
        var_tipovar:multiple_marcar
      - var_var:AJ6_3_2
        var_desp_nombre:2       
        var_texto: Un familiar?
        var_tipovar:multiple_marcar
      - var_var:AJ6_3_3
        var_desp_nombre:3       
        var_texto:Un amigo?
        var_tipovar:multiple_marcar
      - var_var:AJ6_3_4
        var_desp_nombre:4       
        var_texto:Un vecino con el cual tiene relación?
        var_tipovar:multiple_marcar
      - var_var:AJ6_3_5
        var_desp_nombre:5       
        var_texto:Un menor?
        var_tipovar:multiple_marcar
      - var_var:AJ6_3_6
        var_desp_nombre:6       
        var_texto:Un indigente?
        var_tipovar:multiple_marcar
      - var_var:AJ6_3_7
        var_desp_nombre:7       
        var_texto:Un policía?
        var_tipovar:multiple_marcar
      - var_var:AJ6_3_8
        var_desp_nombre:8       
        var_texto:Una figura pública?
        var_tipovar:multiple_marcar
      - var_var:AJ6_3_9
        var_desp_nombre:9       
        var_texto:Otros?
        var_tipovar:multiple_marcar
      - var_var:AJ6_3_9_otro
        var_tipovar:texto
        var_subordinada_var:AJ6_3_9
        var_subordinada_opcion:1
    - pre_pre:AJ6_4
      pre_texto:daños a la propiedad y bienes privados fuese...
      pre_desp_nombre:AJ6.4
      Tabla_variables:
      - var_var:AJ6_4_1
        var_desp_nombre:1
        var_texto: Un conocido del barrio?
        var_tipovar:multiple_marcar
      - var_var:AJ6_4_2
        var_desp_nombre:2      
        var_texto: Un familiar?
        var_tipovar:multiple_marcar
      - var_var:AJ6_4_3
        var_desp_nombre:3       
        var_texto:Un amigo?
        var_tipovar:multiple_marcar
      - var_var:AJ6_4_4
        var_desp_nombre:4      
        var_texto:Un vecino con el cual tiene relación?
        var_tipovar:multiple_marcar
      - var_var:AJ6_4_5
        var_desp_nombre:5       
        var_texto:Un menor?
        var_tipovar:multiple_marcar
      - var_var:AJ6_4_6
        var_desp_nombre:6      
        var_texto:Un indigente?
        var_tipovar:multiple_marcar
      - var_var:AJ6_4_7
        var_desp_nombre:7      
        var_texto:Un policía?
        var_tipovar:multiple_marcar
      - var_var:AJ6_4_8
        var_desp_nombre:8       
        var_texto:Una figura pública?
        var_tipovar:multiple_marcar
      - var_var:AJ6_4_9
        var_desp_nombre:9       
        var_texto:Otros?
        var_tipovar:multiple_marcar
      - var_var:AJ6_4_9_otro
        var_tipovar:texto
        var_subordinada_var:AJ6_4_9
        var_subordinada_opcion:1
    - pre_pre:AJ6_5
      pre_texto:de daños a propiedad pública y bienes públicos fuese... (actos de vandalismo en plazas públicas, destrucción de monumentos, etc.)
      pre_desp_nombre:AJ6.5
      Tabla_variables:
      - var_var:AJ6_5_1
        var_desp_nombre:1
        var_texto: Un conocido del barrio?
        var_tipovar:multiple_marcar
      - var_var:AJ6_5_2
        var_desp_nombre:2       
        var_texto: Un familiar?
        var_tipovar:multiple_marcar
      - var_var:AJ6_5_3
        var_desp_nombre:3      
        var_texto:Un amigo?
        var_tipovar:multiple_marcar
      - var_var:AJ6_5_4
        var_desp_nombre:4      
        var_texto:Un vecino con el cual tiene relación?
        var_tipovar:multiple_marcar
      - var_var:AJ6_5_5
        var_desp_nombre:5      
        var_texto:Un menor?
        var_tipovar:multiple_marcar
      - var_var:AJ6_5_6
        var_desp_nombre:6      
        var_texto:Un indigente?
        var_tipovar:multiple_marcar
      - var_var:AJ6_5_7
        var_desp_nombre:7      
        var_texto:Un policía?
        var_tipovar:multiple_marcar
      - var_var:AJ6_5_8
        var_desp_nombre:8      
        var_texto:Una figura pública?
        var_tipovar:multiple_marcar
      - var_var:AJ6_5_9
        var_desp_nombre:9      
        var_texto:Otros?
        var_tipovar:multiple_marcar
      - var_var:AJ6_5_9_otro
        var_tipovar:texto
        var_subordinada_var:AJ6_5_9
        var_subordinada_opcion:1
    - pre_pre:AJ6_6
      pre_texto:de amenazas fuese...
      pre_desp_nombre:AJ6.6
      Tabla_variables:
      - var_var:AJ6_6_1
        var_desp_nombre:1
        var_texto: Un conocido del barrio?
        var_tipovar:multiple_marcar
      - var_var:AJ6_6_2
        var_desp_nombre:2       
        var_texto: Un familiar?
        var_tipovar:multiple_marcar
      - var_var:AJ6_6_3
        var_desp_nombre:3      
        var_texto:Un amigo?
        var_tipovar:multiple_marcar
      - var_var:AJ6_6_4
        var_desp_nombre:4      
        var_texto:Un vecino con el cual tiene relación?
        var_tipovar:multiple_marcar
      - var_var:AJ6_6_5
        var_desp_nombre:5      
        var_texto:Un menor?
        var_tipovar:multiple_marcar
      - var_var:AJ6_6_6
        var_desp_nombre:6      
        var_texto:Un indigente?
        var_tipovar:multiple_marcar
      - var_var:AJ6_6_7
        var_desp_nombre:7       
        var_texto:Un policía?
        var_tipovar:multiple_marcar
      - var_var:AJ6_6_8
        var_desp_nombre:8       
        var_texto:Una figura pública?
        var_tipovar:multiple_marcar
      - var_var:AJ6_6_9
        var_desp_nombre:9        
        var_texto:Otros?
        var_tipovar:multiple_marcar
      - var_var:AJ6_6_9_otro
        var_tipovar:texto
        var_subordinada_var:AJ6_6_9
        var_subordinada_opcion:1      
    - pre_pre:AJ6_7
      pre_texto:de intimidación con armas blancas fuese...
      pre_desp_nombre:AJ6.7
      Tabla_variables:
      - var_var:AJ6_7_1
        var_desp_nombre:1
        var_texto: Un conocido del barrio?
        var_tipovar:multiple_marcar
      - var_var:AJ6_7_2
        var_desp_nombre:2        
        var_texto: Un familiar?
        var_tipovar:multiple_marcar
      - var_var:AJ6_7_3
        var_desp_nombre:3       
        var_texto:Un amigo?
        var_tipovar:multiple_marcar
      - var_var:AJ6_7_4
        var_desp_nombre:4       
        var_texto:Un vecino con el cual tiene relación?
        var_tipovar:multiple_marcar
      - var_var:AJ6_7_5
        var_desp_nombre:5       
        var_texto:Un menor?
        var_tipovar:multiple_marcar
      - var_var:AJ6_7_6
        var_desp_nombre:6       
        var_texto:Un indigente?
        var_tipovar:multiple_marcar
      - var_var:AJ6_7_7
        var_desp_nombre:7       
        var_texto:Un policía?
        var_tipovar:multiple_marcar
      - var_var:AJ6_7_8
        var_desp_nombre:8       
        var_texto:Una figura pública?
        var_tipovar:multiple_marcar
      - var_var:AJ6_7_9
        var_desp_nombre:9       
        var_texto:Otros?
        var_tipovar:multiple_marcar
      - var_var:AJ6_7_9_otro
        var_tipovar:texto
        var_subordinada_var:AJ6_7_9
        var_subordinada_opcion:1
    - pre_pre:AJ6_8
      pre_texto:de intimidación con armas de fuego fuese...
      pre_desp_nombre:AJ6.8
      Tabla_variables:
      - var_var:AJ6_8_1
        var_desp_nombre:1
        var_texto: Un conocido del barrio?
        var_tipovar:multiple_marcar
      - var_var:AJ6_8_2
        var_desp_nombre:2        
        var_texto: Un familiar?
        var_tipovar:multiple_marcar
      - var_var:AJ6_8_3
        var_desp_nombre:3       
        var_texto:Un amigo?
        var_tipovar:multiple_marcar
      - var_var:AJ6_8_4
        var_desp_nombre:4       
        var_texto:Un vecino con el cual tiene relación?
        var_tipovar:multiple_marcar
      - var_var:AJ6_8_5
        var_desp_nombre:5       
        var_texto:Un menor?
        var_tipovar:multiple_marcar
      - var_var:AJ6_8_6
        var_desp_nombre:6       
        var_texto:Un indigente?
        var_tipovar:multiple_marcar
      - var_var:AJ6_8_7
        var_desp_nombre:7       
        var_texto:Un policía?
        var_tipovar:multiple_marcar
      - var_var:AJ6_8_8
        var_desp_nombre:8       
        var_texto:Una figura pública?
        var_tipovar:multiple_marcar
      - var_var:AJ6_8_9
        var_desp_nombre:9       
        var_texto:Otros?
        var_tipovar:multiple_marcar  
      - var_var:AJ6_8_9_otro
        var_tipovar:texto
        var_subordinada_var:AJ6_8_9
        var_subordinada_opcion:1
    - pre_pre:AJ7
      pre_texto: Segun su opinion el objetivo de las leyes es...
      pre_desp_opc:horizontal
      Tabla_variables:
      - var_var:AJ7_1
        var_texto: Defender el acceso y goce de todos los derechos civiles, politicos, economicoas, sociales y culturales de  las personas
        var_conopc:sino
      - var_var:AJ7_2
        var_texto:Establecer las obligaciones de las personas
        var_conopc:sino
      - var_var:AJ7_3
        var_texto:Regular los castigos que deben aplicarse en determinados casos
        var_conopc:sino
    - pre_pre:AJ8
      pre_desp_opc:horizontal
      Tabla_variables:
      - var_var:AJ8
        var_texto:¿Sabe Ud. qué es una Mediación Judicial?
        var_conopc:sinonosabe
  - blo_blo:EJE2
    blo_texto:CONFIANZA EN EL SISTEMA DE ADMINISTRACIÓN DE JUSTICIA
    Tabla_preguntas:
    - pre_pre:AJ9
      pre_desp_opc:horizontal
      Tabla_variables:
      - var_var:AJ9
        var_texto:Cuando no se garantiza a las personas el acceso a la vivienda, salud, educación, etc. ¿Es necesario que intervenga la Justicia?
        var_conopc:SiempreAvecesNuncaNsNc
    - pre_pre:AJ10
      pre_desp_opc:horizontal
      Tabla_variables:
      - var_var:AJ10
        var_texto:Cuando la justicia resuelve una causa, ¿siempre prevalece la verdad?
        var_conopc:SiempreAvecesNuncaNsNc
    - pre_pre:AJ11
      pre_desp_opc:horizontal
      Tabla_variables:
      - var_var:AJ11
        var_texto:Cuando los jueces dictan sentencia, considera Ud. que se hace Justicia aun si los resultados obtenidos son diferentes a los esperados?
        var_conopc:SiempreAvecesNuncaNsNc
    - pre_pre:AJ12
      pre_desp_opc:horizontal
      pre_texto:Considera Ud. que....
      Tabla_variables:
      - var_var:AJ12_1
        var_desp_nombre:1
        var_texto:Los Jueces son honestos?
        var_conopc:TodosMayoriaNinguno5
      - var_var:AJ12_2
        var_desp_nombre:2
        var_texto:Los Fiscales son honestos?
        var_conopc:TodosMayoriaNinguno5
      - var_var:AJ12_3
        var_desp_nombre:3
        var_texto:Los Defensores Públicos son honestos?
        var_conopc:TodosMayoriaNinguno5
      - var_var:AJ12_4
        var_desp_nombre:4
        var_texto:Los abogados Particulares?
        var_conopc:TodosMayoriaNinguno5  
    - pre_pre:AJ13
      pre_desp_opc:horizontal
      pre_texto:Considera Ud. que...
      pre_aclaracion:(G-S) (Encuestador: tenga en cuenta que con sólo una marca de opciones de respuesta 3 y/o 4 pase a AJ14)
      Tabla_variables:
      - var_var:AJ13_1
        var_texto:Los Jueces toman sus decisiones de manera Independiente?
        var_conopc:TodosMayoriaNinguno4
      - var_var:AJ13_2
        var_texto:Los Fiscales toman sus decisiones de manera Independiente?
        var_conopc:TodosMayoriaNinguno4
      - var_var:AJ13_3
        var_texto:Los Defensores Públicos toman sus decisiones de manera Independiente?
        var_conopc:TodosMayoriaNinguno4
      Tabla_filtros:
      - fil_fil:aj13
        fil_mat:''
        fil_texto:Si todas las respuestas de la AJ13 son 1 ó 2
        fil_expresion:(aj13_1=1 or aj13_1=2) and (aj13_2=1 or aj13_2=2) and (aj13_3=1 or aj13_3=2)
        fil_destino:aj15_1
    - pre_pre:AJ14
      pre_desp_opc:horizontal
      pre_texto:¿Quiénes considera Ud. que influyen en las decisiones de los Jueces, Fiscales y Defensores Públicos?
      Tabla_variables:
      - var_var:AJ14_1
        var_desp_nombre:1
        var_texto:El gobierno
        var_conopc:sinonosabe
      - var_var:AJ14_2
        var_desp_nombre:2
        var_texto:Los grupos empresarios
        var_conopc:sinonosabe
      - var_var:AJ14_3
        var_desp_nombre:3
        var_texto:El periodismo
        var_conopc:sinonosabe
      - var_var:AJ14_4
        var_desp_nombre:4
        var_texto:La Iglesia
        var_conopc:sinonosabe
      - var_var:AJ14_5
        var_desp_nombre:5
        var_texto:Los partidos políticos
        var_conopc:sinonosabe
      - var_var:AJ14_6
        var_desp_nombre:6
        var_texto:Los sindicatos
        var_conopc:sinonosabe  
      - var_var:AJ14_7
        var_desp_nombre:7
        var_texto:La participacion ciudadana
        var_conopc:sinonosabe    
      - var_var:AJ14_8
        var_desp_nombre:8
        var_texto:Otros
        var_aclaracion:(especifique) 
        var_conopc:sinonosabe
      - var_var:AJ14_otros
        var_tipovar:texto
        var_subordinada_var:AJ14_8
        var_subordinada_opcion:1
    - pre_pre:AJ14_A
      Tabla_variables:
      - var_var:AJ14_A
        var_desp_nombre:AJ14.A
        var_texto: Indague por la más importante y registre en este recuadro el código
        var_expresion_habilitar:al_menos_uno_lleno_con_dato_uno([aj14_1, aj14_2, aj14_3, aj14_4, aj14_5, aj14_6,aj14_7,aj14_8])
        var_conopc:AJ14_A
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:El gobierno
          - opc_opc:2
            opc_texto:Los grupos empresarios
          - opc_opc:3
            opc_texto:El periodismo
          - opc_opc:4
            opc_texto:La Iglesia
          - opc_opc:5
            opc_texto:Los partidos políticos
          - opc_opc:6
            opc_texto:Los sindicatos
          - opc_opc:7
            opc_texto:La participacion ciudadana
          - opc_opc:8
            opc_texto:Otros
    - pre_pre:AJ15
      pre_desp_opc:horizontal
      pre_texto:Considera Ud. que...
      pre_aclaracion:(G-S) (Encuestador: tenga en cuenta que con sólo una marca de opciones de respuesta 3 y/o 4 pase a AJ16)
      Tabla_variables:
      - var_var: AJ15_1
        var_texto:los Jueces, Fiscales y Defensores Públicos tratan a todas las personas por igual?
        var_conopc:TodosMayoriaNinguno4
      - var_var: AJ15_2
        var_texto:los fiscales tratan a todas las personas por igual?
        var_conopc:TodosMayoriaNinguno4
      - var_var: AJ15_3
        var_texto:los defensores tratan a todas las personas por igual?
        var_conopc:TodosMayoriaNinguno4
      Tabla_filtros:
      - fil_fil:aj15
        fil_mat:''
        fil_texto:Si todas las respuestas de la AJ15 son 1 ó 2
        fil_expresion:(aj15_1=1 or aj15_1=2) and (aj15_2=1 or aj15_2=2) and (aj15_3=1 or aj15_3=2)
        fil_destino:aj17
    - pre_pre:AJ16
      pre_texto:¿Qué es lo que hace que Jueces, Fiscales y Defensores traten de manera diferente a las personas?
      pre_desp_opc:horizontal
      Tabla_variables:
      - var_var:AJ16_1
        var_desp_nombre:1
        var_texto:Que las personas tengan dinero
        var_conopc:sinonosabe
      - var_var:AJ16_2
        var_desp_nombre:2
        var_texto:Que tengan contactos
        var_conopc:sinonosabe
      - var_var:AJ16_3
        var_desp_nombre:3
        var_texto:Que tengan un alto nivel de instruccion
        var_conopc:sinonosabe
      - var_var:AJ16_4
        var_desp_nombre:4
        var_texto:Que sean famosos
        var_conopc:sinonosabe
      - var_var:AJ16_5
        var_desp_nombre:5
        var_texto:Que estén acompañados de un buen abogado
        var_conopc:sinonosabe
      - var_var:AJ16_6
        var_desp_nombre:6
        var_texto:Otros
        var_aclaracion:(especifique) 
        var_conopc:sinonosabe
      - var_var:AJ16_otros
        var_tipovar:texto
        var_subordinada_var:AJ16_6
        var_subordinada_opcion:1
    - pre_pre:AJ16_A
      Tabla_variables:
      - var_var:AJ16_A
        var_desp_nombre:AJ16.A
        var_texto: Indague por la más importante y registre en este recuadro el código
        var_expresion_habilitar:al_menos_uno_lleno_con_dato_uno([aj16_1, aj16_2, aj16_3, aj16_4, aj16_5, aj16_6])
        var_conopc:AJ16_A
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Que las personas tengan dinero
          - opc_opc:2
            opc_texto:Que tengan contactos
          - opc_opc:3
            opc_texto:Que tengan un alto nivel de instruccion
          - opc_opc:4
            opc_texto:Que sean famosos
          - opc_opc:5
            opc_texto:Que estén acompañados de un buen abogado
          - opc_opc:6
            opc_texto:Otros        
    - pre_pre:AJ17
      pre_texto:¿Considera Ud. qué un abogado privado en comparación con un Defensor Publico es...
      pre_aclaracion:(G-S)
      Tabla_variables:
      - var_var:AJ17
        var_conopc:AJ17
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Más Eficiente
          - opc_opc:2
            opc_texto:Igual de Eficiente
          - opc_opc:3
            opc_texto:Menos eficiente
          - opc_opc:99
            opc_texto:Ns/Nc
    - pre_pre:AJ18
      pre_texto:Si Ud. tuviese que resolver un conflicto por vía judicial, en quién confiaría más para que lo represente? 
      pre_aclaracion:(G-S)
      Tabla_variables:
      - var_var:AJ18
        var_conopc:AJ18
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Un abogado particular
          - opc_opc:2
            opc_texto:Un Defensor público
          - opc_opc:3
            opc_texto:Cualquiera de los dos  
          - opc_opc:99
            opc_texto:Ns/Nc
    - pre_pre:AJ19
      pre_texto:¿Por algún motivo le tocó intervenir en algún proceso judicial de la Ciudad de Buenos Aires?
      Tabla_variables:
      - var_var:AJ19
        var_conopc:sinonosabe
        Tabla_saltos:
        - sal_opc:2
          sal_destino:EJE3
        - sal_opc:99
          sal_destino:EJE3
    - pre_pre:AJ20
      pre_desp_nombre:AJ20
      pre_texto:Recuerda si en esa oportunidad intervino como....
      pre_aclaracion:(Encuestador: en caso de tener más de una causa referirse a la última causa)
      Tabla_variables:
      - var_var:AJ20
        var_conopc:AJ20
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Actor/requirente/denunciante
          - opc_opc:2
            opc_texto:Demandado/requerido/denunciado
          - opc_opc:3
            opc_texto:Testigo
          - opc_opc:4
            opc_texto:Otro (especifique)
          - opc_opc:99
            opc_texto:Ns/Nc
      - var_var:AJ20_otro
        var_tipovar:texto
        var_subordinada_var:AJ20
        var_subordinada_opcion:4
  - blo_blo:EJE3
    blo_texto:PERCEPCIÓN DE Accesibilidad
    Tabla_preguntas:
    - pre_pre:AJ21
      pre_texto:¿Considera Ud. que la Justicia tiene más causas que las que puede resolver?
      Tabla_variables:
      - var_var:AJ21
        var_conopc:sinonosabe
    - pre_pre:AJ22
      pre_texto:Considera Ud. que la Justicia le otorga la misma importancia a todas las demandas que recibe? (G-S)
      Tabla_variables:
      - var_var:AJ22
        var_conopc:SiSiempreAvecesNuncaNsNc
    - pre_pre:AJ23
      pre_desp_opc:horizontal
      pre_texto:¿Qué determina la importancia que la Justicia le otorga los juicios?
      pre_aclaracion:(G-S)
      Tabla_variables:
      - var_var:AJ23_1
        var_desp_nombre:1
        var_texto:La gravedad de los hechos
        var_conopc:sinonosabe
      - var_var:AJ23_2
        var_desp_nombre:2
        var_texto:Que esas personas tengan dinero
        var_conopc:sinonosabe
      - var_var:AJ23_3
        var_desp_nombre:3
        var_texto:Que tengan contactos
        var_conopc:sinonosabe
      - var_var:AJ23_4
        var_desp_nombre:4
        var_texto:Que tengan un alto nivel de intruccion
        var_conopc:sinonosabe
      - var_var:AJ23_5
        var_desp_nombre:5
        var_texto:Que sean famosos
        var_conopc:sinonosabe
      - var_var:AJ23_6
        var_desp_nombre:6
        var_texto:El impulso que le da el abogado
        var_conopc:sinonosabe
    - pre_pre:AJ23_A
      pre_desp_nombre:AJ23.A
      Tabla_variables:
      - var_var:AJ23_A
        var_desp_nombre:AJ23.A
        var_texto: Indague por la más importante y registre en este recuadro el código
        var_tipovar:multiple_mejor
        var_expresion_habilitar:al_menos_uno_lleno_con_dato_uno([aj23_1, aj23_2, aj23_3, aj23_4, aj23_5, aj23_6])
        var_conopc:AJ23_A
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:La gravedad de los hechos
          - opc_opc:2
            opc_texto:Que esas personas tengan dinero
          - opc_opc:3
            opc_texto:Que tengan contactos
          - opc_opc:4
            opc_texto:Que tengan mucha educación
          - opc_opc:5
            opc_texto:Que sean famosos
          - opc_opc:6
            opc_texto:Otros              
    - pre_pre:AJ24
      pre_texto:¿Para Ud. el lenguaje utilizado en la Justicia es.... 
      pre_aclaracion:(G-S)
      Tabla_variables:
      - var_var:AJ24
        var_conopc:AJ24
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Totalmente comprensible
          - opc_opc:2
            opc_texto:Algo comprensible
          - opc_opc:3
            opc_texto:Nada comprensible
          - opc_opc:99
            opc_texto:Ns/Nc
    - pre_pre:AJ25
      pre_texto:¿El lenguaje utilizado en la Justicia le genera a Ud. desconfianza?
      pre_aclaracion:(G-S)
      Tabla_variables:
      - var_var:AJ25
        var_conopc:SiSiempreAvecesNuncaNsNc
    - pre_pre:AJ26
      pre_desp_opc:horizontal
      pre_texto:En caso de tener que realizar una denuncia de...
      pre_aclaracion:(G-S)
      Tabla_variables:
      - var_var:AJ26_1
        var_desp_nombre:AJ26.1
        var_texto:Un conflicto de convivencia preferiría hacerlo...
        var_aclaracion:(Encuestador ejemplifique: ruidos molestos, conflictos de medianera)
        var_conopc:AJ26
      - var_var:AJ26_2
        var_desp_nombre:AJ26.2
        var_texto:Agresiones verbales preferiría hacerlo...
        var_conopc:AJ26
      - var_var:AJ26_3
        var_desp_nombre:AJ26.3
        var_texto:Agresiones físicas preferiría hacerlo...
        var_conopc:AJ26
      - var_var:AJ26_4
        var_desp_nombre:AJ26.4
        var_texto:Daños a la propiedad y bienes privados preferiría hacerlo...
        var_conopc:AJ26
      - var_var:AJ26_5
        var_desp_nombre:AJ26.5
        var_texto:Daños a la propiedad y bienes públicos preferiría hacerlo...
        var_aclaracion:(Encuestador ejemplifique: actos de vandalismo en plazas públicas, destrucción de monumentos, etc.)
        var_conopc:AJ26
      - var_var:AJ26_6
        var_desp_nombre:AJ26.6
        var_texto:Amenazas preferiría hacerlo...
        var_conopc:AJ26
      - var_var:AJ26_7
        var_desp_nombre:AJ26.7
        var_texto:Intimidación con armas blancas preferiría hacerlo...
        var_conopc:AJ26
      - var_var:AJ26_8
        var_desp_nombre:AJ26.8
        var_texto:Intimidación con armas de fuego preferiría hacerlo...
        var_conopc:AJ26
    - pre_pre:AJ27
      pre_texto:Para Ud. el costo económico de un juicio es...
      Tabla_variables:
      - var_var:AJ27
        var_conopc:AJ27
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Accesible
          - opc_opc:2
            opc_texto:Medianamente Accesible
          - opc_opc:3
            opc_texto:Inaccesible
          - opc_opc:99
            opc_texto:Ns/Nc
    - pre_pre:AJ28
      pre_texto:¿Sabe Ud. dónde encontrar en la Ciudad de Buenos Aires asistencia Legal Gratuita?
      Tabla_variables:
      - var_var:AJ28
        var_conopc:sino
        Tabla_saltos:
        - sal_opc:2
          sal_destino:AJ29
    - pre_pre:AJ28_1
      pre_desp_nombre:AJ28.1
      Tabla_variables:
      - var_var:AJ28_1
        var_texto:¿Dónde?
        var_aclaracion:(Encuestador: Registre la Institución o el Domicilio que mencione el Encuestado)
        var_desp_nombre:AJ28.1
        var_tipovar: texto_largo
    - pre_pre:AJ29
      pre_desp_opc:horizontal
      pre_texto:Para Ud. ¿Que determina la duración de los Juicios?
      pre_aclaracion:(G-S)
      Tabla_variables:
      - var_var:AJ29_1
        var_desp_nombre:1
        var_texto:La cantidad de trabajo de los juzgados
        var_conopc:sinonosabe
      - var_var:AJ29_2
        var_desp_nombre:2
        var_texto:Las leyes que determinan los procedimientos
        var_conopc:sinonosabe
      - var_var:AJ29_3
        var_desp_nombre:3
        var_texto:Las estrategias a los abogados
        var_conopc:sinonosabe
      - var_var:AJ29_4
        var_desp_nombre:4
        var_texto:La falta de compromiso de los Jueces
        var_conopc:sinonosabe
      - var_var:AJ29_5
        var_desp_nombre:5
        var_texto:Otros (especifique)
        var_conopc:sinonosabe
      - var_var:AJ29_otro
        var_tipovar:texto_largo
        var_subordinada_var:AJ29_5
        var_subordinada_opcion:1
    - pre_pre:AJ29_A
      pre_desp_nombre:AJ29.A
      Tabla_variables:
      - var_var:AJ29_A
        var_desp_nombre:AJ29.A
        var_texto:Indague por la más importante y registre en este recuadro el código
        var_tipovar:multiple_mejor
        var_expresion_habilitar:al_menos_uno_lleno_con_dato_uno([aj29_1, aj29_2, aj29_3, aj29_4, aj29_5])
        var_conopc:AJ29_A
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:La cantidad de trabajo de los juzgados
          - opc_opc:2
            opc_texto:Las leyes que determinan los procedimientos
          - opc_opc:3
            opc_texto:Las estrategias a los abogados
          - opc_opc:4
            opc_texto:La falta de interés de los Jueces
          - opc_opc:5
            opc_texto:La otra especificada
    - pre_pre:AJ30
      pre_texto:¿Considera Ud. qué se justifica asistir a un proceso judicial aunque ocasione perdidas de horas/días de trabajo?
      Tabla_variables:
      - var_var:AJ30
        var_conopc:SiempreSegunNuncaNs
    - pre_pre:AJ31
      pre_texto:¿Considera Ud. qué se justifica asistir a un proceso judicial aunque ocasione costos personales?
      Tabla_variables:
      - var_var:AJ31
        var_conopc:SiempreSegunNuncaNs
    - pre_pre:AJ32
      pre_texto:¿Sabe Ud. si la Ciudad de Buenos Aires tiene un Poder Judicial propio?
      Tabla_variables:
      - var_var:AJ32
        var_conopc:sinonosabe
        Tabla_saltos:
        - sal_opc:2
          sal_destino:Fin
        - sal_opc:99
          sal_destino:Fin
    - pre_pre:AJ33
      pre_texto:¿Cómo se enteró por primera vez de la existencia de la Justicia de la Ciudad de Buenos Aires?
      pre_aclaracion:(G-S) (Encuestador: Muestre tarjeta 7)
      Tabla_variables:
      - var_var:aj33
        var_conopc:AJ33
    - pre_pre:AJ34
      pre_desp_opc:horizontal
      pre_texto:¿Podría determinar si la Justicia de la Ciudad de Buenos Aires se ocupa de ....
      pre_aclaracion:(G-S)
      Tabla_variables:
      - var_var:AJ34_1
        var_desp_nombre:1
        var_texto:El hostigamiento o maltrato entre vecinos
        var_conopc:sinonosabe
      - var_var:AJ34_2
        var_desp_nombre:2
        var_texto:Ruidos molestos
        var_conopc:sinonosabe
      - var_var:AJ34_3
        var_desp_nombre:3
        var_texto:La oferta de sexo frente a su domicilio
        var_conopc:sinonosabe
      - var_var:AJ34_4
        var_desp_nombre:4
        var_texto:Los conflictos por infracciones de transito
        var_conopc:sinonosabe
      - var_var:AJ34_5
        var_desp_nombre:5
        var_texto:La ocupación de su vereda por vendedores ambulantes
        var_conopc:sinonosabe
      - var_var:AJ34_6
        var_desp_nombre:6
        var_texto:La discriminación por motivos diversos
        var_conopc:sinonosabe    
      - var_var:AJ34_7
        var_desp_nombre:7
        var_texto:Las deudas impositivas
        var_conopc:sinonosabe
      - var_var:AJ34_8
        var_desp_nombre:8
        var_texto:La conducción de vehículos bajo efectos del alcohol 
        var_conopc:sinonosabe
      - var_var:AJ34_9
        var_desp_nombre:9
        var_texto:La conducción de vehículos bajo efectos de estupefacientes (sustancias psicoactivas)
        var_conopc:sinonosabe
      - var_var:AJ34_10
        var_desp_nombre:10
        var_texto:El pedido de retribución por estacionamiento o cuidado de vehículos en la vía publica
        var_conopc:sinonosabe
      - var_var:AJ34_11
        var_desp_nombre:11
        var_texto:La Intimidación con armas de fuego
        var_conopc:sinonosabe
      - var_var:AJ34_12
        var_desp_nombre:12
        var_texto:La tenencia y portación de armas de fuego no declaradas
        var_conopc:sinonosabe
      - var_var:AJ34_13
        var_desp_nombre:13
        var_texto:La violencia en espectáculos deportivos y artísticos en la Ciudad
        var_conopc:sinonosabe
      - var_var:AJ34_14
        var_desp_nombre:14
        var_texto:La protección de derechos sociales como Vivienda, salud, educación, empleo, etc
        var_conopc:sinonosabe
      - var_var:AJ34_15
        var_desp_nombre:15
        var_texto:El incumplimiento de los deberes de asistencia familiar (cuota de Alimentos)
        var_conopc:sinonosabe
    - pre_pre:AJ35
      pre_texto:¿Conoce Ud. dónde está localizada alguna Dependencia Judicial de la Ciudad de Buenos Aires? 
      Tabla_variables:
      - var_var:AJ35
        var_conopc:sino
        Tabla_saltos:
        - sal_opc:2
          sal_destino:AJ37
    - pre_pre:AJ36
      pre_texto:¿Recuerda dónde está/n ubicada/s esa/s dependencia/s? 
      pre_aclaracion:(E-M)
      Tabla_variables:
      - var_var:AJ36
        var_tipovar:texto
    - pre_pre:AJ37
      pre_texto:¿Conoce Ud. que el Ministerio Público de la Ciudad de Buenos Aires  dispone de …
      pre_aclaracion:(G)
      Tabla_variables:
      - var_var:AJ37_1
        var_desp_nombre:37.1
        var_texto:Una línea gratuita de atención permanente, para consultas y denuncias?
        var_conopc:sino
      - var_var:AJ37_2
        var_desp_nombre:37.2
        var_texto:Unidades de Orientación Y Denuncias del Ministerio Publico Fiscal?
        var_conopc:sino
      - var_var:AJ37_3
        var_desp_nombre:37.3
        var_texto:Unidades de Orientación al Habitante del Ministerio Publico de la Defensa?
        var_conopc:sino
      - var_var:AJ37_4
        var_desp_nombre:37.4
        var_texto:Una página Web que brinda información al ciudadano donde se pueden realizar Denuncias?
        var_conopc:sino
    - pre_pre:AJ38
      pre_desp_opc:horizontal
      pre_texto:Conoce  Ud... 
      pre_aclaracion:(G)
      Tabla_variables:
      - var_var:AJ38_1
        var_desp_nombre:38.1
        var_texto:Que la Justicia de la Ciudad se debe realizar algún pago previo de Tasa de Justicia para Iniciar una causa?
        var_conopc:sino
      - var_var:AJ38_2
        var_desp_nombre:38.2
        var_texto:Que en la Justicia de la Ciudad le ofrece asistencia legal en forma gratuita?
        var_conopc:sino
      - var_var:AJ38_3
        var_desp_nombre:38.3
        var_texto:Que en la Justicia de la Ciudad existe la posibilidad de resolver conflictos sin tener que llegar a un juicio?
        var_conopc:sino  
- for_for:TEM
  for_nombre:Tabla tem
  Tabla_matrices:
  - mat_mat:''
    mat_texto:Principal
    mat_ua:enc
    mat_ultimo_campo_pk:enc
    mat_blanquear_clave_al_retroceder:,tra_hog:0,tra_mie:0
  Tabla_bloques:
  - blo_blo:1
    blo_texto:Encuestador
    Tabla_preguntas:
    - pre_pre:1_1
      Tabla_variables:
      - var_var:NENC
        var_desp_nombre:1.1
        var_texto:Encuestador
      - var_var:fecha_rec_enc
        var_texto:Fecha de recepción
        var_tipovar:fecha
    - pre_pre:1_2                                               
      Tabla_variables:
      - var_var:REA_ENC
        var_desp_nombre:1.2
        var_texto:REA encuestador
        var_conopc:REA_ENC
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:0
            opc_texto:no realizada
            Tabla_saltos:
            - sal_destino:RAZON_ENC
          - opc_opc:1
            opc_texto:realizada
    - pre_pre:1_3
      Tabla_variables:
      - var_var:NHOGARES
        var_tipovar:numeros
        var_desp_nombre:1.3
        var_texto:Cantidad de hogares
    - pre_pre:1_4
      Tabla_variables:
      - var_var:NMIEMBROS
        var_tipovar:numeros
        var_desp_nombre:1.4
        var_texto:Cantidad de miembros
        Tabla_filtros:
        - fil_fil:FILTRO_REALIZADA_NHOGARES_1_1
          fil_mat:''
          fil_texto:''
          fil_expresion:nhogares=1
          fil_destino:sup_diri
        - fil_fil:FILTRO_REALIZADA_NHOGARES_1_MAYOR
          fil_mat:''
          fil_texto:''
          fil_expresion:nhogares>1
          fil_destino:cod_sup
  - blo_blo:2
    blo_texto: No realizada x el encuestador
    Tabla_preguntas:
    - pre_pre:2_1
      Tabla_variables:
      - var_var:RAZON_ENC
        var_desp_nombre:2.1
        var_texto:RAZON POR LA CUAL NO SE REALIZO LA ENTREVISTA
        var_aclaracion:(encuestador)
        var_conopc:tem_no_rea        
        Tabla_saltos:
        - sal_opc:11
          sal_destino:2_2
        - sal_opc:12
          sal_destino:2_2
        - sal_opc:13
          sal_destino:2_2
        - sal_opc:14
          sal_destino:2_2
        - sal_opc:21
          sal_destino:2_2
        - sal_opc:22
          sal_destino:2_2
        - sal_opc:23
          sal_destino:2_2
        - sal_opc:24
          sal_destino:2_2
        - sal_opc:31
          sal_destino:2_2
        - sal_opc:32
          sal_destino:2_2
        - sal_opc:33
          sal_destino:2_2
        - sal_opc:41
          sal_destino:2_2
        - sal_opc:42
          sal_destino:2_2
        - sal_opc:43
          sal_destino:2_2
        - sal_opc:51
          sal_destino:2_2
        - sal_opc:61
          sal_destino:2_2
        - sal_opc:62
          sal_destino:2_2
        - sal_opc:63
          sal_destino:bolsa
        - sal_opc:64
          sal_destino:2_2
        - sal_opc:71
          sal_destino:3
        - sal_opc:72
          sal_destino:3
        - sal_opc:73
          sal_destino:3
        - sal_opc:74
          sal_destino:3
        - sal_opc:81
          sal_destino:3
        - sal_opc:82
          sal_destino:3
        - sal_opc:83
          sal_destino:3
        - sal_opc:91
          sal_destino:3
        - sal_opc:92
          sal_destino:3
        - sal_opc:93
          sal_destino:bolsa
        - sal_opc:94
          sal_destino:bolsa
    - pre_pre:2_2
      Tabla_variables:
      - var_var:COD_SUP_NOEC
        var_desp_nombre:2.2
        var_texto:Codigo de supervisor
    - pre_pre:2_3
      Tabla_variables:
      - var_var:FIN_SUP_NOENC
        var_desp_nombre:2.3
        var_texto:Confirma
        var_conopc:sino
        Tabla_saltos:
        - sal_opc:1
          sal_destino:bolsa
    - pre_pre:2_4
      Tabla_variables:
      - var_var:RAZON_SUP
        var_desp_nombre:2.4
        var_texto:RAZON POR LA CUAL NO SE REALIZO LA ENTREVISTA
        var_aclaracion:(Supervisión)
        var_conopc:tem_no_rea  
        var_destino:bolsa
    - pre_pre:2_5
      pre_desp_nombre:2.5
      Tabla_variables:
      - var_var:5_obs
        var_texto:Observaciones
        var_destino:bolsa
  - blo_blo:3
    blo_texto: Recuperacion
    Tabla_preguntas:
    - pre_pre:3_1
      Tabla_variables:
      - var_var:COD_RECU
        var_desp_nombre:3.1
        var_texto:Codigo recuperador
      - var_var:fecha_rec_recu
        var_texto:Fecha de recepción
        var_tipovar:fecha
    - pre_pre:3_2
      Tabla_variables:
      - var_var:REA_RECU
        var_desp_nombre:3.2
        var_texto:REA recuperador
        var_conopc:REA_RECU
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:2
            opc_texto:no realizada
            Tabla_saltos:
            - sal_destino:RAZON_RECU
          - opc_opc:3
            opc_texto:realizada
            Tabla_saltos:
            - sal_destino:NHOGARES_RECU            
    - pre_pre:3_3
      Tabla_variables:
      - var_var:RAZON_RECU
        var_desp_nombre:3.3
        var_texto:RAZON POR LA CUAL NO SE REALIZO LA ENTREVISTA
        var_aclaracion:(Recuperador)
        var_conopc:tem_no_rea
        var_destino:COD_SUP_RECU
    - pre_pre:3_4
      Tabla_variables:
      - var_var:NHOGARES_RECU
        var_tipovar:numeros
        var_desp_nombre:3.4
        var_texto:Cantidad de hogares
    - pre_pre:3_5
      Tabla_variables:
      - var_var:NMIEMBROS_RECU
        var_tipovar:numeros
        var_desp_nombre:3.5
        var_texto:Cantidad de miembros
        Tabla_filtros:
        - fil_fil:FILTRO_REALIZADA_NHOGARES_3_1
          fil_mat:''
          fil_texto:''
          fil_expresion:NHOGARES_RECU=1
          fil_destino:SUP_RECU
        - fil_fil:FILTRO_REALIZADA_NHOGARES_3_MAYOR
          fil_mat:''
          fil_texto:''
          fil_expresion:NHOGARES_RECU>1
          fil_destino:COD_SUP_RECU
  - blo_blo:4
    blo_texto: Supervisión de Recuperador
    Tabla_preguntas:
    - pre_pre:4_1
      Tabla_variables:
      - var_var:SUP_RECU
        var_desp_nombre:4.1
        var_texto:Supervisar?
        var_conopc:sino
        Tabla_saltos:
        - sal_opc:2
          sal_destino:bolsa
    - pre_pre:4_2
      Tabla_variables:
      - var_var:COD_SUP_RECU
        var_desp_nombre:4.2
        var_texto:Código de Supervisor
    - pre_pre:4_3
      Tabla_variables:
      - var_var:FIN_SUP_RECU
        var_desp_nombre:4.3
        var_texto:Confirma
        var_conopc:sino
        Tabla_saltos:
        - sal_opc:1
          sal_destino:bolsa
        - sal_opc:2
          sal_destino:bolsa
  - blo_blo:5
    blo_texto:Supervisión encuestador
    Tabla_preguntas:
    - pre_pre:5_1
      Tabla_variables:
      - var_var:SUP_DIRI
        var_desp_nombre:5.1
        var_texto:Es dirigida?
        var_conopc:SUP_DIRI
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Sí
            Tabla_saltos:
            - sal_destino:COD_SUP
          - opc_opc:2
            opc_texto:No (decide el algoritmo)
          - opc_opc:3
            opc_texto:No. Se exceptúa
            Tabla_saltos:
            - sal_destino:bolsa
    - pre_pre:5_2
      Tabla_variables:
      - var_var:SUP_CAMPO
        var_desp_nombre:5.2
        var_texto: Tipo de supervisión decidida por el algoritmo
        var_editable_por:nadie
        var_conopc:SUP_CAMPO
        Tabla_con_opc:        
        - Tabla_opciones:
          - opc_opc:0
            opc_texto: no se supervisa.
            Tabla_saltos:
            - sal_destino:bolsa
          - opc_opc:1
            opc_texto:Presencial
          - opc_opc:2
            opc_texto:Telefónica
    - pre_pre:5_3
      pre_desp_nombre:5.3
      Tabla_variables:
      - var_var:COD_SUP
        var_texto:Codigo de supervisor
    - pre_pre:5_4
      Tabla_variables:
      - var_var:FIN_SUP
        var_desp_nombre:5.4
        var_texto:Confirma
        var_conopc:sino
    - pre_pre:5_5
      pre_desp_nombre:5.5
      Tabla_variables:
      - var_var:Obs_campo
        var_texto:Observaciones
  - blo_blo:FTC
    blo_texto:Fin de las tareas de campo
    Tabla_preguntas:
    - pre_pre:9
      Tabla_variables:
      - var_var:bolsa
        var_texto:asignada a bolsa
        var_aclaracion:(número)
  - blo_blo:T_ING
    blo_texto:TAREAS DE INGRESO
    Tabla_preguntas:
    - pre_pre:21
      Tabla_variables:
      - var_var:comenzo_ingreso
        var_texto:¿Comenzó el ingreso?
        var_editable_por:nadie
        var_conopc:marquesi
    - pre_pre:22
      Tabla_variables:
      - var_var:comenzo_consistencias
        var_texto:¿Se corrieron las consistencias?
        var_editable_por:nadie
        var_conopc:marquesi
      - var_var:cantidad_inconsistencias
        var_texto:Cantidad de inconsistencias
        var_editable_por:nadie
        var_tipovar:numeros
- for_for:AJH1
  for_nombre:Cuestionario para el hogar
  for_es_principal:true
  Tabla_matrices:
  - mat_mat:''
    mat_texto:Principal
    mat_ua:hog
    mat_ultimo_campo_pk:hog
    mat_blanquear_clave_al_retroceder:,tra_mie:0
  - mat_mat:M
    mat_texto:Miembros
    mat_ua:mie
    mat_ultimo_campo_pk:mie
    mat_blanquear_clave_al_retroceder:''
  Tabla_bloques:
  - blo_blo:0
    blo_texto:Carátula
    Tabla_preguntas:
    - pre_pre:rea
      pre_texto:''
      Tabla_variables:
      - var_var:rea
        var_texto:¿Entrevista realizada?
        var_conopc:sino 
        Tabla_saltos:
        - sal_opc:2
          sal_destino:RAZON_NOREA
    - pre_pre:respondente_num
      pre_texto:''
      Tabla_variables:
      - var_var:respondente_num
        var_texto:Respondente Nº
        var_tipovar:numeros
    - pre_pre:respondente_nom
      pre_texto:''
      Tabla_variables:
      - var_var:respondente_nom
        var_texto:Nombre
        var_tipovar:texto
    - pre_pre:fecha_rea
      pre_texto:''
      Tabla_variables:
      - var_var:fecha_rea
        var_texto:Fecha de realización
        var_tipovar:texto
    - pre_pre:v1
      pre_texto:''
      Tabla_variables:
      - var_var:v1
        var_texto:¿Todas las personas que residen en esta vivienda comparten los gastos de comida?
        var_aclaracion:Si la respuesta es NO abra otro formulario AJH1
        var_conopc:sino
    - pre_pre:totalh
      pre_texto:''
      Tabla_variables:
      - var_var:totalh     
        var_texto:total de hogares
        var_tipovar:numeros
    - pre_pre:telh
      pre_texto:''
      Tabla_variables:
      - var_var:telh     
        var_texto:Teléfono del hogar
        var_tipovar:texto      
    Tabla_filtros:
    - fil_fil:FILTRO_REALIZADA
      fil_mat:''
      fil_texto:Si realizada, va a ultimo_digito
      fil_expresion:rea=1
      fil_destino:total_pr
  - blo_blo:0_norea
    blo_texto: No realizada x el encuestador
    Tabla_preguntas:
    - pre_pre:razon_1
      Tabla_variables:
      - var_var:RAZON_NOREA
        var_texto:RAZON POR LA CUAL NO SE REALIZO LA ENTREVISTA
        var_conopc:RAZON_NOREA
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Deshabitada 
            Tabla_saltos:
            - sal_destino:RAZON_NOREA_1
          - opc_opc:2
            opc_texto:Demolida 
            Tabla_saltos:
            - sal_destino:RAZON_NOREA_2
          - opc_opc:3
            opc_texto:Fin de Semana
            Tabla_saltos:
            - sal_destino:RAZON_NOREA_3
          - opc_opc:4
            opc_texto:Construcción
            Tabla_saltos:
            - sal_destino:RAZON_NOREA_4
          - opc_opc:5
            opc_texto:Vivienda usada como establecimiento
            Tabla_saltos:
            - sal_destino:RAZON_NOREA_5
          - opc_opc:6
            opc_texto:Variaciones en el listado
            Tabla_saltos:
            - sal_destino:RAZON_NOREA_6
          - opc_opc:7
            opc_texto:Ausencia 
            Tabla_saltos:
            - sal_destino:RAZON_NOREA_7
          - opc_opc:8
            opc_texto:Rechazo 
            Tabla_saltos:
            - sal_destino:RAZON_NOREA_8
          - opc_opc:9
            opc_texto:Otras causas
            Tabla_saltos:
            - sal_destino:RAZON_NOREA_9
    - pre_pre:razon_1_1
      Tabla_variables:
      - var_var:RAZON_NOREA_1
        var_conopc:RAZON_NOREA_1
        var_destino:Fin
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Venta o alquiler
          - opc_opc:2
            opc_texto:Sucesión o remate
          - opc_opc:3
            opc_texto:Construccion reciente
          - opc_opc:4
            opc_texto:Sin causa conocida
    - pre_pre:razon_1_2
      Tabla_variables:
      - var_var:RAZON_NOREA_2
        var_conopc:RAZON_NOREA_2
        var_destino:Fin
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Fue demolida
          - opc_opc:2
            opc_texto:En demolición
          - opc_opc:3
            opc_texto:Levantada
          - opc_opc:4
            opc_texto:Tapiada
    - pre_pre:razon_1_3
      Tabla_variables:
      - var_var:RAZON_NOREA_3
        var_conopc:RAZON_NOREA_3
        var_texto:Viven en otra vivienda la mayor parte...
        var_destino:Fin
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:de la semana
          - opc_opc:2
            opc_texto:del mes
          - opc_opc:3
            opc_texto:del año
    - pre_pre:razon_1_4
      Tabla_variables:
      - var_var:RAZON_NOREA_4
        var_conopc:RAZON_NOREA_4
        var_destino:Fin
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Se está construyendo
          - opc_opc:2
            opc_texto:Construccion paralizada
          - opc_opc:3
            opc_texto:Refacción
    - pre_pre:razon_1_5
      Tabla_variables:
      - var_var:RAZON_NOREA_5
        var_conopc:RAZON_NOREA_5
        var_destino:Fin
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Conserva comodidad de vivienda
    - pre_pre:razon_1_6
      Tabla_variables:
      - var_var:RAZON_NOREA_6
        var_conopc:RAZON_NOREA_6
        var_destino:Fin
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:No existe lugar físico
          - opc_opc:2
            opc_texto:No es vivienda
          - opc_opc:3
            opc_texto:Existen otras viviendas
          - opc_opc:4
            opc_texto:Otro
    - pre_pre:razon_1_7
      Tabla_variables:
      - var_var:RAZON_NOREA_7
        var_conopc:RAZON_NOREA_7
        var_destino:Fin
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:No se pudo contactar en 3 visitas
          - opc_opc:2
            opc_texto:Por causas circunstanciales
          - opc_opc:3
            opc_texto:Viaje
          - opc_opc:4
            opc_texto:Vacaciones
    - pre_pre:razon_1_8
      Tabla_variables:
      - var_var:RAZON_NOREA_8
        var_conopc:RAZON_NOREA_8
        var_destino:Fin
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Negativa rotunda
          - opc_opc:2
            opc_texto:Rechazo por portero eléctrico
          - opc_opc:3
            opc_texto:Se acordaron entrevistas que no se concretaron
    - pre_pre:razon_1_9
      Tabla_variables:
      - var_var:RAZON_NOREA_9
        var_conopc:RAZON_NOREA_9
        var_destino:Fin
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Inquilinato, pención, hotel, usurpado, conventillo
          - opc_opc:2
            opc_texto:Duelo, alcoholismo, discapacidad, idioma extranjero
          - opc_opc:3
            opc_texto:Problemas de seguridad
          - opc_opc:4
            opc_texto:Inaccesible(Problemas climáticos u otros)
  - blo_blo:1
    blo_texto:COMPONENTES DEL HOGAR
    blo_mat:''
    blo_incluir_mat:M
  - blo_blo:1_M
    blo_texto:COMPONENTES DEL HOGAR
    blo_mat:M
    Tabla_preguntas:
    - pre_pre:P1
      pre_texto:Nombre
      Tabla_variables:
      - var_var:P1
        var_texto:Nombre de pila
    - pre_pre:P4
      pre_texto:Parantesco
      Tabla_variables:
      - var_var:P4
        var_texto:¿Cual es la relación de parentesco con el jefe/a?
        var_aclaracion:Anote código
        var_conopc:P4
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Jefe/a
          - opc_opc:2
            opc_texto:Cónyuge/pareja
          - opc_opc:3
            opc_texto:Hijo/a Hijastro/a
          - opc_opc:4
            opc_texto:Padre/Madre
          - opc_opc:5
            opc_texto:Hermano/a
          - opc_opc:6
            opc_texto:Suegro/a
          - opc_opc:7
            opc_texto:Yerno/nuera
          - opc_opc:8
            opc_texto:Nieto/Nieta
          - opc_opc:9
            opc_texto:Otro familiar
          - opc_opc:10
            opc_texto:Otro no familiar
    - pre_pre:P2
      pre_texto:Sexo
      Tabla_variables:
      - var_var:P2
        var_texto:Sexo
        var_aclaracion:Anote código
        var_conopc:P2
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Varón
          - opc_opc:2
            opc_texto:Mujer
    - pre_pre:P3_b
      pre_texto:Edad
      Tabla_variables:
      - var_var:P3_b
        var_desp_nombre:P3.b
        var_texto:¿Cuál es su edad en años cumplidos?
        var_aclaracion:Si no hay alguna persona de 18 años y más: Fin de la entrevistas
        var_tipovar:numeros
    - pre_pre:P6
      pre_texto:Letra
      Tabla_variables:
      - var_var:P6
        var_texto:Letra de orden segun edad
        var_aclaracion:Para personas de 18 años y más. Comience con la letra A a partir de la persona de mayor edad y continúe
        var_expresion_habilitar:p3_b>=18
    - pre_pre:M1
      pre_texto:Nacio en
      Tabla_variables:
      - var_var:M1
        var_texto:Dónde nació
        var_conopc:M1
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:En esta Ciudad
          - opc_opc:2
            opc_texto:En la Provincia de Buenos Aires
          - opc_opc:3
            opc_texto:En otra Provincia
            opc_aclaracion:Especifique
          - opc_opc:4
            opc_texto:En otro país
            opc_aclaracion:Especifique
    - pre_pre:M1_3_esp
      pre_texto:''
      Tabla_variables:
      - var_var:M1_3_esp
        var_tipovar:texto
        var_expresion_habilitar:m1=3
    - pre_pre:M1_4_esp
      pre_texto:''
      Tabla_variables:
      - var_var:M1_4_esp
        var_tipovar:texto
        var_expresion_habilitar:m1=4
    - pre_pre:P5
      pre_texto:Conyugal
      Tabla_variables:
      - var_var:P5
        var_texto:¿Actualmente está....
        var_aclaracion:(G-S) Anote código. Para personas de 14 años y más.
        var_expresion_habilitar:p3_b>=14
        var_conopc:P5
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Unido/a
          - opc_opc:2
            opc_texto:Casado/a
          - opc_opc:3
            opc_texto:Separado/a
          - opc_opc:4
            opc_texto:Divorciado/a
          - opc_opc:5
            opc_texto:Viudo/a
          - opc_opc:6
            opc_texto:Soltero/a          
    - pre_pre:P8
      pre_texto:Asiste...
      Tabla_variables:
      - var_var:P8
        var_texto:¿Asiste o asistió a algún establecimiento educativo?
        var_aclaracion:Anote código
        var_conopc:P8
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Asiste
          - opc_opc:2
            opc_texto:Asistió
          - opc_opc:3
            opc_texto:Nunca asistió
        Tabla_saltos:
        - sal_opc:3
          sal_destino:Fin  
    - pre_pre:P9
      pre_texto:Nivel
      Tabla_variables:
      - var_var:P9
        var_texto:¿Cuál es el nivel más alto que cursa o cursó?
        var_aclaracion:Anote código
        var_conopc:P9
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Jardín /Preescolar
          - opc_opc:2
            opc_texto:Primario
          - opc_opc:3
            opc_texto:E.G.B./E.S.B.
          - opc_opc:4
            opc_texto:Secundario/Medio
          - opc_opc:5
            opc_texto:Polimodal
          - opc_opc:6
            opc_texto:Terciario
          - opc_opc:7
            opc_texto:Universitario
          - opc_opc:8
            opc_texto:Posgrado universitario
          - opc_opc:9
            opc_texto:Educación especial
    - pre_pre:P10
      pre_texto:Finalizo
      Tabla_variables:
      - var_var:P10
        var_texto:¿Finalizó ese nivel?
        var_aclaracion:Anote código
        var_conopc:sino 
        Tabla_saltos:
        - sal_opc:1
          sal_destino:Fin
    - pre_pre:P11
      pre_texto:Ultimo
      Tabla_variables:
      - var_var:P11
        var_texto:¿Cuál fue el último grado/año que aprobó?
        var_aclaracion:Anote código
        var_conopc:P11
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:0
            opc_texto:Ninguno
          - opc_opc:1
            opc_texto:Primero
          - opc_opc:2
            opc_texto:Segundo
          - opc_opc:3
            opc_texto:Tercero
          - opc_opc:4
            opc_texto:Cuarto
          - opc_opc:5
            opc_texto:Quinto
          - opc_opc:6
            opc_texto:Sexto
          - opc_opc:7
            opc_texto:Séptimo
          - opc_opc:8
            opc_texto:Octavo
          - opc_opc:9
            opc_texto:Noveno
          - opc_opc:99
            opc_texto:Ns/nc    
  - blo_blo:1_1
    blo_texto:TABLA DE SELECCION DE COMPONENTES Y CUADRO RESUMEN
    blo_mat:''
    Tabla_preguntas:
    - pre_pre:total_pr
      Tabla_variables:
      - var_var:total_pr
        var_texto:Total de personas en el rango
        var_tipovar:numeros
    - pre_pre:ultimo_digito
      pre_texto:Tabla para seleccionar la persona a encuestar
      Tabla_variables:
      - var_var:ultimo_digito
        var_expresion_habilitar:total_pr
        var_tipovar:numeros
        var_texto:Último dígito del Nº de encuesta
    - pre_pre:ps1
      pre_texto:''
      Tabla_variables:
      - var_var:ps1
        var_texto:Nº de componente de 18 años y más
        var_expresion_habilitar:total_pr
        var_tipovar:numeros
        var_desp_nombre:''
    - pre_pre:ps2
      pre_texto:''
      Tabla_variables:
      - var_var:ps2
        var_texto:Ningún componente comprendido entre 18 años y más
        var_expresion_habilitar:!total_pr
        var_conopc:ps2
        var_desp_nombre:''
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:marque
            Tabla_saltos:
            - sal_destino:fin
  - blo_blo:2
    blo_texto:CARACTERÍSTICAS DE LA VIVIENDA
    blo_mat:''
    Tabla_preguntas:
    - pre_pre:v2
      pre_texto:''
      Tabla_variables:
      - var_var:v2
        var_texto:Tipo de vivienda
        var_aclaracion:(observacional)
        var_expresion_habilitar:pk_tra_hog=1
        var_conopc:v2
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Casa
          - opc_opc:2
            opc_texto:Departamento
          - opc_opc:3
            opc_texto:Inquilinato o conventillo
          - opc_opc:4
            opc_texto:Hotel/Pensión
          - opc_opc:5
            opc_texto:Construcción no destinada a vivienda
          - opc_opc:6
            opc_texto:Rancho o casilla
          - opc_opc:7
            opc_texto:Otro
            opc_aclaracion:(Especificar)            
      - var_var:v2_7_esp
        var_tipovar:texto
        var_subordinada_var:v2
        var_subordinada_opcion:7
    - pre_pre:v4
      pre_texto:¿Cuántas habitaciones/ambientes tiene, en total, esta vivienda? Sin contar baños, cocina/s, garages o pasillos
      Tabla_variables:
      - var_var:v4
        var_expresion_habilitar:pk_tra_hog=1
        var_texto:Total habitaciones / ambientes
        var_tipovar:numeros
    - pre_pre:v5
      pre_texto:''
      Tabla_variables:
      - var_var:v5
        var_expresion_habilitar:pk_tra_hog=1
        var_texto:Los pisos interiores son principalmente de...
        var_aclaracion:(G-S)
        var_conopc:v5
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Mosaico / baldosa / madera / cerámica
          - opc_opc:2
            opc_texto:Cemento / ladrillo fijo
          - opc_opc:3
            opc_texto:ladrillo suelto / tierra
          - opc_opc:4
            opc_texto:Otro material
            opc_aclaracion:(especificar)
      - var_var:v5_4_esp
        var_tipovar:texto
        var_subordinada_var:v5
        var_subordinada_opcion:4
    - pre_pre:v12
      pre_texto:''
      Tabla_variables:
      - var_var:v12
        var_texto:Esta vivienda ¿dispone de... 
        var_expresion_habilitar:pk_tra_hog=1
        var_aclaracion:(G-S)
        var_conopc:v12
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:Inodoro o retrete con descarga de agua (botón, cadena, etc.) a red cloacal pública?
          - opc_opc:2
            opc_texto:Inodoro o retrete con descarga de agua (botón, cadena, etc.) a pozo o cámara séptica?
          - opc_opc:3
            opc_texto:Inodoro o retrete sin descarga de agua (letrina)
          - opc_opc:4
            opc_texto:No dispone de  inodoro o retrete
            Tabla_saltos:
            - sal_destino:h2
  - blo_blo:3
    blo_texto:CARACTERÍSTICAS DEL HOGAR
    blo_mat:''
    Tabla_preguntas:
    - pre_pre:h1
      pre_texto:''
      Tabla_variables:
      - var_var:h1
        var_texto:¿El baño es...
        var_aclaracion:(G-S)
        var_conopc:h1
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:de uso exclusivo del hogar?
          - opc_opc:2
            opc_texto:compartido con otro hogar?
    - pre_pre:h2
      pre_texto:''
      Tabla_variables:
      - var_var:h2
        var_texto:¿Este hogar es...
        var_aclaracion:(G-S)
        var_conopc:h2
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:propietario de la vivienda y el terreno?
          - opc_opc:2
            opc_texto:propietario de la vivienda solamente?
          - opc_opc:3
            opc_texto:inquilino o arrendatario?
          - opc_opc:4
            opc_texto:ocupante en relacion de dependencia / por trabajo?
          - opc_opc:5
            opc_texto:ocupante por préstamo, sesión, o servicio gratuito (sin pago)?
          - opc_opc:6
            opc_texto:ocupante de hecho de la vivienda?
          - opc_opc:7
            opc_texto:Otro 
            opc_aclaracion:(especificar)
      - var_var:h2_7_esp
        var_tipovar:texto
        var_subordinada_var:h2
        var_subordinada_opcion:7
    - pre_pre:h3
      pre_texto:¿Cuántas habitaciones/ambientes son de uso exclusivo de este hogar? 
      Tabla_variables:
      - var_var:h3
        var_texto:Total habitaciones / ambientes de uso exclusivo
        var_tipovar:numeros    
    - pre_pre:h4
      Tabla_variables:
      - var_var:h4
        var_texto:¿Disponen de telefono para el uso del hogar? 
        var_conopc:sino
        Tabla_saltos:
        - sal_opc:2
          sal_destino:h5_1
      - var_var:h4_tipot
        var_conopc:FijoCelularAmbos
      - var_var:h4_tel
        var_texto:¿Desea dar algún número?
        var_tipovar:texto
    - pre_pre:h5
      pre_texto:En su hogar tienen... 
      pre_aclaracion:(G-S)
      pre_desp_opc:horizontal
      Tabla_variables:
      - var_var:h5_1
        var_texto:Plasma/LCD/LED? 
        var_conopc:UnaDosymasNotienen
      - var_var:h5_2
        var_texto:Smart TV? 
        var_conopc:UnaDosymasNotienen
      - var_var:h5_3
        var_texto:Computadora de escritorio?
        var_conopc:UnaDosymasNotienen
      - var_var:h5_4
        var_texto:Notebook/netbook? 
        var_conopc:UnaDosymasNotienen
      - var_var:h5_5
        var_texto:Tablet/Ipad? 
        var_conopc:UnaDosymasNotienen
      - var_var:h5_6
        var_texto:Consola de video/wii/play station? 
        var_conopc:UnaDosymasNotienen
      - var_var:h5_7
        var_texto:Lavavajilla? 
        var_conopc:UnaDosymasNotienen
      - var_var:h5_8
        var_texto:Automóvil? 
        var_conopc:UnaDosymasNotienen
      - var_var:h5_9
        var_texto:TV por cable o satelital? 
        var_conopc:sino
      - var_var:h5_10
        var_texto:Conexión a internet 
        var_conopc:sino
      - var_var:h5_11
        var_texto:Teléfono celular de uso exclusivo del hogar? 
        var_conopc:sino
  - blo_blo:4
    blo_texto:ESTRATEGIAS DEL HOGAR
    blo_mat:''
    Tabla_preguntas:
    - pre_pre:h20
      pre_texto:Le voy a nombrar las distinatas maneras para mantener un hogar y quisiera que me diga TODAS las que Uds. utilizan. En los últimos 3 meses este hogar a vivido...
      pre_aclaracion:(G-M)
      Tabla_variables:
      - var_var:h20_1
        var_desp_nombre:1
        var_tipovar:multiple_marcar
        var_texto:De lo que ganan los mienbros del hogar en el trabajo?
      - var_var:h20_2
        var_desp_nombre:2
        var_tipovar:multiple_marcar
        var_texto:Retirando dinero o mercadería del propio negocio?
      - var_var:h20_3
        var_desp_nombre:3
        var_tipovar:multiple_marcar
        var_texto:De la jubilación o pensión de alguno de los miembros del hogar?
      - var_var:h20_4
        var_desp_nombre:4
        var_tipovar:multiple_marcar
        var_texto:De seguro de desempleo?
      - var_var:h20_5
        var_desp_nombre:5
        var_tipovar:multiple_marcar
        var_texto:Indemnización por despido?
      - var_var:h20_6
        var_desp_nombre:6
        var_tipovar:multiple_marcar
        var_texto:De cobro de alquileres, rentas, intereses o dividendos?
      - var_var:h20_7
        var_desp_nombre:7
        var_tipovar:multiple_marcar
        var_texto:De cuotas de alimentos?
      - var_var:h20_8
        var_desp_nombre:8
        var_tipovar:multiple_marcar
        var_texto:De ayuda en dinero de personas que no viven en el hogar?
      - var_var:h20_9
        var_desp_nombre:9
        var_tipovar:multiple_marcar
        var_texto:De subsidio o plan social en dinero del Gobierno Nacional o local?
        var_aclaracion:(Programa de Ciudadanía Porteña, Asignación Universal por Hijo, etc)
      - var_var:h20_10
        var_desp_nombre:10
        var_tipovar:multiple_marcar
        var_texto:Comprando fiado o en cuotas?
      - var_var:h20_11
        var_desp_nombre:11
        var_tipovar:multiple_marcar
        var_texto:De alguna otra forma?
        var_aclaracion:(especificar)
      - var_var:h20_11_esp
        var_tipovar:texto
        var_subordinada_var:h20_11
  - blo_blo:5
    blo_texto:INGRESOS DEL HOGAR
    blo_mat:''
    Tabla_preguntas:
    - pre_pre:i1
      pre_texto:Cuál fué el ingreso total de su hogar el mes pasado?
      pre_aclaracion:(Incluya ingresos provenientes del trabajo, jubilaciones, rentas, seguro de desempleo, becas, cuotas de alimentos, etc.)
      Tabla_variables:
      - var_var:i1
        var_desp_nombre:1
        var_optativa:true
        var_texto:Monto
      - var_var:i2        
        var_texto:''
        var_conopc:i2
        var_expresion_habilitar:!i1 or i1=0
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:2
            opc_texto:Sin ingresos
          - opc_opc:9
            opc_texto:Ns/Nc
      Tabla_filtros:
      - fil_fil:FILTRO_18_ANIOS
        fil_mat:''
        fil_texto:Si el Nº de componente seleccionado de 18 años y mas es igual a 1 pasa a F-AJI 1
        fil_expresion:ps1=1
        fil_destino:fin
  - blo_blo:6
    blo_texto:SITUACIÓN LABORAL DEL JEFE/JEFA DEL HOGAR
    blo_mat:''
    Tabla_preguntas:
    - pre_pre:tj1
      pre_texto:''
      Tabla_variables:
      - var_var:tj1
        var_texto:¿La semana pasada trabajó por lo menos 1 hora?
        var_conopc:sino
        Tabla_saltos:
        - sal_opc:1
          sal_destino:tj44
    - pre_pre:tj2
      pre_texto:''
      Tabla_variables:
      - var_var:tj2
        var_texto:¿En esa semana hizo alguna changa, fabricó algom para vender, ayudó a un familiar / amigo en su negocio?
        var_conopc:sino
        Tabla_saltos:
        - sal_opc:1
          sal_destino:tj44
    - pre_pre:tj3
      pre_texto:''
      Tabla_variables:
      - var_var:tj3
        var_texto:¿La semana pasada...?
        var_aclaracion:(G-S)
        var_conopc:tj3
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:no deseaba / no quería / no podía trabajar?
            Tabla_saltos:
            - sal_destino:fin
          - opc_opc:2
            opc_texto:no tenía / no conseguía trabajo?
            Tabla_saltos:
            - sal_destino:tj9
          - opc_opc:3
            opc_texto:no tuvo pedidos / clientes?
            Tabla_saltos:
            - sal_destino:tj9
          - opc_opc:4
            opc_texto:tenía un trabajo / negocio al que no concurrió?
    - pre_pre:tj4
      pre_texto:''
      Tabla_variables:
      - var_var:tj4
        var_texto:¿No concurrió por...?
        var_conopc:tj4
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:vacaciones, licencia?
            opc_aclaracion:(enfermedad, matrimonio, embarazo, etc.)
            Tabla_saltos:
            - sal_destino:tj44
          - opc_opc:2
            opc_texto:causas personales?
            opc_aclaracion:(viajes, trámites, etc.)
            Tabla_saltos:
            - sal_destino:tj44
          - opc_opc:3
            opc_texto:huelga o conflicto laboral?
            Tabla_saltos:
            - sal_destino:tj44
          - opc_opc:4
            opc_texto:suspención con pago?
            Tabla_saltos:
            - sal_destino:tj44
          - opc_opc:5
            opc_texto:suspención sin pago?
            Tabla_saltos:
            - sal_destino:tj9
          - opc_opc:6
            opc_texto:otras causas laborales y volverá a lo sumo en un mes?
            Tabla_saltos:
            - sal_destino:tj44
          - opc_opc:7
            opc_texto:otras causas laborales y volverá en más de un mes?
            Tabla_saltos:
            - sal_destino:tj9
    - pre_pre:tj9
      pre_texto:''
      Tabla_variables:
      - var_var:tj9
        var_texto:En los últimos 30 días,¿estuvo buscando trabajo de alguna manera?
        var_conopc:sino
        Tabla_saltos:
        - sal_opc:1
          sal_destino:fin
    - pre_pre:tj10
      pre_texto:''
      Tabla_variables:
      - var_var:tj10
        var_texto:Durante esos 30 días consultó amigos / parientes, puso carteles, hizo algo para ponerse por su cuenta?
        var_conopc:sino
        Tabla_saltos:
        - sal_opc:1
          sal_destino:fin
    - pre_pre:tj11
      pre_texto:''
      Tabla_variables:
      - var_var:tj11
        var_texto:¿Durante esos 30 días no buscó trabajo porque...?
        var_conopc:tj11
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:esta suspendido
            Tabla_saltos:
            - sal_destino:fin
          - opc_opc:2
            opc_texto:no tenía / no conseguía trabajo?
            Tabla_saltos:
            - sal_destino:fin
          - opc_opc:3
            opc_texto:se canso de buscar trabajo?
            Tabla_saltos:
            - sal_destino:fin 
          - opc_opc:4
            opc_texto:hay poco trabajo en esta epoca del año?
            Tabla_saltos:
            - sal_destino:fin   
          - opc_opc:5
            opc_texto:Otro
            opc_aclaracion:(Especificar)  
      - var_var:tj11_5_esp
        var_destino:fin
        var_tipovar:texto
        var_subordinada_var:tj11
        var_subordinada_opcion:5
        var_expresion_habilitar:tj11=5
    - pre_pre:tj44
      pre_texto:''
      Tabla_variables:
      - var_var:tj44
        var_texto:¿En la ocupación principal (si tiene mas de una aquella que habitualmente le llava más horas), trabaja..?
        var_conopc:tj44
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:para su propio negocio/empresa/actividad?
            Tabla_saltos:
            - sal_destino:tj46
          - opc_opc:2
            opc_texto:como obrero o empleado para un patrón/empresa/institución (incluye agencia de empleo)?
          - opc_opc:3
            opc_texto:como servicio domestico?
          - opc_opc:4
            opc_texto:como trabajador familiar sin pago?
    - pre_pre:tj51
      pre_texto:''
      Tabla_variables:
      - var_var:tj51
        var_texto:¿En ese trabajo..?
        var_aclaracion:(G-S)
        var_conopc:tj51
        var_destino:Fin
        Tabla_con_opc:
        - Tabla_opciones:
          - opc_opc:1
            opc_texto:le descuentan para la jubilacion?
          - opc_opc:2
            opc_texto:aportra por si mismo para jubilación?
          - opc_opc:3
            opc_texto:no le descuentan ni aporta?
    - pre_pre:tj46
      pre_texto:''
      Tabla_variables:
      - var_var:tj46
        var_texto:¿En ese negocio/empresa/actividad se emplean personas asalariadas
        var_conopc:sino      
YAML
);
    $this->metadatos_ajus['ope_tlg']=PRIMER_TLG;
    Loguear('2012-03-05','terminé el yaml');
/* 
echo "<pre>";
print_r($metadatos_ajus);
echo "</pre>";
// */
///////////////////////////        
    }
    function sqls_instalacion(){
      $insertador=new Insertador_multiple();
      $sqlsalir = new Sqls;
      $tabla_saltos=new Tabla_saltos();
      $sqlsalir->agregar($tabla_saltos->sql_eliminacion_fk('variables'));
      $sqlsalir->agregar($insertador->sqls_insercion($this->metadatos_ajus,new Tabla_operativos()));
      $sqlsalir->agregar($tabla_saltos->sql_creacion_fk('variables'));
      return $sqlsalir;
    }
}

class Tablas_planas extends Objeto_de_la_base{ 
    function __construct(){
        parent::__construct();
        $this->definir_esquema('encu');
    }
    function ejecutar_instalacion(){
        $tabla_matrices=$this->contexto->nuevo_objeto('Tabla_matrices');
        $tabla_matrices->leer_varios(array());
        while($tabla_matrices->obtener_leido()){
            $tra_for=$tabla_matrices->datos->mat_for;
            $tra_mat=$tabla_matrices->datos->mat_mat;
            Tabla_planas::crear_jsones($this->contexto,$tra_for,$tra_mat);
            $tabla_plana=$this->contexto->nuevo_objeto("Tabla_plana_{$tra_for}_{$tra_mat}");
            $tabla_plana->ejecutar_instalacion();
        }
    }
}

class Metadatos_ajus2 extends Objeto_de_la_base{ 
    function __construct(){
        parent::__construct();
        $this->definir_esquema('encu');
    }
    function ejecutar_instalacion(){
        $sqlsalir = new Sqls;
        $tabla_saltos=new Tabla_saltos();
        $tabla_preguntas=new Tabla_preguntas();
        $tabla_filtros=new Tabla_filtros();
        $tabla_variables = new Tabla_variables();
        $tabla_bloques = new Tabla_bloques();

        /* para el lower
        $sqlsalir->agregar($tabla_saltos->sql_eliminacion_fk('variables'));
        $sqlsalir->agregar($tabla_variables->sql_eliminacion_fk('preguntas'));
        $sqlsalir->agregar($tabla_preguntas->sql_eliminacion_fk('bloques'));
        
        $tabla_variables->contexto = $this->contexto;
        $tabla_saltos->contexto = $this->contexto;
        $tabla_preguntas->contexto = $this->contexto;
        $tabla_filtros->contexto = $this->contexto;
        $tabla_bloques->contexto = $this->contexto;
        
        $tabla_bloques->leer_varios(array(
            'blo_ope'=>'AJUS'
            ));
        while($tabla_bloques->obtener_leido()){
            $tabla_bloques->valores_para_update['blo_blo']=strtolower($tabla_bloques->datos->blo_blo);
            $sqlsalir->agregar($tabla_bloques->sql_update_varios(array(
               'blo_ope'=>$tabla_bloques->datos->blo_ope,
               'blo_blo'=>$tabla_bloques->datos->blo_blo,
            )));
        }
        $tabla_preguntas->leer_varios(array(
            'pre_ope'=>'AJUS'
            ));
        Loguear('2012-03-05','un gran while');        
        while($tabla_preguntas->obtener_leido()){
            $tabla_preguntas->valores_para_update['pre_pre']=strtolower($tabla_preguntas->datos->pre_pre);
            $tabla_preguntas->valores_para_update['pre_blo']=strtolower($tabla_preguntas->datos->pre_blo);
            $sqlsalir->agregar($tabla_preguntas->sql_update_varios(array(
               'pre_pre'=>$tabla_preguntas->datos->pre_pre,
               'pre_blo'=>$tabla_preguntas->datos->pre_blo
            )));
        }
        Loguear('2012-03-05','un gran while finalizado');        
        $tabla_filtros->leer_varios(array(
            'fil_ope'=>'AJUS'
            ));
        Loguear('2012-03-05','un gran while');        
        while($tabla_filtros->obtener_leido()){
            $tabla_filtros->valores_para_update['fil_destino']=strtolower($tabla_filtros->datos->fil_destino);
            Loguear('2012-03-28','FILTRO DESTINO '.strtolower($tabla_filtros->datos->fil_destino));
            $sqlsalir->agregar($tabla_filtros->sql_update_varios(array(
               'fil_fil'=>$tabla_filtros->datos->fil_fil
            )));
        }
        // Reemplazar por un único UPDATE #382
        $tabla_variables->leer_varios(array(
            'var_ope'=>'AJUS'
            ));
        while($tabla_variables->obtener_leido()){
            $tabla_variables->valores_para_update['var_var']=strtolower($tabla_variables->datos->var_var);
            $tabla_variables->valores_para_update['var_pre']=strtolower($tabla_variables->datos->var_pre);
            $tabla_variables->valores_para_update['var_subordinada_var']=$tabla_variables->datos->var_subordinada_var===NULL?NULL:strtolower($tabla_variables->datos->var_subordinada_var);
            $tabla_variables->valores_para_update['var_desp_nombre']=$tabla_variables->datos->var_desp_nombre===NULL?NULL:strtolower($tabla_variables->datos->var_desp_nombre);
            $tabla_variables->valores_para_update['var_destino']=$tabla_variables->datos->var_desp_nombre===NULL?NULL:strtolower($tabla_variables->datos->var_destino);
            $sqlsalir->agregar($tabla_variables->sql_update_varios(array(
               'var_ope'=>$tabla_variables->datos->var_ope,
               'var_var'=>$tabla_variables->datos->var_var,
            )));
        }
        
        $tabla_saltos->leer_varios(array(
            'sal_ope'=>'AJUS'
        ));
        while($tabla_saltos->obtener_leido()){
            $tabla_saltos->valores_para_update['sal_var']=strtolower($tabla_saltos->datos->sal_var);
            $tabla_saltos->valores_para_update['sal_destino']=strtolower($tabla_saltos->datos->sal_destino);
            $sqlsalir->agregar($tabla_saltos->sql_update_varios(array(
               'sal_var'=>$tabla_saltos->datos->sal_var,
               'sal_destino'=>$tabla_saltos->datos->sal_destino
            )));
        }
        $sqlsalir->agregar($tabla_saltos->sql_creacion_fk('variables'));
        $sqlsalir->agregar($tabla_variables->sql_creacion_fk('preguntas'));
        $sqlsalir->agregar($tabla_preguntas->sql_creacion_fk('bloques'));
        */
        $muestra_de_prueba=array();
        $cargar_tem_de_prueba=false;
        if($cargar_tem_de_prueba){
            $muestra_de_prueba=array(1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020);
            $tabla_claves=new Tabla_claves();
            $tabla_claves->valores_para_insert=array(
                'cla_ope'=>'AJUS',
                'cla_for'=>'TEM',
                'cla_mat'=>'',
            );
            foreach($muestra_de_prueba as $encuesta){
                $tabla_claves->valores_para_insert['cla_enc']=$encuesta;
                $sqlsalir->agregar($tabla_claves->sqls_insercion());
            }
            $tabla_claves->valores_para_insert['cla_enc']=1001;
            $tabla_claves->valores_para_insert['cla_for']='AJH1';
            $tabla_claves->valores_para_insert['cla_mat']='';
            $tabla_claves->valores_para_insert['cla_hog']=1;
            $sqlsalir->agregar($tabla_claves->sqls_insercion());
            $tabla_claves->valores_para_insert['cla_enc']=1001;
            $tabla_claves->valores_para_insert['cla_for']='AJI1';
            $sqlsalir->agregar($tabla_claves->sqls_insercion());
            $tabla_claves->valores_para_insert['cla_enc']=1001;
            $tabla_claves->valores_para_insert['cla_for']='AJH1';
            $tabla_claves->valores_para_insert['cla_mat']='M';
            $tabla_claves->valores_para_insert['cla_mie']=1;
            $tabla_claves->valores_para_insert['cla_hog']=1;
            $sqlsalir->agregar($tabla_claves->sqls_insercion());
            $tabla_claves->valores_para_insert['cla_mie']=2;
            $sqlsalir->agregar($tabla_claves->sqls_insercion());
            $this->contexto->db->ejecutar_sqls($sqlsalir);
            $sqlsalir=null;
            $tabla_respuestas=$tabla_claves->definicion_tabla('respuestas');
            $tabla_respuestas->contexto=$this->contexto;
            $filtro_update=cambiar_prefijo($tabla_claves->valores_para_insert,'cla_','res_');
            $filtro_update['res_var']='p1';
            $tabla_respuestas->valores_para_update['res_valor']='Carlos';
            $tabla_respuestas->ejecutar_update_unico($filtro_update);
            $filtro_update['res_mie']=1;
            $tabla_respuestas->valores_para_update['res_valor']='Maria';
            $tabla_respuestas->ejecutar_update_unico($filtro_update);
            unset($filtro_update['res_mie']);
            $filtro_update['res_mat']='';
            $filtro_update['res_var']='fecha_rea';
            $tabla_respuestas->valores_para_update['res_valor']='2012/03/22';
            $tabla_respuestas->ejecutar_update_unico($filtro_update);
            $filtro_update['res_for']='AJI1';
            $filtro_update['res_var']='t1';
            $tabla_respuestas->valores_para_update['res_valor']='3';
            $tabla_respuestas->ejecutar_update_unico($filtro_update);
        }
        foreach(explode(';',<<<SQL
update encu.bloques set blo_blo=lower(blo_blo);
update encu.preguntas set pre_pre=lower(pre_pre), pre_destino=lower(pre_destino), pre_desp_nombre=case when pre_desp_nombre is null and not (pre_pre ~ '[0-9]') then '' else null end;
update encu.variables set var_var=lower(var_var), var_destino=lower(var_destino), var_subordinada_var=lower(var_subordinada_var), var_desp_nombre=case when var_desp_nombre is null and not (var_var ~ '[0-9]') then '' else null end;
update encu.filtros set fil_fil=lower(fil_fil), fil_destino=lower(fil_destino);
update encu.saltos set sal_destino=lower(sal_destino);
SQL
            ) as $sentencia)
        {
            if($sentencia){
                $this->contexto->db->ejecutar_sql(new Sql($sentencia));
            }
        }
        $this->contexto->db->ejecutar_sql(new Sql(file_get_contents('../encuestas/proceso_marcar_para_supervisar.sql')));
    }
}
?>