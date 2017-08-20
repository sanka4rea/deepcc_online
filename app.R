# DeepCC web interface
library(shiny)
library(DT)
library(mxnet)
library(DeepCC)
library(ggplot2)
library(cowplot)
library(org.Hs.eg.db)
library(shinythemes)

cancer_type <- c("CRC", "Breast Cancer", "Ovarian Cancer", "Gastric Cancer")#list.files("data")

if (!exists("models")) {
  load("models.RData")
}

init <- function(x) {
  load("models.RData")
}

# Define UI for application
ui <- tagList(
  navbarPage(
    theme = shinytheme("flatly"),  # <--- To use a theme, uncomment this
    "DeepCC Online",
    tabPanel("Home",
             mainPanel(
      includeMarkdown("info/info.md")
    )),
    tabPanel("Analysis",
             sidebarPanel(
               tags$h4("Step 1: Functional spectra transformation"),
               tags$h5("(Skip this step if you want to use public data available)"),
               # tags$h5("(Skip this step if you want to use public data available)"),
               fileInput("eps", "Upload gene expression profiles",
                         accept = c(
                           "text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
               #selectInput(inputId = "dat_direction", label = "Samples in", choices = c("Row", "Column"), selected = "Row"),
               #checkboxInput(inputId = "no_sample_name", label = "No sample name", value = FALSE),
               #selectInput(inputId = "gene_sets", label = "Gene sets", choices = c("MSigDBv6"), selected = "MSigDBv6"),
               selectInput(inputId = "gene_annot", label = "Gene annotation", choices = keytypes(org.Hs.eg.db), selected = "ENTREZID"),
               #tags$h4("Only for single sample:"),
               #selectInput(inputId = "ref_cancer", label = "Pre-defined reference", choices = c("COADREAD", "BRCA", "OV"), selected = "COADREAD"),
               checkboxInput(inputId = "two_color_status", label = "Two color array", value = FALSE),
               actionButton("calc_fs", "Calculate Functional Sepctra", class = "btn-primary"),

               tags$hr(),
               tags$h4("Step 2: Cancer subtype classification"),
               selectInput(inputId = "cancer", label = "Select cancer type", choices = cancer_type, selected = cancer_type[1]),
               selectInput(inputId = "model", label = "Select pre-trained DeepCC classifier", choices = NULL, selected = NULL),
               selectInput(inputId = "dataset", label="Select functional spectra" ,choices = c("Uploaded"), selected = "Uploaded"),
               sliderInput("cutoff", "Set the cutoff on posterior probability:", 0, 1, 0.5),

               actionButton("predition", "Predict", class = "btn-primary")

             ),
             mainPanel(
               textOutput("calc_status"),
               dataTableOutput("pred_output")
             )
    ),
    tabPanel("News",
             mainPanel(
               includeMarkdown("info/news.md")
             )
    ),
    navbarMenu("Datasets",
               tabPanel("CRC", mainPanel(
                 dataTableOutput("crc_info")
               )),
               tabPanel("Breast Cancer", mainPanel(
                 dataTableOutput("br_info")
               )),
               tabPanel("Ovarian Cancer", mainPanel(
                 dataTableOutput("ov_info")
               )),
               tabPanel("Gastric Cancer", mainPanel(
                 dataTableOutput("gc_info")
               ))


               ),
    tabPanel("Help",
             mainPanel(
               includeMarkdown("help/help.md")
             )
    )

  ),
  div(id="login_busyx",
      class = "busy",
      conditionalPanel(
        condition="$('html').hasClass('shiny-busy')",
        img(src="loading.gif")
      )
  ),
  tags$style(type="text/css", "#loginA {text-align: center} #login {font-size:14px;
               text-align: left;position:absolute;top: 30%;left: 45%;margin-top: -100px;margin-left: -150px;}
               #login_busyx {position:fixed;top: 50%;left: 60%;margin-top: -100px;margin-left: -150px;}")
)

# Define server logic
server <- function(input, output, session) {
  gc()
  data_upload <- list()
  output$calc_status <- renderText("Waiting for uploading data...")

  output$crc_info <- renderDataTable(DT::datatable(read.csv("info/CRC.csv", check.names = F), options = list(
    autoWidth = TRUE,
    columnDefs = list(list(width = '200px', targets = c(3)),
                      list(width = '400px', targets = c(4)),
                      list(width = '150px', targets = c(5)))
  )))

  output$br_info <- renderDataTable(DT::datatable(read.csv("info/Breast Cancer.csv", check.names = F), options = list(
    autoWidth = TRUE,
    columnDefs = list(list(width = '200px', targets = c(3)),
                      list(width = '400px', targets = c(4)),
                      list(width = '150px', targets = c(5)))
  )))

  output$ov_info <- renderDataTable(DT::datatable(read.csv("info/Ovarian Cancer.csv", check.names = F), options = list(
    autoWidth = TRUE,
    columnDefs = list(list(width = '200px', targets = c(3)),
                      list(width = '400px', targets = c(4)),
                      list(width = '150px', targets = c(5)))
  )))

  output$gc_info <- renderDataTable(DT::datatable(read.csv("info/Gastric Cancer.csv", check.names = F), options = list(
    autoWidth = TRUE,
    columnDefs = list(list(width = '200px', targets = c(3)),
                      list(width = '400px', targets = c(4)),
                      list(width = '150px', targets = c(5)))
  )))

  observeEvent(input$eps, {
    output$pred_output = renderDataTable(NULL)

    data_upload <<- list(eps=data.table::fread(input$eps$datapath, check.names = F, stringsAsFactors = F, data.table=F))
    #if(!input$no_sample_name) {
      rownames(data_upload$eps) <<- data_upload$eps[, 1]
      if(ncol(data_upload$eps) == 2) {
        data_upload$eps <<- data.frame(Patient=t(data_upload$eps)[2, ])
      } else {
        data_upload$eps <<- data_upload$eps[, -1]

      }

      data_upload$eps <<- t(data_upload$eps)
    #}
    #if(input$dat_direction == "Column")


    output$calc_status <- renderText(paste("Detected", nrow(data_upload$eps), "sample(s) including", ncol(data_upload$eps), "genes uploaded."))
  })

  # fs
  observeEvent(input$calc_fs, {
    withProgress(message = 'Calculating functional spectra...', detail = "waiting...", value = 0, {

    if(!is.null(data_upload$eps)) {
      if(input$gene_annot != "ENTREZID") {
        colnames(data_upload$eps) <<- mapIds(org.Hs.eg.db,
                                             keys = colnames(data_upload$eps),
                                             keytype = input$gene_annot,
                                             column = "ENTREZID")

        missing_rate <- sum(is.na(colnames(data_upload$eps)))/length(is.na(colnames(data_upload$eps)))
        if(missing_rate > 0.9) {
          showModal(modalDialog(
            title = "Error!",
            "Please check the data again since there are more than 90% missing annotations!"
          ))
        }

        data_upload$eps <<- data_upload$eps[, !is.na(colnames(data_upload$eps))]
        }

      if(mean(annotate::isValidKey(colnames(data_upload$eps), "org.Hs.eg")) > 0.5) {
        data_upload$eps <<- data.matrix(data_upload$eps)

        if(nrow(data_upload$eps) > 1) data_upload$fps <<- getFunctionalSpectra(eps=data_upload$eps, geneSets = "MSigDBv6", cores=10)

        if(nrow(data_upload$eps) == 1) {
          if(input$cancer == "CRC") ref_cancer <- "COADREAD"
          if(input$cancer == "Breast Cancer") ref_cancer <- "BRCA"
          if(input$cancer == "Ovarian Cancer") ref_cancer <- "OV"
          if(input$cancer == "Gastric Cancer") ref_cancer <- "STAD"
          if(input$cancer == "Glioblastoma") ref_cancer <- "GBM"

          name <- rownames(data_upload$eps)

          data_upload$eps <<- (data_upload$eps[1, ])
          data_upload$fps <<- getFunctionalSpectrum(data_upload$eps,
                                                    geneSets = "MSigDBv6",
                                                    refExp = ref_cancer,
                                                    logChange = input$two_color_status,
                                                    inverseRescale = T)

          data_upload$fps <<- t(data.frame(data_upload$fps))
          rownames(data_upload$fps) <<- name
        }

        output$calc_status <- renderText(paste("Finished calculation of functional spectra, there are", nrow(data_upload$fps), "sample(s) including", ncol(data_upload$fps), "features."))

      } else {
        showModal(modalDialog(
          title = "Error!",
          "Please check the data again since most of the annotation is not valid!"
        ))
      }
    } else {
      showModal(modalDialog(
        title = "Error!",
        "No data uploaded!"
      ))
      }


      incProgress(1, detail = paste("Finished calculation."))
    })

  })

  observeEvent(input$cancer, {
    datasets <- gsub(".RData", "", list.files(file.path("data", input$cancer), pattern = "*.RData"))

    # Can also set the label and select items
    updateSelectInput(session, "dataset",
                      choices = c("Uploaded", datasets), selected = "Uploaded"
    )

    updateSelectInput(session, "model",
                      choices = c(names(models[[input$cancer]])), selected = names(models[[input$cancer]])[1]
    )
  })

  # predition
  observeEvent(input$predition, {
    #output$calc_status <- renderText("Predicting...")
    withProgress(message = 'Predicting...', detail = "waiting...", value = 0, {


    model <- models[[input$cancer]][[input$model]]
    if(input$dataset == "Uploaded") {
      data <- data_upload
    } else {
      data <- readRDS(file.path("data", input$cancer, paste0(input$dataset, ".RData")))
    }

    if(!is.null(data$fps)) {
      pred <- getDeepCCLabels(model, data$fps, cutoff = input$cutoff, prob.mode=T)
      # pred[, 1] <- as.character(pred[, 1])
      dt <- data.frame(`Sample ID`=rownames(data$fps), pred, check.names = F)

      dt <- datatable(dt, extensions = 'Buttons', options = list(paging = F,
                                                                 dom = 'Bfrtip',
                                                                 buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
      ))

      output$calc_status <- renderText("Prediction results:")
      output$pred_output <- renderDataTable(dt)
    }else {
      showModal(modalDialog(
        title = "Error!",
        "No functional spectra exists!"
      ))
    }

    incProgress(1, detail = paste("Finished."))
    })
  })


}

# Run the application
shinyApp(ui = ui, server = server, onStart = init)

