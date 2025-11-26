## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE
)

## ----echo = T, results = 'hide'-----------------------------------------------
library(pmxNODE)
library(ggplot2)

## ----echo = T, results = 'hide', eval = F-------------------------------------
# get_example_list()
# 
# copy_examples(
#   target_folder = "~/pmxNODE",
#   example_nr = 1,
#   example_software = "NONMEM"
# )

## ----echo=F, results='asis'---------------------------------------------------
model_text <- readLines(system.file("extdata","nm_example1_model.ctl", package = "pmxNODE"),warn = F)[17:18]
cat("```txt\n","...\n",paste(model_text, collapse = "\n"),"\n...", "\n```")

## ----echo = T, results = 'hide', eval = F-------------------------------------
# nn_converter_nm(ctl_path = "~/pmxNODE/nm_example1_model.ctl",
#                  pop_only = TRUE)

## ----echo=F, results='asis'---------------------------------------------------
model_text <- readLines(system.file("extdata","nm_example1_model_converted_ind.ctl", package = "pmxNODE"),warn = F)[113:147]
cat("```txt\n","...\n",paste(model_text, collapse = "\n"),"\n...", "\n```")

## ----echo = T, results = 'hide', eval = F-------------------------------------
# nmfe_path <- find_nmfe()
# 
# run_nm(ctl_file = "~/pmxNODE/nm_example1_model_converted_pop.ctl",
#        nm_path = nmfe_path,
#        parralel_command = "-parafile=C:/nm75g64/run/mpiwini8.pnm [nodes]=30",
#        create_dir = TRUE,
#        data_file = "~/pmxNODE/data_example1_nm.csv")

## ----echo = T, results = 'hide', eval = F-------------------------------------
# est_parms <- pre_fixef_extractor_nm("~/pmxNODE/nm_example1_model_converted_pop/nm_example1_model_converted_pop.res")
# 
# nn_converter_nm(ctl_path = "~/pmxNODE/nm_example1_model.ctl",
#                  pop_only = FALSE,
#                  pre_fixef = est_parms)
# 
# run_nm(ctl_file = "~/pmxNODE/nm_example1_model_converted_ind.ctl",
#        nm_path = nmfe_path,
#        parralel_command = "-parafile=C:/nm75g64/run/mpiwini8.pnm [nodes]=30",
#        create_dir = TRUE,
#        data_file = "~/pmxNODE/data_example1_nm.csv")

## ----echo = T, eval = F-------------------------------------------------------
# predictions <- read.table("~/pmxNODE/nm_example1_model_converted_ind/nm_example1.tab", header = T, skip = 1)
# predictions <- predictions[predictions$AMT == 0,]

## ----include=FALSE------------------------------------------------------------
predictions <- read.table(system.file("extdata", "nm_example1.tab", package = "pmxNODE"), header=T,skip=1)
predictions <- predictions[predictions$AMT == 0,]

## ----echo = T-----------------------------------------------------------------
predictions <- predictions[predictions$AMT == 0,]

ggplot(predictions) +
  geom_point(aes(x = TIME, y = DV)) +
  geom_line(aes(x = TIME, y = IPRED), color = "blue") +
  geom_line(aes(x = TIME, y = PRED), color = "red") +
  facet_wrap(~ID)

ggplot(predictions) +
  geom_point(aes(x = DV,y = PRED)) +
  geom_abline(slope = 1, intercept = 0)

ggplot(predictions) +
  geom_point(aes(x = DV,y = IPRED)) +
  geom_abline(slope = 1, intercept = 0)

ggplot(predictions) +
  geom_point(aes(x = DV, y = IWRE)) +
  geom_abline(slope = 0, intercept = 0)

ggplot(predictions) +
  geom_point(aes(x = TIME, y = IWRE)) +
  geom_abline(slope = 0, intercept = 0)

## ----echo = T, eval=F---------------------------------------------------------
# der_state_plot_nm("c", min_state = 0, max_state = 10, nm_res_file = "~/pmxNODE/nm_example1_model_converted_ind/nm_example1_model_converted_ind.res", plot_type = "ggplot")
# der_state_plot_nm("ct", min_state = 0, max_state = 24, nm_res_file = "~/pmxNODE/nm_example1_model_converted_ind/nm_example1_model_converted_ind.res", time_nn = TRUE, plot_type = "ggplot")

## ----echo=FALSE---------------------------------------------------------------
pc <- der_state_plot_nm("c", min_state = 0, max_state = 10, nm_res_file = system.file("extdata","nm_example1_model_converted_ind.res",package="pmxNODE"), plot_type = "ggplot")
pt <- der_state_plot_nm("t", min_state = 0, max_state = 24, nm_res_file = system.file("extdata","nm_example1_model_converted_ind.res",package="pmxNODE"), time_nn = TRUE, plot_type = "ggplot")
print(pc)
print(pt)

