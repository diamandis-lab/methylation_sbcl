library(docopt)

doc <- "
Usage:
  svm_predict.R
  svm_predict.R --data <FILE> --model <FILE> [--out_csv <FILE>] [--out_rds <FILE>]

Options:
  --data FILE file with expression data: csv, tsv, txt, rds or RData (containing data.frame named 'expr')
  --model FILE file containing SVM model (.rds)
  --out_csv FILE output classification results (.csv)
  --out_rds FILE output classification results (.rds)
  --help               show this help text"
opt <- docopt(doc)

# On app start-up, Shiny-server may attempt to execute every R script that is present
# A "No-args" option is necessary, and captured "error.state" needs to result in successful execution

error.state<-FALSE

if(is.null(opt$data) & is.null(opt$model) & is.null(opt$out_csv) & is.null(opt$out_rds)){
  error.state<-TRUE
  message("Missing parameters: --data, --model and --out_rds")
}else{
  
  if(!file.exists(opt$data)){
    message("File not found: --data ", opt$data)
    error.state<-TRUE
  }
  if(!file.exists(opt$model)){
    message("File not found: --model ", opt$model)
    error.state<-TRUE
  }
  if(is.null(opt$out_csv) & is.null(opt$out_rds)){
    message("Output file not specified: --out_csv and/or --out_rds")
    error.state<-TRUE
  }
}



doPredict<-function(opt){
  library(reshape2)
  library(dplyr)
  library(e1071) #svm
  
  svm <- readRDS(opt$model)
  
  vars<-deparse(svm[["terms"]][[3]]) # converts 'language' type object to string
  vars<-gsub(" ", "", paste(vars, collapse=""))
  vars<-strsplit(vars, split="\\+")[[1]]
  
  
  mval <- read.csv(opt$data)
  rownames(mval)<-mval[,1]
  mval<-mval[,-1]
  mval.sub<-mval[rownames(mval) %in% vars,]
  
  pred.class<-predict(svm, t(mval.sub), probability = FALSE)
  pred.prob<-attr(predict(svm, t(mval.sub), probability = TRUE), "probabilities")
  pred.prob<-data.frame(apply(pred.prob, 2, function(x) format(round(x, 3), nsmall = 3)))
  df<-data.frame(sample=names(pred.class),
                 predicted.class=pred.class,
                 pred.prob)
  rownames(df)<-NULL
  
  if(!is.null(opt$out_rds)){
    saveRDS(df, file=opt$out_rds)
  }
  if(!is.null(opt$out_rds)){
    write.csv(df, file=opt$out_csv, row.names=FALSE, quote=FALSE)
  }
  
}

if(error.state){
  message("Program aborted")
}else{
  doPredict(opt)
}


