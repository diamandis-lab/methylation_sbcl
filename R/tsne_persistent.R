library(docopt)

doc <- "
Usage:
  tsne_persistent.R
  tsne_persistent.R --data <FILE> --model <FILE> [--out_html <FILE>] [--out_rds <FILE>]

Options:
  --data FILE file with expression data: csv, tsv, txt, rds or RData (containing data.frame named 'expr')
  --model FILE file containing persistent tsne model (.rds)
  --out_html FILE output t-SNE plot (.html)
  --out_rds FILE output tsneModel object (.rds)
  --help               show this help text"
opt <- docopt(doc)

# On app start-up, Shiny-server may attempt to execute every R script that is present
# A "No-args" option is necessary, and captured "error.state" needs to result in successful execution

error.state<-FALSE

if(is.null(opt$data) | is.null(opt$model) | is.null(opt$out_html) | is.null(opt$out_rds)){
  error.state<-TRUE
  message("Missing parameters: --data, --model, --out_html and/or --out_rds")
}else{
  
  if(!file.exists(opt$data)){
    message("File not found: --data ", opt$data)
    error.state<-TRUE
  }
  if(!file.exists(opt$model)){
    message("File not found: --model ", opt$model)
    error.state<-TRUE
  }
  if(is.null(opt$out_html) & is.null(opt$out_rds)){
    message("Output file not specified: --out_html and/or --out_rds")
    error.state<-TRUE
  }
}

doPredict<-function(opt){
  
  library(modelTsne)
  tsne.persistent <- readRDS(opt$model)
  mval <- read.csv(opt$data)
  rownames(mval)<-mval[,1]
  mval<-mval[,-1]
  
  tsne.res<-doTsneWithReference(mval, tsne.persistent)
  if(!is.null(opt$out_rds)){
    saveRDS(tsne.res, file=opt$out_rds)
  }
  if(!is.null(opt$out_html)){
    p<-plotTsne(tsne.res, method="plotly", title="t-SNE model (26 methylation probes) of small B-cell lymphomas")
    htmlwidgets::saveWidget(p, opt$out_html)
  }
  
}

if(error.state){
  message("Program aborted")
}else{
  doPredict(opt)
}


