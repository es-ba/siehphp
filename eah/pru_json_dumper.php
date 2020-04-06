<?php

include "lo_necesario.php";

$pru_cant_pruebas_json_d=0;

Elegir_Esquema("test");

pru_json_dropear_tablas_si_existen(
	array('tablas','t_vacia','t_conbool','t_connum','t_condpd','t_conpk2','t_sinpk','t_raros'
		,'t_opcios','t_pregus','t_formus','t_encues','t_confecha'
	)
);

$db->ejecutar(<<<SQL
	CREATE TABLE test.tablas(
		tab_tab varchar(50) primary key,
		tab_prefijo_campos varchar(50)
	)
SQL
);

pru_json_d("tabla simple"
	, 't_encues'
	, array(<<<SQL
		CREATE TABLE test.t_encues (
			enc_enc varchar(10) primary key,
			enc_nombre varchar(30)
		);
SQL
	, <<<SQL
		INSERT INTO test.tablas(tab_tab,tab_prefijo_campos) values ('t_encues','enc_');
SQL
	, $ins_t_encus=<<<SQL
		INSERT INTO test.t_encues (enc_enc, enc_nombre)
			VALUES ('E1', 'nombre del uno'),
				 ('E2', 'nombre del dos');
SQL
	)
, <<<JSON
[ { enc:"E1", nombre:"nombre del uno"}
, { enc:"E2", nombre:"nombre del dos"}
]
JSON
);

pru_json_d("tabla vacia"
	, 't_vacia'
	, array(<<<SQL
		CREATE TABLE test.t_vacia (
			enc_enc varchar(10) primary key,
			enc_nombre varchar(30)
		);
SQL
	)
, <<<JSON
[]
JSON
);

pru_json_d("tabla simple con dato bool"
	, 't_conbool'
	, array(<<<SQL
		CREATE TABLE test.t_conbool (
			con_bool_elbool bool
		);
SQL
	, <<<SQL
		INSERT INTO test.tablas(tab_tab,tab_prefijo_campos) values ('t_conbool','con_bool_');
SQL
	, <<<SQL
		INSERT INTO test.t_conbool (con_bool_elbool)
			VALUES (false), (true), (null);
SQL
	)
, <<<JSON
[ { elbool:false}
, { elbool:true}
, {}
]
JSON
);

pru_json_d("tabla simple con datos numéricos de distintos tipos"
	, 't_connum'
	, array(<<<SQL
		CREATE TABLE test.t_connum (
			conn_entero integer,
			conn_doble double precision default 999,
			conn_fijo numeric default '777',
			conn_texto varchar(20) default '666'
		);
SQL
	, <<<SQL
		INSERT INTO test.tablas(tab_tab,tab_prefijo_campos) values ('t_connum','conn_');
SQL
	, <<<SQL
		INSERT INTO test.t_connum (conn_entero, conn_doble, conn_fijo, conn_texto) 
			VALUES (-1, null, -0.4444, null), (1, 1.1, 1.33, '1'), (2, 3, null, '');
SQL
	)
, <<<JSON
[ { entero:-1, doble:null, fijo:-0.4444, texto:null}
, { entero:1, doble:1.1, fijo:1.33, texto:"1"}
, { entero:2, doble:3, fijo:null, texto:""}
]
JSON
);

pru_json_d("tabla simple con datos por defecto"
	, 't_condpd'
	, array(<<<SQL
		CREATE TABLE test.t_condpd (
			conn_entero integer default 1,
			conn_bool boolean default false,
			conn_texto varchar(20) default 'Don''t "yeah"',
			conn_texto2 varchar(20)
		);
SQL
	, <<<SQL
		INSERT INTO test.tablas(tab_tab,tab_prefijo_campos) values ('t_condpd','conn_');
SQL
	, <<<SQL
		INSERT INTO test.t_condpd (conn_entero, conn_bool, conn_texto, conn_texto2)
			VALUES (1, true, 'S', null), (2, false, 'Don''t "yeah"', 'ALGO'), (null, null, null, 'can''t "yeah"');
SQL
	)
, <<<JSON
[ { bool:true, texto:"S"}
, { entero:2, texto2:"ALGO"}
, { entero:null, bool:null, texto:null, texto2:"can't \"yeah\""}
]
JSON
);

