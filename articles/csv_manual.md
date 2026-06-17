# Banco de España bulk CSV files

*Adaptation of
<https://www.bde.es/webbe/en/estadisticas/compartido/docs/manual_archivos_csv_en.pdf>*

## Introduction

This document describes the information in the files containing the time
series of the statistical tables and charts that Banco de España
publishes on its website, and provides guidance on possible uses of
these files.

Data for the full available sample period are provided for each series,
along with qualitative information or metadata. This information gives
users details about each series, such as the economic concept it
represents, the units in which the data are expressed, the source and
any notes.

The target audience for this information is as wide as the network
through which it is distributed. Nevertheless, two categories of
potential users can be distinguished:

1.  Users who download one or more tables to their computer to process
    them using a spreadsheet.
2.  Users or institutions who download all or most of the information to
    upload it to a database and combine it with other sources of
    statistical data or even with the institution’s own information.

The information provided is geared to both types of users.

The statistics provided by Banco de España as statistical charts or
tables are organized in two different ways on its website: by
statistical publication, which is the approach covered by this document,
or by subject, which is the main organization used in the Statistics
section. The tables and download URLs are the same in both cases.

This document focuses on publications and is organized as follows. The
second section explains the two types of files released, their format
and their content. The third section provides guidance for users who
want to process the information with a spreadsheet. The fourth section
provides guidance for institutions that want to develop software for
automatically uploading the information to a database.

Because the tables in the theme-based classification are the same as
those in the publications, only organized differently, everything
mentioned in this manual about bulk CSV files is valid for both.

## Time-series files

Files containing the time series of the tables of the relevant
publication are in CSV (comma-separated value) format, where fields or
values in each line or record are separated by commas.

The decimal separator is the full stop `"."` and the thousand separator
is a blank space.

They can be classified into two different types according to their
content.

**Catalog file**

The catalog file contains a list of all series and metadata on the
characteristics of each series included in statistical publications.

For example, the file for all the Statistical Bulletin series is called
`catalogo_be.csv`.

The catalog file is updated on a **daily or a quarterly basis**,
depending on the type of publication.

**Example:** Records of the `catalogo_be.csv` file

    "Alias de la serie","Número secuencial","Nombre de la serie/Código de la
    serie","Nombre del archivo con los valores de la serie","Descripción de la
    serie","Tipo de variable","Código de unidades","Exponente","Número de
    decimales","Descripción de unidades y exponente","Frecuencia de la serie","Fecha
    de la primera observación","Fecha de la última observación","Número de
    observaciones","Título de la serie","Fuente","Notas"
    "SI_1_1.1",3778094,DSPC102016VP30000_ES14A_TSC.T,"SI_1_1.csv",...
    "SI_1_1.2",805995,D_1KH90101,"SI_1_1.csv",...
    "SI_1_1.3",1832510,D_1KH99500_D09,"SI_1_1.csv",...

**Files containing the time series data of a table**

These files cover the entire sample period of every series of a table.
There is one file for each table.

These files are **updated on a daily basis**, which means that each CSV
file is updated whenever data for the table in question change.

**Example:** Records of a table file

    "ALIAS DE LA SERIE","BE_23_A.1","BE_23_A.2","BE_23_A.3",...
    "NÚMERO SECUENCIAL",3777714,3777708,3777711,...
    "NOMBRE DE LA SERIE/CÓDIGO DE LA SERIE",...
    "DESCRIPCIÓN DE LA SERIE",...
    "DESCRIPCIÓN DE LAS UNIDADES",...
    "FRECUENCIA","TRIMESTRAL","TRIMESTRAL","TRIMESTRAL",...
    "MAR 1995",88400,68435,1203,...
    "JUN 1995",89949,67556,1122,...
    "SEP 1995",87765,68032,1046,...

**File naming convention**

The names of time series files follow the pattern `ppccaaa.csv`, where:

- `pp` is the publication code.
- `cc` is the chapter number.
- `aaa` is the table code.
- `csv` is the file extension.

For example, `be0101.csv` contains the series of Table 1 in Chapter 1 of
the Statistical Bulletin.

A compressed `pp.zip` file[^1] containing all time series files of a
publication is provided for users who wish to download this content. For
users interested in downloading all files of a chapter, compressed files
following the pattern below are also available: `ppcc.zip`.

For example, `be01.zip` contains all the time series files of Chapter 1
of the Statistical Bulletin.

### Content of the catalog file

The catalog file has a line or record for each time series of the tables
in the publication. When the same series is included in several tables,
the catalog file will have a line for each table in which it appears.
Each column or field contains a characteristic of the time series.

**Alias de la serie (series alias)**

The alias shows where this series can be found in the publication.
Pattern: `pp_c_a.o[.f]`.

Where:

- `pp`: publication code.
- `c`: chapter number.
- `a`: table number or code.
- `o`: column number in vertical or double-entry tables, or row number
  in horizontal tables.
- `f`: row number in double-entry tables.

Each alias is unique but should not be used as a stable series
identifier because it may change whenever a table is reorganized.

**Número secuencial (sequential number)**

Series aliases are positional and may change when tables are
reorganized. To ensure series can always be identified, a sequential
number is assigned to each series and remains unchanged throughout its
lifetime.

**Nombre de la serie/Código de la serie (API series code)**

