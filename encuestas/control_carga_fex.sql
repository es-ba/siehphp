/*
select s.pla_enc, s.pla_hog, pla_entrea, pla_rea, pla_estado, pla_fexp
  from encu.plana_s1_ s inner join encu.plana_tem_ t on s.pla_enc=t.pla_enc
    inner join encu.plana_i1_ i on s.pla_enc=i.pla_enc and s.pla_hog=i.pla_hog
  where (pla_fexp is not null or pla_rea in (1,3,4,5) or pla_entrea<>2)
    -- and s.pla_enc=424401 -- and s.pla_hog=2
    and s.pla_enc in (424401, 512209) and s.pla_hog>1
  order by s.pla_enc, s.pla_hog

select s.pla_enc, s.pla_hog, pla_entrea, pla_rea, pla_estado, pla_fexp
  from encu.plana_s1_ s inner join encu.plana_tem_ t on s.pla_enc=t.pla_enc
    inner join encu.plana_i1_ i on s.pla_enc=i.pla_enc and s.pla_hog=i.pla_hog
  where pla_entrea>2 or pla_rea>3
  order by s.pla_enc, s.pla_hog
*/

select s.pla_enc, s.pla_hog, pla_entrea, pla_rea, pla_estado, pla_fexp
  from encu.plana_s1_ s inner join encu.plana_tem_ t on s.pla_enc=t.pla_enc
    inner join encu.plana_a1_ a on s.pla_enc=a.pla_enc and s.pla_hog=a.pla_hog
    -- inner join encu.plana_i1_ i on s.pla_enc=i.pla_enc and s.pla_hog=i.pla_hog
  where (pla_fexp is not null or pla_rea in (1,3,4,5) or pla_entrea<>2)
    -- and s.pla_enc=424401 -- and s.pla_hog=2
    and s.pla_enc in (424401, 512209) and s.pla_hog>1
  order by s.pla_enc, s.pla_hog
