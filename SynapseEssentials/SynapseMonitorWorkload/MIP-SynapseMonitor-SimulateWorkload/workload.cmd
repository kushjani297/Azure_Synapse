@ECHO OFF
@ECHO.
@ECHO *************************************************************************
@ECHO **********   Simulating workload for Synapse Adv Monitoring   ***********
@ECHO **********                   V1.0  04/2022                    ***********
@ECHO *************************************************************************
@ECHO.
@ECHO.
@ECHO *************************************************************************
@ECHO **********   You can use Ctrl + C to exit anytime as needed   ***********
@ECHO *************************************************************************
@ECHO.
@ECHO.
SET /p MySynapseWorkspace="Enter the Synapse workspace name (i.e. mySynapaseWS): "
@ECHO The Dedicated SQL Endpoint: "%MySynapseWorkspace%.sql.azuresynapse.net"
@ECHO The Serverless SQL Endpoint: "%MySynapseWorkspace%-ondemand.sql.azuresynapse.net"
@ECHO.
SET /p MySQLPool="Enter the Dedicated SQLPool name (i.e. mySQLPool): "
@ECHO The Dedicated SQL Pool Database: "%MySQLPool%"
@ECHO.
SET /p MySQLAdmin="Enter SQL Admin User (i.e. sqladminuser): "
@ECHO The SQL Admin User: %MySQLAdmin%
@ECHO.

::SET /p MyPassword="Enter the SQL Admin User's Password (i.e. myStr0n9Pa$$): "
set "psCommand=powershell -Command "$pword = read-host 'Enter the SQL Admin User''s Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set MyPassword=%%p
::@ECHO "%MyPassword%"
@ECHO.


@ECHO.
@ECHO ******Setting up the enviornment - create tables, schema, users and populate data******
@ECHO ******This step may take 10-15 minutes on DWU100c******
@ECHO.
:: example: ostress -S"MySynapseWorkspace.sql.azuresynapse.net" -dmySQLPool -UmySQLAmin -PmyStrongP@ssw0rd! -i.\sqlscripts\setup.sql -n1 -r1
ostress -S"%MySynapseWorkspace%.sql.azuresynapse.net" -d"%MySQLPool%" -U%MySQLAdmin% -P%MyPassword% -i.\sqlscripts\setup.sql -n1 -r1
@ECHO.
@ECHO ******Setup completed!******
@ECHO.

@ECHO ******Workload simulation is started******
@ECHO ******The whole workload may run for 4-5 hours on DWU100c******
@ECHO.
@ECHO ******Serverless SQL Pool workload started...******
@ECHO.
:: The process will start 5 connections, iterate each workload script file for 10 times on master database on serverless pool
:: example: ostress -S<Serverless SQL Pool URL> -dmaster -U<SQL Admin User> -P<Password> -i.\sqlscripts\Serverlessworkload*.sql -n5 -r10 -q
ostress -S"%MySynapseWorkspace%-ondemand.sql.azuresynapse.net" -dmaster -U%MySQLAdmin% -P%MyPassword% -i.\sqlscripts\Serverlessworkload*.sql -n5 -r10 -q
@ECHO.

@ECHO ******Dedicated SQL Pool workload started...******
@ECHO.
:: The process will start 5 connections, iterate each workload script file for 3 times on the user database on the dedicated pool
:: example: ostress -S<Dedicated SQL Pool URL> -d<Database Name> -U<SQL Admin User> -P<Password> -i.\sqlscripts\workload*.sql -n5 -r3 -q
ostress -S"%MySynapseWorkspace%.sql.azuresynapse.net" -d"%MySQLPool%" -U%MySQLAdmin% -P%MyPassword% -i.\sqlscripts\workload*.sql -n5 -r3 -q
@ECHO.
@ECHO ******Workload completed!******
@ECHO.

EXIT /B 0
