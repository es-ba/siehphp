 select  v.var_for, string_agg( s.sal_var|| '=' ||s.sal_opc, ' or ') as cond--s.sal_var, s.sal_opc, v.var_destino_nsnc
            from encu.saltos s JOIN encu.variables_ordenadas v ON s.sal_var= v.var_var AND s.sal_ope=v.var_ope
            where s.sal_ope='etoi242' and s.sal_destino='fin'
            group by v.var_for
  UNION 
  select distinct var_for, var_ultima_for ||'>0' as cond
   from encu.variables_ordenadas
   where var_ope='etoi242'