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
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.ServiceWorkerAdmin = void 0;
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
                    var urlsToCache = await this.getSW("urlsToCache");
                    [
                        { obj: document.scripts, prop: 'src' },
                        { obj: document.images, prop: 'src' },
                        { obj: document.styleSheets, prop: 'href' },
                    ].forEach(def => {
                        Array.prototype.forEach.call(def.obj, node => {
                            var _a, _b;
                            var path = node[def.prop];
                            if (path) {
                                try {
                                    var url = new URL(path);
                                    var query = url.pathname + url.search;
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
    exports.ServiceWorkerAdmin = ServiceWorkerAdmin;
    console.log('va global');
    // @ts-ignore esto es para web:
    window.ServiceWorkerAdmin = ServiceWorkerAdmin;
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2VydmljZS13b3JrZXItYWRtaW4uanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi9zcmMvc2VydmljZS13b3JrZXItYWRtaW4udHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7O0lBQUEsWUFBWSxDQUFDOzs7SUFjYixNQUFhLGtCQUFrQjtRQUczQjtZQUZRLFlBQU8sR0FBa0IsRUFBRSxDQUFDO1lBQzVCLHdCQUFtQixHQUFrQyxJQUFJLENBQUM7UUFFbEUsQ0FBQztRQUNELEtBQUssQ0FBQyx1QkFBdUIsQ0FBQyxJQUFhOztZQUN6QyxJQUFHO2dCQUNELElBQUksQ0FBQyxPQUFPLEdBQUcsSUFBSSxDQUFDO2dCQUNwQixJQUFHLGVBQWUsSUFBSSxTQUFTLEVBQUM7b0JBQzVCLElBQUksR0FBRyxHQUFHLE1BQU0sU0FBUyxDQUFDLGFBQWEsQ0FBQyxRQUFRLENBQzVDLGdCQUFnQixDQUNuQixDQUFDO29CQUNGLElBQUksZ0JBQWdCLEdBQUcsS0FBSyxJQUFHLEVBQUU7O3dCQUM3QixZQUFBLElBQUksQ0FBQyxPQUFPLDBDQUFFLHFCQUFxQixtREFBRyxLQUFLLElBQUcsRUFBRTs7NEJBQzVDLFlBQUEsSUFBSSxDQUFDLE9BQU8sMENBQUUsY0FBYyxtREFBRyxJQUFJLEVBQUU7NEJBQ3JDLG1CQUFNLElBQUksQ0FBQyxtQkFBbUIsMENBQUUsT0FBTywwQ0FBRSxXQUFXLENBQUMsYUFBYSxFQUFDLENBQUM7d0JBQ3hFLENBQUMsRUFBQztvQkFDTixDQUFDLENBQUE7b0JBQ0QsTUFBQSxNQUFBLElBQUksQ0FBQyxPQUFPLEVBQUMsYUFBYSxtREFBRyxhQUFhLEdBQUMsQ0FBQyxDQUFDLEdBQUcsQ0FBQyxNQUFNLEdBQUMsR0FBRyxHQUFDLENBQUMsQ0FBQyxHQUFHLENBQUMsVUFBVSxHQUFDLEdBQUcsR0FBQyxDQUFDLENBQUMsR0FBRyxDQUFDLE9BQU8sR0FBQyxHQUFHLFVBQUMsR0FBRyxDQUFDLE1BQU0sMENBQUUsS0FBSyxDQUFB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QixJQUFJLFFBQVEsR0FBRyxNQUFNLEtBQUssQ0FBQyxHQUFHLEdBQUMsUUFBUSxDQUFDLENBQUM7WUFDekMsSUFBSSxTQUFTLEdBQUcsUUFBUSxDQUFDLFVBQVUsQ0FBQztZQUNwQyxJQUFHLFNBQVMsS0FBSyxPQUFPLEVBQUM7Z0JBQ3JCLE9BQU8sUUFBUSxDQUFDLElBQUksRUFBRSxDQUFBO2FBQ3pCO1lBQ0QsT0FBTyxTQUFTLENBQUE7UUFDcEIsQ0FBQztRQUNELEtBQUssQ0FBQyxTQUFTOztZQUNYLElBQUksVUFBVSxHQUFHLE1BQU0sSUFBSSxDQUFDLEtBQUssQ0FBQyxZQUFZLENBQUMsQ0FBQTtZQUMvQyxhQUFNLElBQUksQ0FBQyxtQkFBbUIsMENBQUUsVUFBVSxHQUFFLENBQUM7WUFDN0MsSUFBRyxVQUFVLEVBQUM7Z0JBQ1YsTUFBTSxNQUFNLENBQUMsTUFBTSxDQUFDLFVBQVUsQ0FBQyxDQUFDO2FBQ25DO1FBQ0wsQ0FBQztRQUNELEtBQUssQ0FBQyxnQkFBZ0I7O1lBQ2xCLGFBQWE7WUFDYixhQUFNLElBQUksQ0FBQyxtQkFBbUIsMENBQUUsTUFBTSxHQUFFLENBQUE7WUFDeEMsMkRBQTJEO1FBQy9ELENBQUM7S0FDSjtJQXpJRCxnREF5SUM7SUFFRCxPQUFPLENBQUMsR0FBRyxDQUFDLFdBQVcsQ0FBQyxDQUFBO0lBRXhCLCtCQUErQjtJQUMvQixNQUFNLENBQUMsa0JBQWtCLEdBQUcsa0JBQWtCLENBQUMiLCJzb3VyY2VzQ29udGVudCI6WyJcInVzZSBzdHJpY3RcIjtcclxuXHJcbmV4cG9ydCB0eXBlIE9wdGlvbnM9e1xyXG4gICAgLy8gU2UgbGxhbWFuIHZhcmlhcyB2ZWNlc1xyXG4gICAgb25JbmZvTWVzc2FnZToobWVzc2FnZT86c3RyaW5nKT0+dm9pZFxyXG4gICAgb25FYWNoRmlsZToodXJsOnN0cmluZywgZXJyb3I6RXJyb3IpPT52b2lkXHJcbiAgICBvbkVycm9yOihlcnI6RXJyb3IsIGNvbnRleHRvOnN0cmluZyk9PnZvaWRcclxuICAgIG9uUmVhZHlUb1N0YXJ0OihpbnN0YWxsaW5nOmJvb2xlYW4pPT52b2lkIC8vIE11ZXN0cmEgbGEgcGFudGFsbGEgZGUgaW5zdGFsYW5kbyBvIGxhIHBhbnRhbGxhIHByaW5jaXBhbCBkZSBsYSBhcGxpY2FjacOzblxyXG4gICAgb25KdXN0SW5zdGFsbGVkOihydW46KCk9PnZvaWQpPT52b2lkIC8vIHBhcmEgbW9zdHJhIFwiZmluIGRlIGxhIGluc3RhbGFjacOzbiB5IHBvbmVyIGVsIGJvdMOzbiBcImVudHJhclwiPT5ydW4oKVxyXG4gICAgICAgIC8vIHJ1biBoYWNlIHJlbG9hZFxyXG4gICAgb25OZXdWZXJzaW9uQXZhaWxhYmxlOihpbnN0YWxsOigpPT52b2lkKT0+dm9pZCAvLyBwYXJhIG1vc3RyYXIgXCJoYXkgdW5hIG51ZXZhciB2ZXJzacOzblwiIHkgcG9uZXIgZWwgYm90w7NuIFwiaW5zdGFsYXJcIj0+cnVuXHJcbiAgICAgICAgLy8gaW5zdGFsbCBoYWNlIHNraXBXYWl0aW5nIDwtPiBsbGFtYSBhIG9uSW5zdGFsbGluZygpXHJcbn1cclxuXHJcbmV4cG9ydCBjbGFzcyBTZXJ2aWNlV29ya2VyQWRtaW57XHJcbiAgICBwcml2YXRlIG9wdGlvbnM6UGFydGlhbDxPcHRpb25zPj17fTtcclxuICAgIHByaXZhdGUgY3VycmVudFJlZ2lzdHJhdGlvbjpTZXJ2aWNlV29ya2VyUmVnaXN0cmF0aW9ufG51bGwgPSBudWxsO1xyXG4gICAgY29uc3RydWN0b3IoKXtcclxuICAgIH1cclxuICAgIGFzeW5jIGluc3RhbGxJZklzTm90SW5zdGFsbGVkKG9wdHM6IE9wdGlvbnMpOlByb21pc2U8dm9pZD57XHJcbiAgICAgIHRyeXtcclxuICAgICAgICB0aGlzLm9wdGlvbnMgPSBvcHRzO1xyXG4gICAgICAgIGlmKCdzZXJ2aWNlV29ya2VyJyBpbiBuYXZpZ2F0b3Ipe1xyXG4gICAgICAgICAgICB2YXIgcmVnID0gYXdhaXQgbmF2aWdhdG9yLnNlcnZpY2VXb3JrZXIucmVnaXN0ZXIoXHJcbiAgICAgICAgICAgICAgICBgc3ctbWFuaWZlc3QuanNgXHJcbiAgICAgICAgICAgICk7XHJcbiAgICAgICAgICAgIHZhciBoYW5kbGVOZXdWZXJzaW9uID0gYXN5bmMgKCk9PntcclxuICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucz8ub25OZXdWZXJzaW9uQXZhaWxhYmxlPy4oYXN5bmMgKCk9PntcclxuICAgICAgICAgICAgICAgICAgICB0aGlzLm9wdGlvbnM/Lm9uUmVhZHlUb1N0YXJ0Py4odHJ1ZSk7XHJcbiAgICAgICAgICAgICAgICAgICAgYXdhaXQgdGhpcy5jdXJyZW50UmVnaXN0cmF0aW9uPy53YWl0aW5nPy5wb3N0TWVzc2FnZSgnc2tpcFdhaXRpbmcnKTtcclxuICAgICAgICAgICAgICAgIH0pXHJcbiAgICAgICAgICAgIH1cclxuICAgICAgICAgICAgdGhpcy5vcHRpb25zLm9uSW5mb01lc3NhZ2U/LignUmVnaXN0cmFkbzonKyEhcmVnLmFjdGl2ZSsnLCcrISFyZWcuaW5zdGFsbGluZysnLCcrISFyZWcud2FpdGluZysnLCcrcmVnLmFjdGl2ZT8uc3RhdGUrJywnK3JlZy5pbnN0YWxsaW5nPy5zdGF0ZSsnLCcrcmVnLndhaXRpbmc/LnN0YXRlKTtcclxuICAgICAgICAgICAgY29uc29sZS5sb2coJ1JlZ2lzdGVyZWQ6JywgcmVnKTtcclxuICAgICAgICAgICAgdGhpcy5jdXJyZW50UmVnaXN0cmF0aW9uID0gcmVnO1xyXG4gICAgICAgICAgICAvL3VwZGF0ZWZvdW5kIGlzIGZpcmVkIGlmIHNlcnZpY2Utd29ya2VyLmpzIGNoYW5nZXMuXHJcbiAgICAgICAgICAgIHJlZy5vbnVwZGF0ZWZvdW5kID0gKCk9PntcclxuICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucy5vbkluZm9NZXNzYWdlPy4oJ0luc3RhbGFuZG8nKTtcclxuICAgICAgICAgICAgICAgIC8vIFRoZSB1cGRhdGVmb3VuZCBldmVudCBpbXBsaWVzIHRoYXQgcmVnLmluc3RhbGxpbmcgaXMgc2V0OyBzZWVcclxuICAgICAgICAgICAgICAgIC8vIGh0dHBzOi8vdzNjLmdpdGh1Yi5pby9TZXJ2aWNlV29ya2VyLyNzZXJ2aWNlLXdvcmtlci1yZWdpc3RyYXRpb24tdXBkYXRlZm91bmQtZXZlbnRcclxuICAgICAgICAgICAgICAgIC8vIEB0cy1pZ25vcmUgc2kgZXN0b3kgZW4gb25wdWRhdGVmb3VuZCBlcyBwb3JxdWUgZXhpc3RlIHJlZy5pbnN0YWxsaW5nXHJcbiAgICAgICAgICAgICAgICB2YXIgaW5zdGFsbGluZ1dvcmtlcjpTZXJ2aWNlV29ya2VyID0gcmVnLmluc3RhbGxpbmc7XHJcbiAgICAgICAgICAgICAgICBpbnN0YWxsaW5nV29ya2VyLm9uc3RhdGVjaGFuZ2UgPSAoKT0+e1xyXG4gICAgICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucy5vbkluZm9NZXNzYWdlPy4oaW5zdGFsbGluZ1dvcmtlci5zdGF0ZSk7XHJcbiAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJlc3RhZG86IFwiLCBpbnN0YWxsaW5nV29ya2VyLnN0YXRlKTtcclxuICAgICAgICAgICAgICAgICAgICBzd2l0Y2ggKGluc3RhbGxpbmdXb3JrZXIuc3RhdGUpIHtcclxuICAgICAgICAgICAgICAgICAgICAgICAgY2FzZSAnaW5zdGFsbGVkJzpcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChuYXZpZ2F0b3Iuc2VydmljZVdvcmtlci5jb250cm9sbGVyKSB7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLy8gQXQgdGhpcyBwb2ludCwgdGhlIG9sZCBjb250ZW50IHdpbGwgaGF2ZSBiZWVuIHB1cmdlZCBhbmQgdGhlIGZyZXNoIGNvbnRlbnQgd2lsbFxyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIGhhdmUgYmVlbiBhZGRlZCB0byB0aGUgY2FjaGUuXHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLy8gSXQncyB0aGUgcGVyZmVjdCB0aW1lIHRvIGRpc3BsYXkgYSBcIk5ldyBjb250ZW50IGlzIGF2YWlsYWJsZTsgcGxlYXNlIHJlZnJlc2guXCJcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBtZXNzYWdlIGluIHRoZSBwYWdlJ3MgaW50ZXJmYWNlLlxyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKCdOZXcgb3IgdXBkYXRlZCBjb250ZW50IGlzIGF2YWlsYWJsZS4nKTtcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBoYW5kbGVOZXdWZXJzaW9uKCk7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9IGVsc2Uge1xyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIEF0IHRoaXMgcG9pbnQsIGV2ZXJ5dGhpbmcgaGFzIGJlZW4gcHJlY2FjaGVkLlxyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIEl0J3MgdGhlIHBlcmZlY3QgdGltZSB0byBkaXNwbGF5IGEgXCJDb250ZW50IGlzIGNhY2hlZCBmb3Igb2ZmbGluZSB1c2UuXCIgbWVzc2FnZS5cclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZygnQ29udGVudCBpcyBub3cgYXZhaWxhYmxlIG9mZmxpbmUhJyk7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAvL3NldE1lc3NhZ2UoYEFwbGljYWNpw7NuIGFjdHVhbGl6YWRhLCBwb3IgZmF2b3IgcmVmcmVzcXVlIGxhIHBhbnRhbGxhYCwnYWxsLW9rJyk7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrO1xyXG4gICAgICAgICAgICAgICAgICAgICAgICBjYXNlICdhY3RpdmF0ZWQnOlxyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgLy9zZXRNZXNzYWdlKGBBcGxpY2FjacOzbiBhY3R1YWxpemFkYSwgZXNwZXJlIGEgcXVlIHNlIHJlZnJlc3F1ZSBsYSBwYW50YWxsYWAsJ2FsbC1vaycpO1xyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgc2V0VGltZW91dChhc3luYyAoKT0+e1xyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucy5vbkluZm9NZXNzYWdlPy4oJ0lOU1RBTEFETyBERUJFIFJFSU5JQ0lBUicpO1xyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGF3YWl0IHRoaXMub3B0aW9ucz8ub25KdXN0SW5zdGFsbGVkPy4oKCk9PntcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9jYXRpb24ucmVsb2FkKClcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB9KVxyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfSwxMDAwKVxyXG4gICAgICAgICAgICAgICAgICAgICAgICBicmVhaztcclxuICAgICAgICAgICAgICAgICAgICAgICAgY2FzZSAncmVkdW5kYW50JzpcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucz8ub25FcnJvcj8uKG5ldyBFcnJvcigncmVkdW5kYW50JyksICdyZWR1bmRhbnQgaW5zdGFsbGluZycpXHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmVycm9yKG5ldyBFcnJvcigncmVkdW5kYW50JyksICdyZWR1bmRhbnQgaW5zdGFsbGluZycpO1xyXG4gICAgICAgICAgICAgICAgICAgICAgICBicmVhaztcclxuICAgICAgICAgICAgICAgICAgICAgICAgZGVmYXVsdDpcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRoaXMub3B0aW9ucy5vbkluZm9NZXNzYWdlPy4oJ290aGVyOicraW5zdGFsbGluZ1dvcmtlci5zdGF0ZSk7XHJcbiAgICAgICAgICAgICAgICAgICAgfVxyXG4gICAgICAgICAgICAgICAgfTtcclxuICAgICAgICAgICAgICAgIGluc3RhbGxpbmdXb3JrZXIub25lcnJvcj0oZXZFcnIpPT57XHJcbiAgICAgICAgICAgICAgICAgICAgdGhpcy5vcHRpb25zPy5vbkVycm9yPy4oZXZFcnIuZXJyb3IsICdpbnN0YWxsaW5nV29ya2VyJylcclxuICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmVycm9yKGV2RXJyLmVycm9yLCAnaW5zdGFsbGluZ1dvcmtlcicpO1xyXG4gICAgICAgICAgICAgICAgfVxyXG4gICAgICAgICAgICB9O1xyXG4gICAgICAgICAgICBuYXZpZ2F0b3Iuc2VydmljZVdvcmtlci5vbm1lc3NhZ2U9YXN5bmMgKGV2TXNzKT0+e1xyXG4gICAgICAgICAgICAgICAgaWYoZXZNc3MuZGF0YSBpbnN0YW5jZW9mIEVycm9yKXtcclxuICAgICAgICAgICAgICAgICAgICB0aGlzLm9wdGlvbnM/Lm9uRXJyb3I/Lihldk1zcy5kYXRhLCAnZnJvbSBzZXJ2aWNlV29ya2VyJyk7XHJcbiAgICAgICAgICAgICAgICB9ZWxzZXtcclxuICAgICAgICAgICAgICAgICAgICBpZihldk1zcy5kYXRhLnR5cGUgPT09ICdjYWNoaW5nJyl7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgIGF3YWl0IHRoaXMub3B0aW9ucz8ub25FYWNoRmlsZT8uKGV2TXNzLmRhdGEudXJsLCBldk1zcy5kYXRhLmVycm9yKTtcclxuICAgICAgICAgICAgICAgICAgICAgICAgaWYoZXZNc3MuZGF0YS5lcnJvcil7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBhd2FpdCB0aGlzLm9wdGlvbnM/Lm9uRXJyb3I/Lihldk1zcy5kYXRhLmVycm9yLCAnY2FjaGluZyAnK2V2TXNzLmRhdGEudXJsKTtcclxuICAgICAgICAgICAgICAgICAgICAgICAgfVxyXG4gICAgICAgICAgICAgICAgICAgIH1cclxuICAgICAgICAgICAgICAgIH1cclxuICAgICAgICAgICAgICAgIGNvbnNvbGUuZXJyb3IoZXZNc3MuZGF0YSwgJ2Zyb20gc2VydmljZVdvcmtlcicpO1xyXG4gICAgICAgICAgICB9XHJcbiAgICAgICAgICAgIGlmKCEhcmVnLndhaXRpbmcgJiYgcmVnLmFjdGl2ZSl7XHJcbiAgICAgICAgICAgICAgICBoYW5kbGVOZXdWZXJzaW9uKCk7XHJcbiAgICAgICAgICAgIH1cclxuICAgICAgICAgICAgdGhpcy5vcHRpb25zPy5vblJlYWR5VG9TdGFydD8uKCFyZWcuYWN0aXZlKTtcclxuICAgICAgICAgICAgdmFyIHVybHNUb0NhY2hlOnN0cmluZ1tdID0gYXdhaXQgdGhpcy5nZXRTVyhcInVybHNUb0NhY2hlXCIpO1xyXG4gICAgICAgICAgICBbICAgXHJcbiAgICAgICAgICAgICAgICB7b2JqOmRvY3VtZW50LnNjcmlwdHMgICAgLCBwcm9wOidzcmMnIH0sXHJcbiAgICAgICAgICAgICAgICB7b2JqOmRvY3VtZW50LmltYWdlcyAgICAgLCBwcm9wOidzcmMnIH0sXHJcbiAgICAgICAgICAgICAgICB7b2JqOmRvY3VtZW50LnN0eWxlU2hlZXRzLCBwcm9wOidocmVmJ30sXHJcbiAgICAgICAgICAgIF0uZm9yRWFjaChkZWY9PntcclxuICAgICAgICAgICAgICAgIEFycmF5LnByb3RvdHlwZS5mb3JFYWNoLmNhbGwoZGVmLm9iaiwgbm9kZT0+e1xyXG4gICAgICAgICAgICAgICAgICAgIHZhciBwYXRoID0gbm9kZVtkZWYucHJvcF07XHJcbiAgICAgICAgICAgICAgICAgICAgaWYocGF0aCl7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgIHRyeXtcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZhciB1cmwgPSBuZXcgVVJMKHBhdGgpO1xyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgdmFyIHF1ZXJ5ID0gdXJsLnBhdGhuYW1lICsgdXJsLnNlYXJjaDtcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmKCF1cmxzVG9DYWNoZS5pbmNsdWRlcyhxdWVyeSkpe1xyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRocm93IG5ldyBFcnJvcignaXMgbm90IGluIG1hbmlmZXN0Jyk7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XHJcbiAgICAgICAgICAgICAgICAgICAgICAgIH1jYXRjaChlcnIpe1xyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgdGhpcy5vcHRpb25zPy5vbkVycm9yPy4obmV3IEVycm9yKGBSZXNvdXJjZSBcIiR7cXVlcnl9XCIgJHtlcnIubWVzc2FnZX1gKSwgJ2luaXRpYWxpemluZyBzZXJ2aWNlLXdvcmtlcicpXHJcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cclxuICAgICAgICAgICAgICAgICAgICB9XHJcbiAgICAgICAgICAgICAgICB9KVxyXG4gICAgICAgICAgICB9KVxyXG4gICAgICAgIH1lbHNle1xyXG4gICAgICAgICAgICBjb25zb2xlLmxvZygnc2VydmljZVdvcmtlcnMgbm8gc29wb3J0YWRvcycpXHJcbiAgICAgICAgICAgIC8vIGFjw6EgaGF5IHF1ZSBlbGVnaXIgY8OzbW8gZGFyIGVsIGVycm9yOlxyXG4gICAgICAgICAgICAvLyB0aGlzLm9wdGlvbnMub25FcnJvcj8uKG5ldyBFcnJvcignc2VydmljZVdvcmtlcnMgbm8gc29wb3J0YWRvcycpKTtcclxuICAgICAgICAgICAgdGhyb3cgRXJyb3IgKCdzZXJ2aWNlV29ya2VycyBubyBzb3BvcnRhZG9zJyk7XHJcbiAgICAgICAgfVxyXG4gICAgICB9Y2F0Y2goZXJyKXtcclxuICAgICAgICB0aGlzLm9wdGlvbnM/Lm9uRXJyb3I/LihlcnIsICdpbnN0YWxsaW5nJyk7XHJcbiAgICAgIH1cclxuICAgIH1cclxuICAgIGFzeW5jIGdldFNXKHZhcmlhYmxlOnN0cmluZyl7XHJcbiAgICAgICAgbGV0IHJlc3BvbnNlID0gYXdhaXQgZmV0Y2goXCJAXCIrdmFyaWFibGUpO1xyXG4gICAgICAgIGxldCB2YXJSZXN1bHQgPSByZXNwb25zZS5zdGF0dXNUZXh0O1xyXG4gICAgICAgIGlmKHZhclJlc3VsdCA9PT0gXCJAanNvblwiKXtcclxuICAgICAgICAgICAgcmV0dXJuIHJlc3BvbnNlLmpzb24oKVxyXG4gICAgICAgIH1cclxuICAgICAgICByZXR1cm4gdmFyUmVzdWx0XHJcbiAgICB9XHJcbiAgICBhc3luYyB1bmluc3RhbGwoKXtcclxuICAgICAgICB2YXIgQ0FDSEVfTkFNRSA9IGF3YWl0IHRoaXMuZ2V0U1coXCJDQUNIRV9OQU1FXCIpXHJcbiAgICAgICAgYXdhaXQgdGhpcy5jdXJyZW50UmVnaXN0cmF0aW9uPy51bnJlZ2lzdGVyKCk7XHJcbiAgICAgICAgaWYoQ0FDSEVfTkFNRSl7XHJcbiAgICAgICAgICAgIGF3YWl0IGNhY2hlcy5kZWxldGUoQ0FDSEVfTkFNRSk7XHJcbiAgICAgICAgfVxyXG4gICAgfVxyXG4gICAgYXN5bmMgY2hlY2s0bmV3VmVyc2lvbigpOlByb21pc2U8dm9pZD57XHJcbiAgICAgICAgLy8gdmFyIHJlZyA9IFxyXG4gICAgICAgIGF3YWl0IHRoaXMuY3VycmVudFJlZ2lzdHJhdGlvbj8udXBkYXRlKClcclxuICAgICAgICAvLyByZXR1cm4gcmVnIT1udWxsICYmICghIXJlZy53YWl0aW5nIHx8ICEhcmVnLmluc3RhbGxpbmcpO1xyXG4gICAgfVxyXG59XHJcblxyXG5jb25zb2xlLmxvZygndmEgZ2xvYmFsJylcclxuXHJcbi8vIEB0cy1pZ25vcmUgZXN0byBlcyBwYXJhIHdlYjpcclxud2luZG93LlNlcnZpY2VXb3JrZXJBZG1pbiA9IFNlcnZpY2VXb3JrZXJBZG1pbjsiXX0=