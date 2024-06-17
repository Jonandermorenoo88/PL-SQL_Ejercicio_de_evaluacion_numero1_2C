drop table modelos cascade constraints;
drop table autocares cascade constraints;
drop table recorridos cascade constraints;
drop table viajes cascade constraints;
drop table tickets cascade constraints;
drop table revisionesModelo cascade constraints;
drop table revisionesAutocar cascade constraints;
drop table conductores cascade constraints;

create table modelos(
 idModelo integer primary key,
 nplazas integer
);

create table revisionesModelo(
 idRevisionM	integer primary key,
 km		        integer not null,
 descripcion  varchar(20),
 idModelo	    integer not null references modelos
 );

create table conductores(
 idConductor integer primary key,
 nombre      	char(20));

create table autocares(
  idAutocar   integer primary key,
  modelo      integer references modelos,
  kms         integer not null,
  idProximaRevision  	integer references revisionesModelo
);

create table recorridos(
   idRecorrido      integer primary key,
   estacionOrigen   varchar(15) not null,
   estacionDestino  varchar(15) not null,
   kms              numeric(6,2) not null,
   horaSalida       timestamp,          --Oracle no tiene time 
   horaLlegada      timestamp not null, --Oracle no tiene time   
   precio           numeric(5,2) not null,
   unique ( estacionOrigen, estacionDestino, horaSalida )   
);

create table viajes(
 idViaje     	integer primary key,
 idAutocar   	integer references autocares  not null,
 idRecorrido 	integer references recorridos not null,
 fecha 		    date not null,
 nPlazasLibres	integer not null,
 --realizado      boolean default false not null,
 realizado      smallint default 0 not null check(realizado in (0,1)),
 idConductor    integer not null references conductores,
 unique (idRecorrido, fecha) 
);

create table tickets(
 idTicket 	integer primary key,
 idViaje  	integer references viajes not null,
 fechaCompra    date not null,
 cantidad       integer not null,
 precio		numeric(5,2) not null
);
drop sequence seq_tickets;
create sequence seq_tickets;

create table revisionesAutocar(
 idRevisionA    integer  primary key,
 idRevisionM    integer not null references revisionesModelo,
 idAutocar	    integer not null references autocares,
 fecha		      date    not null,
 kms		        integer not null,
 UNIQUE ( idRevisionM, idAutocar)
); 

------------------------------------------------
--                                            nPlazas	idModelo 
insert into modelos (idModelo, nPlazas) values ( 1,     40 );  
insert into modelos (idModelo, nPlazas) values ( 2,     15 );  
insert into modelos (idModelo, nPlazas) values ( 3,     35 );  

insert into revisionesModelo ( idRevisionM, km,    descripcion,     idModelo ) 
		     values                 ( 1,        5000,  'Frenos',  	           1);
insert into revisionesModelo ( idRevisionM, km,    descripcion,     idModelo ) 
		     values                 ( 2,        10000, 'Frenos y filtros',     1);	
insert into revisionesModelo ( idRevisionM, km,    descripcion,     idModelo )                 
		     values                 ( 3,        5000,  'Frenos y filtros',     2);	
insert into revisionesModelo ( idRevisionM, km,    descripcion,     idModelo )                 
		     values                 ( 4,        5000,  'Frenos y filtros',     3);	

insert into autocares ( idAutocar, modelo, 	kms,	idProximaRevision) values
                          (	1,          1,	  1000, 		1); 		
insert into autocares ( idAutocar, modelo, 	kms,	idProximaRevision) values
                          (	2,          1,	7500,		    2);
insert into autocares ( idAutocar, modelo, 	kms,	idProximaRevision) values          
                          (	3,          2,	2000,		    2);
insert into autocares ( idAutocar, modelo, 	kms,	idProximaRevision) values          
                          ( 4,          2,  1000,       2);
insert into autocares ( idAutocar, modelo, 	kms,	idProximaRevision) values          
                          ( 5,          3,  1000,       4);     

