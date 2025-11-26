## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE
)

## ----include=FALSE------------------------------------------------------------
library(pmxNODE)
library(ggplot2)

## ----echo = T, results = 'hide', eval=FALSE-----------------------------------
# library(pmxNODE)
# library(ggplot2)
# library(lixoftConnectors)
# initializeLixoftConnectors("monolix", path = "C:/ProgramData/Lixoft/MonolixSuite2021R2")

## ----echo = T, results = 'hide', eval = F-------------------------------------
# get_example_list()
# 
# copy_examples(
#   target_folder = "~/pmxNODE",
#   example_nr = 1,
#   example_software = "Monolix"
# )

## ----echo=F, results='asis'---------------------------------------------------
model_text <- readLines(system.file("extdata","mlx_example1_model.txt", package = "pmxNODE"),warn = F)
cat("```txt\n", paste(model_text, collapse = "\n"), "\n```")

## ----echo = T, results = 'hide', eval = F-------------------------------------
# nn_converter_mlx(mlx_path = "~/pmxNODE/mlx_example1_model.txt",
#                  pop_only = TRUE,
#                  gen_mlx_file = TRUE,
#                  mlx_name = "~/pmxNODE/mlx_example1",
#                  data_file = "~/pmxNODE/data_example1_mlx.csv",
#                  header_types = c("id","time","amount","observation"))

## ----echo=F, results='asis'---------------------------------------------------
model_text <- readLines(system.file("extdata","mlx_example1_model_converted.txt", package = "pmxNODE"),warn = F)
cat("```txt\n", paste(model_text, collapse = "\n"), "\n```")

## ----echo = T, results = 'hide', eval = F-------------------------------------
# run_mlx("~/pmxNODE/mlx_example1_pop.mlxtran")

## ----echo = T, results = 'hide', eval = F-------------------------------------
# est_parms <- pre_fixef_extractor_mlx("~/pmxNODE/mlx_example1_pop.mlxtran")
# 
# nn_converter_mlx(mlx_path = "~/pmxNODE/mlx_example1_model.txt",
#                  pop_only = FALSE,
#                  pre_fixef = est_parms,
#                  gen_mlx_file = TRUE,
#                  mlx_name = "~/pmxNODE/mlx_example1",
#                  data_file = "~/pmxNODE/data_example1_mlx.csv",
#                  header_types = c("id","time","amount","observation"))
# 
# run_mlx("~/pmxNODE/mlx_example1_ind.mlxtran")

## ----echo = T, eval = F-------------------------------------------------------
# predictions <- read.table("~/pmxNODE/mlx_example1_ind/predictions.txt", header = T, sep = ",")

## ----include=FALSE------------------------------------------------------------
predictions <- read.table(system.file("extdata","mlx_example1_ind","predictions.txt",package = "pmxNODE"),header=T,sep=",")

## ----echo = T-----------------------------------------------------------------
ggplot(predictions) +
  geom_point(aes(x = time, y = DV)) +
  geom_line(aes(x = time, y = indivPred_mode), color = "blue") +
  geom_line(aes(x = time, y = popPred), color = "red") +
  facet_wrap(~id)

ggplot(predictions) +
  geom_point(aes(x = DV,y = popPred)) +
  geom_abline(slope = 1, intercept = 0)

ggplot(predictions) +
  geom_point(aes(x = DV,y = indivPred_mode)) +
  geom_abline(slope = 1, intercept = 0)

ggplot(predictions) +
  geom_point(aes(x = DV, y = indWRes_mode)) +
  geom_abline(slope = 0, intercept = 0)

ggplot(predictions) +
  geom_point(aes(x = time, y = indWRes_mode)) +
  geom_abline(slope = 0, intercept = 0)

## ----echo = T, eval=F---------------------------------------------------------
# der_state_plot_mlx("c", min_state = 0, max_state = 10, mlx_file = "~/pmxNODE/mlx_example1_ind.mlxtran", plot_type = "ggplot")
# der_state_plot_mlx("ct", min_state = 0, max_state = 24, mlx_file = "~/pmxNODE/mlx_example1_ind.mlxtran", time_nn = TRUE, plot_type = "ggplot")

