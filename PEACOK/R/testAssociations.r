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

# Tests the association of a field, determined by its field type
test.associations <- function(opt, vl, currentVar, currentVarShort, thisdata, phenoStartIdx) {
  	## call coresponding test function for variable type
  	tryCatch({
    		# retrieve whether phenotype is excluded etc
    		idx=which(vl$phenoInfo$FieldID==currentVarShort);
    		# check if variable info is found for this field
    		if (length(idx)==0) {
    			  cat(paste(currentVar, " || Variable could not be found in pheno info file. \n", sep=""))			
    		    .incrementCounter("notinphenofile")
    		} else {
        		# get info from variable info file
        		excluded = vl$phenoInfo$EXCLUDED[idx]
        		catSinToMult = vl$phenoInfo$CAT_SINGLE_TO_CAT_MULT[idx]
        		fieldType = vl$phenoInfo$ValueType[idx]
        		isExposure = get.is.exposure(vl, currentVarShort) #vl$phenoInfo$EXPOSURE_PHENOTYPE[idx]
        
        		if (fieldType=="Integer") {		
        			  #### INTEGER
        			  cat(currentVar, "|| ", sep="")
        			  if (excluded!="") {
        				    cat(paste("Excluded integer: ", excluded, " || ", sep=""))
        			      .incrementCounter("excluded.int")
        			  } else {
        			      .incrementCounter("start.int")
        				    if (isExposure==TRUE) {
        				        .incrementCounter("start.exposure.int")
        				    }
        			    	test.integer(opt, vl, currentVarShort, "INTEGER", thisdata, phenoStartIdx)
        			  }
        			  cat("\n")
        	  } else if (fieldType=="Continuous") {
          			cat(currentVar, "|| ", sep="")
          		  if (excluded!="") {
          				  cat(paste("Excluded continuous: ", excluded, " || ", sep=""))
          		    	.incrementCounter("excluded.cont")
          		  } else {
          			    .incrementCounter("start.cont")
          				  if (isExposure==TRUE) {
          				      .incrementCounter("start.exposure.cont")
                    }
          				  test.continuous(opt, vl, currentVarShort, "CONTINUOUS", thisdata, phenoStartIdx)
          	    }
          	    cat("\n")
        		} else if (fieldType=="Categorical single" && catSinToMult=="") {
          			cat(currentVar, "|| ", sep="")
          	    if (excluded!="") {
          			    cat(paste("Excluded cat-single: ", excluded, " || ", sep=""))
          	    		.incrementCounter("excluded.catSin")
          			} else {
          			    .incrementCounter("start.catSin")
          				  if (isExposure==TRUE) {
          				      .incrementCounter("start.exposure.catSin")
                    }
          			    test.categorical.single(opt, vl, currentVarShort, "CAT-SIN", thisdata, phenoStartIdx)
          			}
          			cat("\n")
        	  } else if (fieldType=="Categorical multiple" || catSinToMult!="") {
        			  cat(currentVar, "|| ", sep="")
          			if (excluded!="") {
          			    cat(paste("Excluded cat-multiple: ", excluded, " || ", sep=""))
          			    .incrementCounter("excluded.catMul")
          			} else {
            				if (catSinToMult!="") {
            					  cat("cat-single to cat-multiple || ", sep="")
            				    .incrementCounter("catSinToCatMul")
            				}
            			  .incrementCounter("start.catMul")	
            				if (isExposure==TRUE) {
            				    .incrementCounter("start.exposure.catMul")
                    } else {
            				    # get number of cat mult values denoting trait of interest
            	          numVals = .getNumValuesCatMultExposure(vl, currentVarShort)
            					  if (numVals>0) {
            		            .addToCounts("start.exposure.catMulvalues", numVals)
            					  }
            				}
            		    test.categorical.multiple(opt, vl, currentVarShort, "CAT-MUL", thisdata, phenoStartIdx)
            			}
            			cat("\n")
        		} else {
        	      #cat("VAR MISSING ", currentVarShort, "\n", sep="")
        	  }
        }
  	}, error = function(e) {
  		  print(paste("ERROR:", currentVar,e))
  	})
}