pru_json_d("tabla simple con pk doble"
	, 't_conpk2'
	, array(<<<SQL
		CREATE TABLE test.t_conpk2 (
			conn_entero integer,
			conn_texto varchar(20),
			conn_texto2 varchar(20),
			primary key (conn_entero, conn_texto)
		);
SQL
	, <<<SQL
		INSERT INTO test.tablas(tab_tab,tab_prefijo_campos) values ('t_conpk2','conn_');
SQL
	, <<<SQL
		INSERT INTO test.t_conpk2 (conn_entero, conn_texto, conn_texto2) 
			VALUES (1, 'B', 'B'), (1, 'A', null), (3, 'A', 'B'), (2, 'A', null);
SQL
	)
, <<<JSON
[ { entero:1, texto:"A"}
, { entero:1, texto:"B", texto2:"B"}
, { entero:2, texto:"A"}
, { entero:3, texto:"A", texto2:"B"}
]
JSON
, 'sin_probar_ins');

pru_json_d("tabla simple sin pk, debe ordenar igual por los campos que haya"
	, 't_sinpk'
	, array(<<<SQL
		CREATE TABLE test.t_sinpk (
			conn_entero integer,
			conn_texto varchar(20),
			conn_texto2 varchar(20)
		);
SQL
	, <<<SQL
		INSERT INTO test.tablas(tab_tab,tab_prefijo_campos) values ('t_sinpk','conn_');
SQL
	, <<<SQL
		INSERT INTO test.t_sinpk 
			VALUES (3,'A','B'),(1,'B','B'),(2,'A',null),(1,'A',null);
SQL
	)
, <<<JSON
[ { entero:1, texto:"A"}
, { entero:1, texto:"B", texto2:"B"}
, { entero:2, texto:"A"}
, { entero:3, texto:"A", texto2:"B"}
]
JSON
, 'sin_probar_ins');

pru_json_d("tabla con coleccion (los formularios tienen colección de preguntas)"
	, 't_formus'
	, array(<<<SQL
		CREATE TABLE test.t_formus (
			for_enc varchar(10),
			for_for varchar(10),
			for_nombre varchar(30),
			for_un_bool boolean default false,
			primary key(for_enc, for_for)
		);
SQL
	,<<<SQL
		CREATE TABLE test.t_pregus (
			pre_enc varchar(10),
			pre_for varchar(10),
			pre_pre varchar(10),
			pre_texto varchar(30),
			primary key(pre_enc, pre_for, pre_pre),
			foreign key (pre_enc, pre_for) references test.t_formus(for_enc, for_for)
		);
SQL
	, <<<SQL
		INSERT INTO test.tablas(tab_tab,tab_prefijo_campos) values ('t_formus','for_');
SQL
	, <<<SQL
		INSERT INTO test.tablas(tab_tab,tab_prefijo_campos) values ('t_pregus','pre_');
SQL
	, $ins_t_formus=<<<SQL
		INSERT INTO test.t_formus (for_enc, for_for, for_nombre, for_un_bool) 
			VALUES ('E1', 'F1', 'Nombre del F1', true)
				,  ('E1', 'F2', 'Nombre del F2', false);
SQL
	, $ins_t_pregus=<<<SQL
		INSERT INTO test.t_pregus (pre_enc, pre_for, pre_pre, pre_texto)
			VALUES ('E1', 'F1', 'P1', 'Tiene P1?')
				,  ('E1', 'F1', 'P2', 'Tiene P2?')
				,  ('E1', 'F1', 'P3', 'Tiene P3?')
				,  ('E1', 'F2', 'P2', 'Tiene P2?');
SQL
	)
, <<<JSON
[ { enc:"E1", "for":"F1", nombre:"Nombre del F1", un_bool:true
  , t_pregus:
    [ { pre:"P1", texto:"Tiene P1?"}
    , { pre:"P2", texto:"Tiene P2?"}
    , { pre:"P3", texto:"Tiene P3?"}
    ]
  }
, { enc:"E1", "for":"F2", nombre:"Nombre del F2"
  , t_pregus:
    [ { pre:"P2", texto:"Tiene P2?"}
    ]
  }
]
JSON
);

$db->limpiar_cache(); // tengo que limpiar la caché porque cambia la estructura al agregar una FK

pru_json_d("tabla con coleccion de 3 generaciones"
	, 't_encues'
	, array(<<<SQL
		ALTER TABLE test.t_formus ADD FOREIGN KEY (for_enc) REFERENCES test.t_encues(enc_enc);
SQL
	)
, <<<JSON
[ { enc:"E1", nombre:"nombre del uno"
  , t_formus:
    [ { "for":"F1", nombre:"Nombre del F1", un_bool:true
      , t_pregus:
        [ { pre:"P1", texto:"Tiene P1?"}
        , { pre:"P2", texto:"Tiene P2?"}
        , { pre:"P3", texto:"Tiene P3?"}
        ]
      }
    , { "for":"F2", nombre:"Nombre del F2"
      , t_pregus:
        [ { pre:"P2", texto:"Tiene P2?"}
        ]
      }
    ]
  }
, { enc:"E2", nombre:"nombre del dos"}
]
JSON
, 'la vuelta es esta'
, "$ins_t_encus $ins_t_formus $ins_t_pregus "
);

