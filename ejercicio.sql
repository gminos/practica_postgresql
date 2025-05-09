-- Elimino el schema sr1_public solo para hacer pruebas
DROP SCHEMA sr1_public;

-- Se crea un schema
CREATE SCHEMA sr1_public;

-- Se asigna permiso de uso del schema sr1_public al usuario r1_user_schema
GRANT USAGE ON SCHEMA sr1_public TO r1_user_schema;

-- Se crea una tabla en el schema sr1_public
CREATE TABLE sr1_public.tbr1_contacts (
    r1_id SERIAL PRIMARY KEY,
    r1_name VARCHAR(20) NOT NULL,
    r1_phone VARCHAR(10) UNIQUE NOT NULL
);

-- Se otorga permiso de selecion al usuario r1_user_table sobre las tablas del schema sr1_public
GRANT SELECT ON ALL TABLES IN SCHEMA public TO r1_user_table;
-- Ver que tipo de permisos tiene cierto usuario sobre cierta tabla de cierto schema
SELECT
    grantee,
    privilege_type
FROM information_schema.role_table_grants
WHERE
    table_schema = 'sr1_public'
    AND table_name = 'tbr1_contacts'
    AND grantee = 'r1_user_table';
-- Se otorga permiso de insersion al usuaruio r1_user_table sobre las tablas del schema public (por defecto se crean las tablas en este schema)
GRANT INSERT ON ALL TABLES IN SCHEMA sr1_public TO r1_user_table;

-- Quitar permisos de insersion al usuario r1_user_table a la tabla tbr1_contacts
REVOKE INSERT ON tbr1_contacts FROM r1_user_table;

CREATE TABLE IF NOT EXISTS sr1_public.users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(45) NOT NULL
);

-- Revocar permiso de insersion al usuario sobre la tabla del esquema
REVOKE INSERT ON sr1_public.tbr1_contacts FROM r1_user_table;

-- Revocar permiso seleccion al usuario sobre la tabla del esquema
REVOKE SELECT ON sr1_public.users FROM r1_user_table;
--
-- Otorgar permiso insersion al usuario sobre la tabla del esquema
GRANT INSERT ON sr1_public.users TO r1_user_table;
--
-- Otorgar permiso de conexion al usuario sobre la base de datos
GRANT CONNECT ON DATABASE mrlh_contacts TO r1_user_table;
--
-- Revocar permiso de conexion al usuario sobre la base de datos
REVOKE CONNECT ON DATABASE mrlh_contacts FROM r1_user_schema;

-- Revocar permiso a cualquier usuario de conectarse a la base de datos
REVOKE CONNECT ON DATABASE mrlh_contacts FROM PUBLIC;

-- Otargar permiso de uso al usuario sobre el esquema
GRANT USAGE ON SCHEMA sr1_public TO r1_user_table;
-- nota: Un usuario tiene que tener permiso de uso sobre
-- el esquema ya que nada de servira que tenga permisos de select, insert 
-- sobre las tablas de dicho esquema ya que no podra hacer nada sin antes
-- tener permiso de uso sobre el esquema

-- Para ver los permisos otorgados de un usuario a la tablas de un schema
SELECT
    table_name,
    string_agg(privilege_type, ', ' ORDER BY privilege_type) AS permisos
FROM information_schema.role_table_grants
WHERE
    table_schema = 'sr1_public'
    AND grantee = 'r1_user_table'
GROUP BY table_name
ORDER BY table_name;
