library(pacman)
p_load(readxl,dplyr,tidyverse,lme4,nadiv,MCMCglmm,QGglmm)

#LOAD FILES
Pedigree <- data.frame(read_excel("Supplementary_Table6.xlsx",sheet="Pedigree"))
Sperm <- read_excel("Supplementary_Table6.xlsx",sheet="Drone_Sperm")
Morpho <- read_excel("Supplementary_Table6.xlsx",sheet="Drone_Morphology")
Flight <- read_excel("Supplementary_Table6.xlsx",sheet="Drone_Flight")


# Build the sex-based relationship matrix
##################################################################
# --- Sex-based pedigree relationship matrix --
##################################################################

nrow(Pedigree)
# 507

# Test if queen's are listed in the pedigree as the animals
all(!(Pedigree$dam %in% Pedigree$Drone_ID) |
      !is.na(Pedigree$dam)) # must be TRUE!

# Number of queens
sel <- is.na(Pedigree$dam) & is.na(Pedigree$sire)
sum(sel)
# 20
Pedigree[sel, ]

# Build the sex-based relationship matrix
tmp <- makeS(pedigree = Pedigree[, c("Drone_ID", "dam", "sire", "sex")],
             heterogametic = "1",
             returnS = TRUE)
S    <- tmp[["S"]]
Sinv <- tmp[["Sinv"]]


##################################################################
# --- Sperm Traits ---
##################################################################
Sperm$Drone_Age <- as.factor(Sperm$Drone_Age)
Sperm$Line <- as.factor(Sperm$Line)
Sperm$Colony <- as.factor(Sperm$Colony)
Sperm$Sperm_Conc_2<-round(Sperm$Sperm_Conc, digits = 0)
Sperm$Sperm_viability_2<-round(Sperm$Sperm_viability, digits = 1)*100
Sperm<-data.frame(Sperm)


#######################
# --- Sperm Number ---
#######################

# Prior Distribution
prior <- list(R = list(V = 1, nu = 1),
              G = list(G1 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1000)))

# Model
# Fixed Effects - Breeding Line, Drone Age, and colony
# Random Effects - Drone ID 
# Distribution Poisson
# Sex-based pedigree used
model <- MCMCglmm(Sperm_Conc_2 ~ Drone_Age + Line + Colony,
                  random = ~ Drone_ID,
                  family = "poisson",
                  prior = prior,
                  ginverse = list(Drone_ID = Sinv),
                  data = Sperm,
                  nitt = 100000,
                  burnin = 10000,
                  thin = 10,
                  pr = TRUE)


summary(model)


#Phenotypic Variance
mean(rowSums(model[["VCV"]]))

params <-
  pmap_dfr(list(mu = model[["Sol"]][, "(Intercept)"],
                var.a = model[["VCV"]][, "Drone_ID"] / 2,
                # var.p = rowSums(model[["VCV"]])),
                var.p = model[["VCV"]][, "Drone_ID"] / 2 +
                  model[["VCV"]][, "units"]),
           QGparams,
           model = "Poisson.log",
           verbose = FALSE)
mean(params[["h2.obs"]])
sd(params[["h2.obs"]])
HPDinterval(as.mcmc(params[["h2.obs"]]))

#######################
# --- Sperm Viability ---
#######################

# Prior Distribution
prior <- list(R = list(V = 1, nu = 1),
              G = list(G1 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1000)))

# Model
# Fixed Effects - Breeding Line, Drone Age, and colony
# Random Effects - Drone ID 
# Distribution Poisson
# Sex-based pedigree used
model <- MCMCglmm(Sperm_viability_2 ~ Drone_Age + Line + Colony,
                  random = ~ Drone_ID,
                  family = "poisson",
                  prior = prior,
                  ginverse = list(Drone_ID = Sinv),
                  data = Sperm,
                  nitt = 100000,
                  burnin = 10000,
                  thin = 10,
                  pr = TRUE)


summary(model)

#Total Phenotypic Variance
mean(rowSums(model[["VCV"]]))