insert into revisionesAutocar ( idRevisionA, idRevisionM, idAutocar, fecha,	            kms ) 
                        values ( 1,             1,		      2,      trunc(current_date)-365, 	5500);   

                                                   --
insert into conductores( idConductor, nombre ) values (1, 'Pepe');
insert into conductores( idConductor, nombre ) values (2, 'Juan');
insert into conductores( idConductor, nombre ) values (3, 'Ana');

insert into recorridos 
(idRecorrido, estacionOrigen,	estacionDestino,kms, 	horaSalida, 	horaLlegada, precio) 
values 
( 1, 'Burgos',	   'Madrid',	      201,	'1/1/1 8:30',	'1/1/1 10:30',	10 );
insert into recorridos 
(idRecorrido, estacionOrigen,	estacionDestino,kms, 	horaSalida, 	horaLlegada, precio) 
values 
( 2, 'Burgos',	    'Madrid',	      200,	'1/1/1 16:30', '1/1/1 18:30',	12 );

insert into recorridos 
(idRecorrido, estacionOrigen,	estacionDestino,kms, 	horaSalida, 	horaLlegada, precio) 
values 
( 3,  'Madrid',	  'Burgos',	        200,	'1/1/1 13:30',	'1/1/1 15:30',	10 );

insert into recorridos 
(idRecorrido, estacionOrigen,	estacionDestino,kms, 	horaSalida, 	horaLlegada, precio) 
values 
( 4, 'Leon',       'Zamora',       150,    '1/1/1 8:00',  '1/1/1 9:30',    6  );  

insert into viajes
(idViaje, idAutocar,	idRecorrido,	fecha,		nPlazasLibres, realizado, idConductor)
values
(	1,        1,		      1,	    DATE '2009-1-22', 30,           1,        1);

insert into viajes
(idViaje, idAutocar,	idRecorrido,	fecha,		nPlazasLibres, realizado, idConductor)
values
(	2,        1,		      1,	    trunc(current_date)+1,   38,           0,        2);

insert into viajes
(idViaje, idAutocar,	idRecorrido,	fecha,		nPlazasLibres, realizado, idConductor)
values
( 3,      1,              1,    trunc(current_date)+7,   10,         0,        3);

insert into viajes
(idViaje, idAutocar,	idRecorrido,	fecha,		nPlazasLibres, realizado, idConductor)
values
( 4,      2,              4,	  trunc(current_date)+7,   40,         0,       1);
	        
		
insert into tickets (	idTicket, idViaje, fechaCompra,	cantidad, precio)  
                  values(	seq_tickets.nextval,        1,	trunc(current_date)-3,	  1,	      10);
insert into tickets (	idTicket, idViaje, fechaCompra,	cantidad, precio)                    
                  values( seq_tickets.nextval,        2,  trunc(current_date)-1, 2,        10);	    
                  
commit;
--exit;

create or replace procedure comprarBillete( arg_hora recorridos.horaSalida%type,
          arg_fecha viajes.fecha%type, arg_origen recorridos.estacionorigen%type,
          arg_destino recorridos.estaciondestino%type, arg_nroPlazas viajes.nplazaslibres%type
) is 

begin

  null;
  
end;
/
		       
create or replace procedure test_comprarBillete is
begin
     -- 1 Comprar un billete para un viaje inexistente
     begin
       comprarBillete( '1/1/1 12:00:00', '15/04/2010', 'Burgos', 'Madrid', 3);
      end;
      
     -- 2 Comprar un billete de 50 plazas en un vieje que no tiene tantas plazas libres
     begin
       comprarBillete( '1/1/1 8:30:00', '22/01/2009', 'Burgos', 'Madrid', 50);
     end;
      
      -- 3 Hacemos una compra de un billete de 5 plazas sin problemas
      declare
        varContenidoReal varchar(100);
        varContenidoEsperado    varchar(100):=   'Dummy data';
      begin
        comprarBillete( '1/1/1 8:30:00', '22/01/2009', 'Burgos', 'Madrid', 5);
      end;
end;
/


set serveroutput on
begin
  test_comprarBillete;
end;