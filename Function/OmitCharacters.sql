use [DatabaseName]
go

-- Set ansi nulls
set ansi_nulls on
go

-- Set quoted identifier
set quoted_identifier on
go

-- ===========================
--       File: OmitCharacters
--    Created: 07/22/2020
--    Updated: 07/29/2020
-- Programmer: Cuates
--  Update By: Cuates
--    Purpose: Omit characters
-- ===========================
create function [dbo].[OmitCharacters]
(
  -- Parameters
  @inputString nvarchar(max) = null,
  @unicodeValue nvarchar(max) = null
)
returns nvarchar(max)
as
begin
  -- URLs
  -- http://www.asciitable.com/
  -- http://www.fileformat.info/info/unicode/char/search.htm

  -- Declare variables
  declare @stringResult nvarchar(max)
  declare @curPos int
  declare @stringMod nvarchar(max)
  declare @intLoc int
  declare @numCheck nvarchar(255)

  -- Set variables
  set @stringResult = ''
  set @curPos = 1
  set @stringMod = ''
  set @numCheck = ''

  -- Check if parameter is empty string
  if @unicodeValue = ''
    begin
      -- Set variable to null if empty string
      set @unicodeValue = nullif(@unicodeValue, '')
    end

  -- Check if parameter is not null
  if @unicodeValue is not null
    begin
      -- Declare temporary table
      declare @unicodeTempTable table
      (
        unicodeID int identity (1, 1) primary key,
        unicodeNumber int null null
      )

      -- Loop through user defined string
      while charIndex(',', @unicodeValue, 0) > 0
        begin
          -- Set first comma separated location
          set @intLoc = charindex(',', @unicodeValue, 0)

          -- Set variable
          set @numCheck = ltrim(rtrim(substring(@unicodeValue, 0, @intLoc)))

          -- Check if number and does not exist
          if try_cast(@numCheck as integer) is not null and not exists(select utt.unicodeNumber as [unicodeNumber] from @unicodeTempTable utt where utt.unicodeNumber = @numCheck)
            begin
              -- Insert the found number into the temporary table
              insert into @unicodeTempTable (unicodeNumber)
              select
              ltrim(rtrim(substring(@unicodeValue, 0, @intLoc)))
            end

          -- Remove the found number from the overall string
          set @unicodeValue = stuff(@unicodeValue, 1, @intLoc, '')
        end

      -- Check if the entire string is not empty
      if ltrim(rtrim(@unicodeValue)) != ''
        begin
          -- Check if number and does not exist
          if try_cast(@unicodeValue as integer) is not null and not exists(select utt.unicodeNumber as [unicodeNumber] from @unicodeTempTable utt where utt.unicodeNumber = @unicodeValue)
            begin
              -- Insert the found number into the temporary table
              insert into @unicodeTempTable (unicodeNumber)
              select
              @unicodeValue
            end
          else
            begin
              -- Else empty entire string
              set @unicodeValue = ''
            end
        end

      -- Loop through the entire string by character
      while @curPos <= len(@inputString)
        begin
          -- Set variable with sub string of character
          set @stringMod = substring(@inputString, @curPos, 1)

          -- Check if unicode value exists
          if exists
          (
            -- Select record
            select
            utt.unicodeID as [unicodeID]
            from @unicodeTempTable utt
            where
            utt.unicodeNumber = unicode(@stringMod)
          )
            begin
              -- Append to entire string with new character
              set @stringResult = @stringResult + @stringMod
            end

            -- Increment current position
            set @curPos += 1
          end

      -- Remove additional spaces from the entire string
      set @stringResult =
      replace
      (
        replace
        (
          replace
          (
            ltrim(rtrim(@stringResult)), '  ', ' ' + char(7)
          ), char(7) + ' ', ''
        ), char(7), ''
      )
    end
  else
    begin
      -- Set error message
      set @stringResult = 'Error~Unicode string parameter was not provided'
    end

  -- Return string result
  return @stringResult
end