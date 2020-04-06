<?php
//UTF-8:SÍ
/* ----------------------
= Introducción =

Si queremos usar metodologías ágiles o si queremos poder adaptarnos a los requerimientos cambiantes
vamos a tener que trabajar con pruebas todo lo que podamos. Lo ideal sería usar TDD todo el tiempo
(con TDD me refiero a hacer las pruebas antes o junto con el diseño de lo que se va a programar). 

El TDD se basa en diseños simples y concretos, ni de abajo hacia arriba ni de arriba hacia abajo, 
sino más bien, en cada paso de algo que anda a algo que anda, y la primera vez, de la nada misma
a algo que anda; y en todos casos algo que anda y está probado. 

Empecemos con un ejemplo lo más fácil posible (y que tenga que ver con lo que vamos a hacer):

Producto: una encuesta de ejemplo. 
Alcance: lo más simple posible, preguntas múltiple choice, un único formulario, un único bloque,
sin muestra, ni login, ni control de registros duplicados.

== ¿Cómo empezamos? ==

Vamos parte por parte y definamos los casos de prueba de cada parte.
 - Despliegue del formulario en HTML
 - Grabación de los resultados en la base de datos

REGLA 1: Todo lo que se programa es definitivo. 
REGLA 1S: No programamos nada que tenga agujeros de seguridad por más provisorio que creamos que pueda ser.
 
Concentrémonos en esas dos partes y despreocupémonos del resto (ej: cómo están almacenadas las preguntas
y las respuestas, cómo se inicia o abre la base de datos, etc. 
Para todas esas cuestiones no definidas supongamos que hay una clase que tiene las funciones que
necesitamos para contestar todas las preguntas que hagan falta, y, para la prueba, escribamos la 
versión más sencilla y menos genérica que podamos para cada una de esas funciones y clases.

Empecemos con el despliegue del formulario
*/
require_once "../tedede/probador.php";

class Desplegador_encuesta_ejemplo{
    var $estructura;
    var $html;
    function iniciar_con_estructura($json_de_estructura){
        $this->estructura=json_decode($json_de_estructura);
    }
    function singular_de($palabra){
        $singulares=array('preguntas'=>'pregunta', 'opciones'=>'opcion');
        return $singulares[$palabra]?:('singular de '.$palabra);
    }
    function obtener_html_de_nodo($estructura_nodo){
        $nodo_nodo=new Armador_de_salida(FALSE);
        foreach($estructura_nodo as $propiedad_nodo=>$valor_nodo){
            if($valor_nodo instanceof StdClass){
                $nodo_nodo->enviar($this->obtener_html_de_lista($valor_nodo,$this->singular_de($propiedad_nodo)),$propiedad_nodo);
            }else{
                $nodo_nodo->enviar($valor_nodo,$propiedad_nodo);
            }
        }
        return $nodo_nodo;
    }
    function obtener_html_de_lista($estructura_lista,$nombre_nodo_singular){
        $nodos_nodos=new Armador_de_salida(FALSE);
        foreach($estructura_lista as $estructura_nodo){
            $nodos_nodos->enviar($this->obtener_html_de_nodo($estructura_nodo),$nombre_nodo_singular);
        }
        return $nodos_nodos;
    }
    function obtener_html(){
        $html=$this->obtener_html_de_nodo($this->estructura);
        return $html->obtener_html();
    }
}


class Pruebas_encuesta_de_ejemplo extends Pruebas{
    function probar_que_de_error(){
        $this->probador->informar_error('probando cómo se ve el error');
    }
    function probar_despliegue(){
        $desplegador=new Desplegador_encuesta_ejemplo();
        $desplegador->iniciar_con_estructura(<<<JSON
{ "preguntas":
    { "no lo uso por ahora":
        { "id_pregunta": "P. 1."
        , "texto_pregunta": "Texto de la primer pregunta"
        , "opciones": 
            { "no lo uso por ahora": 
                { "id_opcion": "O. 1."
                , "texto_opcion": "Texto de la opción 1 de la primer pregunta"
                }
            , "no lo uso por ahora 2": 
                { "id_opcion": "O. 2."
                , "texto_opcion": "Texto de la opción 2 de la primer pregunta"
                }
            }
        }
    , "no lo uso por ahora 2": 
        { "id_pregunta": "P. 2."
        , "texto_pregunta": "Texto de la segunda pregunta (que es > que la primera)"
        , "opciones": {}
        }
    }
}
JSON
        );
        $obtenido=$desplegador->obtener_html();
        $this->probador->verificar_texto(<<<HTML
<DIV class="preguntas">
  <DIV class="pregunta">
    <DIV class="id_pregunta">
      P. 1.
    </DIV>
    <DIV class="texto_pregunta">
      Texto de la primer pregunta
    </DIV>
    <DIV class="opciones">
      <DIV class="opcion">
        <DIV class="id_opcion">
           O. 1.
        </DIV>
        <DIV class="texto_opcion">
          Texto de la opción 1 de la primer pregunta
        </DIV>
      </DIV>
      <DIV class="opcion">
        <DIV class="id_opcion">
          O. 2.
        </DIV>
        <DIV class="texto_opcion">
          Texto de la opción 2 de la primer pregunta
        </DIV>
      </DIV>
    </DIV>
  </DIV>
  <DIV class="pregunta">
    <DIV class="id_pregunta">
      P. 2.
    </DIV>
    <DIV class="texto_pregunta">
      Texto de la segunda pregunta (que es &gt; que la primera)
    </DIV>
    <DIV class="opciones">
    </DIV>
  </DIV>
</DIV>

HTML
            ,$obtenido
        );
    }
}

$probador=new Probador_minimo_HTML();
$probador->probar_todo();
$probador->mostrar_resumen();

?>