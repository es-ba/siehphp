set search_path=encu, comun, dbo, public;
ALTER TABLE plana_i1_
  ADD COLUMN pla_c1_tcs   INTEGER,
  ADD COLUMN pla_c2_tcs   INTEGER,
  ADD COLUMN pla_c13_tcs  INTEGER,
  ADD COLUMN pla_c14_tcs  INTEGER,
  ADD COLUMN pla_c31_tcs  INTEGER,
  ADD COLUMN pla_c32_tcs  INTEGER,
  ADD COLUMN pla_c33_tcs  INTEGER,
  ADD COLUMN pla_c34_tcs  INTEGER,
  ADD COLUMN pla_c35_tcs  INTEGER,
  ADD COLUMN pla_c36_tcs  INTEGER,
  ADD COLUMN pla_c37_tcs  INTEGER,
  ADD COLUMN pla_c51_tcs  INTEGER,
  ADD COLUMN pla_c54_tcs  INTEGER,
  ADD COLUMN pla_c61_tcs  INTEGER,
  ADD COLUMN pla_c62_tcs  INTEGER,
  ADD COLUMN pla_c71_tcs  INTEGER,
  ADD COLUMN pla_c72_tcs  INTEGER,
  ADD COLUMN pla_c73_tcs  INTEGER,
  ADD COLUMN pla_c74_tcs  INTEGER,
  ADD COLUMN pla_c81_tcs  INTEGER,
  ADD COLUMN pla_c82_tcs  INTEGER,
  ADD COLUMN pla_c83_tcs  INTEGER,
  ADD COLUMN pla_c84_tcs  INTEGER,
  ADD COLUMN pla_c411_tcs INTEGER,
  ADD COLUMN pla_c412_tcs INTEGER,
  ADD COLUMN pla_c413_tcs INTEGER,
  ADD COLUMN pla_c414_tcs INTEGER,
  ADD COLUMN pla_c421_tcs INTEGER,
  ADD COLUMN pla_c422_tcs INTEGER,
  ADD COLUMN pla_c423_tcs INTEGER,
  ADD COLUMN pla_c431_tcs INTEGER,
  ADD COLUMN pla_c432_tcs INTEGER,
  ADD COLUMN pla_c433_tcs INTEGER,
  ADD COLUMN pla_c441_tcs INTEGER,
  ADD COLUMN pla_c442_tcs INTEGER,
  ADD COLUMN pla_c443_tcs INTEGER,
  ADD COLUMN pla_c911_tcs INTEGER,
  ADD COLUMN pla_c912_tcs INTEGER,
  ADD COLUMN pla_c914_tcs INTEGER,
  ADD COLUMN pla_c921_tcs INTEGER,
  ADD COLUMN pla_c922_tcs INTEGER,
  ADD COLUMN pla_c999_tcs INTEGER,

  ADD COLUMN pla_c1_tss   INTEGER,
  ADD COLUMN pla_c2_tss   INTEGER,
  ADD COLUMN pla_c13_tss  INTEGER,
  ADD COLUMN pla_c14_tss  INTEGER,
  ADD COLUMN pla_c31_tss  INTEGER,
  ADD COLUMN pla_c32_tss  INTEGER,
  ADD COLUMN pla_c33_tss  INTEGER,
  ADD COLUMN pla_c34_tss  INTEGER,
  ADD COLUMN pla_c35_tss  INTEGER,
  ADD COLUMN pla_c36_tss  INTEGER,
  ADD COLUMN pla_c37_tss  INTEGER,
  ADD COLUMN pla_c51_tss  INTEGER,
  ADD COLUMN pla_c54_tss  INTEGER,
  ADD COLUMN pla_c61_tss  INTEGER,
  ADD COLUMN pla_c62_tss  INTEGER,
  ADD COLUMN pla_c71_tss  INTEGER,
  ADD COLUMN pla_c72_tss  INTEGER,
  ADD COLUMN pla_c73_tss  INTEGER,
  ADD COLUMN pla_c74_tss  INTEGER,
  ADD COLUMN pla_c81_tss  INTEGER,
  ADD COLUMN pla_c82_tss  INTEGER,
  ADD COLUMN pla_c83_tss  INTEGER,
  ADD COLUMN pla_c84_tss  INTEGER,
  ADD COLUMN pla_c411_tss INTEGER,
  ADD COLUMN pla_c412_tss INTEGER,
  ADD COLUMN pla_c413_tss INTEGER,
  ADD COLUMN pla_c414_tss INTEGER,
  ADD COLUMN pla_c421_tss INTEGER,
  ADD COLUMN pla_c422_tss INTEGER,
  ADD COLUMN pla_c423_tss INTEGER,
  ADD COLUMN pla_c431_tss INTEGER,
  ADD COLUMN pla_c432_tss INTEGER,
  ADD COLUMN pla_c433_tss INTEGER,
  ADD COLUMN pla_c441_tss INTEGER,
  ADD COLUMN pla_c442_tss INTEGER,
  ADD COLUMN pla_c443_tss INTEGER,
  ADD COLUMN pla_c911_tss INTEGER,
  ADD COLUMN pla_c912_tss INTEGER,
  ADD COLUMN pla_c914_tss INTEGER,
  ADD COLUMN pla_c921_tss INTEGER,
  ADD COLUMN pla_c922_tss INTEGER,
  ADD COLUMN pla_c999_tss INTEGER;

  
