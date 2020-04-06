create or replace function comun.reemplazar_variables(p_expresion text, p_reemplazante text) RETURNS text
  language sql 
as $$ select regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace($1,
                 '(?!\mAND\M)(?!\mOR\M)(?!\mNOT\M)(?!\mIS\M)(?!\mNULL\M)(?!\mIN\M)(?!\mTRUE\M)(?!\mFALSE\M)(?!\mEXISTS\M)(?!\mDISTINCT\M)(?!\mFROM\M)(?!\mBETWEEN\M)((\m[a-z][a-z0-9_.]*?\M)|\$\$[^$]*?\$\$|"@[^"]*?@"\()(?!\.)(?!\s*\()',
                 '¬¬¬¬1234¬¬¬¬\1¬¬¬¬4321¬¬¬¬','ig'),
                 '¬¬¬¬1234¬¬¬¬(\$\$.*?\$\$)¬¬¬¬4321¬¬¬¬','\1::text','ig'),
                 '::¬¬¬¬1234¬¬¬¬(.*?)¬¬¬¬4321¬¬¬¬','::\1','ig'),
                 '¬¬¬¬1234¬¬¬¬(\W.*?)¬¬¬¬4321¬¬¬¬','\1','ig'),
                 '¬¬¬¬1234¬¬¬¬(.*?)¬¬¬¬4321¬¬¬¬',$2,'ig'),
                 '/','::numeric/','ig'),
                 '((::numeric *|\*)::numeric *)/|::numeric/(\*)','\2/\3','ig')
   $$;

select * from (
select expresion, reemplazante, esperado, comun.reemplazar_variables(expresion, reemplazante) as obtenido
  from (select 'uno+dos' as expresion,'v_\1' as reemplazante,'v_uno+v_dos' as esperado
        union select 'x * y', 'j', 'j * j'
        union select 'var_1 and var_2', 'x["\1"]', 'x["var_1"] and x["var_2"]'
        union select 'x + 3 IS NOT NULL', 'v_\1', 'v_x + 3 IS NOT NULL'
        union select 'f(x)', 'v_\1', 'f(v_x)'
        union select 'dbo.dic_tradu(algo)', 'pla_\1', 'dbo.dic_tradu(pla_algo)'
        union select 'dbo.dictradu(algo)', 'pla_\1', 'dbo.dictradu(pla_algo)'
        union select 'dbo.dictradu($$algo$$,variable,$$otra cosa$$)', 'pla_\1', 'dbo.dictradu($$algo$$::text,pla_variable,$$otra cosa$$::text)'
        union select 'g (algo)', 'v_\1', 'g (v_algo)'
        union select 'f(algo/otra)', 'v_\1', 'f(v_algo::numeric/v_otra)'
        union select 'f(algo::numeric*otra)', 'v_\1', 'f(v_algo::numeric*v_otra)'
        union select 'f(algo::numeric/otra)', 'v_\1', 'f(v_algo::numeric/v_otra)'
        union select 'f(/*7*/1)', 'v_\1', 'f(/*7*/1)'
        union select 'traducir(algo)', 'v_\1', 'traducir(v_algo)' 
        union select 'NOTA * RENOT', 'v_\1', 'v_NOTA * v_RENOT'
        union select 'g (algo) + "@(esto no se cambia, no no no @ tampoco + se cambia porque las arrobas)@"(encuesta, hogar) + j', 'v_\1', 'g (v_algo) + "@(esto no se cambia, no no no @ tampoco + se cambia porque las arrobas)@"(v_encuesta, v_hogar) + v_j'
        union select 'g (algo) + "@(no no no @ tampoco)@"(encuesta, hogar) + j + "@(no no no @ tampoco)@"(encuesta, hogar)', 'v_\1', 'g (v_algo) + "@(no no no @ tampoco)@"(v_encuesta, v_hogar) + v_j + "@(no no no @ tampoco)@"(v_encuesta, v_hogar)'
        union select 'x', null, null
        union select null, 'x', null
        ) datos
        ) pruebas
  where esperado is distinct from obtenido;
