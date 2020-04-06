<?php

/*
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_cargar_dispositivo extends Proceso{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Gráfico de avance de los estados',
            'submenu'=>'procesamiento',
            'permisos'=>array('grupo'=>'procesamiento', 'grupo2'=>'subcoor_campo'),
            'para_produccion'=>true,
        ));
    }
    function correr(){
        $str= "";
        $MAX_CANT_ENCU=$this->db->ejecutar_sql(new Sql("select count(*) from encu.plana_tem_"));
        $MARGEN_IZQ = 50;
        $MARGEN_DER = 850;
        $MARGEN_INF =540;
        $CANT_LINEAS = $MAX_CANT_ENCU/1000;
        $color_medidas = 'darkgreen';
        $colores = array('steelblue',
                        'navy',
                        'lightskyblue',
                        'slategray',
                        'gray',
                        'green',
                        'lime',
                        'darkseagreen',
                        'tan',
                        'olive',
                        'darkred' ,
                        'tomato',
                        'silver',
                        'pink',
                        'beige',
                        'khaki',
                        'peru',
                        'thistle',
                        'lightcoral');
$cursor=$db->ejecutar(<<<SQL
  select fecha, estado, count(distinct encues)
  from (select encues, fecha, max(case mod_actual 
               when '9' then (case when rea in (0,2) then 10 else 9 end) 
               when '2' then 3
               when '5' then 6
               when '7' then 8
               when '22' then 23
               else mod_actual::decimal end) as estado
          from modificaciones inner join tem11 on mod_pk=encues::text and mod_pk::integer=encues, 
		(select '2011-09-30'::date + num_num*7 as fecha from numeros) fechas
          where mod_tabla='tem11' 
            and mod_campo='estado' 
            and mod_pk=encues::text 
            and mod_cuando<fecha 
            and fecha<=current_timestamp
          group by encues, fecha
          ) as estados
    group by fecha, estado
    order by 1,2;
SQL
        );
$cant_semanas = 0;
$fech_semana = false;
$estados= array();
$las_semanas = array();

$descripcion_estados = array(
					"en campo", 
					"estado 1.5" ,
					"para recuperaci&oacute;n",
					"en recuperaci&oacute;n",
					"estado 3.5",
					"en supervisi&oacute;n telef&oacute;nica",
					"para supervisi&oacute;n presencial",
					"en supervisi&oacute;n presencial",
					"para supervisi&oacute;n de recuperador",
					"en supervisi&oacute;n de recuperador",
					"para bolsa",
					"para bolsa no rea",
					"bolsa cerrada para subir a ingreso",
					"bolsa para ingreso",
					"ingresando",
					"para analista de ingreso",
					"para analista de campo",
					"para procesamiento",
					"fin fase 1"					
					);

////////////////////////////////////////////////////////////					
					
while($fila=$cursor->fetchObject()){
    // fecha, estado,count
    // la primera vez de cada semana
    if (!$fech_semana || $fech_semana < $fila->fecha){
      
        ++$cant_semanas;
		$las_semanas[]= (string)$fila->fecha;
			
        $fech_semana = $fila->fecha;
        $estados[$cant_semanas -1]= array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
       
    }

	// hacer metodo TraerEstados que devuelva este array
    $estadosTodos = array(	1=>0,
							2=>1,
							3=>2,
							4=>3,
							5=>4,
							6=>5,
							7=>6,
							8=>7,
							9=>8,
							10=>9,
							20=>10,
							21=>11,
							23=>12,
							24=>13,
							25=>14,
							26=>15,
							29=>16,
							'1.5'=>17,
							3.5=>18,
							'3.5'=>18
							);
										
    $estados[$cant_semanas -1][$estadosTodos[$fila->estado]] = $fila->count;

}


$TRAMO_X = round((800 / ($cant_semanas-1)), 0, PHP_ROUND_HALF_DOWN);



$str.= <<<HTML
<h2> EAH - estado de las encuestas </h2> 
  <svg xmlns="http://www.w3.org/2000/svg" version="1.1">
    <!-- rectangulo -->
  <polyline points=" $MARGEN_IZQ,0 $MARGEN_IZQ,$MARGEN_INF $MARGEN_DER,$MARGEN_INF $MARGEN_DER,0 $MARGEN_IZQ,0"
  style="fill:white;stroke:black;stroke-width:2"/>
HTML;

$la_y = round(($MARGEN_INF / ($CANT_LINEAS)), 0, PHP_ROUND_HALF_DOWN);
$lasLineas = '';

// este imprime las lineas,   este imprime la cant de encuestas por linea
for ($i = 0 ; $i< $CANT_LINEAS ; $i++){
	$la_y_c = $la_y*$i;
	$la_y_cT = $la_y_c +4;
	$lasLineas.= '<line x1="'.$MARGEN_IZQ.'" y1="'.$la_y_c.'" x2="'.$MARGEN_DER.'"  y2="'.$la_y_c.'"  style="stroke:silver;stroke-width:1"/>';
	$lasLineas.= '<text x="0" y="'.($la_y_cT+5).'" fill=" '. $color_medidas. '" font-family="Arial" font-size="12" >'.($CANT_LINEAS-$i)*1000 .'</text>';
}
$dibu= $lasLineas; 
$linea;
$semanas='';
$etiquetas_semanas = '';

$semanas2 = '';
for($i = 0; $i <$cant_semanas ; $i++){
	$X_TOTAL = ($TRAMO_X*$i) + $MARGEN_IZQ;
	$semanas2.= '<text x="'.($X_TOTAL - 40).'" y="'.($MARGEN_INF+30).' " fill=" '. $color_medidas. '" font-family="Arial" font-size="12" > '.date('d-m-y',strtotime($las_semanas[$i])).' </text>';
	$linea='<line x1="'. $X_TOTAL . '" y1="0" x2="'. $X_TOTAL . '" y2="'.$MARGEN_INF.'" style="stroke:silver; stroke-width:2"/>';
    $linea = $linea. '<line x1="'.$X_TOTAL.'" y1="'.($MARGEN_INF).'" x2="'.$X_TOTAL.'" y2="'.($MARGEN_INF+5).'"  style="stroke:black; stroke-width:2"/>';
    $dibu.=$linea;
}

$rotulos = '';
for($k = 0; $k <=18; $k++){
    $poliLinea= '<polygon points="';
	$posleyendaY=$k*25+50;
	$poscuadritoY=$k*25 - 10+50;
//			
		$rotulo = '	<rect x="'. ($MARGEN_DER+35) .'" y="' .$poscuadritoY. '" width="10" height="10" style="fill:white; stroke:silver; stroke-width:2" />
			<rect x="'. ($MARGEN_DER+35) .'" y="' .$poscuadritoY. '" width="10" height="10" style="fill:'.$colores[$k].';fill-opacity: .5 ; stroke-width:0"/>
			<text x="'. ($MARGEN_DER+50) .'" y="'  .$posleyendaY. '" fill="black" font-family="Courier New" font-size="15" >'.$descripcion_estados[$k].' </text>';
		$rotulos=$rotulos.$rotulo;	
    
	for($j=0; $j <$cant_semanas;$j++){
        $acumulado=0;
        for($l = $k;$l <=18;$l++){
            $acumulado+= $estados[$j][$l];
		}
		$X_TOTAL2 = ($TRAMO_X*$j) + $MARGEN_IZQ;
//		$X_TOTAL3 = ($TRAMO_X*($j -1)) + $MARGEN_IZQ;    				??
         if($j < $cant_semanas){
            $poliLinea.= ($X_TOTAL2).",".($MARGEN_INF - round((($MARGEN_INF * $acumulado)/$MAX_CANT_ENCU))).' ';
         }else{
            //$poliLinea.= ($X_TOTAL3).",".($MARGEN_INF - round((($MARGEN_INF * $acumulado)/$MAX_CANT_ENCU))).' ';				??
         }
    }
//	$poliLinea.=' '.$MARGEN_DER.','.$MARGEN_INF.' '.$MARGEN_DER.','.$MARGEN_INF.'" style="fill:'.$colores[$k].';fill-opacity: .5 ; stroke-width:0"/>\n';
    $poliLinea.=' '.$MARGEN_DER.','.$MARGEN_INF.' '.$MARGEN_IZQ.','.$MARGEN_INF.'" style="fill:'.$colores[$k].';fill-opacity: .5 ; stroke-width:0"/>\n';
    $dibu.= $poliLinea;
}

$str.= $dibu;



$str.= $rotulos;
$str.= $semanas2;
$str.= '</svg>';
EnviarStrAlCliente($str);



*/

?>