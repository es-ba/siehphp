alter table encu.plana_tem_ add constraint "error interno tem.pla_hog!=0" check (pla_hog=0);
alter table encu.plana_tem_ add constraint "error interno tem.pla_mie!=0" check (pla_mie=0);
alter table encu.plana_tem_ add constraint "error interno tem.pla_exm!=0" check (pla_exm=0);
alter table encu.plana_sm1_ add constraint "error interno sm1.pla_mie!=0" check (pla_mie=0);
alter table encu.plana_sm1_ add constraint "error interno sm1.pla_exm!=0" check (pla_exm=0);
alter table encu.plana_sm1_p add constraint "error interno sm1_p.pla_exm!=0" check (pla_exm=0);
alter table encu.plana_smi1_ add constraint "error interno smi1.pla_exm!=0" check (pla_exm=0);