--Type in the below statement to create a new server login 
--by executing below statement in query window.
CREATE LOGIN DWLoader WITH PASSWORD = 'Str0ng_password';
CREATE LOGIN dwloaderrc10 WITH PASSWORD = 'Str0ng_password';

--Type in the below statement to create a user 
--in the master database for the login created above.
CREATE USER DWLoader FOR LOGIN DWLoader;
CREATE USER dwloaderrc10 FOR LOGIN dwloaderrc10;

--To create user in Synapse SQL using login 
--created in earlier steps, execute below statement.
CREATE USER DWLoader FOR LOGIN DWLoader;
CREATE USER dwloaderrc10 FOR LOGIN dwloaderrc10;