params <-
  pmap_dfr(list(mu = model[["Sol"]][, "(Intercept)"],
                var.a = model[["VCV"]][, "Drone_ID"] / 2,
                # var.p = rowSums(model[["VCV"]])),
                var.p = model[["VCV"]][, "Drone_ID"] / 2 +
                  model[["VCV"]][, "units"]),
           QGparams,
           model = "Poisson.log",
           verbose = FALSE)
mean(params[["h2.obs"]])
sd(params[["h2.obs"]])
HPDinterval(as.mcmc(params[["h2.obs"]]))

##################################################################
# --- Morpho Traits ---
##################################################################

Morpho$Phen_age <- as.factor(Morpho$Phen_age)
Morpho$Line <- as.factor(Morpho$Line)
Morpho$Colony <- as.factor(Morpho$Colony)
Morpho$Maturity <- as.factor(Morpho$Maturity)
Morpho<-data.frame(Morpho)

#######################
# --- Weight ---
#######################

prior <- list(R = list(V = 1, nu = 0.002),
              G = list(G1 = list(V = 1, nu = 0.002)))


# Model
# Fixed Effects - Breeding Line, Drone Age, and colony
# Random Effects - Drone ID 
# Distribution Poisson
# Sex-based pedigree used
model <- MCMCglmm(weight ~ Phen_age + Line + Colony,
                  random = ~ Drone_ID,
                  family = "gaussian",
                  prior = prior,
                  ginverse = list(Drone_ID = Sinv),
                  data = Morpho,
                  nitt = 100000,
                  burnin = 10000,
                  thin = 10,
                  pr = TRUE)

summary(model)


mean((model[["VCV"]][ , "Drone_ID"] + model[["VCV"]][ , "units"]))


herit <-
  model[["VCV"]][ , "Drone_ID"] / (model[["VCV"]][ , "Drone_ID"] + model[["VCV"]][ , "units"])

mean(herit)
HPDinterval(herit)


#######################
# --- basitarsus_length ---
#######################


prior <- list(R = list(V = 1, nu = 0.002),
              G = list(G1 = list(V = 1, nu = 0.002)))


# Model
# Fixed Effects - Breeding Line, Drone Age, and colony
# Random Effects - Drone ID 
# Distribution Poisson
# Sex-based pedigree used
model <- MCMCglmm(basitarsus_length ~ Phen_age + Line + Colony,
                  random = ~ Drone_ID,
                  family = "gaussian",
                  prior = prior,
                  ginverse = list(Drone_ID = Sinv),
                  data = Morpho,
                  nitt = 100000,
                  burnin = 10000,
                  thin = 10,
                  pr = TRUE)

summary(model)

herit <-
  model[["VCV"]][ , "Drone_ID"] / (model[["VCV"]][ , "Drone_ID"] + model[["VCV"]][ , "units"])

mean(herit)
HPDinterval(herit)


#######################
# --- forewing_length ---
#######################


prior <- list(R = list(V = 1, nu = 0.002),
              G = list(G1 = list(V = 1, nu = 0.002)))


# Model
# Fixed Effects - Breeding Line, Drone Age, and colony
# Random Effects - Drone ID 
# Distribution Poisson
# Sex-based pedigree used
model <- MCMCglmm(frontwing_width ~ Phen_age + Line + Colony,
                  random = ~ Drone_ID,
                  family = "gaussian",
                  prior = prior,
                  ginverse = list(Drone_ID = Sinv),
                  data = Morpho,
                  nitt = 100000,
                  burnin = 10000,
                  thin = 10,
                  pr = TRUE)

summary(model)

herit <-
  model[["VCV"]][ , "Drone_ID"] / (model[["VCV"]][ , "Drone_ID"] + model[["VCV"]][ , "units"])

mean(herit)
HPDinterval(herit)


#######################
# --- Sexual Maturity ---
#######################
Morpho<-data.frame(Morpho)

priorB <- list(
  R = list(V = 1, fix = 1),
  G = list(G1 = list(V = 1, nu = 1000, alpha.mu = 0, alpha.V = 1)))


