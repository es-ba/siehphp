<?php
//UTF-8:SÍ

class Grilla_planilla_monitoreo_campo__ebcp2014 extends Grilla_planilla_monitoreo_TEM{
    function codigo_planilla(){
        return 'MON_TEM_CAMPO';
    }
    function iniciar($tov){
        parent::iniciar($tov);
        $this->tabla->clausula_where_agregada_manual="  and (pla_reserva=1 or pla_reserva=3 or pla_nro_enc_de_baja is distinct from null) " ;        
    }
}
?>