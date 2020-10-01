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
* This function was written with SQL Server 2019 methods
* When Providing character input string, the prefix of N (National language character set) is needed to denote unicode nvarchar instead of varchar
* When wanting to include the delimiter character such as a comma then the following is needed
  * Double commas to denote the inclusion of a comma
    * ,,

### Prerequisite Data Types
* nvarchar
* integer (int)

### Prerequisite Functions
* len
* nullif
* substring
* unicode
* string_split
* string_agg
* iif
* charindex
* replace
* trim

### Prerequisite Conditions
* N/A

### Usage
* `dbo.OmitCharacters('This is a test string 12345678.', N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9, ,!,",#,$,%,&,'',(,),*,+,,,-,.,/,:,;,<,=,>,?,@,[,],^,_,{,|,},~')`