$db->limpiar_cache(); // tengo que limpiar la caché porque cambia la estructura al agregar una tabla hija con FK a una cacheada

pru_json_d("tabla con coleccion de 4 generaciones"
	, 't_encues'
	, array(<<<SQL
		CREATE TABLE test.t_opcios (
			opc_enc varchar(10),
			opc_for varchar(10),
			opc_pre varchar(10),
			opc_opc varchar(10),
			opc_texto varchar(30),
			opc_pre_salta varchar(10),
			primary key(opc_enc, opc_for, opc_pre, opc_opc),
			foreign key (opc_enc, opc_for, opc_pre) references test.t_pregus (pre_enc, pre_for, pre_pre),
			foreign key (opc_enc, opc_for, opc_pre_salta) references test.t_pregus (pre_enc, pre_for, pre_pre)
		);
SQL
	, <<<SQL
		INSERT INTO test.tablas(tab_tab,tab_prefijo_campos) values ('t_opcios','opc_');
SQL
	, $ins_t_opcios=<<<SQL
		INSERT INTO test.t_opcios (opc_enc, opc_for, opc_pre, opc_opc, opc_texto, opc_pre_salta) 
			VALUES ('E1', 'F1', 'P1', '1', 'Opcion P1.1', null)
				,  ('E1', 'F1', 'P1', '2', 'Opcion P1.2', 'P2')
				,  ('E1', 'F1', 'P2', 'a', 'Opcion P2.a', null)
				,  ('E1', 'F1', 'P2', 'b', 'Opcion P2.b', null);
SQL
	)
, <<<JSON
[ { enc:"E1", nombre:"nombre del uno"
  , t_formus:
    [ { "for":"F1", nombre:"Nombre del F1", un_bool:true
      , t_pregus:
        [ { pre:"P1", texto:"Tiene P1?"
          , t_opcios:
            [ { opc:"1", texto:"Opcion P1.1"}
            , { opc:"2", texto:"Opcion P1.2", pre_salta:"P2"}
            ]
          }
        , { pre:"P2", texto:"Tiene P2?"
          , t_opcios:
            [ { opc:"a", texto:"Opcion P2.a"}
            , { opc:"b", texto:"Opcion P2.b"}
            ]
          }
        , { pre:"P3", texto:"Tiene P3?"}
        ]
      }
    , { "for":"F2", nombre:"Nombre del F2"
      , t_pregus:
        [ { pre:"P2", texto:"Tiene P2?"}
        ]
      }
    ]
  }
, { enc:"E2", nombre:"nombre del dos"}
]
JSON
, 'la vuelta es esta'
, "$ins_t_encus $ins_t_formus $ins_t_pregus $ins_t_opcios "
);

pru_json_d("tres tablas a la vez"
	, array('t_vacia', 't_conbool')
	, array()
, <<<JSON
{ json_dumper:1
, tablas:
  { t_vacia:
    []
  , t_conbool:
    [ { elbool:false}
    , { elbool:true}
    , {}
    ]
  }
}

JSON
, 'sin_probar_ins');

pru_json_arreglar("Tiene que entrecomillas los tags de la izquierda"
	, <<<JSON
[ { este: "este"
  ,otro : "{ este_no: 'este tampoco', este_menos: \\"este ya estaba\\"}"
  , 3: "supongo que también el 3"
  , uno : [ { dentro: { deotro: 4 , si: "si!"}}]}
  ,dos:[{dentro:{deotro:4,si:"si!"}}]}
]
JSON
, <<<JSON
[ { "este": "este"
  ,"otro" : "{ este_no: 'este tampoco', este_menos: \\"este ya estaba\\"}"
  , "3": "supongo que también el 3"
  , "uno" : [ { "dentro": { "deotro": 4 , "si": "si!"}}]}
  ,"dos":[{"dentro":{"deotro":4,"si":"si!"}}]}
]
JSON
);

pru_json_sangrar("Tiene que entrecomillas los tags de la izquierda"
, <<<JSON
[ { uno: 1
  , dos: 2
  , tres: 
    { alfa: "a"
    , beta: "b"
    , gama: 
      [ "gama"
      , "gamma"
      , "gamha"
      ]
    , dificiles: "{esta: [no: \\"se debe cortar\\", no]}"
    , epsilon: "e"
    }
  }
, 7
]
JSON
);