## ----echo=FALSE---------------------------------------------------------------
pc <- der_state_plot_mlx("c", min_state = 0, max_state = 10, mlx_file = system.file("extdata","mlx_example1_ind.mlxtran",package="pmxNODE"), plot_type = "ggplot")
pt <- der_state_plot_mlx("ct", min_state = 0, max_state = 24, mlx_file = system.file("extdata","mlx_example1_ind.mlxtran",package="pmxNODE"), time_nn = TRUE, plot_type = "ggplot")
print(pc)
print(pt)

## ----eval=F-------------------------------------------------------------------
# est_parms <- pre_fixef_extractor_mlx("~/pmxNODE/mlx_example1_ind.mlxtran")
# rhs_inputs <- data.frame(id = predictions$id,
#                          NNc = predictions$popPred*est_parms["V_pop"],
#                          NNct = predictions$time,
#                          dose = 10)
# rhs_plot_mlx("NNc + dose * NNct", x_var = "NNc", inputs = rhs_inputs, mlx_file = "~/pmxNODE/mlx_example1_ind.mlxtran", time_nn = c(FALSE, TRUE))
# rhs_plot_mlx("NNc + dose * NNct", x_var = "NNct", inputs = rhs_inputs, mlx_file = "~/pmxNODE/mlx_example1_ind.mlxtran", time_nn = c(FALSE, TRUE))

## ----echo=FALSE---------------------------------------------------------------
est_parms <- pre_fixef_extractor_mlx(system.file("extdata","mlx_example1_ind.mlxtran",package="pmxNODE"))
rhs_inputs <- data.frame(id = predictions$id,
                         NNc = predictions$popPred*est_parms["V_pop"],
                         NNct = predictions$time,
                         dose = 10)
prhsc <- rhs_plot_mlx("NNc + dose * NNct", x_var = "NNc", inputs = rhs_inputs, mlx_file = system.file("extdata","mlx_example1_ind.mlxtran",package="pmxNODE"), time_nn = c(FALSE, TRUE))
prhst <- rhs_plot_mlx("NNc + dose * NNct", x_var = "NNct", inputs = rhs_inputs, mlx_file = system.file("extdata","mlx_example1_ind.mlxtran",package="pmxNODE"), time_nn = c(FALSE, TRUE))
print(prhsc)
print(prhst)

## ----echo = T, eval=F---------------------------------------------------------
# ind_der_state_plot_mlx("c", min_state = 0, max_state = 10, mlx_file = "~/pmxNODE/mlx_example1_ind.mlxtran", plot_type = "ggplot")
# ind_der_state_plot_mlx("ct", min_state = 0, max_state = 24, mlx_file = "~/pmxNODE/mlx_example1_ind.mlxtran", time_nn = TRUE, plot_type = "ggplot")
# ind_rhs_plot_mlx("NNc + dose * NNct", x_var = "NNc", group = "id", inputs = rhs_inputs, mlx_file = "~/pmxNODE/mlx_example1_ind.mlxtran", time_nn = c(FALSE, TRUE))
# ind_rhs_plot_mlx("NNc + dose * NNct", x_var = "NNct", group = "id", inputs = rhs_inputs, mlx_file = "~/pmxNODE/mlx_example1_ind.mlxtran", time_nn = c(FALSE, TRUE))

## ----echo=FALSE---------------------------------------------------------------
ipc <- ind_der_state_plot_mlx("c", min_state = 0, max_state = 10, mlx_file = system.file("extdata","mlx_example1_ind.mlxtran",package="pmxNODE"))
ipt <- ind_der_state_plot_mlx("ct", min_state = 0, max_state = 24, mlx_file = system.file("extdata","mlx_example1_ind.mlxtran",package="pmxNODE"), time_nn = TRUE)
iprhsc <- ind_rhs_plot_mlx("NNc + dose * NNct", x_var = "NNc", group = "id", inputs = rhs_inputs, mlx_file = system.file("extdata","mlx_example1_ind.mlxtran",package="pmxNODE"), time_nn = c(FALSE, TRUE))
iprhst <- ind_rhs_plot_mlx("NNc + dose * NNct", x_var = "NNct", group = "id", inputs = rhs_inputs, mlx_file = system.file("extdata","mlx_example1_ind.mlxtran",package="pmxNODE"), time_nn = c(FALSE, TRUE))
print(ipc)
print(ipt)
print(iprhsc)
print(iprhst)

