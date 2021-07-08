use AchitofelProj

CREATE TABLE [dbo].[ClientsTbl]
(
	[ClientID] NCHAR(10) NOT NULL PRIMARY KEY, 
    [ClientName] NVARCHAR(50) NOT NULL, 
    [IsForeign] CHAR(1) NOT NULL DEFAULT 'N'
)

CREATE TABLE [dbo].[ClientsPersonelTbl]
(
    [ClientID] NCHAR(10) NULL, 
    [ManagerFirstName] NCHAR(10) NULL, 
    [ManagerLastName] NCHAR(10) NULL, 
    [Address] NCHAR(10) NULL, 
    [DateOfBirth] NCHAR(10) NULL, 
    [PreferredPresent] NCHAR(10) NULL DEFAULT 'chocolate', 
    [IsBigBossFlag] NCHAR(1) NULL DEFAULT 'N',
     CONSTRAINT [FK_ClientsPersonelTbl_ToTable] FOREIGN KEY ([ClientID]) REFERENCES ClientsTbl([ClientID])    
)

CREATE TABLE [dbo].[ClientsPersonaFamilylTbl]
(
	[ClientID] NCHAR(10) NOT NULL PRIMARY KEY, 
    [FirstName] NVARCHAR(50) NULL, 
    [LastName] NVARCHAR(50) NOT NULL, 
    [FamilyMember] NCHAR(1) NOT NULL DEFAULT 'C', 
    [DateOfBirth] DATETIME2 NOT NULL, 
    [PreferredPresent] NVARCHAR(10) NULL DEFAULT 'Chocolate', 
    [LastTimePresetSentDate] DATETIME2 NULL , 
    CONSTRAINT [FK_ClientsPersonaFamilylTbl_ToTable] FOREIGN KEY (ClientID) REFERENCES [ClientsTbl](ClientID)
)

CREATE TABLE [dbo].[ClientOfficeLocationTbl]
(
	[ClientID] NCHAR(10) NOT NULL PRIMARY KEY, 
    [OfficeAddress] NVARCHAR(50) NULL, 
    [TravelTimeInMinutes] SMALLINT NULL,
    CONSTRAINT [FK_ClientOfficeLocationTbl_ToTable] FOREIGN KEY (ClientID) REFERENCES [ClientsTbl](ClientID)
)

CREATE TABLE [dbo].[EmployeesTbl]
(
	[EmployeeID] NCHAR(10) NOT NULL PRIMARY KEY, 
    [EmployeeFirstName] NVARCHAR(50) NULL, 
    [EmployeeLastName] NVARCHAR(50) NULL, 
    [AddressPrimary] NVARCHAR(50) NULL, 
    [AddressSecondary] NVARCHAR(50) NULL, 
    [MartialStatus] NCHAR(1) NOT NULL DEFAULT 'S', 
    [NoOfChildren] NCHAR(1) NULL, 
    [Gender] NCHAR(1) NULL, 
    [IRSPoints] INT NULL, 
    [ReportsTo ] NCHAR(10) NULL, 
    [EmploymentStartDate] DATETIME2 NOT NULL, 
    [EmploymentEndDate] DATETIME2 NULL, 
    CONSTRAINT [FK_EmployeesTbl_EmployeesTbl] FOREIGN KEY ([EmployeeID]) REFERENCES [EmployeesTbl]([EmployeeID])
)


CREATE TABLE [dbo].[EmpFamilyTbl]
(
	[Id] NCHAR(10) NOT NULL PRIMARY KEY, 
    [FirstName] NVARCHAR(50) NOT NULL, 
    [LastName] NVARCHAR(50) NOT NULL, 
    [RelatedTo] NCHAR(10) NOT NULL, 
    [DateOfBirth] DATETIME2 NULL, 
    [Address] NVARCHAR(50) NOT NULL, 
    [Gender] NCHAR(1) NULL, 
    [FamilyMember] NCHAR(1) NULL DEFAULT 'C', 
    CONSTRAINT [FK_EmpFamilyTbl_EmployeesTbl] FOREIGN KEY (RelatedTo) REFERENCES [EmployeesTbl](EmployeeID), 
    CONSTRAINT [CK_EmpFamilyTbl_Column] CHECK (1 = 1)--valid values for family member are 'C'(hild) or 'S'(pouse))
)


CREATE TABLE [dbo].[TeamsTbl]
(
	[TeamID] NCHAR(10) NOT NULL PRIMARY KEY, 
    [EmployeeID] NCHAR(10) NOT NULL, 
    [ClientID] NCHAR(10) NOT NULL, 
    [OfficeID] NCHAR(10) NOT NULL, 
    [TeamName] NVARCHAR(50) NOT NULL, 
    [EmployeeTeamLeader] NCHAR(10) NULL, 
    [StartDate] DATETIME2 NULL, 
    [EndDate] DATETIME2 NULL, 
    CONSTRAINT [FK_TeamsTbl_EmployeesTbl] FOREIGN KEY ([EmployeeID]) REFERENCES [EmployeesTbl](EmployeeID), 
    CONSTRAINT [FK_TeamLeaderTbl_EmployeesTbl] FOREIGN KEY (EmployeeTeamLeader ) REFERENCES [EmployeesTbl](EmployeeID),
	CONSTRAINT [FK_TeamsTbl_ClientsTbl] FOREIGN KEY (ClientID) REFERENCES [ClientsTbl](ClientID)
)

