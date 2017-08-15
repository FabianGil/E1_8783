* apertura,importacion y combinacion de bases de datos a stata**
 log using "intento.smcl"
 import excel "variable 1.xls", sheet("base1") firstrow case(lower)
 import delimited Base2.csv, delimiter(comma) clear 
 use “intento 1 variables.dta"
 append using "variables 2.dta", force
 merge 1:1 var1 using "Base3.dta"
 save "intento  variables 1+2+3.dta"
 
** asignacion de nombres y rotulos a las variables en la base de datos*
label variable var1 "identificacion"
 rename var1 id
 rename var2 sexo
 label variable sexo "sexo"
 rename var3 dolor
 label variable dolor "tipo de dolor toracico"
 rename var4 sisp
 label variable sisp "presion sistolica"
 rename var5 coles
 label variable coles "colesterol serico"
 rename var6 electro
 label variable electro "resultados electrocardiograficos"
 rename var7 dnaci
 label variable dnaci "dia de nacimiento"
 rename var8 angio
 label variable angio "resultado angiografia"
 rename var9 dangio
 label variable dangio "dia de angiografia"

** asignacion de rotulos para las variables categoricas++
 label define sexo 0 "female" 1 "male"
 label values sexo sexo
 label define dolor 1 "angina tipica" 2 "angina atipica" 3 "dolor no anginal" 4 "asintomatico"
 label values dolor dolor
 label define electro 0 "normal" 1 "con anormalidad de onda ST-T" 2 "muestra probablilidad o define hipertrofia ventricular izquierda"
 label values electro electro
 label define angio 0 "<50% del diametro comprometido" 1 ">50% del diametro comprometido"
 label values angio angio

****categorizacion de la variable de presion arterial y rotulos de la misma** 
gen sisp2= sisp
 codebook sisp2
 destring sisp2, generate(sisp3) force
 codebook sisp3
 gen siscate= .
 replace siscate = 0 if sisp3 <90
 replace siscate= 1 if sisp3 >=90 & sisp3 <130
 replace siscate= 2 if sisp3 >=130 & sisp3 <140
 replace siscate= 3 if sisp3 >=140 & sisp3 <160
 replace siscate= 4 if sisp3 >=160 & sisp3 <180
 replace siscate= 5 if sisp3 >=180 & sisp3 ! = .
 codebook siscate
 label define sisp3 0 "hipotension" 1 "normal" 2 "prehipertension" 3 "hta grado 1" 4 "hta grado 2" 5 "crisis hta"
 label values siscate sisp3
 destring coles, generate(coles2) force

** variable que muestra edad de pacientes en el momento de angiografia**
 gen dnaci1 = date(dnaci, "MDY")
 format dnaci1 %td
 gen dangio1 = date(dangio, "DMY")
 format dangio1 %td
 gen edad = ( dangio1- dnaci1)/365.25

** Eliminación de las variables no empleadas en el análisis
 drop sisp
 drop coles
 drop dnaci
 drop dangio
 drop sisp2
** descripcion mediante graficos de acuerdo edad y sexo**
 histogram edad, bin(5) percent by(sexo)
 graph box edad, over(sexo)
*** tabla de relacion de enfermedad coronoria con el tipo de dolor toracico presentado**
 tabulate angio dolor

