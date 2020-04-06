"use strict";

var expect = require('expect.js');
var GrillaUt = require('../grilla-ut.js');

describe("acomodar", function(){
    var acomodar = function acomodar(tramos){
        var gu = new GrillaUt();
        gu.cargar(tramos);
        gu.acomodar();
        return gu.acomodo;
    }
    it("si se superponen va en otra columna", function(){
    //ESTO TRAE PROBLEMAS CON EL TEST QUE NO HACE QUE NO PASE EL TEST DE ACOMODAR RENGLÓN: NO CONTEMPLA ACOMODAR EL RENGLÓN VACÍO
        var acomodo = acomodar([
            {desde: '00:00', hasta:'08:00', codigo:'444', detalle:'x'},
            {desde: '02:00', hasta:'06:10', codigo:'445', detalle:'xxxx'},
            {desde: '06:50', hasta:'16:00', codigo:'449', detalle:'xxxx'},
            {desde: '15:00', hasta:'21:00', codigo:'459', detalle:'xxxx'},
            {desde: '16:00', hasta:'17:00', codigo:'490', detalle:'no es el ultimo'},
        ]);
        expect(acomodo).to.eql({
            columnas:[
                [
                    {desde: '00:00', hasta:'08:00', codigo:'444', detalle:'x'},
                    {desde: '15:00', hasta:'21:00', codigo:'459', detalle:'xxxx'},
                ],[
                    {desde: '02:00', hasta:'06:10', codigo:'445', detalle:'xxxx'},
                    {desde: '06:50', hasta:'16:00', codigo:'449', detalle:'xxxx'},
                    {desde: '16:00', hasta:'17:00', codigo:'490', detalle:'no es el ultimo'},
                ]
            ],
            agujeros:[],
            cargadoHasta:'21:00',
        });
    });
    it.skip("si no se superponen va en la misma", function(){
        var acomodo = acomodar([
            {desde: '00:00', hasta:'08:00', codigo:'444', detalle:'x'},
            {desde: '08:00', hasta:'08:10', codigo:'445', detalle:'xxxx'},
            {desde: '08:10', hasta:'18:50', codigo:'447', detalle:'xxxx'},
        ]);
        expect(acomodo.columnas).to.eql([
            [
                {desde: '00:00', hasta:'08:00', codigo:'444', detalle:'x'},
                {desde: '08:00', hasta:'08:10', codigo:'445', detalle:'xxxx'},
                {desde: '08:10', hasta:'18:50', codigo:'447', detalle:'xxxx'},
            ]
        ]);
    });
    it.skip("en el resultado tiene que quedar ordenado, primero por desde, luego por hasta al revés (o sea el más largo primero), luego por código", function(){
        var acomodo = acomodar([
            {desde: '19:00', hasta:'20:00', codigo:'378', detalle:'xxxx'},
            {desde: '22:30', hasta:'24:00', codigo:'340', detalle:'xxxx'},
            {desde: '19:30', hasta:'22:00', codigo:'379', detalle:'xxxx'},
            {desde: '08:20', hasta:'10:40', codigo:'377', detalle:'xxxx'},
            {desde: '08:20', hasta:'18:50', codigo:'447', detalle:'xxxx'},
            {desde: '10:00', hasta:'11:00', codigo:'420', detalle:'xxxx'},
            {desde: '08:00', hasta:'08:10', codigo:'445', detalle:'xxxx'},
            {desde: '00:00', hasta:'08:00', codigo:'444', detalle:'x'},
            {desde: '08:00', hasta:'08:10', codigo:'440', detalle:'xxxx'},
        ]);
        expect(acomodo).to.eql({
            columnas:[
                [
                    {desde: '00:00', hasta:'08:00', codigo:'444', detalle:'x'},
                    {desde: '08:00', hasta:'08:10', codigo:'440', detalle:'xxxx'},
                    {desde: '08:20', hasta:'18:50', codigo:'447', detalle:'xxxx'},
                    {desde: '19:00', hasta:'20:00', codigo:'378', detalle:'xxxx'},
                    {desde: '22:30', hasta:'24:00', codigo:'340', detalle:'xxxx'}
                ],[
                    {desde: '08:00', hasta:'08:10', codigo:'445', detalle:'xxxx'},
                    {desde: '08:20', hasta:'10:40', codigo:'377', detalle:'xxxx'},
                    {desde: '19:30', hasta:'22:00', codigo:'379', detalle:'xxxx'},
                ],[
                    {desde: '10:00', hasta:'11:00', codigo:'420', detalle:'xxxx'},
                ]
            ],
            agujeros:[
                {desde:'08:10', hasta:'08:20'},
                {desde:'18:50', hasta:'19:00'},
                {desde:'22:00', hasta:'22:30'},
            ],
            cargadoHasta:'24:00'
        });
    });
});
/*
describe("completar hora", function(){
    var gu = new GrillaUt();
    var completarHora = function completarHora(hora){
        return gu.completarHora(hora);
    };
    [
        {input:"8:00"  ,expects:"08:00"},
        {input:"8:0012",expects:"08:00"},
        {input:"800"   ,expects:"08:00"},
        {input:"1925"  ,expects:"19:25"},
        {input:"14"    ,expects:"14:00"},
        {input:"8"     ,expects:"08:00"},
        {input:"7.15"  ,expects:"07:15"},
        {input:"7.4"   ,expects:"07:40"},
    ].forEach(function(fixture){
        expect(completarHora(fixture.input)).to.eql(fixture.expects);
    });
});

describe("validar hora", function(){
    var gu = new GrillaUt();
    var completarHora = function validarHora(hora){
        return gu.validarHora(hora);
    };
    [
        {input:"08:00" ,expects:true },
        {input:"8:0012",expects:false},
        {input:"800"   ,expects:false},
        {input:"25:00" ,expects:false},
        {input:"hola"  ,expects:false},
        {input:"12:60" ,expects:false},
    ].forEach(function(fixture){
        expect(validarHora(fixture.input)).to.eql(fixture.expects);
    });
});*/

