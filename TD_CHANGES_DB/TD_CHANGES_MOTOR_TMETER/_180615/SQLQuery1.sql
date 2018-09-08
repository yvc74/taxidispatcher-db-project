USE [TD5R1]
GO

/****** Object:  Table [dbo].[DEVICE_CODES]    Script Date: 06/18/2015 14:57:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DEVICE_CODES](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [varchar](50) NOT NULL,
	[device_num] [int] NOT NULL,
 CONSTRAINT [PK_DEVICE_CODES] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[DEVICE_CODES] ADD  CONSTRAINT [DF_DEVICE_CODES_code]  DEFAULT ('000') FOR [code]
GO

ALTER TABLE [dbo].[DEVICE_CODES] ADD  CONSTRAINT [DF_DEVICE_CODES_device_num]  DEFAULT ((0)) FOR [device_num]
GO

