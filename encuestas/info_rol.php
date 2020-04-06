<?php
//UTF-8:SÍ
class Info_Rol_Enc extends Info_Rol{
    function sufijo_titulo(){
        return 'enc';
    }
    function sufijo_rol(){    
        return 'enc';
    }
    function titulo(){    
        return 'encuestador';
    }
    function rol_persona(){    
        return 'encuestador';
    }
    function estados_asignable(){
        return array(20);
    }
    function estados_asignado(){
        return array(22);
    }
    function estados_cargado_ipad(){
        return array(23);
    }
    function estados_cargado_papel(){
        return array(24);
    }
    function puede_usar_DM(){
        return true;
    }
}
class Info_Rol_Recu extends Info_Rol{
    function sufijo_titulo(){
        return 'recu';
    }
    function sufijo_rol(){    
        return 'recu';
    }
    function titulo(){    
        return 'recuperador';
    }
    function rol_persona(){    
        return 'recuperador';
    }
    function estados_asignable(){
        return array(30);
    }
    function estados_asignado(){
        return array(32);
    }
    function estados_cargado_ipad(){
        return array(33);
    }
    function estados_cargado_papel(){
        return array(34);
    }
    function puede_usar_DM(){
        return true;
    }
}
class Info_Rol_Sup_Campo extends Info_Rol{
    function sufijo_titulo(){
        return 'sup_campo';
    }
    function sufijo_rol(){    
        return 'sup';
    }
    function titulo(){    
        return 'supervisor de campo';
    }
    function rol_persona(){    
        return 'supervisor';
    }
    function estados_asignable(){
        return array(40,50);
    }
    function estados_asignado(){ 
        return array(42,52);
    }
    function estados_cargado_ipad(){
        return array(46,56);
    }
    function estados_cargado_papel(){
        return array(44,54);
    }
    function puede_usar_DM(){
        return true;
    }
}
class Info_Rol_Sup_Telefonico extends Info_Rol{
    function sufijo_titulo(){
        return 'sup_telefonico';
    }
    function sufijo_rol(){    
        return 'sup';
    }
    function titulo(){    
        return 'supervisor telefónico';
    }
    function rol_persona(){    
        return 'recepcionista';
    }
    function estados_asignable(){
        return array(41,51);
    }
    function estados_asignado(){ 
        return array(43,53);
    }
    function estados_cargado(){
        return array();
    }
    function puede_usar_DM(){
        return false;
    }
}

class Info_Rol_AnaCon extends Info_Rol{
    function sufijo_rol(){    
        return 'anacon';
    }
    function titulo(){    
        return 'analista de consistencias';
    }
    function estados_asignable(){
        return array(70);
    }
    function estados_asignado(){
        return array(72);
    }
}


class Info_Rol{
    function sufijo_titulo(){
        return $this->sufijo_rol();
    }
    function estados_cargado(){
        return array_merge($this->estados_cargado_ipad(),$this->estados_cargado_papel());
    }
    function estados_cargado_ipad(){
        return array();
    }
    static function a_partir_de_numrol($num){
        switch($num){
        case 1:
            return new Info_Rol_Enc();
        case 2:
            return new Info_Rol_Recu();
        case 3:
            return new Info_Rol_Sup_Campo();
        case 4:
            return new Info_Rol_Sup_Telefonico();
        }
    }
    static function a_partir_de_sufijo($sufijo){
        switch($sufijo){
        case 'enc':
            return new Info_Rol_Enc();
        case 'recu':
            return new Info_Rol_Recu();
        case 'sup':
            return new Info_Rol_Sup_Campo();
        }
    }
    function puede_usar_DM(){
        return true;
    }
}

?>