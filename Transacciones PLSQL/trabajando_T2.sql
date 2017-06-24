-- Jonathan Carrero

/*
  SET AUTOCOMMIT OFF;
  SET SERVEROUTPUT ON SIZE 100000;
  -- Secuencia 2 para transacci�n 2
  CREATE SEQUENCE sec_T2 MINVALUE 0 MAXVALUE 1  START WITH 0 INCREMENT BY 1 cycle nocache;
  SELECT sec_T2.NEXTVAL FROM dual;
  -- Probar trabajando_T2
  BEGIN
    trabajando_T2(5);
  END;
*/

CREATE OR REPLACE PROCEDURE trabajando_T2(segundos NUMBER)
  AS
    -- Almacenar� el id de la transacci�n
    id_transaccion CHAR(24);
    -- Ir� almacenando el valor anterior al valor actual de la secuencia (como al principio no hay valor anterior, se inicializa a -1)
    sec_anterior NUMBER := -1;
    -- Ir� almacenando el valor actual de la secuencia
    sec_actual NUMBER;
BEGIN
  LOOP
    -- Seleccionamos el valor actual de la sec_T2
    SELECT sec_T2.NEXTVAL INTO sec_actual FROM dual;
    -- Si coincide con el valor actual, entonces es que "alguien" lo ha modificado
    IF sec_anterior = sec_actual THEN 
      EXIT;
    ELSE
      -- Si no coincide, actualizamos la secuencia anterior
      sec_anterior := sec_actual;
      -- Y le decimos a la transacci�n que se duerma
      sys.dbms_lock.sleep(segundos);
    END IF;
  END LOOP;
  -- Si hemos salido del bucle, notificamos qu� transacci�n ha dejado de trabajar
  SELECT dbms_transaction.local_transaction_id INTO id_transaccion FROM dual;
  dbms_output.put_line('He terminado de trabajar ' || id_transaccion);
END trabajando_T2;

/

show errors
