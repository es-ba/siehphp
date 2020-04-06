<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_monitoreo_viv_actividad extends Vistas{
    function definicion_estructura(){
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('enc',array('tipo'=>'entero','es_pk'=>true, 'origen'=>'pla_enc'));
        $this->definir_campo('comuna' ,array('tipo'=>'entero'          , 'origen'=>'pla_comuna'));
        $this->definir_campo('zona',array('tipo'=>'texto','largo'=>50  , 'origen'=>'pla_zona'));
        $this->definir_campo('participacion',array('tipo'=>'entero'  , 'origen'=>'pla_participacion'));
        $this->definir_campo('estado',array('tipo'=>'entero' , 'origen'=>'pla_estado'));
        $this->definir_campo('rea',array('tipo'=>'entero'    , 'origen'=>'pla_rea'));
        $this->definir_campo('norea',array('tipo'=>'entero'  , 'origen'=>'pla_norea'));
        $this->definir_campo('h',array('tipo'=>'entero'      , 'origen'=>'h'));
        $this->definir_campo('canthog',array('tipo'=>'entero', 'origen'=>'canthog'));
        $this->definir_campo('p',array('tipo'=>'entero', 'origen'=>'p'));
        $this->definir_campo('v',array('tipo'=>'entero', 'origen'=>'v'));
        $this->definir_campo('m',array('tipo'=>'entero', 'origen'=>'m'));
        $this->definir_campo('o',array('tipo'=>'entero', 'origen'=>'o'));
        $this->definir_campo('ov',array('tipo'=>'entero', 'origen'=>'ov'));
        $this->definir_campo('om',array('tipo'=>'entero', 'origen'=>'om'));
        $this->definir_campo('d',array('tipo'=>'entero', 'origen'=>'d'));
        $this->definir_campo('dv',array('tipo'=>'entero', 'origen'=>'dv'));
        $this->definir_campo('dm',array('tipo'=>'entero', 'origen'=>'dm'));
        $this->definir_campo('i', array('tipo'=>'entero', 'origen'=>'i'));
        $this->definir_campo('iv',array('tipo'=>'entero', 'origen'=>'iv'));
        $this->definir_campo('im',array('tipo'=>'entero', 'origen'=>'im'));     
        $this->definir_campo('pdif',array('tipo'=>'entero', 'origen'=>'dif_p'));
        $this->definir_campo('odif',array('tipo'=>'entero', 'origen'=>'dif_o'));
        $this->definir_campo('ddif',array('tipo'=>'entero', 'origen'=>'dif_d'));
        $this->definir_campo('idif',array('tipo'=>'entero', 'origen'=>'dif_i'));
        $this->definir_campo('reaant',array('tipo'=>'entero'    , 'origen'=>'rea_ant'));
        $this->definir_campo('noreaant',array('tipo'=>'entero'  , 'origen'=>'norea_ant'));
        $this->definir_campo('hant',array('tipo'=>'entero'      , 'origen'=>'h_ant'));
        $this->definir_campo('canthogant',array('tipo'=>'entero', 'origen'=>'canthog_ant'));
        $this->definir_campo('pant',array('tipo'=>'entero', 'origen'=>'p_ant'));
        $this->definir_campo('vant',array('tipo'=>'entero', 'origen'=>'v_ant'));
        $this->definir_campo('mant',array('tipo'=>'entero', 'origen'=>'m_ant'));
        $this->definir_campo('oant',array('tipo'=>'entero', 'origen'=>'o_ant'));
        $this->definir_campo('ovant',array('tipo'=>'entero', 'origen'=>'ov_ant'));
        $this->definir_campo('omant',array('tipo'=>'entero', 'origen'=>'om_ant'));
        $this->definir_campo('dant',array('tipo'=>'entero',  'origen'=>'d_ant'));
        $this->definir_campo('dvant',array('tipo'=>'entero', 'origen'=>'dv_ant'));
        $this->definir_campo('dmant',array('tipo'=>'entero', 'origen'=>'dm_ant'));
        $this->definir_campo('iant', array('tipo'=>'entero', 'origen'=>'i_ant'));
        $this->definir_campo('ivant',array('tipo'=>'entero', 'origen'=>'iv_ant'));
        $this->definir_campo('imant',array('tipo'=>'entero', 'origen'=>'im_ant'));
        $this->definir_campos_orden(array('pla_enc'));
    }
    function clausula_from(){
        return <<<SQL
    (select a.*, coalesce(a.p,0)-coalesce(r.p,0) dif_p,coalesce(a.o,0)-coalesce(r.o,0) dif_o,
                    coalesce(a.d,0)-coalesce(r.d,0) dif_d, coalesce(a.i,0)-coalesce(r.i,0) dif_i,
                    r.pla_rea rea_ant, r.pla_norea norea_ant,
                    r.h h_ant, r.canthog canthog_ant, r.p p_ant, r.v v_ant, r.m m_ant, 
                    r.o o_ant, r.ov ov_ant, r.om om_ant, r.d d_ant, r.dv dv_ant, r.dm dm_ant,
                    r.i i_ant, r.iv iv_ant, r.im im_ant
              from encu.monitoreo_viv_condact a left join encu.monitoreo_viv_ant_ope r on a.pla_enc= r.pla_enc
              where a.pla_participacion>1 and (a.canthog>0 or r.canthog>0) ) as x
SQL;
    }
}

?>