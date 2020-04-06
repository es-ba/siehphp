"use strict";


(function (){

    var app = angular.module("personasApp",[]);

    // /*
    app.directive("contenteditable", function() {
      return {
        restrict: 'A',
        require: "ngModel",
        link: function(scope, element, attrs, ngModel) {
          function read() {
            console.log('read', element.text(), scope, element, attrs, ngModel);
            var value=element.text();
            // if(attrs.
            if(value=='true'){
                value=true;
            }else if(element.text()=='false'){
                value=false;
            }
            ngModel.$setViewValue(value);
          }

          ngModel.$render = function() {
            console.log('$render', ngModel.$viewValue, scope, element, attrs, ngModel);
            element.html(ngModel.$viewValue || "");
          };

          element.bind("blur keyup change", function() {
            console.log('bind', scope, element, attrs, ngModel);
            scope.$apply(read);
          });
        }
      };
    });    
    // */
    
    app.controller("PersonasCtrl",function($scope){
        // $scope.sanitizar = function(valor){
            // return JSON.stringify(valor);
        // };
        var vm=this;
        vm.vacio=true;
        vm.parametros={};
        vm.parametros.estado="vacio";
        vm.parametros.con_con="audi_nsnc_e13";
        vm.datos={};
        vm.infoCampos={
            con_con:{ tipoVisual:'con_con' },
            // seleccionado:{ tipoVisual:'check' },
            cod_niv_estud:{ tipoVisual:'numerico' },
        };
        vm.operaciones={
            traer:function(operacion){
                var operaciones={
                    bulkload: { concon_con:true , accept:function(result){ 
                        vm.parametros.estado="ok";
                        var datosCrudos=JSON.parse(result);
                        vm.fields=datosCrudos.fields;
                        vm.datosOriginales=JSON.parse(result);
                        vm.filasOriginales=vm.datosOriginales.rows;
                        vm.filas=datosCrudos.rows;
                        vm.fieldsInfo={};
                        vm.fields.forEach(function(fieldInfo){
                            vm.fieldsInfo[fieldInfo.name]=fieldInfo;
                        });
                        vm.filasRender=vm.filas.map(function(fila){
                            var filaRender={};
                            vm.fields.forEach(function(fieldInfo){
                                var value=fila[fieldInfo.name];
                                var renderValue;
                                if(value==null){
                                    renderValue='';
                                }else if(fieldInfo.dataTypeID===16){
                                    renderValue=value?'Sí':'no';
                                }else{
                                    renderValue=value.toString();
                                }
                                filaRender[fieldInfo.name]=renderValue;
                            });
                            return filaRender;
                        });
                        vm.campos=Object.keys(vm.filas[0]);
                    }},
                    load:     { concon_con:true },
                    anterior: { concon_con:true },
                    siguiente:{ concon_con:true },
                }
                vm.parametros.estado="loading";
                var parametrosLlamada={
                    url:'/persona/' + operacion,
                    data:{}
                }
                if((operaciones[operacion]||{}).concon_con){
                    parametrosLlamada.data.con_con = vm.parametros.con_con;
                }
                AjaxBestPromise.get(parametrosLlamada).then(
                    (operaciones[operacion]||{}).accept ||
                    function(result){
                        vm.parametros.estado="ok";
                        var datosCrudos=JSON.parse(result);
                        vm.campos=Object.keys(datosCrudos);
                        vm.filas=[datosCrudos];
                    }
                ).catch(function(err){
                    vm.parametros.estado="error";
                    vm.parametros.mensaje_error=err.message;
                }).then(function(){
                    $scope.$apply();
                });
            }
        }
    });

    app.controller("ErroresCtrl",function(){
        var vm=this;
        vm.message="";
        vm.object="";
        window.addEventListener('error', function(err){
            vm.message=err.message;
            vm.object=JSON.stringify(err);
        });
    });
})();