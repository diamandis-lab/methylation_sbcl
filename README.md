# methylation_sbcl: Classification of small B-cell lymphomas

This repository includes the SVM classifier, persistent t-SNE configuration, relevant scripts and demo data, as published in this manuscript:

**DNA methylation-based classification of small B-cell lymphomas: a proof-of-principle study** <br/>
*Xia D, Leon AJ, Yan J, Silva A, Bakhtiari M, Tremblay-LeMay R, Selvarajah S, Sabatini P, Diamandis P, Pugh TJ, Kridel R, Delabie J* <br/>
**(under review)**

A live-version can be found at (https://cancerhub.shinyapps.io/methylation_sbcl/) and it allows researchers classify SBCL samples using their own DNA methylation data.

## Demo run
The demo code includes stand-alone scripts that run via bash commands.

Installation of required packages
```
R -e "for(curr in c('reshape2', 'dplyr', 'e1071', 'docopt', 'htmlwidgets','remotes')){if(!require(curr, character.only = TRUE)){install.packages(curr)}}"
R -e "remotes::install_github('https://github.com/oicr-gsi/modelTsne')"
```
Download repository:
```
wget https://github.com/diamandis-lab/methylation_sbcl/archive/refs/heads/main.zip
unzip main.zip
cd methylation_sbcl-main
```
Sample classification using the SVM model:
```
Rscript R/svm_predict.R --data data/M_values_methylation_sbcl_demo.csv \
                      --model data/svm_methylation_sbcl.rds \
                      --out_csv predictSVM_demo.csv
```
Dimensional reduction with  persistent t-TSNE model using the [modelTsne package](https://github.com/oicr-gsi/modelTsne):
```
Rscript R/tsne_persistent.R --data data/M_values_methylation_sbcl_demo.csv \
                          --model data/modelTsne_methylation_sbcl.rds \
                          --out_html resTsne_methylation_sbcl_demo.html
```