# Model
# Fixed Effects - Breeding Line, Drone Age, and colony
# Random Effects - Drone ID 
# Distribution Poisson
# Sex-based pedigree used
model <- MCMCglmm(Maturity ~ Phen_age + Line + Colony,
                  random = ~ Drone_ID,
                  family = "threshold",
                  prior = priorB,
                  ginverse = list(Drone_ID = Sinv),
                  data = Morpho,
                  nitt = 100000,
                  burnin = 10000,
                  thin = 10,
                  pr = TRUE)

summary(model)



herit <-model[["VCV"]][ , "Drone_ID"] / rowSums(model[["VCV"]])


paramsB <-pmap_dfr(list(mu = model[["Sol"]][ , "(Intercept)"],
                        var.a = model[["VCV"]][ , "Drone_ID"],
                        var.p = rowSums(model[["VCV"]]) - 1), # Note the - 1 here
                   QGparams,
                   model = "binom1.probit",
                   verbose = FALSE)


mean(paramsB[["h2.obs"]])
HPDinterval(as.mcmc(paramsB[["h2.obs"]]))


##################################################################
# --- Flight ---
##################################################################

Flight$Drone_Age <- as.factor(Flight$Phen_age)
Flight$Line <- as.factor(Flight$Line)
Flight$Colony <- as.factor(Flight$Colony)
Flight<-data.frame(Flight)

#######################
# --- Daily Mean Flight Duration  ---
#######################


priorP <- list(R = list(V = 1, nu = 1),
               G = list(G1 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1000)))


# Model
# Fixed Effects - Breeding Line, Drone Age, and colony
# Random Effects - Drone ID 
# Distribution Poisson
# Sex-based pedigree used
model <- MCMCglmm(mean_flight_timediff ~ Phen_age + Line + Colony,
                  random = ~ Drone_ID,
                  family = "poisson",
                  prior = priorP,
                  ginverse = list(Drone_ID = Sinv),
                  data = Flight,
                  nitt = 100000,
                  burnin = 10000,
                  thin = 10,
                  pr = TRUE)


summary(model)


params <-
  pmap_dfr(list(mu = model[["Sol"]][, "(Intercept)"],
                var.a = model[["VCV"]][, "Drone_ID"] / 2,
                # var.p = rowSums(model[["VCV"]])),
                var.p = model[["VCV"]][, "Drone_ID"] / 2 +
                  model[["VCV"]][, "units"]),
           QGparams,
           model = "Poisson.log",
           verbose = FALSE)
mean(params[["h2.obs"]])
sd(params[["h2.obs"]])
HPDinterval(as.mcmc(params[["h2.obs"]]))

#######################
# --- Age of First Flight  ---
#######################


priorP <- list(R = list(V = 1, nu = 1),
               G = list(G1 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1000)))


# Model
# Fixed Effects - Breeding Line, Drone Age, and colony
# Random Effects - Drone ID 
# Distribution Poisson
# Sex-based pedigree used
model <- MCMCglmm(first_flight_age ~ Phen_age + Line + Colony,
                  random = ~ Drone_ID,
                  family = "poisson",
                  prior = priorP,
                  ginverse = list(Drone_ID = Sinv),
                  data = Flight,
                  nitt = 100000,
                  burnin = 10000,
                  thin = 10,
                  pr = TRUE)


summary(model)

#Phenotypic Variance
mean(model[["VCV"]][ , "Drone_ID"])



params <-
  pmap_dfr(list(mu = model[["Sol"]][, "(Intercept)"],
                var.a = model[["VCV"]][, "Drone_ID"] / 2,
                # var.p = rowSums(model[["VCV"]])),
                var.p = model[["VCV"]][, "Drone_ID"] / 2 +
                  model[["VCV"]][, "units"]),
           QGparams,
           model = "Poisson.log",
           verbose = FALSE)
mean(params[["h2.obs"]])
sd(params[["h2.obs"]])
HPDinterval(as.mcmc(params[["h2.obs"]]))



