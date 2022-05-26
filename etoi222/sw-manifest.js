"use strict";
// TEMPLATE-START
var version = 'v 3.05';
var appName = 'etoi222_test';
var urlsToCache = [
'../etoi222/etoi222_icon.png',
'../etoi222/etoi222_icon_super.png',
'../etoi222/etoi222_icon_capa.png',
'../tedede/comunes.js ',
'../tedede/cuantas_instancias.js ',
'../tedede/probador.css',
'../tedede/menu.css',
'../encuestas/encuestas.css',
'../encuestas/encuestas.js',
'../encuestas/mostrar_como_cachea.js',
'../encuestas/encu_especiales.js',
'../etoi222/etoi222.css',
'../etoi222/dbo_etoi222.js',
'../tedede/tedede.js ',
'../tedede/tedede.css ',
'../tedede/editor.js',
'../tedede/para_grilla.js',
'../tedede/tabulados.js',     //   #agregado para test
'../tedede/test_fondo_t.png', //   #agregado para test
'../etoi222/estructura_etoi222.js',
'../tercera/md5_paj.js',
'../tercera/aes.js',
'../etoi222/logo_app.png',
'../etoi222/logo_esperar.png',
'../etoi222/etoi222_fondo_t.png',
'../etoi222/etoi222_icon.gif',
'../etoi222/etoi222_icon_test.gif',
'../etoi222/etoi222_icon_desa.gif',
'../etoi222/etoi222_icon_capa.gif',
'../etoi222/etoi222.php?hacer=hoja_de_ruta',
'../etoi222/etoi222.php?hacer=hoja_de_ruta_super',
'../etoi222/etoi222.php?hacer=formularios_de_la_vivienda',
'../etoi222/etoi222.php?hacer=aviso_offline',
'../etoi222/etoi222.php?hacer=desplegar_formulario&todo={"tra_ope":"etoi222","tra_for":"S1","tra_mat":""}',
'../etoi222/etoi222.php?hacer=desplegar_formulario&todo={"tra_ope":"etoi222","tra_for":"S1","tra_mat":"P"}',
'../etoi222/etoi222.php?hacer=desplegar_formulario&todo={"tra_ope":"etoi222","tra_for":"A1","tra_mat":""}',
'../etoi222/etoi222.php?hacer=desplegar_formulario&todo={"tra_ope":"etoi222","tra_for":"I1","tra_mat":""}',
'../etoi222/etoi222.php?hacer=desplegar_formulario&todo={"tra_ope":"etoi222","tra_for":"SUP","tra_mat":""}',
'../tedede/compatibilidad.js ',
'../imagenes/bloq_mayus.jpg',
'../encuestas/control_mini_cal.js',
'../encuestas/calendario01.png',
'../encuestas/lapiz_calendario_active.png',
'../encuestas/lapiz_calendario.png',
'../encuestas/goma01_calendario_active.png',
'../encuestas/goma01_calendario.png',
'../encuestas/cuadrado_calendario.png',
'../encuestas/cuadradotic_calendario.png',
'../encuestas/fondo_calendario.png',
'../tercera/require-bro.js',
'../service-worker-admin.js',
];
  
var fallback = [
    {"path":"../etoi222/etoi222.php?hacer=cargar_dispositivo","fallback":"../etoi222/etoi222.php?hacer=aviso_offline"},
];
// TEMPLATE-END
var CACHE_NAME = appName + ':' + version;
var urlsCached;
// Fin de la espera?
self.addEventListener('install', async (evt) => {
    // @ts-expect-error Esperando que agregen el listener de 'fetch' en el sistema de tipos
    var event = evt;
    //si hay cambios no espero para cambiarlo
    //self.skipWaiting();
    console.log("instalando");
    var myHeaders = new Headers();
    myHeaders.append('pragma', 'no-cache');
    myHeaders.append('cache-control', 'no-cache');
    event.waitUntil(caches.open(CACHE_NAME).then((cache) => Promise.all(urlsToCache.map(async (urlToCache) => {
        var error = null;
        try {
            var myInit = {
            method: 'GET',
            headers: myHeaders,
            };
            var myRequest = new Request(urlToCache, myInit);
            await cache.add(myRequest);
        }
        catch (err) {
            error = err;
        }
        var message = { type: 'caching', url: urlToCache, error };
        self.clients.matchAll({ includeUncontrolled: true }).then(clients => {
            for (const client of clients)
                client.postMessage(message);
        });
        if (error)
            throw error;
    }))));
    // idea de informar error: https://stackoverflow.com/questions/62909289/how-do-i-handle-a-rejected-promise-in-a-service-worker-install-event
});
var specialSources = {
    "@version": () => version,
    "@CACHE_NAME": () => CACHE_NAME,
    "@urlsToCache": () => urlsToCache.map(r => { var u = new URL(new Request(r).url); return u.pathname + u.search; })
};
self.addEventListener('fetch', async (evt) => {
    // @ts-expect-error Esperando que agregen el listener de 'fetch' en el sistema de tipos
    var event = evt;
    var sourceParts = event.request.url.split('/');
    var source = sourceParts[sourceParts.length - 1];
    console.log("source", source);
    if (source in specialSources) {
        var value = await specialSources[source]();
        var miBlob = new Blob([JSON.stringify(value)], { type: "application/json" });
        var opciones = { "status": 200, "statusText": typeof value === "string" ? value : "@json", ok: true };
        var miRespuesta = new Response(miBlob, opciones);
        event.respondWith(miRespuesta);
    }
    else {
        event.respondWith(caches.open(CACHE_NAME).then((cache) => cache.match(event.request).then((response) => {
            console.log("respuesta caché: ", response);
            return response || fetch(event.request).catch(async (err) => {
                console.log(err);
                console.log("request: ", event.request);
                var fallbackResult = fallback.find((aFallback) => aFallback.path.includes(source));
                if (fallbackResult) {
                    return cache.match(fallbackResult.fallback).then((response) => {
                        if (response) {
                            console.log("respuesta fallback: ", response);
                            return response;
                        }
                        else {
                            throw err;
                        }
                    });
                }
                throw err;
            });
        })));
    }
});
self.addEventListener('activate', (evt) => {
    // @ts-expect-error Esperando que agregen el listener de 'fetch' en el sistema de tipos
    var event = evt;
    console.log("borrando caches viejas");
    event.waitUntil(caches.keys().then((cacheNames) => {
        return Promise.all(cacheNames.filter((cacheName) => cacheName != CACHE_NAME).map((cacheName) => {
            console.log("borrando cache ", cacheName);
            return caches.delete(cacheName);
        }));
    }));
});
self.addEventListener('message', function (evt) {
    console.log("mensaje: ", evt.data);
    if (evt.data == 'skipWaiting') {
        self.skipWaiting().then(() => console.log(version));
    }
});