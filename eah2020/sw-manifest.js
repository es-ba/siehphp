"use strict";
// TEMPLATE-START
var version = 'v 3.03h';
var appName = 'eah2020_test';
var urlsToCache = [
'../eah2020/eah2020_icon.png',
'../eah2020/eah2020_icon_super.png',
'../eah2020/eah2020_icon_capa.png',
'../tedede/comunes.js ',
'../tedede/cuantas_instancias.js ',
'../tedede/probador.css',
'../tedede/menu.css',
'../encuestas/encuestas.css',
'../encuestas/encuestas.js',
'../encuestas/mostrar_como_cachea.js',
'../encuestas/encu_especiales.js',
'../eah2020/eah2020.css',
'../eah2020/dbo_eah2020.js',
'../tedede/tedede.js ',
'../tedede/tedede.css ',
'../tedede/editor.js',
'../tedede/para_grilla.js',
'../tedede/tabulados.js',     //   #agregado para test
'../tedede/test_fondo_t.png', //   #agregado para test
'../eah2020/estructura_eah2020.js',
'../tercera/md5_paj.js',
'../tercera/aes.js',
'../eah2020/logo_app.png',
'../eah2020/logo_esperar.png',
'../eah2020/eah2020_fondo_t.png',
'../eah2020/eah2020_icon.gif',
'../eah2020/eah2020_icon_test.gif',
'../eah2020/eah2020_icon_desa.gif',
'../eah2020/eah2020_icon_capa.gif',
'../eah2020/eah2020.php?hacer=hoja_de_ruta',
'../eah2020/eah2020.php?hacer=hoja_de_ruta_super',
'../eah2020/eah2020.php?hacer=formularios_de_la_vivienda',
'../eah2020/eah2020.php?hacer=aviso_offline',
'../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"S1","tra_mat":""}',
'../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"S1","tra_mat":"P"}',
'../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"A1","tra_mat":""}',
'../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"I1","tra_mat":""}',
// '../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"PMD","tra_mat":""}',
// '../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"GH","tra_mat":""}',
'../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"SUP","tra_mat":""}',
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
    {"path":"../eah2020/eah2020.php?hacer=cargar_dispositivo","fallback":"../eah2020/eah2020.php?hacer=aviso_offline"},
];
// TEMPLATE-END
var CACHE_NAME = appName + ':' + version;
var urlsCached;
// Fin de la espera?
self.addEventListener('install', async (evt) => {
    // @ts-expect-error Esperando que agregen el listener de 'fetch' en el sistema de tipos
    var event = evt;
    //si hay cambios no espero para cambiarlo
    // self.skipWaiting();
    console.log("instalando");
    event.waitUntil(caches.open(CACHE_NAME).then((cache) => Promise.all(urlsToCache.map(async (urlToCache) => {
        var error = null;
        try {
            await cache.add(urlToCache);
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
            return response || fetch(event.request).then((response) => {
                console.log("respuesta", response);
                if (!response) {
                    console.log("no tiene respuesta");
                    throw Error('without response');
                }
                return response;
            }).catch(async (err) => {
                console.log(err);
                var client = await self.clients.get(event.clientId);
                client.postMessage(err);
                return new Response(`<p>Se produjo un error al intentar cargar la p&aacute;gina, es posible que no haya conexi&oacute;n a internet</p><a href='/'>Volver a Hoja de Ruta</button>`, {
                    headers: { 'Content-Type': 'text/html' }
                });
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