--FUNCION TRIGGERS  
set search_path=encu, comun, dbo, public;
-- Function: encu.recalcular_tiempos_actividades_i1_trg()

-- DROP FUNCTION encu.recalcular_tiempos_actividades_i1_trg();

CREATE OR REPLACE FUNCTION encu.recalcular_tiempos_actividades_i1_trg()
  RETURNS trigger AS
$BODY$
    DECLARE
    x_c1_tcs     integer;
    x_c2_tcs     integer;
    x_c13_tcs    integer;
    x_c14_tcs    integer;
    x_c31_tcs    integer;
    x_c32_tcs    integer;
    x_c33_tcs    integer;
    x_c34_tcs    integer;
    x_c35_tcs    integer;
    x_c36_tcs    integer;
    x_c37_tcs    integer;
    x_c51_tcs    integer;
    x_c54_tcs    integer;
    x_c61_tcs    integer;
    x_c62_tcs    integer;
    x_c71_tcs    integer;
    x_c72_tcs    integer;
    x_c73_tcs    integer;
    x_c74_tcs    integer;
    x_c81_tcs    integer;
    x_c82_tcs    integer;
    x_c83_tcs    integer;
    x_c84_tcs    integer;
    x_c411_tcs   integer;
    x_c412_tcs   integer;
    x_c413_tcs   integer;
    x_c414_tcs   integer;
    x_c421_tcs   integer;
    x_c422_tcs   integer;
    x_c423_tcs   integer;
    x_c431_tcs   integer;
    x_c432_tcs   integer;
    x_c433_tcs   integer;
    x_c441_tcs   integer;
    x_c442_tcs   integer;
    x_c443_tcs   integer;
    x_c911_tcs   integer;
    x_c912_tcs   integer;
    x_c914_tcs   integer;
    x_c921_tcs   integer;
    x_c922_tcs   integer;
    x_c999_tcs   integer;
                 
    x_c1_tss     integer;    
    x_c2_tss     integer;    
    x_c13_tss    integer;    
    x_c14_tss    integer;    
    x_c31_tss    integer;    
    x_c32_tss    integer;    
    x_c33_tss    integer;    
    x_c34_tss    integer;    
    x_c35_tss    integer;    
    x_c36_tss    integer;    
    x_c37_tss    integer;    
    x_c51_tss    integer;    
    x_c54_tss    integer;    
    x_c61_tss    integer;    
    x_c62_tss    integer;    
    x_c71_tss    integer;    
    x_c72_tss    integer;    
    x_c73_tss    integer;    
    x_c74_tss    integer;    
    x_c81_tss    integer;    
    x_c82_tss    integer;    
    x_c83_tss    integer;    
    x_c84_tss    integer;    
    x_c411_tss   integer;    
    x_c412_tss   integer;    
    x_c413_tss   integer;    
    x_c414_tss   integer;    
    x_c421_tss   integer;    
    x_c422_tss   integer;    
    x_c423_tss   integer;    
    x_c431_tss   integer;    
    x_c432_tss   integer;    
    x_c433_tss   integer;    
    x_c441_tss   integer;    
    x_c442_tss   integer;    
    x_c443_tss   integer;    
    x_c911_tss   integer;    
    x_c912_tss   integer;    
    x_c914_tss   integer;    
    x_c921_tss   integer;    
    x_c922_tss   integer;    
    x_c999_tss   integer;
    BEGIN
        --raise notice ' modulo old:% new: %', old.pla_modulo_1,new.pla_modulo_1;
        
        --raise notice ' agrupado 82 % ', dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 82, $$pla_t_con_simu_min$$);

        if (new.pla_modulo_1 is distinct from old.pla_modulo_1) or (
            new.pla_c1_tcs  is null and new.pla_c2_tcs   is null and new.pla_c13_tcs  is null and new.pla_c14_tcs  is null and
            new.pla_c31_tcs  is null and new.pla_c32_tcs  is null and new.pla_c33_tcs  is null and new.pla_c34_tcs  is null and
            new.pla_c35_tcs  is null and new.pla_c36_tcs  is null and new.pla_c37_tcs  is null and new.pla_c51_tcs  is null and
            new.pla_c54_tcs  is null and new.pla_c61_tcs  is null and new.pla_c62_tcs  is null and new.pla_c71_tcs  is null and
            new.pla_c72_tcs  is null and new.pla_c73_tcs  is null and new.pla_c74_tcs  is null and new.pla_c81_tcs  is null and
            new.pla_c82_tcs  is null and new.pla_c83_tcs  is null and new.pla_c84_tcs  is null and new.pla_c411_tcs is null and
            new.pla_c412_tcs is null and new.pla_c413_tcs is null and new.pla_c414_tcs is null and new.pla_c421_tcs is null and
            new.pla_c422_tcs is null and new.pla_c423_tcs is null and new.pla_c431_tcs is null and new.pla_c432_tcs is null and
            new.pla_c433_tcs is null and new.pla_c441_tcs is null and new.pla_c442_tcs is null and new.pla_c443_tcs is null and
            new.pla_c911_tcs is null and new.pla_c912_tcs is null and new.pla_c914_tcs is null and new.pla_c921_tcs is null and
            new.pla_c922_tcs is null and new.pla_c999_tcs is null ) then
            x_c1_tcs  = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 1, $$pla_t_con_simu_min$$);
            x_c2_tcs  = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 2, $$pla_t_con_simu_min$$);
            x_c13_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 13, $$pla_t_con_simu_min$$);
            x_c14_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 14, $$pla_t_con_simu_min$$);
            x_c31_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 31, $$pla_t_con_simu_min$$);
            x_c32_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 32, $$pla_t_con_simu_min$$);
            x_c33_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 33, $$pla_t_con_simu_min$$);
            x_c34_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 34, $$pla_t_con_simu_min$$);
            x_c35_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 35, $$pla_t_con_simu_min$$);
            x_c36_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 36, $$pla_t_con_simu_min$$);
            x_c37_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 37, $$pla_t_con_simu_min$$);
            x_c51_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 51, $$pla_t_con_simu_min$$);
            x_c54_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 54, $$pla_t_con_simu_min$$);
            x_c61_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 61, $$pla_t_con_simu_min$$);
            x_c62_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 62, $$pla_t_con_simu_min$$);
            x_c71_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 71, $$pla_t_con_simu_min$$);
            x_c72_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 72, $$pla_t_con_simu_min$$);
            x_c73_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 73, $$pla_t_con_simu_min$$);
            x_c74_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 74, $$pla_t_con_simu_min$$);
            x_c81_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 81, $$pla_t_con_simu_min$$);
            x_c82_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 82, $$pla_t_con_simu_min$$);
            x_c83_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 83, $$pla_t_con_simu_min$$);
            x_c84_tcs = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 84, $$pla_t_con_simu_min$$);
            x_c411_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 411, $$pla_t_con_simu_min$$);
            x_c412_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 412, $$pla_t_con_simu_min$$);
            x_c413_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 413, $$pla_t_con_simu_min$$);
            x_c414_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 414, $$pla_t_con_simu_min$$);
            x_c421_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 421, $$pla_t_con_simu_min$$);
            x_c422_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 422, $$pla_t_con_simu_min$$);
            x_c423_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 423, $$pla_t_con_simu_min$$);
            x_c431_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 431, $$pla_t_con_simu_min$$);
            x_c432_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 432, $$pla_t_con_simu_min$$);
            x_c433_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 433, $$pla_t_con_simu_min$$);
            x_c441_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 441, $$pla_t_con_simu_min$$);
            x_c442_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 442, $$pla_t_con_simu_min$$);
            x_c443_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 443, $$pla_t_con_simu_min$$);
            x_c911_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 911, $$pla_t_con_simu_min$$);
            x_c912_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 912, $$pla_t_con_simu_min$$);
            x_c914_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 914, $$pla_t_con_simu_min$$);
            x_c921_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 921, $$pla_t_con_simu_min$$);
            x_c922_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 922, $$pla_t_con_simu_min$$);
            x_c999_tcs= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie, 999, $$pla_t_con_simu_min$$);
            
            x_c1_tss  = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,1, $$pla_t_sin_simu_min$$);
            x_c2_tss  = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,2, $$pla_t_sin_simu_min$$);
            x_c13_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,13, $$pla_t_sin_simu_min$$);
            x_c14_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,14, $$pla_t_sin_simu_min$$);
            x_c31_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,31, $$pla_t_sin_simu_min$$);
            x_c32_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,32, $$pla_t_sin_simu_min$$);
            x_c33_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,33, $$pla_t_sin_simu_min$$);
            x_c34_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,34, $$pla_t_sin_simu_min$$);
            x_c35_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,35, $$pla_t_sin_simu_min$$);
            x_c36_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,36, $$pla_t_sin_simu_min$$);
            x_c37_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,37, $$pla_t_sin_simu_min$$);
            x_c51_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,51, $$pla_t_sin_simu_min$$);
            x_c54_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,54, $$pla_t_sin_simu_min$$);
            x_c61_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,61, $$pla_t_sin_simu_min$$);
            x_c62_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,62, $$pla_t_sin_simu_min$$);
            x_c71_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,71, $$pla_t_sin_simu_min$$);
            x_c72_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,72, $$pla_t_sin_simu_min$$);
            x_c73_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,73, $$pla_t_sin_simu_min$$);
            x_c74_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,74, $$pla_t_sin_simu_min$$);
            x_c81_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,81, $$pla_t_sin_simu_min$$);
            x_c82_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,82, $$pla_t_sin_simu_min$$);
            x_c83_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,83, $$pla_t_sin_simu_min$$);
            x_c84_tss = dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,84, $$pla_t_sin_simu_min$$);
            x_c411_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,411, $$pla_t_sin_simu_min$$);
            x_c412_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,412, $$pla_t_sin_simu_min$$);
            x_c413_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,413, $$pla_t_sin_simu_min$$);
            x_c414_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,414, $$pla_t_sin_simu_min$$);
            x_c421_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,421, $$pla_t_sin_simu_min$$);
            x_c422_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,422, $$pla_t_sin_simu_min$$);
            x_c423_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,423, $$pla_t_sin_simu_min$$);
            x_c431_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,431, $$pla_t_sin_simu_min$$);
            x_c432_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,432, $$pla_t_sin_simu_min$$);
            x_c433_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,433, $$pla_t_sin_simu_min$$);
            x_c441_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,441, $$pla_t_sin_simu_min$$);
            x_c442_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,442, $$pla_t_sin_simu_min$$);
            x_c443_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,443, $$pla_t_sin_simu_min$$);
            x_c911_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,911, $$pla_t_sin_simu_min$$);
            x_c912_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,912, $$pla_t_sin_simu_min$$);
            x_c914_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,914, $$pla_t_sin_simu_min$$);
            x_c921_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,921, $$pla_t_sin_simu_min$$);
            x_c922_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,922, $$pla_t_sin_simu_min$$);
            x_c999_tss= dbo.lee_tiempo_ajustado(new.pla_enc,new.pla_hog,new.pla_mie,999, $$pla_t_sin_simu_min$$);
            update encu.plana_i1_
                set pla_c1_tcs   =x_c1_tcs  ,
                    pla_c2_tcs   =x_c2_tcs  ,
                    pla_c13_tcs  =x_c13_tcs ,
                    pla_c14_tcs  =x_c14_tcs ,
                    pla_c31_tcs  =x_c31_tcs ,
                    pla_c32_tcs  =x_c32_tcs ,
                    pla_c33_tcs  =x_c33_tcs ,
                    pla_c34_tcs  =x_c34_tcs ,
                    pla_c35_tcs  =x_c35_tcs ,
                    pla_c36_tcs  =x_c36_tcs ,
                    pla_c37_tcs  =x_c37_tcs ,
                    pla_c51_tcs  =x_c51_tcs ,
                    pla_c54_tcs  =x_c54_tcs ,
                    pla_c61_tcs  =x_c61_tcs ,
                    pla_c62_tcs  =x_c62_tcs ,
                    pla_c71_tcs  =x_c71_tcs ,
                    pla_c72_tcs  =x_c72_tcs ,
                    pla_c73_tcs  =x_c73_tcs ,
                    pla_c74_tcs  =x_c74_tcs ,
                    pla_c81_tcs  =x_c81_tcs ,
                    pla_c82_tcs  =x_c82_tcs ,
                    pla_c83_tcs  =x_c83_tcs ,
                    pla_c84_tcs  =x_c84_tcs ,
                    pla_c411_tcs =x_c411_tcs,
                    pla_c412_tcs =x_c412_tcs,
                    pla_c413_tcs =x_c413_tcs,
                    pla_c414_tcs =x_c414_tcs,
                    pla_c421_tcs =x_c421_tcs,
                    pla_c422_tcs =x_c422_tcs,
                    pla_c423_tcs =x_c423_tcs,
                    pla_c431_tcs =x_c431_tcs,
                    pla_c432_tcs =x_c432_tcs,
                    pla_c433_tcs =x_c433_tcs,
                    pla_c441_tcs =x_c441_tcs,
                    pla_c442_tcs =x_c442_tcs,
                    pla_c443_tcs =x_c443_tcs,
                    pla_c911_tcs =x_c911_tcs,
                    pla_c912_tcs =x_c912_tcs,
                    pla_c914_tcs =x_c914_tcs,
                    pla_c921_tcs =x_c921_tcs,
                    pla_c922_tcs =x_c922_tcs,
                    pla_c999_tcs =x_c999_tcs,
                                          
                    pla_c1_tss   =x_c1_tss  ,
                    pla_c2_tss   =x_c2_tss  ,
                    pla_c13_tss  =x_c13_tss ,
                    pla_c14_tss  =x_c14_tss ,
                    pla_c31_tss  =x_c31_tss ,
                    pla_c32_tss  =x_c32_tss ,
                    pla_c33_tss  =x_c33_tss ,
                    pla_c34_tss  =x_c34_tss ,
                    pla_c35_tss  =x_c35_tss ,
                    pla_c36_tss  =x_c36_tss ,
                    pla_c37_tss  =x_c37_tss ,
                    pla_c51_tss  =x_c51_tss ,
                    pla_c54_tss  =x_c54_tss ,
                    pla_c61_tss  =x_c61_tss ,
                    pla_c62_tss  =x_c62_tss ,
                    pla_c71_tss  =x_c71_tss ,
                    pla_c72_tss  =x_c72_tss ,
                    pla_c73_tss  =x_c73_tss ,
                    pla_c74_tss  =x_c74_tss ,
                    pla_c81_tss  =x_c81_tss ,
                    pla_c82_tss  =x_c82_tss ,
                    pla_c83_tss  =x_c83_tss ,
                    pla_c84_tss  =x_c84_tss ,
                    pla_c411_tss =x_c411_tss,
                    pla_c412_tss =x_c412_tss,
                    pla_c413_tss =x_c413_tss,
                    pla_c414_tss =x_c414_tss,
                    pla_c421_tss =x_c421_tss,
                    pla_c422_tss =x_c422_tss,
                    pla_c423_tss =x_c423_tss,
                    pla_c431_tss =x_c431_tss,
                    pla_c432_tss =x_c432_tss,
                    pla_c433_tss =x_c433_tss,
                    pla_c441_tss =x_c441_tss,
                    pla_c442_tss =x_c442_tss,
                    pla_c443_tss =x_c443_tss,
                    pla_c911_tss =x_c911_tss,
                    pla_c912_tss =x_c912_tss,
                    pla_c914_tss =x_c914_tss,
                    pla_c921_tss =x_c921_tss,
                    pla_c922_tss =x_c922_tss,
                    pla_c999_tss =x_c999_tss
            where pla_enc=new.pla_enc and pla_hog=new.pla_hog and pla_mie=new.pla_mie;
       end if;
       RETURN new;
    END
  $BODY$
  LANGUAGE plpgsql ;
