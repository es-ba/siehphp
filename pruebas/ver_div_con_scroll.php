<html>
<body>
<div id=afuera style='position:absolute; left:10%; right:20%; top:5%; bottom:15%; border:1px solid green; overflow-x:scroll; -webkit-overflow-scrolling: touch;'>

<script>
var a=[];
a[1]="uno";
var b={}
b[1]="dos";
document.write('verificando las características del div:');
var div=document.getElementById('afuera');
document.write(JSON.stringify(div.style));
</script>

<div id="mw-content-text" lang="es" dir="ltr" class="mw-content-ltr"><p>La <b>tercera forma normal</b> (<b>3NF</b>) es una <a href="/wiki/Forma_normal_(base_de_datos)" title="Forma normal (base de datos)">forma normal</a> usada en la <a href="/wiki/Normalizaci%C3%B3n_de_bases_de_datos" title="Normalización de bases de datos">normalización de bases de datos</a>. La 3NF fue definida originalmente por <a href="/wiki/Edgar_Frank_Codd" title="Edgar Frank Codd">E.F. Codd</a><sup id="cite_ref-Codd_0-0" class="reference"><a href="#cite_note-Codd-0"><span class="corchete-llamada">[</span>1<span class="corchete-llamada">]</span></a></sup> en 1971. La definición de Codd indica que una tabla está en 3NF <a href="/wiki/Si_y_solo_si" title="Si y solo si" class="mw-redirect">si y solo si</a> las dos condiciones siguientes se mantienen:</p>
<ul>
<li>La tabla está en la <a href="/wiki/Segunda_forma_normal" title="Segunda forma normal">segunda forma normal</a> (2NF)</li>
<li>Ningún atributo no-primario de la tabla es dependiente transitivamente de una <a href="/wiki/Clave_primaria" title="Clave primaria">clave primaria</a></li>
</ul>
<p>Un atributo no-primario es un atributo que no pertenece a ninguna clave candidata. Una <i>dependencia transitiva</i> es una <a href="/wiki/Dependencia_funcional" title="Dependencia funcional">dependencia funcional</a> <i>X</i> ? <i>Z</i> en la cual <i>Z</i> no es inmediatamente dependiente de <i>X</i>, pero sí de un tercer conjunto de atributos <i>Y</i>, que a su vez depende de <i>X</i>. Es decir, <i>X</i> ? <i>Z</i> por virtud de <i>X</i> ? <i>Y</i> e <i>Y</i> ? <i>Z</i>.</p>
<p>Una formulación alternativa de la definición de Codd, dada por Carlo Zaniolo<sup id="cite_ref-Zaniolo_1-0" class="reference"><a href="#cite_note-Zaniolo-1"><span class="corchete-llamada">[</span>2<span class="corchete-llamada">]</span></a></sup> en 1982, es ésta: Una tabla está en 3NF si y solo si, para cada una de sus dependencias funcionales <i>X</i> ? <i>A</i>, por lo menos una de las condiciones siguientes se mantiene:</p>
<ul>
<li><i>X</i> contiene <i>A</i>, ó</li>
<li><i>X</i> es una <a href="/wiki/Superclave" title="Superclave" class="mw-redirect">superclave</a>, ó</li>
<li><i>A</i> es un atributo primario (es decir, <i>A</i> está contenido dentro de una clave candidata)</li>
</ul>
<p>La definición de Zaniolo tiene la ventaja de dar un claro sentido de la diferencia entre la 3NF y la más rigurosa <a href="/wiki/Forma_normal_de_Boyce-Codd" title="Forma normal de Boyce-Codd">forma normal de Boyce-Codd</a> (BCNF). La BCNF simplemente elimina la tercera alternativa ("<i>A</i> es un atributo primario").</p>
<table id="toc" class="toc">
<tr>
<td>
<div id="toctitle">
<h2>Contenido</h2>
</div>
<ul>
<li class="toclevel-1 tocsection-1"><a href="#.22Nada_excepto_la_clave.22"><span class="tocnumber">1</span> <span class="toctext">"Nada excepto la clave"</span></a></li>
<li class="toclevel-1 tocsection-2"><a href="#Ejemplo"><span class="tocnumber">2</span> <span class="toctext">Ejemplo</span></a></li>
<li class="toclevel-1 tocsection-3"><a href="#Derivaci.C3.B3n_de_las_condiciones_de_Zambruno"><span class="tocnumber">3</span> <span class="toctext">Derivación de las condiciones de Zambruno</span></a></li>
<li class="toclevel-1 tocsection-4"><a href="#Normalizaci.C3.B3n_m.C3.A1s_all.C3.A1_de_la_3NF"><span class="tocnumber">4</span> <span class="toctext">Normalización más allá de la 3NF</span></a></li>
<li class="toclevel-1 tocsection-5"><a href="#Referencias"><span class="tocnumber">5</span> <span class="toctext">Referencias</span></a></li>
<li class="toclevel-1 tocsection-6"><a href="#Lectura_adicional"><span class="tocnumber">6</span> <span class="toctext">Lectura adicional</span></a></li>
<li class="toclevel-1 tocsection-7"><a href="#V.C3.A9ase_tambi.C3.A9n"><span class="tocnumber">7</span> <span class="toctext">Véase también</span></a></li>
<li class="toclevel-1 tocsection-8"><a href="#Enlaces_externos"><span class="tocnumber">8</span> <span class="toctext">Enlaces externos</span></a></li>
</ul>
</td>
</tr>
</table>
<h2><span class="editsection"></span> <span class="mw-headline" id=".22Nada_excepto_la_clave.22">"Nada excepto la clave"</span></h2>
<p>Un memorable resumen de la definición de Codd de la 3NF, siendo paralelo al compromiso tradicional de dar evidencia verdadera en un tribunal de justicia, fue dado por <a href="/w/index.php?title=Bill_Kent&amp;action=edit&amp;redlink=1" class="new" title="Bill Kent (aún no redactado)">Bill Kent</a>: cada atributo no-clave "debe proporcionar un hecho sobre la clave, la clave entera, y nada más excepto la clave".<sup id="cite_ref-Kent_2-0" class="reference"><a href="#cite_note-Kent-2"><span class="corchete-llamada">[</span>3<span class="corchete-llamada">]</span></a></sup> Una variación común complementa esta definición con el juramento: "con la ayuda de Codd".<sup id="cite_ref-Diehr_3-0" class="reference"><a href="#cite_note-Diehr-3"><span class="corchete-llamada">[</span>4<span class="corchete-llamada">]</span></a></sup></p>
<p>Requerir que los atributos no-clave sean dependientes en "la clave completa" asegura que una tabla esté en 2NF; un requerimiento posterior que los atributos no-clave sean dependientes de "nada excepto la clave" asegura que la tabla esté en 3NF.</p>
<p><a href="/wiki/Christopher_Date" title="Christopher Date">Chris Date</a> refiere al resumen de Kent como "una intuitiva atractiva caracterización" de la 3NF, y observa que con una ligera adaptación puede servir como definición ligeramente más fuerte de la <a href="/wiki/Forma_normal_de_Boyce-Codd" title="Forma normal de Boyce-Codd">forma normal de Boyce-Codd</a>: "Cada atributo debe representar un hecho acerca de la clave, la clave entera, y nada excepto la clave".<sup id="cite_ref-DateIntro_4-0" class="reference"><a href="#cite_note-DateIntro-4"><span class="corchete-llamada">[</span>5<span class="corchete-llamada">]</span></a></sup> La versión 3NF de la definición es más débil que la variación de BCNF de Date, pues el anterior se refiere solamente a asegurarse de que los atributos no-clave son dependientes en las claves. Los atributos primarios (que son claves o partes de claves) no deben ser funcionalmente dependientes en absoluto; cada uno de ellos representa un hecho sobre la clave en el sentido de proporcionar parte o toda la clave en sí misma. Debe ser observado que esta regla se aplica solamente a los atributos funcionalmente dependientes, Ya que aplicándola a todos los atributos prohibiría implícitamente claves de candidato compuestas, puesto que cada parte de cualquiera de tales claves violaría la cláusula de "clave completa"..</p>
<h2><span class="editsection"></span> <span class="mw-headline" id="Ejemplo">Ejemplo</span></h2>
<p>Un ejemplo de una tabla 2NF que falla en satisfacer los requerimientos de la 3NF es:</p>
<table class="wikitable">
<caption>Ganadores del torneo</caption>
<tr>
<th><u>Torneo</u></th>
<th><u>Año</u></th>
<th>Ganador</th>
<th>Fecha de nacimiento del ganador</th>
</tr>
<tr>
<td>Indiana Invitational</td>
<td>1998</td>
<td>Al Fredrickson</td>
<td>21 de julio de 1975</td>
</tr>
<tr>
<td>Cleveland Open</td>
<td>1999</td>
<td>Bob Albertson</td>
<td>28 de septiembre de 1968</td>
</tr>
<tr>
<td>Des Moines Masters</td>
<td>1999</td>
<td>Al Fredrickson</td>
<td>21 de julio de 1975</td>
</tr>
<tr>
<td>Indiana Invitational</td>
<td>1999</td>
<td>Chip Masterson</td>
<td>14 de marzo de 1977</td>
</tr>
</table>
<p>La única clave candidata es {Torneo, Año}.</p>
<p>La violación de la 3NF ocurre porque el atributo no primario <i>Fecha de nacimiento del ganador</i> es dependiente transitivamente de {Torneo, Año} vía el atributo no primario <i>Ganador</i>. El hecho de que la <i>Fecha de nacimiento del ganador</i> es funcionalmente dependiente en el <i>Ganador</i> hace la tabla vulnerable a inconsistencias lógicas, pues no hay nada que impida a la misma persona ser mostrada con diferentes fechas de nacimiento en diversos registros.</p>
<p>Para expresar los mismos hechos sin violar la 3NF, es necesario dividir la tabla en dos:</p>
<table class="wikitable">
<caption>Ganadores del torneo</caption>
<tr>
<th><u>Torneo</u></th>
<th><u>Año</u></th>
<th>Ganador</th>
</tr>
<tr>
<td>Indiana Invitational</td>
<td>1998</td>
<td>Al Fredrickson</td>
</tr>
<tr>
<td>Cleveland Open</td>
<td>1999</td>
<td>Bob Albertson</td>
</tr>
<tr>
<td>Des Moines Masters</td>
<td>1999</td>
<td>Al Fredrickson</td>
</tr>
<tr>
<td>Indiana Invitational</td>
<td>1999</td>
<td>Chip Masterson</td>
</tr>
</table>
<dl>
<dd>
<dl>
<dd>
<dl>
<dd>
<table class="wikitable">
<caption>Fecha de nacimiento del jugador</caption>
<tr>
<th><u>Ganador</u></th>
<th>Fecha de nacimiento</th>
</tr>
<tr>
<td>Chip Masterson</td>
<td>14 de marzo de 1977</td>
</tr>
<tr>
<td>Al Fredrickson</td>
<td>21 de julio de 1975</td>
</tr>
<tr>
<td>Bob Albertson</td>
<td>28 de septiembre de 1968</td>
</tr>
</table>
</dd>
</dl>
</dd>
</dl>
</dd>
</dl>
<p>Las anomalías de actualización no pueden ocurrir en estas tablas, las cuales están en 3NF.</p>
<h2><span class="editsection"></span> <span class="mw-headline" id="Derivaci.C3.B3n_de_las_condiciones_de_Zambruno">Derivación de las condiciones de Zambruno</span></h2>
<p>La definición de 3NF ofrecida por Carlo Zaniolo en 1982, y dada arriba, es probada así: Sea X ? A un FD no trivial (es decir, uno donde X no contiene a A) y sea A un atributo no clave. También sea Y una clave de R. Entonces Y ? X. Por lo tanto A no es dependiente transitivo de Y, si y solo si el X ? Y, es decir, si y solo si X es una superclave.<sup id="cite_ref-5" class="reference"><a href="#cite_note-5"><span class="corchete-llamada">[</span>6<span class="corchete-llamada">]</span></a></sup></p>
<h2><span class="editsection"></span> <span class="mw-headline" id="Normalizaci.C3.B3n_m.C3.A1s_all.C3.A1_de_la_3NF">Normalización más allá de la 3NF</span></h2>
<p>La mayoría de las tablas 3NF están libres anomalías de actualización, inserción, y borrado. Ciertos tipos de tablas 3NF, que en la práctica raramente se encuentran, son afectadas por tales anomalías; éstas son tablas que no satisfacen la <a href="/wiki/Forma_normal_de_Boyce-Codd" title="Forma normal de Boyce-Codd">forma normal de Boyce-Codd</a> (BCNF) o, si satisfacen la BCNF, son insuficientes para satisfacer las formas normales más altas <a href="/wiki/Cuarta_forma_normal" title="Cuarta forma normal">4NF</a> o <a href="/wiki/Quinta_forma_normal" title="Quinta forma normal">5NF</a>.</p>
<h2><span class="editsection"></span> <span class="mw-headline" id="Referencias">Referencias</span></h2>
<ol class="references">
<li id="cite_note-Codd-0"><span class="mw-cite-backlink"><a href="#cite_ref-Codd_0-0">?</a></span> <span class="reference-text">Codd, E.F. "Further Normalization of the Data Base Relational Model." (Presented at Courant Computer Science Symposia Series 6, "Data Base Systems," New York City, May 24th-25th, 1971.) IBM Research Report RJ909 (August 31st, 1971). Republished in Randall J. Rustin (ed.), <i>Data Base Systems: Courant Computer Science Symposia Series 6</i>. Prentice-Hall, 1972.</span></li>
<li id="cite_note-Zaniolo-1"><span class="mw-cite-backlink"><a href="#cite_ref-Zaniolo_1-0">?</a></span> <span class="reference-text">Zaniolo, Carlo. "A New Normal Form for the Design of Relational Database Schemata." <i>ACM Transactions on Database Systems</i> 7(3), September 1982.</span></li>
<li id="cite_note-Kent-2"><span class="mw-cite-backlink"><a href="#cite_ref-Kent_2-0">?</a></span> <span class="reference-text">Kent, William. <a rel="nofollow" class="external text" href="http://www.bkent.net/Doc/simple5.htm">"A Simple Guide to Five Normal Forms in Relational Database Theory"</a>, <i>Communications of the ACM</i> <b>26</b> (2), Feb. 1983, pp. 120-125.</span></li>
<li id="cite_note-Diehr-3"><span class="mw-cite-backlink"><a href="#cite_ref-Diehr_3-0">?</a></span> <span class="reference-text">The author of a 1989 book on database management credits one of his students with coming up with the "so help me Codd" addendum. Diehr, George. <i>Database Management</i> (Scott, Foresman, 1989), p. 331.</span></li>
<li id="cite_note-DateIntro-4"><span class="mw-cite-backlink"><a href="#cite_ref-DateIntro_4-0">?</a></span> <span class="reference-text">Date, C.J. <i>An Introduction to Database Systems</i> (7th ed.) (Addison Wesley, 2000), p. 379.</span></li>
<li id="cite_note-5"><span class="mw-cite-backlink"><a href="#cite_ref-5">?</a></span> <span class="reference-text">Zaniolo, p. 494.</span></li>
</ol>
<h2><span class="editsection"></span> <span class="mw-headline" id="Lectura_adicional">Lectura adicional</span></h2>
<ul>
<li>Date, C. J. (1999), <i><a rel="nofollow" class="external text" href="http://www.aw-bc.com/catalog/academic/product/0,1144,0321197844,00.html">An Introduction to Database Systems</a></i> (8th ed.). Addison-Wesley Longman. <a href="/wiki/Especial:FuentesDeLibros/0321197844" class="internal mw-magiclink-isbn">ISBN 0-321-19784-4</a>.</li>
<li>Kent, W. (1983) <i><a rel="nofollow" class="external text" href="http://www.bkent.net/Doc/simple5.htm">A Simple Guide to Five Normal Forms in Relational Database Theory</a></i>, Communications of the ACM, vol. 26, pp. 120-125</li>
</ul>
<h2><span class="editsection"></span> <span class="mw-headline" id="V.C3.A9ase_tambi.C3.A9n">Véase también</span></h2>
<ul>
<li><a href="/wiki/1NF" title="1NF" class="mw-redirect">1NF</a> - <a href="/wiki/2NF" title="2NF" class="mw-redirect">2NF</a> - <a href="/wiki/3NF" title="3NF" class="mw-redirect">3NF</a> - <a href="/wiki/BCNF" title="BCNF" class="mw-redirect">BCNF</a> - <a href="/wiki/4NF" title="4NF" class="mw-redirect">4NF</a> - <a href="/wiki/5NF" title="5NF" class="mw-redirect">5NF</a> - <a href="/wiki/DKNF" title="DKNF" class="mw-redirect">DKNF</a> - <a href="/wiki/Denormalizaci%C3%B3n_(base_de_datos)" title="Denormalización (base de datos)">Denormalización</a></li>
</ul>
<h2><span class="editsection"></span> <span class="mw-headline" id="Enlaces_externos">Enlaces externos</span></h2>
<ul>
<li><a rel="nofollow" class="external text" href="http://www.troubleshooters.com/littstip/ltnorm.html">Litt's Tips: Normalization</a></li>
<li><a rel="nofollow" class="external text" href="http://www.datamodel.org/NormalizationRules.html">Rules Of Data Normalization</a></li>
<li><a rel="nofollow" class="external text" href="http://databases.about.com/od/specificproducts/a/normalization.htm">Database Normalization Basics</a> by Mike Chapple (About.com)</li>
<li><a rel="nofollow" class="external text" href="http://dev.mysql.com/tech-resources/articles/intro-to-normalization.html">An Introduction to Database Normalization</a> by Mike Hillyer.</li>
<li><a rel="nofollow" class="external text" href="http://www.utexas.edu/its/windows/database/datamodeling/rm/rm7.html">Normalization</a> by ITS, University of Texas.</li>
<li><a rel="nofollow" class="external text" href="http://phlonx.com/resources/nf3/">A tutorial on the first 3 normal forms</a> by Fred Coulson</li>
<li><a rel="nofollow" class="external text" href="http://support.microsoft.com/kb/283878">Description of the database normalization basics</a> by Microsoft</li>
<li><a rel="nofollow" class="external text" href="http://www.dbdebunk.com">Database Debunkings</a>: Fabian Pascal, Chris Date, and Hugh Darwen</li>
</ul>

</div>
</div>
</body>
</html>