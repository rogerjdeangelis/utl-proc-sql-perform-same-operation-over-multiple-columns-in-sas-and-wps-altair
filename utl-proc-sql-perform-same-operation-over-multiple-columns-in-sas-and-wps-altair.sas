%let pgm=utl-proc-sql-perform-same-operation-over-multiple-columns-in-sas-and-wps-altair;

proc sql perform same operation over multiple columns

max of variables m1-m10 by patient into variables max_m1-max_m10
This can also be dome in proc summary

Use sql arrays, may not be as slow as you think.

github
https://tinyurl.com/2abadsb2
https://github.com/rogerjdeangelis/utl-proc-sql-perform-same-operation-over-multiple-columns-in-sas-and-wps-altair

StackOverflow
https://tinyurl.com/2rupt9tz
https://stackoverflow.com/questions/75006864/proc-sql-perform-same-operation-over-multiple-columns

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/
data have;
  retain pat 1;
  array morb[10] m1-m10 (10*1);

  do idx=1 to 20;
    if mod(idx,5)=0 then pat=pat+1;
    do i=1 to 10;
      morb[i] = int(10*uniform(3214));
    end;
    output;
  end;
  drop idx i;
run;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*    HAVE total obs=20 17APR2023:14:08:16                                                                                */
/*                                                                                                                        */
/*    PAT    M1    M2    M3    M4    M5    M6    M7    M8    M9    M10                                                    */
/*                                                                                                                        */
/*     1      4     8     0     7     0     2     1     8     0     9                                                     */
/*     1      2     7     8     9     8     1     1     4     3     9                                                     */
/*     1      9     6     1     1     1     7     3     4     4     7                                                     */
/*     1      9     2     9     1     1     2     8     3     9     2                                                     */
/*                                                                                                                        */
/*     2      2     7     3     9     1     0     2     7     3     3                                                     */
/*     2      0     4     0     2     5     3     5     4     5     6                                                     */
/*     2      9     5     9     2     7     4     4     2     9     0                                                     */
/*     2      2     1     1     5     1     5     1     5     7     1                                                     */
/*     2      1     3     8     6     6     0     0     3     2     0                                                     */
/*     3      8     1     7     6     8     4     2     0     3     7                                                     */
/*                                                                                                                        */
/*     3      8     8     3     8     5     1     8     7     4     8                                                     */
/*     3      0     2     1     1     7     3     9     2     0     7                                                     */
/*     3      5     5     7     8     2     6     8     1     3     7                                                     */
/*     3      4     5     9     5     1     1     4     4     9     1                                                     */
/*                                                                                                                        */
/*     4      2     4     1     8     1     0     7     2     1     5                                                     */
/*     4      6     9     8     4     3     0     6     5     1     0                                                     */
/*     4      2     6     2     3     1     2     6     7     0     9                                                     */
/*     4      7     6     0     7     3     6     0     0     3     9                                                     */
/*     4      3     7     6     2     9     0     6     4     3     4                                                     */
/*                                                                                                                        */
/*     5      4     1     5     5     9     9     7     9     0     2                                                     */
/*                                                                                                                        */
/**************************************************************************************************************************/
/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/
/**************************************************************************************************************************/
/*                                                                                                                        */
/*  WANT total obs=5 17APR2023:14:11:14                                                                                   */
/*                                                                                                                        */
/*  PAT    MAX_M1    MAX_M2    MAX_M3    MAX_M4    MAX_M5    MAX_M6    MAX_M7    MAX_M8    MAX_M9    MAX_M10              */
/*                                                                                                                        */
/*   1        9         8         9         9         8         7         8         8         9         9                 */
/*   2        9         7         9         9         7         5         5         7         9         6                 */
/*   3        8         8         9         8         8         6         9         7         9         8                 */
/*   4        7         9         8         8         9         6         7         7         3         9                 */
/*   5        4         1         5         5         9         9         7         9         0         2                 */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%array(_morb,values=1-10);

proc sql;
   create
      table want as
   select
      Pat
      %do_over(_morb,phrase=%str(
       , max(m?)  as max_m?
      ))
   from
      have
   group
     by Pat
;quit;
/*
__      ___ __  ___
\ \ /\ / / `_ \/ __|
 \ V  V /| |_) \__ \
  \_/\_/ | .__/|___/
         |_|
*/
%let wrk=%sysfunc(pathname(work));

%utl_submit_wps64("

libname wrk '&wrk' ;

%array(_morb,values=1-10);

proc sql;
   create
      table want as
   select
      Pat
      %do_over(_morb,phrase=%str(
       , max(m?)  as max_m?
      ))
   from
      wrk.have
   group
     by Pat
;quit;

proc print data=want;
run;quit;

");

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