CREATE TABLE [dbo].[ProjectsTbl]
(
	[ProjectID] NCHAR(10) NOT NULL PRIMARY KEY, 
    [ProjectName] NVARCHAR(50) NOT NULL, 
    [HourlyPrice] INT NOT NULL, 
    [ClientID] NCHAR(10) NOT NULL, 
        CONSTRAINT [FK_ProjectsTbl_ClientsTbl] FOREIGN KEY (ClientID) REFERENCES [ClientsTbl](ClientID)
 )


 CREATE TABLE [dbo].[ClientsDailyChargingTbl]
(
	[ClientID] NCHAR(10) NOT NULL, 
    [ProjectID] NCHAR(10) NOT NULL, 
    [EmployeeID] NCHAR(10) NOT NULL, 
    [Start] DATETIME2 NOT NULL, 
    [End] DATETIME2 NOT NULL, 
    [TravelTime InMinutes] INT NOT NULL, 
    [Currency ] NCHAR(3) NOT NULL DEFAULT 'ILS', 
    CONSTRAINT [FK_ClientsDailyChargingTbl_ClientsTbl] FOREIGN KEY (ClientID) REFERENCES [ClientsTbl](ClientID), 
    CONSTRAINT [FK_ClientsDailyChargingTbl_ProjectsTbl] FOREIGN KEY ([ProjectID]) REFERENCES [ProjectsTbl](ProjectID), 
    CONSTRAINT [FK_ClientsDailyChargingTbl_EmployeesTbl] FOREIGN KEY ([EmployeeID]) REFERENCES [EmployeesTbl](EmployeeID), 
    CONSTRAINT [CK_ClientsDailyChargingTbl_Duplicates] CHECK (1 = 1), -- make sure there are no duplicates reports on behalf of the employee
    CONSTRAINT [CK_ClientsDailyChargingTbl_VerifyTeamMember] CHECK (1 = 1) -- make sure the employee is in the projects team member
   )


 CREATE TABLE [dbo].[BlackListTbl]
(
	[ClientID] NCHAR(10) NOT NULL, 
    [StartDate] DATETIME2 NOT NULL, 
    [EndDate] DATETIME2 NOT NULL, 
    [ProjectID] NCHAR(10) NOT NULL, 
    CONSTRAINT [FK_BlackListTbl_ClientsTbl] FOREIGN KEY (ClientID) REFERENCES [ClientsTbl](ClientID) ,
    CONSTRAINT [FK_BlackListTbl_ProjectsTbl] FOREIGN KEY ([ProjectID]) REFERENCES [ProjectsTbl](ProjectID)
)


CREATE TABLE [dbo].[EmployeeSalaryTbl]
(
	[EmployeeID] NCHAR(10) NOT NULL PRIMARY KEY, 
    [SalaryAmount] FLOAT NOT NULL, 
    [SalaryLastUpdatedDate] DATETIME2 NOT NULL, 
    [Bonus] FLOAT NULL, 
    [BonusLastGivenDate] DATETIME2 NULL, 
    [SocialBEnefitsPercentage] INT NOT NULL, 
    [ManagementBenefits] INT NULL, 
    CONSTRAINT [FK_EmployeeSalaryTbl_EmployeesTbl] FOREIGN KEY ([EmployeeID]) REFERENCES [EmployeesTbl](EmployeeID)
  )


CREATE TABLE [dbo].[CurrencyExchangeTbl]
(
	[CurrecnyName ] NVARCHAR(50) NOT NULL PRIMARY KEY, 
    [StartDate] DATETIME2 NOT NULL, 
    [EndDate] DATETIME2 NOT NULL, 
    [ILSval] NCHAR(10) NOT NULL
)

CREATE TABLE [dbo].[InquiryTalkTbl]
(
	[EmployeeID] NCHAR(10) NOT NULL PRIMARY KEY, 
    [DateOfInquiry] DATETIME2 NOT NULL, 
    [ConductedBy ] NCHAR(10) NOT NULL, 
    [Result] NVARCHAR(50) NOT NULL, 
    CONSTRAINT [FK_InquiryTalkTbl_EmployeesTbl] FOREIGN KEY ([EmployeeID]) REFERENCES [EmployeesTbl](EmployeeID),
    CONSTRAINT [FK_InquiryConductedTalkTbl_EmployeesTbl] FOREIGN KEY ([EmployeeID]) REFERENCES [EmployeesTbl](EmployeeID)
)
