var count = 0;
var cant_activos = 0;
var activos={};
var port_activos={};
onconnect = function(evento) {
  count += 1;
  cant_activos += 1;
  var port = evento.ports[0];
  activos[count]=true;
  port_activos[count]=port;
  port.postMessage({tipo:'conexiones',cantidad:count,cant_activos:cant_activos,asignar_id:count});
  var avisar_a_los_activos=function(subtipo){
       //console.log('por avisar a '+JSON.stringify(activos));
       //console.log('por avisar a: '+JSON.stringify(port_activos));
      for(var id_activo in activos) if(activos.hasOwnProperty(id_activo)){
          var port_activo=port_activos[id_activo];
          port_activo.postMessage({
              tipo:'status',
              subtipo:subtipo,
              activos:activos,
              cant_activos:cant_activos,
          });
          /*
          port_activo.postMessage({
              tipo:'status',
              subtipo:subtipo,
              activos:'SEGUNDO',
              cant_activos:cant_activos,
          });
          */
          // console.log('mando mensaje a '+id_activo+' '+subtipo);
      }
  }
  //port.addEventListener('message')(function(evento) {
  port.onmessage=function(evento) {
    if(evento.data.accion=='desconectar'){
      if(activos[evento.data.id_desconectando]){
        cant_activos--;
      }
      delete activos[evento.data.id_desconectando];
      delete port_activos[evento.data.id_desconectando];
      avisar_a_los_activos('cierre');
    }
    if(evento.data.accion=='status'){
      port.postMessage({
        tipo:'status',
        activos:activos,
        cant_activos:cant_activos,
      });
    }
  }
  // });
  // console.log('por entrar a avisar');
  avisar_a_los_activos('nuevo');
}