describe("completar hora", function(){
    var gu = new GrillaUt();
    var completarHora = function completarHora(hora){
        return gu.completarHora(hora);
    };
    it.skip("completa la hora si no se le pasan los dos puntos o menos de cuatro dígitos", function(){
        [
            {input:"8:00"  ,expects:"08:00"},
            {input:"7.15"  ,expects:"07:15"},
            {input:"7.4"   ,expects:"07:40"},
            {input:"8:0012",expects:"08:00"},
            {input:"800"   ,expects:"08:00"},
            {input:"1925"  ,expects:"19:25"},
            {input:"14"    ,expects:"14:00"},
            {input:"8"     ,expects:"08:00"},
        ].forEach(function(fixture){
            expect(completarHora(fixture.input)).to.eql(fixture.expects);
        });
    });
    
});
describe("validar", function(){
    var gu = new GrillaUt();
    var validarHora = function validarHora(hora){
        return gu.validarHora(hora);
    };
    it.skip("valida que el dato sea de tipo hora", function(){
        [
            {input:"08:00" ,expects:true },
            {input:"8:0012",expects:false},
            {input:"800"   ,expects:false},
            {input:"25:00" ,expects:false},
            {input:"hola"  ,expects:false},
            {input:"12:60" ,expects:false},
        ].forEach(function(fixture){
            expect(validarHora(fixture.input)).to.eql(fixture.expects);
        });
    });
    
});
describe("validar codigos Actividades", function(){
    var gu = new GrillaUt();
    var validarActividad = function validarActividad(actividad){
        return gu.validarActividad(actividad);
    };
    it.skip("valida que el codigo ingresado sea un número", function(){
        [
            {input:'a' ,expects:false },
            {input:null,expects:false},
            {input:","   ,expects:false},
            {input:":" ,expects:false},
        ].forEach(function(fixture){
            expect(validarActividad(fixture.input)).to.eql(fixture.expects);
        });
    });
   /* it("valida que el codigo ingresado corresponda a una actividad", function(){
        var codigosPermitidos=[1,22,21,31,32,33,36,37,34,35,412,411,413,414,422,421,423,432,431,433,51,52,61,62,,72,73,74,81,82,84,912,,921,922,999];
        [
            {input:'a' ,expects:false },
            {input:null,expects:false},
            {input:","   ,expects:false},
            {input:":" ,expects:false},
        ].forEach(function(fixture){
            expect(validarActividad(fixture.input)).to.eql(fixture.expects);
        });
    });*/
    
});

