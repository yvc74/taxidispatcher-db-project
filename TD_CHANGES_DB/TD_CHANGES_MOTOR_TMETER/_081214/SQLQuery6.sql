USE [TD5R1]
GO
/****** Object:  UserDefinedFunction [dbo].[GetOrderINumComment]    Script Date: 12/08/2014 16:29:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER FUNCTION [dbo].[GetOrderINumComment]  ( @inum varchar(255))
RETURNS varchar(255)
AS
BEGIN
   declare @res varchar(255), @pres1 int, @pres2 int, @pres3 int
   
   select @pres1=Prizovoe_kolichestvo_1 from Objekt_vyborki_otchyotnosti where
    Tip_objekta='for_drivers' 
  
  if @pres1>0 begin
  select @res=('Абонент: '+Familiya+' '+Imya+' '+Otchestvo+
  ', приз. накопл. -'+CAST((dom%@pres1) as VARCHAR)+', '+
   'рез.-'+CAST(RESERVED_PRESENTS as VARCHAR)+'.')  
   from Persona where 
     CAST(korpus as varchar(255))=@inum  
  end
 else
  begin
    select @res=('Абонент: '+Familiya+' '+Imya+' '+Otchestvo+
    ', выз. всего-'+CAST(dom as VARCHAR)+', '+
    'рез.-'+CAST(RESERVED_PRESENTS as VARCHAR)+'.')  
   from Persona where 
     CAST(korpus as varchar(255))=@inum
  end

   if @res=NULL begin
       SET @res='Нет данных по абонентскому номеру '
   end  

   RETURN(@res)
END