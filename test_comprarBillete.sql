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
end test_comprarBillete;