<?php
//UTF-8:SÍ

class Pauta{
    function sqls_natalia(){
        $sqls=new Sqls();
        $sqls= array(
        "implementando;"
        );
        return $sqls;
    }
}

class Prueba_pautas extends Pruebas{
    function probar_natalia(){
        $pauta=new Pauta();
        $this->probador->verificar_sqls(
        array(
        "implementando;"
        ),
        $pauta->sqls_natalia());
    }
    function probar_natalia2(){
        return true;
    }
}

?>