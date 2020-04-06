CREATE OR REPLACE FUNCTION encu.actualizar_i1_trg()
  RETURNS trigger AS
$BODY$
BEGIN
     CASE TG_OP
            WHEN 'INSERT' THEN
                insert into encu.plana_i1_(pla_enc, pla_hog, pla_mie, pla_exm, pla_tlg) values (new.pla_enc, new.pla_hog, new.pla_mie, new.pla_exm, 1);
                RETURN NEW;
            WHEN 'DELETE' THEN 
                delete from encu.plana_i1_ where pla_enc=old.pla_enc and pla_hog=old.pla_hog and pla_mie=old.pla_mie and pla_exm=old.pla_exm;
                RETURN OLD;
            WHEN 'UPDATE' THEN 
                if new.pla_enc is distinct from old.pla_enc or new.pla_hog is distinct from old.pla_hog or new.pla_mie is distinct from old.pla_mie or new.pla_exm is distinct from old.pla_exm then
                   update encu.plana_i1_ set pla_enc=new.pla_enc,pla_hog=old.pla_hog, pla_mie=new.pla_mie, pla_exm=new.pla_exm
                     where pla_enc=old.pla_enc and pla_hog=old.pla_hog and pla_mie=old.pla_mie and pla_exm=old.pla_exm;
                end if;
                RETURN NEW;    
            ELSE
                RETURN NULL;                
    END CASE;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION encu.actualizar_i1_trg()
  OWNER TO tedede_php;

-- DROP TRIGGER actualizar_i1_trg ON encu.plana_s1_p;

CREATE TRIGGER actualizar_i1_trg
  AFTER INSERT OR UPDATE OR DELETE
  ON encu.plana_s1_p
  FOR EACH ROW
  EXECUTE PROCEDURE encu.actualizar_i1_trg();