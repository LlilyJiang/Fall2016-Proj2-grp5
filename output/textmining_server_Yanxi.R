library(tm) 
library(proxy) 
namemap <- list.files("/Users/jesserina/Desktop/shiny app/tree")
shinyServer(function(input, output) {
  
  output$desc <-  renderText({   
    treefile <- paste0("tree/",namemap[as.integer(input$treename)])
    desc <- readLines(treefile)
    desc
    })
 

  output$cd <-  renderTable({   
    trees <- strsplit(input$tt, split = "&")[[1]]
   
    treefiles <- paste0("tree/",namemap)
    ss <- sapply(treefiles, readLines)
    corpus  <- Corpus(VectorSource(ss),
                      readerControl = list(blank.lines.skip=TRUE))
    #some preprocessing
    corpus <- tm_map(corpus, removeWords, stopwords("english"))
    corpus <- tm_map(corpus, stripWhitespace)
    corpus <- tm_map(corpus, removePunctuation)
   

    #creating term matrix with TF-IDF weighting
    terms <- DocumentTermMatrix(corpus,
                                control = list(weighting = function(x) weightTfIdf(x, normalize = FALSE)))
    dtm <- removeSparseTerms(terms, sparse = 0.6)
    mat <- as.matrix(dtm)
    res <- dist(mat, method = "cosine")
    res2 <- round(as.matrix(res),5)
    diag(res2) <- 1
    res <- data.frame(res2)
    res$name <- gsub(".txt"," ",namemap)
    colnames(res) <- c(gsub(".txt"," ",namemap)," ")
    res[as.integer(trees),as.integer(trees)]
    
    
    
    
  })
   output$fig <-  renderPlot({   
    trees <- strsplit(input$tt, split = "&")[[1]]
    trees <- namemap[as.integer(trees)]
    treefiles <- paste0("tree/",trees)
    ss <- sapply(treefiles, readLines)
    corpus  <- Corpus(VectorSource(ss),
                      readerControl = list(blank.lines.skip=TRUE))
    #some preprocessing
    corpus <- tm_map(corpus, removeWords, stopwords("english"))
    corpus <- tm_map(corpus, stripWhitespace)
    corpus <- tm_map(corpus, removePunctuation)
    
    
    #creating term matrix with TF-IDF weighting
    terms <- DocumentTermMatrix(corpus,
                                control = list(weighting = function(x) weightTfIdf(x, normalize = FALSE)))
    dtm <- removeSparseTerms(terms, sparse = 0.6)
    mat <- as.matrix(dtm)
    res <- dist(mat, method = "cosine")
    res <- 1-res
    if(dim(res)[1] > 2)
    plot(hclust(res),labels = gsub(".txt"," ",trees),xlab = " ")
    else NULL
  })
  output$tb <-  renderTable({   
     data.frame(ID=1:length(namemap), Name = gsub(".txt"," ",namemap))
  })
  
})
