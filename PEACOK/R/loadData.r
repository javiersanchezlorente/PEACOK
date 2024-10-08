# The MIT License (MIT)
# Copyright (c) 2017 Louise AC Millard, MRC Integrative Epidemiology Unit, University of Bristol
# Copyright (c) 2020 Quanli Wang, Center for Genomic Research, AstraZeneca
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without
# limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions
# of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.


# loads phenotype and trait of interest data files
# creates phenotype / trait of interest data frame
# creates confounder data frame
# create indicator fields data frame
# returns an object holding these three data frames
load.data <- function(opt, vl) {
  
  	validate.phenotype.input.header(opt)
  	validate.trait.input.header(opt)
  
  	print("Loading phenotypes ...")
  	phenotype = load.phenotypes(opt)
    toi <- load.trait.of.interest(opt, phenotype)
    conf <- load.confounders(opt, phenotype)
  
  	## add trait of interest to phenotype data frame and remove rows with no trait of interest
  	## merge in toi with phenotype - keep id list from phenotypes file
  	phenotype = merge(toi, phenotype, by="userID", all.y=TRUE, all.x=FALSE)
  	
    ## remove any rows with no trait of interest
    idxNotEmpty = which(!is.na(phenotype[,"geno"]))
  	if (opt$save == TRUE) {
  	      print(paste("Phenotype file has ", nrow(phenotype), " rows.", sep=""))
  	} else {
  		    print(paste("Phenotype file has ", nrow(phenotype), " rows with ", length(idxNotEmpty), " not NA for trait of interest (",opt$traitofinterest,").", sep=""))
  	}
    phenotype = phenotype[idxNotEmpty,]
  
  	# match ids from not empty phenotypes list
  	confsIdx = which(conf$userID %in% phenotype$userID)
    conf = conf[confsIdx,]
  
  	if (nrow(phenotype)==0) {
  	    stop("No examples with row in both trait of interest and phenotype files", call.=FALSE)
  	} else {
  	    print(paste("Phenotype and trait of interest data files merged, with", nrow(phenotype),"examples"))
  	}
  
  	# some fields are fixed that have a field type as cat single but we want to treat them like cat mult
  	phenotype <- .fixOddFieldsToCatMul(vl, phenotype)
  	indFields <- .loadIndicatorFields(opt, vl, colnames(phenotype))
  	samples <- .loadSampleFile(opt)
  	if (!is.null(samples)) {
  	    phenotype <- phenotype %>% inner_join(samples)
  	    conf <- conf %>% inner_join(samples)
  	    indFields <- indFields %>% inner_join(samples)
  	}
  	if (dim(phenotype)[1] < 1) {
  	    stop("Error: no samples found in dataset", call.=FALSE)
  	}
  	if (opt$extract) {
  	    write.table(phenotype, file=paste(opt$resDir,"extracted-phenotype.csv", sep=""), 
  	                append=FALSE, quote=FALSE, sep=",", na="", row.names=FALSE, col.names=TRUE)
  	    write.table(conf, file=paste(opt$resDir,"extracted-confounders.csv", sep=""), 
  	                append=FALSE, quote=FALSE, sep=",", na="", row.names=FALSE, col.names=TRUE)
  	}
  	d = list(phenotype=phenotype, confounders=conf, inds=indFields)
  	return(d)
}

.loadSampleFile <- function(opt) {
    if (!is.null(opt$samplefile)) {
        header <- fread(opt$samplefile, header=FALSE, data.table=FALSE, nrows=1, sep='\t')
        hasHeader <- "userID" %in% header
        samples <- fread(opt$samplefile, sep='\t', header=hasHeader, data.table=FALSE, na.strings=c("", "NA"))
        if (!hasHeader) {#assume the second column being sampleID (PED format)
            names(samples)[2] <- "userID"
        }
        samples <- samples %>% select("userID")
        samples$userID <- as.integer(samples$userID) #since all UKB samples are integers
    } else {
        samples <- NULL
    }
    return(samples)
}
