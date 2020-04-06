//Función en caso de error
function loguear(mensaje){
    var txt= document.createTextNode(mensaje)
    document.body.appendChild(txt)
}

var error = function(e) {
    loguear('¡No pude grabarte!', e);
};

function hasGetUserMedia() {
  // Note: Opera builds are unprefixed.
  return !!(navigator.getUserMedia || navigator.webkitGetUserMedia ||
            navigator.mozGetUserMedia || navigator.msGetUserMedia);
}

loguear('hasGetUserMedia '+(hasGetUserMedia()? 'si':'no'));

 //Función cuando todo tenga exito
 var exito = function(s) {
 var context = new webkitAudioContext(); //Conectamos con nuestra entrada de audio
 var flujo = context.createMediaStreamSource(s); //Obtenemos el flujo de datos desde la fuente
 recorder = new Recorder(flujo); //Todo el flujo de datos lo pasamos a nuestra libreria para procesarlo en esta instancia
 recorder.record(); //Ejecutamos la función para procesarlo
 };
 //Convertirmos el objeto en URL
 window.URL = window.URL || window.webkitURL;
 navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;
 var recorder; //Es nuestra variable para usar la libreria Recorder.js
 var audio = document.querySelector('audio'); //Seleccionamos la etiqueta audio para enviarte el audio y escucharla
//Funcion para iniciar el grabado
 function grabar() {
 if (navigator.getUserMedia) { //Preguntamos si nuestro navegador es compatible con esta función que permite usar microfono o camara web
 navigator.getUserMedia({audio: true}, exito, error); //En caso de que si, habilitamos audio y se ejecutan las funciones, en caso de exito o error.
 } else {
 loguear('¡Tu navegador no es compatible!, ¿No lo vas a acutalizar?'); //Si no es compatible, enviamos este mensaje.
 }
 }
 //Funcion para parar la grabación y escucharla
 function parar() {
 recorder.stop(); //Paramos la grabación
 recorder.exportWAV(function(s) { //Exportamos en formato WAV el audio
 audio.src = window.URL.createObjectURL(s); //Y convertimos el valor devuelto en URL para pasarlo a nuestro reproductor.
 });
 }