ALTER FUNCTION encu.recalcular_tiempos_actividades_i1_trg()
  OWNER TO tedede_php;

--DROP TRIGGER recalcular_tiempos_actividades_i1_trg ON encu.plana_i1_;
  
CREATE TRIGGER recalcular_tiempos_actividades_i1_trg
  AFTER UPDATE
  ON encu.plana_i1_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.recalcular_tiempos_actividades_i1_trg();

-- para actualizar variables de actividades inicialmente 
update encu.plana_i1_
set pla_observ= pla_Observ;

select count(*)
from encu.plana_i1_

-- revision
select i.pla_enc, i.pla_hog, i.pla_mie, a.pla_codigo,i.pla_c911_tcs,i.pla_c911_tss, sum(a.pla_t_con_simu_min) s_t_con_simu_min , sum(a.pla_t_sin_simu_min) s_t_sin_simu_min 
from encu.plana_i1_ i join encu.diario_actividades_ajustado_vw  a on a.pla_enc=i.pla_enc and a.pla_hog=i.pla_hog and a.pla_mie=i.pla_mie
where a.pla_codigo=911
group by i.pla_enc, i.pla_hog, i.pla_mie, a.pla_codigo,i.pla_c911_tss,i.pla_c911_tcs
having  i.pla_c911_tss is not distinct from sum(a.pla_t_sin_simu_min) and  i.pla_c911_tcs is not distinct from sum(a.pla_t_con_simu_min)
--having i.pla_c911_tss is distinct from sum(a.pla_t_sin_simu_min) or i.pla_c911_tcs is distinct from sum(a.pla_t_con_simu_min)

