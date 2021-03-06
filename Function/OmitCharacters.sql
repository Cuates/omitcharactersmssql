-- Database Connect
use [databasename]
go

-- Set ansi nulls
set ansi_nulls on
go

-- Set quoted identifier
set quoted_identifier on
go

-- Function Drop
drop function if exists dbo.OmitCharacters
go

-- ===========================
--       File: OmitCharacters
--    Created: 07/22/2020
--    Updated: 10/01/2020
-- Programmer: Cuates
--  Update By: Cuates
--    Purpose: Omit characters
-- ===========================

-- Function Create
create function [dbo].[OmitCharacters]
(
  -- Parameters
  @inputString nvarchar(max),
  @characterInputString nvarchar(max)
)
returns nvarchar(max)
as
begin
  -- Declare variables
  declare @inputStringLength int
  declare @curPos int
  declare @stringResult nvarchar(max)
  declare @delimiterCharacter nvarchar(1)

  -- Declare temporary table
  declare @inputStringTemp table
  (
    istID int identity (1, 1) primary key,
    inputAsciiCharacter nvarchar(1) null,
    inputUnicodeCharacter int null
  )

  -- Declare temporary table
  declare @characterStringTemp table
  (
    cstID int identity (1, 1) primary key,
    asciiCharacter nvarchar(1) null,
    unicodeCharacter int null
  )

  -- Set variables
  set @delimiterCharacter = N','
  set @inputStringLength = len(@inputString)
  set @curPos = 1
  set @stringResult = ''

  -- Check if parameter is empty string
  if @inputString = ''
    begin
      -- Set variable to null if empty string
      set @inputString = nullif(@inputString, '')
    end

  -- Check if parameter is empty string
  if @characterInputString = ''
    begin
      -- Set variable to null if empty string
      set @characterInputString = nullif(@characterInputString, '')
    end

  -- Check if parameters are null
  if @inputString is not null and @characterInputString is not null
    begin
      -- Loop through input string
      while @curPos <= @inputStringLength
        begin
          -- Insert select each character from input string
          insert into @inputStringTemp (inputAsciiCharacter, inputUnicodeCharacter)
          select
          substring(@inputString, @curPos, 1),
          unicode(substring(@inputString, @curPos, 1))

          -- Increment position
          set @curPos = @curPos + 1
        end

      -- Insert select each character from character input string
      insert into @characterStringTemp (asciiCharacter, unicodeCharacter)
      select
      substring([value], 1, 1),
      unicode(substring([value], 1, 1))
      from string_split(@characterInputString, @delimiterCharacter)
      group by substring([value], 1, 1), unicode(substring([value], 1, 1))

      -- Update table to include delimiter character
      update @characterStringTemp
      set
      asciiCharacter = @delimiterCharacter,
      unicodeCharacter = unicode(@delimiterCharacter)
      where
      asciiCharacter = '' and
      unicodeCharacter is null

      -- Set variable combining each row into one row as a single string
      select
      @stringResult = string_agg(iif(cst.cstID is null, ' ', ist.inputAsciiCharacter), '') within group (order by ist.istID asc)
      from @inputStringTemp ist
      left join @characterStringTemp cst on cst.asciiCharacter = ist.inputAsciiCharacter and cst.unicodeCharacter = ist.inputUnicodeCharacter

      -- Loop through variable string until no more exists
      while charindex('  ', @stringResult) > 0
        begin
          -- Convert double spaces into one space
          set @stringResult = replace(@stringResult, '  ', ' ')
        end

      -- Set variable
      set @stringResult = trim(@stringResult)
    end
  else
    begin
      -- Set variable
      set @stringResult = null
    end

  -- Return variable
  return @stringResult
end
