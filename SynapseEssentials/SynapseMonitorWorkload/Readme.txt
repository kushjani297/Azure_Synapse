*************************************************************************
**********   Simulating workload for Synapse Adv Monitoring   ***********
**********                   V1.0  04/2022                    ***********
*************************************************************************

Pre-requisites:
Before you start, please make sure you have provisioned the followings:
1. Synapse workspace
2. A dedicated SQL Pool
3. Make sure the Dedicated SQL Pool is started/resumed

To Start workload simulation:
1. copy all files/subfolders to your local folder
2. open the command prompt
3. change directory to this folder
4. enter workload.cmd to start - 
	a. you will be prompted to enter the Synapse Workspace name you would like to connect
	b. you will be prompted to enter the Dedicated SQL Pool database name you would like to use
	c. you will be prompted to enter the SQL Login name for the dedicated SQL Pool (SQL Admin User is preferred since setup needs permissions)
	d. you will be prompted to enter the password for the SQL Login

If you see any "failed to connect" error message, please check if you entered the correct information (workspace, databasename, user and password).
you can always use Ctrl+C to exit and re-run the steps.