select pla_enc, pla_hog, pla_mie, pla_codigo
from encu.diario_actividades_ajustado_vw
where pla_codigo=911
group by  pla_enc, pla_hog, pla_mie, pla_codigo

-- revision modificacion agrupados
select pla_c82_tcs, pla_c82_tss, dbo.lee_tiempo_ajustado(pla_enc,pla_hog,pla_mie, 82, 'pla_t_con_simu_min'), pla_modulo_1
        ,dbo.lee_tiempo_ajustado(pla_enc,pla_hog,pla_mie, 82, 'pla_t_sin_simu_min')
 from encu.plana_i1_
where pla_enc=108107  
160;125;160;125

set search_path=encu, dbo, public, comun,public;

update respuestas
set res_valor=
'[{"desde":"00:00","hasta":"01:30","codigo":"82","detalle":null},{"desde":"01:30","hasta":"07:00","codigo":"922","detalle":null},{"desde":"07:00","hasta":"07:15","codigo":"911","detalle":null},{"desde":"07:15","hasta":"07:20","codigo":"31","detalle":null},{"desde":"07:20","hasta":"09:30","codigo":"411","detalle":null},{"desde":"07:20","hasta":"07:50","codigo":"71","detalle":null},{"desde":"07:20","hasta":"07:50","codigo":"921","detalle":null},{"desde":"07:50","hasta":"08:20","codigo":"32","detalle":null},{"desde":"09:30","hasta":"09:45","codigo":"14","detalle":null},{"desde":"09:45","hasta":"13:00","codigo":"1","detalle":null},{"desde":"13:00","hasta":"13:15","codigo":"36","detalle":null},{"desde":"13:15","hasta":"14:30","codigo":"71","detalle":null},{"desde":"13:15","hasta":"14:30","codigo":"921","detalle":null},{"desde":"14:30","hasta":"17:30","codigo":"1","detalle":null},{"desde":"17:30","hasta":"18:00","codigo":"71","detalle":null},{"desde":"17:30","hasta":"18:00","codigo":"921","detalle":null},{"desde":"18:00","hasta":"20:00","codigo":"1","detalle":null},{"desde":"20:00","hasta":"20:20","codigo":"14","detalle":null},{"desde":"20:20","hasta":"20:45","codigo":"71","detalle":null},{"desde":"20:45","hasta":"20:50","codigo":"911","detalle":null},{"desde":"20:50","hasta":"23:40","codigo":"411","detalle":null},{"desde":"20:50","hasta":"22:00","codigo":"71","detalle":null},{"desde":"21:30","hasta":"22:00","codigo":"921","detalle":null},{"desde":"22:00","hasta":"22:20","codigo":"31","detalle":null},{"desde":"23:40","hasta":"24:00","codigo":"73","detalle":null}]' --90
--'[{"desde":"00:00","hasta":"01:30","codigo":"82","detalle":null},{"desde":"01:30","hasta":"07:00","codigo":"922","detalle":null},{"desde":"07:00","hasta":"07:15","codigo":"911","detalle":null},{"desde":"07:15","hasta":"07:20","codigo":"31","detalle":null},{"desde":"07:20","hasta":"09:30","codigo":"411","detalle":null},{"desde":"07:20","hasta":"07:50","codigo":"71","detalle":null},{"desde":"07:20","hasta":"07:50","codigo":"921","detalle":null},{"desde":"07:50","hasta":"08:20","codigo":"32","detalle":null},{"desde":"09:30","hasta":"09:45","codigo":"14","detalle":null},{"desde":"09:45","hasta":"13:00","codigo":"1","detalle":null},{"desde":"13:00","hasta":"13:15","codigo":"36","detalle":null},{"desde":"13:15","hasta":"14:30","codigo":"71","detalle":null},{"desde":"13:15","hasta":"14:30","codigo":"921","detalle":null},{"desde":"14:30","hasta":"17:30","codigo":"1","detalle":null},{"desde":"17:30","hasta":"18:00","codigo":"71","detalle":null},{"desde":"17:30","hasta":"18:00","codigo":"921","detalle":null},{"desde":"18:00","hasta":"20:00","codigo":"1","detalle":null},{"desde":"20:00","hasta":"20:20","codigo":"14","detalle":null},{"desde":"20:20","hasta":"20:45","codigo":"71","detalle":null},{"desde":"20:45","hasta":"20:50","codigo":"911","detalle":null},{"desde":"20:50","hasta":"23:40","codigo":"411","detalle":null},{"desde":"20:50","hasta":"22:00","codigo":"71","detalle":null},{"desde":"21:30","hasta":"22:00","codigo":"921","detalle":null},{"desde":"22:00","hasta":"22:20","codigo":"31","detalle":null},{"desde":"22:20","hasta":"23:30","codigo":"82","detalle":null},{"desde":"23:40","hasta":"24:00","codigo":"73","detalle":null}]' --160
where res_enc=108107 and res_for='I1' and res_mat='' and res_var='modulo_1';
