(function (factory) {
    if (typeof module === "object" && typeof module.exports === "object") {
        var v = factory(require, exports);
        if (v !== undefined) module.exports = v;
    }
    else if (typeof define === "function" && define.amd) {
        define(["require", "exports"], factory);
    }
})(function (require, exports) {
    "use strict";
    class ServiceWorkerAdmin {
        constructor() {
            this.options = {};
            this.currentRegistration = null;
        }
        async installIfIsNotInstalled(opts) {
            var _a, _b, _c, _d, _e, _f, _g, _h, _j;
            try {
                this.options = opts;
                if ('serviceWorker' in navigator) {
                    var reg = await navigator.serviceWorker.register(`sw-manifest.js`);
                    var handleNewVersion = async () => {
                        var _a, _b;
                        (_b = (_a = this.options) === null || _a === void 0 ? void 0 : _a.onNewVersionAvailable) === null || _b === void 0 ? void 0 : _b.call(_a, async () => {
                            var _a, _b, _c, _d;
                            (_b = (_a = this.options) === null || _a === void 0 ? void 0 : _a.onReadyToStart) === null || _b === void 0 ? void 0 : _b.call(_a, true);
                            await ((_d = (_c = this.currentRegistration) === null || _c === void 0 ? void 0 : _c.waiting) === null || _d === void 0 ? void 0 : _d.postMessage('skipWaiting'));
                        });
                    };
                    (_b = (_a = this.options).onInfoMessage) === null || _b === void 0 ? void 0 : _b.call(_a, 'Registrado:' + !!reg.active + ',' + !!reg.installing + ',' + !!reg.waiting + ',' + ((_c = reg.active) === null || _c === void 0 ? void 0 : _c.state) + ',' + ((_d = reg.installing) === null || _d === void 0 ? void 0 : _d.state) + ',' + ((_e = reg.waiting) === null || _e === void 0 ? void 0 : _e.state));
                    console.log('Registered:', reg);
                    this.currentRegistration = reg;
                    //updatefound is fired if service-worker.js changes.
                    reg.onupdatefound = () => {
                        var _a, _b;
                        (_b = (_a = this.options).onInfoMessage) === null || _b === void 0 ? void 0 : _b.call(_a, 'Instalando');
                        // The updatefound event implies that reg.installing is set; see
                        // https://w3c.github.io/ServiceWorker/#service-worker-registration-updatefound-event
                        // @ts-ignore si estoy en onpudatefound es porque existe reg.installing
                        var installingWorker = reg.installing;
                        installingWorker.onstatechange = () => {
                            var _a, _b, _c, _d, _e, _f;
                            (_b = (_a = this.options).onInfoMessage) === null || _b === void 0 ? void 0 : _b.call(_a, installingWorker.state);
                            console.log("estado: ", installingWorker.state);
                            switch (installingWorker.state) {
                                case 'installed':
                                    if (navigator.serviceWorker.controller) {
                                        // At this point, the old content will have been purged and the fresh content will
                                        // have been added to the cache.
                                        // It's the perfect time to display a "New content is available; please refresh."
                                        // message in the page's interface.
                                        console.log('New or updated content is available.');
                                        handleNewVersion();
                                    }
                                    else {
                                        // At this point, everything has been precached.
                                        // It's the perfect time to display a "Content is cached for offline use." message.
                                        console.log('Content is now available offline!');
                                    }
                                    //setMessage(`Aplicación actualizada, por favor refresque la pantalla`,'all-ok');
                                    break;
                                case 'activated':
                                    //setMessage(`Aplicación actualizada, espere a que se refresque la pantalla`,'all-ok');
                                    setTimeout(async () => {
                                        var _a, _b, _c, _d;
                                        (_b = (_a = this.options).onInfoMessage) === null || _b === void 0 ? void 0 : _b.call(_a, 'INSTALADO DEBE REINICIAR');
                                        await ((_d = (_c = this.options) === null || _c === void 0 ? void 0 : _c.onJustInstalled) === null || _d === void 0 ? void 0 : _d.call(_c, () => {
                                            location.reload();
                                        }));
                                    }, 1000);
                                    break;
                                case 'redundant':
                                    (_d = (_c = this.options) === null || _c === void 0 ? void 0 : _c.onError) === null || _d === void 0 ? void 0 : _d.call(_c, new Error('redundant'), 'redundant installing');
                                    console.error(new Error('redundant'), 'redundant installing');
                                    break;
                                default:
                                    (_f = (_e = this.options).onInfoMessage) === null || _f === void 0 ? void 0 : _f.call(_e, 'other:' + installingWorker.state);
                            }
                        };
                        installingWorker.onerror = (evErr) => {
                            var _a, _b;
                            (_b = (_a = this.options) === null || _a === void 0 ? void 0 : _a.onError) === null || _b === void 0 ? void 0 : _b.call(_a, evErr.error, 'installingWorker');
                            console.error(evErr.error, 'installingWorker');
                        };
                    };
                    navigator.serviceWorker.onmessage = async (evMss) => {
                        var _a, _b, _c, _d, _e, _f;
                        if (evMss.data instanceof Error) {
                            (_b = (_a = this.options) === null || _a === void 0 ? void 0 : _a.onError) === null || _b === void 0 ? void 0 : _b.call(_a, evMss.data, 'from serviceWorker');
                        }
                        else {
                            if (evMss.data.type === 'caching') {
                                await ((_d = (_c = this.options) === null || _c === void 0 ? void 0 : _c.onEachFile) === null || _d === void 0 ? void 0 : _d.call(_c, evMss.data.url, evMss.data.error));
                                if (evMss.data.error) {
                                    await ((_f = (_e = this.options) === null || _e === void 0 ? void 0 : _e.onError) === null || _f === void 0 ? void 0 : _f.call(_e, evMss.data.error, 'caching ' + evMss.data.url));
                                }
                            }
                        }
                        console.error(evMss.data, 'from serviceWorker');
                    };
                    if (!!reg.waiting && reg.active) {
                        handleNewVersion();
                    }
                    (_g = (_f = this.options) === null || _f === void 0 ? void 0 : _f.onReadyToStart) === null || _g === void 0 ? void 0 : _g.call(_f, !reg.active);
                    this.localResourceControl(3);
                }
                else {
                    console.log('serviceWorkers no soportados');
                    // acá hay que elegir cómo dar el error:
                    // this.options.onError?.(new Error('serviceWorkers no soportados'));
                    throw Error('serviceWorkers no soportados');
                }
            }
            catch (err) {
                (_j = (_h = this.options) === null || _h === void 0 ? void 0 : _h.onError) === null || _j === void 0 ? void 0 : _j.call(_h, err, 'installing');
            }
        }
        async localResourceControl(retrys) {
            var _a, _b;
            var urlsToCache = await this.getSW("urlsToCache");
            if (!(urlsToCache instanceof Array)) {
                if (retrys) {
                    return new Promise((resolve, reject) => {
                        setTimeout(() => {
                            this.localResourceControl(retrys - 1).then(resolve, reject);
                        }, 1000);
                    });
                }
                else {
                    (_b = (_a = this.options) === null || _a === void 0 ? void 0 : _a.onError) === null || _b === void 0 ? void 0 : _b.call(_a, new Error(`Manifest cache "${urlsToCache}"`), 'initializing service-worker');
                }
                return;
            }
            [
                { obj: document.scripts, prop: 'src' },
                { obj: document.images, prop: 'src' },
                { obj: document.styleSheets, prop: 'href' },
            ].forEach(def => {
                Array.prototype.forEach.call(def.obj, node => {
                    var _a, _b;
                    var path = node[def.prop];
                    if (path) {
                        var query;
                        try {
                            var url = new URL(path);
                            query = url.pathname + url.search;
                            if (!urlsToCache.includes(query)) {
                                throw new Error('is not in manifest');
                            }
                        }
                        catch (err) {
                            (_b = (_a = this.options) === null || _a === void 0 ? void 0 : _a.onError) === null || _b === void 0 ? void 0 : _b.call(_a, new Error(`Resource "${query}" ${err.message}`), 'initializing service-worker');
                        }
                    }
                });
            });
        }
        async getSW(variable) {
            let response = await fetch("@" + variable);
            let varResult = response.statusText;
            if (varResult === "@json") {
                return response.json();
            }
            return varResult;
        }
        async uninstall() {
            var _a;
            var CACHE_NAME = await this.getSW("CACHE_NAME");
            await ((_a = this.currentRegistration) === null || _a === void 0 ? void 0 : _a.unregister());
            if (CACHE_NAME) {
                await caches.delete(CACHE_NAME);
            }
        }
        async check4newVersion() {
            var _a;
            // var reg = 
            await ((_a = this.currentRegistration) === null || _a === void 0 ? void 0 : _a.update());
            // return reg!=null && (!!reg.waiting || !!reg.installing);
        }
    }
    console.log('va global');
    // @ts-ignore esto es para web:
    window.ServiceWorkerAdmin = ServiceWorkerAdmin;
    return ServiceWorkerAdmin;
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2VydmljZS13b3JrZXItYWRtaW4uanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi9zcmMvc2VydmljZS13b3JrZXItYWRtaW4udHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7O0lBQUEsWUFBWSxDQUFDO0lBRWIsTUFBTSxrQkFBa0I7UUFHcEI7WUFGUSxZQUFPLEdBQXFDLEVBQUUsQ0FBQztZQUMvQyx3QkFBbUIsR0FBa0MsSUFBSSxDQUFDO1FBRWxFLENBQUM7UUFDRCxLQUFLLENBQUMsdUJBQXVCLENBQUMsSUFBZ0M7O1lBQzVELElBQUc7Z0JBQ0QsSUFBSSxDQUFDLE9BQU8sR0FBRyxJQUFJLENBQUM7Z0JBQ3BCLElBQUcsZUFBZSxJQUFJLFNBQVMsRUFBQztvQkFDNUIsSUFBSSxHQUFHLEdBQUcsTUFBTSxTQUFTLENBQUMsYUFBYSxDQUFDLFFBQVEsQ0FDNUMsZ0JBQWdCLENBQ25CLENBQUM7b0JBQ0YsSUFBSSxnQkFBZ0IsR0FBRyxLQUFLLElBQUcsRUFBRTs7d0JBQzdCLFlBQUEsSUFBSSxDQUFDLE9BQU8sMENBQUUscUJBQXFCLG1EQUFHLEtBQUssSUFBRyxFQUFFOzs0QkFDNUMsWUFBQSxJQUFJLENBQUMsT0FBTywwQ0FBRSxjQUFjLG1EQUFHLElBQUksRUFBRTs0QkFDckMsbUJBQU0sSUFBSSxDQUFDLG1CQUFtQiwwQ0FBRSxPQUFPLDBDQUFFLFdBQVcsQ0FBQyxhQUFhLEVBQUMsQ0FBQzt3QkFDeEUsQ0FBQyxFQUFDO29CQUNOLENBQUMsQ0FBQTtvQkFDRCxNQUFBLE1BQUEsSUFBSSxDQUFDLE9BQU8sRUFBQyxhQUFhLG1EQUFHLGFBQWEsR0FBQyxDQUFDLENBQUMsR0FBRyxDQUFDLE1BQU0sR0FBQyxHQUFHLEdBQUMsQ0FBQyxDQUFDLEdBQUcsQ0FBQyxVQUFVLEdBQUMsR0FBRyxHQUFDLENBQUMsQ0FBQyxHQUFHLENBQUMsT0FBTyxHQUFDLEdBQUcsVUFBQyxHQUFHLENBQUMsTUFBTSwwQ0FBRSxLQUFLLENBQUEs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TSxDQUFDLFVBQVUsQ0FBQyxDQUFDO2FBQ25DO1FBQ0wsQ0FBQztRQUNELEtBQUssQ0FBQyxnQkFBZ0I7O1lBQ2xCLGFBQWE7WUFDYixhQUFNLElBQUksQ0FBQyxtQkFBbUIsMENBQUUsTUFBTSxHQUFFLENBQUE7WUFDeEMsMkRBQTJEO1FBQy9ELENBQUM7S0FDSjtJQWdCRCxPQUFPLENBQUMsR0FBRyxDQUFDLFdBQVcsQ0FBQyxDQUFBO0lBRXhCLCtCQUErQjtJQUMvQixNQUFNLENBQUMsa0JBQWtCLEdBQUcsa0JBQWtCLENBQUM7SUFFL0MsT0FBUyxrQkFBa0IsQ0FBQyIsInNvdXJjZXNDb250ZW50IjpbIlwidXNlIHN0cmljdFwiO1xyXG5cclxuY2xhc3MgU2VydmljZVdvcmtlckFkbWlue1xyXG4gICAgcHJpdmF0ZSBvcHRpb25zOlBhcnRpYWw8U2VydmljZVdvcmtlckFkbWluLk9wdGlvbnM+PXt9O1xyXG4gICAgcHJpdmF0ZSBjdXJyZW50UmVnaXN0cmF0aW9uOlNlcnZpY2VXb3JrZXJSZWdpc3RyYXRpb258bnVsbCA9IG51bGw7XHJcbiAgICBjb25zdHJ1Y3Rvcigpe1xyXG4gICAgfVxyXG4gICAgYXN5bmMgaW5zdGFsbElmSXNOb3RJbnN0YWxsZWQob3B0czogU2VydmljZVdvcmtlckFkbWluLk9wdGlvbnMpOlByb21pc2U8dm9pZD57XHJcbiAgICAgIHRyeXtcclxuICAgICAgICB0aGlzLm9wdGlvbnMgPSBvcHRzO1xyXG4gICAgICAgIGlmKCdzZXJ2aWNlV29ya2VyJyBpbiBuYXZpZ2F0b3Ipe1xyXG4gICAgICAgICAgICB2YXIgcmVnID0gYXdhaXQgbmF2aWdhdG9yLnNlcnZpY2VXb3JrZXIucmVnaXN0ZXIoXHJcbiAgICAgICAgICAgICAgICBgc3ctbWFuaWZlc3QuanNgXHJcbiAgICAgICAgICAgICk7XHJcbiAgICAgICAgICAgIHZhciBoYW5kbGVOZXdWZXJzaW9uID0gYXN5bmMgKCk9PntcclxuICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucz8ub25OZXdWZXJzaW9uQXZhaWxhYmxlPy4oYXN5bmMgKCk9PntcclxuICAgICAgICAgICAgICAgICAgICB0aGlzLm9wdGlvbnM/Lm9uUmVhZHlUb1N0YXJ0Py4odHJ1ZSk7XHJcbiAgICAgICAgICAgICAgICAgICAgYXdhaXQgdGhpcy5jdXJyZW50UmVnaXN0cmF0aW9uPy53YWl0aW5nPy5wb3N0TWVzc2FnZSgnc2tpcFdhaXRpbmcnKTtcclxuICAgICAgICAgICAgICAgIH0pXHJcbiAgICAgICAgICAgIH1cclxuICAgICAgICAgICAgdGhpcy5vcHRpb25zLm9uSW5mb01lc3NhZ2U/LignUmVnaXN0cmFkbzonKyEhcmVnLmFjdGl2ZSsnLCcrISFyZWcuaW5zdGFsbGluZysnLCcrISFyZWcud2FpdGluZysnLCcrcmVnLmFjdGl2ZT8uc3RhdGUrJywnK3JlZy5pbnN0YWxsaW5nPy5zdGF0ZSsnLCcrcmVnLndhaXRpbmc/LnN0YXRlKTtcclxuICAgICAgICAgICAgY29uc29sZS5sb2coJ1JlZ2lzdGVyZWQ6JywgcmVnKTtcclxuICAgICAgICAgICAgdGhpcy5jdXJyZW50UmVnaXN0cmF0aW9uID0gcmVnO1xyXG4gICAgICAgICAgICAvL3VwZGF0ZWZvdW5kIGlzIGZpcmVkIGlmIHNlcnZpY2Utd29ya2VyLmpzIGNoYW5nZXMuXHJcbiAgICAgICAgICAgIHJlZy5vbnVwZGF0ZWZvdW5kID0gKCk9PntcclxuICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucy5vbkluZm9NZXNzYWdlPy4oJ0luc3RhbGFuZG8nKTtcclxuICAgICAgICAgICAgICAgIC8vIFRoZSB1cGRhdGVmb3VuZCBldmVudCBpbXBsaWVzIHRoYXQgcmVnLmluc3RhbGxpbmcgaXMgc2V0OyBzZWVcclxuICAgICAgICAgICAgICAgIC8vIGh0dHBzOi8vdzNjLmdpdGh1Yi5pby9TZXJ2aWNlV29ya2VyLyNzZXJ2aWNlLXdvcmtlci1yZWdpc3RyYXRpb24tdXBkYXRlZm91bmQtZXZlbnRcclxuICAgICAgICAgICAgICAgIC8vIEB0cy1pZ25vcmUgc2kgZXN0b3kgZW4gb25wdWRhdGVmb3VuZCBlcyBwb3JxdWUgZXhpc3RlIHJlZy5pbnN0YWxsaW5nXHJcbiAgICAgICAgICAgICAgICB2YXIgaW5zdGFsbGluZ1dvcmtlcjpTZXJ2aWNlV29ya2VyID0gcmVnLmluc3RhbGxpbmc7XHJcbiAgICAgICAgICAgICAgICBpbnN0YWxsaW5nV29ya2VyLm9uc3RhdGVjaGFuZ2UgPSAoKT0+e1xyXG4gICAgICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucy5vbkluZm9NZXNzYWdlPy4oaW5zdGFsbGluZ1dvcmtlci5zdGF0ZSk7XHJcbiAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJlc3RhZG86IFwiLCBpbnN0YWxsaW5nV29ya2VyLnN0YXRlKTtcclxuICAgICAgICAgICAgICAgICAgICBzd2l0Y2ggKGluc3RhbGxpbmdXb3JrZXIuc3RhdGUpIHtcclxuICAgICAgICAgICAgICAgICAgICAgICAgY2FzZSAnaW5zdGFsbGVkJzpcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChuYXZpZ2F0b3Iuc2VydmljZVdvcmtlci5jb250cm9sbGVyKSB7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLy8gQXQgdGhpcyBwb2ludCwgdGhlIG9sZCBjb250ZW50IHdpbGwgaGF2ZSBiZWVuIHB1cmdlZCBhbmQgdGhlIGZyZXNoIGNvbnRlbnQgd2lsbFxyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIGhhdmUgYmVlbiBhZGRlZCB0byB0aGUgY2FjaGUuXHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLy8gSXQncyB0aGUgcGVyZmVjdCB0aW1lIHRvIGRpc3BsYXkgYSBcIk5ldyBjb250ZW50IGlzIGF2YWlsYWJsZTsgcGxlYXNlIHJlZnJlc2guXCJcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBtZXNzYWdlIGluIHRoZSBwYWdlJ3MgaW50ZXJmYWNlLlxyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKCdOZXcgb3IgdXBkYXRlZCBjb250ZW50IGlzIGF2YWlsYWJsZS4nKTtcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBoYW5kbGVOZXdWZXJzaW9uKCk7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9IGVsc2Uge1xyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIEF0IHRoaXMgcG9pbnQsIGV2ZXJ5dGhpbmcgaGFzIGJlZW4gcHJlY2FjaGVkLlxyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIEl0J3MgdGhlIHBlcmZlY3QgdGltZSB0byBkaXNwbGF5IGEgXCJDb250ZW50IGlzIGNhY2hlZCBmb3Igb2ZmbGluZSB1c2UuXCIgbWVzc2FnZS5cclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZygnQ29udGVudCBpcyBub3cgYXZhaWxhYmxlIG9mZmxpbmUhJyk7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAvL3NldE1lc3NhZ2UoYEFwbGljYWNpw7NuIGFjdHVhbGl6YWRhLCBwb3IgZmF2b3IgcmVmcmVzcXVlIGxhIHBhbnRhbGxhYCwnYWxsLW9rJyk7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrO1xyXG4gICAgICAgICAgICAgICAgICAgICAgICBjYXNlICdhY3RpdmF0ZWQnOlxyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgLy9zZXRNZXNzYWdlKGBBcGxpY2FjacOzbiBhY3R1YWxpemFkYSwgZXNwZXJlIGEgcXVlIHNlIHJlZnJlc3F1ZSBsYSBwYW50YWxsYWAsJ2FsbC1vaycpO1xyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgc2V0VGltZW91dChhc3luYyAoKT0+e1xyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucy5vbkluZm9NZXNzYWdlPy4oJ0lOU1RBTEFETyBERUJFIFJFSU5JQ0lBUicpO1xyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGF3YWl0IHRoaXMub3B0aW9ucz8ub25KdXN0SW5zdGFsbGVkPy4oKCk9PntcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9jYXRpb24ucmVsb2FkKClcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB9KVxyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfSwxMDAwKVxyXG4gICAgICAgICAgICAgICAgICAgICAgICBicmVhaztcclxuICAgICAgICAgICAgICAgICAgICAgICAgY2FzZSAncmVkdW5kYW50JzpcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucz8ub25FcnJvcj8uKG5ldyBFcnJvcigncmVkdW5kYW50JyksICdyZWR1bmRhbnQgaW5zdGFsbGluZycpXHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmVycm9yKG5ldyBFcnJvcigncmVkdW5kYW50JyksICdyZWR1bmRhbnQgaW5zdGFsbGluZycpO1xyXG4gICAgICAgICAgICAgICAgICAgICAgICBicmVhaztcclxuICAgICAgICAgICAgICAgICAgICAgICAgZGVmYXVsdDpcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucy5vbkluZm9NZXNzYWdlPy4oJ290aGVyOicraW5zdGFsbGluZ1dvcmtlci5zdGF0ZSk7XHJcbiAgICAgICAgICAgICAgICAgICAgfVxyXG4gICAgICAgICAgICAgICAgfTtcclxuICAgICAgICAgICAgICAgIGluc3RhbGxpbmdXb3JrZXIub25lcnJvcj0oZXZFcnIpPT57XHJcbiAgICAgICAgICAgICAgICAgICAgdGhpcy5vcHRpb25zPy5vbkVycm9yPy4oZXZFcnIuZXJyb3IsICdpbnN0YWxsaW5nV29ya2VyJylcclxuICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmVycm9yKGV2RXJyLmVycm9yLCAnaW5zdGFsbGluZ1dvcmtlcicpO1xyXG4gICAgICAgICAgICAgICAgfVxyXG4gICAgICAgICAgICB9O1xyXG4gICAgICAgICAgICBuYXZpZ2F0b3Iuc2VydmljZVdvcmtlci5vbm1lc3NhZ2U9YXN5bmMgKGV2TXNzKT0+e1xyXG4gICAgICAgICAgICAgICAgaWYoZXZNc3MuZGF0YSBpbnN0YW5jZW9mIEVycm9yKXtcclxuICAgICAgICAgICAgICAgICAgICB0aGlzLm9wdGlvbnM/Lm9uRXJyb3I/Lihldk1zcy5kYXRhLCAnZnJvbSBzZXJ2aWNlV29ya2VyJyk7XHJcbiAgICAgICAgICAgICAgICB9ZWxzZXtcclxuICAgICAgICAgICAgICAgICAgICBpZihldk1zcy5kYXRhLnR5cGUgPT09ICdjYWNoaW5nJyl7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgIGF3YWl0IHRoaXMub3B0aW9ucz8ub25FYWNoRmlsZT8uKGV2TXNzLmRhdGEudXJsLCBldk1zcy5kYXRhLmVycm9yKTtcclxuICAgICAgICAgICAgICAgICAgICAgICAgaWYoZXZNc3MuZGF0YS5lcnJvcil7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBhd2FpdCB0aGlzLm9wdGlvbnM/Lm9uRXJyb3I/Lihldk1zcy5kYXRhLmVycm9yLCAnY2FjaGluZyAnK2V2TXNzLmRhdGEudXJsKTtcclxuICAgICAgICAgICAgICAgICAgICAgICAgfVxyXG4gICAgICAgICAgICAgICAgICAgIH1cclxuICAgICAgICAgICAgICAgIH1cclxuICAgICAgICAgICAgICAgIGNvbnNvbGUuZXJyb3IoZXZNc3MuZGF0YSwgJ2Zyb20gc2VydmljZVdvcmtlcicpO1xyXG4gICAgICAgICAgICB9XHJcbiAgICAgICAgICAgIGlmKCEhcmVnLndhaXRpbmcgJiYgcmVnLmFjdGl2ZSl7XHJcbiAgICAgICAgICAgICAgICBoYW5kbGVOZXdWZXJzaW9uKCk7XHJcbiAgICAgICAgICAgIH1cclxuICAgICAgICAgICAgdGhpcy5vcHRpb25zPy5vblJlYWR5VG9TdGFydD8uKCFyZWcuYWN0aXZlKTtcclxuICAgICAgICAgICAgdGhpcy5sb2NhbFJlc291cmNlQ29udHJvbCgzKTtcclxuICAgICAgICB9ZWxzZXtcclxuICAgICAgICAgICAgY29uc29sZS5sb2coJ3NlcnZpY2VXb3JrZXJzIG5vIHNvcG9ydGFkb3MnKVxyXG4gICAgICAgICAgICAvLyBhY8OhIGhheSBxdWUgZWxlZ2lyIGPDs21vIGRhciBlbCBlcnJvcjpcclxuICAgICAgICAgICAgLy8gdGhpcy5vcHRpb25zLm9uRXJyb3I/LihuZXcgRXJyb3IoJ3NlcnZpY2VXb3JrZXJzIG5vIHNvcG9ydGFkb3MnKSk7XHJcbiAgICAgICAgICAgIHRocm93IEVycm9yICgnc2VydmljZVdvcmtlcnMgbm8gc29wb3J0YWRvcycpO1xyXG4gICAgICAgIH1cclxuICAgICAgfWNhdGNoKGVycil7XHJcbiAgICAgICAgdGhpcy5vcHRpb25zPy5vbkVycm9yPy4oZXJyLCAnaW5zdGFsbGluZycpO1xyXG4gICAgICB9XHJcbiAgICB9XHJcbiAgICBhc3luYyBsb2NhbFJlc291cmNlQ29udHJvbChyZXRyeXM6bnVtYmVyKXtcclxuICAgICAgICB2YXIgdXJsc1RvQ2FjaGU6c3RyaW5nW10gPSBhd2FpdCB0aGlzLmdldFNXKFwidXJsc1RvQ2FjaGVcIik7XHJcbiAgICAgICAgaWYoISh1cmxzVG9DYWNoZSBpbnN0YW5jZW9mIEFycmF5KSl7XHJcbiAgICAgICAgICAgIGlmKHJldHJ5cyl7XHJcbiAgICAgICAgICAgICAgICByZXR1cm4gbmV3IFByb21pc2UoKHJlc29sdmUsIHJlamVjdCk9PntcclxuICAgICAgICAgICAgICAgICAgICBzZXRUaW1lb3V0KCgpPT57XHJcbiAgICAgICAgICAgICAgICAgICAgICAgIHRoaXMubG9jYWxSZXNvdXJjZUNvbnRyb2wocmV0cnlzLTEpLnRoZW4ocmVzb2x2ZSwgcmVqZWN0KVxyXG4gICAgICAgICAgICAgICAgICAgIH0sMTAwMClcclxuICAgICAgICAgICAgICAgIH0pO1xyXG4gICAgICAgICAgICB9ZWxzZXtcclxuICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucz8ub25FcnJvcj8uKG5ldyBFcnJvcihgTWFuaWZlc3QgY2FjaGUgXCIke3VybHNUb0NhY2hlfVwiYCksICdpbml0aWFsaXppbmcgc2VydmljZS13b3JrZXInKVxyXG4gICAgICAgICAgICB9XHJcbiAgICAgICAgICAgIHJldHVybjtcclxuICAgICAgICB9XHJcbiAgICAgICAgWyAgIFxyXG4gICAgICAgICAgICB7b2JqOmRvY3VtZW50LnNjcmlwdHMgICAgLCBwcm9wOidzcmMnIH0sXHJcbiAgICAgICAgICAgIHtvYmo6ZG9jdW1lbnQuaW1hZ2VzICAgICAsIHByb3A6J3NyYycgfSxcclxuICAgICAgICAgICAge29iajpkb2N1bWVudC5zdHlsZVNoZWV0cywgcHJvcDonaHJlZid9LFxyXG4gICAgICAgIF0uZm9yRWFjaChkZWY9PntcclxuICAgICAgICAgICAgQXJyYXkucHJvdG90eXBlLmZvckVhY2guY2FsbChkZWYub2JqLCBub2RlPT57XHJcbiAgICAgICAgICAgICAgICB2YXIgcGF0aCA9IG5vZGVbZGVmLnByb3BdO1xyXG4gICAgICAgICAgICAgICAgaWYocGF0aCl7XHJcbiAgICAgICAgICAgICAgICAgICAgdmFyIHF1ZXJ5O1xyXG4gICAgICAgICAgICAgICAgICAgIHRyeXtcclxuICAgICAgICAgICAgICAgICAgICAgICAgdmFyIHVybCA9IG5ldyBVUkwocGF0aCk7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgIHF1ZXJ5ID0gdXJsLnBhdGhuYW1lICsgdXJsLnNlYXJjaDtcclxuICAgICAgICAgICAgICAgICAgICAgICAgaWYoIXVybHNUb0NhY2hlLmluY2x1ZGVzKHF1ZXJ5KSl7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoJ2lzIG5vdCBpbiBtYW5pZmVzdCcpO1xyXG4gICAgICAgICAgICAgICAgICAgICAgICB9XHJcbiAgICAgICAgICAgICAgICAgICAgfWNhdGNoKGVycil7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucz8ub25FcnJvcj8uKG5ldyBFcnJvcihgUmVzb3VyY2UgXCIke3F1ZXJ5fVwiICR7ZXJyLm1lc3NhZ2V9YCksICdpbml0aWFsaXppbmcgc2VydmljZS13b3JrZXInKVxyXG4gICAgICAgICAgICAgICAgICAgIH1cclxuICAgICAgICAgICAgICAgIH1cclxuICAgICAgICAgICAgfSlcclxuICAgICAgICB9KVxyXG4gICAgfVxyXG4gICAgYXN5bmMgZ2V0U1codmFyaWFibGU6c3RyaW5nKXtcclxuICAgICAgICBsZXQgcmVzcG9uc2UgPSBhd2FpdCBmZXRjaChcIkBcIit2YXJpYWJsZSk7XHJcbiAgICAgICAgbGV0IHZhclJlc3VsdCA9IHJlc3BvbnNlLnN0YXR1c1RleHQ7XHJcbiAgICAgICAgaWYodmFyUmVzdWx0ID09PSBcIkBqc29uXCIpe1xyXG4gICAgICAgICAgICByZXR1cm4gcmVzcG9uc2UuanNvbigpXHJcbiAgICAgICAgfVxyXG4gICAgICAgIHJldHVybiB2YXJSZXN1bHRcclxuICAgIH1cclxuICAgIGFzeW5jIHVuaW5zdGFsbCgpe1xyXG4gICAgICAgIHZhciBDQUNIRV9OQU1FID0gYXdhaXQgdGhpcy5nZXRTVyhcIkNBQ0hFX05BTUVcIilcclxuICAgICAgICBhd2FpdCB0aGlzLmN1cnJlbnRSZWdpc3RyYXRpb24/LnVucmVnaXN0ZXIoKTtcclxuICAgICAgICBpZihDQUNIRV9OQU1FKXtcclxuICAgICAgICAgICAgYXdhaXQgY2FjaGVzLmRlbGV0ZShDQUNIRV9OQU1FKTtcclxuICAgICAgICB9XHJcbiAgICB9XHJcbiAgICBhc3luYyBjaGVjazRuZXdWZXJzaW9uKCk6UHJvbWlzZTx2b2lkPntcclxuICAgICAgICAvLyB2YXIgcmVnID0gXHJcbiAgICAgICAgYXdhaXQgdGhpcy5jdXJyZW50UmVnaXN0cmF0aW9uPy51cGRhdGUoKVxyXG4gICAgICAgIC8vIHJldHVybiByZWchPW51bGwgJiYgKCEhcmVnLndhaXRpbmcgfHwgISFyZWcuaW5zdGFsbGluZyk7XHJcbiAgICB9XHJcbn1cclxuXHJcbm5hbWVzcGFjZSBTZXJ2aWNlV29ya2VyQWRtaW57XHJcbiAgICBleHBvcnQgdHlwZSBPcHRpb25zID0ge1xyXG4gICAgICAgIC8vIFNlIGxsYW1hbiB2YXJpYXMgdmVjZXNcclxuICAgICAgICBvbkluZm9NZXNzYWdlOihtZXNzYWdlPzpzdHJpbmcpPT52b2lkXHJcbiAgICAgICAgb25FYWNoRmlsZToodXJsOnN0cmluZywgZXJyb3I6RXJyb3IpPT52b2lkXHJcbiAgICAgICAgb25FcnJvcjooZXJyOkVycm9yLCBjb250ZXh0bzpzdHJpbmcpPT52b2lkXHJcbiAgICAgICAgb25SZWFkeVRvU3RhcnQ6KGluc3RhbGxpbmc6Ym9vbGVhbik9PnZvaWQgLy8gTXVlc3RyYSBsYSBwYW50YWxsYSBkZSBpbnN0YWxhbmRvIG8gbGEgcGFudGFsbGEgcHJpbmNpcGFsIGRlIGxhIGFwbGljYWNpw7NuXHJcbiAgICAgICAgb25KdXN0SW5zdGFsbGVkOihydW46KCk9PnZvaWQpPT52b2lkIC8vIHBhcmEgbW9zdHJhIFwiZmluIGRlIGxhIGluc3RhbGFjacOzbiB5IHBvbmVyIGVsIGJvdMOzbiBcImVudHJhclwiPT5ydW4oKVxyXG4gICAgICAgICAgICAvLyBydW4gaGFjZSByZWxvYWRcclxuICAgICAgICBvbk5ld1ZlcnNpb25BdmFpbGFibGU6KGluc3RhbGw6KCk9PnZvaWQpPT52b2lkIC8vIHBhcmEgbW9zdHJhciBcImhheSB1bmEgbnVldmFyIHZlcnNpw7NuXCIgeSBwb25lciBlbCBib3TDs24gXCJpbnN0YWxhclwiPT5ydW5cclxuICAgICAgICAgICAgLy8gaW5zdGFsbCBoYWNlIHNraXBXYWl0aW5nIDwtPiBsbGFtYSBhIG9uSW5zdGFsbGluZygpXHJcbiAgICB9XHJcbn1cclxuXHJcbmNvbnNvbGUubG9nKCd2YSBnbG9iYWwnKVxyXG5cclxuLy8gQHRzLWlnbm9yZSBlc3RvIGVzIHBhcmEgd2ViOlxyXG53aW5kb3cuU2VydmljZVdvcmtlckFkbWluID0gU2VydmljZVdvcmtlckFkbWluO1xyXG5cclxuZXhwb3J0ID0gU2VydmljZVdvcmtlckFkbWluOyJdfQ==