## ----eval=F-------------------------------------------------------------------
# est_parms <- pre_fixef_extractor_nm("~/pmxNODE/nm_example1_model_converted_ind/nm_example1_model_converted_ind.res")
# rhs_inputs <- data.frame(id = predictions$ID,
#                          NNc = predictions$PRED*as.numeric(est_parms["V"]),
#                          NNt = predictions$TIME,
#                          dose = 10)
# rhs_plot_nm("NNc + dose * NNct", x_var = "NNc", inputs = rhs_inputs, nm_res_file = "~/pmxNODE/nm_example1_model_converted_ind/nm_example1_model_converted_ind.res", time_nn = c(FALSE, TRUE))
# rhs_plot_nm("NNc + dose * NNct", x_var = "NNct", inputs = rhs_inputs, nm_res_file = "~/pmxNODE/nm_example1_model_converted_ind/nm_example1_model_converted_ind.res", time_nn = c(FALSE, TRUE))

## ----echo=FALSE---------------------------------------------------------------
est_parms <- pre_fixef_extractor_nm(system.file("extdata","nm_example1_model_converted_ind.res",package="pmxNODE"))
rhs_inputs <- data.frame(id = predictions$ID,
                         NNc = predictions$PRED*as.numeric(est_parms["V"]),
                         NNt = predictions$TIME,
                         dose = 10)
prhsc <- rhs_plot_nm("NNc + dose * NNt", x_var = "NNc", inputs = rhs_inputs, nm_res_file = system.file("extdata","nm_example1_model_converted_ind.res",package="pmxNODE"), time_nn = c(FALSE, TRUE))
prhst <- rhs_plot_nm("NNc + dose * NNt", x_var = "NNt", inputs = rhs_inputs, nm_res_file = system.file("extdata","nm_example1_model_converted_ind.res",package="pmxNODE"), time_nn = c(FALSE, TRUE))
print(prhsc)
print(prhst)

## ----echo = T, eval=F---------------------------------------------------------
# ind_der_state_plot_mlx("c", min_state = 0, max_state = 10,
#                        nm_res_file = "~/pmxNODE/nm_example1_model_converted_ind/nm_example1_model_converted_ind.res",
#                        nm_phi_file = "~/pmxNODE/nm_example1_model_converted_ind/nm_example1_model_converted_ind.phi",
#                        plot_type = "ggplot")
# ind_der_state_plot_mlx("ct", min_state = 0, max_state = 24,
#                        nm_res_file = "~/pmxNODE/nm_example1_model_converted_ind/nm_example1_model_converted_ind.res",
#                        nm_phi_file = "~/pmxNODE/nm_example1_model_converted_ind/nm_example1_model_converted_ind.phi",
#                        time_nn = TRUE, plot_type = "ggplot")
# ind_rhs_plot_mlx("NNc + dose * NNt", x_var = "NNc", group = "id", inputs = rhs_inputs,
#                        nm_res_file = "~/pmxNODE/nm_example1_model_converted_ind/nm_example1_model_converted_ind.res",
#                        nm_phi_file = "~/pmxNODE/nm_example1_model_converted_ind/nm_example1_model_converted_ind.phi",
#                        time_nn = c(FALSE, TRUE))
# ind_rhs_plot_mlx("NNc + dose * NNt", x_var = "NNt", group = "id", inputs = rhs_inputs,
#                        nm_res_file = "~/pmxNODE/nm_example1_model_converted_ind/nm_example1_model_converted_ind.res",
#                        nm_phi_file = "~/pmxNODE/nm_example1_model_converted_ind/nm_example1_model_converted_ind.phi",
#                        time_nn = c(FALSE, TRUE))

## ----echo=FALSE---------------------------------------------------------------
ipc <- ind_der_state_plot_nm("c", min_state = 0, max_state = 10, nm_res_file = system.file("extdata","nm_example1_model_converted_ind.res",package="pmxNODE"),
                           nm_phi_file = system.file("extdata","nm_example1_model_converted_ind.phi",package="pmxNODE"))
ipt <- ind_der_state_plot_nm("t", min_state = 0, max_state = 24, nm_res_file = system.file("extdata","nm_example1_model_converted_ind.res",package="pmxNODE"),
                           nm_phi_file = system.file("extdata","nm_example1_model_converted_ind.phi",package="pmxNODE"), time_nn = TRUE)
iprhsc <- ind_rhs_plot_nm("NNc + dose * NNt", x_var = "NNc", group = "id", inputs = rhs_inputs, nm_res_file = system.file("extdata","nm_example1_model_converted_ind.res",package="pmxNODE"),
                           nm_phi_file = system.file("extdata","nm_example1_model_converted_ind.phi",package="pmxNODE"), time_nn = c(FALSE, TRUE))
iprhst <- ind_rhs_plot_nm("NNc + dose * NNt", x_var = "NNt", group = "id", inputs = rhs_inputs, nm_res_file = system.file("extdata","nm_example1_model_converted_ind.res",package="pmxNODE"),
                           nm_phi_file = system.file("extdata","nm_example1_model_converted_ind.phi",package="pmxNODE"), time_nn = c(FALSE, TRUE))
print(ipc)
print(ipt)
print(iprhsc)
print(iprhst)

