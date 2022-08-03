/*
Cleanup script - Assuming you have Synapse dedicated sql pool provisioned 
*/
print 'UTC: ' + cast(getdate() as varchar(30))
print '---------Cleaning up all schema, users and tables created by the workload simulator...-----------'

IF OBJECT_ID(N'[synmon].[Date]') IS NOT NULL DROP TABLE [synmon].[Date];
IF OBJECT_ID(N'[synmon].[Geography]') IS NOT NULL DROP TABLE [synmon].[Geography];
IF OBJECT_ID(N'[synmon].[HackneyLicense]') IS NOT NULL DROP TABLE [synmon].[HackneyLicense];
IF OBJECT_ID(N'[synmon].[Medallion]') IS NOT NULL DROP TABLE [synmon].[Medallion];
IF OBJECT_ID(N'[synmon].[Time]') IS NOT NULL DROP TABLE [synmon].[Time];
IF OBJECT_ID(N'[synmon].[Trip]') IS NOT NULL DROP TABLE [synmon].[Trip];
IF OBJECT_ID(N'[synmon].[Weather]') IS NOT NULL DROP TABLE [synmon].[Weather];
IF OBJECT_ID(N'synmon.dimDate_RR') IS NOT NULL DROP TABLE [synmon].[dimDate_RR];
IF OBJECT_ID(N'synmon.dimDate_RPL') IS NOT NULL DROP TABLE [synmon].[dimDate_RPL];
IF OBJECT_ID(N'synmon.fctTrip') IS NOT NULL DROP TABLE [synmon].[fctTrip];
IF OBJECT_ID(N'synmon.fctTrip_RR') IS NOT NULL DROP TABLE [synmon].[fctTrip_RR];
IF OBJECT_ID(N'synmon.fctTrip_HackneyLicenseID') IS NOT NULL DROP TABLE [synmon].[fctTrip_HackneyLicenseID];
IF OBJECT_ID(N'synmon.fctTrip_MedallionID') IS NOT NULL DROP TABLE [synmon].[fctTrip_MedallionID];
IF OBJECT_ID(N'synmon.fctTrip_MedallionID_BIGINT') IS NOT NULL DROP TABLE [synmon].[fctTrip_MedallionID_BIGINT];
IF EXISTS(SELECT * FROM sys.schemas WHERE NAME = 'synmon')
    DROP SCHEMA synmon;
IF EXISTS(SELECT * FROM sys.schemas WHERE NAME = 'synmonext')
    DROP SCHEMA synmonext;
GO
IF EXISTS(SELECT * FROM sys.database_principals WHERE NAME = 'synmonNormalUser')
    DROP USER synmonNormalUser;
IF EXISTS(SELECT * FROM sys.database_principals WHERE NAME = 'synmonProcessUser')
    DROP USER synmonProcessUser;
IF EXISTS(SELECT * FROM sys.database_principals WHERE NAME = 'synmonReportUser')
    DROP USER synmonReportUser;
GO
--create a workload group, classifier for Report Users
IF EXISTS (SELECT 1 FROM sys.workload_management_workload_classifiers WHERE name = 'synmonWLCReportUser')
    DROP WORKLOAD CLASSIFIER synmonWLCReportUser;
IF EXISTS (SELECT 1 FROM sys.workload_management_workload_groups WHERE name = 'synmonWGReportUser')
    DROP WORKLOAD GROUP synmonWGReportUser;
print 'UTC: ' + cast(getdate() as varchar(30))
print '------------------------Cleanup completed---------------------------'