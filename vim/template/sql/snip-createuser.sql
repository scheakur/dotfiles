create user foobar identified by foobar
default tablespace users
temporary tablespace temp;

grant connect, resource to foobar;
grant create view to foobar;
grant create job to foobar;
grant ctxapp to foobar;
grant execute on dbms_crypto to foobar;
grant unlimited tablespace to foobar;

commit;