pru_json_d("con timestamp"
	, 't_confecha'
	, array(<<<SQL
		CREATE TABLE test.t_confecha(
			ahora timestamp not null default current_timestamp primary key
		)
SQL
, <<<SQL
		INSERT INTO test.t_confecha (ahora)
			VALUES ('2010-05-06 20:10:00');
SQL
	)
, <<<JSON
[ { ahora:"2010-05-06 20:10:00"}
]
JSON
);


echo "<p><b>Se corrieron $pru_cant_pruebas_json_d pruebas de json";
echo <<<HTML
<script language='JavaScript'>
	var d=new Date(2010,11,30,20,10);
	var j=JSON.stringify(d);
	document.write('<p>mi fecha: '+j+'</p>');
	var dd=JSON.parse(j);
	document.write('<p>tipo de dd: '+(typeof dd)+'</p>');
	
</script>
HTML;

function pru_json_d($nombre_caso, $tabla_que_dumpear, $sqls_a_subir_a_la_base, $salida_esperada, $modo='probar_los_dos', $vuelta=''){
	global $db;
	foreach($sqls_a_subir_a_la_base as $sql){
		$db->ejecutar($sql);
	}
	// ejecuta json_dump y verifica que el json obtenido sea el que esperaba
	$obtenido=json_dump("test",$tabla_que_dumpear);
	pru_comparar_resultados($nombre_caso, $salida_esperada, $obtenido);
	if($modo!='sin_probar_ins'){
		// luego hago lo inverso, tomo como punto de partida el json y genero las sentencias INSERT, luego comparo esas sentencias INSERT 
		$json_entrada=$salida_esperada; // la salda ahora es entrada
		$sql_insert_obtenido=json_generar_insert("test",$tabla_que_dumpear,json_arreglar($json_entrada));
		if($modo=='la vuelta es esta'){
			$insert_esperado=$vuelta;
		}else{
			$insert_esperado=implode(
				array_filter($sqls_a_subir_a_la_base
					, function ($una_sentencia) { 
						return strpos($una_sentencia,'INSERT')!==FALSE && strpos($una_sentencia,'test.tablas')===FALSE; 
					}
				)
			);
		}
		pru_comparar_resultados($nombre_caso."<br>".$salida_esperada,insert_bonito($insert_esperado),insert_bonito($sql_insert_obtenido));
	}
}

function pru_comparar_resultados($nombre_caso, $salida_esperada, $obtenido){
	global $pru_cant_pruebas_json_d;
	$pru_cant_pruebas_json_d++;
	$salida_esperada=str_replace("\r",'',$salida_esperada);
	$obtenido=str_replace("\r",'',$obtenido);
	if($obtenido!=$salida_esperada){
		echo "<p>Error en el caso ".$nombre_caso;
		echo "<p>esperado:<pre>\n".$salida_esperada."</pre>";
		echo "<p>obtenido:<pre>\n".$obtenido."</pre>";
		$i=0;
		echo "<p>iguales en:<code>";
		while($i<strlen($obtenido) && $i<strlen($salida_esperada) && substr($obtenido,$i,1)==substr($salida_esperada,$i,1)){
			echo substr($salida_esperada,$i,1);
			$i++;
		}
		echo "</code>";
		echo "<p>diferente esperado:<code>".ord(substr($salida_esperada,$i))."«".str_replace(" ","&#3645;",substr($salida_esperada,$i))."»</code>";
		echo "<p>diferente obtenido:<code>".ord(substr($obtenido,$i))."«".str_replace(" ","&#3645;",substr($obtenido,$i))."»</code>";
	}
}

function pru_json_arreglar($nombre_caso, $que_arreglar, $salida_esperada){
	$obtenido=json_arreglar($que_arreglar);
	pru_comparar_resultados($nombre_caso, $salida_esperada, $obtenido);
}

function pru_json_sangrar($nombre_caso, $salida_esperada){
	$que_sangrar=str_replace(array("\r","\n",' "',' g'),array('','','"','   g'),$salida_esperada);
	$obtenido=json_sangrar($que_sangrar);
	pru_comparar_resultados($nombre_caso, $salida_esperada, $obtenido);
}

function pru_json_dropear_tablas_si_existen($array_de_tablas){
	global $db;
	foreach($array_de_tablas as $tabla){
		$db->ejecutar("DROP TABLE IF EXISTS test.{$tabla}");
	}
}

function Elegir_Esquema($esquema){
}

?>