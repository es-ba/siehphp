// tedede_cm_pr.js
// UTF-8:SÍ
"use strict";

var pru_casos_domCreator=[
    { modulo: pru_domCreator
    , casos: [
        { titulo: "párrafo simple"
        , entrada: { tipox: "p", nodes: "este texto" }
        , salida: "<p>este texto</p>"
        }
        , 
        { titulo: "párrafo vacío"
        , entrada: { tipox:"p" }
        , salida: "<p></p>"
        }
        , 
        { titulo: "párrafo con mucho contenido"
        , entrada: { tipox: "p", nodes: [ "algo con ", {tipox: "small", nodes: "algo chico"}, " dentro" ]}
        , salida: "<p>algo con <small>algo chico</small> dentro</p>"
        }
        , 
        { titulo: "párrafo con propiedades"
        , entrada: { tipox: "p", id:"este", className:"la clase", nodes:"un texto"}
        , salida: '<p id="este" class="la clase">un texto</p>'
        }
        , 
        { titulo: "lista de elementos"
        , entrada: [ {tipox: "p", nodes: "párrafo"}, "texto suelto"]
        , salida: '<p>párrafo</p>texto suelto'
        }
        , 
        { titulo: "elemento sin cierre (img)"
        , entrada: {tipox: "img", id:"el_id", src:'fuente'}
        , salida: '<img id="el_id" src="fuente">'
        }
        , 
        { titulo: "elemento con atributo inexistente"
        , entrada: {tipox: "img", id:"el_id", src:'fuente', inexistente:'este no va a aparecer'}
        , excepcion: 'atributo "inexistente" inexistente en elemento IMG'
        }
        , 
        { titulo: "estilo simple via string"
        , entrada: {tipox: "p", style:"position:absolute; left:10px; background-color:Black; inexistente:no_aparece"}
        , salida: '<p style="position: absolute; left: 10px; background-color: black;"></p>'
        }
        , 
        { titulo: "estilo simple via atributos"
        , entrada: {tipox: "p", style:{ position:'absolute', left:'10px', backgroundColor:'Black'}}
        , salida: '<p style="position: absolute; left: 10px; background-color: black;"></p>'
        }
        , 
        { titulo: "estilo inexistente"
        , entrada: {tipox: "p", style:{ position:'absolute', left:'10px', backgroundColor:'Black', no_existe:'no_aparece'}}
        , excepcion: 'estilo "no_existe" inexistente en elemento P'
        }
        , 
        { titulo: "SVG simple, teniendo en cuenta que lo que va en style ahí lo pone y que el namespace es optativo"
        , entrada: { tipox: "svg", xmlns:"http://www.w3.org/2000/svg", nodes:[ 
                {tipox: "circle", cx:"100", cy:"50", r:"40", stroke:"black", strokeWidth:"2", fill:"red"}
            ]}
        , salida_combinatoria:
            [ "<svg><circle style=\"stroke: #000000; stroke-width: 2px; fill: #ff0000;\""
            , { todas: [ ' cy="50"',' cx="100"', ' r="40"'] }
            , "></circle></svg>" 
            ]
        }
        , 
        { titulo: "ERROR sin tipox"
        , entrada: {style:{ position:'absolute', left:'10px', backgroundColor:'Black', no_existe:'no_aparece'}}
        , excepcion: 'Bad structure falta tipox'
        }
        , 
        { titulo: "tipox inexistente"
        , entrada: {tipox: "gr_no_existe"}
        , excepcion: 'tipox inexistente gr_no_existe'
        }
        , 
        { titulo: "tipox debug_dump"
        , entrada: {tipox: "debug_dump", otra:'algo', nodes:['esto', {"a":"b"}]}
        , salida: '{"tipox":"debug_dump","otra":"algo","nodes":["esto",{"a":"b"}]}'
        }
    ] 
    }
    , 
    { modulo: pru_domCreator_debug
    , casos: [
        { titulo: "Excepciones inline"
        , entrada: {tipox: "img", id:"el_id", src:'fuente', inexistente:'este no va a aparecer'}
        , salida: 
            { excepcion: 'atributo "inexistente" inexistente en elemento IMG'
            , salida: '<div class="debug_exceptions">atributo "inexistente" inexistente en elemento IMG</div>'
            }
        }
        ,
        { titulo: "ERROR sin tipox extendido"
        , entrada: {style:{ position:'absolute'}}
        , salida: 
            { excepcion: "Bad structure falta tipox"
            , salida: '<div class="debug_exceptions">Bad structure falta tipox {"style":{"position":"absolute"}}</div>'
            }
        }
    ]
    }
];

pru_casos=pru_casos.concat(pru_casos_domCreator);

function pru_domCreator_generico(caso,ejecutar){
    var domCreator=new DomCreator();
    var elemento_pru_domCreator=document.getElementById('elemento_pru_domCreator');
    if(!elemento_pru_domCreator){
        elemento_pru_domCreator=document.createElement('div');
        elemento_pru_domCreator.id='elemento_pru_domCreator';
        document.body.appendChild(elemento_pru_domCreator);
    }
    elemento_pru_domCreator.innerHTML='';
    pru_probador_modulo(caso,ejecutar);
    elemento_pru_domCreator.innerHTML='';
}

function pru_domCreator_debug(caso){
    var domCreator=new DomCreator();
    domCreator.show_exceptions=elemento_pru_domCreator;
    pru_domCreator_generico(caso,function(caso){
        var obtenido={};
        try{
            domCreator.grab(elemento_pru_domCreator,caso.entrada);
        }catch(err){
            obtenido.excepcion=err.message;
        }
        obtenido.salida=elemento_pru_domCreator.innerHTML;
        return obtenido;
    });
}

function pru_domCreator(caso){
    var domCreator=new DomCreator();
    pru_domCreator_generico(caso,function(caso){
        domCreator.grab(elemento_pru_domCreator,caso.entrada);
        return elemento_pru_domCreator.innerHTML;
    });
}
