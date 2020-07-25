# omitcharactersmssql
> Microsoft SQL Server function to omit characters from user defined string

## Table of Contents
* [Version](#version)
* [Important Note](#important-note)
* [Prerequisite Data Types](#prerequisite-data-types)
* [Prerequisite Functions](#prerequisite-functions)
* [Prerequisite Conditions](#prerequisite-conditions)
* [Usage](#usage)

### Version
* 0.0.1

### **Important Note**
* This function was written with SQL Server 2012 methods

### Prerequisite Data Types
* nvarchar
* integer (int)
* char

### Prerequisite Functions
* nullif
* charIndex
* ltrim
* rtrim
* substring
* try_cast
* stuff
* len
* unicode
* replace

### Prerequisite Conditions
* exists

### Usage
* `dbo.OmitCharacters('This is a test string 12345678.', '65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')`
