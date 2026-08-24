# Banco de España bulk CSV files

*Adapted from the [Banco de España bulk CSV file
manual](https://www.bde.es/webbe/en/estadisticas/compartido/docs/manual_archivos_csv_en.pdf).*

## Introduction

This document describes the files containing time series from
statistical tables and charts published on the Banco de España website.
It also explains how to use these files.

Data for the entire available sample period are provided for each
series, along with metadata describing its economic concept, units,
source and notes.

These files serve a broad audience, but users generally fall into two
categories:

1.  Users who download one or more tables to their computer to process
    them using a spreadsheet.
2.  Users or institutions that download all or most of the information,
    load it into a database and combine it with other statistical data
    or their own information.

The files are designed for both workflows.

Banco de España organizes statistical charts and tables on its website
by statistical publication or by subject. This document covers the
publication classification. The Statistics section primarily uses the
subject classification. Both classifications contain the same tables and
download URLs.

This document focuses on publications. The next section describes the
available files, their format and their content. The section on loading
CSV files summarizes the required delimiters and regional settings. The
annexes list the statistical publications and date formats.

The guidance in this manual applies to both classifications because they
contain the same tables, organized differently.

## Time series files

Files containing the time series for each publication table use the CSV
(comma-separated values) format. Commas separate the fields or values in
each line or record.

The decimal separator is a period (`.`) and the thousands separator is a
space.

Two file types are available based on their content.

**Catalog file**

The catalog file lists all series and describes the characteristics of
each series included in statistical publications.

For example, the file for all the Statistical Bulletin series is called
`catalogo_be.csv`.

The catalog file is updated **daily or quarterly**, depending on the
publication type.

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

**Table time series files**

These files cover the entire sample period for every series in a table.
There is one file for each table.

These files are **updated daily** whenever data for the corresponding
table change.

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

Users can download all time series files for a publication in a
compressed `pp.zip` file[^1]. Compressed files following the pattern
`ppcc.zip` contain all files for a chapter.

For example, `be01.zip` contains all the time series files of Chapter 1
of the Statistical Bulletin.

### Content of the catalog file

The catalog file has one record for each time series in the publication
tables. When the same series appears in several tables, the catalog has
one record for each table in which it appears. Each field describes a
characteristic of the time series.

**Alias de la serie (series alias)**

The alias shows where a series can be found in the publication. It
follows the pattern `pp_c_a.o[.f]`.

In this pattern:

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
reorganized. To ensure that a series can always be identified, it is
assigned a sequential number that remains unchanged throughout its
lifetime.

**Nombre de la serie/Código de la serie (API series code)**

This field contains the API series code used in Banco de España
databases. In **tidyBdE**, it is returned as `Nombre_de_la_serie`. Pass
this column to the `series_code` argument of
[`bde_series_api_latest()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_api.md)
or
[`bde_series_api_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_api.md).
It corresponds to the API `series_list` parameter.

**Nombre del archivo con los valores de la serie (name of the file
containing the series values)**

This field gives the name of the table file that contains the series
observations.

**Descripción de la serie (series description)**

This field summarizes the economic concept represented by the series.
The title field provides additional detail.

**Tipo de variable (variable type)**

This field indicates whether the economic concept represented by the
series is a flow, stock, average or annualized rate.

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

This field contains a code for the unit in which the series is
expressed. The “description of units and exponent” field explains the
code.

**Exponente (exponent)**

This field shows the power of ten by which the series values must be
multiplied to obtain the units. The meaning of this number is detailed
in the “description of units and exponent” field.

**Número de decimales (number of decimals)**

This field shows the precision with which the series is measured.

**Descripción de unidades y exponente (description of units and
exponent)**

This field describes the unit and exponent codes.

**Frecuencia (frequency)**

This field reports the highest frequency at which the series appears in
the table. For example, if a series appears at monthly and annual
frequencies, the file reports its frequency as monthly. The available
frequencies are:

- DIARIA (daily).
- LABORABLE (business days).
- MENSUAL (monthly).
- TRIMESTRAL (quarterly).
- SEMESTRAL (half-yearly).
- ANUAL (yearly).

The `LABORABLE` frequency covers Monday through Friday. The `DIARIA`
frequency also includes Saturdays and Sundays.

**Fecha de la primera observación (date of first observation)**

This field gives the date of the first observation in the sample period
covered by the series file. The date format depends on the series
frequency. See [Annex II: Date formats](#annex-ii-date-formats) for
details.

**Fecha de la última observación (date of last observation)**

This field gives the date of the last observation in the sample period
covered by the series file. The date format depends on the series
frequency. See [Annex II: Date formats](#annex-ii-date-formats) for
details.

**Número de observaciones (number of observations)**

This field gives the number of observations in the sample period covered
by the series file.

**Título (title)**

This field describes the economic concept measured or represented by the
series. It complements the description field and consists of character
strings separated by `/`.

**Fuente (source)**

This field describes the original source of the series and consists of
character strings separated by `/`.

**Notas (notes)**

This field contains general comments on how the series was compiled or
on particular observations. It consists of character strings separated
by `/`.

### Content of files with series values

Files with series values contain six header lines identifying the
series, one line of values for each date in the sample period and two
final lines containing the source and notes.

**Header lines**

The six header lines contain:

1.  Series aliases.
2.  Sequential numbers.
3.  API series code.
4.  Series description.
5.  Description of units.
6.  Frequency.

**Value lines**

Each line contains values for one date of the sample period. Values are
expressed using the number of decimals specified in the catalog file.

When data are not available, symbols are used instead of values:

- `_`: The phenomenon in question does not exist.
- `...`: Data are not available.

**Last lines**

The final lines contain:

- Source.
- Notes.

## Loading CSV files

CSV files are generated using:

- Decimal separator: period (`.`).
- Thousands separator: blank space.
- List separator: comma (`,`).

If regional settings differ from these conventions, values may not be
loaded correctly.

Catalog metadata can be used to locate series by searching for specific
characteristics.

For example, searching for text in the title field helps identify the
file that contains the corresponding series values.

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
| Daily / Business day | `DD MMMYYYY` | `02 FEB2019` |
| Monthly | `MMM YYYY` | `MAR 2020` |
| Quarterly | `MMM YYYY`, where `MMM` is the first or last month of the quarter, depending on the value of the `OBSERVED` variable | `ENE 2020` / `MAR 2020` |
| Half-yearly | `MMM YYYY`, where `MMM` is the first or last month of the half-year period, depending on the value of its `OBSERVED` variable | `ENE 2020` / `JUN 2020` |
| Annual | `YYYY` | `2020` |

Banco de España date formats. {.table}

[^1]: Files are compressed with **WinZip**.