The API series code in the Banco de España databases. It is unique and
invariable. In **tidyBdE**, this field is passed through `series_code`
in the Statistics web service (API) helpers and corresponds to the API
`series_list` parameter.

**Nombre del archivo con los valores de la serie (name of the file
containing the series values)**

The name of the file corresponding to the table to which the series
belongs and which contains the series observations.

**Descripción de la serie (series description)**

A string of characters summarising the economic concept represented by
the series. It is complemented by the title field.

**Tipo de variable (variable type)**

Indicates whether the economic concept represented by the series is a
flow, stock, average or annualized rate.

|                         |                                  |
|-------------------------|----------------------------------|
| **Type of variable**    | **Explanation**                  |
| Principio (start)       | Stock at the start of the period |
| Final (end)             | Stock at the end of the period   |
| Media (average)         | Period average                   |
| Suma (total)            | Flow during the period           |
| Anualizado (annualized) | Annualized variable              |

Explanations of the type of variable in the catalog file. {.table}

**Código de unidades (unit code)**

A code showing the unit in which the series is expressed. The meaning of
this code is detailed in the “description of units and exponent” field.

**Exponente (exponent)**

It shows the power of ten by which the values of the series have to be
multiplied to obtain the units. The meaning of this number is detailed
in the “description of units and exponent” field.

**Número de decimales (number of decimals)**

It shows the precision with which the series is measured.

**Descripción de unidades y exponente (description of units and
exponent)**

It describes or decodes the unit and exponent codes.

**Frecuencia (frequency)**

The series frequency will be the highest of those with which it appears
in the table. For example, if a series appears in a table with monthly
and annual frequencies, the series frequency displayed in the file will
be monthly. These frequencies can be:

- DIARIA (daily),
- LABORABLE (business days),
- MENSUAL (monthly),
- TRIMESTRAL (quarterly),
- SEMESTRAL (half-yearly),
- ANUAL (yearly)

Note: LABORABLE frequency means Monday to Friday. DIARIA frequency also
includes Saturdays and Sundays.

**Fecha de la primera observación (date of first observation)**

Date of the first observation inside the sample period included in the
file with the series values. The date of the first observation is
expressed according to the frequency of the series. See [Annex II: Date
formats](#annex-ii-date-formats) for date formats.

**Fecha de la última observación (date of last observation)**

Date of the last observation inside the sample period included in the
file with the series values. The date of the last observation is
expressed according to the frequency of the series. See [Annex II: Date
formats](#annex-ii-date-formats) for date formats.

**Número de observaciones (number of observations)**

The number of observations contained in the sample period of the series,
which are included in the file with the series values.

**Título (title)**

It describes in detail the economic concept measured or represented by
the series. It complements the description field. It consists of a set
of character strings separated by the `/` character.

**Fuente (source)**

It describes the original source of the series. It consists of a set of
character strings separated by the `/` character.

**Notas (notes)**

It contains general comments on how the series was compiled or on
certain particular observations. It consists of a set of character
strings separated by the `/` character.

### Content of files with series values

Files with series values contain six header lines identifying the
series, a line with values for each date of the sample period and, at
the end of the file, two lines with the source and notes.

**Header lines**

The six header lines contain:

1.  Series aliases.
2.  Sequential numbers.
3.  API series code.
4.  Series description.
5.  Description of units.
6.  Frequency.

**Values lines**

Each line contains values for one date of the sample period. Values are
expressed using the number of decimals specified in the catalog file.

When data are not available, symbols are used instead of values:

- `_`: The phenomenon in question does not exist.
- `...`: Data not available.

**Last lines**

The final lines contain:

- Source.
- Notes.

## Loading CSV files

CSV files are generated using:

- Decimal separator: full stop (`.`)
- Thousands separator: none.
- List separator: comma (`,`).

If regional settings differ from these conventions, values may not be
loaded correctly.

Catalog metadata can be used to locate series by searching for specific
characteristics.

For example, searching for a text string in the title field allows
identification of the corresponding file containing the series values.

## Annex I: Statistical publications

|      |                      |                  |                              |
|------|----------------------|------------------|------------------------------|
| Code | Publication          | Update frequency | Frequency of the publication |
| BE   | Statistical Bulletin | Daily            | Monthly                      |
| SI   | Summary Indicators   | Daily            | Daily                        |
| TC   | Exchange Rates       | Daily            | Daily                        |
| TI   | Interest Rates       | Daily            | Daily                        |
| PB   | Bank Lending Survey  | Quarterly        | Quarterly                    |

Banco de España statistical publications. {.table}

## Annex II: Date formats

|  |  |  |
|----|----|----|
| Frequency | Format | Examples |
| Daily / Business day | `DD MMMMYYYY` | `02 FEB2019` |
| Monthly | `MMM YYYY` | `MAR 2020` |
| Quarterly | `MMM YYYY`, where `MMM` is the first or last month of the quarter, depending on the value of the `OBSERVED` variable | `ENE 2020` / `MAR 2020` |
| Half-yearly | `MMM YYYY`, where `MMM` is the first or last month of the half-year period, depending on the value of its `OBSERVED` variable | `ENE 2020` / `JUN 2020` |
| Annual | `YYYY` | `2020` |

Banco de España date formats. {.table}

[^1]: Files are compressed with WinZip.
